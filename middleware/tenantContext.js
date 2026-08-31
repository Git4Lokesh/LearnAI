/**
 * Tenant Context Middleware
 * 
 * Sets the PostgreSQL session variable `app.current_school_id` based on
 * the authenticated user's institute_id. This activates Row-Level Security
 * policies at the database layer, ensuring no cross-tenant data leakage
 * even if application code omits a WHERE clause.
 *
 * Strategy for connection pooling (pg.Pool):
 *   - We can't permanently SET on pooled connections (they're shared).
 *   - Instead, we wrap db.query to prepend SET LOCAL within a transaction,
 *     OR we use a request-scoped approach where the middleware attaches
 *     the tenant ID and the db helper applies it per-query.
 *
 * This middleware attaches `req.tenantId` which the db wrapper reads.
 * For platform admins (no institute_id), tenantId = '__bypass__'.
 */

/**
 * Express middleware: extracts tenant context from authenticated user
 * and attaches it to the request for downstream use.
 */
export function tenantContext(req, res, next) {
    if (!req.isAuthenticated || !req.isAuthenticated()) {
        // Unauthenticated requests: no tenant context (public routes like /report/:token)
        req.tenantId = '';
        return next();
    }

    const user = req.user;

    if (user.role === 'admin') {
        // Platform admin bypasses tenant isolation
        req.tenantId = '__bypass__';
    } else if (user.institute_id) {
        req.tenantId = String(user.institute_id);
    } else {
        // User without institute (e.g. legacy free user, not yet assigned)
        req.tenantId = '';
    }

    return next();
}

export default tenantContext;
