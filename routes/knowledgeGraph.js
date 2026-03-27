import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';

const router = express.Router();

// Helper: Detect and filter circular dependencies from prerequisite edges
function filterCircularDependencies(edges) {
    // Build adjacency list
    const adj = {};
    edges.forEach(e => {
        if (!adj[e.prereq_id]) adj[e.prereq_id] = [];
        adj[e.prereq_id].push(e.chapter_id);
    });

    // DFS-based cycle detection
    const WHITE = 0, GRAY = 1, BLACK = 2;
    const color = {};
    const cyclicEdges = new Set();

    function dfs(node, path) {
        color[node] = GRAY;
        path.push(node);

        for (const neighbor of (adj[node] || [])) {
            if (color[neighbor] === GRAY) {
                // Found a cycle - log it and mark the edge
                const cycleStart = path.indexOf(neighbor);
                const cyclePath = path.slice(cycleStart).concat(neighbor);
                console.error('[KnowledgeGraph] Circular dependency detected:', cyclePath.join(' → '));
                cyclicEdges.add(node + '->' + neighbor);
            } else if (color[neighbor] !== BLACK) {
                dfs(neighbor, path);
            }
        }

        path.pop();
        color[node] = BLACK;
    }

    // Get all unique nodes
    const allNodes = new Set();
    edges.forEach(e => { allNodes.add(e.prereq_id); allNodes.add(e.chapter_id); });

    allNodes.forEach(node => {
        if (!color[node]) dfs(node, []);
    });

    // Filter out cyclic edges
    return edges.filter(e => !cyclicEdges.has(e.prereq_id + '->' + e.chapter_id));
}

// GET /api/chapters - Returns all chapters with prerequisite relationships and bridge edges
router.get('/api/chapters', ensureAuthenticated, async (req, res) => {
    try {
        const { subject } = req.query;

        // Validate subject parameter if provided
        if (subject && typeof subject !== 'string') {
            return res.status(400).json({ error: 'Invalid subject parameter' });
        }

        // Query chapters with optional subject filter
        let chaptersQuery = 'SELECT id, name, subject, display_order, description FROM chapters';
        const queryParams = [];

        if (subject) {
            chaptersQuery += ' WHERE subject = $1';
            queryParams.push(subject);
        }

        chaptersQuery += ' ORDER BY display_order';

        const chaptersResult = await db.query(chaptersQuery, queryParams);

        // Query all chapter prerequisites
        const prerequisitesResult = await db.query(
            'SELECT chapter_id, prereq_id FROM chapter_prerequisites'
        );

        // Detect and exclude circular dependencies
        const prereqEdges = prerequisitesResult.rows;
        const validPrereqs = filterCircularDependencies(prereqEdges);

        // Calculate bridge edges: cross-chapter concept dependencies
        let bridgeEdges = [];
        try {
            const bridgeResult = await db.query(
                `SELECT 
                    c1.chapter_id as from_chapter,
                    c2.chapter_id as to_chapter,
                    COUNT(*) as concept_count
                 FROM concept_prerequisites cp
                 JOIN concepts c1 ON c1.id = cp.prereq_id
                 JOIN concepts c2 ON c2.id = cp.concept_id
                 WHERE c1.chapter_id != c2.chapter_id
                    AND c1.chapter_id IS NOT NULL
                    AND c2.chapter_id IS NOT NULL
                 GROUP BY c1.chapter_id, c2.chapter_id`
            );
            bridgeEdges = bridgeResult.rows.map(row => ({
                from_chapter: row.from_chapter,
                to_chapter: row.to_chapter,
                concept_count: parseInt(row.concept_count)
            }));
        } catch (bridgeError) {
            console.error('[KnowledgeGraph] Error calculating bridge edges:', bridgeError.message);
        }

        res.json({
            chapters: chaptersResult.rows,
            prerequisites: validPrereqs,
            bridgeEdges: bridgeEdges
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching chapters:', error.message, { query: 'GET /api/chapters', subject: req.query.subject });
        res.status(500).json({ error: 'Failed to fetch chapters. Please try again later.' });
    }
});

// GET /api/chapters/:chapterId/concepts - Returns micro-concepts for a specific chapter
router.get('/api/chapters/:chapterId/concepts', ensureAuthenticated, async (req, res) => {
    try {
        const { chapterId } = req.params;
        const { userId } = req.query;

        // Validate chapterId - alphanumeric with underscores only
        if (!chapterId || !/^[a-zA-Z0-9_]+$/.test(chapterId)) {
            return res.status(400).json({ error: 'Invalid chapter_id parameter' });
        }

        // Validate userId if provided
        if (userId && !/^\d+$/.test(userId)) {
            return res.status(400).json({ error: 'Invalid user_id parameter' });
        }

        // Get chapter info
        const chapterResult = await db.query(
            'SELECT id, name FROM chapters WHERE id = $1',
            [chapterId]
        );

        if (chapterResult.rows.length === 0) {
            return res.status(404).json({ error: 'Chapter not found' });
        }

        // Get concepts in this chapter
        const conceptsResult = await db.query(
            'SELECT id, name, chapter_id FROM concepts WHERE chapter_id = $1',
            [chapterId]
        );

        const conceptIds = conceptsResult.rows.map(c => c.id);

        // Get prerequisites for these concepts
        let prerequisitesRows = [];
        if (conceptIds.length > 0) {
            const prerequisitesResult = await db.query(
                'SELECT concept_id, prereq_id FROM concept_prerequisites WHERE concept_id = ANY($1)',
                [conceptIds]
            );
            prerequisitesRows = prerequisitesResult.rows;
        }

        // Identify ghost nodes (prerequisites from other chapters) with validation
        let ghostNodes = [];
        if (conceptIds.length > 0) {
            const ghostNodesResult = await db.query(
                `SELECT DISTINCT 
                    c.id, 
                    c.name, 
                    c.chapter_id,
                    ch.name as chapter_name
                FROM concept_prerequisites cp
                JOIN concepts c ON c.id = cp.prereq_id
                JOIN chapters ch ON ch.id = c.chapter_id
                WHERE cp.concept_id = ANY($1)
                    AND c.chapter_id != $2
                    AND c.chapter_id IS NOT NULL`,
                [conceptIds, chapterId]
            );
            // Validate ghost nodes - only include those with valid concept and chapter references
            ghostNodes = ghostNodesResult.rows.filter(g => {
                if (!g.id || !g.chapter_id || !g.chapter_name) {
                    console.warn('[KnowledgeGraph] Excluding invalid ghost node: missing concept or chapter reference', { ghostId: g.id, chapterId: g.chapter_id });
                    return false;
                }
                return true;
            });
        }

        res.json({
            chapter: chapterResult.rows[0],
            concepts: conceptsResult.rows,
            prerequisites: prerequisitesRows,
            ghostNodes: ghostNodes
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching chapter concepts:', error.message, { query: 'GET /api/chapters/:chapterId/concepts', chapterId: req.params.chapterId });
        res.status(500).json({ error: 'Failed to fetch chapter concepts. Please try again later.' });
    }
});

// Helper function: Calculate chapter mastery for a user
async function calculateChapterMastery(userId, chapterId) {
    try {
        // Query all concepts in chapter
        const conceptsResult = await db.query(
            'SELECT id FROM concepts WHERE chapter_id = $1',
            [chapterId]
        );

        if (conceptsResult.rows.length === 0) return null;

        const conceptIds = conceptsResult.rows.map(c => c.id);

        // Query mastery for each concept
        const masteryResult = await db.query(
            `SELECT concept_id, mastery 
             FROM user_concept_mastery 
             WHERE user_id = $1 AND concept_id = ANY($2)`,
            [userId, conceptIds]
        );

        if (masteryResult.rows.length === 0) return null;

        // Calculate average across ALL concepts in chapter (unattempted = 0)
        const totalMastery = masteryResult.rows.reduce((sum, row) => sum + parseFloat(row.mastery), 0);
        return totalMastery / conceptIds.length;
    } catch (error) {
        console.error('[KnowledgeGraph] Error calculating chapter mastery:', error.message, { userId, chapterId });
        return null;
    }
}

// GET /api/user/:userId/chapter-mastery - Returns chapter mastery scores for a user
router.get('/api/user/:userId/chapter-mastery', ensureAuthenticated, async (req, res) => {
    try {
        const { userId } = req.params;

        // Validate userId - must be numeric
        if (!userId || !/^\d+$/.test(userId)) {
            return res.status(400).json({ error: 'Invalid user_id parameter' });
        }

        // Ensure user can only access their own data (or is admin/teacher)
        if (req.user.id !== parseInt(userId) && req.user.role !== 'admin' && req.user.role !== 'teacher') {
            return res.status(403).json({ error: 'Unauthorized' });
        }

        // Query all chapters
        const chaptersResult = await db.query('SELECT id FROM chapters ORDER BY display_order');

        // Calculate mastery for each chapter
        const chapterMastery = [];
        for (const chapter of chaptersResult.rows) {
            const mastery = await calculateChapterMastery(userId, chapter.id);
            if (mastery !== null) {
                // Get concept counts
                const conceptsResult = await db.query(
                    'SELECT COUNT(*) as total FROM concepts WHERE chapter_id = $1',
                    [chapter.id]
                );
                const masteredResult = await db.query(
                    `SELECT COUNT(DISTINCT ucm.concept_id) as mastered
                     FROM user_concept_mastery ucm
                     JOIN concepts c ON c.id = ucm.concept_id
                     WHERE ucm.user_id = $1 AND c.chapter_id = $2 AND ucm.mastery >= 0.8`,
                    [userId, chapter.id]
                );

                chapterMastery.push({
                    chapter_id: chapter.id,
                    mastery: mastery,
                    concept_count: parseInt(conceptsResult.rows[0].total),
                    mastered_count: parseInt(masteredResult.rows[0].mastered)
                });
            }
        }

        res.json({
            userId: parseInt(userId),
            chapterMastery: chapterMastery
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching user chapter mastery:', error.message, { query: 'GET /api/user/:userId/chapter-mastery', userId: req.params.userId });
        res.status(500).json({ error: 'Failed to fetch chapter mastery. Please try again later.' });
    }
});

// Helper function: Calculate batch chapter mastery
async function calculateBatchChapterMastery(batchId) {
    try {
        // Get all students in batch
        const studentsResult = await db.query(
            'SELECT user_id FROM batch_students WHERE batch_id = $1',
            [batchId]
        );

        if (studentsResult.rows.length === 0) return [];

        const studentIds = studentsResult.rows.map(s => s.user_id);

        // Aggregate mastery by chapter
        const batchMasteryResult = await db.query(
            `SELECT 
                c.chapter_id,
                AVG(ucm.mastery) as avg_mastery,
                MIN(ucm.mastery) as min_mastery,
                MAX(ucm.mastery) as max_mastery,
                COUNT(DISTINCT CASE WHEN ucm.mastery >= 0.8 THEN ucm.user_id END) as students_mastered
             FROM concepts c
             JOIN user_concept_mastery ucm ON ucm.concept_id = c.id
             WHERE ucm.user_id = ANY($1)
                AND c.chapter_id IS NOT NULL
             GROUP BY c.chapter_id`,
            [studentIds]
        );

        return batchMasteryResult.rows.map(row => ({
            chapter_id: row.chapter_id,
            avg_mastery: parseFloat(row.avg_mastery),
            min_mastery: parseFloat(row.min_mastery),
            max_mastery: parseFloat(row.max_mastery),
            students_mastered: parseInt(row.students_mastered)
        }));
    } catch (error) {
        console.error('[KnowledgeGraph] Error calculating batch chapter mastery:', error.message, { batchId });
        return [];
    }
}

// GET /api/batch/:batchId/chapter-mastery - Returns aggregated chapter mastery for a batch
router.get('/api/batch/:batchId/chapter-mastery', ensureAuthenticated, async (req, res) => {
    try {
        const { batchId } = req.params;

        // Validate batchId - must be numeric
        if (!batchId || !/^\d+$/.test(batchId)) {
            return res.status(400).json({ error: 'Invalid batch_id parameter' });
        }

        // Verify user has access to this batch (teacher/admin of the institute)
        if (req.user.role !== 'admin' && req.user.role !== 'teacher' && req.user.role !== 'institute_admin') {
            return res.status(403).json({ error: 'Unauthorized' });
        }

        // Get student count
        const studentCountResult = await db.query(
            'SELECT COUNT(*) as count FROM batch_students WHERE batch_id = $1',
            [batchId]
        );

        const chapterMastery = await calculateBatchChapterMastery(batchId);

        res.json({
            batchId: parseInt(batchId),
            studentCount: parseInt(studentCountResult.rows[0].count),
            chapterMastery: chapterMastery
        });
    } catch (error) {
        console.error('[KnowledgeGraph] Error fetching batch chapter mastery:', error.message, { query: 'GET /api/batch/:batchId/chapter-mastery', batchId: req.params.batchId });
        res.status(500).json({ error: 'Failed to fetch batch chapter mastery. Please try again later.' });
    }
});

export default router;
