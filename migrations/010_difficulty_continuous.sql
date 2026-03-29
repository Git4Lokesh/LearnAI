-- ============================================================
-- Migration 010: Continuous Difficulty Scale (1.0 – 10.0)
-- Replaces integer tiers (1/2/3) with a continuous NUMERIC scale
-- Mapping: 1 (Easy) → 2.0, 2 (Medium) → 5.0, 3 (Hard) → 8.0
-- ============================================================

-- Step 1: Alter questions table
ALTER TABLE questions ALTER COLUMN difficulty_tier TYPE NUMERIC(3,1)
    USING difficulty_tier::NUMERIC(3,1);

-- Step 2: Map existing tier values to the new scale
UPDATE questions SET difficulty_tier = CASE
    WHEN difficulty_tier = 1 THEN 2.0
    WHEN difficulty_tier = 2 THEN 5.0
    WHEN difficulty_tier = 3 THEN 8.0
    ELSE 5.0  -- fallback for any unexpected values
END;

-- Step 3: Add CHECK constraint for valid range
ALTER TABLE questions ADD CONSTRAINT chk_difficulty_range
    CHECK (difficulty_tier >= 1.0 AND difficulty_tier <= 10.0);

-- Step 4: Update default
ALTER TABLE questions ALTER COLUMN difficulty_tier SET DEFAULT 5.0;

-- Step 5: Alter concept_bkt_params table
ALTER TABLE concept_bkt_params ALTER COLUMN difficulty_tier TYPE NUMERIC(3,1)
    USING difficulty_tier::NUMERIC(3,1);

-- Step 6: Map existing BKT param tiers
UPDATE concept_bkt_params SET difficulty_tier = CASE
    WHEN difficulty_tier = 1 THEN 2.0
    WHEN difficulty_tier = 2 THEN 5.0
    WHEN difficulty_tier = 3 THEN 8.0
    ELSE 5.0
END;

-- Step 7: Add CHECK constraint for BKT params
ALTER TABLE concept_bkt_params ADD CONSTRAINT chk_bkt_difficulty_range
    CHECK (difficulty_tier >= 1.0 AND difficulty_tier <= 10.0);

ALTER TABLE concept_bkt_params ALTER COLUMN difficulty_tier SET DEFAULT 5.0;

-- Step 8: Drop and recreate the unique constraint (it still works with NUMERIC)
-- The existing UNIQUE (concept_id, difficulty_tier, version) constraint remains valid
