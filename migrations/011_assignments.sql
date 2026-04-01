-- Migration 011: LMS Assignment System
-- Creates tables for assignments, assignment questions, submissions, answers, and notifications

-- ── Assignments table ──
CREATE TABLE IF NOT EXISTS assignments (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    batch_id INTEGER NOT NULL REFERENCES batches(id),
    created_by INTEGER NOT NULL REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    deadline TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ── Assignment-Question mappings ──
CREATE TABLE IF NOT EXISTS assignment_questions (
    assignment_id INTEGER NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(id),
    question_order INTEGER NOT NULL,
    PRIMARY KEY (assignment_id, question_id)
);

-- ── Assignment Submissions ──
CREATE TABLE IF NOT EXISTS assignment_submissions (
    id SERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL REFERENCES assignments(id),
    user_id INTEGER NOT NULL REFERENCES users(id),
    score INTEGER NOT NULL,
    max_score INTEGER NOT NULL,
    time_taken_seconds INTEGER,
    started_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE (assignment_id, user_id)
);

-- ── Assignment Answers ──
CREATE TABLE IF NOT EXISTS assignment_answers (
    id SERIAL PRIMARY KEY,
    submission_id INTEGER NOT NULL REFERENCES assignment_submissions(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(id),
    selected_option VARCHAR(10),
    is_correct BOOLEAN NOT NULL
);

-- ── Notifications ──
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    type VARCHAR(50) NOT NULL,
    reference_id INTEGER,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ── Indexes ──
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_assignment ON assignment_submissions(assignment_id);
CREATE INDEX IF NOT EXISTS idx_assignment_submissions_user ON assignment_submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_assignment_answers_submission ON assignment_answers(submission_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_assignments_batch ON assignments(batch_id);
CREATE INDEX IF NOT EXISTS idx_assignments_created_by ON assignments(created_by);
