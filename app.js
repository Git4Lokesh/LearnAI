import axios from "axios";
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
import {Strategy} from 'passport-local';
import { bktUpdate, bktNext } from './services/bktClient.js';
import { ensureBktService } from './services/bktRunner.js';
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


const db = new pg.Client({
  host:  'localhost',        
  port: 5432,       
  user: 'postgres',         
  password:  process.env.db_password,  
  database: 'Content Storage',     
});


await db.connect();

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
    const resp = await axios.post("https://api.perplexity.ai/chat/completions", {
        model: "sonar-pro",
        messages: [system, user]
    }, {
        headers: { Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}` }
    });
    const content = resp.data.choices[0].message.content;
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
        const matchIndex = [1,2,3,4].find(i => normalized[`option${i}`].toLowerCase() === ansText);
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

// Routes

// Handle favicon requests to prevent 404 errors
app.get("/favicon.ico", (req, res) => {
    res.status(204).end(); 
});

app.get("/", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query(`
            SELECT SUM(row_count) AS total_rows FROM (
                SELECT COUNT(*) AS row_count FROM quiz WHERE user_id=$1
                UNION ALL
                SELECT COUNT(*) AS row_count FROM quicknotes where user_id=$1
                UNION ALL
                SELECT COUNT(*) AS row_count FROM flashcards where user_id=$1
            ) AS counts
        `, [req.user.id]);
        
        const savedContentCount = parseInt(response.rows[0].total_rows) || 0;
        
        res.render("dashboard.ejs", {
            savedContentCount: savedContentCount,
            user: req.user
        });
    } catch (error) {
        console.error('Error counting saved content:', error);
        res.render("dashboard.ejs", {
            savedContentCount: 0,
            user: req.user
        });
    }
});

app.get("/signup", (req, res) => {
    res.render("signup.ejs");
});

app.get("/login", (req, res) => {
    res.render("login.ejs");
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
    console.log("=== LOGIN ATTEMPT ===");
    console.log("Email:", req.body.email);
    console.log("Password provided:", !!req.body.password);
    
    passport.authenticate("local", (err, user, info) => {
        console.log("Passport callback - Error:", err);
        console.log("Passport callback - User:", !!user);
        console.log("Passport callback - Info:", info);
        
        if (err) {
            console.error("Authentication error:", err);
            return next(err);
        }
        
        if (!user) {
            console.log("Authentication failed - no user returned");
            return res.redirect("/login?error=invalid");
        }
        
        req.logIn(user, (loginErr) => {
            if (loginErr) {
                console.error("Login error:", loginErr);
                return next(loginErr);
            }
            console.log("✅ Login successful - redirecting to dashboard");
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

// Passport configuration
passport.use(new Strategy({
    usernameField: 'email',
    passwordField: 'password'
}, async function(email, password, done) {
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
// Main generation route
app.post("/generate", ensureAuthenticated, upload.single('document'), async (req, res) => {
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
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educator. Create study materials in HTML format with proper tags. Never show your research process or mention search results. Start directly with the educational content. For ALL mathematical expressions, use proper notation enclosed in $$ (e.g., $$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$)"
                        },
                        {
                            "role": "user",
                            "content": `Write extremely thorough study notes on ${topic} for ${level} level students. The student should be able to revise this for exams.

Format Requirements:
- Start with a clear definition
- Use HTML tags: <h1>, <h2>, <h3> for headings
- Use <strong> for bold, <em> for italic
- Use <p> for paragraphs and <br> for line breaks
- Use <ul><li> for bullet points
- Add practical examples
- No meta-commentary about sources
- No phrases like "based on the search results"
- If mathematical in nature, include example problems with solutions formatted in $$...$$ notation
- ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$E = mc^2$$)

Topic: ${topic}
Level: ${level}`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                req.session.content = response.data.choices[0].message.content
                res.render("quicknotes.ejs", {
                    topic: topic,
                    gradeLevel: level,
                    content: response.data.choices[0].message.content
                });
                
            } catch (error) {
                console.error("Quick notes error:", error.message);
                res.status(500).send("Failed to generate notes. Please try again.");
            }
        }
        else if (type === "flashcards") {
            try {
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    "model": "sonar-pro",
                    "messages": [
                        {
                            "role": "system",
                            "content": "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\frac{1}{2}$$)"
                        },
                        {
                            "role": "user",
                            "content": `Generate 10 flashcards for ${topic} at ${level} school level. Format as JSON array: [{"question": "...", "answer": "..."}].

Requirements:
- No meta-commentary about sources
- No phrases like "based on the search results"
- Include mathematical concepts in $$...$$ notation where needed
- ALL mathematical expressions MUST use proper notation enclosed in $$`
                        }
                    ]
                }, {
                    headers: {
                        "Authorization": `Bearer ${process.env.PERPLEXITY_API_KEY}`,
                        "Content-Type": "application/json"
                    }
                });
                
                const flashcards = JSON.parse(response.data.choices[0].message.content);
                
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
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text, explanations, or formatting. Each question must have exactly 4 distinct, plausible options with one clearly correct answer. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$x^2 + 5x + 6$$)"
                        },
                        {
                            "role": "user", 
                            "content": `Create a 10-question multiple choice quiz about ${topic} for ${level} school students.

Requirements:
- Format: JSON array only, no other text
- Each question must have: question, option1, option2, option3, option4, answer
- Answer field must specify which option is correct (e.g., "option2")
- All options should be plausible but only one correct
- Questions should test understanding, not just memorization
- Use clear, grade-appropriate language
- ONLY IF the topic is mathematical in nature or could have calculation based questions, include 3-4 questions which involve calculations
- ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\sqrt{25} = 5$$)

Example format:
[
    {
        "question": "What is the discriminant of the quadratic equation $$ax^2 + bx + c = 0$$?",
        "option1": "$$b^2 - 4ac$$",
        "option2": "$$-b \\pm \\sqrt{b^2 - 4ac}$$", 
        "option3": "$$4ac - b^2$$",
        "option4": "$$a^2 + b^2 + c^2$$",
        "answer": "option1"
    }
]

Topic: ${topic}
Grade Level: ${level}`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                const content = JSON.parse(response.data.choices[0].message.content);
                req.session.topic = topic;
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(topic) });
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
    else if(method === "pdf") {
        if (!req.file) {
            return res.status(400).send("Please upload a PDF file");
        }
        
        try {
            console.log("Processing PDF with LlamaParse API...");
            
            const formData = new FormData();
            formData.append('file', req.file.buffer, {
                filename: req.file.originalname,
                contentType: 'application/pdf'
            });
            
            const uploadResponse = await axios.post(
                'https://api.cloud.llamaindex.ai/api/v1/parsing/upload',
                formData,
                {
                    headers: {
                        'accept': 'application/json', 
                        'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}`,
                        ...formData.getHeaders()
                    }
                }
            );
            
            const jobId = uploadResponse.data.id;
            console.log("Upload successful, job ID:", jobId);
            
            let jobComplete = false;
            let attempts = 0;
            const maxAttempts = 30;
            
            while (!jobComplete && attempts < maxAttempts) {
                const statusResponse = await axios.get(
                    `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}`,
                    {
                        headers: {
                            'accept': 'application/json', 
                            'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` 
                        }
                    }
                );
                
                if (statusResponse.data.status === 'SUCCESS') {
                    jobComplete = true;
                } else if (statusResponse.data.status === 'ERROR') {
                    throw new Error('PDF parsing failed');
                } else {
                    await new Promise(resolve => setTimeout(resolve, 1000));
                    attempts++;
                }
            }
            
            if (!jobComplete) {
                throw new Error('PDF parsing timeout');
            }
            
            const resultResponse = await axios.get(
                `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}/result/markdown`,
                {
                    headers: {
                        'accept': 'application/json',
                        'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` 
                    }
                }
            );
            
            const extractedText = resultResponse.data.markdown;
            console.log("LlamaParse extraction successful, text length:", extractedText.length);
            
            if (!extractedText || extractedText.trim().length < 50) {
                return res.status(400).send("PDF content appears to be empty or too short. Please ensure the PDF contains readable text.");
            }
            
            if (type === "quicknotes") {
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educator specializing in analyzing comprehensive academic course materials. Transform content into well-organized study notes with HTML formatting. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$F = ma$$)"
                        },
                        {
                            "role": "user",
                            "content": `Transform the following comprehensive course material into detailed study notes for ${level} level students:

COMPREHENSIVE COURSE MATERIAL:
${extractedText}

Create study notes with these requirements:
- Use HTML formatting: <h2>, <h3>, <p>, <ul>, <li>, <strong>
- Preserve mathematical formulas in $$...$$ notation
- Structure content logically for exam preparation
- ALL mathematical expressions MUST use proper notation enclosed in $$

Format: Use HTML formatting with proper tags.`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                res.render("quicknotes.ejs", {
                    topic: "Course Material Analysis",
                    gradeLevel: level,
                    content: response.data.choices[0].message.content 
                });
            }
            else if (type === "flashcards") {
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    "model": "sonar-pro",
                    "messages": [
                        {
                            "role": "system",
                            "content": "You are an expert educator creating flashcards from comprehensive course material that includes properly extracted text, mathematical notation, table data, and visual element descriptions. Return only a JSON array of objects with 'question' and 'answer' properties. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\int x dx = \\frac{x^2}{2} + C$$)"
                        },
                        {
                            "role": "user",
                            "content": `Analyze the following comprehensive course material and create 10 high-quality flashcards for ${level} level students. This content includes properly extracted mathematical formulas, table data, and visual element descriptions.

COMPREHENSIVE COURSE MATERIAL:
${extractedText}

Requirements:
- Format as JSON array: [{"question": "...", "answer": "..."}]
- Include questions about key concepts, definitions, and important principles
- Include questions about mathematical formulas, equations, and calculations
- Create questions about data from tables and charts mentioned
- Include questions about visual elements and their significance
- Test both factual knowledge and conceptual understanding
- Use clear, ${level}-appropriate language
- Make answers comprehensive but concise
- Cover the full breadth of content including visual and mathematical elements
- Return only a valid JSON array.
- Do not include any Markdown code fences, explanations, or extra text.
- Output must start directly with '[' and end with ']'.
- Generate exactly 10 flashcards covering the most essential content from this material.
- ALL mathematical expressions MUST use proper notation enclosed in $$`
                        }
                    ]
                }, {
                    headers: {
                        "Authorization": `Bearer ${process.env.PERPLEXITY_API_KEY}`,
                        "Content-Type": "application/json"
                    }
                });
                
                const flashcards = JSON.parse(response.data.choices[0].message.content);
                
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
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educational assessment creator analyzing comprehensive course material with properly extracted mathematical notation, table data, and visual element descriptions. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text, explanations, or formatting. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$y = mx + b$$)"
                        },
                        {
                            "role": "user", 
                            "content": `Create a comprehensive 10-question multiple choice quiz based on the following extracted course material for ${level} students. This content includes mathematical formulas, table data, and visual element descriptions.

COMPREHENSIVE COURSE MATERIAL:
${extractedText}

Requirements:
- Format: JSON array only, no other text
- Each question must have: question, option1, option2, option3, option4, answer
- Answer field must specify which option is correct (e.g., "option2")
- All options should be plausible but only one correct
- Include questions about key definitions, principles, and applications
- Include questions about mathematical formulas and calculations when present
- Include questions about data from tables and charts
- Include questions about visual elements and their significance
- Test both factual recall and conceptual understanding
- Use clear, ${level}-appropriate language
- Cover different aspects of the comprehensive material provided
- ALL mathematical expressions MUST use proper notation enclosed in $$
- Generate exactly 10 questions covering the essential content from this course material.`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                const content = JSON.parse(response.data.choices[0].message.content);
                req.session.topic = "Course Material";
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(req.session.topic) });
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
            console.error("LlamaParse API error:", error.message);
            
            if (error.response?.status === 429) {
                return res.status(429).send("API rate limit reached. Please try again later.");
            }
            
            if (error.response?.status === 401) {
                return res.status(500).send("Authentication failed. Check your LLAMA_CLOUD_API_KEY.");
            }
            
            return res.status(500).send("Failed to process PDF. Please try again.");
        }
    }
    else if(method==="url")
    {
        console.log(url);
        const transcript = await YoutubeTranscript.fetchTranscript(url, { lang: 'en' })
        console.log(transcript);
        let fullText = transcript.map(item=>item.text).join(" ");
        if (type === "quicknotes") {
            try {
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educator. Create study materials in HTML format with proper tags. Never show your research process or mention search results. Start directly with the educational content. For ALL mathematical expressions, use proper notation enclosed in $$ (e.g., $$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$)"
                        },
                        {
                            "role": "user",
                            "content": `Write extremely thorough study notes from the transcript of an educational study video which is as follows: ${fullText} for ${level} level students. The student should be able to revise this for exams.

Format Requirements:
- Start with a clear definition
- Use HTML tags: <h1>, <h2>, <h3> for headings
- Use <strong> for bold, <em> for italic
- Use <p> for paragraphs and <br> for line breaks
- Use <ul><li> for bullet points
- Add practical examples
- No meta-commentary about sources
- No phrases like "based on the search results"
- If mathematical in nature, include example problems with solutions formatted in $$...$$ notation
- ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$E = mc^2$$)

Topic: ${url}
Level: ${level}`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                req.session.content = response.data.choices[0].message.content
                res.render("quicknotes.ejs", {
                    topic: "Youtube Video",
                    gradeLevel: level,
                    content: response.data.choices[0].message.content
                });
                
            } catch (error) {
                console.error("Quick notes error:", error.message);
                res.status(500).send("Failed to generate notes. Please try again.");
            }
        }
        else if (type === "flashcards") {
            try {
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    "model": "sonar-pro",
                    "messages": [
                        {
                            "role": "system",
                            "content": "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\frac{1}{2}$$)"
                        },
                        {
                            "role": "user",
                            "content": `Generate 10 flashcards using the transcript of a youtube video which is as follows: ${fullText} at ${level} school level. Format as JSON array: [{"question": "...", "answer": "..."}].

Requirements:
- No meta-commentary about sources
- No phrases like "based on the search results"
- Include mathematical concepts in $$...$$ notation where needed
- ALL mathematical expressions MUST use proper notation enclosed in $$`
                        }
                    ]
                }, {
                    headers: {
                        "Authorization": `Bearer ${process.env.PERPLEXITY_API_KEY}`,
                        "Content-Type": "application/json"
                    }
                });
                
                const flashcards = JSON.parse(response.data.choices[0].message.content);
                
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
                const response = await axios.post("https://api.perplexity.ai/chat/completions", {
                    model: "sonar-pro",
                    messages: [
                        {
                            "role": "system",
                            "content": "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text, explanations, or formatting. Each question must have exactly 4 distinct, plausible options with one clearly correct answer. ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$x^2 + 5x + 6$$)"
                        },
                        {
                            "role": "user", 
                            "content": `Create a 10-question multiple choice quiz from the transcript of a youtube video which is as follows: ${fullText} for ${level} school students.

Requirements:
- Format: JSON array only, no other text
- Each question must have: question, option1, option2, option3, option4, answer
- Answer field must specify which option is correct (e.g., "option2")
- All options should be plausible but only one correct
- Questions should test understanding, not just memorization
- Use clear, grade-appropriate language
- ONLY IF the topic is mathematical in nature or could have calculation based questions, include 3-4 questions which involve calculations
- ALL mathematical expressions MUST use proper notation enclosed in $$ (e.g., $$\\sqrt{25} = 5$$)

Example format:
[
    {
        "question": "What is the discriminant of the quadratic equation $$ax^2 + bx + c = 0$$?",
        "option1": "$$b^2 - 4ac$$",
        "option2": "$$-b \\pm \\sqrt{b^2 - 4ac}$$", 
        "option3": "$$4ac - b^2$$",
        "option4": "$$a^2 + b^2 + c^2$$",
        "answer": "option1"
    }
]

Topic: ${topic}
Grade Level: ${level}`
                        }
                    ]
                }, {
                    headers: {
                        Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
                    }
                });
                
                const content = JSON.parse(response.data.choices[0].message.content);
                req.session.topic = url;
                req.session.gradeLevel = level;
                req.session.content = content;
                let bktInfo = null;
                try {
                    bktInfo = await bktNext({ userId: String(req.user.id), skillId: String(url) });
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
    
    for(let i = 0; i < 10; i++) {
        userAnswers.push(req.body[`answer_${i}`]);
        if(req.body[`answer_${i}`] === req.session.content[i].answer) {
            score++;
        }
    }

    // Update BKT with each response under the current topic as the skill
    const skillId = String(req.session.topic);
    try {
        for (let i = 0; i < req.session.content.length; i++) {
            const correct = userAnswers[i] === req.session.content[i].answer;
            await bktUpdate({
                userId: String(req.user.id),
                skillId: skillId,
                correct: Boolean(correct)
            });
        }
    } catch (e) {
        console.warn('BKT update (submit) failed:', e.message || e);
    }
    let bktInfoAfter = null;
    try {
        bktInfoAfter = await bktNext({ userId: String(req.user.id), skillId: skillId });
    } catch (e) {
        console.warn('BKT next (submit) failed:', e.message || e);
    }

    const prompt = `Analyze this quiz performance:
        
Topic: ${req.session.topic}
Grade Level: ${req.session.gradeLevel}
Score: ${score}/${req.session.content.length}

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

    const analysis = await axios.post("https://api.perplexity.ai/chat/completions",{
        model:"sonar-pro",
        messages:[
            {
                role:"system",
                content:"You are an expert educator in "+req.session.topic+". Analyze quiz data and provide actionable insights. For mathematical expressions, use $$...$$ notation."
            },
            {
                role:"user",
                content:prompt
            }
        ]
    },{
        headers:{
            Authorization:`Bearer ${process.env.PERPLEXITY_API_KEY}`
        }
    })
    
    const processedAnalysis = processMathContent(analysis.data.choices[0].message.content);
    
    res.render("quiz.ejs",{
        topic:req.session.topic,
        gradeLevel:req.session.gradeLevel,
        content:req.session.content,
        showResults:showResults,
        userAnswers:userAnswers,
        score:score,
        performanceAnalysis: processedAnalysis,
        bktMastery: bktInfoAfter?.mastery,
        bktRecommendedDifficulty: bktInfoAfter?.recommendedDifficulty
    })
});

// Text expansion API
app.post('/api/expand-text', ensureAuthenticated, async (req, res) => {
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
        
        const response = await axios.post("https://api.perplexity.ai/chat/completions", {
            model: "sonar",
            messages: [
                {
                    role: "system",
                    content: "You are an expert educator providing detailed explanations for study materials. Use proper LaTeX formatting for mathematical expressions."
                },
                {
                    role: "user",
                    content: finalPrompt
                }
            ]
        }, {
            headers: {
                Authorization: `Bearer ${process.env.PERPLEXITY_API_KEY}`
            }
        });

        const expansion = response.data.choices[0].message.content;
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

// Export endpoints
app.get('/export/quicknotes/:id', ensureAuthenticated, async (req, res) => {
    try {
        const id = req.params.id;
        const response = await db.query("SELECT topic,grade_level,note_content,created_at FROM quicknotes WHERE id=$1 AND user_id=$2", [id, req.user.id]);
        if (response.rows.length === 0) {
            return res.status(404).send('Not found');
        }
        const note = response.rows[0];
        const fileName = `${note.topic.replace(/[^a-z0-9]+/gi,'_')}.html`;
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
        const fileName = `${set.topic.replace(/[^a-z0-9]+/gi,'_')}_flashcards.json`;
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
        const fileName = `${quiz.topic.replace(/[^a-z0-9]+/gi,'_')}_quiz.json`;
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
app.post("/api/chat", ensureAuthenticated, async (req, res) => {
    try {
        const { message, sessionId } = req.body;
        
        if (!message) {
            return res.status(400).json({ error: 'Message is required' });
        }
        
        // Import and call the chat function
        const { chatWithPerplexity } = await import('./services/chatService.js');
        
        const response = await chatWithPerplexity(
            message,
            req.user.id,
            sessionId || 'default'
        );
        
        res.json({ response });
    } catch (error) {
        console.error('Chat API error:', error);
        res.status(500).json({ error: 'Failed to get AI response' });
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

// Mastery Mode routes (single-question loop until mastery >= 0.95)
app.get('/master', ensureAuthenticated, async (req, res) => {
    res.render('master.ejs', {
        topic: req.session.masterTopic || '',
        gradeLevel: req.session.masterLevel || '',
        mastery: null,
        question: null,
        completed: false,
        message: null
    });
});

app.post('/master/start', ensureAuthenticated, upload.single('document'), async (req, res) => {
    try {
        const topic = req.body.topic;
        const level = req.body.gradeLevel;
        const method = req.body.inputMethod || (req.file ? 'pdf' : 'topic');
        if (!topic || !level) return res.status(400).send('Topic and level required');
        req.session.masterTopic = topic;
        req.session.masterLevel = level;
        req.session.masterContext = null;
        if (method === 'pdf') {
            if (!req.file) return res.status(400).send('Please upload a PDF file');
            try {
                const formData = new FormData();
                formData.append('file', req.file.buffer, {
                    filename: req.file.originalname,
                    contentType: 'application/pdf'
                });
                const uploadResponse = await axios.post(
                    'https://api.cloud.llamaindex.ai/api/v1/parsing/upload',
                    formData,
                    {
                        headers: {
                            'accept': 'application/json',
                            'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}`,
                            ...formData.getHeaders()
                        }
                    }
                );
                const jobId = uploadResponse.data.id;
                let done = false; let attempts = 0;
                while (!done && attempts < 30) {
                    const statusResponse = await axios.get(
                        `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}`,
                        { headers: { 'accept': 'application/json', 'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` } }
                    );
                    if (statusResponse.data.status === 'SUCCESS') done = true;
                    else if (statusResponse.data.status === 'ERROR') throw new Error('PDF parsing failed');
                    else { await new Promise(r => setTimeout(r, 1000)); attempts++; }
                }
                if (!done) throw new Error('PDF parsing timeout');
                const resultResponse = await axios.get(
                    `https://api.cloud.llamaindex.ai/api/v1/parsing/job/${jobId}/result/markdown`,
                    { headers: { 'accept': 'application/json', 'Authorization': `Bearer ${process.env.LLAMA_CLOUD_API_KEY}` } }
                );
                const extractedText = resultResponse.data.markdown;
                if (!extractedText || extractedText.trim().length < 50) {
                    return res.status(400).send('PDF content appears empty or too short.');
                }
                req.session.masterContext = extractedText;
            } catch (err) {
                console.error('Master PDF parse error:', err.message || err);
                return res.status(500).send('Failed to process PDF for mastery mode');
            }
        }
        let info = null;
        try { info = await bktNext({ userId: String(req.user.id), skillId: String(topic) }); } catch {}
        const mastery = info?.mastery ?? 0.2;
        const difficulty = info?.recommendedDifficulty || 'medium';
        const question = await generateSingleQuestion(topic, level, difficulty, req.session.masterContext || null);
        req.session.masterQuestion = question;
        res.render('master.ejs', {
            topic, gradeLevel: level,
            mastery, question,
            completed: false,
            message: null
        });
    } catch (e) {
        console.error('Master start error:', e);
        res.status(500).send('Failed to start mastery session');
    }
});

app.post('/master/answer', ensureAuthenticated, async (req, res) => {
    try {
        const topic = req.session.masterTopic;
        const level = req.session.masterLevel;
        const question = req.session.masterQuestion;
        if (!topic || !level || !question) return res.redirect('/master');
        const userAnswer = req.body.answer;
        const correct = userAnswer === question.answer;
        try {
            await bktUpdate({ userId: String(req.user.id), skillId: String(topic), correct: Boolean(correct) });
        } catch (e) {
            console.warn('BKT update (master) failed:', e.message || e);
        }
        let info = null;
        try { info = await bktNext({ userId: String(req.user.id), skillId: String(topic) }); } catch {}
        const mastery = info?.mastery ?? 0.2;
        if (mastery >= 0.95) {
            // Clear session so user can start a new topic cleanly
            req.session.masterQuestion = null;
            req.session.masterTopic = null;
            req.session.masterLevel = null;
            return res.render('master.ejs', {
                topic, gradeLevel: level,
                mastery, question: null,
                completed: true,
                message: 'Congratulations! You have mastered this topic.'
            });
        }
        const nextQuestion = await generateSingleQuestion(topic, level, info?.recommendedDifficulty || 'medium', req.session.masterContext || null);
        req.session.masterQuestion = nextQuestion;
        res.render('master.ejs', {
            topic, gradeLevel: level,
            mastery, question: nextQuestion,
            completed: false,
            message: correct ? 'Correct!' : 'Incorrect. Keep going!'
        });
    } catch (e) {
        console.error('Master answer error:', e);
        res.status(500).send('Failed to process answer');
    }
});

// BKT proxy endpoints
app.post('/api/bkt/update', ensureAuthenticated, async (req, res) => {
    try {
        const { skillId, correct, params } = req.body;
        if (!skillId || typeof correct === 'undefined') {
            return res.status(400).json({ error: 'skillId and correct are required' });
        }
        const result = await bktUpdate({
            userId: String(req.user.id),
            skillId: String(skillId),
            correct: Boolean(correct),
            params: params || {}
        });
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
        const result = await bktNext({
            userId: String(req.user.id),
            skillId: String(skillId)
        });
        res.json(result);
    } catch (err) {
        console.error('BKT next error:', err.message || err);
        res.status(500).json({ error: 'BKT next failed' });
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
    
    socket.on('note_edit', (data) => {
        // Broadcast note edits for collaborative editing
        const { roomId, roomContentId, edit } = data;
        // Save edit to database
        if (edit && edit.type && edit.position !== undefined) {
            db.query(
                `INSERT INTO room_notes_edits (room_content_id, user_id, edit_type, position, content)
                 VALUES ($1, $2, $3, $4, $5)`,
                [roomContentId, edit.userId, edit.type, edit.position, edit.content]
            ).catch(err => console.error('Error saving edit:', err));
        }
        socket.to(`room_${roomId}`).emit('note_edited', { roomContentId, edit });
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

