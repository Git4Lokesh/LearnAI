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
