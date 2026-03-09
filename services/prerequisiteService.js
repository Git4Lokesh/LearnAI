// Enhanced prerequisite checking and learning path optimization
export async function checkPrerequisiteGaps(db, userId, conceptId) {
    const result = await db.query(`
        WITH RECURSIVE prereq_chain AS (
            SELECT concept_id, prereq_id, 1 as depth FROM concept_prerequisites WHERE concept_id = $1
            UNION ALL
            SELECT cp.concept_id, cp.prereq_id, pc.depth + 1 
            FROM concept_prerequisites cp
            JOIN prereq_chain pc ON cp.concept_id = pc.prereq_id
            WHERE pc.depth < 5
        )
        SELECT DISTINCT p.prereq_id as concept_id, c.name,
               COALESCE(ucm.mastery, 0.2) as mastery,
               p.depth
        FROM prereq_chain p
        JOIN concepts c ON c.id = p.prereq_id
        LEFT JOIN user_concept_mastery ucm ON ucm.concept_id = p.prereq_id AND ucm.user_id = $2
        WHERE COALESCE(ucm.mastery, 0.2) < 0.7
        ORDER BY p.depth ASC, COALESCE(ucm.mastery, 0.2) ASC
    `, [conceptId, userId]);
    
    return result.rows;
}

export async function getOptimalLearningPath(db, userId, targetConceptId) {
    const gaps = await checkPrerequisiteGaps(db, userId, targetConceptId);
    if (gaps.length === 0) return [targetConceptId];
    
    // Return path: weakest prerequisites first, then target
    return [...gaps.map(g => g.concept_id), targetConceptId];
}