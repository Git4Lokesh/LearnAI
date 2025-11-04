from fastapi import FastAPI
from fastapi.responses import Response
from pydantic import BaseModel
from typing import Dict, Optional
import math

app = FastAPI(title="BKT Service", version="0.1.0")

# Handle favicon requests to prevent 404 errors
@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)  # No Content - prevents 404 error

# Handle root path requests
@app.get("/")
def root():
    return {
        "service": "BKT Service",
        "version": "0.1.0",
        "docs": "/docs",
        "health": "/health"
    }

# Handle Chrome DevTools auto-discovery requests
@app.get("/.well-known/appspecific/com.chrome.devtools.json")
def chrome_devtools():
    return Response(status_code=204)  # No Content - prevents 404 error

# Simple in-memory store: { userId: { skillId: state } }
# State per skill stores mastery probability and parameters
_store: Dict[str, Dict[str, Dict[str, float]]] = {}

# Default BKT parameters (can be tuned per skill)
DEFAULT_P_INIT = 0.2   # prior mastery
DEFAULT_P_LEARN = 0.15 # transition from not-mastered -> mastered
DEFAULT_P_GUESS = 0.2  # probability of correct if not mastered
DEFAULT_P_SLIP  = 0.1  # probability of incorrect if mastered

class UpdateRequest(BaseModel):
    userId: str
    skillId: str
    correct: bool
    # optional overrides
    p_init: Optional[float] = None
    p_learn: Optional[float] = None
    p_guess: Optional[float] = None
    p_slip: Optional[float] = None

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

class NextResponse(BaseModel):
    userId: str
    skillId: str
    mastery: float
    # Simple policy: map mastery to difficulty bucket
    recommendedDifficulty: str  # one of: very_easy, easy, medium, hard, very_hard


def _get_params(payload: UpdateRequest):
    return (
        payload.p_init if payload.p_init is not None else DEFAULT_P_INIT,
        payload.p_learn if payload.p_learn is not None else DEFAULT_P_LEARN,
        payload.p_guess if payload.p_guess is not None else DEFAULT_P_GUESS,
        payload.p_slip  if payload.p_slip  is not None else DEFAULT_P_SLIP,
    )


def _get_state(user_id: str, skill_id: str, p_init: float):
    user_state = _store.setdefault(user_id, {})
    skill_state = user_state.get(skill_id)
    if skill_state is None:
        skill_state = {"p_mastery": float(p_init)}
        user_state[skill_id] = skill_state
    return skill_state


def _bayes_update(p_mastery: float, correct: bool, p_guess: float, p_slip: float) -> float:
    # Posterior mastery given observation
    if correct:
        num = p_mastery * (1 - p_slip)
        den = num + (1 - p_mastery) * p_guess
    else:
        num = p_mastery * p_slip
        den = num + (1 - p_mastery) * (1 - p_guess)
    if den == 0:
        return p_mastery
    return num / den


def _apply_learning(p_mastery_post: float, p_learn: float) -> float:
    # State transition after observation
    return p_mastery_post + (1 - p_mastery_post) * p_learn


def _difficulty_from_mastery(m: float) -> str:
    if m < 0.2:
        return "very_hard"
    if m < 0.4:
        return "hard"
    if m < 0.6:
        return "medium"
    if m < 0.8:
        return "easy"
    return "very_easy"


@app.post("/update", response_model=UpdateResponse)
def update_knowledge(req: UpdateRequest):
    p_init, p_learn, p_guess, p_slip = _get_params(req)
    state = _get_state(req.userId, req.skillId, p_init)

    p_m = state["p_mastery"]
    p_post = _bayes_update(p_m, req.correct, p_guess, p_slip)
    p_next = _apply_learning(p_post, p_learn)

    state["p_mastery"] = float(p_next)

    return UpdateResponse(
        userId=req.userId,
        skillId=req.skillId,
        posterior_mastery=float(p_next),
        p_learn=float(p_learn),
        p_guess=float(p_guess),
        p_slip=float(p_slip),
    )


@app.post("/next", response_model=NextResponse)
def next_question(req: NextRequest):
    # If no state yet, use prior
    p_init = DEFAULT_P_INIT
    mastery = _get_state(req.userId, req.skillId, p_init)["p_mastery"]
    return NextResponse(
        userId=req.userId,
        skillId=req.skillId,
        mastery=float(mastery),
        recommendedDifficulty=_difficulty_from_mastery(mastery),
    )


@app.get("/health")
def health():
    return {"status": "ok"}
