from fastapi import FastAPI
from fastapi.responses import Response
from pydantic import BaseModel
from typing import Optional

app = FastAPI(title="BKT Service", version="0.2.0")

DEFAULT_P_INIT  = 0.2
DEFAULT_P_LEARN = 0.15
DEFAULT_P_GUESS = 0.2
DEFAULT_P_SLIP  = 0.1


@app.get("/favicon.ico")
def favicon():
    return Response(status_code=204)

@app.get("/")
def root():
    return {"service": "BKT Service", "version": "0.2.0", "docs": "/docs", "health": "/health"}

@app.get("/.well-known/appspecific/com.chrome.devtools.json")
def chrome_devtools():
    return Response(status_code=204)


class UpdateRequest(BaseModel):
    userId: str
    skillId: str
    correct: bool
    p_mastery: float = DEFAULT_P_INIT  # caller passes current mastery from DB
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
    p_mastery: float = DEFAULT_P_INIT  # caller passes current mastery from DB

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


@app.post("/update", response_model=UpdateResponse)
def update_knowledge(req: UpdateRequest):
    p_learn = req.p_learn if req.p_learn is not None else DEFAULT_P_LEARN
    p_guess = req.p_guess if req.p_guess is not None else DEFAULT_P_GUESS
    p_slip  = req.p_slip  if req.p_slip  is not None else DEFAULT_P_SLIP

    p_post = _bayes_update(req.p_mastery, req.correct, p_guess, p_slip)
    p_next = _apply_learning(p_post, p_learn)

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
    return NextResponse(
        userId=req.userId,
        skillId=req.skillId,
        mastery=float(req.p_mastery),
        recommendedDifficulty=_difficulty_from_mastery(req.p_mastery),
    )


@app.get("/health")
def health():
    return {"status": "ok"}
