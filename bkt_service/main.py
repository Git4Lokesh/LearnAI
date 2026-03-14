from fastapi import FastAPI
from fastapi.responses import Response
from pydantic import BaseModel
from typing import Optional, List, Dict, Tuple
import asyncpg
import os
import logging
from datetime import datetime, timezone

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("bkt")

app = FastAPI(title="BKT Service", version="0.3.0")

DEFAULT_P_INIT  = 0.2
DEFAULT_P_LEARN = 0.15

# ── Connection pool (replaces per-request connections) ──
pool: Optional[asyncpg.Pool] = None

# ── Learned params cache: { (concept_id, tier): {p_init, p_learn, p_guess, p_slip} } ──
learned_params_cache: Dict[Tuple[str, int], Dict[str, float]] = {}

# Per-tier params: harder questions have lower guess chance and lower slip
TIER_PARAMS = {
    1: {'p_guess': 0.35, 'p_slip': 0.15, 'p_learn': 0.12},  # easy
    2: {'p_guess': 0.20, 'p_slip': 0.10, 'p_learn': 0.15},  # medium
    3: {'p_guess': 0.08, 'p_slip': 0.05, 'p_learn': 0.18},  # hard
}
# Expected time per tier in seconds (for confidence multiplier)
TIER_EXPECTED_TIME = {1: 60, 2: 120, 3: 180}


# ── Lifecycle: pool + cache ──

@app.on_event("startup")
async def startup():
    global pool
    pool = await asyncpg.create_pool(
        host='localhost', port=5432, user='postgres',
        password=os.environ.get('db_password'),
        database=os.environ.get('db_name', 'dblearn'),
        min_size=2, max_size=10
    )
    logger.info("DB connection pool created")
    await reload_learned_params()


@app.on_event("shutdown")
async def shutdown():
    if pool:
        await pool.close()
        logger.info("DB connection pool closed")


async def reload_learned_params():
    """Load all active learned params from DB into in-memory cache."""
    global learned_params_cache
    if pool is None:
        return
    try:
        async with pool.acquire() as conn:
            rows = await conn.fetch("""
                SELECT concept_id, difficulty_tier, p_init, p_learn, p_guess, p_slip,
                       source, version, sample_size
                FROM concept_bkt_params
                WHERE is_active = true
            """)
            new_cache = {}
            for r in rows:
                key = (r['concept_id'], r['difficulty_tier'])
                new_cache[key] = {
                    'p_init':  float(r['p_init']),
                    'p_learn': float(r['p_learn']),
                    'p_guess': float(r['p_guess']),
                    'p_slip':  float(r['p_slip']),
                    'source':  r['source'],
                    'version': r['version'],
                    'sample_size': r['sample_size'],
                    'difficulty_tier': r['difficulty_tier'],
                }
            learned_params_cache = new_cache
            logger.info(f"Loaded {len(new_cache)} learned param sets from DB")
    except Exception as e:
        logger.warning(f"Failed to load learned params (table may not exist yet): {e}")


def resolve_params(concept_id: Optional[str], tier: int,
                   override_learn=None, override_guess=None, override_slip=None) -> Dict[str, float]:
    """
    Resolve BKT params with fallback chain:
      1. Caller overrides (if explicitly provided)
      2. Learned params for (concept, tier)
      3. Learned params for (concept, any tier) — average
      4. Hardcoded TIER_PARAMS defaults
      
    For a BKT-IRT hybrid approach: 
      p_init and p_learn are treated as Concept-level (averaged across all tiers)
      p_guess and p_slip are treated as Item-level (tier-specific)
    """
    tier = tier if tier in TIER_PARAMS else 2
    defaults = TIER_PARAMS[tier]

    # Check learned cache
    learned_tier_specific = None
    concept_entries = []
    
    if concept_id:
        learned_tier_specific = learned_params_cache.get((concept_id, tier))
        concept_entries = [v for (c, t), v in learned_params_cache.items() if c == concept_id]

    # Calculate concept-level averages for p_init and p_learn
    concept_p_init = None
    concept_p_learn = None
    if concept_entries:
        # p_init is the prior baseline mastery. We only use Tier 1's learned p_init as the true baseline.
        # em_fitter already sets identical p_learn across tiers, so any entry's p_learn is fine.
        tier_1_entry = next((e for e in concept_entries if e.get('difficulty_tier') == 1), None)
        
        if tier_1_entry:
            concept_p_init = tier_1_entry.get('p_init', DEFAULT_P_INIT)
        else:
            concept_p_init = concept_entries[0].get('p_init', DEFAULT_P_INIT)
            
        concept_p_learn = concept_entries[0].get('p_learn', DEFAULT_P_LEARN)

    # Resolve p_init and p_learn (Concept Level)
    res_p_init = concept_p_init if concept_p_init is not None else DEFAULT_P_INIT
    res_p_learn = override_learn if override_learn is not None else (concept_p_learn if concept_p_learn is not None else defaults['p_learn'])

    # Resolve p_guess and p_slip (Tier Level)
    res_p_guess = override_guess if override_guess is not None else (learned_tier_specific['p_guess'] if learned_tier_specific else defaults['p_guess'])
    res_p_slip = override_slip if override_slip is not None else (learned_tier_specific['p_slip'] if learned_tier_specific else defaults['p_slip'])

    return {
        'p_init': res_p_init,
        'p_learn': res_p_learn,
        'p_guess': res_p_guess,
        'p_slip':  res_p_slip,
        'source':  'learned' if concept_entries else 'default',
    }


@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)

@app.get("/")
def root():
    return {"service": "BKT Service", "version": "0.3.0", "docs": "/docs", "health": "/health"}

@app.get("/.well-known/appspecific/com.chrome.devtools.json")
def chrome_devtools():
    return Response(status_code=204)


class UpdateRequest(BaseModel):
    userId: str
    skillId: str
    correct: bool
    p_mastery: Optional[float] = None
    difficulty_tier: Optional[int] = 2
    time_taken_seconds: Optional[float] = None
    p_learn: Optional[float] = None
    p_guess: Optional[float] = None
    p_slip:  Optional[float] = None

class UpdateResponse(BaseModel):
    userId: str
    skillId: str
    posterior_mastery: float
    p_learn: float
    p_guess: float
    p_slip: float

class NextRequest(BaseModel):
    userId: str
    skillId: str
    p_mastery: Optional[float] = None

class NextResponse(BaseModel):
    userId: str
    skillId: str
    mastery: float
    recommendedDifficulty: str


def _bayes_update(p_mastery: float, correct: bool, p_guess: float, p_slip: float) -> float:
    if correct:
        num = p_mastery * (1 - p_slip)
        den = num + (1 - p_mastery) * p_guess
    else:
        num = p_mastery * p_slip
        den = num + (1 - p_mastery) * (1 - p_guess)
    return num / den if den != 0 else p_mastery


def _apply_learning(p_post: float, p_learn: float) -> float:
    return p_post + (1 - p_post) * p_learn


def _difficulty_from_mastery(m: float) -> str:
    if m < 0.2: return "very_hard"
    if m < 0.4: return "hard"
    if m < 0.6: return "medium"
    if m < 0.8: return "easy"
    return "very_easy"


def _decay_mastery(mastery: float, last_updated) -> float:
    """Exponential decay based on days since last practice. λ=0.05 per day."""
    if last_updated is None:
        return mastery
    if isinstance(last_updated, str):
        last_updated = datetime.fromisoformat(last_updated)
    now = datetime.now(timezone.utc)
    if last_updated.tzinfo is None:
        last_updated = last_updated.replace(tzinfo=timezone.utc)
    days = (now - last_updated).total_seconds() / 86400
    decayed = mastery * (2.718281828 ** (-0.05 * days))
    return max(decayed, 0.1)  # floor at 0.1 so it never hits zero


def _time_multiplier(time_taken: Optional[float], tier: int, correct: bool) -> float:
    """Returns a learning boost (>=1) for fast correct answers. No penalty for slow/wrong."""
    if time_taken is None:
        return 1.0
    expected = TIER_EXPECTED_TIME.get(tier, 120)
    ratio = time_taken / expected
    if correct:
        # Fast correct answer = stronger signal
        if ratio < 0.5: return 1.3
        if ratio < 1.0: return 1.1
        return 1.0
    else:
        # We no longer penalize p_learn if they get it wrong slowly
        # Standard BKT handles the penalty via the negative Bayesian emission update
        return 1.0


@app.post("/update", response_model=UpdateResponse)
def update_knowledge(req: UpdateRequest):
    tier = req.difficulty_tier if req.difficulty_tier in TIER_PARAMS else 2
    resolved = resolve_params(req.skillId, tier, req.p_learn, req.p_guess, req.p_slip)
    
    p_init  = resolved['p_init']
    p_learn = resolved['p_learn']
    p_guess = resolved['p_guess']
    p_slip  = resolved['p_slip']

    # Use learned p_init if p_mastery is not provided
    current_mastery = req.p_mastery if req.p_mastery is not None else p_init

    p_post = _bayes_update(current_mastery, req.correct, p_guess, p_slip)
    t_mult = _time_multiplier(req.time_taken_seconds, tier, req.correct)
    p_next = _apply_learning(p_post, p_learn * t_mult)
    p_next = min(p_next, 0.99)

    return UpdateResponse(
        userId=req.userId, skillId=req.skillId,
        posterior_mastery=float(p_next),
        p_learn=float(p_learn), p_guess=float(p_guess), p_slip=float(p_slip),
    )


@app.post("/next", response_model=NextResponse)
def next_question(req: NextRequest):
    tier = 2 # default to medium for resolving p_init
    resolved = resolve_params(req.skillId, tier)
    current_mastery = req.p_mastery if req.p_mastery is not None else resolved['p_init']
    
    return NextResponse(
        userId=req.userId,
        skillId=req.skillId,
        mastery=float(current_mastery),
        recommendedDifficulty=_difficulty_from_mastery(current_mastery),
    )


class NextConceptRequest(BaseModel):
    userId: int
    subject: Optional[str] = None  # filter by subject e.g. "physics"

class ConceptMasteryItem(BaseModel):
    concept_id: str
    concept_name: str
    mastery: float
    unlocked: bool

class NextConceptResponse(BaseModel):
    next_concept_id: Optional[str]
    next_concept_name: Optional[str]
    mastery: float
    recommendedDifficulty: str
    all_concepts: List[ConceptMasteryItem]


async def get_db():
    """Get a connection from the pool, or create a direct one as fallback."""
    if pool:
        return await pool.acquire()
    return await asyncpg.connect(
        host='localhost', port=5432, user='postgres',
        password=os.environ.get('db_password'),
        database=os.environ.get('db_name', 'dblearn')
    )


@app.post("/next-concept", response_model=NextConceptResponse)
async def next_concept(req: NextConceptRequest):
    conn = await get_db()
    try:
        # Load all concepts (optionally filtered by subject)
        if req.subject:
            concepts = await conn.fetch(
                "SELECT id, name FROM concepts WHERE subject=$1 ORDER BY id", req.subject
            )
        else:
            concepts = await conn.fetch("SELECT id, name FROM concepts ORDER BY id")

        # Load all prerequisites
        prereqs = await conn.fetch("SELECT concept_id, prereq_id FROM concept_prerequisites")
        prereq_map = {}  # concept_id -> set of prereq_ids
        for row in prereqs:
            prereq_map.setdefault(row['concept_id'], set()).add(row['prereq_id'])

        # Load user mastery
        mastery_rows = await conn.fetch(
            "SELECT concept_id, mastery, last_updated FROM user_concept_mastery WHERE user_id=$1", req.userId
        )
        mastery_map = {r['concept_id']: _decay_mastery(float(r['mastery']), r['last_updated']) for r in mastery_rows}

        MASTERY_THRESHOLD = 0.8

        result = []
        next_concept = None
        next_mastery = 0.2

        for c in concepts:
            cid = c['id']
            m = mastery_map.get(cid, 0.2)
            prereqs_for = prereq_map.get(cid, set())
            # Unlocked if all prerequisites are mastered (or no prerequisites)
            unlocked = all(mastery_map.get(p, 0.2) >= MASTERY_THRESHOLD for p in prereqs_for)
            result.append(ConceptMasteryItem(
                concept_id=cid, concept_name=c['name'],
                mastery=m, unlocked=unlocked
            ))
            # Pick the first unlocked, unmastered concept as next
            if next_concept is None and unlocked and m < MASTERY_THRESHOLD:
                next_concept = c
                next_mastery = m

        return NextConceptResponse(
            next_concept_id=next_concept['id'] if next_concept else None,
            next_concept_name=next_concept['name'] if next_concept else None,
            mastery=next_mastery,
            recommendedDifficulty=_difficulty_from_mastery(next_mastery),
            all_concepts=result
        )
    finally:
        if pool:
            await pool.release(conn)
        else:
            await conn.close()


@app.post("/update-concept", response_model=UpdateResponse)
async def update_concept_mastery(req: UpdateRequest):
    """Update mastery in user_concept_mastery table (securely via DB) and return posterior."""
    tier = req.difficulty_tier if req.difficulty_tier in TIER_PARAMS else 2
    resolved = resolve_params(req.skillId, tier, req.p_learn, req.p_guess, req.p_slip)
    
    p_init  = resolved['p_init']
    p_learn = resolved['p_learn']
    p_guess = resolved['p_guess']
    p_slip  = resolved['p_slip']
    param_source = resolved['source']

    conn = await get_db()
    try:
        # Fetch actual historical state from DB
        row = await conn.fetchrow(
            "SELECT mastery, last_updated FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2",
            int(req.userId), req.skillId
        )

        if row:
            current_mastery = _decay_mastery(float(row['mastery']), row['last_updated'])
        else:
            current_mastery = p_init

        p_post = _bayes_update(current_mastery, req.correct, p_guess, p_slip)
        t_mult = _time_multiplier(req.time_taken_seconds, tier, req.correct)
        p_next = min(_apply_learning(p_post, p_learn * t_mult), 0.99)
        await conn.execute("""
            INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
            VALUES ($1, $2, $3, 1, $4, NOW())
            ON CONFLICT (user_id, concept_id) DO UPDATE SET
                mastery = $3,
                questions_answered = user_concept_mastery.questions_answered + 1,
                correct_answers = user_concept_mastery.correct_answers + $4,
                last_updated = NOW()
        """, int(req.userId), req.skillId, p_next, 1 if req.correct else 0)
    finally:
        if pool:
            await pool.release(conn)
        else:
            await conn.close()

    return UpdateResponse(
        userId=req.userId, skillId=req.skillId,
        posterior_mastery=float(p_next),
        p_learn=float(p_learn), p_guess=float(p_guess), p_slip=float(p_slip)
    )



# ── EM Fitting Endpoints ──

@app.post("/fit")
async def trigger_fitting(triggered_by: str = 'admin'):
    """Trigger EM parameter fitting. Call this from admin or cron."""
    from bkt_service.em_fitter import fit_all_concepts
    try:
        result = await fit_all_concepts(dry_run=False, triggered_by=triggered_by)
        # Reload cache after fitting
        await reload_learned_params()
        return {"status": "completed", **result}
    except Exception as e:
        logger.error(f"Fitting failed: {e}")
        return {"status": "failed", "error": str(e)}


@app.post("/fit-dry")
async def trigger_fitting_dry():
    """Dry-run EM fitting — prints results without writing to DB."""
    from bkt_service.em_fitter import fit_all_concepts
    try:
        result = await fit_all_concepts(dry_run=True, triggered_by='admin_dry')
        return {"status": "dry_run_complete", **result}
    except Exception as e:
        return {"status": "failed", "error": str(e)}


@app.get("/params/{concept_id}")
async def get_concept_params(concept_id: str):
    """Inspect current BKT params for a concept (learned or default)."""
    result = {}
    for tier in [1, 2, 3]:
        resolved = resolve_params(concept_id, tier)
        cached = learned_params_cache.get((concept_id, tier))
        result[f"tier_{tier}"] = {
            'p_learn': resolved['p_learn'],
            'p_guess': resolved['p_guess'],
            'p_slip':  resolved['p_slip'],
            'source':  resolved['source'],
            'version': cached.get('version') if cached else None,
            'sample_size': cached.get('sample_size') if cached else None,
        }
    return {"concept_id": concept_id, "params": result}


@app.get("/params")
async def get_all_learned_params():
    """List all concepts with learned (non-default) params."""
    result = []
    for (cid, tier), params in learned_params_cache.items():
        result.append({
            'concept_id': cid,
            'difficulty_tier': tier,
            **params
        })
    return {
        "total_learned": len(result),
        "params": sorted(result, key=lambda x: (x['concept_id'], x['difficulty_tier']))
    }


@app.post("/reload-params")
async def reload_params_endpoint():
    """Force reload learned params from DB into cache."""
    await reload_learned_params()
    return {"status": "reloaded", "total_cached": len(learned_params_cache)}


@app.get("/health")
def health():
    return {
        "status": "ok",
        "version": "0.3.0",
        "learned_params_cached": len(learned_params_cache),
        "pool_active": pool is not None
    }
