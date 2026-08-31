import express from 'express';
import crypto from 'crypto';
import bcrypt from 'bcrypt';
import multer from 'multer';
import db from '../config/db.js';
import { ensureAuthenticated, ensureInstituteAdmin } from '../middleware/auth.js';
import { parseUploadedFile } from '../services/fileParser.js';

const router = express.Router();
const saltRounds = 12;

// Multer for CSV/XLSX uploads (10MB)
const onboardUpload = multer({
    storage: multer.memoryStorage(),
    limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        const ext = file.originalname.toLowerCase().split('.').pop();
        if (['csv', 'xlsx'].includes(ext)) cb(null, true);
        else cb(new Error('Only CSV and XLSX files are accepted'), false);
    }
});

// ═══════════════════════════════════════════════════════════════
// CSV TEMPLATE DOWNLOAD
// ═══════════════════════════════════════════════════════════════

router.get('/institute/onboard-template', ensureAuthenticated, ensureInstituteAdmin, (req, res) => {
    const csvContent = [
        'student_name,roll_no,class,section,parent_name,parent_phone',
        'Rahul Sharma,2025001,11,A,Rajesh Sharma,9876543210',
        'Priya Verma,2025002,11,A,Suresh Verma,9876543211',
        'Amit Kumar,2025003,12,B,Dinesh Kumar,9876543212'
    ].join('\n');

    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename="student_onboarding_template.csv"');
    res.send(csvContent);
});

// ═══════════════════════════════════════════════════════════════
// CSV BULK INGESTION — Single upload creates everything
//
// Expected columns: student_name, roll_no, class, section, parent_name, parent_phone
// Optional columns: student_email, student_phone
//
// What it does:
//   1. Creates sections (class+section combos) if they don't exist
//   2. Creates student user accounts with PIN = last 4 digits of parent_phone
//   3. Creates parent user accounts (deduplicated by phone number)
//   4. Links students to parents via student_profiles
//   5. Creates student_profiles with roll_no and section assignment
// ═══════════════════════════════════════════════════════════════

router.post('/institute/onboard-students', ensureAuthenticated, ensureInstituteAdmin, (req, res, next) => {
    onboardUpload.single('file')(req, res, (err) => {
        if (err) {
            if (err.code === 'LIMIT_FILE_SIZE') {
                return res.status(400).json({ ok: false, error: 'File exceeds 10MB limit.' });
            }
            return res.status(400).json({ ok: false, error: err.message || 'Upload failed.' });
        }
        next();
    });
}, async (req, res) => {
    const instituteId = req.user.institute_id;
    const uploadedBy = req.user.id;

    if (!req.file) {
        return res.status(400).json({ ok: false, error: 'No file uploaded.' });
    }

    let rows;
    try {
        rows = parseUploadedFile(req.file.buffer, req.file.originalname);
    } catch (e) {
        return res.status(400).json({ ok: false, error: 'Could not parse file. Ensure it is a valid CSV or XLSX.' });
    }

    if (!rows || rows.length === 0) {
        return res.status(400).json({ ok: false, error: 'File contains no data rows.' });
    }

    // Validate required columns exist
    const requiredCols = ['student_name', 'roll_no', 'class', 'section', 'parent_phone'];
    const headers = Object.keys(rows[0]).map(h => h.trim().toLowerCase());
    const missing = requiredCols.filter(col => !headers.includes(col));
    if (missing.length > 0) {
        return res.status(400).json({
            ok: false,
            error: `Missing required columns: ${missing.join(', ')}. Download the template for the correct format.`
        });
    }

    // Create onboarding job record
    const jobResult = await db.query(
        `INSERT INTO onboarding_jobs (institute_id, uploaded_by, filename, job_type, total_rows, status)
         VALUES ($1, $2, $3, 'students', $4, 'processing') RETURNING id`,
        [instituteId, uploadedBy, req.file.originalname, rows.length]
    );
    const jobId = jobResult.rows[0].id;

    // Get or create the active academic year
    let academicYearId;
    const ayResult = await db.query(
        'SELECT id FROM academic_years WHERE institute_id = $1 AND is_active = true LIMIT 1',
        [instituteId]
    );
    if (ayResult.rows[0]) {
        academicYearId = ayResult.rows[0].id;
    } else {
        const newAy = await db.query(
            `INSERT INTO academic_years (institute_id, label, is_active) VALUES ($1, '2025-26', true) RETURNING id`,
            [instituteId]
        );
        academicYearId = newAy.rows[0].id;
    }

    // Get school_code for PIN generation context
    const schoolRes = await db.query('SELECT school_code FROM institutes WHERE id = $1', [instituteId]);
    const schoolCode = schoolRes.rows[0]?.school_code || 'SCHOOL';

    // Process rows
    let createdStudents = 0;
    let createdParents = 0;
    let createdSections = 0;
    let failedRows = 0;
    const errorLog = [];

    // Cache to avoid duplicate DB lookups within this upload
    const sectionCache = new Map();   // "class|section" -> section_id
    const parentCache = new Map();    // phone -> user_id

    // Pre-load existing sections for this institute
    const existingSections = await db.query(
        'SELECT id, class_level, section_name FROM sections WHERE institute_id = $1 AND deleted_at IS NULL',
        [instituteId]
    );
    for (const s of existingSections.rows) {
        sectionCache.set(`${s.class_level}|${s.section_name}`, s.id);
    }

    // Pre-load existing parents (by phone) at this institute
    const existingParents = await db.query(
        `SELECT id, phone FROM users WHERE institute_id = $1 AND role = 'parent' AND phone IS NOT NULL AND deleted_at IS NULL`,
        [instituteId]
    );
    for (const p of existingParents.rows) {
        parentCache.set(p.phone, p.id);
    }

    // Pre-load existing roll numbers to detect duplicates
    const existingRolls = await db.query(
        'SELECT roll_no FROM student_profiles WHERE institute_id = $1 AND deleted_at IS NULL',
        [instituteId]
    );
    const existingRollSet = new Set(existingRolls.rows.map(r => r.roll_no));

    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const rowNum = i + 2; // header is row 1
        const rowErrors = [];

        // Normalize fields
        const studentName = String(row.student_name || '').trim();
        const rollNo = String(row.roll_no || '').trim();
        const classLevel = String(row.class || row['class'] || '').trim();
        const sectionName = String(row.section || '').trim().toUpperCase();
        const parentName = String(row.parent_name || '').trim();
        const parentPhone = String(row.parent_phone || '').trim().replace(/\D/g, '').slice(-10); // last 10 digits
        const studentEmail = String(row.student_email || '').trim().toLowerCase() || null;
        const studentPhone = String(row.student_phone || '').trim().replace(/\D/g, '').slice(-10) || null;

        // Validate
        if (!studentName) rowErrors.push('Missing student_name');
        if (!rollNo) rowErrors.push('Missing roll_no');
        if (!classLevel) rowErrors.push('Missing class');
        if (!sectionName) rowErrors.push('Missing section');
        if (!parentPhone || parentPhone.length !== 10) rowErrors.push('Invalid parent_phone (must be 10 digits)');

        if (existingRollSet.has(rollNo)) {
            rowErrors.push(`Roll number ${rollNo} already exists in this school`);
        }

        if (rowErrors.length > 0) {
            failedRows++;
            errorLog.push({ row: rowNum, errors: rowErrors });
            continue;
        }

        try {
            // ── Step 1: Ensure section exists ──
            const sectionKey = `${classLevel}|${sectionName}`;
            let sectionId = sectionCache.get(sectionKey);
            if (!sectionId) {
                const secResult = await db.query(
                    `INSERT INTO sections (institute_id, academic_year_id, class_level, section_name)
                     VALUES ($1, $2, $3, $4)
                     ON CONFLICT (institute_id, class_level, section_name, academic_year_id) DO UPDATE SET deleted_at = NULL
                     RETURNING id`,
                    [instituteId, academicYearId, classLevel, sectionName]
                );
                sectionId = secResult.rows[0].id;
                sectionCache.set(sectionKey, sectionId);
                createdSections++;
            }

            // ── Step 2: Create or find parent account ──
            let parentUserId = parentCache.get(parentPhone);
            if (!parentUserId) {
                // Check if parent already exists by phone at this institute
                const existingParent = await db.query(
                    `SELECT id FROM users WHERE phone = $1 AND institute_id = $2 AND role = 'parent' AND deleted_at IS NULL`,
                    [parentPhone, instituteId]
                );
                if (existingParent.rows[0]) {
                    parentUserId = existingParent.rows[0].id;
                } else {
                    // Create parent account — no password needed (token-based access)
                    const parentResult = await db.query(
                        `INSERT INTO users (name, phone, role, institute_id, password)
                         VALUES ($1, $2, 'parent', $3, '__token_only__')
                         RETURNING id`,
                        [parentName || `Parent of ${studentName}`, parentPhone, instituteId]
                    );
                    parentUserId = parentResult.rows[0].id;
                    createdParents++;
                }
                parentCache.set(parentPhone, parentUserId);
            }

            // ── Step 3: Create student user account ──
            // PIN = last 4 digits of parent phone (simple, memorable)
            const defaultPin = parentPhone.slice(-4);
            const hashedPin = await bcrypt.hash(defaultPin, saltRounds);

            const studentResult = await db.query(
                `INSERT INTO users (name, email, phone, pin, role, institute_id, password)
                 VALUES ($1, $2, $3, $4, 'student', $5, '__pin_auth__')
                 RETURNING id`,
                [studentName, studentEmail, studentPhone, hashedPin, instituteId]
            );
            const studentUserId = studentResult.rows[0].id;

            // ── Step 4: Create student profile ──
            await db.query(
                `INSERT INTO student_profiles (user_id, institute_id, section_id, roll_no, parent_user_id)
                 VALUES ($1, $2, $3, $4, $5)`,
                [studentUserId, instituteId, sectionId, rollNo, parentUserId]
            );

            // ── Step 5: Add student to the section's batch (if one exists) ──
            // Look for a batch that matches this section (convention: batch name = "Class X - Section Y")
            const batchName = `Class ${classLevel} - ${sectionName}`;
            const batchResult = await db.query(
                `INSERT INTO batches (institute_id, name, invite_code)
                 VALUES ($1, $2, $3)
                 ON CONFLICT DO NOTHING
                 RETURNING id`,
                [instituteId, batchName, crypto.randomBytes(4).toString('hex')]
            );
            let batchId;
            if (batchResult.rows[0]) {
                batchId = batchResult.rows[0].id;
            } else {
                const existing = await db.query(
                    'SELECT id FROM batches WHERE institute_id = $1 AND name = $2 AND deleted_at IS NULL',
                    [instituteId, batchName]
                );
                batchId = existing.rows[0]?.id;
            }
            if (batchId) {
                await db.query(
                    'INSERT INTO batch_students (batch_id, user_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
                    [batchId, studentUserId]
                );
            }

            existingRollSet.add(rollNo);
            createdStudents++;
        } catch (err) {
            failedRows++;
            errorLog.push({ row: rowNum, errors: [err.message] });
        }
    }

    // Update job record
    await db.query(
        `UPDATE onboarding_jobs SET
            created_students = $1, created_parents = $2, created_sections = $3,
            failed_rows = $4, error_log = $5,
            status = 'completed', completed_at = now()
         WHERE id = $6`,
        [createdStudents, createdParents, createdSections, failedRows, JSON.stringify(errorLog), jobId]
    );

    res.json({
        ok: true,
        summary: {
            totalRows: rows.length,
            createdStudents,
            createdParents,
            createdSections,
            failedRows,
            errors: errorLog.slice(0, 20) // Return first 20 errors max
        }
    });
});

// ═══════════════════════════════════════════════════════════════
// MAGIC LINK — Teacher Onboarding
//
// Admin assigns a teacher to a section+subject → system generates
// a one-click login link. Teacher clicks it, lands on their
// pre-populated dashboard. No password creation needed.
// ═══════════════════════════════════════════════════════════════

router.post('/institute/onboard-teacher', ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const { name, email, phone, section_id, subject } = req.body;
        const instituteId = req.user.institute_id;

        if (!name || (!email && !phone)) {
            return res.status(400).json({ ok: false, error: 'Name and either email or phone required.' });
        }
        if (!section_id || !subject) {
            return res.status(400).json({ ok: false, error: 'Section and subject are required.' });
        }

        // Validate section belongs to this institute
        const secCheck = await db.query(
            'SELECT id FROM sections WHERE id = $1 AND institute_id = $2 AND deleted_at IS NULL',
            [section_id, instituteId]
        );
        if (secCheck.rowCount === 0) {
            return res.status(400).json({ ok: false, error: 'Invalid section.' });
        }

        // Check if teacher already exists
        let teacherUserId;
        const normalizedEmail = email ? email.trim().toLowerCase() : null;
        const normalizedPhone = phone ? phone.trim().replace(/\D/g, '').slice(-10) : null;

        let existingTeacher;
        if (normalizedEmail) {
            existingTeacher = await db.query(
                'SELECT id FROM users WHERE email = $1 AND deleted_at IS NULL', [normalizedEmail]
            );
        }
        if (!existingTeacher?.rows[0] && normalizedPhone) {
            existingTeacher = await db.query(
                'SELECT id FROM users WHERE phone = $1 AND institute_id = $2 AND deleted_at IS NULL',
                [normalizedPhone, instituteId]
            );
        }

        if (existingTeacher?.rows[0]) {
            teacherUserId = existingTeacher.rows[0].id;
            // Ensure they're marked as teacher at this institute
            await db.query(
                'UPDATE users SET role = $1, institute_id = $2 WHERE id = $3',
                ['teacher', instituteId, teacherUserId]
            );
        } else {
            // Create teacher account (no password — magic link only)
            const teacherResult = await db.query(
                `INSERT INTO users (name, email, phone, role, institute_id, password)
                 VALUES ($1, $2, $3, 'teacher', $4, '__magic_link__')
                 RETURNING id`,
                [name.trim(), normalizedEmail, normalizedPhone, instituteId]
            );
            teacherUserId = teacherResult.rows[0].id;
        }

        // Create teacher assignment
        await db.query(
            `INSERT INTO teacher_assignments (user_id, institute_id, section_id, subject)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (user_id, section_id, subject) DO UPDATE SET deleted_at = NULL`,
            [teacherUserId, instituteId, parseInt(section_id), subject.trim()]
        );

        // Generate magic link token (valid for 30 days)
        const token = crypto.randomBytes(32).toString('hex');
        const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days

        await db.query(
            `INSERT INTO magic_links (user_id, institute_id, email, phone, token, purpose, expires_at)
             VALUES ($1, $2, $3, $4, $5, 'onboard_teacher', $6)`,
            [teacherUserId, instituteId, normalizedEmail, normalizedPhone, token, expiresAt]
        );

        // Build the magic link URL
        const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
        const magicLink = `${baseUrl}/auth/magic/${token}`;

        res.json({
            ok: true,
            teacherId: teacherUserId,
            magicLink,
            message: `Teacher account created. Share this link with ${name}: ${magicLink}`
        });
    } catch (err) {
        console.error('Teacher onboard error:', err);
        res.status(500).json({ ok: false, error: 'Failed to onboard teacher.' });
    }
});

// ═══════════════════════════════════════════════════════════════
// MAGIC LINK CLAIM — Logs user in directly
// ═══════════════════════════════════════════════════════════════

router.get('/auth/magic/:token', async (req, res) => {
    try {
        const { token } = req.params;

        const result = await db.query(
            `SELECT ml.*, u.id AS uid, u.name, u.role, u.institute_id
             FROM magic_links ml
             LEFT JOIN users u ON u.id = ml.user_id
             WHERE ml.token = $1 AND ml.claimed_at IS NULL AND ml.expires_at > now()`,
            [token]
        );

        if (result.rowCount === 0) {
            return res.status(410).render('login.ejs', {
                error: 'This link has expired or already been used. Please contact your school admin.'
            });
        }

        const link = result.rows[0];

        // Mark as claimed
        await db.query('UPDATE magic_links SET claimed_at = now() WHERE id = $1', [link.id]);

        if (!link.uid) {
            // Edge case: user was deleted between creation and claim
            return res.status(410).render('login.ejs', { error: 'Account not found. Contact your school admin.' });
        }

        // Fetch fresh user data for session
        const userResult = await db.query('SELECT * FROM users WHERE id = $1', [link.uid]);
        const user = userResult.rows[0];

        // Log the user in
        req.login(user, (err) => {
            if (err) {
                console.error('Magic link login error:', err);
                return res.redirect('/login?error=invalid');
            }

            // Redirect based on role
            if (['teacher'].includes(user.role)) {
                return res.redirect('/institute/dashboard/teacher');
            }
            if (['institute_admin', 'school_admin'].includes(user.role)) {
                return res.redirect('/institute/dashboard');
            }
            return res.redirect('/');
        });
    } catch (err) {
        console.error('Magic link claim error:', err);
        res.status(500).send('Server error');
    }
});

// ═══════════════════════════════════════════════════════════════
// STUDENT SIMPLIFIED AUTH — school_code + roll_no + PIN
// ═══════════════════════════════════════════════════════════════

router.post('/auth/student-login', async (req, res) => {
    try {
        const { school_code, roll_no, pin } = req.body;

        if (!school_code || !roll_no || !pin) {
            return res.status(400).json({ ok: false, error: 'School code, roll number, and PIN are required.' });
        }

        const normalizedCode = school_code.trim().toUpperCase();
        const normalizedRoll = roll_no.trim();

        // Look up institute by school_code
        const instResult = await db.query(
            'SELECT id FROM institutes WHERE school_code = $1 AND deleted_at IS NULL',
            [normalizedCode]
        );
        if (instResult.rowCount === 0) {
            return res.status(401).json({ ok: false, error: 'Invalid school code.' });
        }
        const instituteId = instResult.rows[0].id;

        // Find student profile by roll_no within this institute
        const profileResult = await db.query(
            `SELECT sp.user_id, u.name, u.pin, u.role, u.institute_id, u.deleted_at
             FROM student_profiles sp
             JOIN users u ON u.id = sp.user_id
             WHERE sp.institute_id = $1 AND sp.roll_no = $2 AND sp.deleted_at IS NULL`,
            [instituteId, normalizedRoll]
        );

        if (profileResult.rowCount === 0) {
            return res.status(401).json({ ok: false, error: 'Invalid roll number.' });
        }

        const student = profileResult.rows[0];
        if (student.deleted_at) {
            return res.status(401).json({ ok: false, error: 'Account has been deactivated.' });
        }

        // Verify PIN
        if (!student.pin) {
            return res.status(401).json({ ok: false, error: 'PIN not set. Contact your teacher.' });
        }

        const pinMatch = await bcrypt.compare(pin, student.pin);
        if (!pinMatch) {
            return res.status(401).json({ ok: false, error: 'Invalid PIN.' });
        }

        // Fetch full user for session
        const userResult = await db.query('SELECT * FROM users WHERE id = $1', [student.user_id]);
        const user = userResult.rows[0];

        // Log in
        req.login(user, (err) => {
            if (err) {
                return res.status(500).json({ ok: false, error: 'Login failed.' });
            }

            // For form-based login, redirect
            if (req.headers['content-type']?.includes('application/x-www-form-urlencoded')) {
                if (!user.diagnostic_completed) return res.redirect('/diagnostic');
                return res.redirect('/');
            }

            // For API/JSON requests
            return res.json({ ok: true, redirect: user.diagnostic_completed ? '/' : '/diagnostic' });
        });
    } catch (err) {
        console.error('Student login error:', err);
        res.status(500).json({ ok: false, error: 'Login failed.' });
    }
});

// ═══════════════════════════════════════════════════════════════
// PARENT REPORT — Tokenized access (no login required)
// ═══════════════════════════════════════════════════════════════

router.post('/institute/generate-parent-report', ensureAuthenticated, ensureInstituteUser, async (req, res) => {
    try {
        const { student_id } = req.body;
        const instituteId = req.user.institute_id;

        if (!student_id) {
            return res.status(400).json({ ok: false, error: 'student_id is required.' });
        }

        // Verify student belongs to this institute
        const studentCheck = await db.query(
            `SELECT sp.user_id, sp.parent_user_id, u.name AS student_name, pu.phone AS parent_phone
             FROM student_profiles sp
             JOIN users u ON u.id = sp.user_id
             LEFT JOIN users pu ON pu.id = sp.parent_user_id
             WHERE sp.user_id = $1 AND sp.institute_id = $2 AND sp.deleted_at IS NULL`,
            [student_id, instituteId]
        );
        if (studentCheck.rowCount === 0) {
            return res.status(404).json({ ok: false, error: 'Student not found.' });
        }

        const student = studentCheck.rows[0];

        // Generate token (valid for 7 days)
        const token = crypto.randomBytes(24).toString('hex');
        const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);

        await db.query(
            `INSERT INTO parent_report_tokens (token, parent_user_id, student_user_id, institute_id, phone, expires_at)
             VALUES ($1, $2, $3, $4, $5, $6)`,
            [token, student.parent_user_id, student_id, instituteId, student.parent_phone, expiresAt]
        );

        const baseUrl = process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}`;
        const reportLink = `${baseUrl}/report/${token}`;

        res.json({
            ok: true,
            reportLink,
            parentPhone: student.parent_phone,
            studentName: student.student_name,
            expiresAt: expiresAt.toISOString()
        });
    } catch (err) {
        console.error('Generate parent report error:', err);
        res.status(500).json({ ok: false, error: 'Failed to generate report link.' });
    }
});

// GET /report/:token — Public, no auth. Renders mastery report for parent.
router.get('/report/:token', async (req, res) => {
    try {
        const { token } = req.params;

        const result = await db.query(
            `SELECT prt.*, u.name AS student_name, i.name AS institute_name, i.logo_url
             FROM parent_report_tokens prt
             JOIN users u ON u.id = prt.student_user_id
             JOIN institutes i ON i.id = prt.institute_id
             WHERE prt.token = $1 AND prt.expires_at > now()`,
            [token]
        );

        if (result.rowCount === 0) {
            return res.status(410).send(`
                <html><body style="font-family:system-ui;display:flex;justify-content:center;align-items:center;height:100vh;margin:0;">
                <div style="text-align:center;max-width:400px;">
                    <h2>Report Expired</h2>
                    <p>This report link has expired. Please contact your child's school for a new link.</p>
                </div>
                </body></html>
            `);
        }

        const report = result.rows[0];

        // Track access
        await db.query(
            'UPDATE parent_report_tokens SET accessed_at = COALESCE(accessed_at, now()), access_count = access_count + 1 WHERE id = $1',
            [report.id]
        );

        // Fetch mastery data for the student
        const masteryData = await db.query(
            `SELECT c.name AS concept_name, c.subject, ch.name AS chapter_name,
                    ucm.mastery, ucm.questions_answered, ucm.correct_answers, ucm.last_updated
             FROM user_concept_mastery ucm
             JOIN concepts c ON c.id = ucm.concept_id
             LEFT JOIN chapters ch ON ch.id = c.chapter_id
             WHERE ucm.user_id = $1
             ORDER BY c.subject, ch.name, c.name`,
            [report.student_user_id]
        );

        // Group by subject → chapter → concepts
        const subjects = {};
        for (const row of masteryData.rows) {
            if (!subjects[row.subject]) subjects[row.subject] = { chapters: {}, avgMastery: 0, count: 0 };
            const subj = subjects[row.subject];
            const chapterName = row.chapter_name || 'General';
            if (!subj.chapters[chapterName]) subj.chapters[chapterName] = { concepts: [], avgMastery: 0 };
            subj.chapters[chapterName].concepts.push({
                name: row.concept_name,
                mastery: parseFloat(row.mastery),
                questionsAnswered: row.questions_answered,
                correctAnswers: row.correct_answers
            });
            subj.count++;
        }

        // Compute averages
        for (const [subjName, subj] of Object.entries(subjects)) {
            let totalMastery = 0;
            for (const [chName, ch] of Object.entries(subj.chapters)) {
                const chMastery = ch.concepts.reduce((s, c) => s + c.mastery, 0) / ch.concepts.length;
                ch.avgMastery = Math.round(chMastery * 100);
                totalMastery += chMastery * ch.concepts.length;
            }
            subj.avgMastery = subj.count > 0 ? Math.round((totalMastery / subj.count) * 100) : 0;
        }

        res.render('parent-report.ejs', {
            student: { name: report.student_name },
            institute: { name: report.institute_name, logoUrl: report.logo_url },
            subjects,
            generatedAt: report.created_at
        });
    } catch (err) {
        console.error('Parent report view error:', err);
        res.status(500).send('Failed to load report.');
    }
});

// ═══════════════════════════════════════════════════════════════
// UTILITY: List sections for this institute (for teacher assignment UI)
// ═══════════════════════════════════════════════════════════════

router.get('/api/institute/sections', ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const result = await db.query(
            `SELECT s.id, s.class_level, s.section_name, ay.label AS academic_year
             FROM sections s
             LEFT JOIN academic_years ay ON ay.id = s.academic_year_id
             WHERE s.institute_id = $1 AND s.deleted_at IS NULL
             ORDER BY s.class_level, s.section_name`,
            [req.user.institute_id]
        );
        res.json({ ok: true, sections: result.rows });
    } catch (err) {
        res.status(500).json({ ok: false, error: 'Failed to fetch sections.' });
    }
});

// ═══════════════════════════════════════════════════════════════
// UTILITY: List onboarding job history
// ═══════════════════════════════════════════════════════════════

router.get('/api/institute/onboarding-jobs', ensureAuthenticated, ensureInstituteAdmin, async (req, res) => {
    try {
        const result = await db.query(
            `SELECT id, filename, job_type, total_rows, created_students, created_parents,
                    created_sections, failed_rows, status, created_at, completed_at
             FROM onboarding_jobs
             WHERE institute_id = $1
             ORDER BY created_at DESC
             LIMIT 20`,
            [req.user.institute_id]
        );
        res.json({ ok: true, jobs: result.rows });
    } catch (err) {
        res.status(500).json({ ok: false, error: 'Failed to fetch jobs.' });
    }
});

export default router;
