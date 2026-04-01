-- Migration 012: Batch Invite Codes for Magic Link Onboarding
-- Adds invite_code column to batches table for shareable join links

ALTER TABLE batches ADD COLUMN IF NOT EXISTS invite_code VARCHAR(20) UNIQUE;

-- Generate invite codes for existing batches
DO $$
DECLARE
    b RECORD;
BEGIN
    FOR b IN SELECT id FROM batches WHERE invite_code IS NULL LOOP
        UPDATE batches SET invite_code = lower(substr(md5(random()::text), 1, 8))
        WHERE id = b.id;
    END LOOP;
END $$;

-- Make invite_code NOT NULL after backfill
ALTER TABLE batches ALTER COLUMN invite_code SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_batches_invite_code ON batches(invite_code);
