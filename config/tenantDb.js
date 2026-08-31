/**
 * Tenant-Aware Database Query Helper
 *
 * Wraps the standard pg.Pool to enforce Row-Level Security by setting
 * `app.current_school_id` before executing queries.
 *
 * Usage in routes:
 *   import { tenantQuery } from '../config/tenantDb.js';
 *   const result = await tenantQuery(req, 'SELECT * FROM questions WHERE concept_id=$1', [id]);
 *
 * How it works:
 *   1. Acquires a client from the pool
 *   2. Begins a transaction
 *   3. SET LOCAL app.current_school_id = req.tenantId (transaction-scoped, doesn't pollute other connections)
 *   4. Executes the actual query
 *   5. Commits and releases the client
 *
 * For bulk operations (multiple queries in one tenant context), use `withTenantClient`.
 */

import db from './db.js';

/**
 * Execute a single query with tenant isolation enforced at the DB level.
 * 
 * @param {object} req - Express request (must have req.tenantId set by tenantContext middleware)
 * @param {string} text - SQL query text
 * @param {Array} params - Query parameters
 * @returns {Promise<pg.QueryResult>}
 */
export async function tenantQuery(req, text, params = []) {
    const tenantId = req?.tenantId || '';
    const client = await db.connect();

    try {
        await client.query('BEGIN');
        await client.query('SET LOCAL app.current_school_id = $1', [tenantId]);
        const result = await client.query(text, params);
        await client.query('COMMIT');
        return result;
    } catch (err) {
        await client.query('ROLLBACK');
        throw err;
    } finally {
        client.release();
    }
}

/**
 * Execute multiple queries within a single tenant-scoped transaction.
 * The callback receives a `client` with the tenant context already set.
 *
 * Usage:
 *   const result = await withTenantClient(req, async (client) => {
 *       const students = await client.query('SELECT * FROM student_profiles');
 *       const mastery = await client.query('SELECT * FROM user_concept_mastery WHERE user_id = $1', [id]);
 *       return { students, mastery };
 *   });
 *
 * @param {object} req - Express request
 * @param {function} callback - async (client) => result
 * @returns {Promise<any>} - whatever the callback returns
 */
export async function withTenantClient(req, callback) {
    const tenantId = req?.tenantId || '';
    const client = await db.connect();

    try {
        await client.query('BEGIN');
        await client.query('SET LOCAL app.current_school_id = $1', [tenantId]);
        const result = await callback(client);
        await client.query('COMMIT');
        return result;
    } catch (err) {
        await client.query('ROLLBACK');
        throw err;
    } finally {
        client.release();
    }
}

/**
 * Raw pool query without tenant context — for use in:
 *   - Authentication (before user is known)
 *   - Public routes (report token validation)
 *   - Platform admin operations
 *   - Migrations and scripts
 *
 * This is the same as importing db directly.
 */
export { default as rawDb } from './db.js';
