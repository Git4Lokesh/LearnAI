/**
 * Role Elevation Prevention Middleware
 *
 * Ensures that no user can create or promote accounts to a role
 * higher than their own authority level.
 *
 * Authority hierarchy:
 *   admin (platform) > school_admin/institute_admin > teacher > student/parent
 *
 * Rules:
 *   - school_admin can create: teacher, student, parent
 *   - school_admin CANNOT create: school_admin, institute_admin, admin
 *   - teacher can create: student (via some flows)
 *   - teacher CANNOT create: teacher, school_admin, admin
 *   - Only platform admin can create school_admin
 */

const ROLE_AUTHORITY = {
    admin: 100,
    institute_admin: 80,
    school_admin: 80,
    teacher: 50,
    student: 10,
    parent: 10,
};

// Roles that each authority level is allowed to create
const ALLOWED_CREATIONS = {
    admin: ['institute_admin', 'school_admin', 'teacher', 'student', 'parent'],
    institute_admin: ['teacher', 'student', 'parent'],
    school_admin: ['teacher', 'student', 'parent'],
    teacher: ['student'],
    student: [],
    parent: [],
};

/**
 * Middleware: validates that the `role` field in the request body
 * is permissible for the authenticated user to create.
 *
 * @param {string} roleField - The body field containing the target role (default: 'role')
 */
export function preventRoleElevation(roleField = 'role') {
    return (req, res, next) => {
        const targetRole = (req.body?.[roleField] || '').trim().toLowerCase();

        // If no role specified, default to 'student' (safe)
        if (!targetRole) return next();

        const creatorRole = req.user?.role || 'student';
        const allowed = ALLOWED_CREATIONS[creatorRole] || [];

        if (!allowed.includes(targetRole)) {
            return res.status(403).json({
                error: `Permission denied. You cannot create accounts with role "${targetRole}".`,
                allowed: allowed
            });
        }

        return next();
    };
}

/**
 * Middleware: prevents changing a user's role to something above the requester's authority.
 * Used on role-change endpoints (e.g., promoting a student to teacher).
 *
 * @param {string} roleField - The body field containing the new role
 */
export function preventRoleChange(roleField = 'newRole') {
    return (req, res, next) => {
        const newRole = (req.body?.[roleField] || '').trim().toLowerCase();
        if (!newRole) return next();

        const changerRole = req.user?.role || 'student';
        const changerAuthority = ROLE_AUTHORITY[changerRole] || 0;
        const targetAuthority = ROLE_AUTHORITY[newRole] || 0;

        // Cannot promote to equal or higher authority
        if (targetAuthority >= changerAuthority) {
            return res.status(403).json({
                error: `Permission denied. Cannot assign role "${newRole}" — it requires higher authority.`
            });
        }

        // Check allowed creations as well
        const allowed = ALLOWED_CREATIONS[changerRole] || [];
        if (!allowed.includes(newRole)) {
            return res.status(403).json({
                error: `Permission denied. You cannot assign the role "${newRole}".`,
                allowed
            });
        }

        return next();
    };
}

export default { preventRoleElevation, preventRoleChange };
