-- Migration 010: Add prerequisite gating toggle per institute
-- Defaults to FALSE (open access) — schools can enable strict gating if desired

ALTER TABLE institutes
ADD COLUMN IF NOT EXISTS prerequisite_gating_enabled BOOLEAN DEFAULT false;
