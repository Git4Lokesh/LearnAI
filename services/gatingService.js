// Prerequisite gating service — server-side enforcement of unit and subconcept unlock logic
// Reads from chapter_prerequisites, concept_prerequisites, user_concept_mastery
// Never writes — pure query layer

export const MASTERY_THRESHOLD = 0.8;

/**
 * Check if a unit (chapter) is unlocked for a given student.
 * A unit is unlocked when:
 *   - It has no rows in chapter_prerequisites (starting unit), OR
 *   - Every subconcept in every prerequisite unit has mastery >= MASTERY_THRESHOLD
 *
 * @param {pg.Client} db
 * @param {number} userId
 * @param {string} chapterId
 * @returns {Promise<{unlocked: boolean, unmetPrereqs: Array<{id: string, name: string, mastery: number, unitId: string, unitName: string}>}>}
 */
export async function isUnitUnlocked(db, userId, chapterId) {
    const result = await db.query(`
        SELECT cp.prereq_id AS unit_id,
               ch.name AS unit_name,
               c.id AS concept_id,
               c.name AS concept_name,
               COALESCE(ucm.mastery, 0.0) AS mastery
        FROM chapter_prerequisites cp
        JOIN chapters ch ON ch.id = cp.prereq_id
        JOIN concepts c ON c.chapter_id = cp.prereq_id
        LEFT JOIN user_concept_mastery ucm
               ON ucm.concept_id = c.id AND ucm.user_id = $1
        WHERE cp.chapter_id = $2
          AND COALESCE(ucm.mastery, 0.0) < $3
        ORDER BY ch.name, c.name
    `, [userId, chapterId, MASTERY_THRESHOLD]);

    if (result.rows.length === 0) {
        return { unlocked: true, unmetPrereqs: [] };
    }

    return {
        unlocked: false,
        unmetPrereqs: result.rows.map(r => ({
            id: r.concept_id,
            name: r.concept_name,
            mastery: parseFloat(r.mastery),
            unitId: r.unit_id,
            unitName: r.unit_name
        }))
    };
}


/**
 * Check if a subconcept is unlocked for a given student.
 * A subconcept is unlocked when:
 *   - Its parent unit is unlocked, AND
 *   - It has no rows in concept_prerequisites (starting subconcept), OR
 *   - Every prerequisite subconcept has mastery >= MASTERY_THRESHOLD
 *
 * @param {pg.Client} db
 * @param {number} userId
 * @param {string} conceptId
 * @returns {Promise<{unlocked: boolean, reason: string|null, unmetPrereqs: Array<{id: string, name: string, mastery: number}>}>}
 */
export async function isSubconceptUnlocked(db, userId, conceptId) {
    // Step 1: Look up the subconcept's parent unit
    const conceptRes = await db.query(
        'SELECT chapter_id FROM concepts WHERE id = $1', [conceptId]
    );

    if (conceptRes.rows.length === 0) {
        // Concept not found — let the caller handle 404
        return { unlocked: false, reason: 'not_found', unmetPrereqs: [] };
    }

    const chapterId = conceptRes.rows[0].chapter_id;

    // Orphan subconcept (no parent unit) — treat as unlocked at unit level with warning
    if (!chapterId) {
        console.warn(`[gatingService] Subconcept ${conceptId} has no chapter_id (orphan). Treating as unit-unlocked.`);
    } else {
        // Step 2: Check if parent unit is unlocked
        const unitResult = await isUnitUnlocked(db, userId, chapterId);
        if (!unitResult.unlocked) {
            return {
                unlocked: false,
                reason: 'unit_locked',
                unmetPrereqs: unitResult.unmetPrereqs
            };
        }
    }

    // Step 3: Check subconcept-level prerequisites
    const prereqResult = await db.query(`
        SELECT cp.prereq_id AS id,
               c.name,
               COALESCE(ucm.mastery, 0.0) AS mastery
        FROM concept_prerequisites cp
        JOIN concepts c ON c.id = cp.prereq_id
        LEFT JOIN user_concept_mastery ucm
               ON ucm.concept_id = cp.prereq_id AND ucm.user_id = $1
        WHERE cp.concept_id = $2
          AND COALESCE(ucm.mastery, 0.0) < $3
        ORDER BY c.name
    `, [userId, conceptId, MASTERY_THRESHOLD]);

    if (prereqResult.rows.length === 0) {
        return { unlocked: true, reason: null, unmetPrereqs: [] };
    }

    return {
        unlocked: false,
        reason: 'prereqs_not_met',
        unmetPrereqs: prereqResult.rows.map(r => ({
            id: r.id,
            name: r.name,
            mastery: parseFloat(r.mastery)
        }))
    };
}
