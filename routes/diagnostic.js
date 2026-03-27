import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';
import { getUserConceptMastery } from '../helpers/mastery.js';
import { getQuestionFromDB } from '../helpers/questions.js';
import { bktUpdateConcept } from '../services/bktClient.js';

const router = express.Router();

// ============================================================
// Diagnostic Onboarding Test — 30-question adaptive assessment
// Initializes BKT weights for new students so they don't start from zero
// ============================================================

router.get('/diagnostic', ensureAuthenticated, async (req, res) => {
    // If already completed, go to dashboard
    if (req.user.diagnostic_completed) return res.redirect('/');
    
    // Initialize session state if not started
    if (!req.session.diagnostic) {
        req.session.diagnostic = {
            questionIndex: 0,
            totalQuestions: 30,
            answers: [],           // { conceptId, correct, difficulty_tier }
            sampledConcepts: [],   // concept IDs we've picked questions from
            currentQuestion: null,
            currentConceptId: null,
            subjectIndex: 0,
            started: false
        };
    }
    
    res.render('diagnostic.ejs', {
        diagnostic: req.session.diagnostic,
        question: req.session.diagnostic.currentQuestion,
        user: req.user
    });
});

router.post('/diagnostic/start', ensureAuthenticated, async (req, res) => {
    try {
        if (req.user.diagnostic_completed) return res.redirect('/');
        
        // ── Improved sampling: 2 concepts per chapter, ~45 questions total ──
        // This gives us 2 data points per chapter for more reliable inference
        const subjects = ['Physics', 'Mathematics'];
        const chemRes = await db.query("SELECT DISTINCT subject FROM concepts WHERE subject ILIKE 'chemistry%'");
        const chemSubjects = chemRes.rows.map(r => r.subject);
        const allSubjects = [...subjects, ...chemSubjects];
        
        // Target: ~9 questions per subject (45 total across 5 subjects)
        // Pick up to 2 concepts per chapter
        let sampledConcepts = [];
        
        for (const subject of allSubjects) {
            const chaptersRes = await db.query(`
                SELECT chapter_id, concept_id, name FROM (
                    SELECT c.chapter_id, c.id as concept_id, c.name,
                           ROW_NUMBER() OVER (PARTITION BY c.chapter_id ORDER BY RANDOM()) as rn
                    FROM concepts c
                    WHERE c.subject = $1 AND c.chapter_id IS NOT NULL
                ) sub WHERE rn <= 2
                ORDER BY chapter_id, rn
            `, [subject]);
            
            for (const row of chaptersRes.rows) {
                sampledConcepts.push({ conceptId: row.concept_id, name: row.name, subject, chapterId: row.chapter_id });
            }
        }
        
        // Shuffle and trim to 45
        sampledConcepts.sort(() => Math.random() - 0.5);
        sampledConcepts = sampledConcepts.slice(0, 45);
        
        // Fetch first question (start at tier 2 — medium difficulty)
        const firstConcept = sampledConcepts[0];
        const question = await getQuestionFromDB(firstConcept.conceptId, 'medium', [], req.user.id, req.user.institute_id);
        
        req.session.diagnostic = {
            questionIndex: 0,
            totalQuestions: sampledConcepts.length,
            answers: [],
            sampledConcepts,
            currentQuestion: question,
            currentConceptId: firstConcept.conceptId,
            currentConceptName: firstConcept.name,
            started: true,
            subjectCorrect: {},
            subjectTotal: {}
        };
        
        res.render('diagnostic.ejs', {
            diagnostic: req.session.diagnostic,
            question,
            user: req.user
        });
    } catch (e) {
        console.error('Diagnostic start error:', e);
        res.status(500).send('Failed to start diagnostic test');
    }
});

router.post('/diagnostic/answer', ensureAuthenticated, async (req, res) => {
    try {
        if (req.user.diagnostic_completed) return res.redirect('/');
        
        const diag = req.session.diagnostic;
        if (!diag || !diag.started) return res.redirect('/diagnostic');
        
        const question = diag.currentQuestion;
        const conceptId = diag.currentConceptId;
        if (!question || !conceptId) return res.redirect('/diagnostic');
        
        const correct = req.body.answer === question.correct_answer;
        const difficultyTier = question.difficulty_tier || 2;
        
        // Record the answer
        diag.answers.push({ conceptId, correct, difficultyTier });
        
        // Track per-subject performance
        const concept = diag.sampledConcepts[diag.questionIndex];
        if (concept) {
            const subj = concept.subject;
            diag.subjectCorrect[subj] = (diag.subjectCorrect[subj] || 0) + (correct ? 1 : 0);
            diag.subjectTotal[subj] = (diag.subjectTotal[subj] || 0) + 1;
        }
        
        // Log the attempt
        if (question.id) {
            await db.query(
                'INSERT INTO user_question_attempts (user_id, question_id, correct, time_taken_seconds) VALUES ($1,$2,$3,$4)',
                [req.user.id, question.id, correct, null]
            );
        }
        
        // Update BKT mastery for this concept
        const prev = await getUserConceptMastery(req.user.id, conceptId);
        const updated = await bktUpdateConcept({
            userId: req.user.id, skillId: conceptId,
            correct, p_mastery: parseFloat(prev.mastery),
            difficulty_tier: difficultyTier
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
        
        // Move to next question
        diag.questionIndex++;
        
        if (diag.questionIndex >= diag.totalQuestions) {
            // Diagnostic complete — initialize remaining concepts
            await initializeRemainingConcepts(req.user.id, diag);
            
            // Mark diagnostic as completed
            await db.query('UPDATE users SET diagnostic_completed = true WHERE id = $1', [req.user.id]);
            req.user.diagnostic_completed = true;
            
            // Calculate summary stats
            const totalCorrect = diag.answers.filter(a => a.correct).length;
            
            req.session.diagnosticResult = {
                totalQuestions: diag.totalQuestions,
                totalCorrect,
                percentage: Math.round((totalCorrect / diag.totalQuestions) * 100)
            };
            
            delete req.session.diagnostic;
            return res.redirect('/diagnostic/results');
        }
        
        // Fetch next question with adaptive difficulty
        const nextConcept = diag.sampledConcepts[diag.questionIndex];
        const subjectAccuracy = diag.subjectTotal[nextConcept.subject] > 0
            ? diag.subjectCorrect[nextConcept.subject] / diag.subjectTotal[nextConcept.subject]
            : 0.5;
        
        // Adapt difficulty based on subject performance
        let difficulty = 'medium';
        if (subjectAccuracy >= 0.7) difficulty = 'hard';
        else if (subjectAccuracy < 0.4) difficulty = 'easy';
        
        // Find next concept that has available questions
        let nextQuestion = null;
        while (diag.questionIndex < diag.totalQuestions && !nextQuestion) {
            const tryC = diag.sampledConcepts[diag.questionIndex];
            nextQuestion = await getQuestionFromDB(tryC.conceptId, difficulty, [], req.user.id, req.user.institute_id);
            if (!nextQuestion) {
                diag.questionIndex++;
            } else {
                diag.currentQuestion = nextQuestion;
                diag.currentConceptId = tryC.conceptId;
                diag.currentConceptName = tryC.name;
            }
        }
        
        // If we ran out of concepts with questions, finish early
        if (!nextQuestion) {
            await initializeRemainingConcepts(req.user.id, diag);
            await db.query('UPDATE users SET diagnostic_completed = true WHERE id = $1', [req.user.id]);
            req.user.diagnostic_completed = true;
            const totalCorrect = diag.answers.filter(a => a.correct).length;
            req.session.diagnosticResult = {
                totalQuestions: diag.answers.length,
                totalCorrect,
                percentage: Math.round((totalCorrect / Math.max(diag.answers.length, 1)) * 100)
            };
            delete req.session.diagnostic;
            return res.redirect('/diagnostic/results');
        }
        diag.lastAnswer = { correct, conceptName: concept?.name || conceptId };
        
        req.session.diagnostic = diag;
        
        res.render('diagnostic.ejs', {
            diagnostic: diag,
            question: nextQuestion,
            user: req.user
        });
    } catch (e) {
        console.error('Diagnostic answer error:', e);
        res.status(500).send('Failed to process diagnostic answer');
    }
});

// Initialize mastery for concepts not directly tested in the diagnostic
async function initializeRemainingConcepts(userId, diag) {
    // ── Prerequisite-aware mastery inference ──
    // Uses 4 signals (strongest → weakest):
    //   1. Prerequisite graph: if you got a hard concept right, you likely know its prerequisites
    //   2. Reverse prereqs: if you got a prerequisite wrong, downstream concepts are likely weak too
    //   3. Same chapter performance (2 data points per chapter now)
    //   4. Same subject performance (fallback)
    
    const allConcepts = await db.query('SELECT id, subject, chapter_id FROM concepts');
    const prereqRes = await db.query('SELECT concept_id, prereq_id FROM concept_prerequisites');
    const testedConcepts = new Set(diag.answers.map(a => a.conceptId));
    
    // Build prerequisite graph (both directions)
    const prereqsOf = {};    // concept → [its prerequisites]
    const dependentsOf = {}; // concept → [concepts that depend on it]
    for (const row of prereqRes.rows) {
        if (!prereqsOf[row.concept_id]) prereqsOf[row.concept_id] = [];
        prereqsOf[row.concept_id].push(row.prereq_id);
        if (!dependentsOf[row.prereq_id]) dependentsOf[row.prereq_id] = [];
        dependentsOf[row.prereq_id].push(row.concept_id);
    }
    
    // Build tested concept mastery map from diagnostic answers
    const testedMastery = {};
    for (const answer of diag.answers) {
        // Use the actual BKT-computed mastery from the DB
        const mRow = await db.query(
            'SELECT mastery FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2',
            [userId, answer.conceptId]
        );
        testedMastery[answer.conceptId] = mRow.rows[0] ? parseFloat(mRow.rows[0].mastery) : 0.2;
    }
    
    // Build chapter and subject performance
    const chapterPerformance = {};
    const subjectPerformance = {};
    for (const answer of diag.answers) {
        const concept = diag.sampledConcepts.find(c => c.conceptId === answer.conceptId);
        if (!concept) continue;
        
        const cRow = allConcepts.rows.find(r => r.id === answer.conceptId);
        if (cRow && cRow.chapter_id) {
            if (!chapterPerformance[cRow.chapter_id]) chapterPerformance[cRow.chapter_id] = { correct: 0, total: 0 };
            chapterPerformance[cRow.chapter_id].correct += answer.correct ? 1 : 0;
            chapterPerformance[cRow.chapter_id].total += 1;
        }
        
        if (!subjectPerformance[concept.subject]) subjectPerformance[concept.subject] = { correct: 0, total: 0 };
        subjectPerformance[concept.subject].correct += answer.correct ? 1 : 0;
        subjectPerformance[concept.subject].total += 1;
    }
    
    // ── Traverse prerequisite graph to propagate mastery ──
    // Walk UP from tested concepts: if student got concept X right,
    // its prerequisites are likely known (with decay per hop)
    function getUpstreamInference(conceptId, visited = new Set(), depth = 0) {
        if (depth > 5 || visited.has(conceptId)) return null;
        visited.add(conceptId);
        
        // Check if this concept was directly tested
        if (testedMastery[conceptId] !== undefined) {
            return { mastery: testedMastery[conceptId], depth };
        }
        
        // Check if any dependent (downstream) concept was tested
        const dependents = dependentsOf[conceptId] || [];
        let bestSignal = null;
        for (const dep of dependents) {
            const signal = getUpstreamInference(dep, new Set(visited), depth + 1);
            if (signal && (!bestSignal || signal.mastery > bestSignal.mastery)) {
                bestSignal = signal;
            }
        }
        return bestSignal;
    }
    
    // Walk DOWN from tested concepts: if student got prerequisite X wrong,
    // downstream concepts are likely weak too (with decay per hop)
    function getDownstreamInference(conceptId, visited = new Set(), depth = 0) {
        if (depth > 5 || visited.has(conceptId)) return null;
        visited.add(conceptId);
        
        if (testedMastery[conceptId] !== undefined) {
            return { mastery: testedMastery[conceptId], depth };
        }
        
        const prereqs = prereqsOf[conceptId] || [];
        let bestSignal = null;
        for (const pre of prereqs) {
            const signal = getDownstreamInference(pre, new Set(visited), depth + 1);
            if (signal && (!bestSignal || signal.depth < bestSignal.depth)) {
                bestSignal = signal;
            }
        }
        return bestSignal;
    }
    
    const values = [];
    for (const concept of allConcepts.rows) {
        if (testedConcepts.has(concept.id)) continue;
        
        let inferredMastery = null;
        let source = 'default';
        
        // Signal 1: Upstream inference (student got a harder dependent concept right)
        // If you can do Integration by Parts, you likely know basic Integration
        const upstream = getUpstreamInference(concept.id);
        if (upstream) {
            // Decay factor: 0.85 per hop — prerequisites of tested concepts get high credit
            // e.g., depth=1 → 85% of tested mastery, depth=2 → 72%, depth=3 → 61%
            const decayFactor = Math.pow(0.85, upstream.depth);
            // Upstream means the tested concept DEPENDS on this one,
            // so if they got the dependent right, this prerequisite is likely strong
            // Cap at 0.6 — we don't want to over-credit from inference alone
            inferredMastery = Math.min(0.6, upstream.mastery * decayFactor);
            source = 'upstream';
        }
        
        // Signal 2: Downstream inference (student got a prerequisite wrong)
        // If you can't do basic Kinematics, Rotational Motion is likely weak
        const downstream = getDownstreamInference(concept.id);
        if (downstream) {
            const decayFactor = Math.pow(0.8, downstream.depth);
            // Downstream: the tested concept is a PREREQUISITE of this one
            // If prereq is weak, this concept is likely weaker
            // If prereq is strong, this concept might still be unknown
            const downstreamMastery = downstream.mastery < 0.5
                ? Math.min(0.3, downstream.mastery * decayFactor * 0.7) // weak prereq → very weak
                : Math.min(0.45, downstream.mastery * decayFactor * 0.6); // strong prereq → moderate
            
            // Take the lower of upstream and downstream (conservative)
            if (inferredMastery === null || downstreamMastery < inferredMastery) {
                inferredMastery = downstreamMastery;
                source = 'downstream';
            }
        }
        
        // Signal 3: Chapter-level performance (2 data points per chapter)
        if (inferredMastery === null && concept.chapter_id && chapterPerformance[concept.chapter_id]) {
            const cp = chapterPerformance[concept.chapter_id];
            const accuracy = cp.correct / cp.total;
            // With 2 questions per chapter: 2/2 → 0.50, 1/2 → 0.30, 0/2 → 0.15
            inferredMastery = 0.15 + accuracy * 0.35;
            source = 'chapter';
        }
        
        // Signal 4: Subject-level performance (weakest signal)
        if (inferredMastery === null && subjectPerformance[concept.subject]) {
            const sp = subjectPerformance[concept.subject];
            const accuracy = sp.correct / sp.total;
            inferredMastery = 0.15 + accuracy * 0.25;
            source = 'subject';
        }
        
        // Default: no signal at all
        if (inferredMastery === null) {
            inferredMastery = 0.2;
        }
        
        // Clamp to valid range
        inferredMastery = Math.max(0.1, Math.min(0.6, inferredMastery));
        
        values.push(`(${userId}, '${concept.id}', ${inferredMastery.toFixed(4)}, 0, 0, CURRENT_TIMESTAMP)`);
    }
    
    if (values.length > 0) {
        const chunkSize = 100;
        for (let i = 0; i < values.length; i += chunkSize) {
            const chunk = values.slice(i, i + chunkSize);
            await db.query(`
                INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
                VALUES ${chunk.join(',')}
                ON CONFLICT (user_id, concept_id) DO NOTHING
            `);
        }
    }
}

router.get('/diagnostic/results', ensureAuthenticated, async (req, res) => {
    const result = req.session.diagnosticResult;
    if (!result) return res.redirect('/');
    
    // Get the initialized mastery data for the summary
    const masteryRes = await db.query(
        'SELECT concept_id, mastery FROM user_concept_mastery WHERE user_id=$1 ORDER BY mastery DESC',
        [req.user.id]
    );
    
    const strong = masteryRes.rows.filter(r => parseFloat(r.mastery) >= 0.4).length;
    const developing = masteryRes.rows.filter(r => parseFloat(r.mastery) >= 0.25 && parseFloat(r.mastery) < 0.4).length;
    const needsWork = masteryRes.rows.filter(r => parseFloat(r.mastery) < 0.25).length;
    
    delete req.session.diagnosticResult;
    
    res.render('diagnostic-results.ejs', {
        result,
        summary: { strong, developing, needsWork, total: masteryRes.rows.length },
        user: req.user
    });
});

router.get('/diagnostic/skip', ensureAuthenticated, async (req, res) => {
    // Allow students to skip diagnostic (they'll start with default 0.2 mastery)
    await db.query('UPDATE users SET diagnostic_completed = true WHERE id = $1', [req.user.id]);
    req.user.diagnostic_completed = true;
    if (req.session.diagnostic) delete req.session.diagnostic;
    res.redirect('/');
});

export default router;
