import passport from 'passport';
import { Strategy } from 'passport-local';
import bcrypt from 'bcrypt';
import db from './db.js';

passport.use(new Strategy({
    usernameField: 'email',
    passwordField: 'password'
}, async function (email, password, done) {
    try {
        if (!email || !password) {
            return done(null, false, { message: 'Email and password required' });
        }

        const result = await db.query("SELECT * FROM users WHERE email = $1", [email]);

        if (result.rowCount === 0) {
            return done(null, false, { message: 'Invalid credentials' });
        }

        const user = result.rows[0];
        const isMatch = await bcrypt.compare(password, user.password);

        if (isMatch) {
            return done(null, user);
        } else {
            return done(null, false, { message: 'Invalid credentials' });
        }
    } catch (error) {
        console.error("Strategy error:", error);
        return done(error);
    }
}));

passport.serializeUser((user, cb) => {
    const { password, ...userWithoutPassword } = user;
    cb(null, userWithoutPassword);
});

passport.deserializeUser((user, cb) => {
    cb(null, user);
});

export default passport;
