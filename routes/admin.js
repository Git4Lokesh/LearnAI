import express from 'express';
import db from '../config/db.js';
import { ensureAdmin, ensureInstituteUser } from '../middleware/auth.js';
import { bktFit, bktFitDry, bktGetParams, bktGetAllParams, bktReloadParams } from '../services/bktClient.js';
import { compileReportData, generateReportPDF, sanitizeFilename } from '../services/reportCardService.js';

const router = express.Router();

// Admin: verify queue
router.get('/admin/verify', ensureAdmin, async (req, res) => {
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
router.post('/admin/verify/:id', ensureAdmin, async (req, res) => {
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
router.get('/admin/payouts', ensureAdmin, async (req, res) => {
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
router.post('/api/bkt/fit', ensureAdmin, async (req, res) => {
    try {
        const result = await bktFit('admin');
        res.json(result);
    } catch (err) {
        console.error('BKT fit error:', err.message);
        res.status(500).json({ error: 'BKT fitting failed', details: err.message });
    }
});

// Dry-run EM fitting (no DB writes, just prints results)
router.post('/api/bkt/fit-dry', ensureAdmin, async (req, res) => {
    try {
        const result = await bktFitDry();
        res.json(result);
    } catch (err) {
        console.error('BKT fit-dry error:', err.message);
        res.status(500).json({ error: 'BKT dry-run failed', details: err.message });
    }
});

// Get BKT params for a specific concept
router.get('/api/bkt/params/:conceptId', ensureAdmin, async (req, res) => {
    try {
        const result = await bktGetParams(req.params.conceptId);
        res.json(result);
    } catch (err) {
        console.error('BKT params error:', err.message);
        res.status(500).json({ error: 'Failed to get BKT params', details: err.message });
    }
});

// List all learned BKT params
router.get('/api/bkt/params', ensureAdmin, async (req, res) => {
    try {
        const result = await bktGetAllParams();
        res.json(result);
    } catch (err) {
        console.error('BKT all params error:', err.message);
        res.status(500).json({ error: 'Failed to get all BKT params', details: err.message });
    }
});

// Force reload learned params into BKT cache
router.post('/api/bkt/reload-params', ensureAdmin, async (req, res) => {
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
router.post('/api/syllabus/mark', ensureInstituteUser, async (req, res) => {
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
router.delete('/api/syllabus/unmark', ensureInstituteUser, async (req, res) => {
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
router.get('/api/syllabus/status/:batchId', ensureInstituteUser, async (req, res) => {
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
router.get('/api/syllabus/delta/:batchId', ensureInstituteUser, async (req, res) => {
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
router.get('/api/report-card/:studentId', ensureInstituteUser, async (req, res) => {
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

export default router;
