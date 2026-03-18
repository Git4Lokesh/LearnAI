-- ============================================================
-- Migration 009: Syllabus Tracker — Chapter Teaching Status
-- Tracks which chapters a teacher has marked as "Taught in Class"
-- per batch, supporting the syllabus-vs-mastery delta feature.
-- ============================================================

CREATE TABLE IF NOT EXISTS chapter_teaching_status (
    id SERIAL PRIMARY KEY,
    chapter_id VARCHAR(100) NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    batch_id INTEGER NOT NULL REFERENCES batches(id) ON DELETE CASCADE,
    teacher_id INTEGER NOT NULL REFERENCES users(id),
    marked_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE (chapter_id, batch_id)
);

CREATE INDEX IF NOT EXISTS idx_teaching_status_batch ON chapter_teaching_status(batch_id);
CREATE INDEX IF NOT EXISTS idx_teaching_status_chapter ON chapter_teaching_status(chapter_id);
