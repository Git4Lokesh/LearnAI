import axios from "axios";
import { GoogleGenerativeAI } from '@google/generative-ai';
import bodyParser from "body-parser";
import express from "express";
import { marked } from "marked";
import session from "express-session";
import dotenv from "dotenv";
import multer from 'multer';
import FormData from 'form-data';
import pg from 'pg';
import bcrypt from 'bcrypt';
import passport from 'passport';
import { Strategy } from 'passport-local';
import rateLimit from 'express-rate-limit';
import { bktUpdate, bktNext, bktUpdateConcept, bktNextConcept, bktFit, bktFitDry, bktGetParams, bktGetAllParams, bktReloadParams } from './services/bktClient.js';
import { checkPrerequisiteGaps, getOptimalLearningPath } from './services/prerequisiteService.js';
import { extractTextFromPDF } from './services/pdfService.js';
import { parseUploadedFile } from './services/fileParser.js';
import { classifyQuestionConcept } from './services/conceptTagger.js';
import { ensureBktService } from './services/bktRunner.js';
import { compileReportData, generateReportPDF, sanitizeFilename } from './services/reportCardService.js';
import { YoutubeTranscript } from "@danielxceron/youtube-transcript";
import { Server as SocketIOServer } from 'socket.io';
import http from 'http';
import {
    createRoom, getRoomByCode, getRoomWithMembers, joinRoom, isRoomMember,
    getUserRoomRole, shareContentToRoom, getRoomContent, getUserRooms,
    createStudySession, getRoomSessions, joinStudySession,
    updateGroupProgress, getGroupProgressStats, getQuizLeaderboard, addQuizResult,
    updateUserPresence, getActiveMembers, getRoomChatMessages, saveChatMessage,
    leaveRoom, deleteRoom, getActiveSession, startSession, endSession,
    updateSessionPosition, addAnnotation, getAnnotations, getUserAnalytics,
    getRoomAnalytics, getStudyStreaks, inviteUserToRoom, removeUserFromRoom,
    promoteUser, getSessionParticipants, saveSessionNotes, getSessionNotes,
    getSessionSummary, getUpcomingSessions
} from './services/groupStudyService.js';
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
const saltRounds = 12;


const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function geminiGenerate(systemPrompt, userPrompt, model = 'gemini-2.5-flash') {
    const m = genAI.getGenerativeModel({ model, systemInstruction: systemPrompt });
    const result = await m.generateContent(userPrompt);
    return result.response.text();
}

const db = new pg.Client({
    host: 'localhost',
    port: 5432,
    user: 'postgres',
    password: process.env.db_password,
    database: 'Content Storage',
});


await db.connect();

async function getUserConceptMastery(userId, conceptId) {
    const r = await db.query(
        'SELECT mastery, questions_answered, correct_answers FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2',
        [userId, conceptId]
    );
    return r.rows[0] ?? { mastery: 0.2, questions_answered: 0, correct_answers: 0 };
}

// Enhanced question selection with spaced repetition and error analysis
async function getQuestionFromDB(conceptId, difficulty, excludeIds = [], userId = null, instituteId = null) {
    const tierMap = { very_hard: [3], hard: [3, 2], medium: [2], easy: [1, 2], very_easy: [1] };
    const tiers = tierMap[difficulty] || [2];

    // Prioritize questions user got wrong recently (spaced repetition)
    if (userId) {
        let paramIndex = 5;
        let instituteFilter = '';
        const params = [conceptId, tiers, userId, excludeIds.length ? excludeIds : [0]];
        if (instituteId) {
            instituteFilter = `AND (q.institute_id = $${paramIndex} OR q.institute_id IS NULL)`;
            params.push(instituteId);
        }
        const recentErrors = await db.query(`
            SELECT q.* FROM questions q
            JOIN user_question_attempts uqa ON q.id = uqa.question_id
            WHERE q.concept_id=$1 AND q.difficulty_tier=ANY($2) AND q.status='approved'
            AND uqa.user_id=$3 AND uqa.correct=false AND uqa.attempted_at > NOW() - INTERVAL '7 days'
            AND q.id != ALL($4)
            ${instituteFilter}
            ORDER BY uqa.attempted_at DESC LIMIT 1
        `, params);

        if (recentErrors.rows[0]) return recentErrors.rows[0];
    }

    // Fallback to random selection
    let fallbackParamIndex = 4;
    let fallbackInstituteFilter = '';
    const fallbackParams = [conceptId, tiers, excludeIds.length ? excludeIds : [0]];
    if (instituteId) {
        fallbackInstituteFilter = `AND (institute_id = $${fallbackParamIndex} OR institute_id IS NULL)`;
        fallbackParams.push(instituteId);
    }
    const r = await db.query(
        `SELECT * FROM questions WHERE concept_id=$1 AND difficulty_tier=ANY($2) AND status='approved'
         AND id != ALL($3) ${fallbackInstituteFilter} ORDER BY RANDOM() LIMIT 1`,
        fallbackParams
    );
    return r.rows[0] || null;
}

// Pick tier based on mastery for adaptive question selection
function masteryToTier(mastery) {
    if (mastery < 0.4) return 1;
    if (mastery < 0.7) return 2;
    return 3;
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

const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024
    },
    fileFilter: (req, file, cb) => {
        if (file.mimetype === 'application/pdf') {
            cb(null, true);
        } else {
            cb(new Error('Only PDF files are allowed'), false);
        }
    }
});

// Multer instance for question CSV/XLSX uploads (10MB limit)
const questionUpload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024 // 10MB
    },
    fileFilter: (req, file, cb) => {
        const ext = file.originalname.toLowerCase().split('.').pop();
        if (['csv', 'xlsx'].includes(ext)) {
            cb(null, true);
        } else {
            cb(new Error('Only CSV and XLSX files are accepted'), false);
        }
    }
});

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

function processMathContent(content) {
    let processedContent = content;

    processedContent = processedContent.replace(/\$\$(.*?)\$\$/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });

    processedContent = processedContent.replace(/\\\\(.*?)\\\\/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\/\/(.*?)\/\//g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });

    processedContent = processedContent.replace(/\\\((.*?)\\\)/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\\\[(.*?)\\\]/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });

    return processedContent;
}

// Generate a single MCQ based on topic/level/difficulty
async function generateSingleQuestion(topic, level, difficulty, contextText) {
    const system = {
        role: "system",
        content: "You are an expert educational assessment creator. Generate ONE multiple choice question in strict JSON. Return ONLY JSON with keys: question, option1, option2, option3, option4, answer (answer is one of 'option1'..'option4'). Adjust difficulty appropriately. Use $$...$$ for any math."
    };
    const user = {
        role: "user",
        content: `Create ONE ${difficulty || 'medium'} difficulty multiple choice question for ${level} level.

${topic ? `Topic: ${topic}` : ''}
${contextText ? `
CONTEXT (use only this content for the question):
${contextText.substring(0, 6000)}
` : ''}

Requirements:
- Return only JSON object, no text outside JSON
- Keys: question, option1, option2, option3, option4, answer
- Options must be plausible, exactly one correct
- Use clear, grade-appropriate language
- If mathematical, use $$...$$ notation`
    };
    const content = await geminiGenerate(system.content, user.content, 'gemini-2.5-pro');
    let parsed;
    try {
        parsed = JSON.parse(content);
    } catch (e) {
        const start = content.indexOf('{');
        const end = content.lastIndexOf('}');
        if (start !== -1 && end !== -1 && end > start) {
            parsed = JSON.parse(content.slice(start, end + 1));
        } else {
            throw new Error('Model did not return valid JSON');
        }
    }
    // If array returned, use first element
    let obj = Array.isArray(parsed) ? parsed[0] : parsed;
    if (!obj || typeof obj !== 'object') throw new Error('Invalid question object');
    // Normalize keys case-insensitively
    const lower = {};
    for (const [k, v] of Object.entries(obj)) lower[k.toLowerCase()] = v;
    // Map common variants
    if (!lower.question && lower.prompt) lower.question = lower.prompt;
    if (!lower.answer && lower.correct) lower.answer = lower.correct;
    if (!lower.answer && lower.correctoption) lower.answer = lower.correctoption;
    if (!lower.option1 && Array.isArray(lower.options) && lower.options.length >= 4) {
        lower.option1 = lower.options[0];
        lower.option2 = lower.options[1];
        lower.option3 = lower.options[2];
        lower.option4 = lower.options[3];
        if (typeof lower.correctindex === 'number') {
            lower.answer = `option${(lower.correctindex + 1)}`;
        }
    }
    // Ensure we have core fields
    const normalized = {
        question: String(lower.question || '').trim(),
        option1: String(lower.option1 || '').trim(),
        option2: String(lower.option2 || '').trim(),
        option3: String(lower.option3 || '').trim(),
        option4: String(lower.option4 || '').trim(),
        answer: String(lower.answer || '').trim()
    };
    // If answer provided as text, map to matching option
    if (!/^option[1-4]$/.test(normalized.answer)) {
        const ansText = normalized.answer.toLowerCase();
        const matchIndex = [1, 2, 3, 4].find(i => normalized[`option${i}`].toLowerCase() === ansText);
        if (matchIndex) normalized.answer = `option${matchIndex}`;
    }
    // Final sanity
    if (!normalized.question || !normalized.option1 || !normalized.option2 || !normalized.option3 || !normalized.option4) {
        throw new Error('Incomplete question fields');
    }
    if (!/^option[1-4]$/.test(normalized.answer)) {
        // default to option1 if model failed
        normalized.answer = 'option1';
    }
    return normalized;
}

// Authentication middleware
function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect('/login');
}

// Allows institute_admin (with institute) and platform admin
function ensureInstituteAdmin(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.role === 'institute_admin' && req.user.institute_id) return next();
    }
    res.status(403).send('Forbidden');
}

// Allows teacher and institute_admin (with institute) and platform admin
function ensureInstituteUser(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (['teacher', 'institute_admin'].includes(req.user.role) && req.user.institute_id) return next();
    }
    res.status(403).send('Forbidden');
}


// Routes

// Handle favicon requests to prevent 404 errors
app.get("/favicon.ico", (req, res) => {
    res.status(204).end();
});

app.get("/", ensureAuthenticated, async (req, res) => {
    // Redirect institute roles to their appropriate dashboards
    if (req.user.role === 'institute_admin' && req.user.institute_id) {
        return res.redirect("/institute/dashboard");
    }
    if (req.user.role === 'teacher' && req.user.institute_id) {
        return res.redirect("/institute/dashboard/teacher");
    }
    try {
        const [conceptsRes, prereqsRes, masteryRes, chaptersRes, chapterPrereqsRes] = await Promise.all([
            db.query('SELECT id, name, subject, chapter_id FROM concepts ORDER BY subject, name'),
            db.query('SELECT concept_id, prereq_id FROM concept_prerequisites'),
            db.query('SELECT concept_id, mastery, questions_answered, correct_answers FROM user_concept_mastery WHERE user_id=$1', [req.user.id]),
            db.query('SELECT id, name, subject FROM chapters ORDER BY display_order'),
            db.query('SELECT chapter_id, prereq_id FROM chapter_prerequisites')
        ]);
        res.render('dashboard.ejs', {
            user: req.user,
            graphData: {
                userId: req.user.id,
                concepts: conceptsRes.rows,
                prereqs: prereqsRes.rows,
                mastery: masteryRes.rows,
                chapters: chaptersRes.rows,
                chapterPrereqs: chapterPrereqsRes.rows
            }
        });
    } catch (error) {
        console.error('Graph load error:', error);
        res.render('dashboard.ejs', { user: req.user, graphData: { userId: req.user.id, concepts: [], prereqs: [], mastery: [], chapters: [], chapterPrereqs: [] } });
    }
});

app.get("/signup", (req, res) => {
    res.render("signup.ejs");
});

app.get("/login", (req, res) => {
    const error = req.query.error === 'invalid' ? 'Invalid email or password' : null;
    res.render("login.ejs", { error });
});

app.post("/signup", async (req, res) => {
    try {
        const name = req.body.fullName;
        const email = req.body.email;
        const password = req.body.password;

        const result = await db.query("SELECT * FROM users WHERE email=$1", [email]);
        if (result.rowCount > 0) {
            return res.send("Email already exists, try logging in");
        }

        const hash = await bcrypt.hash(password, saltRounds);
        const userresult = await db.query("INSERT INTO users (email,password,name) VALUES ($1,$2,$3) RETURNING *", [email, hash, name]);
        const user = userresult.rows[0];

        req.login(user, (err) => {
            if (err) {
                console.log(err);
                return res.status(500).send("Login failed");
            }
            res.redirect("/");
        });
    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).send("Registration failed");
    }
});

app.post("/login", (req, res, next) => {
    const selectedRole = req.body.role || 'student'; // from hidden field

    passport.authenticate("local", (err, user, info) => {
        if (err) {
            console.error("Authentication error:", err);
            return next(err);
        }

        if (!user) {
            return res.redirect("/login?error=invalid");
        }

        // Validate role matches what user selected
        const userRole = user.role || 'student';
        if (selectedRole === 'admin' && userRole !== 'institute_admin') {
            return res.redirect("/login?error=invalid");
        }
        if (selectedRole === 'teacher' && userRole !== 'teacher') {
            return res.redirect("/login?error=invalid");
        }
        if (selectedRole === 'student' && userRole !== 'student') {
            return res.redirect("/login?error=invalid");
        }

        req.logIn(user, (loginErr) => {
            if (loginErr) {
                console.error("Login error:", loginErr);
                return next(loginErr);
            }
            if (user.role === 'institute_admin' && user.institute_id) {
                return res.redirect("/institute/dashboard");
            }
            if (user.role === 'teacher' && user.institute_id) {
                return res.redirect("/institute/dashboard/teacher");
            }
            return res.redirect("/");
        });
    })(req, res, next);
});

app.post("/logout", (req, res) => {
    req.logout((err) => {
        if (err) {
            console.error('Logout error:', err);
            return res.status(500).send('Logout failed');
        }
        res.redirect("/login");
    });
});

// Institute registration (public — no auth middleware)
app.get("/institute/register", (req, res) => {
    const error = req.session.instituteRegError || null;
    delete req.session.instituteRegError;
    res.render("institute-register.ejs", { error });
});

app.post("/institute/register", async (req, res) => {
    try {
        const { instituteName, contactEmail, adminName, adminEmail, adminPassword } = req.body;

        // Generate slug from institute name
        const slug = instituteName
            .toLowerCase()
            .trim()
            .replace(/[^a-z0-9\s-]/g, '')
            .replace(/[\s]+/g, '-')
            .replace(/-+/g, '-')
            .replace(/^-|-$/g, '');

        // Check slug uniqueness
        const slugCheck = await db.query("SELECT id FROM institutes WHERE slug = $1", [slug]);
        if (slugCheck.rowCount > 0) {
            req.session.instituteRegError = "An institute with a similar name already exists. Please choose a different name.";
            return res.redirect("/institute/register");
        }

        // Check admin email uniqueness
        const emailCheck = await db.query("SELECT id FROM users WHERE email = $1", [adminEmail]);
        if (emailCheck.rowCount > 0) {
            req.session.instituteRegError = "This admin email is already registered. Please use a different email or sign in.";
            return res.redirect("/institute/register");
        }

        // Create institute
        const instituteResult = await db.query(
            "INSERT INTO institutes (name, slug, contact_email, subscription_status) VALUES ($1, $2, $3, 'trial') RETURNING *",
            [instituteName, slug, contactEmail]
        );
        const institute = instituteResult.rows[0];

        // Create admin user
        const hash = await bcrypt.hash(adminPassword, saltRounds);
        const userResult = await db.query(
            "INSERT INTO users (name, email, password, role, institute_id) VALUES ($1, $2, $3, 'institute_admin', $4) RETURNING *",
            [adminName, adminEmail, hash, institute.id]
        );
        const user = userResult.rows[0];

        // Log the user in and redirect to institute dashboard
        req.login(user, (err) => {
            if (err) {
                console.error('Institute registration login error:', err);
                return res.redirect("/login");
            }
            res.redirect("/institute/dashboard");
        });
    } catch (error) {
        console.error('Institute registration error:', error);
        req.session.instituteRegError = "Registration failed. Please try again.";
        res.redirect("/institute/register");
    }
});

// Institute dashboard (admin only)
app.get("/institute/dashboard", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;

        const instituteResult = await db.query(
            "SELECT name, subscription_status FROM institutes WHERE id = $1",
            [instituteId]
        );
        const institute = instituteResult.rows[0];

        const teacherCount = await db.query(
            "SELECT COUNT(*) FROM users WHERE institute_id = $1 AND role = 'teacher'",
            [instituteId]
        );
        const studentCount = await db.query(
            "SELECT COUNT(*) FROM users WHERE institute_id = $1 AND role = 'student'",
            [instituteId]
        );
        const questionCount = await db.query(
            "SELECT COUNT(*) FROM questions WHERE institute_id = $1 AND status = 'approved'",
            [instituteId]
        );

        res.render("institute-dashboard.ejs", {
            user: req.user,
            instituteName: institute.name,
            subscriptionStatus: institute.subscription_status,
            teacherCount: parseInt(teacherCount.rows[0].count),
            studentCount: parseInt(studentCount.rows[0].count),
            approvedQuestionCount: parseInt(questionCount.rows[0].count)
        });
    } catch (error) {
        console.error('Institute dashboard error:', error);
        res.status(500).send("Failed to load dashboard");
    }
});

// Institute invite (admin only)
app.get("/institute/invite", ensureAuthenticated, ensureInstituteAdmin, (req, res) => {
    const success = req.session.inviteSuccess || null;
    const error = req.session.inviteError || null;
    delete req.session.inviteSuccess;
    delete req.session.inviteError;
    res.render("institute-invite.ejs", { user: req.user, success, error });
});

app.post("/institute/invite", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const { name, email, password, role } = req.body;
        const instituteId = req.user.institute_id;

        // Validate role
        if (!['teacher', 'student'].includes(role)) {
            req.session.inviteError = "Invalid role selected.";
            return res.redirect("/institute/invite");
        }

        // Check if email already exists
        const existingUser = await db.query("SELECT id, institute_id FROM users WHERE email = $1", [email]);

        if (existingUser.rowCount > 0) {
            const existing = existingUser.rows[0];
            if (existing.institute_id && existing.institute_id !== instituteId) {
                req.session.inviteError = "This email is already associated with a different institute.";
                return res.redirect("/institute/invite");
            }
            if (existing.institute_id === instituteId) {
                req.session.inviteError = "This email is already a member of your institute.";
                return res.redirect("/institute/invite");
            }
        }

        // Create user with hashed password
        const hash = await bcrypt.hash(password, saltRounds);
        await db.query(
            "INSERT INTO users (name, email, password, role, institute_id) VALUES ($1, $2, $3, $4, $5)",
            [name, email, hash, role, instituteId]
        );

        req.session.inviteSuccess = `Successfully invited ${email} as ${role}.`;
        res.redirect("/institute/invite");
    } catch (error) {
        console.error('Institute invite error:', error);
        req.session.inviteError = "Failed to create invitation. Please try again.";
        res.redirect("/institute/invite");
    }
});

// Institute batches management (admin only)
app.get("/institute/batches", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;

        // Get all batches for this institute
        const batchesResult = await db.query(
            "SELECT * FROM batches WHERE institute_id = $1 ORDER BY created_at DESC",
            [instituteId]
        );
        const batches = batchesResult.rows;

        // For each batch, get its students
        for (const batch of batches) {
            const studentsResult = await db.query(
                `SELECT u.id, u.name, u.email FROM batch_students bs
                 JOIN users u ON u.id = bs.user_id
                 WHERE bs.batch_id = $1 ORDER BY u.name`,
                [batch.id]
            );
            batch.students = studentsResult.rows;
        }

        // Get all students in the institute who are NOT in any batch
        const unassignedResult = await db.query(
            `SELECT u.id, u.name, u.email FROM users u
             WHERE u.institute_id = $1 AND u.role = 'student'
             AND u.id NOT IN (SELECT user_id FROM batch_students)
             ORDER BY u.name`,
            [instituteId]
        );
        const unassignedStudents = unassignedResult.rows;

        const success = req.session.batchSuccess || null;
        const error = req.session.batchError || null;
        delete req.session.batchSuccess;
        delete req.session.batchError;

        res.render("institute-batches", { batches, unassignedStudents, success, error });
    } catch (err) {
        console.error("Batch list error:", err);
        res.status(500).send("Server error");
    }
});

app.post("/institute/batches", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;
        const { action } = req.body;

        if (action === 'create') {
            const { name } = req.body;
            if (!name || !name.trim()) {
                req.session.batchError = "Batch name is required.";
                return res.redirect("/institute/batches");
            }
            await db.query(
                "INSERT INTO batches (institute_id, name) VALUES ($1, $2)",
                [instituteId, name.trim()]
            );
            req.session.batchSuccess = `Batch "${name.trim()}" created successfully.`;
        } else if (action === 'assign') {
            const { batch_id } = req.body;
            let { student_ids } = req.body;

            if (!batch_id) {
                req.session.batchError = "Batch ID is required.";
                return res.redirect("/institute/batches");
            }

            // Ensure student_ids is an array
            if (!student_ids) student_ids = [];
            if (!Array.isArray(student_ids)) student_ids = [student_ids];

            // Validate batch belongs to this institute
            const batchResult = await db.query(
                "SELECT * FROM batches WHERE id = $1 AND institute_id = $2",
                [batch_id, instituteId]
            );
            if (batchResult.rowCount === 0) {
                req.session.batchError = "Invalid batch.";
                return res.redirect("/institute/batches");
            }

            // Validate each student belongs to this institute and insert
            let assignedCount = 0;
            for (const studentId of student_ids) {
                const studentResult = await db.query(
                    "SELECT id FROM users WHERE id = $1 AND institute_id = $2 AND role = 'student'",
                    [studentId, instituteId]
                );
                if (studentResult.rowCount > 0) {
                    await db.query(
                        "INSERT INTO batch_students (batch_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
                        [batch_id, studentId]
                    );
                    assignedCount++;
                }
            }
            req.session.batchSuccess = `${assignedCount} student(s) assigned to batch.`;
        } else {
            req.session.batchError = "Invalid action.";
        }

        res.redirect("/institute/batches");
    } catch (err) {
        console.error("Batch management error:", err);
        req.session.batchError = "An error occurred. Please try again.";
        res.redirect("/institute/batches");
    }
});

// Question bulk upload routes
app.get("/institute/questions/upload", ensureAuthenticated, ensureInstituteUser, (req, res) => {
    const error = req.session.uploadError || null;
    const success = req.session.uploadSuccess || null;
    const summary = req.session.uploadSummary || null;
    delete req.session.uploadError;
    delete req.session.uploadSuccess;
    delete req.session.uploadSummary;
    res.render("institute-upload", { error, success, summary });
});

app.post("/institute/questions/upload", ensureAuthenticated, ensureInstituteUser, (req, res, next) => {
    questionUpload.single('file')(req, res, (err) => {
        if (err) {
            if (err.code === 'LIMIT_FILE_SIZE') {
                req.session.uploadError = "File exceeds 10MB limit.";
            } else {
                req.session.uploadError = err.message || "File upload failed.";
            }
            return res.redirect("/institute/questions/upload");
        }
        next();
    });
}, async (req, res) => {
    try {
        if (!req.file) {
            req.session.uploadError = "Please select a file to upload.";
            return res.redirect("/institute/questions/upload");
        }

        const filename = req.file.originalname;
        const ext = filename.toLowerCase().split('.').pop();
        if (!['csv', 'xlsx'].includes(ext)) {
            req.session.uploadError = "Only CSV and XLSX files are accepted.";
            return res.redirect("/institute/questions/upload");
        }

        // Parse the file
        let rows;
        try {
            rows = parseUploadedFile(req.file.buffer, filename);
        } catch (parseErr) {
            console.error('File parse error:', parseErr);
            req.session.uploadError = "Could not parse file. Ensure it is a valid CSV or Excel file.";
            return res.redirect("/institute/questions/upload");
        }

        if (!rows || rows.length === 0) {
            req.session.uploadError = "The uploaded file contains no data rows.";
            return res.redirect("/institute/questions/upload");
        }

        const instituteId = req.user.institute_id;
        const uploadedBy = req.user.id;
        const totalRows = rows.length;
        const requiredFields = ['question_text', 'option1', 'option2', 'option3', 'option4', 'correct_answer'];
        const validCorrectAnswers = ['option1', 'option2', 'option3', 'option4'];

        // Create upload_jobs record
        const jobResult = await db.query(
            `INSERT INTO upload_jobs (institute_id, uploaded_by, filename, total_rows, status)
             VALUES ($1, $2, $3, $4, 'processing') RETURNING id`,
            [instituteId, uploadedBy, filename, totalRows]
        );
        const jobId = jobResult.rows[0].id;

        // Fetch concept list for AI tagging
        const conceptsResult = await db.query('SELECT id, name FROM concepts ORDER BY id');
        const conceptList = conceptsResult.rows;

        let processedRows = 0;
        let failedRows = 0;
        const errorLog = [];

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const rowNum = i + 2; // +2 because row 1 is the header, data starts at row 2
            const rowErrors = [];

            // Validate required fields
            for (const field of requiredFields) {
                if (!row[field] || String(row[field]).trim() === '') {
                    rowErrors.push(`Missing required field: ${field}`);
                }
            }

            // Validate correct_answer format
            if (row.correct_answer && !validCorrectAnswers.includes(String(row.correct_answer).trim().toLowerCase())) {
                rowErrors.push(`correct_answer must be one of: option1, option2, option3, option4`);
            }

            if (rowErrors.length > 0) {
                failedRows++;
                errorLog.push({ row: rowNum, errors: rowErrors });
                continue;
            }

            // Insert valid row into questions
            try {
                const difficultyTier = row.difficulty_tier ? parseInt(row.difficulty_tier, 10) : 2;
                const questionText = String(row.question_text).trim();
                const insertResult = await db.query(
                    `INSERT INTO questions (question_text, option1, option2, option3, option4, correct_answer, solution, difficulty_tier, status, institute_id, concept_id)
                     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'pending', $9, NULL) RETURNING id`,
                    [
                        questionText,
                        String(row.option1).trim(),
                        String(row.option2).trim(),
                        String(row.option3).trim(),
                        String(row.option4).trim(),
                        String(row.correct_answer).trim().toLowerCase(),
                        row.solution ? String(row.solution).trim() : null,
                        isNaN(difficultyTier) ? 2 : difficultyTier,
                        instituteId
                    ]
                );
                const questionId = insertResult.rows[0].id;
                processedRows++;

                // AI concept auto-tagging
                try {
                    const topicHint = row.topic_hint || null;
                    const aiResult = await classifyQuestionConcept(questionText, topicHint, conceptList, geminiGenerate);
                    if (aiResult.confidence >= 0.6) {
                        await db.query(
                            `UPDATE questions SET concept_id = $1, concept_confidence = $2, needs_review_tag = false WHERE id = $3`,
                            [aiResult.concept_id, aiResult.confidence, questionId]
                        );
                    } else {
                        await db.query(
                            `UPDATE questions SET concept_id = $1, concept_confidence = $2, needs_review_tag = true WHERE id = $3`,
                            [aiResult.concept_id, aiResult.confidence, questionId]
                        );
                    }
                } catch (aiErr) {
                    console.error(`Row ${rowNum} AI tagging error:`, aiErr.message);
                    errorLog.push({ row: rowNum, errors: [`AI tagging failed: ${aiErr.message}`] });
                }

                // Update processed_rows after each row
                await db.query(
                    `UPDATE upload_jobs SET processed_rows = $1 WHERE id = $2`,
                    [processedRows, jobId]
                );
            } catch (insertErr) {
                console.error(`Row ${rowNum} insert error:`, insertErr.message);
                failedRows++;
                errorLog.push({ row: rowNum, errors: [`Database insert failed: ${insertErr.message}`] });
            }
        }

        // Update upload_jobs with final counts
        await db.query(
            `UPDATE upload_jobs SET processed_rows = $1, failed_rows = $2, status = 'completed', error_log = $3, completed_at = NOW() WHERE id = $4`,
            [processedRows, failedRows, JSON.stringify(errorLog), jobId]
        );

        // Store summary in session for display
        req.session.uploadSummary = {
            filename,
            totalRows,
            processedRows,
            failedRows,
            errors: errorLog
        };
        req.session.uploadSuccess = `Upload complete: ${processedRows} questions imported, ${failedRows} rows failed.`;
        res.redirect("/institute/questions/upload");
    } catch (err) {
        console.error('Question upload error:', err);
        req.session.uploadError = "An unexpected error occurred during upload. Please try again.";
        res.redirect("/institute/questions/upload");
    }
});

// ==================== Question Review Queue ====================

// GET /institute/questions/review — display pending questions for review
app.get("/institute/questions/review", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;

        // Query pending questions with concept name
        const pendingResult = await db.query(
            `SELECT q.*, c.name as concept_name
             FROM questions q
             LEFT JOIN concepts c ON c.id = q.concept_id
             WHERE q.institute_id = $1 AND q.status = 'pending'
             ORDER BY q.created_at ASC`,
            [instituteId]
        );

        // Query review stats
        const statsResult = await db.query(
            `SELECT status, COUNT(*)::int as count FROM questions WHERE institute_id = $1 GROUP BY status`,
            [instituteId]
        );
        const stats = { pending: 0, approved: 0, rejected: 0 };
        statsResult.rows.forEach(row => {
            if (stats.hasOwnProperty(row.status)) {
                stats[row.status] = row.count;
            }
        });

        // Query full concept list for edit dropdown
        const conceptsResult = await db.query(`SELECT id, name FROM concepts ORDER BY name`);

        // Flash messages
        const reviewSuccess = req.session.reviewSuccess || null;
        const reviewError = req.session.reviewError || null;
        delete req.session.reviewSuccess;
        delete req.session.reviewError;

        res.render("institute-review", {
            questions: pendingResult.rows,
            stats,
            concepts: conceptsResult.rows,
            success: reviewSuccess,
            error: reviewError
        });
    } catch (err) {
        console.error('Review queue error:', err);
        res.status(500).send('Error loading review queue');
    }
});

// POST /institute/questions/review/:id — approve, reject, or edit-then-approve
app.post("/institute/questions/review/:id", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const questionId = req.params.id;
        const instituteId = req.user.institute_id;
        const { action, concept_id, difficulty_tier, question_text } = req.body;

        // Validate question belongs to user's institute
        const questionResult = await db.query(
            `SELECT id, status FROM questions WHERE id = $1 AND institute_id = $2`,
            [questionId, instituteId]
        );

        if (questionResult.rows.length === 0) {
            req.session.reviewError = "Question not found or does not belong to your institute.";
            return res.redirect("/institute/questions/review");
        }

        if (action === 'approve') {
            await db.query(
                `UPDATE questions SET status = 'approved' WHERE id = $1`,
                [questionId]
            );
            req.session.reviewSuccess = "Question approved successfully.";
        } else if (action === 'reject') {
            await db.query(
                `UPDATE questions SET status = 'rejected' WHERE id = $1`,
                [questionId]
            );
            req.session.reviewSuccess = "Question rejected.";
        } else if (action === 'edit') {
            // Edit fields then approve
            await db.query(
                `UPDATE questions SET concept_id = $1, difficulty_tier = $2, question_text = $3, status = 'approved' WHERE id = $4`,
                [concept_id || null, difficulty_tier || 2, question_text, questionId]
            );
            req.session.reviewSuccess = "Question edited and approved.";
        } else {
            req.session.reviewError = "Invalid review action.";
        }

        res.redirect("/institute/questions/review");
    } catch (err) {
        console.error('Review action error:', err);
        req.session.reviewError = "An error occurred while processing the review action.";
        res.redirect("/institute/questions/review");
    }
});

// ==================== Teacher Dashboard — Batch Mastery Heatmap ====================

app.get("/institute/dashboard/teacher", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;
        const selectedBatchId = req.query.batchId || null;
        const selectedSubject = req.query.subject || null;

        // Query all batches for this institute
        const batchesResult = await db.query(
            "SELECT id, name FROM batches WHERE institute_id = $1 ORDER BY name",
            [instituteId]
        );
        const batches = batchesResult.rows;

        // Get distinct subjects for the filter dropdown
        const subjectsResult = await db.query(
            "SELECT DISTINCT subject FROM concepts ORDER BY subject"
        );
        const subjects = subjectsResult.rows.map(r => r.subject);

        // Query stuck students for this institute (Req 8.1, 8.2, 8.3, 8.5)
        const stuckResult = await db.query(`
            SELECT u.id as user_id, u.name, c.id as concept_id, c.name as concept_name,
                   ucm.mastery, ucm.questions_answered, ucm.correct_answers
            FROM user_concept_mastery ucm
            JOIN users u ON u.id = ucm.user_id
            JOIN concepts c ON c.id = ucm.concept_id
            WHERE u.institute_id = $1
              AND ucm.mastery < 0.5
              AND ucm.questions_answered > 10
            ORDER BY ucm.mastery ASC
        `, [instituteId]);
        const stuckStudents = stuckResult.rows;

        // Query concept prerequisites for knowledge graph edges
        const prereqsResult = await db.query(
            "SELECT concept_id, prereq_id FROM concept_prerequisites"
        );
        const prereqs = prereqsResult.rows;

        let heatmapData = null;

        if (selectedBatchId) {
            // Build heatmap query with optional subject filter
            let heatmapQuery = `
                SELECT u.id as user_id, u.name as student_name,
                       c.id as concept_id, c.name as concept_name, c.subject,
                       COALESCE(ucm.mastery, 0.2) as mastery
                FROM batch_students bs
                JOIN users u ON u.id = bs.user_id
                CROSS JOIN concepts c
                LEFT JOIN user_concept_mastery ucm ON ucm.user_id = u.id AND ucm.concept_id = c.id
                WHERE bs.batch_id = $1
            `;
            const params = [selectedBatchId];

            if (selectedSubject) {
                heatmapQuery += " AND c.subject = $2";
                params.push(selectedSubject);
            }

            heatmapQuery += " ORDER BY u.name, c.subject, c.name";

            const heatmapResult = await db.query(heatmapQuery, params);

            // Transform flat rows into structured heatmap data
            const studentsMap = new Map();
            const conceptsMap = new Map();

            for (const row of heatmapResult.rows) {
                // Build concepts list (unique)
                if (!conceptsMap.has(row.concept_id)) {
                    conceptsMap.set(row.concept_id, {
                        id: row.concept_id,
                        name: row.concept_name,
                        subject: row.subject
                    });
                }

                // Build students with their masteries
                if (!studentsMap.has(row.user_id)) {
                    studentsMap.set(row.user_id, {
                        id: row.user_id,
                        name: row.student_name,
                        masteries: {}
                    });
                }
                studentsMap.get(row.user_id).masteries[row.concept_id] = parseFloat(row.mastery);
            }

            const students = Array.from(studentsMap.values());
            const concepts = Array.from(conceptsMap.values());

            // Compute batch-average mastery per concept
            const batchAverages = {};
            for (const concept of concepts) {
                let sum = 0;
                let count = 0;
                for (const student of students) {
                    const m = student.masteries[concept.id];
                    if (m !== undefined) {
                        sum += m;
                        count++;
                    }
                }
                batchAverages[concept.id] = count > 0 ? sum / count : 0.2;
            }

            heatmapData = { students, concepts, batchAverages };
        }

        res.render("institute-teacher-dashboard", {
            batches,
            heatmapData,
            selectedBatchId,
            selectedSubject,
            subjects,
            stuckStudents,
            prereqs
        });
    } catch (err) {
        console.error('Teacher dashboard error:', err);
        res.status(500).send("Error loading teacher dashboard.");
    }
});

// ==================== Teacher Dashboard — Prerequisite Gap Analysis ====================

app.get("/institute/dashboard/teacher/gaps/:userId/:conceptId", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;
        const userId = parseInt(req.params.userId);
        const conceptId = parseInt(req.params.conceptId);

        // Validate the target student belongs to the teacher's institute
        const studentResult = await db.query(
            "SELECT id, name FROM users WHERE id = $1 AND institute_id = $2",
            [userId, instituteId]
        );
        if (studentResult.rowCount === 0) {
            return res.status(403).send("Forbidden: Student not in your institute.");
        }
        const studentName = studentResult.rows[0].name;

        // Get concept name
        const conceptResult = await db.query(
            "SELECT name FROM concepts WHERE id = $1",
            [conceptId]
        );
        if (conceptResult.rowCount === 0) {
            return res.status(404).send("Concept not found.");
        }
        const conceptName = conceptResult.rows[0].name;

        // Get prerequisite gaps and optimal learning path
        const gaps = await checkPrerequisiteGaps(db, userId, conceptId);
        const learningPath = await getOptimalLearningPath(db, userId, conceptId);

        // Resolve concept names for the learning path
        let learningPathDetails = [];
        if (learningPath.length > 0) {
            const pathResult = await db.query(
                "SELECT id, name FROM concepts WHERE id = ANY($1)",
                [learningPath]
            );
            const conceptMap = {};
            for (const row of pathResult.rows) {
                conceptMap[row.id] = row.name;
            }
            learningPathDetails = learningPath.map(id => ({
                id,
                name: conceptMap[id] || `Concept ${id}`
            }));
        }

        res.render("institute-prereq-gaps", {
            studentName,
            conceptName,
            gaps,
            learningPath: learningPathDetails
        });
    } catch (err) {
        console.error('Prerequisite gap analysis error:', err);
        res.status(500).send("Error loading prerequisite gap analysis.");
    }
});

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

const generateLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 10, standardHeaders: true, legacyHeaders: false });
const chatLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 30, standardHeaders: true, legacyHeaders: false });
const expandLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 50, standardHeaders: true, legacyHeaders: false });

// Main generation route
app.post("/generate", generateLimiter, ensureAuthenticated, upload.single('document'), async (req, res) => {
    const topic = req.body.topic;
    const level = req.body.gradeLevel;
    const type = req.body.studyType;
    const method = req.body.inputMethod;
    const url = req.body.url;
    req.session.topic = topic;
    req.session.level = level;

    if (!level || !type) {
        return res.status(400).send("Please fill in all required fields");
    }

    if (method === "topic") {
        if (!topic) {
            return res.status(400).send("Please enter a topic");
        }

        if (type === "quicknotes") {
            try {
                const noteContent = await geminiGenerate(
                    "You are an expert educator. Create study materials in HTML format with proper tags. Start directly with the educational content. For ALL mathematical expressions, use proper notation enclosed in $$ (e.g., $$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$)",
                    `Write extremely thorough study notes on ${topic} for ${level} level students. The student should be able to revise this for exams.\n\nFormat Requirements:\n- Start with a clear definition\n- Use HTML tags: <h1>, <h2>, <h3> for headings\n- Use <strong> for bold, <em> for italic\n- Use <p> for paragraphs and <br> for line breaks\n- Use <ul><li> for bullet points\n- Add practical examples\n- If mathematical in nature, include example problems with solutions formatted in $$...$$ notation\n- ALL mathematical expressions MUST use proper notation enclosed in $$\n\nTopic: ${topic}\nLevel: ${level}`
                );
                req.session.content = noteContent;
                res.render("quicknotes.ejs", { topic, gradeLevel: level, content: noteContent });

            } catch (error) {
                console.error("Quick notes error:", error.message);
                res.status(500).send("Failed to generate notes. Please try again.");
            }
        }
        else if (type === "flashcards") {
            try {
                const fcRaw = await geminiGenerate(
                    "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\frac{1}{2}$$)",
                    `Generate 10 flashcards for ${topic} at ${level} school level. Format as JSON array: [{"question": "...", "answer": "..."}]. Return only valid JSON, no markdown fences.`
                );
                const fcClean = fcRaw.replace(/```json\n?|```/g, '').trim();
                const flashcards = JSON.parse(fcClean);

                req.session.flashcards = flashcards;
                req.session.topic = topic;
                req.session.gradeLevel = level;

                res.render("flashcards.ejs", {
                    topic: topic,
                    gradeLevel: level,
                    content: flashcards,
                    currentIndex: 0,
                    showAnswer: false
                });

            } catch (error) {
                console.error("Flashcards error:", error.message);
                res.status(500).send("Failed to generate flashcards. Please try again.");
            }
        }
        else {
            try {
                const quizRaw = await geminiGenerate(
                    "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text, explanations, or markdown fences. Each question must have exactly 4 distinct, plausible options with one clearly correct answer. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Create a 10-question multiple choice quiz about ${topic} for ${level} school students.\n\nRequirements:\n- Format: JSON array only, no other text, no markdown\n- Each question must have: question, option1, option2, option3, option4, answer\n- Answer field must specify which option is correct (e.g., "option2")\n- ALL mathematical expressions MUST use proper notation enclosed in $$\n\nTopic: ${topic}\nGrade Level: ${level}`,
                    'gemini-2.5-pro'
                );
                const content = JSON.parse(quizRaw.replace(/```json\n?|```/g, '').trim());
                req.session.topic = topic;
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    const progress = await getUserMastery(req.user.id, topic);
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(topic), p_mastery: parseFloat(progress.mastery_score) });
                } catch (e) {
                    console.warn('BKT next (generate) failed:', e.message || e);
                }
                res.render("quiz.ejs", {
                    topic: topic,
                    gradeLevel: level,
                    content: content,
                    showResults: false,
                    bktMastery: bktInfo?.mastery,
                    bktRecommendedDifficulty: bktInfo?.recommendedDifficulty
                });

            } catch (error) {
                console.error("Quiz error:", error.message);
                res.status(500).send("Failed to generate quiz. Please try again.");
            }
        }
    }
    else if (method === "pdf") {
        if (!req.file) {
            return res.status(400).send("Please upload a PDF file");
        }

        try {
            const extractedText = await extractTextFromPDF(req.file.buffer, req.file.originalname);

            if (type === "quicknotes") {
                const pdfNoteContent = await geminiGenerate(
                    "You are an expert educator specializing in analyzing comprehensive academic course materials. Transform content into well-organized study notes with HTML formatting. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Transform the following comprehensive course material into detailed study notes for ${level} level students:\n\nCOMPREHENSIVE COURSE MATERIAL:\n${extractedText}\n\nCreate study notes with these requirements:\n- Use HTML formatting: <h2>, <h3>, <p>, <ul>, <li>, <strong>\n- Preserve mathematical formulas in $$...$$ notation\n- Structure content logically for exam preparation`
                );
                res.render("quicknotes.ejs", { topic: "Course Material Analysis", gradeLevel: level, content: pdfNoteContent });
            }
            else if (type === "flashcards") {
                const pdfFcRaw = await geminiGenerate(
                    "You are an expert educator creating flashcards from course material. Return only a JSON array of objects with 'question' and 'answer' properties. No markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Create 10 high-quality flashcards for ${level} level students from this course material:\n\n${extractedText}\n\nReturn only a valid JSON array starting with '[' and ending with ']'.`
                );
                const flashcards = JSON.parse(pdfFcRaw.replace(/```json\n?|```/g, '').trim());

                req.session.flashcards = flashcards;
                req.session.topic = "Course Material";
                req.session.gradeLevel = level;

                res.render("flashcards.ejs", {
                    topic: "Course Material",
                    gradeLevel: level,
                    content: flashcards,
                    currentIndex: 0,
                    showAnswer: false
                });
            }
            else {
                const pdfQuizRaw = await geminiGenerate(
                    "You are an expert educational assessment creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text or markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Create a 10-question multiple choice quiz for ${level} students based on this course material:\n\n${extractedText}\n\nEach question must have: question, option1, option2, option3, option4, answer. Return only valid JSON array.`,
                    'gemini-2.5-pro'
                );
                const content = JSON.parse(pdfQuizRaw.replace(/```json\n?|```/g, '').trim());
                req.session.topic = "Course Material";
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    const progress = await getUserMastery(req.user.id, req.session.topic);
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(req.session.topic), p_mastery: parseFloat(progress.mastery_score) });
                } catch (e) {
                    console.warn('BKT next (generate-pdf) failed:', e.message || e);
                }
                res.render("quiz.ejs", {
                    topic: "Course Material",
                    gradeLevel: level,
                    content: content,
                    showResults: false,
                    bktMastery: bktInfo?.mastery,
                    bktRecommendedDifficulty: bktInfo?.recommendedDifficulty
                });
            }

        } catch (error) {
            console.error("PDF processing error:", error.message);
            if (error.response?.status === 429) return res.status(429).send("API rate limit reached. Please try again later.");
            if (error.response?.status === 401) return res.status(500).send("Authentication failed. Check your LLAMA_CLOUD_API_KEY.");
            return res.status(500).send("Failed to process PDF. Please try again.");
        }
    }
    else if (method === "url") {
        console.log(url);
        const transcript = await YoutubeTranscript.fetchTranscript(url, { lang: 'en' })
        console.log(transcript);
        let fullText = transcript.map(item => item.text).join(" ");
        if (type === "quicknotes") {
            try {
                const urlNoteContent = await geminiGenerate(
                    "You are an expert educator. Create study materials in HTML format with proper tags. Start directly with the educational content. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Write extremely thorough study notes from this YouTube video transcript for ${level} level students:\n\n${fullText}\n\nUse HTML tags: <h1>, <h2>, <h3>, <p>, <ul>, <li>, <strong>. ALL math in $$...$$ notation.`
                );
                req.session.content = urlNoteContent;
                res.render("quicknotes.ejs", { topic: "Youtube Video", gradeLevel: level, content: urlNoteContent });

            } catch (error) {
                console.error("Quick notes error:", error.message);
                res.status(500).send("Failed to generate notes. Please try again.");
            }
        }
        else if (type === "flashcards") {
            try {
                const urlFcRaw = await geminiGenerate(
                    "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. No markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Generate 10 flashcards from this YouTube transcript at ${level} school level. Format as JSON array: [{"question": "...", "answer": "..."}]. Return only valid JSON.\n\n${fullText}`
                );
                const flashcards = JSON.parse(urlFcRaw.replace(/```json\n?|```/g, '').trim());

                req.session.flashcards = flashcards;
                req.session.topic = url;
                req.session.gradeLevel = level;

                res.render("flashcards.ejs", {
                    topic: "Youtube Video",
                    gradeLevel: level,
                    content: flashcards,
                    currentIndex: 0,
                    showAnswer: false
                });

            } catch (error) {
                console.error("Flashcards error:", error.message);
                res.status(500).send("Failed to generate flashcards. Please try again.");
            }
        }
        else {
            try {
                const urlQuizRaw = await geminiGenerate(
                    "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text or markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $$",
                    `Create a 10-question multiple choice quiz from this YouTube transcript for ${level} school students. Each question must have: question, option1, option2, option3, option4, answer. Return only valid JSON array.\n\n${fullText}`,
                    'gemini-2.5-pro'
                );
                const content = JSON.parse(urlQuizRaw.replace(/```json\n?|```/g, '').trim());
                req.session.topic = url;
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    const progress = await getUserMastery(req.user.id, url);
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(url), p_mastery: parseFloat(progress.mastery_score) });
                } catch (e) {
                    console.warn('BKT next (generate) failed:', e.message || e);
                }
                res.render("quiz.ejs", {
                    topic: "Youtube Video",
                    gradeLevel: level,
                    content: content,
                    showResults: false,
                    bktMastery: bktInfo?.mastery,
                    bktRecommendedDifficulty: bktInfo?.recommendedDifficulty
                });

            } catch (error) {
                console.error("Quiz error:", error.message);
                res.status(500).send("Failed to generate quiz. Please try again.");
            }
        }
    }
});

// Flashcard navigation
app.post("/flashcard", ensureAuthenticated, (req, res) => {
    if (!req.session.flashcards) {
        return res.redirect('/');
    }

    const currentIndex = parseInt(req.body.currentIndex);
    const showAnswer = req.body.showAnswer === "true";

    res.render("flashcards.ejs", {
        topic: req.session.topic,
        gradeLevel: req.session.gradeLevel,
        content: req.session.flashcards,
        currentIndex: currentIndex,
        showAnswer: showAnswer
    });
});

// Quiz submission and analysis
app.post("/quiz", ensureAuthenticated, async (req, res) => {
    var showResults = true;
    var userAnswers = [];
    var score = 0;

    for (let i = 0; i < 10; i++) {
        userAnswers.push(req.body[`answer_${i}`]);
        if (req.body[`answer_${i}`] === req.session.content[i].answer) {
            score++;
        }
    }

    // Update BKT with each response under the current topic as the skill
    const skillId = String(req.session.topic);
    let progressBefore = { mastery_score: 0.2, questions_answered: 0, correct_answers: 0 };
    try {
        progressBefore = await getUserMastery(req.user.id, skillId);
    } catch (e) { console.warn('getUserMastery failed:', e.message); }

    let currentMastery = parseFloat(progressBefore.mastery_score);
    let totalAnswered = progressBefore.questions_answered;
    let totalCorrect = progressBefore.correct_answers;
    try {
        for (let i = 0; i < req.session.content.length; i++) {
            const correct = userAnswers[i] === req.session.content[i].answer;
            const result = await bktUpdate({
                userId: String(req.user.id),
                skillId: skillId,
                correct: Boolean(correct),
                p_mastery: currentMastery
            });
            currentMastery = result.posterior_mastery;
            totalAnswered++;
            if (correct) totalCorrect++;
        }
        await upsertUserMastery(req.user.id, skillId, currentMastery, totalAnswered, totalCorrect);
    } catch (e) {
        console.warn('BKT update (submit) failed:', e.message || e);
    }
    let bktInfoAfter = null;
    try {
        bktInfoAfter = await bktNext({ userId: String(req.user.id), skillId: skillId, p_mastery: currentMastery });
    } catch (e) {
        console.warn('BKT next (submit) failed:', e.message || e);
    }

    const prompt = `Analyze this quiz performance:
        
Topic: ${req.session.topic}
Grade Level: ${req.session.gradeLevel}
Score: ${score}/${req.session.content.length}
Current Mastery Level: ${bktInfoAfter ? (bktInfoAfter.mastery * 100).toFixed(1) + '%' : 'N/A'} (${bktInfoAfter?.recommendedDifficulty || 'unknown'} difficulty recommended)

Questions and Answers:
${JSON.stringify({
        questions: req.session.content,
        userAnswers: userAnswers,
        score: score,
        total: req.session.content.length
    }, null, 2)}

Provide a comprehensive analysis with:
1. Overall Performance Summary
2. Key Strengths
3. Areas for Improvement
4. Study Recommendations
5. Recommended youtube videos or websites

IMPORTANT: Format your response in proper HTML with:
- Use <h2> for main headings (e.g., <h2>Overall Performance Summary</h2>)
- Use <h3> for subheadings if needed
- Use <ul><li> for bullet points in lists
- Use <strong>text</strong> for bold emphasis
- Use <br> tags for line breaks where needed
- Make it clean and well-structured for web display
- Refer to the person as if you're talking to them, not as "the student".
- Do NOT use Markdown syntax (##, -, **) - use actual HTML tags only
- If referencing mathematical concepts, use $$...$$ proper latex notation`;

    const analysisText = await geminiGenerate(
        `You are an expert educator in ${req.session.topic}. Analyze quiz data and provide actionable insights. For mathematical expressions, use $$...$$ notation.`,
        prompt,
        'gemini-2.5-pro'
    );
    const processedAnalysis = processMathContent(analysisText);

    res.render("quiz.ejs", {
        topic: req.session.topic,
        gradeLevel: req.session.gradeLevel,
        content: req.session.content,
        showResults: showResults,
        userAnswers: userAnswers,
        score: score,
        performanceAnalysis: processedAnalysis,
        bktMastery: bktInfoAfter?.mastery,
        bktRecommendedDifficulty: bktInfoAfter?.recommendedDifficulty
    })
});

// Text expansion API
app.post('/api/expand-text', ensureAuthenticated, expandLimiter, async (req, res) => {
    try {
        const { text, type, prompt, topic, gradeLevel, customQuestion } = req.body;

        const isCustomQuestion = type === 'custom' && customQuestion;

        let finalPrompt;

        if (isCustomQuestion) {
            finalPrompt = `Context: "${text}" from ${topic} study notes for ${gradeLevel} students.

Student Question: "${customQuestion}"

FORMATTING REQUIREMENTS: 
-RETURN HTML FORMATTED CONTENT (use <p>, <strong>, <ul> tags and etcetera)
- Use LaTeX notation for math : \\( \\) for inline, \\[ \\] for display
-Keep responses concise
-Use HTML formatting for emphasis and structure
-No markdown formatting,only HTML tags

Please provide a brief, HTML-formatted answer that:
- Directly addresses the student's specific question
- Uses the highlighted text as context
- Is under 150 words
- Uses LaTeX notation for math expressions
- Provides clear, educational explanations relevant to ${gradeLevel} level`;
        } else {
            // Original pre-defined context prompt
            finalPrompt = `${prompt}

Context: This is from study notes about "${topic}" for ${gradeLevel} level students from a previous prompt, you have to provide additional explanation.

FORMATTING REQUIREMENTS: 
-RETURN HTML FORMATTED CONTENT (use <p>, <strong>, <ul> tags and etcetera)
- Use LaTeX notation for math : \\( \\) for inline, \\[ \\] for display
-Keep responses concise
-Use HTML formatting for emphasis and structure
-No markdown formatting,only HTML tags

Please provide a comprehensive response that:
- Is appropriate for ${gradeLevel} level understanding
- Uses proper formatting including LaTeX for mathematical expressions
- Provides clear, educational explanations
- Includes relevant examples where helpful
- As this is further context, be extremely concise and quick to the point. Should not exceed 100 words.
- Do not delve into irrelevant topics, do exactly what is needed.

Text to expand: "${text}"`;
        }

        const expansion = await geminiGenerate(
            "You are an expert educator providing detailed explanations for study materials. Use proper LaTeX formatting for mathematical expressions.",
            finalPrompt
        );
        console.log(expansion);
        res.json({ expansion });
    } catch (error) {
        console.error('Text expansion error:', error);
        res.status(500).json({ error: 'Failed to generate expansion' });
    }
});

// Save content routes
app.post("/save-quicknotes", ensureAuthenticated, async (req, res) => {
    try {
        const topic = req.body.topic;
        const level = req.body.gradeLevel;
        const content = req.body.content;

        await db.query(
            "INSERT INTO quicknotes(topic, grade_level, note_content, user_id) VALUES ($1,$2,$3,$4)",
            [topic, level, content, req.user.id]
        );

        res.render('quicknotes.ejs', {
            topic: topic,
            gradeLevel: level,
            content: content,
            saved: true
        });
    } catch (error) {
        console.error('Error saving notes:', error);
        res.status(500).send("Error saving notes");
    }
});

app.post("/save-flashcards", ensureAuthenticated, async (req, res) => {
    try {
        const topic = req.body.topic;
        const gradeLevel = req.body.gradeLevel;

        await db.query(`
            INSERT INTO flashcards(topic, grade_level, card_content, user_id) 
            VALUES ($1, $2, $3, $4)
            ON CONFLICT (topic, grade_level, user_id) 
            DO UPDATE SET card_content = $3
        `, [topic, gradeLevel, req.body.content, req.user.id]);

        res.render("flashcards.ejs", {
            topic: topic,
            gradeLevel: gradeLevel,
            content: JSON.parse(req.body.content),
            showAnswer: req.body.showAnswer === 'true',
            currentIndex: parseInt(req.body.index) || 0,
            savedMessage: "Flashcards saved successfully!"
        });

    } catch (error) {
        console.error('Error saving flashcards:', error);
        res.render("flashcards.ejs", {
            topic: req.body.topic || '',
            gradeLevel: req.body.gradeLevel || '',
            content: req.body.content ? JSON.parse(req.body.content) : [],
            showAnswer: req.body.showAnswer === 'true',
            currentIndex: parseInt(req.body.index) || 0,
            savedMessage: null,
            errorMessage: "Failed to save flashcards"
        });
    }
});

app.post("/save-quiz", ensureAuthenticated, async (req, res) => {
    try {
        const topic = req.body.topic;
        const gradeLevel = req.body.gradeLevel;
        const content = req.body.content;

        await db.query("INSERT INTO quiz(topic,grade_level,content,user_id) VALUES ($1,$2,$3,$4)", [topic, gradeLevel, content, req.user.id]);

        res.render("quiz.ejs", {
            topic: topic,
            gradeLevel: gradeLevel,
            content: JSON.parse(content),
            score: parseInt(req.body.score),
            userAnswers: JSON.parse(req.body.userAnswers),
            performanceAnalysis: req.body.performanceAnalysis,
            showResults: true,
            saved: true
        });
    } catch (error) {
        console.error('Error saving quiz:', error);
        res.status(500).send("Error saving quiz");
    }
});

// Saved content routes
app.get("/saved-content", ensureAuthenticated, (req, res) => {
    res.render("saved-content.ejs");
});

// API routes for saved content
app.get("/api/quicknotes", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM quicknotes WHERE user_id=$1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching quicknotes:', error);
        res.status(500).json({ error: 'Failed to fetch quicknotes' });
    }
});

// Fetch single quicknote (for preview/export)
app.get("/api/quicknotes/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT id,topic,grade_level,note_content,created_at FROM quicknotes WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).json({ error: 'Not found' });
        }
        res.json(response.rows[0]);
    } catch (error) {
        console.error('Error fetching quicknote:', error);
        res.status(500).json({ error: 'Failed to fetch quicknote' });
    }
});

app.get("/api/flashcards", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM flashcards WHERE user_id = $1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching flashcards:', error);
        res.status(500).json({ error: 'Failed to fetch flashcards' });
    }
});

// Fetch single flashcard set (for export)
app.get("/api/flashcards/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT id,topic,grade_level,card_content,created_at FROM flashcards WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).json({ error: 'Not found' });
        }
        res.json(response.rows[0]);
    } catch (error) {
        console.error('Error fetching flashcards:', error);
        res.status(500).json({ error: 'Failed to fetch flashcards' });
    }
});

app.get("/api/quiz", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM quiz WHERE user_id = $1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching quizzes:', error);
        res.status(500).json({ error: 'Failed to fetch quizzes' });
    }
});

// Fetch single quiz (for export)
app.get("/api/quiz/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT id,topic,grade_level,content,created_at FROM quiz WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).json({ error: 'Not found' });
        }
        res.json(response.rows[0]);
    } catch (error) {
        console.error('Error fetching quiz:', error);
        res.status(500).json({ error: 'Failed to fetch quiz' });
    }
});

// Hierarchical Knowledge Graph API endpoints
// NOTE: Duplicate /api/chapters route removed — the canonical route is in the Hierarchical Knowledge Graph section below

// Export endpoints
app.get('/export/quicknotes/:id', ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,note_content,created_at FROM quicknotes WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).send('Not found');
        }
        const note = response.rows[0];
        const fileName = `${note.topic.replace(/[^a-z0-9]+/gi, '_')}.html`;
        res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
        res.setHeader('Content-Type', 'text/html; charset=utf-8');
        res.send(`<!DOCTYPE html><html><head><meta charset="utf-8"><title>${note.topic}</title></head><body>${note.note_content}</body></html>`);
    } catch (error) {
        console.error('Error exporting quicknote:', error);
        res.status(500).send('Failed to export quicknote');
    }
});

app.get('/export/flashcards/:id', ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,card_content FROM flashcards WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).send('Not found');
        }
        const set = response.rows[0];
        const fileName = `${set.topic.replace(/[^a-z0-9]+/gi, '_')}_flashcards.json`;
        res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.send(JSON.stringify(set.card_content));
    } catch (error) {
        console.error('Error exporting flashcards:', error);
        res.status(500).send('Failed to export flashcards');
    }
});

app.get('/export/quiz/:id', ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,content FROM quiz WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).send('Not found');
        }
        const quiz = response.rows[0];
        const fileName = `${quiz.topic.replace(/[^a-z0-9]+/gi, '_')}_quiz.json`;
        res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
        res.setHeader('Content-Type', 'application/json; charset=utf-8');
        res.send(JSON.stringify(quiz.content));
    } catch (error) {
        console.error('Error exporting quiz:', error);
        res.status(500).send('Failed to export quiz');
    }
});

// View saved content routes
app.get("/view-quicknote/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,note_content FROM quicknotes WHERE id=$1 AND user_id=$2", [id, req.user.id]);

        if (response.rows.length === 0) {
            return res.status(404).send('Note not found');
        }

        const result = response.rows[0];
        res.render("quicknotes.ejs", {
            topic: result.topic,
            gradeLevel: result.grade_level,
            content: result.note_content
        });
    } catch (error) {
        console.error('Error fetching quicknote:', error);
        res.status(500).send('Failed to load note');
    }
});

app.get("/view-flashcards/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const currentIndex = parseInt(req.query.currentIndex) || 0;
        const showAnswer = req.query.showAnswer === 'true';

        const response = await db.query("SELECT topic,grade_level,card_content FROM flashcards WHERE id=$1 AND user_id=$2", [id, req.user.id]);

        if (response.rows.length === 0) {
            return res.status(404).send('Flashcard set not found');
        }

        const content = response.rows[0];

        req.session.flashcards = content.card_content;
        req.session.topic = content.topic;
        req.session.gradeLevel = content.grade_level;

        res.render("flashcards.ejs", {
            topic: content.topic,
            gradeLevel: content.grade_level,
            content: content.card_content,
            currentIndex: currentIndex,
            showAnswer: showAnswer,
            savedMessage: null
        });
    } catch (error) {
        console.error('Error fetching flashcard:', error);
        res.status(500).send('Failed to load flashcard set');
    }
});

app.get("/view-quiz/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,content FROM quiz WHERE id=$1 AND user_id=$2", [id, req.user.id]);

        if (response.rows.length === 0) {
            return res.status(404).send('Quiz not found');
        }

        const result = response.rows[0];
        req.session.topic = result.topic;
        req.session.gradeLevel = result.grade_level;
        req.session.content = result.content;

        res.render("quiz.ejs", {
            topic: req.session.topic,
            gradeLevel: req.session.gradeLevel,
            content: req.session.content,
            showResults: false
        });
    } catch (error) {
        console.error('Error fetching quiz:', error);
        res.status(500).send('Failed to load quiz');
    }
});

// Delete content routes
app.delete("/delete-content/quicknotes/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const result = await db.query("DELETE FROM quicknotes WHERE id=$1 AND user_id=$2 RETURNING id", [id, req.user.id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Note not found'
            });
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Error deleting quicknote:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete note'
        });
    }
});

app.delete("/delete-content/flashcards/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const result = await db.query("DELETE FROM flashcards WHERE id=$1 AND user_id=$2 RETURNING id", [id, req.user.id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Flashcard set not found'
            });
        }

        res.json({
            success: true,
            message: 'Flashcard set deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting flashcard:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete flashcard set'
        });
    }
});

app.delete("/delete-content/quiz/:id", ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const result = await db.query("DELETE FROM quiz WHERE id=$1 AND user_id=$2 RETURNING id", [id, req.user.id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Quiz not found'
            });
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Error deleting quiz:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to delete quiz'
        });
    }
});
app.get("/chat", ensureAuthenticated, (req, res) => {
    res.render("chat.ejs", {
        user: req.user
    });
});
app.post("/api/chat", ensureAuthenticated, chatLimiter, async (req, res) => {
    try {
        const { message, sessionId } = req.body;
        if (!message) return res.status(400).json({ error: 'Message is required' });
        const { chatWithPerplexityStream } = await import('./services/chatService.js');
        await chatWithPerplexityStream(message, req.user.id, sessionId || 'default', res);
    } catch (error) {
        console.error('Chat API error:', error);
        if (!res.headersSent) res.status(500).json({ error: 'Failed to get AI response' });
    }
});

app.post("/api/chat/upload-pdf", ensureAuthenticated, upload.single('document'), async (req, res) => {
    try {
        if (!req.file) return res.status(400).json({ error: 'PDF file required' });
        const { sessionId } = req.body;
        const { ingestPDFForSession } = await import('./services/chatService.js');
        const chunkCount = await ingestPDFForSession(req.file.buffer, req.file.originalname, req.user.id, sessionId || 'default');
        res.json({ success: true, chunks: chunkCount });
    } catch (error) {
        console.error('Chat PDF upload error:', error);
        res.status(500).json({ error: 'Failed to process PDF' });
    }
});

// Translation API endpoint
app.post("/api/translate", async (req, res) => {
    try {
        const { text, targetLanguage, sourceLanguage = 'en' } = req.body;

        if (!text) {
            return res.status(400).json({ error: 'Text is required' });
        }

        if (!targetLanguage) {
            return res.status(400).json({ error: 'Target language is required' });
        }

        const { translateText } = await import('./services/translationService.js');
        const translatedText = await translateText(text, targetLanguage, sourceLanguage);

        res.json({ translatedText });
    } catch (error) {
        console.error('Translation API error:', error);
        res.status(500).json({ error: 'Failed to translate text' });
    }
});

// Batch translation API endpoint
app.post("/api/translate/batch", async (req, res) => {
    try {
        const { texts, targetLanguage, sourceLanguage = 'en' } = req.body;

        if (!texts || !Array.isArray(texts)) {
            return res.status(400).json({ error: 'Texts array is required' });
        }

        if (!targetLanguage) {
            return res.status(400).json({ error: 'Target language is required' });
        }

        const { translateMultiple } = await import('./services/translationService.js');
        const translatedTexts = await translateMultiple(texts, targetLanguage, sourceLanguage);

        res.json({ translatedTexts });
    } catch (error) {
        console.error('Batch translation API error:', error);
        res.status(500).json({ error: 'Failed to translate texts' });
    }
});

// Practice routes
function applyDecay(mastery, lastUpdated) {
    if (!lastUpdated) return mastery;
    const days = (Date.now() - new Date(lastUpdated).getTime()) / 86400000;
    return Math.max(mastery * Math.exp(-0.05 * days), 0.1);
}

app.get('/practice/:conceptId', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const [conceptRes, masteryRes] = await Promise.all([
            db.query('SELECT id, name, subject FROM concepts WHERE id=$1', [conceptId]),
            db.query('SELECT mastery, last_updated FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2', [req.user.id, conceptId])
        ]);
        if (!conceptRes.rows[0]) return res.status(404).send('Concept not found');
        const storedMastery = parseFloat(masteryRes.rows[0]?.mastery || 0.2);
        const mastery = masteryRes.rows[0] ? applyDecay(storedMastery, masteryRes.rows[0].last_updated) : storedMastery;
        const decayedBy = Math.round((storedMastery - mastery) * 100);
        const tier = masteryToTier(mastery);
        // Load questions at the right tier, with fallback to adjacent tiers
        const instituteId = req.user.institute_id;
        let practiceQuery = `SELECT id, question_text, option1, option2, option3, option4, correct_answer, solution_text, difficulty_tier
             FROM questions WHERE concept_id=$1 AND status='approved'`;
        const practiceParams = [conceptId, tier];
        if (instituteId) {
            practiceQuery += ` AND (institute_id = $3 OR institute_id IS NULL)`;
            practiceParams.push(instituteId);
        }
        practiceQuery += ` ORDER BY ABS(difficulty_tier - $2) ASC, RANDOM()`;
        const questionsRes = await db.query(practiceQuery, practiceParams);
        res.render('practice.ejs', {
            concept: conceptRes.rows[0],
            questions: questionsRes.rows,
            mastery,
            decayedBy
        });
    } catch (e) {
        console.error('Practice load error:', e);
        res.status(500).send('Failed to load practice session');
    }
});

app.post('/practice/:conceptId/answer', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const { correct, difficulty_tier, time_taken_seconds, question_id } = req.body;

        // Log the attempt
        if (question_id) {
            await db.query(
                'INSERT INTO user_question_attempts (user_id, question_id, correct, time_taken_seconds) VALUES ($1,$2,$3,$4)',
                [req.user.id, question_id, correct, time_taken_seconds]
            );
        }

        const prev = await getUserConceptMastery(req.user.id, conceptId);
        const updated = await bktUpdateConcept({
            userId: req.user.id, skillId: conceptId,
            correct: Boolean(correct), p_mastery: parseFloat(prev.mastery),
            difficulty_tier: Number(difficulty_tier) || 2,
            time_taken_seconds: time_taken_seconds ? Number(time_taken_seconds) : null
        });
        const newMastery = updated.posterior_mastery;
        const newQA = prev.questions_answered + 1;
        const newCA = prev.correct_answers + (correct ? 1 : 0);

        await db.query(`
            INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
            VALUES ($1,$2,$3,$4,$5,CURRENT_TIMESTAMP)
            ON CONFLICT (user_id, concept_id) DO UPDATE
            SET mastery=$3, questions_answered=$4, correct_answers=$5, last_updated=CURRENT_TIMESTAMP`,
            [req.user.id, conceptId, newMastery, newQA, newCA]
        );

        // Enhanced stagnation check with prerequisite analysis
        let stagnating = false;
        let prerequisiteGaps = [];
        let suggestedPath = [];

        if (newQA >= 5 && newMastery < 0.5) {
            stagnating = true;
            prerequisiteGaps = await checkPrerequisiteGaps(db, req.user.id, conceptId);
            if (prerequisiteGaps.length > 0) {
                suggestedPath = await getOptimalLearningPath(db, req.user.id, conceptId);
            }
        }

        res.json({
            mastery: newMastery,
            stagnating,
            prerequisiteGaps,
            suggestedPath,
            message: stagnating ?
                `Consider reviewing prerequisites: ${prerequisiteGaps.map(p => p.name).join(', ')}` :
                null
        });
    } catch (e) {
        console.error('Practice answer error:', e);
        res.status(500).json({ error: 'Failed to update mastery' });
    }
});

// Adaptive questions API - fetch questions based on current mastery tier
app.get('/api/adaptive-questions/:conceptId', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const { tier } = req.query;
        const targetTier = parseInt(tier) || 2;

        // Fetch questions at the target tier, with fallback to adjacent tiers
        const questionsRes = await db.query(
            `SELECT id, question_text, option1, option2, option3, option4, correct_answer, solution_text, difficulty_tier
             FROM questions WHERE concept_id=$1 AND status='approved'
             AND difficulty_tier >= $2
             ORDER BY difficulty_tier ASC, RANDOM() LIMIT 5`,
            [conceptId, targetTier]
        );

        res.json({ questions: questionsRes.rows });
    } catch (e) {
        console.error('Adaptive questions error:', e);
        res.status(500).json({ error: 'Failed to fetch questions' });
    }
});

// Mastery Mode — graph-aware, pulls real questions from DB
app.get('/master', ensureAuthenticated, async (req, res) => {
    res.render('master.ejs', {
        topic: null, gradeLevel: null, mastery: null,
        question: null, completed: false, message: null,
        conceptName: null, allConcepts: null
    });
});

app.post('/master/start', ensureAuthenticated, async (req, res) => {
    try {
        const subject = req.body.subject || 'physics';
        req.session.masterSubject = subject;

        const graphData = await bktNextConcept({ userId: req.user.id, subject });
        if (!graphData.next_concept_id) {
            return res.render('master.ejs', {
                topic: null, gradeLevel: null, mastery: null, question: null,
                completed: true, message: 'All concepts mastered!',
                conceptName: null, allConcepts: graphData.all_concepts
            });
        }

        const conceptId = graphData.next_concept_id;
        const difficulty = graphData.recommendedDifficulty;
        const question = await getQuestionFromDB(conceptId, difficulty, [], req.user.id, req.user.institute_id);

        if (!question) {
            return res.status(404).send(`No approved questions found for concept: ${graphData.next_concept_name}`);
        }

        req.session.masterConceptId = conceptId;
        req.session.masterQuestion = question;

        res.render('master.ejs', {
            topic: conceptId, gradeLevel: difficulty,
            mastery: graphData.mastery, question,
            completed: false, message: null,
            conceptName: graphData.next_concept_name,
            allConcepts: graphData.all_concepts
        });
    } catch (e) {
        console.error('Master start error:', e);
        res.status(500).send('Failed to start mastery session');
    }
});

app.post('/master/answer', ensureAuthenticated, async (req, res) => {
    try {
        const conceptId = req.session.masterConceptId;
        const question = req.session.masterQuestion;
        if (!conceptId || !question) return res.redirect('/master');

        const correct = req.body.answer === question.correct_answer;
        const prev = await getUserConceptMastery(req.user.id, conceptId);

        // Update mastery in DB via BKT
        const updated = await bktUpdateConcept({
            userId: req.user.id, skillId: conceptId,
            correct, p_mastery: parseFloat(prev.mastery)
        });
        const newMastery = updated.posterior_mastery;

        // Get next concept from graph
        const subject = req.session.masterSubject || 'physics';
        const graphData = await bktNextConcept({ userId: req.user.id, subject });

        if (!graphData.next_concept_id) {
            return res.render('master.ejs', {
                topic: null, gradeLevel: null, mastery: newMastery, question: null,
                completed: true, message: 'All concepts mastered!',
                conceptName: null, allConcepts: graphData.all_concepts
            });
        }

        const nextConceptId = graphData.next_concept_id;
        const nextQuestion = await getQuestionFromDB(nextConceptId, graphData.recommendedDifficulty, [], null, req.user.institute_id);

        if (!nextQuestion) {
            return res.status(404).send(`No approved questions for concept: ${graphData.next_concept_name}`);
        }

        req.session.masterConceptId = nextConceptId;
        req.session.masterQuestion = nextQuestion;

        res.render('master.ejs', {
            topic: nextConceptId, gradeLevel: graphData.recommendedDifficulty,
            mastery: graphData.mastery, question: nextQuestion,
            completed: false,
            message: correct ? '✓ Correct!' : '✗ Incorrect. Keep going!',
            conceptName: graphData.next_concept_name,
            allConcepts: graphData.all_concepts
        });
    } catch (e) {
        console.error('Master answer error:', e);
        res.status(500).send('Failed to process answer');
    }
});

// Concept-specific prerequisite diagnosis API endpoint
app.post('/api/diagnose-concept', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.body;

        // Set up Server-Sent Events
        res.writeHead(200, {
            'Content-Type': 'text/event-stream',
            'Cache-Control': 'no-cache',
            'Connection': 'keep-alive'
        });

        function sendEvent(type, data) {
            res.write(`data: ${JSON.stringify({ type, ...data })}\n\n`);
        }

        // Get prerequisite chain for this concept (recursive)
        const visited = new Set();
        const toCheck = [];

        async function getPrereqChain(cId) {
            if (visited.has(cId)) return;
            visited.add(cId);
            toCheck.push(cId);

            const prereqRes = await db.query(
                'SELECT prereq_id FROM concept_prerequisites WHERE concept_id = $1',
                [cId]
            );

            for (const row of prereqRes.rows) {
                await getPrereqChain(row.prereq_id);
            }
        }

        await getPrereqChain(conceptId);

        let gapsFound = 0;

        // Check each concept in the chain
        for (const cId of toCheck) {
            sendEvent('checking', { conceptId: cId });

            // Get mastery
            const masteryRes = await db.query(
                'SELECT mastery FROM user_concept_mastery WHERE user_id = $1 AND concept_id = $2',
                [req.user.id, cId]
            );

            const mastery = masteryRes.rows[0]?.mastery || 0.2;

            await new Promise(resolve => setTimeout(resolve, 500)); // Visual delay

            if (mastery < 0.7) {
                gapsFound++;
                sendEvent('gap', { conceptId: cId, mastery: Math.round(mastery * 100) });
            } else {
                sendEvent('ok', { conceptId: cId, mastery: Math.round(mastery * 100) });
            }
        }

        sendEvent('complete', { gapsFound, totalChecked: toCheck.length });
        res.end();

    } catch (error) {
        console.error('Concept diagnosis error:', error);
        res.write(`data: ${JSON.stringify({ type: 'error', message: error.message })}\n\n`);
        res.end();
    }
});
app.post('/api/bkt/update', ensureAuthenticated, async (req, res) => {
    try {
        const { skillId, correct, params } = req.body;
        if (!skillId || typeof correct === 'undefined') {
            return res.status(400).json({ error: 'skillId and correct are required' });
        }
        const progress = await getUserMastery(req.user.id, skillId);
        const result = await bktUpdate({
            userId: String(req.user.id),
            skillId: String(skillId),
            correct: Boolean(correct),
            p_mastery: parseFloat(progress.mastery_score),
            ...(params || {})
        });
        await upsertUserMastery(req.user.id, skillId, result.posterior_mastery, progress.questions_answered + 1, progress.correct_answers + (correct ? 1 : 0));
        res.json(result);
    } catch (err) {
        console.error('BKT update error:', err.message || err);
        res.status(500).json({ error: 'BKT update failed' });
    }
});

app.post('/api/bkt/next', ensureAuthenticated, async (req, res) => {
    try {
        const { skillId } = req.body;
        if (!skillId) {
            return res.status(400).json({ error: 'skillId is required' });
        }
        const progress = await getUserMastery(req.user.id, skillId);
        const result = await bktNext({
            userId: String(req.user.id),
            skillId: String(skillId),
            p_mastery: parseFloat(progress.mastery_score)
        });
        res.json(result);
    } catch (err) {
        console.error('BKT next error:', err.message || err);
        res.status(500).json({ error: 'BKT next failed' });
    }
});

// Hierarchical Knowledge Graph API Endpoints

// Helper: Detect and filter circular dependencies from prerequisite edges
function filterCircularDependencies(edges) {
    // Build adjacency list
    const adj = {};
    edges.forEach(e => {
        if (!adj[e.prereq_id]) adj[e.prereq_id] = [];
        adj[e.prereq_id].push(e.chapter_id);
    });

    // DFS-based cycle detection
    const WHITE = 0, GRAY = 1, BLACK = 2;
    const color = {};
    const cyclicEdges = new Set();

    function dfs(node, path) {
        color[node] = GRAY;
        path.push(node);

        for (const neighbor of (adj[node] || [])) {
            if (color[neighbor] === GRAY) {
                // Found a cycle - log it and mark the edge
                const cycleStart = path.indexOf(neighbor);
                const cyclePath = path.slice(cycleStart).concat(neighbor);
                console.error('[KnowledgeGraph] Circular dependency detected:', cyclePath.join(' → '));
                cyclicEdges.add(node + '->' + neighbor);
            } else if (color[neighbor] !== BLACK) {
                dfs(neighbor, path);
            }
        }

        path.pop();
        color[node] = BLACK;
    }

    // Get all unique nodes
    const allNodes = new Set();
    edges.forEach(e => { allNodes.add(e.prereq_id); allNodes.add(e.chapter_id); });

    allNodes.forEach(node => {
        if (!color[node]) dfs(node, []);
    });

    // Filter out cyclic edges
    return edges.filter(e => !cyclicEdges.has(e.prereq_id + '->' + e.chapter_id));
}

// GET /api/chapters - Returns all chapters with prerequisite relationships and bridge edges
app.get('/api/chapters', ensureAuthenticated, async (req, res) => {
    try {
        const { subject } = req.query;

        // Validate subject parameter if provided
        if (subject && typeof subject !== 'string') {
            return res.status(400).json({ error: 'Invalid subject parameter' });
        }

        // Query chapters with optional subject filter
        let chaptersQuery = 'SELECT id, name, subject, display_order, description FROM chapters';
        const queryParams = [];

        if (subject) {
            chaptersQuery += ' WHERE subject = $1';
            queryParams.push(subject);
        }

        chaptersQuery += ' ORDER BY display_order';

        const chaptersResult = await db.query(chaptersQuery, queryParams);

        // Query all chapter prerequisites
        const prerequisitesResult = await db.query(
            'SELECT chapter_id, prereq_id FROM chapter_prerequisites'
        );

        // Detect and exclude circular dependencies
        const prereqEdges = prerequisitesResult.rows;
        const validPrereqs = filterCircularDependencies(prereqEdges);

        // Calculate bridge edges: cross-chapter concept dependencies
        let bridgeEdges = [];
        try {
            const bridgeResult = await db.query(
                `SELECT 
                    c1.chapter_id as from_chapter,
                    c2.chapter_id as to_chapter,
                    COUNT(*) as concept_count
                 FROM concept_prerequisites cp
                 JOIN concepts c1 ON c1.id = cp.prereq_id
                 JOIN concepts c2 ON c2.id = cp.concept_id
                 WHERE c1.chapter_id != c2.chapter_id
                    AND c1.chapter_id IS NOT NULL
                    AND c2.chapter_id IS NOT NULL
                 GROUP BY c1.chapter_id, c2.chapter_id`
            );
            bridgeEdges = bridgeResult.rows.map(row => ({
                from_chapter: row.from_chapter,
                to_chapter: row.to_chapter,
                concept_count: parseInt(row.concept_count)
            }));
        } catch (bridgeError) {
            console.error('[KnowledgeGraph] Error calculating bridge edges:', bridgeError.message);
        }

        res.json({
            chapters: chaptersResult.rows,
            prerequisites: validPrereqs,
            bridgeEdges: bridgeEdges
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching chapters:', error.message, { query: 'GET /api/chapters', subject: req.query.subject });
        res.status(500).json({ error: 'Failed to fetch chapters. Please try again later.' });
    }
});

// GET /api/chapters/:chapterId/concepts - Returns micro-concepts for a specific chapter
app.get('/api/chapters/:chapterId/concepts', ensureAuthenticated, async (req, res) => {
    try {
        const { chapterId } = req.params;
        const { userId } = req.query;

        // Validate chapterId - alphanumeric with underscores only
        if (!chapterId || !/^[a-zA-Z0-9_]+$/.test(chapterId)) {
            return res.status(400).json({ error: 'Invalid chapter_id parameter' });
        }

        // Validate userId if provided
        if (userId && !/^\d+$/.test(userId)) {
            return res.status(400).json({ error: 'Invalid user_id parameter' });
        }

        // Get chapter info
        const chapterResult = await db.query(
            'SELECT id, name FROM chapters WHERE id = $1',
            [chapterId]
        );

        if (chapterResult.rows.length === 0) {
            return res.status(404).json({ error: 'Chapter not found' });
        }

        // Get concepts in this chapter
        const conceptsResult = await db.query(
            'SELECT id, name, chapter_id FROM concepts WHERE chapter_id = $1',
            [chapterId]
        );

        const conceptIds = conceptsResult.rows.map(c => c.id);

        // Get prerequisites for these concepts
        let prerequisitesRows = [];
        if (conceptIds.length > 0) {
            const prerequisitesResult = await db.query(
                'SELECT concept_id, prereq_id FROM concept_prerequisites WHERE concept_id = ANY($1)',
                [conceptIds]
            );
            prerequisitesRows = prerequisitesResult.rows;
        }

        // Identify ghost nodes (prerequisites from other chapters) with validation
        let ghostNodes = [];
        if (conceptIds.length > 0) {
            const ghostNodesResult = await db.query(
                `SELECT DISTINCT 
                    c.id, 
                    c.name, 
                    c.chapter_id,
                    ch.name as chapter_name
                FROM concept_prerequisites cp
                JOIN concepts c ON c.id = cp.prereq_id
                JOIN chapters ch ON ch.id = c.chapter_id
                WHERE cp.concept_id = ANY($1)
                    AND c.chapter_id != $2
                    AND c.chapter_id IS NOT NULL`,
                [conceptIds, chapterId]
            );
            // Validate ghost nodes - only include those with valid concept and chapter references
            ghostNodes = ghostNodesResult.rows.filter(g => {
                if (!g.id || !g.chapter_id || !g.chapter_name) {
                    console.warn('[KnowledgeGraph] Excluding invalid ghost node: missing concept or chapter reference', { ghostId: g.id, chapterId: g.chapter_id });
                    return false;
                }
                return true;
            });
        }

        res.json({
            chapter: chapterResult.rows[0],
            concepts: conceptsResult.rows,
            prerequisites: prerequisitesRows,
            ghostNodes: ghostNodes
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching chapter concepts:', error.message, { query: 'GET /api/chapters/:chapterId/concepts', chapterId: req.params.chapterId });
        res.status(500).json({ error: 'Failed to fetch chapter concepts. Please try again later.' });
    }
});

// Helper function: Calculate chapter mastery for a user
async function calculateChapterMastery(userId, chapterId) {
    try {
        // Query all concepts in chapter
        const conceptsResult = await db.query(
            'SELECT id FROM concepts WHERE chapter_id = $1',
            [chapterId]
        );

        if (conceptsResult.rows.length === 0) return null;

        const conceptIds = conceptsResult.rows.map(c => c.id);

        // Query mastery for each concept
        const masteryResult = await db.query(
            `SELECT concept_id, mastery 
             FROM user_concept_mastery 
             WHERE user_id = $1 AND concept_id = ANY($2)`,
            [userId, conceptIds]
        );

        if (masteryResult.rows.length === 0) return null;

        // Calculate weighted average (equal weights)
        const totalMastery = masteryResult.rows.reduce((sum, row) => sum + parseFloat(row.mastery), 0);
        return totalMastery / masteryResult.rows.length;
    } catch (error) {
        console.error('[KnowledgeGraph] Error calculating chapter mastery:', error.message, { userId, chapterId });
        return null;
    }
}

// GET /api/user/:userId/chapter-mastery - Returns chapter mastery scores for a user
app.get('/api/user/:userId/chapter-mastery', ensureAuthenticated, async (req, res) => {
    try {
        const { userId } = req.params;

        // Validate userId - must be numeric
        if (!userId || !/^\d+$/.test(userId)) {
            return res.status(400).json({ error: 'Invalid user_id parameter' });
        }

        // Ensure user can only access their own data (or is admin/teacher)
        if (req.user.id !== parseInt(userId) && req.user.role !== 'admin' && req.user.role !== 'teacher') {
            return res.status(403).json({ error: 'Unauthorized' });
        }

        // Query all chapters
        const chaptersResult = await db.query('SELECT id FROM chapters ORDER BY display_order');

        // Calculate mastery for each chapter
        const chapterMastery = [];
        for (const chapter of chaptersResult.rows) {
            const mastery = await calculateChapterMastery(userId, chapter.id);
            if (mastery !== null) {
                // Get concept counts
                const conceptsResult = await db.query(
                    'SELECT COUNT(*) as total FROM concepts WHERE chapter_id = $1',
                    [chapter.id]
                );
                const masteredResult = await db.query(
                    `SELECT COUNT(DISTINCT ucm.concept_id) as mastered
                     FROM user_concept_mastery ucm
                     JOIN concepts c ON c.id = ucm.concept_id
                     WHERE ucm.user_id = $1 AND c.chapter_id = $2 AND ucm.mastery >= 0.8`,
                    [userId, chapter.id]
                );

                chapterMastery.push({
                    chapter_id: chapter.id,
                    mastery: mastery,
                    concept_count: parseInt(conceptsResult.rows[0].total),
                    mastered_count: parseInt(masteredResult.rows[0].mastered)
                });
            }
        }

        res.json({
            userId: parseInt(userId),
            chapterMastery: chapterMastery
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching user chapter mastery:', error.message, { query: 'GET /api/user/:userId/chapter-mastery', userId: req.params.userId });
        res.status(500).json({ error: 'Failed to fetch chapter mastery. Please try again later.' });
    }
});

// Helper function: Calculate batch chapter mastery
async function calculateBatchChapterMastery(batchId) {
    try {
        // Get all students in batch
        const studentsResult = await db.query(
            'SELECT user_id FROM batch_students WHERE batch_id = $1',
            [batchId]
        );

        if (studentsResult.rows.length === 0) return [];

        const studentIds = studentsResult.rows.map(s => s.user_id);

        // Aggregate mastery by chapter
        const batchMasteryResult = await db.query(
            `SELECT 
                c.chapter_id,
                AVG(ucm.mastery) as avg_mastery,
                MIN(ucm.mastery) as min_mastery,
                MAX(ucm.mastery) as max_mastery,
                COUNT(DISTINCT CASE WHEN ucm.mastery >= 0.8 THEN ucm.user_id END) as students_mastered
             FROM concepts c
             JOIN user_concept_mastery ucm ON ucm.concept_id = c.id
             WHERE ucm.user_id = ANY($1)
                AND c.chapter_id IS NOT NULL
             GROUP BY c.chapter_id`,
            [studentIds]
        );

        return batchMasteryResult.rows.map(row => ({
            chapter_id: row.chapter_id,
            avg_mastery: parseFloat(row.avg_mastery),
            min_mastery: parseFloat(row.min_mastery),
            max_mastery: parseFloat(row.max_mastery),
            students_mastered: parseInt(row.students_mastered)
        }));
    } catch (error) {
        console.error('[KnowledgeGraph] Error calculating batch chapter mastery:', error.message, { batchId });
        return [];
    }
}

// GET /api/batch/:batchId/chapter-mastery - Returns aggregated chapter mastery for a batch
app.get('/api/batch/:batchId/chapter-mastery', ensureAuthenticated, async (req, res) => {
    try {
        const { batchId } = req.params;

        // Validate batchId - must be numeric
        if (!batchId || !/^\d+$/.test(batchId)) {
            return res.status(400).json({ error: 'Invalid batch_id parameter' });
        }

        // Verify user has access to this batch (teacher/admin of the institute)
        if (req.user.role !== 'admin' && req.user.role !== 'teacher' && req.user.role !== 'institute_admin') {
            return res.status(403).json({ error: 'Unauthorized' });
        }

        // Get student count
        const studentCountResult = await db.query(
            'SELECT COUNT(*) as count FROM batch_students WHERE batch_id = $1',
            [batchId]
        );

        const chapterMastery = await calculateBatchChapterMastery(batchId);

        res.json({
            batchId: parseInt(batchId),
            studentCount: parseInt(studentCountResult.rows[0].count),
            chapterMastery: chapterMastery
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching batch chapter mastery:', error.message, { query: 'GET /api/batch/:batchId/chapter-mastery', batchId: req.params.batchId });
        res.status(500).json({ error: 'Failed to fetch batch chapter mastery. Please try again later.' });
    }
});

// Group Study Routes
app.get("/group-study", ensureAuthenticated, async (req, res) => {
    try {
        const rooms = await getUserRooms(db, req.user.id);
        res.render("group-study-rooms.ejs", {
            user: req.user,
            rooms: rooms
        });
    } catch (error) {
        console.error('Error loading group study rooms:', error);
        res.status(500).send("Error loading group study");
    }
});

app.get("/group-study/create", ensureAuthenticated, (req, res) => {
    res.render("group-study-create.ejs", { user: req.user });
});

app.post("/group-study/create", ensureAuthenticated, async (req, res) => {
    try {
        const { name, topic, description, privacy, maxParticipants, studyMaterialType } = req.body;

        const room = await createRoom(db, {
            name,
            topic,
            description,
            privacy: privacy || 'public',
            maxParticipants: parseInt(maxParticipants) || 50,
            studyMaterialType,
            ownerId: req.user.id
        });

        res.redirect(`/group-study/room/${room.room_code}`);
    } catch (error) {
        console.error('Error creating room:', error);
        res.status(500).send("Error creating study room");
    }
});

app.get("/group-study/join", ensureAuthenticated, (req, res) => {
    res.render("group-study-join.ejs", { user: req.user });
});

app.post("/group-study/join", ensureAuthenticated, async (req, res) => {
    try {
        const { roomCode } = req.body;

        const room = await getRoomByCode(db, roomCode.toUpperCase());
        if (!room) {
            return res.status(404).send("Room not found");
        }

        // Check if already a member
        const isMember = await isRoomMember(db, room.id, req.user.id);
        if (!isMember) {
            // Join room
            await joinRoom(db, room.id, req.user.id);
        }

        res.redirect(`/group-study/room/${room.room_code}`);
    } catch (error) {
        console.error('Error joining room:', error);
        res.status(500).send(error.message || "Error joining room");
    }
});

app.get("/group-study/room/:roomCode", ensureAuthenticated, async (req, res) => {
    try {
        const { roomCode } = req.params;

        const room = await getRoomByCode(db, roomCode.toUpperCase());
        if (!room) {
            return res.status(404).send("Room not found");
        }

        // Check if user is member
        const isMember = await isRoomMember(db, room.id, req.user.id);
        if (!isMember) {
            // Try to join if public
            if (room.privacy === 'public') {
                try {
                    await joinRoom(db, room.id, req.user.id);
                } catch (joinError) {
                    return res.status(403).send("Cannot join this room");
                }
            } else {
                return res.status(403).send("You must be invited to join this room");
            }
        }

        const roomWithMembers = await getRoomWithMembers(db, room.id);
        const content = await getRoomContent(db, room.id);
        const sessions = await getRoomSessions(db, room.id);
        const progressStats = await getGroupProgressStats(db, room.id);
        const userRole = await getUserRoomRole(db, room.id, req.user.id);
        const chatMessages = await getRoomChatMessages(db, room.id);

        res.render("group-study-room.ejs", {
            user: req.user,
            room: roomWithMembers,
            content: content,
            sessions: sessions,
            progressStats: progressStats,
            userRole: userRole,
            chatMessages: chatMessages
        });
    } catch (error) {
        console.error('Error loading room:', error);
        res.status(500).send("Error loading room");
    }
});

app.post("/group-study/room/:roomId/share", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;
        const { contentType, contentId, title, topic, gradeLevel, contentData } = req.body;

        // Check if user is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const shared = await shareContentToRoom(db, {
            roomId: parseInt(roomId),
            contentType,
            contentId: contentId ? parseInt(contentId) : null,
            title,
            topic,
            gradeLevel,
            contentData: typeof contentData === 'string' ? JSON.parse(contentData) : contentData,
            sharedBy: req.user.id
        });

        // Emit to room
        io.to(`room_${roomId}`).emit('content_shared', shared);

        res.json({ success: true, content: shared });
    } catch (error) {
        console.error('Error sharing content:', error);
        res.status(500).json({ error: "Error sharing content" });
    }
});

app.post("/group-study/session/create", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, title, description, scheduledAt, durationMinutes } = req.body;

        const session = await createStudySession(db, {
            roomId: parseInt(roomId),
            title,
            description,
            scheduledAt: new Date(scheduledAt),
            durationMinutes: parseInt(durationMinutes) || 60,
            createdBy: req.user.id
        });

        io.to(`room_${roomId}`).emit('session_created', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error creating session:', error);
        res.status(500).json({ error: "Error creating session" });
    }
});

app.post("/group-study/quiz/submit", ensureAuthenticated, async (req, res) => {
    try {
        const { roomContentId, score, totalQuestions, timeTakenSeconds, skillId, roomId } = req.body;

        // Add to leaderboard
        await addQuizResult(db, parseInt(roomContentId), req.user.id, parseInt(score), parseInt(totalQuestions), parseInt(timeTakenSeconds));

        // Update group progress if skillId provided
        if (skillId && roomId) {
            const correctAnswers = parseInt(score);
            await updateGroupProgress(db, parseInt(roomId), skillId, req.user.id, correctAnswers / totalQuestions, parseInt(totalQuestions), correctAnswers);
        }

        // Emit leaderboard update
        const leaderboard = await getQuizLeaderboard(db, parseInt(roomContentId));
        io.to(`room_${roomId}`).emit('leaderboard_updated', { roomContentId, leaderboard });

        res.json({ success: true, leaderboard });
    } catch (error) {
        console.error('Error submitting quiz:', error);
        res.status(500).json({ error: "Error submitting quiz" });
    }
});

// Additional group study routes
app.post("/group-study/room/:roomId/invite", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;
        const { email } = req.body;

        const result = await inviteUserToRoom(db, parseInt(roomId), req.user.id, email);

        io.to(`room_${roomId}`).emit('member_added', { userId: result.userId });

        res.json({ success: true });
    } catch (error) {
        console.error('Error inviting user:', error);
        res.status(500).json({ error: error.message || "Error inviting user" });
    }
});

app.delete("/group-study/room/:roomId/leave", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        await leaveRoom(db, parseInt(roomId), req.user.id);

        io.to(`room_${roomId}`).emit('member_left', { userId: req.user.id });

        res.json({ success: true });
    } catch (error) {
        console.error('Error leaving room:', error);
        res.status(500).json({ error: error.message || "Error leaving room" });
    }
});

app.delete("/group-study/room/:roomId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        await deleteRoom(db, parseInt(roomId), req.user.id);

        io.to(`room_${roomId}`).emit('room_deleted');

        res.json({ success: true });
    } catch (error) {
        console.error('Error deleting room:', error);
        res.status(500).json({ error: error.message || "Error deleting room" });
    }
});

app.delete("/group-study/room/:roomId/member/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        await removeUserFromRoom(db, parseInt(roomId), req.user.id, parseInt(userId));

        io.to(`room_${roomId}`).emit('member_removed', { userId: parseInt(userId) });

        res.json({ success: true });
    } catch (error) {
        console.error('Error removing member:', error);
        res.status(500).json({ error: error.message || "Error removing member" });
    }
});

app.post("/group-study/room/:roomId/promote/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        await promoteUser(db, parseInt(roomId), req.user.id, parseInt(userId));

        io.to(`room_${roomId}`).emit('member_promoted', { userId: parseInt(userId), role: 'admin' });

        res.json({ success: true });
    } catch (error) {
        console.error('Error promoting user:', error);
        res.status(500).json({ error: error.message || "Error promoting user" });
    }
});

// Session management routes
app.get("/group-study/room/:roomId/sessions/active", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        const activeSession = await getActiveSession(db, parseInt(roomId));

        if (activeSession) {
            const participants = await getSessionParticipants(db, activeSession.id);
            activeSession.participants = participants;
        }

        res.json({ session: activeSession });
    } catch (error) {
        console.error('Error getting active session:', error);
        res.status(500).json({ error: "Error getting active session" });
    }
});

app.post("/group-study/sessions/:sessionId/start", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const session = await startSession(db, parseInt(sessionId), req.user.id);

        io.to(`room_${session.room_id}`).emit('session_started', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error starting session:', error);
        res.status(500).json({ error: error.message || "Error starting session" });
    }
});

app.post("/group-study/sessions/:sessionId/end", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const session = await endSession(db, parseInt(sessionId), req.user.id);

        io.to(`room_${session.room_id}`).emit('session_ended', session);

        res.json({ success: true, session });
    } catch (error) {
        console.error('Error ending session:', error);
        res.status(500).json({ error: error.message || "Error ending session" });
    }
});

app.post("/group-study/sessions/:sessionId/sync", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { position } = req.body;

        await updateSessionPosition(db, parseInt(sessionId), req.user.id, position);

        // Broadcast sync to room
        const sessionResult = await db.query('SELECT room_id FROM study_sessions WHERE id = $1', [sessionId]);
        if (sessionResult.rows.length > 0) {
            io.to(`room_${sessionResult.rows[0].room_id}`).emit('position_synced', {
                sessionId: parseInt(sessionId),
                userId: req.user.id,
                position
            });
        }

        res.json({ success: true });
    } catch (error) {
        console.error('Error syncing position:', error);
        res.status(500).json({ error: "Error syncing position" });
    }
});

app.post("/group-study/sessions/:sessionId/answer", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { answer, questionIndex, correct } = req.body;

        // Get session info
        const sessionResult = await db.query(
            'SELECT ss.*, rc.room_id FROM study_sessions ss JOIN study_rooms sr ON ss.room_id = sr.id LEFT JOIN room_content rc ON rc.id = ss.content_id WHERE ss.id = $1',
            [sessionId]
        );

        if (sessionResult.rows.length === 0) {
            return res.status(404).json({ error: "Session not found" });
        }

        const session = sessionResult.rows[0];

        // Broadcast answer to room
        io.to(`room_${session.room_id}`).emit('answer_submitted', {
            sessionId: parseInt(sessionId),
            userId: req.user.id,
            questionIndex,
            answer,
            correct
        });

        res.json({ success: true });
    } catch (error) {
        console.error('Error submitting answer:', error);
        res.status(500).json({ error: "Error submitting answer" });
    }
});

// Annotation routes
app.post("/group-study/content/:contentId/annotate", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const { annotationText, positionStart, positionEnd } = req.body;

        const annotation = await addAnnotation(db, {
            roomContentId: parseInt(contentId),
            userId: req.user.id,
            annotationText,
            positionStart: parseInt(positionStart),
            positionEnd: parseInt(positionEnd)
        });

        // Get room ID for broadcasting
        const contentResult = await db.query('SELECT room_id FROM room_content WHERE id = $1', [contentId]);
        if (contentResult.rows.length > 0) {
            io.to(`room_${contentResult.rows[0].room_id}`).emit('annotation_added', annotation);
        }

        res.json({ success: true, annotation });
    } catch (error) {
        console.error('Error adding annotation:', error);
        res.status(500).json({ error: "Error adding annotation" });
    }
});

// Get content with annotations (GENERIC route - must come LAST)
app.get("/group-study/content/:contentId", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const contentResult = await db.query(
            `SELECT rc.*, u.name as shared_by_name
             FROM room_content rc
             JOIN users u ON rc.shared_by = u.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).json({ error: "Content not found" });
        }

        const content = contentResult.rows[0];
        const annotations = await getAnnotations(db, parseInt(contentId));

        res.json({ content, annotations });
    } catch (error) {
        console.error('Error getting content:', error);
        res.status(500).json({ error: "Error getting content" });
    }
});

// Analytics routes
app.get("/group-study/room/:roomId/analytics", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId } = req.params;

        // Verify user is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const analytics = await getRoomAnalytics(db, parseInt(roomId));
        const streaks = await getStudyStreaks(db, req.user.id, parseInt(roomId));

        res.json({ analytics, streaks });
    } catch (error) {
        console.error('Error getting analytics:', error);
        res.status(500).json({ error: "Error getting analytics" });
    }
});

app.get("/group-study/room/:roomId/analytics/user/:userId", ensureAuthenticated, async (req, res) => {
    try {
        const { roomId, userId } = req.params;

        // Verify requester is member
        const isMember = await isRoomMember(db, parseInt(roomId), req.user.id);
        if (!isMember) {
            return res.status(403).json({ error: "Not a member of this room" });
        }

        const userAnalytics = await getUserAnalytics(db, parseInt(roomId), parseInt(userId));
        const streaks = await getStudyStreaks(db, parseInt(userId), parseInt(roomId));

        res.json({ analytics: userAnalytics, streaks });
    } catch (error) {
        console.error('Error getting user analytics:', error);
        res.status(500).json({ error: "Error getting user analytics" });
    }
});

// Session notes and summaries
app.post("/group-study/sessions/:sessionId/notes", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { notesText } = req.body;

        const notes = await saveSessionNotes(db, parseInt(sessionId), req.user.id, notesText);

        res.json({ success: true, notes });
    } catch (error) {
        console.error('Error saving session notes:', error);
        res.status(500).json({ error: "Error saving session notes" });
    }
});

app.get("/group-study/sessions/:sessionId/notes", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const notes = await getSessionNotes(db, parseInt(sessionId));

        res.json({ notes });
    } catch (error) {
        console.error('Error getting session notes:', error);
        res.status(500).json({ error: "Error getting session notes" });
    }
});

app.get("/group-study/sessions/:sessionId/summary", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const summary = await getSessionSummary(db, parseInt(sessionId));

        res.json({ summary });
    } catch (error) {
        console.error('Error getting session summary:', error);
        res.status(500).json({ error: error.message || "Error getting session summary" });
    }
});

// Get quiz leaderboard
app.get("/group-study/quiz/leaderboard/:contentId", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const leaderboard = await getQuizLeaderboard(db, parseInt(contentId));
        res.json({ leaderboard });
    } catch (error) {
        console.error('Error getting leaderboard:', error);
        res.status(500).json({ error: "Error getting leaderboard" });
    }
});

// IMPORTANT: More specific routes must come BEFORE generic routes
// Synchronized session view for flashcards/quizzes
app.get("/group-study/content/:contentId/session", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;
        const { type } = req.query;

        const contentResult = await db.query(
            `SELECT rc.*, sr.id as room_id, sr.name as room_name
             FROM room_content rc
             JOIN study_rooms sr ON rc.room_id = sr.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).send("Content not found");
        }

        const content = contentResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, content.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Get active session or create one
        let session = await getActiveSession(db, content.room_id);

        if (!session) {
            // Create a new session for this content
            session = await createStudySession(db, {
                roomId: content.room_id,
                title: `Study Session: ${content.title || content.topic}`,
                description: `Synchronized ${type} session`,
                scheduledAt: new Date(),
                durationMinutes: 60,
                createdBy: req.user.id
            });

            // Start it immediately
            session = await startSession(db, session.id, req.user.id);
        }

        const participants = await getSessionParticipants(db, session.id);

        res.render("group-study-session.ejs", {
            user: req.user,
            content: content,
            session: session,
            participants: participants,
            contentType: type
        });
    } catch (error) {
        console.error('Error loading session:', error);
        res.status(500).send("Error loading session");
    }
});

// Get content annotations (must come before generic content route)
app.get("/group-study/content/:contentId/annotations", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const annotations = await getAnnotations(db, parseInt(contentId));

        res.json({ annotations });
    } catch (error) {
        console.error('Error getting annotations:', error);
        res.status(500).json({ error: "Error getting annotations" });
    }
});

// View/Edit content with collaborative editing (must come before generic content route)
app.get("/group-study/content/:contentId/edit", ensureAuthenticated, async (req, res) => {
    try {
        const { contentId } = req.params;

        const contentResult = await db.query(
            `SELECT rc.*, sr.id as room_id, sr.name as room_name
             FROM room_content rc
             JOIN study_rooms sr ON rc.room_id = sr.id
             WHERE rc.id = $1`,
            [contentId]
        );

        if (contentResult.rows.length === 0) {
            return res.status(404).send("Content not found");
        }

        const content = contentResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, content.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Only quicknotes can be collaboratively edited
        if (content.content_type !== 'quicknotes') {
            return res.status(400).send("Only notes can be collaboratively edited");
        }

        const annotations = await getAnnotations(db, parseInt(contentId));

        res.render("group-study-editor.ejs", {
            user: req.user,
            content: content,
            room: { id: content.room_id, name: content.room_name },
            annotations: annotations
        });
    } catch (error) {
        console.error('Error loading editor:', error);
        res.status(500).send("Error loading editor");
    }
});

// Get upcoming session reminders
app.get("/group-study/reminders", ensureAuthenticated, async (req, res) => {
    try {
        const upcoming = await getUpcomingSessions(db, req.user.id, 24);
        res.json({ sessions: upcoming });
    } catch (error) {
        console.error('Error getting reminders:', error);
        res.status(500).json({ error: "Error getting reminders" });
    }
});

// View session page
app.get("/group-study/session/:sessionId", ensureAuthenticated, async (req, res) => {
    try {
        const { sessionId } = req.params;

        const sessionResult = await db.query(
            `SELECT ss.*, sr.id as room_id, sr.name as room_name
             FROM study_sessions ss
             JOIN study_rooms sr ON ss.room_id = sr.id
             WHERE ss.id = $1`,
            [sessionId]
        );

        if (sessionResult.rows.length === 0) {
            return res.status(404).send("Session not found");
        }

        const session = sessionResult.rows[0];

        // Verify user is member
        const isMember = await isRoomMember(db, session.room_id, req.user.id);
        if (!isMember) {
            return res.status(403).send("Not a member of this room");
        }

        // Get associated content if any
        const contentResult = await db.query(
            'SELECT * FROM room_content WHERE room_id = $1 ORDER BY created_at DESC LIMIT 1',
            [session.room_id]
        );

        const participants = await getSessionParticipants(db, parseInt(sessionId));

        res.render("group-study-session.ejs", {
            user: req.user,
            content: contentResult.rows[0] || null,
            session: session,
            participants: participants,
            contentType: 'quiz' // Default, can be determined from content
        });
    } catch (error) {
        console.error('Error loading session:', error);
        res.status(500).send("Error loading session");
    }
});

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

// Admin middleware
function ensureAdmin(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'admin') return next();
    res.status(403).send('Forbidden');
}

// Admin: verify queue
app.get('/admin/verify', ensureAdmin, async (req, res) => {
    const [qRes, statsRes, conceptsRes] = await Promise.all([
        db.query(`SELECT * FROM questions WHERE status='pending' ORDER BY extracted_by_ai_at ASC LIMIT 1`),
        db.query(`SELECT status, COUNT(*) as count FROM questions GROUP BY status`),
        db.query(`SELECT id, name, subject FROM concepts ORDER BY subject, name`)
    ]);
    const stats = { pending: 0, approved: 0, rejected: 0 };
    statsRes.rows.forEach(r => { stats[r.status] = parseInt(r.count); });
    res.render('admin-verify.ejs', {
        question: qRes.rows[0] || null,
        stats,
        concepts: conceptsRes.rows
    });
});

// Admin: process verification action
app.post('/admin/verify/:id', ensureAdmin, async (req, res) => {
    const { id } = req.params;
    const { action, question_text, option1, option2, option3, option4, correct_answer, concept_id, difficulty_tier, solution_text } = req.body;

    if (action === 'reject') {
        await db.query(`UPDATE questions SET status='rejected', verified_by=$1, verified_at=NOW() WHERE id=$2`, [req.user.id, id]);
    } else {
        // approve or save_approve — always update fields for save_approve, only status for approve
        if (action === 'save_approve') {
            await db.query(`
                UPDATE questions SET
                    question_text=$1, option1=$2, option2=$3, option3=$4, option4=$5,
                    correct_answer=$6, concept_id=$7, difficulty_tier=$8, solution_text=$9,
                    status='approved', verified_by=$10, verified_at=NOW(), updated_at=NOW()
                WHERE id=$11`,
                [question_text, option1, option2, option3, option4, correct_answer, concept_id, parseInt(difficulty_tier), solution_text, req.user.id, id]
            );
        } else {
            await db.query(`UPDATE questions SET status='approved', verified_by=$1, verified_at=NOW() WHERE id=$2`, [req.user.id, id]);
        }
    }
    res.redirect('/admin/verify');
});

// Admin: payouts dashboard
app.get('/admin/payouts', ensureAdmin, async (req, res) => {
    const result = await db.query(`
        SELECT u.name, COUNT(q.id) as approved_count
        FROM questions q JOIN users u ON q.verified_by = u.id
        WHERE q.status='approved' AND q.verified_at > NOW() - INTERVAL '7 days'
        GROUP BY u.name ORDER BY approved_count DESC
    `);
    res.render('admin-payouts.ejs', { payouts: result.rows, rate: 25 });
});

// ── BKT Admin: EM Parameter Learning ──

// Trigger EM fitting (learns BKT params from student data)
app.post('/api/bkt/fit', ensureAdmin, async (req, res) => {
    try {
        const result = await bktFit('admin');
        res.json(result);
    } catch (err) {
        console.error('BKT fit error:', err.message);
        res.status(500).json({ error: 'BKT fitting failed', details: err.message });
    }
});

// Dry-run EM fitting (no DB writes, just prints results)
app.post('/api/bkt/fit-dry', ensureAdmin, async (req, res) => {
    try {
        const result = await bktFitDry();
        res.json(result);
    } catch (err) {
        console.error('BKT fit-dry error:', err.message);
        res.status(500).json({ error: 'BKT dry-run failed', details: err.message });
    }
});

// Get BKT params for a specific concept
app.get('/api/bkt/params/:conceptId', ensureAdmin, async (req, res) => {
    try {
        const result = await bktGetParams(req.params.conceptId);
        res.json(result);
    } catch (err) {
        console.error('BKT params error:', err.message);
        res.status(500).json({ error: 'Failed to get BKT params', details: err.message });
    }
});

// List all learned BKT params
app.get('/api/bkt/params', ensureAdmin, async (req, res) => {
    try {
        const result = await bktGetAllParams();
        res.json(result);
    } catch (err) {
        console.error('BKT all params error:', err.message);
        res.status(500).json({ error: 'Failed to get all BKT params', details: err.message });
    }
});

// Force reload learned params into BKT cache
app.post('/api/bkt/reload-params', ensureAdmin, async (req, res) => {
    try {
        const result = await bktReloadParams();
        res.json(result);
    } catch (err) {
        console.error('BKT reload error:', err.message);
        res.status(500).json({ error: 'Failed to reload BKT params', details: err.message });
    }
});

// ============================================================
// Syllabus Tracker API Routes
// ============================================================

// POST /api/syllabus/mark — Mark a chapter as taught for a batch
app.post('/api/syllabus/mark', ensureInstituteUser, async (req, res) => {
    try {
        const { chapterId, batchId } = req.body;
        if (!chapterId || !batchId) {
            return res.status(400).json({ error: 'chapterId and batchId are required' });
        }

        // Validate batch belongs to teacher's institute
        const batchCheck = await db.query(
            'SELECT b.id FROM batches b WHERE b.id = $1 AND b.institute_id = $2',
            [batchId, req.user.institute_id]
        );
        if (batchCheck.rows.length === 0) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const result = await db.query(
            `INSERT INTO chapter_teaching_status (chapter_id, batch_id, teacher_id)
             VALUES ($1, $2, $3)
             RETURNING chapter_id, batch_id, teacher_id, marked_at`,
            [chapterId, batchId, req.user.id]
        );

        res.status(201).json(result.rows[0]);
    } catch (err) {
        if (err.code === '23505') {
            return res.status(409).json({ error: 'Chapter already marked as taught for this batch' });
        }
        console.error('Mark chapter error:', err.message);
        res.status(500).json({ error: 'Failed to mark chapter', details: err.message });
    }
});

// DELETE /api/syllabus/unmark — Unmark a chapter as taught for a batch
app.delete('/api/syllabus/unmark', ensureInstituteUser, async (req, res) => {
    try {
        const { chapterId, batchId } = req.body;
        if (!chapterId || !batchId) {
            return res.status(400).json({ error: 'chapterId and batchId are required' });
        }

        // Validate batch belongs to teacher's institute
        const batchCheck = await db.query(
            'SELECT b.id FROM batches b WHERE b.id = $1 AND b.institute_id = $2',
            [batchId, req.user.institute_id]
        );
        if (batchCheck.rows.length === 0) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const result = await db.query(
            `DELETE FROM chapter_teaching_status
             WHERE chapter_id = $1 AND batch_id = $2`,
            [chapterId, batchId]
        );

        if (result.rowCount === 0) {
            return res.status(404).json({ error: 'Teaching status not found' });
        }

        res.json({ success: true });
    } catch (err) {
        console.error('Unmark chapter error:', err.message);
        res.status(500).json({ error: 'Failed to unmark chapter', details: err.message });
    }
});

// GET /api/syllabus/status/:batchId — Get all teaching statuses for a batch
app.get('/api/syllabus/status/:batchId', ensureInstituteUser, async (req, res) => {
    try {
        const { batchId } = req.params;

        // Validate batch belongs to teacher's institute
        const batchCheck = await db.query(
            'SELECT b.id FROM batches b WHERE b.id = $1 AND b.institute_id = $2',
            [batchId, req.user.institute_id]
        );
        if (batchCheck.rows.length === 0) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const result = await db.query(
            `SELECT chapter_id, teacher_id, marked_at
             FROM chapter_teaching_status
             WHERE batch_id = $1`,
            [batchId]
        );

        res.json({ batchId: parseInt(batchId), statuses: result.rows });
    } catch (err) {
        console.error('Get syllabus status error:', err.message);
        res.status(500).json({ error: 'Failed to get syllabus status', details: err.message });
    }
});

// GET /api/syllabus/delta/:batchId — Get taught chapters with batch mastery + warnings
app.get('/api/syllabus/delta/:batchId', ensureInstituteUser, async (req, res) => {
    try {
        const { batchId } = req.params;

        // Validate batch belongs to teacher's institute
        const batchCheck = await db.query(
            'SELECT b.id FROM batches b WHERE b.id = $1 AND b.institute_id = $2',
            [batchId, req.user.institute_id]
        );
        if (batchCheck.rows.length === 0) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        // Get total chapter count
        const totalResult = await db.query('SELECT COUNT(*) AS count FROM chapters');
        const totalChapters = parseInt(totalResult.rows[0].count);

        // Single aggregated query for taught chapters with batch mastery and warning flags
        const deltaResult = await db.query(`
            WITH taught AS (
                SELECT cts.chapter_id
                FROM chapter_teaching_status cts
                WHERE cts.batch_id = $1
            ),
            batch_students_list AS (
                SELECT bs.student_id
                FROM batch_students bs
                WHERE bs.batch_id = $1
            ),
            chapter_concepts AS (
                SELECT t.chapter_id, c.id AS concept_id
                FROM taught t
                JOIN concepts c ON c.chapter_id = t.chapter_id
            ),
            student_concept_mastery AS (
                SELECT
                    cc.chapter_id,
                    bsl.student_id,
                    cc.concept_id,
                    COALESCE(ucm.mastery, 0.2) AS mastery
                FROM chapter_concepts cc
                CROSS JOIN batch_students_list bsl
                LEFT JOIN user_concept_mastery ucm
                    ON ucm.user_id = bsl.student_id
                    AND ucm.concept_id = cc.concept_id
            ),
            student_chapter_mastery AS (
                SELECT
                    chapter_id,
                    student_id,
                    AVG(mastery) AS student_mastery
                FROM student_concept_mastery
                GROUP BY chapter_id, student_id
            ),
            chapter_stats AS (
                SELECT
                    scm.chapter_id,
                    AVG(scm.student_mastery) AS batch_mastery,
                    COUNT(*) FILTER (WHERE scm.student_mastery < 0.5)::float
                        / NULLIF(COUNT(*), 0) AS students_below_50
                FROM student_chapter_mastery scm
                GROUP BY scm.chapter_id
            )
            SELECT
                ch.id AS chapter_id,
                ch.name AS chapter_name,
                COALESCE(cs.batch_mastery, 0.2) AS batch_mastery,
                COALESCE(cs.students_below_50, 1.0) AS students_below_50,
                CASE WHEN COALESCE(cs.students_below_50, 1.0) >= 0.8 THEN true ELSE false END AS is_warning
            FROM taught t
            JOIN chapters ch ON ch.id = t.chapter_id
            LEFT JOIN chapter_stats cs ON cs.chapter_id = t.chapter_id
            ORDER BY COALESCE(cs.batch_mastery, 0.2) ASC
        `, [batchId]);

        res.json({
            batchId: parseInt(batchId),
            totalChapters,
            taughtCount: deltaResult.rows.length,
            taughtChapters: deltaResult.rows.map(r => ({
                chapter_id: r.chapter_id,
                chapter_name: r.chapter_name,
                batch_mastery: parseFloat(r.batch_mastery),
                students_below_50: parseFloat(r.students_below_50),
                is_warning: r.is_warning
            }))
        });
    } catch (err) {
        console.error('Get syllabus delta error:', err.message);
        res.status(500).json({ error: 'Failed to get syllabus delta', details: err.message });
    }
});

// ============================================================
// Report Card API Route
// ============================================================

// GET /api/report-card/:studentId — Generate and stream PDF report card
app.get('/api/report-card/:studentId', ensureInstituteUser, async (req, res) => {
    try {
        const studentId = parseInt(req.params.studentId);
        if (isNaN(studentId)) {
            return res.status(400).json({ error: 'Invalid studentId' });
        }

        // Validate that the student belongs to the same institute as the requesting user
        const studentCheck = await db.query(
            'SELECT id, institute_id FROM users WHERE id = $1',
            [studentId]
        );
        if (studentCheck.rows.length === 0) {
            return res.status(404).json({ error: 'Student not found' });
        }
        if (studentCheck.rows[0].institute_id !== req.user.institute_id) {
            return res.status(403).json({ error: 'Forbidden' });
        }

        const reportData = await compileReportData(db, studentId, req.user.institute_id);
        const pdfDoc = generateReportPDF(reportData);

        const safeName = sanitizeFilename(reportData.studentName);
        const dateStr = reportData.generatedAt.toISOString().split('T')[0];
        const filename = `${safeName}_report_card_${dateStr}.pdf`;

        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);

        pdfDoc.pipe(res);
    } catch (err) {
        console.error('Report card generation error:', err.message);
        if (!res.headersSent) {
            res.status(500).json({ error: 'Failed to generate report card. Please try again.' });
        }
    }
});

// Start the server
await ensureBktService(process.env.BKT_BASE_URL || 'http://127.0.0.1:8000');
httpServer.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

