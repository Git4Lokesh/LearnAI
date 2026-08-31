/**
 * Audit Logging Service
 *
 * Append-only audit trail for security-sensitive operations.
 * The audit_logs table has RULEs preventing UPDATE and DELETE,
 * making it tamper-proof at the DB level.
 *
 * Usage:
 *   import { auditLog } from '../services/auditService.js';
 *   await auditLog(req, 'csv_upload', 'onboarding_job', jobId, { filename, rowCount });
 */

import db from '../config/db.js';

/**
 * Log an auditable action.
 *
 * @param {object} req - Express request (used for user info and IP)
 * @param {string} action - The action type (see ACTION_TYPES below)
 * @param {string} resourceType - The type of resource affected
 * @param {string|number|null} resourceId - The specific resource ID
 * @param {object} details - Additional JSON metadata about the action
 */
export async function auditLog(req, action, resourceType = null, resourceId = null, details = {}) {
    try {
        const userId = req?.user?.id || null;
        const userRole = req?.user?.role || null;
        const instituteId = req?.user?.institute_id || null;
        const ipAddress = getClientIp(req);
        const userAgent = req?.headers?.['user-agent'] || null;

        await db.query(
            `INSERT INTO audit_logs (institute_id, user_id, user_role, action, resource_type, resource_id, details, ip_address, user_agent)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
            [
                instituteId,
                userId,
                userRole,
                action,
                resourceType,
                resourceId ? String(resourceId) : null,
                JSON.stringify(details),
                ipAddress,
                userAgent
            ]
        );
    } catch (err) {
        // Audit logging should never break the main flow
        console.error('[AUDIT] Failed to write audit log:', err.message);
    }
}

/**
 * Express middleware factory: auto-log specific route actions.
 *
 * Usage:
 *   router.post('/institute/onboard-students', ensureAuth, auditMiddleware('csv_upload', 'onboarding_job'), handler);
 *
 * Logs AFTER the response is sent (doesn't slow down the request).
 */
export function auditMiddleware(action, resourceType = null) {
    return (req, res, next) => {
        // Hook into response finish to log after completion
        const originalEnd = res.end;
        res.end = function (...args) {
            originalEnd.apply(this, args);
            // Log asynchronously (fire and forget)
            const resourceId = req.params?.id || req.body?.id || null;
            auditLog(req, action, resourceType, resourceId, {
                method: req.method,
                path: req.originalUrl,
                statusCode: res.statusCode
            });
        };
        next();
    };
}

/**
 * Predefined action types for consistency.
 */
export const AUDIT_ACTIONS = {
    // Authentication
    LOGIN_SUCCESS: 'login_success',
    LOGIN_FAILED: 'login_failed',
    MAGIC_LINK_CLAIMED: 'magic_link_claimed',
    STUDENT_PIN_LOGIN: 'student_pin_login',

    // Onboarding
    CSV_UPLOAD: 'csv_upload',
    TEACHER_ONBOARDED: 'teacher_onboarded',
    STUDENT_CREATED: 'student_created',
    PARENT_CREATED: 'parent_created',

    // Role management
    ROLE_CHANGED: 'role_changed',
    USER_INVITED: 'user_invited',
    USER_DEACTIVATED: 'user_deactivated',

    // Data access
    REPORT_GENERATED: 'report_generated',
    REPORT_ACCESSED: 'report_accessed',
    MASTERY_EXPORT: 'mastery_export',
    HEATMAP_VIEWED: 'heatmap_viewed',

    // Question management
    QUESTION_UPLOAD: 'question_upload',
    QUESTION_APPROVED: 'question_approved',
    QUESTION_REJECTED: 'question_rejected',

    // Settings
    SCHOOL_SETTINGS_CHANGED: 'school_settings_changed',
    SUBSCRIPTION_CHANGED: 'subscription_changed',
};

/**
 * Extract client IP from Express request.
 * Handles proxies via X-Forwarded-For.
 */
function getClientIp(req) {
    if (!req) return null;
    const forwarded = req.headers?.['x-forwarded-for'];
    if (forwarded) {
        return forwarded.split(',')[0].trim();
    }
    return req.socket?.remoteAddress || req.ip || null;
}
