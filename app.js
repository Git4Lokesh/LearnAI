import bodyParser from "body-parser";
import express from "express";
import { marked } from "marked";
import session from "express-session";
import dotenv from "dotenv";
import passport from 'passport';
import { Strategy } from 'passport-local';
import bcrypt from 'bcrypt';
import { Server as SocketIOServer } from 'socket.io';
import http from 'http';
import { createClient } from 'redis';
import { RedisStore } from 'connect-redis';
import db from './config/db.js';
import { ensureBktService } from './services/bktRunner.js';
import {
    isRoomMember, updateUserPresence, getActiveMembers,
    saveChatMessage, joinStudySession
} from './services/groupStudyService.js';

// Route imports
import authRoutes from './routes/auth.js';
import instituteRoutes from './routes/institute.js';
import contentRoutes from './routes/content.js';
import chatRoutes from './routes/chat.js';
import practiceRoutes from './routes/practice.js';
import diagnosticRoutes from './routes/diagnostic.js';
import knowledgeGraphRoutes from './routes/knowledgeGraph.js';
import setupGroupStudyRoutes from './routes/groupStudy.js';
import adminRoutes from './routes/admin.js';
import aiRoutes from './routes/ai.js';
import assignmentRoutes from './routes/assignments.js';

dotenv.config();

const app = express();
const httpServer = http.createServer(app);
const allowedOrigins = (process.env.APP_ORIGIN || '').split(',').map((origin) => origin.trim()).filter(Boolean);
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: allowedOrigins.length ? allowedOrigins : (process.env.NODE_ENV === 'production' ? false : '*'),
        methods: ["GET", "POST"],
        credentials: true
    }
});
const port = process.env.PORT || 3000;
const isProduction = process.env.NODE_ENV === 'production';

if (isProduction) {
    const required = ['SESSION_SECRET', 'DATABASE_URL', 'REDIS_URL', 'APP_ORIGIN'];
    const missing = required.filter((name) => !process.env[name]);
    if (missing.length) throw new Error(`Missing required production configuration: ${missing.join(', ')}`);
    if (process.env.SESSION_SECRET.length < 32) throw new Error('SESSION_SECRET must be at least 32 characters in production');
}

marked.setOptions({
    breaks: true,
    gfm: true,
    sanitize: true
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static("public"));
app.set('view engine', 'ejs');
app.set('views', './views');

app.set('trust proxy', 1);
let redisClient;
if (process.env.REDIS_URL) {
    redisClient = createClient({ url: process.env.REDIS_URL });
    redisClient.on('error', (error) => console.error('Redis session store error:', error.message));
    await redisClient.connect();
}

const sessionMiddleware = session({
    store: redisClient ? new RedisStore({ client: redisClient }) : undefined,
    secret: process.env.SESSION_SECRET || 'development-only-secret-change-me',
    resave: false,
    saveUninitialized: false,
    name: 'learnai.sid',
    cookie: {
        httpOnly: true,
        sameSite: 'lax',
        secure: isProduction,
        maxAge: 1000 * 60 * 60 * 24
    }
});
app.use(sessionMiddleware);

app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'SAMEORIGIN');
    res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
    res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
    next();
});

app.get('/health', (req, res) => res.status(200).json({ status: 'ok' }));
app.get('/health/ready', async (req, res) => {
    try {
        await db.query('SELECT 1');
        if (redisClient && !redisClient.isReady) throw new Error('Redis unavailable');
        res.status(200).json({ status: 'ready' });
    } catch {
        res.status(503).json({ status: 'not_ready' });
    }
});

app.use(passport.initialize());
app.use(passport.session());

// Passport configuration
passport.use(new Strategy({
    usernameField: 'email',
    passwordField: 'password'
}, async function (email, password, done) {
    try {
        if (!email || !password) {
            return done(null, false, { message: 'Email and password required' });
        }

        const result = await db.query("SELECT * FROM users WHERE email = $1", [email]);

        if (result.rowCount === 0) {
            return done(null, false, { message: 'Invalid credentials' });
        }

        const user = result.rows[0];

        const isMatch = await bcrypt.compare(password, user.password);

        if (isMatch) {
            return done(null, user);
        } else {
            return done(null, false, { message: 'Invalid credentials' });
        }

    } catch (error) {
        console.error("❌ Strategy error:", error);
        return done(error);
    }
}));

passport.serializeUser((user, cb) => {
    const { password, ...userWithoutPassword } = user;
    cb(null, userWithoutPassword);
});

passport.deserializeUser((user, cb) => {
    cb(null, user);
});

// Handle favicon requests to prevent 404 errors
app.get("/favicon.ico", (req, res) => {
    res.status(204).end();
});

// Mount route modules
app.use(authRoutes);
app.use(instituteRoutes);
app.use(contentRoutes);
app.use(chatRoutes);
app.use(practiceRoutes);
app.use(diagnosticRoutes);
app.use(knowledgeGraphRoutes);
app.use(setupGroupStudyRoutes(io));
app.use(adminRoutes);
app.use(aiRoutes);
app.use(assignmentRoutes);

// WebSocket connection handling
io.use((socket, next) => {
    sessionMiddleware(socket.request, socket.request.res, (error) => {
        if (error) return next(error);
        passport.initialize()(socket.request, socket.request.res, (initializeError) => {
            if (initializeError) return next(initializeError);
            passport.session()(socket.request, socket.request.res, (sessionError) => {
                if (sessionError) return next(sessionError);
                if (!socket.request.user) return next(new Error('Authentication required'));
                socket.data.userId = Number(socket.request.user.id);
                next();
            });
        });
    });
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.id);

    socket.on('join_room', async (data) => {
        try {
            const { roomId } = data || {};
            const userId = socket.data.userId;

            // Verify user is member
            const isMember = await isRoomMember(db, parseInt(roomId), parseInt(userId));
            if (!isMember) {
                socket.emit('error', { message: 'Not a member of this room' });
                return;
            }

            socket.join(`room_${roomId}`);
            await updateUserPresence(db, parseInt(roomId), parseInt(userId));

            // Notify others
            const activeMembers = await getActiveMembers(db, parseInt(roomId));
            io.to(`room_${roomId}`).emit('members_updated', activeMembers);

            socket.emit('joined_room', { roomId });
        } catch (error) {
            console.error('Error joining room via socket:', error);
            socket.emit('error', { message: 'Error joining room' });
        }
    });

    socket.on('leave_room', async (data) => {
        const { roomId } = data || {};
        const userId = socket.data.userId;
        socket.leave(`room_${roomId}`);

        if (await isRoomMember(db, parseInt(roomId), userId)) {
            const activeMembers = await getActiveMembers(db, parseInt(roomId));
            io.to(`room_${roomId}`).emit('members_updated', activeMembers);
        }
    });

    socket.on('chat_message', async (data) => {
        try {
            const { roomId, message } = data || {};
            const userId = socket.data.userId;
            if (typeof message !== 'string' || !message.trim() || message.length > 4000) {
                socket.emit('error', { message: 'Message must be between 1 and 4000 characters' });
                return;
            }

            // Verify user is member
            const isMember = await isRoomMember(db, parseInt(roomId), parseInt(userId));
            if (!isMember) {
                socket.emit('error', { message: 'Not a member of this room' });
                return;
            }

            // Save message
            const savedMessage = await saveChatMessage(db, parseInt(roomId), parseInt(userId), message);

            // Get user info
            const userResult = await db.query('SELECT name FROM users WHERE id = $1', [userId]);
            const messageWithUser = {
                ...savedMessage,
                user_name: userResult.rows[0]?.name || 'Unknown'
            };

            // Broadcast to room
            io.to(`room_${roomId}`).emit('chat_message', messageWithUser);
        } catch (error) {
            console.error('Error handling chat message:', error);
            socket.emit('error', { message: 'Error sending message' });
        }
    });

    socket.on('sync_flashcard', async (data) => {
        const { roomId, currentIndex } = data || {};
        try {
            const index = Number(currentIndex);
            if (Number.isInteger(index) && index >= 0 && await isRoomMember(db, Number(roomId), socket.data.userId)) {
                socket.to(`room_${roomId}`).emit('flashcard_synced', { currentIndex: index });
            }
        } catch (error) { console.error('Flashcard sync authorization failed:', error.message); }
    });

    socket.on('sync_quiz', async (data) => {
        // Broadcast quiz question to room
        const { roomId, questionIndex } = data || {};
        try {
            const index = Number(questionIndex);
            if (await isRoomMember(db, Number(roomId), socket.data.userId) && Number.isInteger(index) && index >= 0) {
                socket.to(`room_${roomId}`).emit('quiz_synced', { questionIndex: index });
            }
        } catch (error) { console.error('Quiz sync authorization failed:', error.message); }
    });

    socket.on('annotation_typing', async (data) => {
        // Real-time annotation typing
        const { roomId, roomContentId } = data || {};
        try {
            if (await isRoomMember(db, Number(roomId), socket.data.userId)) {
                socket.to(`room_${roomId}`).emit('annotation_typing', { roomId, roomContentId, userId: socket.data.userId });
            }
        } catch (error) { console.error('Annotation authorization failed:', error.message); }
    });

    // Typing indicators
    socket.on('typing_start', async (data) => {
        const { roomId } = data || {};
        try {
            if (await isRoomMember(db, Number(roomId), socket.data.userId)) {
                socket.to(`room_${roomId}`).emit('user_typing', { userId: socket.data.userId, userName: socket.request.user.name });
            }
        } catch (error) { console.error('Typing authorization failed:', error.message); }
    });

    socket.on('typing_stop', async (data) => {
        const { roomId } = data || {};
        try {
            if (await isRoomMember(db, Number(roomId), socket.data.userId)) {
                socket.to(`room_${roomId}`).emit('user_stopped_typing', { userId: socket.data.userId });
            }
        } catch (error) { console.error('Typing authorization failed:', error.message); }
    });

    // Session synchronization
    socket.on('session_join', async (data) => {
        try {
            const { sessionId } = data || {};
            const userId = socket.data.userId;
            const sessionRoom = await db.query('SELECT room_id FROM study_sessions WHERE id = $1', [parseInt(sessionId)]);
            if (!sessionRoom.rows[0] || !await isRoomMember(db, sessionRoom.rows[0].room_id, userId)) {
                socket.emit('error', { message: 'Not authorized to join this session' });
                return;
            }
            await joinStudySession(db, parseInt(sessionId), userId);
            socket.join(`session_${sessionId}`);
            io.to(`session_${sessionId}`).emit('participant_joined', { userId });
        } catch (error) {
            console.error('Error joining session:', error);
        }
    });

    socket.on('session_leave', (data) => {
        const { sessionId } = data || {};
        socket.leave(`session_${sessionId}`);
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

// Start the server
await ensureBktService(process.env.BKT_BASE_URL || 'http://127.0.0.1:8000');
httpServer.listen(port, '0.0.0.0', () => {
    console.log(`Server running on port ${port}`);
});

async function shutdown(signal) {
    console.log(`${signal} received; shutting down`);
    httpServer.close(async () => {
        await db.end();
        if (redisClient) await redisClient.quit();
        process.exit(0);
    });
    setTimeout(() => process.exit(1), 10000).unref();
}
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
