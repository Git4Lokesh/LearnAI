// ─── Role-based auth middleware ──────────────────────────────────────────────
// Supports 4 personas: school_admin (institute_admin), teacher, student, parent
// Plus platform-level 'admin' role for internal ops

/**
 * Basic authentication check — any logged-in user.
 */
export function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    // For API requests, return 401 JSON
    if (req.path.startsWith('/api/')) {
        return res.status(401).json({ error: 'Authentication required' });
    }
    res.redirect('/login');
}

/**
 * Platform admin — full system access.
 */
export function ensureAdmin(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'admin') return next();
    return _forbidden(req, res);
}

/**
 * School admin (institute_admin or school_admin role) — manages their institute.
 */
export function ensureInstituteAdmin(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (['institute_admin', 'school_admin'].includes(req.user.role) && req.user.institute_id) {
            return next();
        }
    }
    return _forbidden(req, res);
}

/**
 * Institute staff — school_admin OR teacher with an institute_id.
 * Used for routes both roles can access (batch management, question upload, etc.)
 */
export function ensureInstituteUser(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (['teacher', 'institute_admin', 'school_admin'].includes(req.user.role) && req.user.institute_id) {
            return next();
        }
    }
    return _forbidden(req, res);
}

/**
 * Teacher only — for teacher-specific routes (heatmap, assignments, etc.)
 */
export function ensureTeacher(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.role === 'teacher' && req.user.institute_id) return next();
        // school_admin can also access teacher views
        if (['institute_admin', 'school_admin'].includes(req.user.role) && req.user.institute_id) {
            return next();
        }
    }
    return _forbidden(req, res);
}

/**
 * Student only — for practice, diagnostic, mastery routes.
 */
export function ensureStudent(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.role === 'student') return next();
    }
    return _forbidden(req, res);
}

/**
 * Parent only — read-only access to their child's reports.
 */
export function ensureParent(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.role === 'parent') return next();
    }
    return _forbidden(req, res);
}

/**
 * Any role within an institute (student, teacher, admin, parent).
 * Blocks users who aren't part of any institute.
 */
export function ensureInstituteMember(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.institute_id) return next();
    }
    return _forbidden(req, res);
}

/**
 * Factory: create a middleware that allows any of the specified roles.
 * Usage: requireRole('teacher', 'school_admin')
 */
export function requireRole(...roles) {
    // Expand 'school_admin' to also match 'institute_admin' for backward compat
    const expandedRoles = new Set(roles);
    if (expandedRoles.has('school_admin')) expandedRoles.add('institute_admin');
    if (expandedRoles.has('institute_admin')) expandedRoles.add('school_admin');

    return (req, res, next) => {
        if (!req.isAuthenticated()) {
            if (req.path.startsWith('/api/')) {
                return res.status(401).json({ error: 'Authentication required' });
            }
            return res.redirect('/login');
        }
        // Platform admin always passes
        if (req.user.role === 'admin') return next();
        if (expandedRoles.has(req.user.role)) return next();
        return _forbidden(req, res);
    };
}

/**
 * Ensure the authenticated user belongs to the same institute as the resource.
 * Pass the institute_id as a route param or query param.
 * Prevents cross-tenant data access.
 */
export function ensureSameInstitute(paramName = 'instituteId') {
    return (req, res, next) => {
        if (!req.isAuthenticated()) return _forbidden(req, res);
        if (req.user.role === 'admin') return next(); // platform admin bypasses

        const targetInstituteId = parseInt(req.params[paramName] || req.query[paramName] || req.body?.[paramName]);
        if (targetInstituteId && req.user.institute_id !== targetInstituteId) {
            return _forbidden(req, res);
        }
        return next();
    };
}

// ─── Helpers ────────────────────────────────────────────────────────────────

function _forbidden(req, res) {
    if (req.path.startsWith('/api/')) {
        return res.status(403).json({ error: 'Forbidden' });
    }
    return res.status(403).send('Forbidden');
}
