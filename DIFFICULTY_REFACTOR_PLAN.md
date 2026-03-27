# Refactor: Continuous Difficulty Scale (1.0 – 10.0)

Replace the 3-tier integer difficulty system (1=Easy, 2=Medium, 3=Hard) with a continuous **1.0 – 10.0** scale where higher values represent more challenging questions (e.g., 10.0 = JEE Advanced / IE Irodov level).

## User Review Required

> [!IMPORTANT]
> **Mapping existing questions**: All existing questions with tiers 1/2/3 will be mapped to **2.0 / 5.0 / 8.0** on the new scale. This is a reasonable default but you may want to re-rate questions later with finer granularity.

> [!IMPORTANT]
> **BKT parameter bands**: Instead of 3 discrete tier-specific BKT params, the system will use **5 difficulty bands** for BKT parameter lookup:
> 
> | Band | Range | Label | Approx. Level |
> |------|-------|-------|----------------|
> | 1 | 1.0 – 2.0 | Very Easy | NCERT basics |
> | 2 | 2.1 – 4.0 | Easy | JEE Mains easy |
> | 3 | 4.1 – 6.0 | Medium | JEE Mains medium / JEE Advanced easy |
> | 4 | 6.1 – 8.0 | Hard | JEE Mains hard / JEE Advanced medium |
> | 5 | 8.1 – 10.0 | Very Hard | JEE Advanced hard / Olympiad |
> 
> Do you want different band boundaries or labels?

> [!WARNING]
> **Seed SQL files** (768+ lines each) contain hardcoded tier values. The migration will update existing DB rows, but the SQL files themselves will be updated with mapped values for fresh installs. AI-extracted questions via `extract_pyqs.js` will need to be prompted for 1.0–10.0 values.

---

## Proposed Changes

### Database Migration

#### [NEW] [010_difficulty_continuous.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/migrations/010_difficulty_continuous.sql)

1. `ALTER TABLE questions ALTER difficulty_tier TYPE NUMERIC(3,1)` — change from INT to NUMERIC(3,1)
2. Map existing data: `UPDATE questions SET difficulty_tier = CASE WHEN difficulty_tier = 1 THEN 2.0 WHEN difficulty_tier = 2 THEN 5.0 WHEN difficulty_tier = 3 THEN 8.0 END`
3. Add CHECK constraint: `difficulty_tier BETWEEN 1.0 AND 10.0`
4. `ALTER TABLE concept_bkt_params ALTER difficulty_tier TYPE NUMERIC(3,1)` — same for BKT params
5. Map BKT params: tier 1→2.0, 2→5.0, 3→8.0

---

### BKT Service

#### [MODIFY] [main.py](file:///Users/lakshminathkopparti/Desktop/Learn.ai/bkt_service/main.py)

- Replace `TIER_PARAMS` dict (keyed 1/2/3) with `BAND_PARAMS` (keyed 1-5) and a `difficulty_to_band(d)` function
- Replace `TIER_EXPECTED_TIME` with `BAND_EXPECTED_TIME` (5 bands)
- Update `resolve_params()` to accept `float` difficulty and map to band
- Update `_time_multiplier()` to work with bands
- Update `UpdateRequest.difficulty_tier` from `Optional[int]` to `Optional[float]`
- Update `/params/{concept_id}` endpoint to iterate 5 bands
- Update `/params` endpoint
- Update `_difficulty_from_mastery()` to return finer-grained labels

#### [MODIFY] [em_fitter.py](file:///Users/lakshminathkopparti/Desktop/Learn.ai/bkt_service/em_fitter.py)

- Replace `DEFAULT_PARAMS` dict (keyed 1/2/3) with 5-band version
- Update `em_fit()` accumulator dicts from 3 keys to 5 bands
- Update `_forward_backward()` to convert `seq[t]['tier']` (now float) to band
- Update `validate_params()` to iterate 5 bands
- Update `fit_all_concepts()` DB inserts for 5 bands

---

### Node.js Backend

#### [MODIFY] [app.js](file:///Users/lakshminathkopparti/Desktop/Learn.ai/app.js)

Key changes across ~15 locations:

1. **`tierMap`** (line 81): Replace `{ very_hard: [3], hard: [3,2], ... }` with difficulty ranges ≥/≤ comparisons
2. **`getQuestionFromDB()`** (line 80): Change `difficulty_tier=ANY($2)` to a range query (`difficulty_tier BETWEEN $2 AND $3`)
3. **`masteryToTier()`** (line 123): Return a float instead of int
4. **CSV upload** (line 818): Parse `difficulty_tier` as float, validate 1.0–10.0
5. **Practice answer endpoint** (line 2148): Pass float to BKT
6. **Adaptive questions** (line 2209): Use range queries
7. **Diagnostic test** (lines 2296, 2336): Use float difficulty
8. **Admin verify** (line 4100): Parse as float
9. **Institute review** (line 977): Save as float

---

### Frontend Views

#### [MODIFY] [practice.ejs](file:///Users/lakshminathkopparti/Desktop/Learn.ai/views/practice.ejs)

- Replace `['','Easy','Medium','Hard'][q.difficulty_tier]` with a `getDifficultyLabel(d)` function that maps 1.0–10.0 → labels
- Replace `['','tier-1','tier-2','tier-3'][q.difficulty_tier]` with dynamic CSS class by band
- Add graduated color scale for difficulty badges (green → yellow → orange → red → dark red)

#### [MODIFY] [admin-verify.ejs](file:///Users/lakshminathkopparti/Desktop/Learn.ai/views/admin-verify.ejs)

- Replace 3 radio buttons for tiers with a number input (step=0.5, min=1.0, max=10.0) + visual label

#### [MODIFY] [institute-review.ejs](file:///Users/lakshminathkopparti/Desktop/Learn.ai/views/institute-review.ejs)

- Replace 3 `<option>` dropdown with a number input or slider (1.0–10.0)

#### [MODIFY] [institute-upload.ejs](file:///Users/lakshminathkopparti/Desktop/Learn.ai/views/institute-upload.ejs)

- Update CSV documentation to show `difficulty_tier` accepts 1.0–10.0 values

---

### Scripts

#### [MODIFY] [extract_pyqs.js](file:///Users/lakshminathkopparti/Desktop/Learn.ai/scripts/extract_pyqs.js)

- Change SchemaType from `INTEGER` to `NUMBER`
- Update AI prompt: `difficulty_tier: 1.0 to 10.0 scale where 10 is JEE Advanced level`
- Update validation: `Number(q.difficulty_tier) >= 1.0 && Number(q.difficulty_tier) <= 10.0`

#### [MODIFY] [seed_jee_questions.js](file:///Users/lakshminathkopparti/Desktop/Learn.ai/scripts/seed_jee_questions.js)

- Minor: update any hardcoded tier references

---

### Seed Data

#### [MODIFY] [database_setup.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/database_setup.sql)

- Change `difficulty_tier INTEGER NOT NULL` to `difficulty_tier NUMERIC(3,1) NOT NULL`
- Add CHECK constraint

#### [MODIFY] [seed_questions_math_01.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/seed_questions_math_01.sql)

- Replace all `, 1,` → `, 2.0,` / `, 2,` → `, 5.0,` / `, 3,` → `, 8.0,` for the difficulty_tier column

#### [MODIFY] [seed_questions_math_02.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/seed_questions_math_02.sql)

- Same mapping as above

#### [MODIFY] [seed_questions.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/seed_questions.sql)

- Same mapping as above

#### [MODIFY] [seed_questions_nta.sql](file:///Users/lakshminathkopparti/Desktop/Learn.ai/seed_questions_nta.sql)

- Same mapping as above

---

## Verification Plan

### Manual Verification (user)

1. **Run the migration** on your local PostgreSQL:
   ```bash
   psql -U postgres -d "Content Storage" -f migrations/010_difficulty_continuous.sql
   ```
2. **Verify DB state**: Run `SELECT DISTINCT difficulty_tier FROM questions ORDER BY 1;` — should show 2.0, 5.0, 8.0
3. **Start the BKT service**: `cd bkt_service && uvicorn main:app --reload --port 8001`
   - Hit `GET /health` — should return ok
   - Hit `GET /params` — should show params with band-mapped difficulty tiers
4. **Start the app**: `node app.js`
   - Go to a practice page → verify difficulty badge shows correct label
   - Answer questions → verify BKT updates work (mastery % changes)
   - Go to admin verify → verify the difficulty input shows 1.0–10.0 slider/input
5. **Test CSV upload**: Upload a question CSV with `difficulty_tier` values like `3.5`, `7.0`, `9.5` → verify they are accepted
6. **Test AI extraction**: Run `extract_pyqs.js` on a sample PDF → verify extracted `difficulty_tier` is a float in [1.0, 10.0]

### Automated (scripted) Checks

Since there are no existing test suites, I propose adding a quick smoke-test script:

```bash
# After migration + services are running:
curl -s localhost:8001/health | jq .status  # should print "ok"
curl -s -X POST localhost:8001/update -H 'Content-Type: application/json' \
  -d '{"userId":"1","skillId":"test","correct":true,"difficulty_tier":7.5}' | jq .posterior_mastery
# Should return a float between 0 and 1
```
