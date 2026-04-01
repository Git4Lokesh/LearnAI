-- Migration 013: Teacher Invite Tokens
-- Stores pending teacher invitations with unique tokens

CREATE TABLE IF NOT EXISTS teacher_invites (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    email VARCHAR(255) NOT NULL,
    token VARCHAR(64) NOT NULL UNIQUE,
    invited_by INTEGER NOT NULL REFERENCES users(id),
    claimed_by INTEGER REFERENCES users(id),
    claimed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_teacher_invites_token ON teacher_invites(token);
CREATE INDEX IF NOT EXISTS idx_teacher_invites_institute ON teacher_invites(institute_id);
