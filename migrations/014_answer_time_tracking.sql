-- Migration 014: Add per-question time tracking to assignment_answers
ALTER TABLE assignment_answers ADD COLUMN IF NOT EXISTS time_taken_seconds INTEGER;
