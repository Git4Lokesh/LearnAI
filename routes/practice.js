import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';
import { getUserConceptMastery, masteryToTier, applyDecay } from '../helpers/mastery.js';
import { getQuestionFromDB } from '../helpers/questions.js';
import { bktUpdateConcept, bktNextConcept, bktUpdate, bktNext } from '../services/bktClient.js';
import { checkPrerequisiteGaps, getOptimalLearningPath } from '../services/prerequisiteService.js';
import { diagnosePrerequisites } from '../services/diagnosisEngine.js';
import { isSubconceptUnlocked } from '../services/gatingService.js';

const router = express.Router();

// Practice routes
router.get('/practice/:conceptId', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const [conceptRes, masteryRes] = await Promise.all([
            db.query('SELECT id, name, subject FROM concepts WHERE id=$1', [conceptId]),
            db.query('SELECT mastery, last_updated FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2', [req.user.id, conceptId])
        ]);
        if (!conceptRes.rows[0]) return res.status(404).send('Concept not found');

        // Prerequisite gating check
        const gateResult = await isSubconceptUnlocked(db, req.user.id, conceptId);
        if (!gateResult.unlocked) {
            return res.status(403).render('practice-locked.ejs', {
                concept: conceptRes.rows[0],
                reason: gateResult.reason,
                unmetPrereqs: gateResult.unmetPrereqs,
                user: req.user
            });
        }

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

router.post('/practice/:conceptId/answer', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const { correct, difficulty_tier, time_taken_seconds, question_id } = req.body;

        // Log the attempt
        if (question_id) {
            await db.query(
                'INSERT INTO user_question_attempts (user_id, question_id, correct, time_taken_seconds) VALUES ($1,$2,$3,$4)',
                [req.user.id, parseInt(question_id), correct, time_taken_seconds ? Math.round(Number(time_taken_seconds)) : null]
            );
        }

        // BKT service handles both mastery computation AND DB write via /update-concept
        const updated = await bktUpdateConcept({
            userId: req.user.id, skillId: conceptId,
            correct: Boolean(correct),
            difficulty_tier: Number(difficulty_tier) || 2,
            time_taken_seconds: time_taken_seconds ? Number(time_taken_seconds) : null
        });
        const newMastery = updated.posterior_mastery;

        // Read back the updated counts (BKT service already wrote mastery + incremented counts)
        const afterUpdate = await getUserConceptMastery(req.user.id, conceptId);
        const newQA = afterUpdate.questions_answered;
        const newCA = afterUpdate.correct_answers;

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
router.get('/api/adaptive-questions/:conceptId', ensureAuthenticated, async (req, res) => {
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

// Concept stats API - mastery history sparkline + unsolved question count
router.get('/api/concept-stats/:conceptId', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.params;
        const userId = req.user.id;
        const instituteId = req.user.institute_id;

        // 1. Mastery history: reconstruct from last 20 attempts
        const attemptsRes = await db.query(
            `SELECT uqa.correct, uqa.time_taken_seconds, uqa.attempted_at, q.difficulty_tier
             FROM user_question_attempts uqa
             JOIN questions q ON q.id = uqa.question_id
             WHERE uqa.user_id = $1 AND q.concept_id = $2
             ORDER BY uqa.attempted_at DESC LIMIT 20`,
            [userId, conceptId]
        );
        // Reverse to chronological order
        const attempts = attemptsRes.rows.reverse();

        // 2. Total approved questions for this concept (respecting institute scope)
        let totalQQuery = `SELECT COUNT(*) FROM questions WHERE concept_id = $1 AND status = 'approved'`;
        const totalQParams = [conceptId];
        if (instituteId) {
            totalQQuery += ` AND (institute_id = $2 OR institute_id IS NULL)`;
            totalQParams.push(instituteId);
        }
        const totalQRes = await db.query(totalQQuery, totalQParams);
        const totalQuestions = parseInt(totalQRes.rows[0].count);

        // 3. Distinct questions this user has attempted for this concept
        const attemptedQRes = await db.query(
            `SELECT COUNT(DISTINCT uqa.question_id)
             FROM user_question_attempts uqa
             JOIN questions q ON q.id = uqa.question_id
             WHERE uqa.user_id = $1 AND q.concept_id = $2`,
            [userId, conceptId]
        );
        const attemptedQuestions = parseInt(attemptedQRes.rows[0].count);
        const unsolvedQuestions = Math.max(0, totalQuestions - attemptedQuestions);

        // 4. Accuracy and avg time
        const totalAttempts = attemptsRes.rows.length;
        const correctCount = attemptsRes.rows.filter(a => a.correct).length;
        const avgTime = totalAttempts > 0
            ? Math.round(attemptsRes.rows.reduce((s, a) => s + (a.time_taken_seconds || 0), 0) / totalAttempts)
            : null;

        // 5. Last practiced
        const lastPracticed = totalAttempts > 0 ? attemptsRes.rows[attemptsRes.rows.length - 1].attempted_at : null;

        res.json({
            attempts: attempts.map(a => ({ correct: a.correct, tier: a.difficulty_tier })),
            totalQuestions,
            attemptedQuestions,
            unsolvedQuestions,
            accuracy: totalAttempts > 0 ? Math.round((correctCount / totalAttempts) * 100) : null,
            avgTimeSeconds: avgTime,
            lastPracticed
        });
    } catch (e) {
        console.error('Concept stats error:', e);
        res.status(500).json({ error: 'Failed to fetch concept stats' });
    }
});

// Mastery Mode — graph-aware, pulls real questions from DB
router.get('/master', ensureAuthenticated, async (req, res) => {
    res.render('master.ejs', {
        topic: null, gradeLevel: null, mastery: null,
        question: null, completed: false, message: null,
        conceptName: null, allConcepts: null
    });
});

router.post('/master/start', ensureAuthenticated, async (req, res) => {
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

router.post('/master/answer', ensureAuthenticated, async (req, res) => {
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

// Concept-specific prerequisite diagnosis API endpoint (v2 — multi-signal engine)
router.post('/api/diagnose-concept', ensureAuthenticated, async (req, res) => {
    try {
        const { conceptId } = req.body;
        if (!conceptId) return res.status(400).json({ error: 'conceptId required' });
        const result = await diagnosePrerequisites(db, req.user.id, conceptId);
        res.json(result);
    } catch (error) {
        console.error('Concept diagnosis error:', error);
        res.status(500).json({ error: error.message });
    }
});

router.post('/api/bkt/update', ensureAuthenticated, async (req, res) => {
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

router.post('/api/bkt/next', ensureAuthenticated, async (req, res) => {
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

export default router;
