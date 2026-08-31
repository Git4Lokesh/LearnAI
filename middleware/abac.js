/**
 * Attribute-Based Access Control (ABAC) Middleware
 *
 * Enforces the ownership/relationship model on top of RBAC:
 *   - Students can only access their own data
 *   - Parents can only access their linked children's data
 *   - Teachers can only access students in their assigned sections
 *   - School admins have school-wide access
 *   - Platform admins bypass all checks
 *
 * These middlewares are applied AFTER authentication and tenant context.
 */

import db from '../config/db.js';

/**
 * Enforce access to a specific student's data.
 * Reads :studentId from route params (configurable via paramName).
 *
 * Access granted if:
 *   - Platform admin
 *   - School admin at the same institute
 *   - Teacher with the student in one of their assigned sections
 *   - Parent with the student linked via student_profiles.parent_user_id
 *   - The student themselves
 *
 * Usage: router.get('/student/:studentId/mastery', ensureAuthenticated, enforceStudentAccess(), handler)
 */
export function enforceStudentAccess(paramName = 'studentId') {
    return async (req, res, next) => {
        const targetStudentId = parseInt(req.params[paramName] || req.query[paramName] || req.body?.[paramName]);
        if (!targetStudentId) {
            return res.status(400).json({ error: 'Student ID is required.' });
        }

        const { role, id: userId, institute_id: userInstituteId } = req.user;

        // Platform admin — full bypass
        if (role === 'admin') return next();

        // Student accessing their own data
        if (role === 'student' && userId === targetStudentId) return next();

        // School admin — can access any student in their school
        if (['institute_admin', 'school_admin'].includes(role)) {
            const check = await db.query(
                'SELECT 1 FROM users WHERE id = $1 AND institute_id = $2 AND deleted_at IS NULL',
                [targetStudentId, userInstituteId]
            );
            if (check.rowCount > 0) return next();
            return res.status(403).json({ error: 'Student not found in your school.' });
        }

        // Parent — can access linked children only
        if (role === 'parent') {
            const check = await db.query(
                'SELECT 1 FROM student_profiles WHERE user_id = $1 AND parent_user_id = $2 AND deleted_at IS NULL',
                [targetStudentId, userId]
            );
            if (check.rowCount > 0) return next();
            return res.status(403).json({ error: 'Access denied. This student is not linked to your account.' });
        }

        // Teacher — can access students in their assigned sections
        if (role === 'teacher') {
            const check = await db.query(
                `SELECT 1 FROM student_profiles sp
                 JOIN teacher_assignments ta ON ta.section_id = sp.section_id
                 WHERE sp.user_id = $1 AND ta.user_id = $2
                 AND sp.deleted_at IS NULL AND ta.deleted_at IS NULL`,
                [targetStudentId, userId]
            );
            if (check.rowCount > 0) return next();
            return res.status(403).json({ error: 'Access denied. This student is not in your assigned sections.' });
        }

        return res.status(403).json({ error: 'Access denied.' });
    };
}

/**
 * Enforce access to a batch — only teachers/admins at the same school.
 * Students can see their own batch info but not other batches.
 */
export function enforceBatchAccess(paramName = 'batchId') {
    return async (req, res, next) => {
        const targetBatchId = parseInt(req.params[paramName] || req.query[paramName]);
        if (!targetBatchId) {
            return res.status(400).json({ error: 'Batch ID is required.' });
        }

        const { role, id: userId, institute_id: userInstituteId } = req.user;

        if (role === 'admin') return next();

        // Verify batch belongs to user's institute
        const batchCheck = await db.query(
            'SELECT institute_id FROM batches WHERE id = $1 AND deleted_at IS NULL',
            [targetBatchId]
        );
        if (batchCheck.rowCount === 0) {
            return res.status(404).json({ error: 'Batch not found.' });
        }
        if (batchCheck.rows[0].institute_id !== userInstituteId) {
            return res.status(403).json({ error: 'Access denied.' });
        }

        // School admin — full access to any batch in their school
        if (['institute_admin', 'school_admin'].includes(role)) return next();

        // Teacher — verify they teach a section that maps to this batch
        // (Teachers can see any batch in their school for now — can tighten later)
        if (role === 'teacher') return next();

        // Student — only if they're a member
        if (role === 'student') {
            const memberCheck = await db.query(
                'SELECT 1 FROM batch_students WHERE batch_id = $1 AND user_id = $2',
                [targetBatchId, userId]
            );
            if (memberCheck.rowCount > 0) return next();
            return res.status(403).json({ error: 'Access denied. You are not a member of this batch.' });
        }

        return res.status(403).json({ error: 'Access denied.' });
    };
}

/**
 * Enforce that a parent can only see reports for their linked children.
 * Useful for the report token generation and parent dashboard routes.
 */
export function enforceParentChildLink(studentParamName = 'studentId') {
    return async (req, res, next) => {
        const { role, id: userId } = req.user;

        // Non-parent roles: defer to other middlewares
        if (role !== 'parent') return next();

        const targetStudentId = parseInt(
            req.params[studentParamName] || req.query[studentParamName] || req.body?.[studentParamName]
        );
        if (!targetStudentId) {
            return res.status(400).json({ error: 'Student ID is required.' });
        }

        const check = await db.query(
            'SELECT 1 FROM student_profiles WHERE user_id = $1 AND parent_user_id = $2 AND deleted_at IS NULL',
            [targetStudentId, userId]
        );
        if (check.rowCount > 0) return next();

        return res.status(403).json({ error: 'Access denied. This student is not linked to your account.' });
    };
}

/**
 * Enforce teacher's section scope — for heatmap and assignment routes.
 * Teachers can only query sections they're assigned to.
 */
export function enforceTeacherSectionAccess(paramName = 'sectionId') {
    return async (req, res, next) => {
        const { role, id: userId } = req.user;

        // Non-teachers: pass through (admins bypass, students don't hit these routes)
        if (role === 'admin') return next();
        if (['institute_admin', 'school_admin'].includes(role)) return next();

        if (role !== 'teacher') {
            return res.status(403).json({ error: 'Access denied.' });
        }

        const targetSectionId = parseInt(
            req.params[paramName] || req.query[paramName] || req.body?.[paramName]
        );
        if (!targetSectionId) {
            return res.status(400).json({ error: 'Section ID is required.' });
        }

        const check = await db.query(
            'SELECT 1 FROM teacher_assignments WHERE user_id = $1 AND section_id = $2 AND deleted_at IS NULL',
            [userId, targetSectionId]
        );
        if (check.rowCount > 0) return next();

        return res.status(403).json({ error: 'Access denied. You are not assigned to this section.' });
    };
}
