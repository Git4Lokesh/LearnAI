import db from '../config/db.js';

// DB-backed AI rate limiter — 50 Gemini calls per student per day (UTC)
const DAILY_LIMIT = 50;
let usageTableReady = false;
let usageTableInitPromise = null;

async function ensureUsageTable() {
    if (usageTableReady) return;
    if (!usageTableInitPromise) {
        usageTableInitPromise = db.query(`
            CREATE TABLE IF NOT EXISTS ai_daily_usage (
                user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                usage_date DATE NOT NULL,
                call_count INTEGER NOT NULL DEFAULT 0,
                updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                PRIMARY KEY (user_id, usage_date)
            );
        `).then(() => {
            usageTableReady = true;
        });
    }
    await usageTableInitPromise;
}

export async function aiRateLimiter(req, res, next) {
    try {
        await ensureUsageTable();
        const userId = req.user.id;

        const usageResult = await db.query(
            `
            INSERT INTO ai_daily_usage (user_id, usage_date, call_count, updated_at)
            VALUES ($1, CURRENT_DATE, 1, NOW())
            ON CONFLICT (user_id, usage_date)
            DO UPDATE SET
                call_count = ai_daily_usage.call_count + 1,
                updated_at = NOW()
            RETURNING call_count
            `,
            [userId]
        );

        const used = parseInt(usageResult.rows[0]?.call_count || 0, 10);
        if (used > DAILY_LIMIT) {
            // Roll back this increment so rejected calls do not consume quota.
            await db.query(
                `
                UPDATE ai_daily_usage
                SET call_count = GREATEST(call_count - 1, 0), updated_at = NOW()
                WHERE user_id = $1 AND usage_date = CURRENT_DATE
                `,
                [userId]
            );
            return res.status(429).json({
                error: 'Daily AI limit reached',
                message: 'You\'ve used all 50 AI calls for today. Try again tomorrow!',
                remaining: 0
            });
        }

        res.set('X-AI-Remaining', String(Math.max(DAILY_LIMIT - used, 0)));
        next();
    } catch (err) {
        console.error('aiRateLimiter error:', err.message);
        next();
    }
}

export async function getAiUsage(userId) {
    await ensureUsageTable();
    const result = await db.query(
        `SELECT call_count FROM ai_daily_usage WHERE user_id = $1 AND usage_date = CURRENT_DATE`,
        [userId]
    );
    const used = parseInt(result.rows[0]?.call_count || 0, 10);
    return { used, remaining: Math.max(DAILY_LIMIT - used, 0), limit: DAILY_LIMIT };
}
