import express from 'express';
import bcrypt from 'bcrypt';
import multer from 'multer';
import db from '../config/db.js';
import { ensureAuthenticated, ensureInstituteAdmin, ensureInstituteUser } from '../middleware/auth.js';
import { geminiGenerate } from '../helpers/gemini.js';
import { classifyQuestionConcept } from '../services/conceptTagger.js';
import { parseUploadedFile } from '../services/fileParser.js';
import { checkPrerequisiteGaps, getOptimalLearningPath } from '../services/prerequisiteService.js';
import { preventRoleElevation } from '../middleware/roleElevation.js';
import { auditLog, AUDIT_ACTIONS } from '../services/auditService.js';

const router = express.Router();
const saltRounds = 12;

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

// Institute registration (public — no auth middleware)
router.get("/institute/register", (req, res) => {
    const error = req.session.instituteRegError || null;
    delete req.session.instituteRegError;
    res.render("institute-register.ejs", { error });
});

router.post("/institute/register", async (req, res) => {
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
router.get("/institute/dashboard", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
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
router.get("/institute/invite", ensureAuthenticated, ensureInstituteAdmin, (req, res) => {
    const success = req.session.inviteSuccess || null;
    const error = req.session.inviteError || null;
    delete req.session.inviteSuccess;
    delete req.session.inviteError;
    res.render("institute-invite.ejs", { user: req.user, success, error });
});

router.post("/institute/invite", ensureAuthenticated, ensureInstituteAdmin, preventRoleElevation('role'), async (req, res) => {
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

// ==================== Bulk Teacher Invite ====================

// GET /institute/invite-teachers — show bulk invite page
router.get("/institute/invite-teachers", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;
        // Load existing invites
        const invites = await db.query(
            `SELECT ti.*, u.name AS claimed_name
             FROM teacher_invites ti
             LEFT JOIN users u ON u.id = ti.claimed_by
             WHERE ti.institute_id = $1
             ORDER BY ti.created_at DESC`,
            [instituteId]
        );
        res.render('institute-invite-teachers.ejs', {
            user: req.user,
            invites: invites.rows,
            error: req.session.bulkInviteError || null,
            success: req.session.bulkInviteSuccess || null,
        });
        delete req.session.bulkInviteError;
        delete req.session.bulkInviteSuccess;
    } catch (err) {
        console.error('Invite teachers page error:', err);
        res.status(500).send('Server error');
    }
});

// POST /institute/invite-teachers — bulk create invite tokens from emails
router.post("/institute/invite-teachers", ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const { emails } = req.body;
        const instituteId = req.user.institute_id;

        // Parse emails: support comma-separated, newline-separated, or mixed
        const emailList = emails
            .split(/[,\n\r]+/)
            .map(e => e.trim().toLowerCase())
            .filter(e => e && e.includes('@'));

        if (emailList.length === 0) {
            req.session.bulkInviteError = 'No valid emails found. Enter emails separated by commas or newlines.';
            return res.redirect('/institute/invite-teachers');
        }

        let created = 0, skipped = 0;
        for (const email of emailList) {
            // Check if already invited
            const existing = await db.query(
                'SELECT id FROM teacher_invites WHERE institute_id = $1 AND email = $2',
                [instituteId, email]
            );
            if (existing.rowCount > 0) { skipped++; continue; }

            // Check if already a user at this institute
            const existingUser = await db.query(
                'SELECT id FROM users WHERE email = $1 AND institute_id = $2',
                [email, instituteId]
            );
            if (existingUser.rowCount > 0) { skipped++; continue; }

            // Generate unique token
            const token = Math.random().toString(36).substring(2) + Math.random().toString(36).substring(2);

            await db.query(
                'INSERT INTO teacher_invites (institute_id, email, token, invited_by) VALUES ($1, $2, $3, $4)',
                [instituteId, email, token, req.user.id]
            );
            created++;
        }

        req.session.bulkInviteSuccess = `${created} invite(s) created, ${skipped} skipped (already invited or registered).`;
        res.redirect('/institute/invite-teachers');
    } catch (err) {
        console.error('Bulk invite error:', err);
        req.session.bulkInviteError = 'Failed to create invites. Please try again.';
        res.redirect('/institute/invite-teachers');
    }
});

// Institute batches management (admin and teachers)
router.get("/institute/batches", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
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

router.post("/institute/batches", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const instituteId = req.user.institute_id;
        const { action } = req.body;

        if (action === 'create') {
            const { name } = req.body;
            if (!name || !name.trim()) {
                req.session.batchError = "Batch name is required.";
                return res.redirect("/institute/batches");
            }
            const inviteCode = Math.random().toString(36).substring(2, 10);
            await db.query(
                "INSERT INTO batches (institute_id, name, invite_code) VALUES ($1, $2, $3)",
                [instituteId, name.trim(), inviteCode]
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
router.get("/institute/questions/upload", ensureAuthenticated, ensureInstituteUser, (req, res) => {
    const error = req.session.uploadError || null;
    const success = req.session.uploadSuccess || null;
    const summary = req.session.uploadSummary || null;
    delete req.session.uploadError;
    delete req.session.uploadSuccess;
    delete req.session.uploadSummary;
    res.render("institute-upload", { error, success, summary });
});

router.post("/institute/questions/upload", ensureAuthenticated, ensureInstituteUser, (req, res, next) => {
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

// ==================== PDF Question Extraction ====================

// Multer for PDF uploads (20MB limit)
const pdfUpload = multer({
    storage: multer.memoryStorage(),
    limits: { fileSize: 20 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        if (file.originalname.toLowerCase().endsWith('.pdf')) cb(null, true);
        else cb(new Error('Only PDF files are accepted'), false);
    }
});

router.post("/institute/questions/upload-pdf", ensureAuthenticated, ensureInstituteUser, (req, res, next) => {
    pdfUpload.single('file')(req, res, (err) => {
        if (err) {
            req.session.uploadError = err.code === 'LIMIT_FILE_SIZE' ? 'File too large (max 20MB).' : (err.message || 'Upload failed.');
            return res.redirect("/institute/questions/upload");
        }
        next();
    });
}, async (req, res) => {
    try {
        if (!req.file) {
            req.session.uploadError = "Please select a PDF file.";
            return res.redirect("/institute/questions/upload");
        }

        const { extractQuestionsFromPDF } = await import('../services/pdfQuestionExtractor.js');
        const subject = req.body.pdf_subject || '';
        const source = req.body.pdf_source || req.file.originalname;

        const questions = await extractQuestionsFromPDF(req.file.buffer, req.file.originalname, { subject, source });

        if (questions.length === 0) {
            req.session.uploadError = "No questions could be extracted from this PDF. Check the format.";
            return res.redirect("/institute/questions/upload");
        }

        // Get concept list for AI tagging
        const conceptsResult = await db.query('SELECT id, name FROM concepts ORDER BY name');
        const conceptList = conceptsResult.rows;

        let imported = 0, failed = 0;
        for (const q of questions) {
            try {
                // AI concept classification
                let conceptId = null, confidence = 0;
                try {
                    const classification = await classifyQuestionConcept(q.question_text, subject, conceptList, geminiGenerate);
                    conceptId = classification.concept_id;
                    confidence = classification.confidence;
                } catch (tagErr) {
                    console.error('Concept tagging failed:', tagErr.message);
                }

                await db.query(
                    `INSERT INTO questions (question_text, option1, option2, option3, option4, correct_answer, solution_text, concept_id, difficulty_tier, source, status, institute_id, concept_confidence, needs_review_tag)
                     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,'pending',$11,$12,$13)`,
                    [q.question_text, q.option1, q.option2, q.option3, q.option4, q.correct_answer, q.solution_text,
                     conceptId, 2, source, req.user.institute_id, confidence, q.needs_review || confidence < 0.7]
                );
                imported++;
            } catch (insertErr) {
                console.error('Failed to insert PDF question:', insertErr.message);
                failed++;
            }
        }

        req.session.uploadSuccess = `PDF extraction complete: ${imported} questions imported, ${failed} failed. All set to 'pending' for review.`;
        res.redirect("/institute/questions/upload");
    } catch (err) {
        console.error('PDF extraction error:', err);
        req.session.uploadError = "PDF extraction failed: " + (err.message || 'Unknown error');
        res.redirect("/institute/questions/upload");
    }
});

// ==================== Question Review Queue ====================

// GET /institute/questions/review — display pending questions for review
router.get("/institute/questions/review", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
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
router.post("/institute/questions/review/:id", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
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

router.get("/institute/dashboard/teacher", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
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

router.get("/institute/dashboard/teacher/gaps/:userId/:conceptId", ensureAuthenticated, ensureInstituteUser, async (req, res) => {
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

export default router;
