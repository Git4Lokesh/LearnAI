// In-memory AI rate limiter — 50 Gemini calls per student per day (UTC)
const DAILY_LIMIT = 50;
const counters = new Map();

export function aiRateLimiter(req, res, next) {
    const userId = req.user.id;
    const today = new Date().toISOString().slice(0, 10);
    const key = `${userId}:${today}`;

    const current = counters.get(key) || 0;
    if (current >= DAILY_LIMIT) {
        return res.status(429).json({
            error: 'Daily AI limit reached',
            message: 'You\'ve used all 50 AI calls for today. Try again tomorrow!',
            remaining: 0
        });
    }

    counters.set(key, current + 1);

    // Cleanup old date keys periodically
    if (Math.random() < 0.01) {
        for (const k of counters.keys()) {
            if (!k.endsWith(today)) counters.delete(k);
        }
    }

    res.set('X-AI-Remaining', String(DAILY_LIMIT - current - 1));
    next();
}

export function getAiUsage(userId) {
    const today = new Date().toISOString().slice(0, 10);
    const key = `${userId}:${today}`;
    const used = counters.get(key) || 0;
    return { used, remaining: DAILY_LIMIT - used, limit: DAILY_LIMIT };
}
