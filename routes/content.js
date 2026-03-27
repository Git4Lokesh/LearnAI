import express from 'express';
import multer from 'multer';
import rateLimit from 'express-rate-limit';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';
import { geminiGenerate, generateSingleQuestion } from '../helpers/gemini.js';
import { processMathContent } from '../helpers/mastery.js';
import { extractTextFromPDF } from '../services/pdfService.js';
import { bktUpdate, bktNext } from '../services/bktClient.js';
import { YoutubeTranscript } from "@danielxceron/youtube-transcript";

const router = express.Router();

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

const generateLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 10, standardHeaders: true, legacyHeaders: false });
const expandLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 50, standardHeaders: true, legacyHeaders: false });

// Main generation route
router.post("/generate", generateLimiter, ensureAuthenticated, upload.single('document'), async (req, res) => {
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
                    "You are an expert educator. Create study materials in HTML format with proper tags. Start directly with the educational content. For ALL mathematical expressions, use proper notation enclosed in $ (e.g., $x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$)",
                    `Write extremely thorough study notes on ${topic} for ${level} level students. The student should be able to revise this for exams.\n\nFormat Requirements:\n- Start with a clear definition\n- Use HTML tags: <h1>, <h2>, <h3> for headings\n- Use <strong> for bold, <em> for italic\n- Use <p> for paragraphs and <br> for line breaks\n- Use <ul><li> for bullet points\n- Add practical examples\n- If mathematical in nature, include example problems with solutions formatted in $...$ notation\n- ALL mathematical expressions MUST use proper notation enclosed in $\n\nTopic: ${topic}\nLevel: ${level}`
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
                    "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. ALL mathematical expressions MUST use proper notation enclosed in $ (e.g., $\\frac{1}{2}$)",
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
                    "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text, explanations, or markdown fences. Each question must have exactly 4 distinct, plausible options with one clearly correct answer. ALL mathematical expressions MUST use proper notation enclosed in $",
                    `Create a 10-question multiple choice quiz about ${topic} for ${level} school students.\n\nRequirements:\n- Format: JSON array only, no other text, no markdown\n- Each question must have: question, option1, option2, option3, option4, answer\n- Answer field must specify which option is correct (e.g., "option2")\n- ALL mathematical expressions MUST use proper notation enclosed in $\n\nTopic: ${topic}\nGrade Level: ${level}`,
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
                    "You are an expert educator specializing in analyzing comprehensive academic course materials. Transform content into well-organized study notes with HTML formatting. ALL mathematical expressions MUST use proper notation enclosed in $",
                    `Transform the following comprehensive course material into detailed study notes for ${level} level students:\n\nCOMPREHENSIVE COURSE MATERIAL:\n${extractedText}\n\nCreate study notes with these requirements:\n- Use HTML formatting: <h2>, <h3>, <p>, <ul>, <li>, <strong>\n- Preserve mathematical formulas in $...$ notation\n- Structure content logically for exam preparation`
                );
                res.render("quicknotes.ejs", { topic: "Course Material Analysis", gradeLevel: level, content: pdfNoteContent });
            }
            else if (type === "flashcards") {
                const pdfFcRaw = await geminiGenerate(
                    "You are an expert educator creating flashcards from course material. Return only a JSON array of objects with 'question' and 'answer' properties. No markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $",
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
                    "You are an expert educational assessment creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text or markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $",
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
                    "You are an expert educator. Create study materials in HTML format with proper tags. Start directly with the educational content. ALL mathematical expressions MUST use proper notation enclosed in $",
                    `Write extremely thorough study notes from this YouTube video transcript for ${level} level students:\n\n${fullText}\n\nUse HTML tags: <h1>, <h2>, <h3>, <p>, <ul>, <li>, <strong>. ALL math in $...$ notation.`
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
                    "Create flashcards in JSON format. Return only a JSON array of objects with 'question' and 'answer' properties. No markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $",
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
                    "You are an expert educational content creator. Generate quiz questions in strict JSON format. Return ONLY a valid JSON array with no additional text or markdown fences. ALL mathematical expressions MUST use proper notation enclosed in $",
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
router.post("/flashcard", ensureAuthenticated, (req, res) => {
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
router.post("/quiz", ensureAuthenticated, async (req, res) => {
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
- If referencing mathematical concepts, use $...$ proper latex notation`;

    const analysisText = await geminiGenerate(
        `You are an expert educator in ${req.session.topic}. Analyze quiz data and provide actionable insights. For mathematical expressions, use $...$ notation.`,
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
router.post('/api/expand-text', ensureAuthenticated, expandLimiter, async (req, res) => {
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
router.post("/save-quicknotes", ensureAuthenticated, async (req, res) => {
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

router.post("/save-flashcards", ensureAuthenticated, async (req, res) => {
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

router.post("/save-quiz", ensureAuthenticated, async (req, res) => {
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
router.get("/saved-content", ensureAuthenticated, (req, res) => {
    res.render("saved-content.ejs");
});

// API routes for saved content
router.get("/api/quicknotes", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM quicknotes WHERE user_id=$1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching quicknotes:', error);
        res.status(500).json({ error: 'Failed to fetch quicknotes' });
    }
});

// Fetch single quicknote (for preview/export)
router.get("/api/quicknotes/:id", ensureAuthenticated, async (req, res) => {
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

router.get("/api/flashcards", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM flashcards WHERE user_id = $1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching flashcards:', error);
        res.status(500).json({ error: 'Failed to fetch flashcards' });
    }
});

// Fetch single flashcard set (for export)
router.get("/api/flashcards/:id", ensureAuthenticated, async (req, res) => {
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

router.get("/api/quiz", ensureAuthenticated, async (req, res) => {
    try {
        const response = await db.query("SELECT * FROM quiz WHERE user_id = $1 ORDER BY created_at DESC", [req.user.id]);
        res.json(response.rows);
    } catch (error) {
        console.error('Error fetching quizzes:', error);
        res.status(500).json({ error: 'Failed to fetch quizzes' });
    }
});

// Fetch single quiz (for export)
router.get("/api/quiz/:id", ensureAuthenticated, async (req, res) => {
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
router.get('/export/quicknotes/:id', ensureAuthenticated, async (req, res) => {
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

router.get('/export/flashcards/:id', ensureAuthenticated, async (req, res) => {
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

router.get('/export/quiz/:id', ensureAuthenticated, async (req, res) => {
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
router.get("/view-quicknote/:id", ensureAuthenticated, async (req, res) => {
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

router.get("/view-flashcards/:id", ensureAuthenticated, async (req, res) => {
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

router.get("/view-quiz/:id", ensureAuthenticated, async (req, res) => {
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
router.delete("/delete-content/quicknotes/:id", ensureAuthenticated, async (req, res) => {
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

router.delete("/delete-content/flashcards/:id", ensureAuthenticated, async (req, res) => {
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

router.delete("/delete-content/quiz/:id", ensureAuthenticated, async (req, res) => {
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

export default router;
