import express from 'express';
import db from '../config/db.js';
import bcrypt from 'bcrypt';
import passport from 'passport';
import { ensureAuthenticated } from '../middleware/auth.js';

const router = express.Router();
const saltRounds = 12;

router.get("/", ensureAuthenticated, async (req, res) => {
    // Redirect institute roles to their appropriate dashboards
    if (req.user.role === 'institute_admin' && req.user.institute_id) {
        return res.redirect("/institute/dashboard");
    }
    if (req.user.role === 'teacher' && req.user.institute_id) {
        return res.redirect("/institute/dashboard/teacher");
    }
    // Redirect new students to diagnostic test
    if (req.user.role === 'student' && !req.user.diagnostic_completed) {
        return res.redirect("/diagnostic");
    }
    try {
        const [conceptsRes, prereqsRes, masteryRes, chaptersRes, chapterPrereqsRes] = await Promise.all([
            db.query('SELECT id, name, subject, chapter_id FROM concepts ORDER BY subject, name'),
            db.query('SELECT concept_id, prereq_id FROM concept_prerequisites'),
            db.query('SELECT concept_id, mastery, questions_answered, correct_answers FROM user_concept_mastery WHERE user_id=$1', [req.user.id]),
            db.query('SELECT id, name, subject FROM chapters ORDER BY display_order'),
            db.query('SELECT chapter_id, prereq_id FROM chapter_prerequisites')
        ]);
        res.render('dashboard.ejs', {
            user: req.user,
            graphData: {
                userId: req.user.id,
                concepts: conceptsRes.rows,
                prereqs: prereqsRes.rows,
                mastery: masteryRes.rows,
                chapters: chaptersRes.rows,
                chapterPrereqs: chapterPrereqsRes.rows
            }
        });
    } catch (error) {
        console.error('Graph load error:', error);
        res.render('dashboard.ejs', { user: req.user, graphData: { userId: req.user.id, concepts: [], prereqs: [], mastery: [], chapters: [], chapterPrereqs: [] } });
    }
});

router.get("/signup", (req, res) => {
    res.render("signup.ejs");
});

router.get("/login", (req, res) => {
    const error = req.query.error === 'invalid' ? 'Invalid email or password' : null;
    res.render("login.ejs", { error });
});

// Student simplified login page (school_code + roll_no + PIN)
router.get("/student-login", (req, res) => {
    res.render("student-login.ejs");
});

router.post("/signup", async (req, res) => {
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
            // New students go straight to diagnostic
            if (user.role === 'student' || !user.role) {
                return res.redirect("/diagnostic");
            }
            res.redirect("/");
        });
    } catch (error) {
        console.error('Signup error:', error);
        res.status(500).send("Registration failed");
    }
});

// ═══════════════════════════════════════════════════════════════
// MAGIC INVITE LINK — Batch Join Flow
// ═══════════════════════════════════════════════════════════════

// GET /join/redirect?code=xxx — redirect from signup page join code form
router.get("/join/redirect", (req, res) => {
    const code = (req.query.code || '').trim();
    if (!code) return res.redirect('/signup');
    res.redirect(`/join/${code}`);
});

// ═══════════════════════════════════════════════════════════════
// TEACHER INVITE CLAIM
// ═══════════════════════════════════════════════════════════════

// GET /invite/teacher/:token — show teacher signup form
router.get("/invite/teacher/:token", async (req, res) => {
    try {
        const result = await db.query(
            `SELECT ti.*, i.name AS institute_name
             FROM teacher_invites ti
             JOIN institutes i ON i.id = ti.institute_id
             WHERE ti.token = $1`,
            [req.params.token]
        );
        if (result.rowCount === 0) {
            return res.render('signup.ejs', { error: 'Invalid or expired invite link.' });
        }
        const invite = result.rows[0];
        if (invite.claimed_by) {
            return res.render('login.ejs', { error: 'This invite has already been claimed. Please log in.' });
        }
        res.render('claim-teacher-invite.ejs', { invite, error: req.session.claimError || null });
        delete req.session.claimError;
    } catch (err) {
        console.error('Teacher invite page error:', err);
        res.status(500).send('Server error');
    }
});

// POST /invite/teacher/:token — create teacher account
router.post("/invite/teacher/:token", async (req, res) => {
    try {
        const { fullName, password } = req.body;
        const token = req.params.token;

        const inviteResult = await db.query(
            `SELECT ti.*, i.name AS institute_name
             FROM teacher_invites ti
             JOIN institutes i ON i.id = ti.institute_id
             WHERE ti.token = $1`,
            [token]
        );
        if (inviteResult.rowCount === 0) {
            return res.render('signup.ejs', { error: 'Invalid invite link.' });
        }
        const invite = inviteResult.rows[0];
        if (invite.claimed_by) {
            return res.render('login.ejs', { error: 'This invite has already been claimed.' });
        }

        // Check if email already exists
        const existing = await db.query('SELECT id FROM users WHERE email = $1', [invite.email]);
        if (existing.rowCount > 0) {
            // Update existing user to teacher role at this institute
            await db.query(
                'UPDATE users SET role = $1, institute_id = $2 WHERE email = $3',
                ['teacher', invite.institute_id, invite.email]
            );
            await db.query(
                'UPDATE teacher_invites SET claimed_by = (SELECT id FROM users WHERE email = $1), claimed_at = now() WHERE id = $2',
                [invite.email, invite.id]
            );
            req.session.claimError = 'Your account has been upgraded to teacher. Please log in.';
            return res.redirect('/login');
        }

        // Create new teacher account
        const hash = await bcrypt.hash(password, saltRounds);
        const userResult = await db.query(
            "INSERT INTO users (email, password, name, role, institute_id) VALUES ($1, $2, $3, 'teacher', $4) RETURNING *",
            [invite.email, hash, fullName, invite.institute_id]
        );
        const user = userResult.rows[0];

        // Mark invite as claimed
        await db.query(
            'UPDATE teacher_invites SET claimed_by = $1, claimed_at = now() WHERE id = $2',
            [user.id, invite.id]
        );

        // Log in and redirect
        req.login(user, (err) => {
            if (err) return res.status(500).send('Login failed');
            return res.redirect('/institute/dashboard/teacher');
        });
    } catch (err) {
        console.error('Teacher claim error:', err);
        req.session.claimError = 'Registration failed. Please try again.';
        res.redirect(`/invite/teacher/${req.params.token}`);
    }
});

// GET /join/:code — show signup form with batch/institute pre-filled
router.get("/join/:code", async (req, res) => {
    try {
        const result = await db.query(
            `SELECT b.id AS batch_id, b.name AS batch_name, b.invite_code,
                    i.id AS institute_id, i.name AS institute_name
             FROM batches b
             JOIN institutes i ON i.id = b.institute_id
             WHERE b.invite_code = $1`,
            [req.params.code]
        );
        if (result.rowCount === 0) {
            return res.render('signup.ejs', { error: 'Invalid invite link. Please check with your teacher.' });
        }
        const batch = result.rows[0];
        res.render('join-batch.ejs', {
            batch,
            error: req.session.joinError || null,
        });
        delete req.session.joinError;
    } catch (err) {
        console.error('Join page error:', err);
        res.status(500).send('Server error');
    }
});

// POST /join/:code — create student account and auto-join batch
router.post("/join/:code", async (req, res) => {
    try {
        const { fullName, email, password } = req.body;
        const code = req.params.code;

        // Look up batch
        const batchResult = await db.query(
            `SELECT b.id AS batch_id, b.institute_id, b.name AS batch_name, i.name AS institute_name
             FROM batches b JOIN institutes i ON i.id = b.institute_id
             WHERE b.invite_code = $1`,
            [code]
        );
        if (batchResult.rowCount === 0) {
            return res.render('signup.ejs', { error: 'Invalid invite code.' });
        }
        const batch = batchResult.rows[0];

        // Check if email already exists
        const existing = await db.query("SELECT * FROM users WHERE email = $1", [email]);
        if (existing.rowCount > 0) {
            const existingUser = existing.rows[0];
            // If user exists but not in this batch, add them
            if (existingUser.institute_id === batch.institute_id) {
                const alreadyInBatch = await db.query(
                    'SELECT 1 FROM batch_students WHERE batch_id = $1 AND user_id = $2',
                    [batch.batch_id, existingUser.id]
                );
                if (alreadyInBatch.rowCount === 0) {
                    await db.query('INSERT INTO batch_students (batch_id, user_id) VALUES ($1, $2)', [batch.batch_id, existingUser.id]);
                }
                // Log them in
                return req.login(existingUser, (err) => {
                    if (err) return res.status(500).send('Login failed');
                    return res.redirect('/');
                });
            }
            req.session.joinError = 'This email is already registered with a different institute. Please use a different email or contact your teacher.';
            return res.redirect(`/join/${code}`);
        }

        // Create new student account
        const hash = await bcrypt.hash(password, saltRounds);
        const userResult = await db.query(
            "INSERT INTO users (email, password, name, role, institute_id) VALUES ($1, $2, $3, 'student', $4) RETURNING *",
            [email, hash, fullName, batch.institute_id]
        );
        const user = userResult.rows[0];

        // Add to batch
        await db.query('INSERT INTO batch_students (batch_id, user_id) VALUES ($1, $2)', [batch.batch_id, user.id]);

        // Log in and redirect to diagnostic
        req.login(user, (err) => {
            if (err) return res.status(500).send('Login failed');
            return res.redirect('/diagnostic');
        });
    } catch (err) {
        console.error('Join error:', err);
        req.session.joinError = 'Registration failed. Please try again.';
        res.redirect(`/join/${req.params.code}`);
    }
});

router.post("/login", (req, res, next) => {
    const selectedRole = req.body.role || 'student'; // from hidden field

    passport.authenticate("local", (err, user, info) => {
        if (err) {
            console.error("Authentication error:", err);
            return next(err);
        }

        if (!user) {
            return res.redirect("/login?error=invalid");
        }

        // Validate role matches what user selected
        const userRole = user.role || 'student';
        if (selectedRole === 'admin' && userRole !== 'institute_admin') {
            return res.redirect("/login?error=invalid");
        }
        if (selectedRole === 'teacher' && userRole !== 'teacher') {
            return res.redirect("/login?error=invalid");
        }
        if (selectedRole === 'student' && userRole !== 'student') {
            return res.redirect("/login?error=invalid");
        }

        req.logIn(user, (loginErr) => {
            if (loginErr) {
                console.error("Login error:", loginErr);
                return next(loginErr);
            }
            if (user.role === 'institute_admin' && user.institute_id) {
                return res.redirect("/institute/dashboard");
            }
            if (user.role === 'teacher' && user.institute_id) {
                return res.redirect("/institute/dashboard/teacher");
            }
            return res.redirect("/");
        });
    })(req, res, next);
});

router.post("/logout", (req, res) => {
    req.logout((err) => {
        if (err) {
            console.error('Logout error:', err);
            return res.status(500).send('Logout failed');
        }
        res.redirect("/login");
    });
});

export default router;
