import db from '../config/db.js';

export async function getQuestionFromDB(conceptId, difficulty, excludeIds = [], userId = null, instituteId = null) {
    const tierMap = { very_hard: [3], hard: [3, 2], medium: [2], easy: [1, 2], very_easy: [1] };
    const tiers = tierMap[difficulty] || [2];

    if (userId) {
        let paramIndex = 5;
        let instituteFilter = '';
        const params = [conceptId, tiers, userId, excludeIds.length ? excludeIds : [0]];
        if (instituteId) {
            instituteFilter = `AND (q.institute_id = ${paramIndex} OR q.institute_id IS NULL)`;
            params.push(instituteId);
        }
        const recentErrors = await db.query(`
            SELECT q.* FROM questions q
            JOIN user_question_attempts uqa ON q.id = uqa.question_id
            WHERE q.concept_id=$1 AND q.difficulty_tier=ANY($2) AND q.status='approved'
            AND uqa.user_id=$3 AND uqa.correct=false AND uqa.attempted_at > NOW() - INTERVAL '7 days'
            AND q.id != ALL($4)
            ${instituteFilter}
            ORDER BY uqa.attempted_at DESC LIMIT 1
        `, params);

        if (recentErrors.rows[0]) return recentErrors.rows[0];
    }

    let fallbackParamIndex = 4;
    let fallbackInstituteFilter = '';
    const fallbackParams = [conceptId, tiers, excludeIds.length ? excludeIds : [0]];
    if (instituteId) {
        fallbackInstituteFilter = `AND (institute_id = ${fallbackParamIndex} OR institute_id IS NULL)`;
        fallbackParams.push(instituteId);
    }
    const r = await db.query(
        `SELECT * FROM questions WHERE concept_id=$1 AND difficulty_tier=ANY($2) AND status='approved'
         AND id != ALL($3) ${fallbackInstituteFilter} ORDER BY RANDOM() LIMIT 1`,
        fallbackParams
    );
    return r.rows[0] || null;
}
