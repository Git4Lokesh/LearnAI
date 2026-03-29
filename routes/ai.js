import express from 'express';
import { ensureAuthenticated } from '../middleware/auth.js';
import { aiRateLimiter } from '../middleware/aiRateLimit.js';
import { generateHint, generateDiagnosis, generateChatResponse } from '../services/aiTutorService.js';

const router = express.Router();

// POST /api/ai/hint — BKT-aware personalized hint on wrong answer
router.post('/api/ai/hint', ensureAuthenticated, aiRateLimiter, async (req, res) => {
    try {
        const { questionText, option1, option2, option3, option4, correctAnswer, selectedAnswer, conceptId, conceptName } = req.body;
        if (!questionText || !option1 || !option2 || !option3 || !option4 || !correctAnswer || !selectedAnswer || !conceptId || !conceptName) {
            return res.status(400).json({ error: 'Missing required fields' });
        }
        const result = await generateHint({
            userId: req.user.id, questionText, option1, option2, option3, option4,
            correctAnswer, selectedAnswer, conceptId, conceptName
        });
        res.json(result);
    } catch (e) {
        console.error('AI hint error:', e);
        res.status(500).json({ error: 'Failed to generate hint', hint: 'Hint temporarily unavailable.' });
    }
});

// POST /api/ai/diagnose — AI prerequisite diagnosis explanation
router.post('/api/ai/diagnose', ensureAuthenticated, aiRateLimiter, async (req, res) => {
    try {
        const { conceptId } = req.body;
        if (!conceptId) return res.status(400).json({ error: 'conceptId is required' });
        const result = await generateDiagnosis({ userId: req.user.id, conceptId });
        res.json(result);
    } catch (e) {
        console.error('AI diagnose error:', e);
        res.status(500).json({ error: 'Failed to generate diagnosis' });
    }
});

// POST /api/ai/chat — AI study plan chatbot
router.post('/api/ai/chat', ensureAuthenticated, aiRateLimiter, async (req, res) => {
    try {
        const { message } = req.body;
        if (!message || !message.trim()) return res.status(400).json({ error: 'Message is required' });

        if (!req.session.aiChatHistory) req.session.aiChatHistory = [];

        // Pass current concept context if available (from practice page)
        const currentConcept = req.body.currentConcept || null;
        const currentConceptId = req.body.currentConceptId || null;
        const currentQuestion = req.body.currentQuestion || null;

        const result = await generateChatResponse({
            userId: req.user.id,
            message: message.trim(),
            conversationHistory: req.session.aiChatHistory,
            currentConcept,
            currentConceptId,
            currentQuestion
        });

        // Append to session history
        req.session.aiChatHistory.push({ role: 'user', content: message.trim() });
        req.session.aiChatHistory.push({ role: 'assistant', content: result.response });

        // Keep history manageable (last 20 messages)
        if (req.session.aiChatHistory.length > 20) {
            req.session.aiChatHistory = req.session.aiChatHistory.slice(-20);
        }

        res.json(result);
    } catch (e) {
        console.error('AI chat error:', e);
        res.status(500).json({ error: 'Failed to generate response', response: 'Something went wrong. Please try again.' });
    }
});

export default router;
