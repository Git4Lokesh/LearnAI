-- Migration 008: Diagnostic Onboarding Test
-- Adds flag to track whether a student has completed the diagnostic assessment

ALTER TABLE users ADD COLUMN IF NOT EXISTS diagnostic_completed BOOLEAN DEFAULT false;

-- Index for quick lookup during login redirect
CREATE INDEX IF NOT EXISTS idx_users_diagnostic ON users(id) WHERE diagnostic_completed = false;
