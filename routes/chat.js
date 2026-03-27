import express from 'express';
import multer from 'multer';
import rateLimit from 'express-rate-limit';
import { ensureAuthenticated } from '../middleware/auth.js';

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

const chatLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 30, standardHeaders: true, legacyHeaders: false });

router.get("/chat", ensureAuthenticated, (req, res) => {
    res.render("chat.ejs", {
        user: req.user
    });
});

router.post("/api/chat", ensureAuthenticated, chatLimiter, async (req, res) => {
    try {
        const { message, sessionId } = req.body;
        if (!message) return res.status(400).json({ error: 'Message is required' });
        const { chatWithPerplexityStream } = await import('../services/chatService.js');
        await chatWithPerplexityStream(message, req.user.id, sessionId || 'default', res);
    } catch (error) {
        console.error('Chat API error:', error);
        if (!res.headersSent) res.status(500).json({ error: 'Failed to get AI response' });
    }
});

router.post("/api/chat/upload-pdf", ensureAuthenticated, upload.single('document'), async (req, res) => {
    try {
        if (!req.file) return res.status(400).json({ error: 'PDF file required' });
        const { sessionId } = req.body;
        const { ingestPDFForSession } = await import('../services/chatService.js');
        const chunkCount = await ingestPDFForSession(req.file.buffer, req.file.originalname, req.user.id, sessionId || 'default');
        res.json({ success: true, chunks: chunkCount });
    } catch (error) {
        console.error('Chat PDF upload error:', error);
        res.status(500).json({ error: 'Failed to process PDF' });
    }
});

// Translation API endpoint
router.post("/api/translate", async (req, res) => {
    try {
        const { text, targetLanguage, sourceLanguage = 'en' } = req.body;

        if (!text) {
            return res.status(400).json({ error: 'Text is required' });
        }

        if (!targetLanguage) {
            return res.status(400).json({ error: 'Target language is required' });
        }

        const { translateText } = await import('../services/translationService.js');
        const translatedText = await translateText(text, targetLanguage, sourceLanguage);

        res.json({ translatedText });
    } catch (error) {
        console.error('Translation API error:', error);
        res.status(500).json({ error: 'Failed to translate text' });
    }
});

// Batch translation API endpoint
router.post("/api/translate/batch", async (req, res) => {
    try {
        const { texts, targetLanguage, sourceLanguage = 'en' } = req.body;

        if (!texts || !Array.isArray(texts)) {
            return res.status(400).json({ error: 'Texts array is required' });
        }

        if (!targetLanguage) {
            return res.status(400).json({ error: 'Target language is required' });
        }

        const { translateMultiple } = await import('../services/translationService.js');
        const translatedTexts = await translateMultiple(texts, targetLanguage, sourceLanguage);

        res.json({ translatedTexts });
    } catch (error) {
        console.error('Batch translation API error:', error);
        res.status(500).json({ error: 'Failed to translate texts' });
    }
});

export default router;
