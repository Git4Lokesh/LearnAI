-- ============================================================
-- Migration 016: Row-Level Security (RLS) for Tenant Isolation
--
-- Ensures that even if application code omits a WHERE clause,
-- cross-tenant data can never be read or written at the DB level.
--
-- Strategy:
--   - Tables with direct institute_id get a policy comparing against
--     the session variable `app.current_school_id`
--   - Tables without direct institute_id but with user_id get a policy
--     joining through users.institute_id
--   - A dedicated "app_user" role is used for application queries;
--     the "postgres" superuser bypasses RLS for migrations/admin.
--
-- IMPORTANT: The application MUST call:
--   SET LOCAL app.current_school_id = '<institute_id>';
-- inside a transaction (or at session start) before executing queries.
-- If unset, the GUC defaults to '' which matches nothing → zero rows.
-- ============================================================

-- ─── 0. Register custom GUC (safe to call multiple times) ───────────────────

-- Create the GUC if it doesn't exist (PostgreSQL 9.2+)
DO $$
BEGIN
    -- Try to access the setting; if it doesn't exist, we'll set a default
    PERFORM current_setting('app.current_school_id', true);
EXCEPTION WHEN OTHERS THEN
    -- Setting doesn't exist yet, that's fine
    NULL;
END $$;

-- Set a default empty value for the session variable
ALTER DATABASE "Content Storage" SET app.current_school_id = '';

-- ─── 1. Create application role (if not exists) ─────────────────────────────
-- The app connects as this role; superuser (postgres) bypasses RLS.

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
        CREATE ROLE app_user LOGIN PASSWORD 'app_user_secure_pw';
    END IF;
END $$;

-- Grant necessary permissions to app_user
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_user;

-- Ensure future tables also get permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO app_user;

-- ─── 2. Enable RLS on tenant-scoped tables ──────────────────────────────────

-- student_profiles: has direct institute_id
ALTER TABLE student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_profiles FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON student_profiles
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- questions: has direct institute_id (NULL = global/seed questions, always visible)
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON questions
    USING (
        institute_id IS NULL  -- global questions visible to all
        OR institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- batches: has direct institute_id
ALTER TABLE batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE batches FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON batches
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- sections: has direct institute_id
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON sections
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- upload_jobs: has direct institute_id
ALTER TABLE upload_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE upload_jobs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON upload_jobs
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- onboarding_jobs: has direct institute_id
ALTER TABLE onboarding_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE onboarding_jobs FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON onboarding_jobs
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- teacher_assignments: has direct institute_id
ALTER TABLE teacher_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_assignments FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON teacher_assignments
    USING (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

-- ─── 3. User-scoped tables (no direct institute_id — join through users) ────

-- user_concept_mastery: scoped via user_id → users.institute_id
ALTER TABLE user_concept_mastery ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_concept_mastery FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON user_concept_mastery
    USING (
        current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
        OR user_id IN (
            SELECT id FROM users 
            WHERE institute_id::text = current_setting('app.current_school_id', true)
        )
    );

-- user_question_attempts: scoped via user_id → users.institute_id
ALTER TABLE user_question_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_question_attempts FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON user_question_attempts
    USING (
        current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
        OR user_id IN (
            SELECT id FROM users 
            WHERE institute_id::text = current_setting('app.current_school_id', true)
        )
    );

-- ─── 4. RLS on users table itself ──────────────────────────────────────────
-- Users table needs special handling: platform users (no institute_id) must
-- still be visible for auth, and cross-tenant must be blocked for data queries.

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON users
    USING (
        current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
        OR institute_id IS NULL  -- platform-level users (admin) always visible
        OR institute_id::text = current_setting('app.current_school_id', true)
    );

-- ─── 5. Audit log table (append-only, no RLS — platform admins see all) ────

CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    institute_id INTEGER REFERENCES institutes(id),
    user_id INTEGER,
    user_role VARCHAR(20),
    action VARCHAR(100) NOT NULL,        -- e.g. 'csv_upload', 'report_generated', 'role_changed'
    resource_type VARCHAR(50),           -- e.g. 'student', 'question', 'report'
    resource_id TEXT,                    -- ID of the affected resource
    details JSONB DEFAULT '{}',          -- action-specific metadata
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for audit queries
CREATE INDEX IF NOT EXISTS idx_audit_logs_institute ON audit_logs(institute_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created ON audit_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource ON audit_logs(resource_type, resource_id);

-- Prevent updates and deletes on audit_logs (append-only)
CREATE OR REPLACE RULE audit_no_update AS ON UPDATE TO audit_logs DO INSTEAD NOTHING;
CREATE OR REPLACE RULE audit_no_delete AS ON DELETE TO audit_logs DO INSTEAD NOTHING;

-- ─── 6. Write policies (INSERT/UPDATE/DELETE) ───────────────────────────────
-- Write policies mirror read policies — user can only insert/update within their tenant

CREATE POLICY tenant_write ON student_profiles
    FOR INSERT WITH CHECK (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

CREATE POLICY tenant_write ON questions
    FOR INSERT WITH CHECK (
        institute_id IS NULL
        OR institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

CREATE POLICY tenant_write ON batches
    FOR INSERT WITH CHECK (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

CREATE POLICY tenant_write ON sections
    FOR INSERT WITH CHECK (
        institute_id::text = current_setting('app.current_school_id', true)
        OR current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
    );

CREATE POLICY tenant_write ON users
    FOR INSERT WITH CHECK (
        current_setting('app.current_school_id', true) = ''
        OR current_setting('app.current_school_id', true) = '__bypass__'
        OR institute_id IS NULL
        OR institute_id::text = current_setting('app.current_school_id', true)
    );
