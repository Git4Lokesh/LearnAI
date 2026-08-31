-- ============================================================
-- Migration 015: IAM & Onboarding Overhaul
-- 
-- Adds support for 4 personas: school_admin, teacher, student, parent
-- Decouples student academic profiles from user accounts
-- Introduces school_code for simplified student login
-- Adds parent accounts linked to students via phone number
-- Adds academic_years and sections for school structure
-- Soft delete support across tenant-scoped tables
-- ============================================================

-- ─── 1. Extend institutes table with school-specific fields ─────────────────

ALTER TABLE institutes ADD COLUMN IF NOT EXISTS school_code VARCHAR(20) UNIQUE;
ALTER TABLE institutes ADD COLUMN IF NOT EXISTS logo_url TEXT;
ALTER TABLE institutes ADD COLUMN IF NOT EXISTS settings JSONB DEFAULT '{}';
ALTER TABLE institutes ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

-- Backfill school_code from slug for existing institutes
UPDATE institutes SET school_code = UPPER(REPLACE(slug, '-', ''))
WHERE school_code IS NULL;

-- Generate short codes if the slug-based ones are too long (truncate to 12 chars)
UPDATE institutes SET school_code = UPPER(SUBSTRING(REPLACE(slug, '-', '') FROM 1 FOR 12))
WHERE LENGTH(school_code) > 12;

CREATE UNIQUE INDEX IF NOT EXISTS idx_institutes_school_code ON institutes(school_code) WHERE deleted_at IS NULL;

-- ─── 2. Academic years (optional per-school academic year tracking) ─────────

CREATE TABLE IF NOT EXISTS academic_years (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL,          -- e.g. "2025-26"
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_academic_years_institute ON academic_years(institute_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_academic_years_active ON academic_years(institute_id, is_active) WHERE is_active = true;

-- ─── 3. Sections (class + section within a school) ──────────────────────────

CREATE TABLE IF NOT EXISTS sections (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id) ON DELETE CASCADE,
    academic_year_id INTEGER REFERENCES academic_years(id),
    class_level VARCHAR(20) NOT NULL,    -- e.g. "11", "12", "9"
    section_name VARCHAR(20) NOT NULL,   -- e.g. "A", "B", "Science"
    created_at TIMESTAMPTZ DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    UNIQUE (institute_id, class_level, section_name, academic_year_id)
);

CREATE INDEX IF NOT EXISTS idx_sections_institute ON sections(institute_id);

-- ─── 4. Extend users table for new auth flows ───────────────────────────────

-- Add phone number (primary identifier for parents, alternate for teachers)
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20);

-- Add PIN for simplified student login (school_code + roll_no + pin)
ALTER TABLE users ADD COLUMN IF NOT EXISTS pin VARCHAR(255);  -- bcrypt hashed

-- Make email nullable (students/parents may not have one)
ALTER TABLE users ALTER COLUMN email DROP NOT NULL;

-- Add soft delete
ALTER TABLE users ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

-- Add diagnostic_completed if not exists (some migrations may have added it)
ALTER TABLE users ADD COLUMN IF NOT EXISTS diagnostic_completed BOOLEAN DEFAULT false;

-- Create partial unique index on email (allow NULLs, enforce uniqueness on non-null)
-- First drop the old unique constraint on email
DO $$
BEGIN
    -- Drop old unique constraint if it exists
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'users_email_key' AND conrelid = 'users'::regclass
    ) THEN
        ALTER TABLE users DROP CONSTRAINT users_email_key;
    END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_unique 
ON users(email) WHERE email IS NOT NULL AND deleted_at IS NULL;

-- Index for phone-based lookups (parents)
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone) WHERE phone IS NOT NULL;

-- ─── 5. Student profiles (decoupled academic state) ─────────────────────────

CREATE TABLE IF NOT EXISTS student_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    institute_id INTEGER NOT NULL REFERENCES institutes(id) ON DELETE CASCADE,
    section_id INTEGER REFERENCES sections(id),
    roll_no VARCHAR(50),
    parent_user_id INTEGER REFERENCES users(id),  -- linked parent account
    admission_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    UNIQUE (institute_id, roll_no)  -- roll numbers unique within a school
);

CREATE INDEX IF NOT EXISTS idx_student_profiles_user ON student_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_section ON student_profiles(section_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_parent ON student_profiles(parent_user_id);
CREATE INDEX IF NOT EXISTS idx_student_profiles_institute_roll 
ON student_profiles(institute_id, roll_no) WHERE deleted_at IS NULL;

-- ─── 6. Teacher assignments (which teacher teaches which section+subject) ───

CREATE TABLE IF NOT EXISTS teacher_assignments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    institute_id INTEGER NOT NULL REFERENCES institutes(id) ON DELETE CASCADE,
    section_id INTEGER NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    subject VARCHAR(100) NOT NULL,       -- e.g. "Physics", "Mathematics"
    academic_year_id INTEGER REFERENCES academic_years(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    UNIQUE (user_id, section_id, subject)
);

CREATE INDEX IF NOT EXISTS idx_teacher_assignments_user ON teacher_assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_assignments_section ON teacher_assignments(section_id);

-- ─── 7. Parent report tokens (tokenized access without login) ───────────────

CREATE TABLE IF NOT EXISTS parent_report_tokens (
    id SERIAL PRIMARY KEY,
    token VARCHAR(64) NOT NULL UNIQUE,
    parent_user_id INTEGER REFERENCES users(id),          -- NULL if sent to unregistered phone
    student_user_id INTEGER NOT NULL REFERENCES users(id),
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    phone VARCHAR(20),                    -- delivery phone number
    expires_at TIMESTAMPTZ NOT NULL,
    accessed_at TIMESTAMPTZ,              -- first access timestamp
    access_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_parent_report_tokens_token ON parent_report_tokens(token);
CREATE INDEX IF NOT EXISTS idx_parent_report_tokens_student ON parent_report_tokens(student_user_id);
CREATE INDEX IF NOT EXISTS idx_parent_report_tokens_expiry ON parent_report_tokens(expires_at);

-- ─── 8. Magic link tokens (for teacher passwordless onboarding) ─────────────

CREATE TABLE IF NOT EXISTS magic_links (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),             -- NULL if user not yet created
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    email VARCHAR(255),
    phone VARCHAR(20),
    token VARCHAR(128) NOT NULL UNIQUE,
    purpose VARCHAR(30) NOT NULL DEFAULT 'login',     -- 'login', 'onboard_teacher', 'onboard_parent'
    expires_at TIMESTAMPTZ NOT NULL,
    claimed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_magic_links_token ON magic_links(token);
CREATE INDEX IF NOT EXISTS idx_magic_links_expiry ON magic_links(expires_at);

-- ─── 9. CSV upload tracking for bulk onboarding ─────────────────────────────

CREATE TABLE IF NOT EXISTS onboarding_jobs (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    uploaded_by INTEGER NOT NULL REFERENCES users(id),
    filename TEXT,
    job_type VARCHAR(30) NOT NULL DEFAULT 'students',  -- 'students', 'teachers'
    total_rows INTEGER DEFAULT 0,
    created_students INTEGER DEFAULT 0,
    created_parents INTEGER DEFAULT 0,
    created_sections INTEGER DEFAULT 0,
    failed_rows INTEGER DEFAULT 0,
    error_log JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'processing',  -- 'processing', 'completed', 'failed'
    created_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_onboarding_jobs_institute ON onboarding_jobs(institute_id);

-- ─── 10. Soft delete on batches ─────────────────────────────────────────────

ALTER TABLE batches ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

-- ─── 11. Update role values ─────────────────────────────────────────────────
-- Expand the role column to support: student, teacher, school_admin (alias for institute_admin), parent, admin
-- The existing 'institute_admin' values remain valid and are treated as 'school_admin' in app logic

-- No schema change needed since role is VARCHAR(20), which fits all values.
-- Add a CHECK constraint for documentation (won't break existing data):
-- ALTER TABLE users ADD CONSTRAINT chk_user_role 
--   CHECK (role IN ('student', 'teacher', 'institute_admin', 'school_admin', 'parent', 'admin'));
-- ^ Commented out: add this only after migrating all 'institute_admin' values if desired.

-- ─── 12. Composite indexes for performance on common queries ────────────────

-- Teacher dashboard: fetch all students in a section with their mastery
CREATE INDEX IF NOT EXISTS idx_users_institute_role 
ON users(institute_id, role) WHERE deleted_at IS NULL;

-- BKT lookups: student+concept mastery (already has PK, but add institute-scoped)
CREATE INDEX IF NOT EXISTS idx_ucm_user_concept 
ON user_concept_mastery(user_id, concept_id);

-- Student login: school_code lookup then institute_id + roll_no
-- (covered by idx_student_profiles_institute_roll above)

-- ─── 13. Insert default academic year for existing institutes ────────────────

INSERT INTO academic_years (institute_id, label, is_active)
SELECT id, '2025-26', true FROM institutes
WHERE id NOT IN (SELECT institute_id FROM academic_years)
ON CONFLICT DO NOTHING;
