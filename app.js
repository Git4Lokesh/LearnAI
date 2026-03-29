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

dotenv.config();

const app = express();
const httpServer = http.createServer(app);
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});
const port = process.env.PORT || 3000;

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
app.use(session({
    secret: process.env.SESSION_SECRET || 'your-secret-key-here',
    resave: false,
    saveUninitialized: true,
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        maxAge: 1000 * 60 * 60 * 24
    }
}));

app.use(passport.initialize());
app.use(passport.session());

// Passport configuration
passport.use(new Strategy({
    usernameField: 'email',
    passwordField: 'password'
}, async function (email, password, done) {
    try {
        console.log("=== PASSPORT STRATEGY ===");
        console.log("Attempting auth for:", email);

        if (!email || !password) {
            console.log("❌ Missing email or password");
            return done(null, false, { message: 'Email and password required' });
        }

        const result = await db.query("SELECT * FROM users WHERE email = $1", [email]);
        console.log("Database query returned:", result.rowCount, "rows");

        if (result.rowCount === 0) {
            console.log("❌ No user found with email:", email);
            return done(null, false, { message: 'Invalid credentials' });
        }

        const user = result.rows[0];
        console.log("✅ User found - ID:", user.id);

        const isMatch = await bcrypt.compare(password, user.password);
        console.log("Password comparison result:", isMatch);

        if (isMatch) {
            console.log("✅ Password matches - authentication successful");
            return done(null, user);
        } else {
            console.log("❌ Password does not match");
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

// WebSocket connection handling
io.use((socket, next) => {
    // Authenticate socket connections
    // In production, use proper session/auth middleware
    next();
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.id);

    socket.on('join_room', async (data) => {
        try {
            const { roomId, userId } = data;

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
        const { roomId, userId } = data;
        socket.leave(`room_${roomId}`);

        const activeMembers = await getActiveMembers(db, parseInt(roomId));
        io.to(`room_${roomId}`).emit('members_updated', activeMembers);
    });

    socket.on('chat_message', async (data) => {
        try {
            const { roomId, userId, message } = data;

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

    socket.on('sync_flashcard', (data) => {
        // Broadcast flashcard navigation to room
        const { roomId, currentIndex } = data;
        socket.to(`room_${roomId}`).emit('flashcard_synced', { currentIndex });
    });

    socket.on('sync_quiz', (data) => {
        // Broadcast quiz question to room
        const { roomId, questionIndex } = data;
        socket.to(`room_${roomId}`).emit('quiz_synced', { questionIndex });
    });

    socket.on('annotation_typing', (data) => {
        // Real-time annotation typing
        const { roomId, roomContentId } = data;
        socket.to(`room_${roomId}`).emit('annotation_typing', data);
    });

    // Typing indicators
    socket.on('typing_start', (data) => {
        const { roomId, userId, userName } = data;
        socket.to(`room_${roomId}`).emit('user_typing', { userId, userName });
    });

    socket.on('typing_stop', (data) => {
        const { roomId, userId } = data;
        socket.to(`room_${roomId}`).emit('user_stopped_typing', { userId });
    });

    // Session synchronization
    socket.on('session_join', async (data) => {
        try {
            const { sessionId, userId } = data;
            await joinStudySession(db, parseInt(sessionId), parseInt(userId));
            socket.join(`session_${sessionId}`);
            io.to(`session_${sessionId}`).emit('participant_joined', { userId });
        } catch (error) {
            console.error('Error joining session:', error);
        }
    });

    socket.on('session_leave', (data) => {
        const { sessionId } = data;
        socket.leave(`session_${sessionId}`);
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

// Start the server
await ensureBktService(process.env.BKT_BASE_URL || 'http://127.0.0.1:8000');
httpServer.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
