-- ============================================================
-- Migration 008: BKT Learned Parameters
-- Stores EM-fitted BKT parameters per concept + difficulty tier
-- Supports versioning, rollback, and audit logging
-- ============================================================

-- Table: concept_bkt_params
-- Stores the latest learned (or default) BKT params per concept+tier
CREATE TABLE IF NOT EXISTS concept_bkt_params (
    id SERIAL PRIMARY KEY,
    concept_id VARCHAR(100) NOT NULL REFERENCES concepts(id) ON DELETE CASCADE,
    difficulty_tier INTEGER NOT NULL DEFAULT 2,  -- 1=easy, 2=medium, 3=hard
    p_init NUMERIC(6,4) NOT NULL DEFAULT 0.2000,
    p_learn NUMERIC(6,4) NOT NULL DEFAULT 0.1500,
    p_guess NUMERIC(6,4) NOT NULL DEFAULT 0.2000,
    p_slip NUMERIC(6,4) NOT NULL DEFAULT 0.1000,
    source VARCHAR(20) NOT NULL DEFAULT 'default',  -- 'default', 'em_fitted', 'manual'
    version INTEGER NOT NULL DEFAULT 1,
    sample_size INTEGER NOT NULL DEFAULT 0,          -- number of response sequences used
    student_count INTEGER NOT NULL DEFAULT 0,        -- distinct students in training data
    log_likelihood NUMERIC(12,4),                     -- final EM log-likelihood (fit quality)
    fitted_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN NOT NULL DEFAULT true,          -- only one active per concept+tier
    UNIQUE (concept_id, difficulty_tier, version)
);

CREATE INDEX IF NOT EXISTS idx_cbp_concept_tier ON concept_bkt_params(concept_id, difficulty_tier);
CREATE INDEX IF NOT EXISTS idx_cbp_active ON concept_bkt_params(is_active) WHERE is_active = true;

-- Table: bkt_fitting_log
-- Audit log for every EM fitting run
CREATE TABLE IF NOT EXISTS bkt_fitting_log (
    id SERIAL PRIMARY KEY,
    run_id VARCHAR(50) NOT NULL,             -- UUID for grouping one run's results
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    concepts_fitted INTEGER DEFAULT 0,       -- how many concepts were fitted
    concepts_skipped INTEGER DEFAULT 0,      -- how many had insufficient data
    total_sequences INTEGER DEFAULT 0,       -- total response sequences processed
    status VARCHAR(20) DEFAULT 'running',    -- 'running', 'completed', 'failed'
    error_message TEXT,
    triggered_by VARCHAR(50) DEFAULT 'cron'  -- 'cron', 'admin', 'test'
);

CREATE INDEX IF NOT EXISTS idx_bfl_status ON bkt_fitting_log(status);
CREATE INDEX IF NOT EXISTS idx_bfl_run ON bkt_fitting_log(run_id);
