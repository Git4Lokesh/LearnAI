-- Migration: Institute Multi-Tenancy Schema
-- Adds multi-tenancy support for coaching center platform
-- Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 4.6

-- New enum types
CREATE TYPE subscription_status AS ENUM ('trial', 'active', 'suspended', 'cancelled');
CREATE TYPE upload_job_status AS ENUM ('processing', 'completed', 'failed');

-- New tables
CREATE TABLE institutes (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    contact_email TEXT,
    subscription_status subscription_status DEFAULT 'trial',
    max_students INTEGER DEFAULT 500,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE batches (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE batch_students (
    batch_id INTEGER REFERENCES batches(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (batch_id, user_id)
);

CREATE TABLE upload_jobs (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER REFERENCES institutes(id),
    uploaded_by INTEGER REFERENCES users(id),
    filename TEXT,
    total_rows INTEGER,
    processed_rows INTEGER DEFAULT 0,
    failed_rows INTEGER DEFAULT 0,
    status upload_job_status DEFAULT 'processing',
    error_log JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ
);

-- Alter existing tables
ALTER TABLE users ADD COLUMN institute_id INTEGER REFERENCES institutes(id);
ALTER TABLE questions ADD COLUMN institute_id INTEGER REFERENCES institutes(id);
ALTER TABLE questions ADD COLUMN concept_confidence NUMERIC(3,2);
ALTER TABLE questions ADD COLUMN needs_review_tag BOOLEAN DEFAULT false;
ALTER TABLE questions ALTER COLUMN concept_id DROP NOT NULL;

-- Indexes for query performance
CREATE INDEX idx_users_institute ON users(institute_id);
CREATE INDEX idx_questions_institute ON questions(institute_id);
CREATE INDEX idx_questions_status_institute ON questions(status, institute_id);
CREATE INDEX idx_batch_students_user ON batch_students(user_id);
CREATE INDEX idx_upload_jobs_institute ON upload_jobs(institute_id);
CREATE INDEX idx_user_concept_mastery_mastery ON user_concept_mastery(mastery);
