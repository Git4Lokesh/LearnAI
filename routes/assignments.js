import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated, ensureInstituteUser } from '../middleware/auth.js';
import { computeJeeScore, computeAssignmentStatus } from '../helpers/scoring.js';
import { getUserConceptMastery } from '../helpers/mastery.js';
import { bktUpdateConcept } from '../services/bktClient.js';

const router = express.Router();

// ═══════════════════════════════════════════════════════════════
// TEACHER ROUTES
// ═══════════════════════════════════════════════════════════════

// GET /assignments — list teacher's assignments
router.get('/assignments', ensureInstituteUser, async (req, res) => {
    try {
        const result = await db.query(`
            SELECT a.*, b.name AS batch_name,
                   (SELECT COUNT(*) FROM assignment_questions aq WHERE aq.assignment_id = a.id) AS question_count,
                   (SELECT COUNT(*) FROM assignment_submissions s WHERE s.assignment_id = a.id) AS submission_count,
                   (SELECT COUNT(*) FROM batch_students bs WHERE bs.batch_id = a.batch_id) AS student_count
            FROM assignments a
            JOIN batches b ON b.id = a.batch_id
            WHERE a.created_by = $1
            ORDER BY a.deadline DESC
        `, [req.user.id]);

        res.render('assignment-list.ejs', {
            user: req.user,
            assignments: result.rows,
        });
    } catch (err) {
        console.error('Error loading assignments:', err);
        res.status(500).send('Server error');
    }
});

// GET /assignments/create — render creation form
router.get('/assignments/create', ensureInstituteUser, async (req, res) => {
    try {
        const batches = await db.query(
            'SELECT id, name FROM batches WHERE institute_id = $1 ORDER BY name',
            [req.user.institute_id]
        );

        // Get distinct subjects and concepts for filter dropdowns
        const subjects = await db.query(
            `SELECT DISTINCT subject FROM concepts ORDER BY subject`
        );
        const concepts = await db.query(
            `SELECT id, name, subject FROM concepts ORDER BY subject, name`
        );

        res.render('assignment-create.ejs', {
            user: req.user,
            batches: batches.rows,
            subjects: subjects.rows.map(r => r.subject),
            concepts: concepts.rows,
            error: req.session.assignmentError || null,
        });
        delete req.session.assignmentError;
    } catch (err) {
        console.error('Error loading assignment creation form:', err);
        res.status(500).send('Server error');
    }
});

// GET /api/assignments/questions — AJAX: fetch filtered questions for creation form
router.get('/api/assignments/questions', ensureInstituteUser, async (req, res) => {
    try {
        const { subject, concept_id, difficulty_tier } = req.query;
        const params = [req.user.institute_id];
        const conditions = [
            `q.status = 'approved'`,
            `(q.institute_id = $1 OR q.institute_id IS NULL)`,
        ];
        let idx = 2;

        if (subject) {
            conditions.push(`c.subject = $${idx++}`);
            params.push(subject);
        }
        if (concept_id) {
            conditions.push(`q.concept_id = $${idx++}`);
            params.push(concept_id);
        }
        if (difficulty_tier) {
            conditions.push(`q.difficulty_tier = $${idx++}`);
            params.push(parseInt(difficulty_tier));
        }

        const result = await db.query(`
            SELECT q.id, q.question_text, q.option1, q.option2, q.option3, q.option4,
                   q.correct_answer, q.concept_id, q.difficulty_tier, c.name AS concept_name, c.subject
            FROM questions q
            LEFT JOIN concepts c ON c.id = q.concept_id
            WHERE ${conditions.join(' AND ')}
            ORDER BY c.subject, c.name, q.difficulty_tier
            LIMIT 200
        `, params);

        res.json({ questions: result.rows });
    } catch (err) {
        console.error('Error fetching questions:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/assignments/auto-generate — randomly pick N questions matching filters
router.get('/api/assignments/auto-generate', ensureInstituteUser, async (req, res) => {
    try {
        const { subject, concept_id, difficulty_tier, count } = req.query;
        const limit = Math.min(parseInt(count) || 10, 50);
        const params = [req.user.institute_id];
        const conditions = [
            `q.status = 'approved'`,
            `(q.institute_id = $1 OR q.institute_id IS NULL)`,
        ];
        let idx = 2;

        if (subject) {
            conditions.push(`c.subject = $${idx++}`);
            params.push(subject);
        }
        if (concept_id) {
            conditions.push(`q.concept_id = $${idx++}`);
            params.push(concept_id);
        }
        if (difficulty_tier) {
            conditions.push(`q.difficulty_tier = $${idx++}`);
            params.push(parseInt(difficulty_tier));
        }

        params.push(limit);

        const result = await db.query(`
            SELECT q.id, q.question_text, q.concept_id, q.difficulty_tier, c.name AS concept_name, c.subject
            FROM questions q
            LEFT JOIN concepts c ON c.id = q.concept_id
            WHERE ${conditions.join(' AND ')}
            ORDER BY RANDOM()
            LIMIT $${idx}
        `, params);

        res.json({ questions: result.rows, total: result.rowCount });
    } catch (err) {
        console.error('Error auto-generating questions:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// POST /assignments/create — create assignment + notifications
router.post('/assignments/create', ensureInstituteUser, async (req, res) => {
    try {
        const { title, batch_id, deadline, question_ids } = req.body;
        const instituteId = req.user.institute_id;

        // Parse question IDs (comes as comma-separated string or array)
        const qIds = Array.isArray(question_ids)
            ? question_ids.map(Number)
            : (question_ids || '').split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));

        // Validate at least one question
        if (qIds.length === 0) {
            req.session.assignmentError = 'Please select at least one question.';
            return res.redirect('/assignments/create');
        }

        // Validate deadline is in the future
        const deadlineDate = new Date(deadline);
        if (isNaN(deadlineDate.getTime()) || deadlineDate <= new Date()) {
            req.session.assignmentError = 'Deadline must be a future date and time.';
            return res.redirect('/assignments/create');
        }

        // Validate batch belongs to teacher's institute
        const batchCheck = await db.query(
            'SELECT id FROM batches WHERE id = $1 AND institute_id = $2',
            [batch_id, instituteId]
        );
        if (batchCheck.rowCount === 0) {
            return res.status(403).send('Forbidden: batch does not belong to your institute.');
        }

        // Validate all question IDs exist and are approved
        const qCheck = await db.query(
            `SELECT id FROM questions WHERE id = ANY($1) AND status = 'approved'`,
            [qIds]
        );
        if (qCheck.rowCount !== qIds.length) {
            req.session.assignmentError = 'Some selected questions are invalid or not approved.';
            return res.redirect('/assignments/create');
        }

        // Create assignment
        const assignmentResult = await db.query(
            `INSERT INTO assignments (institute_id, batch_id, created_by, title, deadline)
             VALUES ($1, $2, $3, $4, $5) RETURNING id`,
            [instituteId, batch_id, req.user.id, title, deadlineDate]
        );
        const assignmentId = assignmentResult.rows[0].id;

        // Insert assignment questions with order
        for (let i = 0; i < qIds.length; i++) {
            await db.query(
                `INSERT INTO assignment_questions (assignment_id, question_id, question_order)
                 VALUES ($1, $2, $3)`,
                [assignmentId, qIds[i], i + 1]
            );
        }

        // Create notifications for all students in the batch
        const students = await db.query(
            'SELECT user_id FROM batch_students WHERE batch_id = $1',
            [batch_id]
        );
        for (const student of students.rows) {
            await db.query(
                `INSERT INTO notifications (user_id, type, reference_id, title, message)
                 VALUES ($1, 'assignment', $2, $3, $4)`,
                [student.user_id, assignmentId, `New Assignment: ${title}`,
                 `You have a new assignment "${title}" due by ${deadlineDate.toLocaleString()}. ${qIds.length} questions.`]
            );
        }

        res.redirect('/assignments');
    } catch (err) {
        console.error('Error creating assignment:', err);
        req.session.assignmentError = 'Failed to create assignment. Please try again.';
        res.redirect('/assignments/create');
    }
});


// ═══════════════════════════════════════════════════════════════
// STUDENT ROUTES
// ═══════════════════════════════════════════════════════════════

// GET /assignments/:id/take — render assignment-taking UI
router.get('/assignments/:id/take', ensureAuthenticated, async (req, res) => {
    try {
        const assignmentId = parseInt(req.params.id);
        const userId = req.user.id;

        // Load assignment
        const aResult = await db.query(
            'SELECT a.*, b.name AS batch_name FROM assignments a JOIN batches b ON b.id = a.batch_id WHERE a.id = $1',
            [assignmentId]
        );
        if (aResult.rowCount === 0) return res.status(404).send('Assignment not found.');
        const assignment = aResult.rows[0];

        // Check student belongs to the batch
        const memberCheck = await db.query(
            'SELECT 1 FROM batch_students WHERE batch_id = $1 AND user_id = $2',
            [assignment.batch_id, userId]
        );
        if (memberCheck.rowCount === 0) return res.status(403).send('You are not in this batch.');

        // Check deadline
        if (new Date(assignment.deadline) <= new Date()) {
            req.session.flashMsg = 'Deadline has passed for this assignment.';
            return res.redirect('/');
        }

        // Check existing submission — redirect to results
        const subCheck = await db.query(
            'SELECT id FROM assignment_submissions WHERE assignment_id = $1 AND user_id = $2',
            [assignmentId, userId]
        );
        if (subCheck.rowCount > 0) {
            return res.redirect(`/assignments/${assignmentId}/results`);
        }

        // Load questions in order
        const qResult = await db.query(`
            SELECT q.id, q.question_text, q.option1, q.option2, q.option3, q.option4,
                   q.correct_answer, q.concept_id, q.difficulty_tier, aq.question_order
            FROM assignment_questions aq
            JOIN questions q ON q.id = aq.question_id
            WHERE aq.assignment_id = $1
            ORDER BY aq.question_order
        `, [assignmentId]);

        // Initialize or restore session
        if (!req.session.assignmentState || req.session.assignmentState.assignmentId !== assignmentId) {
            req.session.assignmentState = {
                assignmentId,
                answers: {},
                startedAt: Date.now(),
            };
        }

        // Sanitize questions for client (remove correct_answer)
        const clientQuestions = qResult.rows.map(q => ({
            seq: q.question_order,
            id: q.id,
            question_text: q.question_text,
            option1: q.option1,
            option2: q.option2,
            option3: q.option3,
            option4: q.option4,
            difficulty_tier: q.difficulty_tier,
            concept_id: q.concept_id,
        }));

        res.render('assignment-take.ejs', {
            user: req.user,
            assignment,
            questions: clientQuestions,
            answers: req.session.assignmentState.answers,
            startTimestamp: req.session.assignmentState.startedAt,
            deadline: new Date(assignment.deadline).getTime(),
        });
    } catch (err) {
        console.error('Error loading assignment:', err);
        res.status(500).send('Server error');
    }
});

// POST /assignments/:id/answer — save answer (AJAX)
router.post('/assignments/:id/answer', ensureAuthenticated, (req, res) => {
    const assignmentId = parseInt(req.params.id);
    const { seq, answer } = req.body;

    if (!req.session.assignmentState || req.session.assignmentState.assignmentId !== assignmentId) {
        return res.status(400).json({ error: 'No active assignment session.' });
    }

    req.session.assignmentState.answers[String(seq)] = answer;
    res.json({ ok: true });
});

// POST /assignments/:id/clear — clear answer (AJAX)
router.post('/assignments/:id/clear', ensureAuthenticated, (req, res) => {
    const assignmentId = parseInt(req.params.id);
    const { seq } = req.body;

    if (!req.session.assignmentState || req.session.assignmentState.assignmentId !== assignmentId) {
        return res.status(400).json({ error: 'No active assignment session.' });
    }

    delete req.session.assignmentState.answers[String(seq)];
    res.json({ ok: true });
});

// POST /assignments/:id/submit — submit assignment
router.post('/assignments/:id/submit', ensureAuthenticated, async (req, res) => {
    try {
        const assignmentId = parseInt(req.params.id);
        const userId = req.user.id;

        // Check existing submission (idempotency)
        const existingSub = await db.query(
            'SELECT id FROM assignment_submissions WHERE assignment_id = $1 AND user_id = $2',
            [assignmentId, userId]
        );
        if (existingSub.rowCount > 0) {
            return res.json({ ok: true, redirect: `/assignments/${assignmentId}/results` });
        }

        const state = req.session.assignmentState;
        if (!state || state.assignmentId !== assignmentId) {
            return res.status(400).json({ error: 'No active assignment session.' });
        }

        // Load full questions (with correct_answer) for scoring
        const qResult = await db.query(`
            SELECT q.id, q.correct_answer, q.concept_id, q.difficulty_tier, aq.question_order
            FROM assignment_questions aq
            JOIN questions q ON q.id = aq.question_id
            WHERE aq.assignment_id = $1
            ORDER BY aq.question_order
        `, [assignmentId]);

        const questions = qResult.rows.map(q => ({
            ...q,
            seq: q.question_order,
        }));

        // Score
        const score = computeJeeScore(questions, state.answers);
        const timeTaken = Math.round((Date.now() - state.startedAt) / 1000);

        // Insert submission
        const subResult = await db.query(
            `INSERT INTO assignment_submissions (assignment_id, user_id, score, max_score, time_taken_seconds, started_at, submitted_at)
             VALUES ($1, $2, $3, $4, $5, to_timestamp($6 / 1000.0), now())
             RETURNING id`,
            [assignmentId, userId, score.total, score.maxScore, timeTaken, state.startedAt]
        );
        const submissionId = subResult.rows[0].id;

        // Insert individual answers (one per question, including unanswered)
        for (const q of questions) {
            const selected = state.answers[String(q.seq)] || null;
            const isCorrect = selected ? (selected === q.correct_answer) : false;
            await db.query(
                `INSERT INTO assignment_answers (submission_id, question_id, selected_option, is_correct)
                 VALUES ($1, $2, $3, $4)`,
                [submissionId, q.id, selected, isCorrect]
            );
        }

        // Log user_question_attempts for answered questions (consistency with practice tracking)
        for (const q of questions) {
            const selected = state.answers[String(q.seq)];
            if (!selected) continue;
            const isCorrect = selected === q.correct_answer;
            try {
                await db.query(
                    'INSERT INTO user_question_attempts (user_id, question_id, correct, time_taken_seconds) VALUES ($1, $2, $3, $4)',
                    [userId, q.id, isCorrect, null]
                );
            } catch (logErr) {
                console.error('Failed to log attempt for question', q.id, logErr.message);
            }
        }

        // BKT mastery updates — group by concept
        const conceptAnswers = {};
        for (const q of questions) {
            const selected = state.answers[String(q.seq)];
            if (!selected) continue;
            const isCorrect = selected === q.correct_answer;
            if (!conceptAnswers[q.concept_id]) {
                conceptAnswers[q.concept_id] = { correct: 0, total: 0, difficulty_tier: q.difficulty_tier };
            }
            conceptAnswers[q.concept_id].total++;
            if (isCorrect) conceptAnswers[q.concept_id].correct++;
        }

        for (const [conceptId, data] of Object.entries(conceptAnswers)) {
            try {
                const prev = await getUserConceptMastery(userId, conceptId);
                // Send one update per answered question in this concept
                let currentMastery = parseFloat(prev.mastery);
                let questionsAnswered = prev.questions_answered;
                let correctAnswers = prev.correct_answers;

                // We iterate per-answer to get proper sequential BKT updates
                for (const q of questions.filter(qq => qq.concept_id === conceptId)) {
                    const selected = state.answers[String(q.seq)];
                    if (!selected) continue;
                    const isCorrect = selected === q.correct_answer;

                    const updated = await bktUpdateConcept({
                        userId,
                        skillId: conceptId,
                        correct: isCorrect,
                        p_mastery: currentMastery,
                        difficulty_tier: q.difficulty_tier,
                    });
                    currentMastery = updated.posterior_mastery;
                    questionsAnswered++;
                    if (isCorrect) correctAnswers++;
                }

                await db.query(`
                    INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
                    VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP)
                    ON CONFLICT (user_id, concept_id) DO UPDATE
                    SET mastery = $3, questions_answered = $4, correct_answers = $5, last_updated = CURRENT_TIMESTAMP`,
                    [userId, conceptId, currentMastery, questionsAnswered, correctAnswers]
                );
            } catch (bktErr) {
                console.error('BKT update failed for concept', conceptId, bktErr.message);
                // Submission is still saved — BKT failure is non-fatal
            }
        }

        // Clean up session
        delete req.session.assignmentState;

        res.json({ ok: true, redirect: `/assignments/${assignmentId}/results` });
    } catch (err) {
        console.error('Error submitting assignment:', err);
        // Handle duplicate submission (unique constraint)
        if (err.code === '23505') {
            return res.json({ ok: true, redirect: `/assignments/${req.params.id}/results` });
        }
        res.status(500).json({ error: 'Submission failed.' });
    }
});

// GET /assignments/:id/results — student views own results
router.get('/assignments/:id/results', ensureAuthenticated, async (req, res) => {
    try {
        const assignmentId = parseInt(req.params.id);
        const userId = req.user.id;

        const subResult = await db.query(
            `SELECT s.*, a.title, a.deadline, b.name AS batch_name
             FROM assignment_submissions s
             JOIN assignments a ON a.id = s.assignment_id
             JOIN batches b ON b.id = a.batch_id
             WHERE s.assignment_id = $1 AND s.user_id = $2`,
            [assignmentId, userId]
        );
        if (subResult.rowCount === 0) return res.status(404).send('No submission found.');

        const submission = subResult.rows[0];

        // Load answers with question details
        const answersResult = await db.query(`
            SELECT aa.*, q.question_text, q.option1, q.option2, q.option3, q.option4,
                   q.correct_answer, q.concept_id, q.difficulty_tier, c.name AS concept_name,
                   aq.question_order
            FROM assignment_answers aa
            JOIN questions q ON q.id = aa.question_id
            JOIN assignment_questions aq ON aq.assignment_id = $1 AND aq.question_id = aa.question_id
            LEFT JOIN concepts c ON c.id = q.concept_id
            WHERE aa.submission_id = $2
            ORDER BY aq.question_order
        `, [assignmentId, submission.id]);

        res.render('assignment-results.ejs', {
            user: req.user,
            submission,
            answers: answersResult.rows,
        });
    } catch (err) {
        console.error('Error loading results:', err);
        res.status(500).send('Server error');
    }
});


// ═══════════════════════════════════════════════════════════════
// TEACHER: VIEW INDIVIDUAL STUDENT SUBMISSION
// ═══════════════════════════════════════════════════════════════

// GET /assignments/:id/submissions/:userId — teacher views a specific student's answers
router.get('/assignments/:id/submissions/:userId', ensureAuthenticated, async (req, res) => {
    try {
        const assignmentId = parseInt(req.params.id);
        const studentId = parseInt(req.params.userId);

        // Load assignment
        const aResult = await db.query(
            `SELECT a.*, b.name AS batch_name FROM assignments a JOIN batches b ON b.id = a.batch_id WHERE a.id = $1`,
            [assignmentId]
        );
        if (aResult.rowCount === 0) return res.status(404).send('Assignment not found.');
        const assignment = aResult.rows[0];

        // Authorization: only creator or institute_admin of same institute
        const isCreator = assignment.created_by === req.user.id;
        const isAdmin = req.user.role === 'institute_admin' && req.user.institute_id === assignment.institute_id;
        if (!isCreator && !isAdmin && req.user.role !== 'admin') {
            return res.status(403).send('Forbidden');
        }

        // Load submission
        const subResult = await db.query(
            `SELECT s.*, u.name AS student_name, u.email AS student_email
             FROM assignment_submissions s
             JOIN users u ON u.id = s.user_id
             WHERE s.assignment_id = $1 AND s.user_id = $2`,
            [assignmentId, studentId]
        );
        if (subResult.rowCount === 0) return res.status(404).send('No submission found for this student.');
        const submission = subResult.rows[0];

        // Load answers with question details
        const answersResult = await db.query(`
            SELECT aa.*, q.question_text, q.option1, q.option2, q.option3, q.option4,
                   q.correct_answer, q.concept_id, q.difficulty_tier, c.name AS concept_name,
                   aq.question_order
            FROM assignment_answers aa
            JOIN questions q ON q.id = aa.question_id
            JOIN assignment_questions aq ON aq.assignment_id = $1 AND aq.question_id = aa.question_id
            LEFT JOIN concepts c ON c.id = q.concept_id
            WHERE aa.submission_id = $2
            ORDER BY aq.question_order
        `, [assignmentId, submission.id]);

        res.render('assignment-student-review.ejs', {
            user: req.user,
            assignment,
            submission,
            answers: answersResult.rows,
        });
    } catch (err) {
        console.error('Error loading student submission:', err);
        res.status(500).send('Server error');
    }
});

// ═══════════════════════════════════════════════════════════════
// TEACHER SUBMISSIONS DASHBOARD
// ═══════════════════════════════════════════════════════════════

// GET /assignments/:id/submissions — teacher views all submissions
router.get('/assignments/:id/submissions', ensureAuthenticated, async (req, res) => {
    try {
        const assignmentId = parseInt(req.params.id);

        // Load assignment
        const aResult = await db.query(
            `SELECT a.*, b.name AS batch_name
             FROM assignments a JOIN batches b ON b.id = a.batch_id
             WHERE a.id = $1`,
            [assignmentId]
        );
        if (aResult.rowCount === 0) return res.status(404).send('Assignment not found.');
        const assignment = aResult.rows[0];

        // Authorization: only creator or institute_admin of same institute
        const isCreator = assignment.created_by === req.user.id;
        const isAdmin = req.user.role === 'institute_admin' && req.user.institute_id === assignment.institute_id;
        if (!isCreator && !isAdmin && req.user.role !== 'admin') {
            return res.status(403).send('Forbidden');
        }

        // Get all students in the batch
        const studentsResult = await db.query(`
            SELECT u.id, u.name, u.email
            FROM batch_students bs
            JOIN users u ON u.id = bs.user_id
            WHERE bs.batch_id = $1
            ORDER BY u.name
        `, [assignment.batch_id]);

        // Get all submissions for this assignment
        const subsResult = await db.query(`
            SELECT s.user_id, s.score, s.max_score, s.time_taken_seconds, s.submitted_at
            FROM assignment_submissions s
            WHERE s.assignment_id = $1
        `, [assignmentId]);

        const submissionMap = {};
        for (const s of subsResult.rows) {
            submissionMap[s.user_id] = s;
        }

        // Build student rows with status
        const now = new Date();
        const deadlinePassed = new Date(assignment.deadline) <= now;
        const students = studentsResult.rows.map(student => {
            const sub = submissionMap[student.id];
            let status = 'Pending';
            if (sub) status = 'Completed';
            else if (deadlinePassed) status = 'Missed';

            return {
                ...student,
                status,
                score: sub ? sub.score : null,
                max_score: sub ? sub.max_score : null,
                percentage: sub ? Math.round((sub.score / sub.max_score) * 100) : null,
                time_taken_seconds: sub ? sub.time_taken_seconds : null,
                submitted_at: sub ? sub.submitted_at : null,
            };
        });

        // Sort by score descending (submitted first, then pending, then missed)
        students.sort((a, b) => {
            if (a.status === 'Completed' && b.status !== 'Completed') return -1;
            if (a.status !== 'Completed' && b.status === 'Completed') return 1;
            if (a.score !== null && b.score !== null) return b.score - a.score;
            return 0;
        });

        // Batch aggregate stats
        const submitted = students.filter(s => s.status === 'Completed');
        const aggregates = {
            totalStudents: students.length,
            submittedCount: submitted.length,
            pendingCount: students.filter(s => s.status === 'Pending').length,
            missedCount: students.filter(s => s.status === 'Missed').length,
            avgScore: submitted.length ? Math.round(submitted.reduce((sum, s) => sum + s.score, 0) / submitted.length) : 0,
            highestScore: submitted.length ? Math.max(...submitted.map(s => s.score)) : 0,
            lowestScore: submitted.length ? Math.min(...submitted.map(s => s.score)) : 0,
            avgTime: submitted.length ? Math.round(submitted.reduce((sum, s) => sum + (s.time_taken_seconds || 0), 0) / submitted.length) : 0,
        };

        // Concept-wise breakdown for submitted students
        const conceptBreakdown = {};
        if (submitted.length > 0) {
            const answersResult = await db.query(`
                SELECT aa.submission_id, aa.is_correct, q.concept_id, c.name AS concept_name,
                       s.user_id
                FROM assignment_answers aa
                JOIN questions q ON q.id = aa.question_id
                LEFT JOIN concepts c ON c.id = q.concept_id
                JOIN assignment_submissions s ON s.id = aa.submission_id
                WHERE s.assignment_id = $1
                ORDER BY q.concept_id
            `, [assignmentId]);

            for (const row of answersResult.rows) {
                const key = row.user_id;
                if (!conceptBreakdown[key]) conceptBreakdown[key] = {};
                const cid = row.concept_id || 'unknown';
                if (!conceptBreakdown[key][cid]) {
                    conceptBreakdown[key][cid] = { concept_name: row.concept_name || 'Unknown', correct: 0, total: 0 };
                }
                conceptBreakdown[key][cid].total++;
                if (row.is_correct) conceptBreakdown[key][cid].correct++;
            }
        }

        // Get question count
        const qCountResult = await db.query(
            'SELECT COUNT(*) AS count FROM assignment_questions WHERE assignment_id = $1',
            [assignmentId]
        );

        res.render('assignment-submissions.ejs', {
            user: req.user,
            assignment,
            students,
            aggregates,
            conceptBreakdown,
            questionCount: parseInt(qCountResult.rows[0].count),
        });
    } catch (err) {
        console.error('Error loading submissions:', err);
        res.status(500).send('Server error');
    }
});

// ═══════════════════════════════════════════════════════════════
// DASHBOARD API
// ═══════════════════════════════════════════════════════════════

// GET /api/assignments/pending — student's assignments for dashboard widget
router.get('/api/assignments/pending', ensureAuthenticated, async (req, res) => {
    try {
        const userId = req.user.id;

        // Get all assignments for batches the student belongs to
        const result = await db.query(`
            SELECT a.id, a.title, a.deadline,
                   (SELECT COUNT(*) FROM assignment_questions aq WHERE aq.assignment_id = a.id) AS question_count,
                   s.id AS submission_id, s.score, s.max_score
            FROM assignments a
            JOIN batch_students bs ON bs.batch_id = a.batch_id AND bs.user_id = $1
            LEFT JOIN assignment_submissions s ON s.assignment_id = a.id AND s.user_id = $1
            ORDER BY a.deadline DESC
            LIMIT 20
        `, [userId]);

        const now = new Date();
        const assignments = result.rows.map(a => ({
            id: a.id,
            title: a.title,
            deadline: a.deadline,
            question_count: parseInt(a.question_count),
            status: computeAssignmentStatus(a.deadline, !!a.submission_id, now),
            score: a.score,
            max_score: a.max_score,
        }));

        res.json({ assignments });
    } catch (err) {
        console.error('Error fetching pending assignments:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

export default router;
