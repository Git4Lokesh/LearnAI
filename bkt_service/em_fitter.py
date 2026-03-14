"""
BKT Parameter Learning via Expectation-Maximization (Baum-Welch)

Learns optimal (p_init, p_learn, p_guess, p_slip) per concept + difficulty tier
from real student response sequences stored in user_question_attempts.

Lifecycle:
  1. Start with hardcoded TIER_PARAMS (defaults)
  2. Collect student response data passively
  3. Run EM twice/week via cron (or admin trigger)
  4. Once a concept+tier has ≥1000 data points, push learned params
  5. BKT service uses learned params with fallback to defaults

Usage:
  python -m bkt_service.em_fitter          # fit all eligible concepts
  python -m bkt_service.em_fitter --dry    # dry run, print results without writing to DB
"""

import asyncio
import os
import uuid
import math
import argparse
from datetime import datetime, timezone
from typing import List, Tuple, Optional, Dict

import asyncpg

# ──────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────

MIN_SEQUENCES = 1000       # minimum response data points per concept+tier to fit
MIN_STUDENTS = 10          # minimum distinct students
EM_MAX_ITER = 50           # max EM iterations
EM_CONVERGENCE = 1e-4      # stop when log-likelihood change < this
MIN_SEQ_LENGTH = 3         # skip students with < 3 attempts on a concept

# Parameter bounds (prevents degenerate solutions)
BOUNDS = {
    'p_init':  (0.05, 0.50),
    'p_learn': (0.02, 0.40),
    'p_guess': (0.01, 0.45),
    'p_slip':  (0.01, 0.25),
}

# Hardcoded defaults (same as main.py TIER_PARAMS)
DEFAULT_PARAMS = {
    1: {'p_init': 0.20, 'p_learn': 0.12, 'p_guess': 0.35, 'p_slip': 0.15},
    2: {'p_init': 0.20, 'p_learn': 0.15, 'p_guess': 0.20, 'p_slip': 0.10},
    3: {'p_init': 0.20, 'p_learn': 0.18, 'p_guess': 0.08, 'p_slip': 0.05},
}


def _clamp(value: float, low: float, high: float) -> float:
    return max(low, min(high, value))


# ──────────────────────────────────────────────
# Data Loading
# ──────────────────────────────────────────────

async def build_sequences(conn, concept_id: str, difficulty_tier: int) -> Tuple[List[List[bool]], int, int]:
    """
    Build per-student binary response sequences for a given concept + tier.

    Returns:
        sequences: list of lists, each inner list = [True, False, True, ...] for one student
        total_responses: total number of individual responses
        student_count: number of distinct students
    """
    rows = await conn.fetch("""
        SELECT uqa.user_id, uqa.correct
        FROM user_question_attempts uqa
        JOIN questions q ON q.id = uqa.question_id
        WHERE q.concept_id = $1
          AND q.difficulty_tier = $2
        ORDER BY uqa.user_id, uqa.attempted_at ASC
    """, concept_id, difficulty_tier)

    if not rows:
        return [], 0, 0

    # Group by user
    sequences = []
    current_user = None
    current_seq = []

    for row in rows:
        if row['user_id'] != current_user:
            if current_seq and len(current_seq) >= MIN_SEQ_LENGTH:
                sequences.append(current_seq)
            current_user = row['user_id']
            current_seq = []
        current_seq.append(bool(row['correct']))

    # Don't forget last student
    if current_seq and len(current_seq) >= MIN_SEQ_LENGTH:
        sequences.append(current_seq)

    total_responses = sum(len(s) for s in sequences)
    student_count = len(sequences)

    return sequences, total_responses, student_count


# ──────────────────────────────────────────────
# EM Algorithm (Baum-Welch for BKT)
# ──────────────────────────────────────────────

def _emission_prob(obs: bool, mastered: bool, p_guess: float, p_slip: float) -> float:
    """P(observation | hidden state)"""
    if mastered:
        return (1 - p_slip) if obs else p_slip
    else:
        return p_guess if obs else (1 - p_guess)


def _forward_backward(seq: List[bool], p_init: float, p_learn: float,
                       p_guess: float, p_slip: float) -> Tuple[List[float], List[float], float]:
    """
    Run forward-backward algorithm on a single student's response sequence.

    Hidden states: 0 = unmastered, 1 = mastered
    Transition: P(mastered_t+1 | unmastered_t) = p_learn
                P(mastered_t+1 | mastered_t)   = 1.0 (no forgetting in standard BKT)

    Returns:
        gamma: posterior P(mastered) at each time step
        xi_learn: P(transition 0→1) at each time step
        log_likelihood: log P(observations | params)
    """
    T = len(seq)
    if T == 0:
        return [], [], 0.0

    # Forward pass
    alpha = []  # alpha[t] = [P(unmastered, obs_1:t), P(mastered, obs_1:t)]
    # t=0
    e_unmastered = _emission_prob(seq[0], False, p_guess, p_slip)
    e_mastered = _emission_prob(seq[0], True, p_guess, p_slip)
    a0_u = (1 - p_init) * e_unmastered
    a0_m = p_init * e_mastered
    normalizer = a0_u + a0_m
    if normalizer < 1e-300:
        normalizer = 1e-300
    alpha.append((a0_u / normalizer, a0_m / normalizer))
    log_lik = math.log(normalizer)

    for t in range(1, T):
        prev_u, prev_m = alpha[t - 1]
        # Transition
        pred_u = prev_u * (1 - p_learn)           # stayed unmastered
        pred_m = prev_u * p_learn + prev_m * 1.0   # learned or stayed mastered
        # Emission
        e_u = _emission_prob(seq[t], False, p_guess, p_slip)
        e_m = _emission_prob(seq[t], True, p_guess, p_slip)
        at_u = pred_u * e_u
        at_m = pred_m * e_m
        normalizer = at_u + at_m
        if normalizer < 1e-300:
            normalizer = 1e-300
        alpha.append((at_u / normalizer, at_m / normalizer))
        log_lik += math.log(normalizer)

    # Backward pass
    beta = [(1.0, 1.0)] * T
    for t in range(T - 2, -1, -1):
        e_u_next = _emission_prob(seq[t + 1], False, p_guess, p_slip)
        e_m_next = _emission_prob(seq[t + 1], True, p_guess, p_slip)
        bt_u = (1 - p_learn) * e_u_next * beta[t + 1][0] + p_learn * e_m_next * beta[t + 1][1]
        bt_m = 1.0 * e_m_next * beta[t + 1][1]  # mastered stays mastered
        normalizer = bt_u + bt_m
        if normalizer < 1e-300:
            normalizer = 1e-300
        beta[t] = (bt_u / normalizer, bt_m / normalizer)

    # Gamma: P(mastered at t | all observations)
    gamma = []
    for t in range(T):
        g_u = alpha[t][0] * beta[t][0]
        g_m = alpha[t][1] * beta[t][1]
        total = g_u + g_m
        if total < 1e-300:
            total = 1e-300
        gamma.append(g_m / total)

    # Xi_learn: P(transition unmastered→mastered at t | all observations)
    xi_learn = []
    for t in range(T - 1):
        e_u_next = _emission_prob(seq[t + 1], False, p_guess, p_slip)
        e_m_next = _emission_prob(seq[t + 1], True, p_guess, p_slip)
        # P(unmastered_t, mastered_{t+1} | all obs)
        xi_01 = alpha[t][0] * p_learn * e_m_next * beta[t + 1][1]
        # P(unmastered_t, unmastered_{t+1} | all obs)
        xi_00 = alpha[t][0] * (1 - p_learn) * e_u_next * beta[t + 1][0]
        total = xi_00 + xi_01
        if total < 1e-300:
            xi_learn.append(0.0)
        else:
            xi_learn.append(xi_01 / total)

    return gamma, xi_learn, log_lik


def em_fit(sequences: List[List[bool]], init_params: Optional[Dict] = None,
           max_iter: int = EM_MAX_ITER, tol: float = EM_CONVERGENCE) -> Tuple[Dict, float, int]:
    """
    Run EM (Baum-Welch) to fit BKT parameters from multiple student sequences.

    Args:
        sequences: list of per-student binary response lists
        init_params: optional starting parameters dict with p_init, p_learn, p_guess, p_slip
        max_iter: maximum EM iterations
        tol: convergence tolerance on log-likelihood change

    Returns:
        params: dict with fitted p_init, p_learn, p_guess, p_slip
        log_likelihood: final log-likelihood
        iterations: number of iterations run
    """
    if not sequences:
        raise ValueError("No sequences provided")

    # Initialize from defaults or provided params
    if init_params:
        p_init = init_params.get('p_init', 0.2)
        p_learn = init_params.get('p_learn', 0.15)
        p_guess = init_params.get('p_guess', 0.2)
        p_slip = init_params.get('p_slip', 0.1)
    else:
        p_init, p_learn, p_guess, p_slip = 0.2, 0.15, 0.2, 0.1

    prev_ll = -float('inf')

    for iteration in range(max_iter):
        # ──── E-step ────
        # Accumulate sufficient statistics across all students
        sum_gamma_0 = 0.0       # sum of P(mastered at t=0)
        sum_xi_01 = 0.0         # sum of P(unmastered→mastered transitions)
        sum_gamma_unmastered = 0.0  # sum of P(unmastered) at non-terminal steps
        sum_correct_unmastered = 0.0  # sum of P(correct AND unmastered)
        sum_wrong_mastered = 0.0      # sum of P(wrong AND mastered)
        sum_gamma_all = 0.0     # total gamma for emission re-estimation
        total_obs = 0
        total_ll = 0.0

        for seq in sequences:
            gamma, xi_learn, ll = _forward_backward(seq, p_init, p_learn, p_guess, p_slip)
            total_ll += ll

            T = len(seq)
            if T == 0:
                continue

            # p_init: P(mastered at t=0)
            sum_gamma_0 += gamma[0]

            # p_learn: P(0→1) / P(in state 0) across non-terminal steps
            for t in range(T - 1):
                p_unmastered_t = 1 - gamma[t]
                sum_gamma_unmastered += p_unmastered_t
                sum_xi_01 += xi_learn[t] * p_unmastered_t  # weighted

            # p_guess and p_slip: emission re-estimation
            for t in range(T):
                p_m = gamma[t]
                p_u = 1 - gamma[t]
                if seq[t]:  # correct answer
                    sum_correct_unmastered += p_u   # correct while unmastered = guess
                else:       # wrong answer
                    sum_wrong_mastered += p_m         # wrong while mastered = slip
                sum_gamma_all += 1
            total_obs += T

        # ──── M-step ────
        N = len(sequences)

        # p_init
        new_p_init = sum_gamma_0 / N if N > 0 else p_init
        new_p_init = _clamp(new_p_init, *BOUNDS['p_init'])

        # p_learn
        if sum_gamma_unmastered > 1e-10:
            new_p_learn = sum_xi_01 / sum_gamma_unmastered
        else:
            new_p_learn = p_learn
        new_p_learn = _clamp(new_p_learn, *BOUNDS['p_learn'])

        # p_guess = P(correct | unmastered)
        total_unmastered = sum(1 - g for seq in sequences for g in
                               _forward_backward(seq, p_init, p_learn, p_guess, p_slip)[0])
        if total_unmastered > 1e-10:
            new_p_guess = sum_correct_unmastered / total_unmastered
        else:
            new_p_guess = p_guess

        # p_slip = P(wrong | mastered)
        total_mastered = total_obs - total_unmastered
        if total_mastered > 1e-10:
            new_p_slip = sum_wrong_mastered / total_mastered
        else:
            new_p_slip = p_slip

        # Enforce constraints
        new_p_guess = _clamp(new_p_guess, *BOUNDS['p_guess'])
        new_p_slip = _clamp(new_p_slip, *BOUNDS['p_slip'])

        # Sanity: p_guess should not exceed (1 - p_slip), otherwise model is degenerate
        if new_p_guess + new_p_slip > 0.9:
            new_p_guess = min(new_p_guess, 0.45)
            new_p_slip = min(new_p_slip, 0.20)

        p_init, p_learn, p_guess, p_slip = new_p_init, new_p_learn, new_p_guess, new_p_slip

        # Check convergence
        if abs(total_ll - prev_ll) < tol:
            return {
                'p_init': round(p_init, 4),
                'p_learn': round(p_learn, 4),
                'p_guess': round(p_guess, 4),
                'p_slip': round(p_slip, 4),
            }, total_ll, iteration + 1

        prev_ll = total_ll

    return {
        'p_init': round(p_init, 4),
        'p_learn': round(p_learn, 4),
        'p_guess': round(p_guess, 4),
        'p_slip': round(p_slip, 4),
    }, prev_ll, max_iter


# ──────────────────────────────────────────────
# Sanity Checks
# ──────────────────────────────────────────────

def validate_params(params: Dict, prev_params: Optional[Dict] = None) -> Tuple[bool, List[str]]:
    """
    Validate fitted parameters. Returns (is_valid, list_of_warnings).
    """
    warnings = []

    # Basic bounds
    if params['p_guess'] >= params.get('p_slip', 1.0) + 0.35:
        warnings.append(f"p_guess ({params['p_guess']}) much higher than p_slip ({params['p_slip']})")

    if params['p_learn'] > 0.35:
        warnings.append(f"p_learn ({params['p_learn']}) suspiciously high")

    # Drift check against previous version
    if prev_params:
        for key in ('p_init', 'p_learn', 'p_guess', 'p_slip'):
            old = prev_params.get(key, 0)
            new = params.get(key, 0)
            if old > 0 and abs(new - old) / old > 0.30:
                warnings.append(f"{key} shifted by {abs(new-old)/old*100:.0f}% ({old:.4f} → {new:.4f})")

    is_valid = len([w for w in warnings if 'much higher' in w]) == 0
    return is_valid, warnings


# ──────────────────────────────────────────────
# Main Fitting Pipeline
# ──────────────────────────────────────────────

async def get_pool():
    return await asyncpg.create_pool(
        host='localhost', port=5432, user='postgres',
        password=os.environ.get('db_password'),
        database=os.environ.get('db_name', 'dblearn'),
        min_size=2, max_size=5
    )


async def fit_all_concepts(dry_run: bool = False, triggered_by: str = 'cron'):
    """
    Main entry point: fit BKT params for all concepts with enough data.

    Args:
        dry_run: if True, print results but don't write to DB
        triggered_by: 'cron', 'admin', or 'test'
    """
    pool = await get_pool()
    run_id = str(uuid.uuid4())[:8]
    started_at = datetime.now(timezone.utc)

    concepts_fitted = 0
    concepts_skipped = 0
    total_sequences = 0

    try:
        async with pool.acquire() as conn:
            # Log the run start
            if not dry_run:
                await conn.execute("""
                    INSERT INTO bkt_fitting_log (run_id, started_at, status, triggered_by)
                    VALUES ($1, $2, 'running', $3)
                """, run_id, started_at, triggered_by)

            # Get all concepts that have questions
            concept_tiers = await conn.fetch("""
                SELECT q.concept_id, q.difficulty_tier, COUNT(*) as attempt_count,
                       COUNT(DISTINCT uqa.user_id) as student_count
                FROM user_question_attempts uqa
                JOIN questions q ON q.id = uqa.question_id
                WHERE q.concept_id IS NOT NULL
                GROUP BY q.concept_id, q.difficulty_tier
                HAVING COUNT(*) >= $1 AND COUNT(DISTINCT uqa.user_id) >= $2
                ORDER BY COUNT(*) DESC
            """, MIN_SEQUENCES, MIN_STUDENTS)

            print(f"\n{'='*60}")
            print(f"BKT EM Fitting Run: {run_id}")
            print(f"{'='*60}")
            print(f"Eligible concept+tier pairs: {len(concept_tiers)}")
            print(f"Min sequences: {MIN_SEQUENCES}, Min students: {MIN_STUDENTS}")
            print(f"Mode: {'DRY RUN' if dry_run else 'LIVE'}")
            print(f"{'='*60}\n")

            for row in concept_tiers:
                concept_id = row['concept_id']
                tier = row['difficulty_tier']
                attempt_count = row['attempt_count']
                student_count = row['student_count']

                print(f"  Fitting: {concept_id} (tier {tier}) — "
                      f"{attempt_count} attempts, {student_count} students")

                # Build sequences
                sequences, n_responses, n_students = await build_sequences(conn, concept_id, tier)

                if not sequences or n_responses < MIN_SEQUENCES:
                    print(f"    ⏭  Skipping (only {n_responses} responses after filtering)")
                    concepts_skipped += 1
                    continue

                total_sequences += n_responses

                # Get previous params for drift checking
                prev_row = await conn.fetchrow("""
                    SELECT p_init, p_learn, p_guess, p_slip, version
                    FROM concept_bkt_params
                    WHERE concept_id = $1 AND difficulty_tier = $2 AND is_active = true
                    ORDER BY version DESC LIMIT 1
                """, concept_id, tier)

                prev_params = None
                prev_version = 0
                if prev_row:
                    prev_params = {
                        'p_init': float(prev_row['p_init']),
                        'p_learn': float(prev_row['p_learn']),
                        'p_guess': float(prev_row['p_guess']),
                        'p_slip': float(prev_row['p_slip']),
                    }
                    prev_version = prev_row['version']

                # Initialize EM from previous fitted params or tier defaults
                init_params = prev_params or DEFAULT_PARAMS.get(tier, DEFAULT_PARAMS[2])

                # Run EM
                try:
                    fitted, log_lik, iterations = em_fit(sequences, init_params)
                except Exception as e:
                    print(f"    ❌ EM failed: {e}")
                    concepts_skipped += 1
                    continue

                # Validate
                is_valid, warnings = validate_params(fitted, prev_params)
                for w in warnings:
                    print(f"    ⚠️  {w}")

                if not is_valid:
                    print(f"    ❌ Params failed validation, skipping")
                    concepts_skipped += 1
                    continue

                new_version = prev_version + 1

                print(f"    ✅ Fitted in {iterations} iterations (LL={log_lik:.2f})")
                print(f"       p_init={fitted['p_init']:.4f}  p_learn={fitted['p_learn']:.4f}  "
                      f"p_guess={fitted['p_guess']:.4f}  p_slip={fitted['p_slip']:.4f}")
                if prev_params:
                    print(f"       (was: p_init={prev_params['p_init']:.4f}  "
                          f"p_learn={prev_params['p_learn']:.4f}  "
                          f"p_guess={prev_params['p_guess']:.4f}  "
                          f"p_slip={prev_params['p_slip']:.4f})")
                print(f"       version: {prev_version} → {new_version}")

                if not dry_run:
                    # Deactivate previous version
                    await conn.execute("""
                        UPDATE concept_bkt_params
                        SET is_active = false
                        WHERE concept_id = $1 AND difficulty_tier = $2 AND is_active = true
                    """, concept_id, tier)

                    # Insert new version
                    await conn.execute("""
                        INSERT INTO concept_bkt_params
                            (concept_id, difficulty_tier, p_init, p_learn, p_guess, p_slip,
                             source, version, sample_size, student_count, log_likelihood, is_active)
                        VALUES ($1, $2, $3, $4, $5, $6, 'em_fitted', $7, $8, $9, $10, true)
                    """, concept_id, tier,
                        fitted['p_init'], fitted['p_learn'], fitted['p_guess'], fitted['p_slip'],
                        new_version, n_responses, n_students, log_lik)

                concepts_fitted += 1

            # Finalize log
            if not dry_run:
                await conn.execute("""
                    UPDATE bkt_fitting_log
                    SET completed_at = NOW(), concepts_fitted = $2, concepts_skipped = $3,
                        total_sequences = $4, status = 'completed'
                    WHERE run_id = $1
                """, run_id, concepts_fitted, concepts_skipped, total_sequences)

        print(f"\n{'='*60}")
        print(f"Run {run_id} complete: {concepts_fitted} fitted, {concepts_skipped} skipped")
        print(f"Total response sequences processed: {total_sequences}")
        print(f"{'='*60}\n")

    except Exception as e:
        print(f"\n❌ Fitting run failed: {e}")
        try:
            async with pool.acquire() as conn:
                await conn.execute("""
                    UPDATE bkt_fitting_log
                    SET completed_at = NOW(), status = 'failed', error_message = $2
                    WHERE run_id = $1
                """, run_id, str(e))
        except Exception:
            pass
        raise
    finally:
        await pool.close()

    return {
        'run_id': run_id,
        'concepts_fitted': concepts_fitted,
        'concepts_skipped': concepts_skipped,
        'total_sequences': total_sequences,
    }


# ──────────────────────────────────────────────
# CLI Entry Point
# ──────────────────────────────────────────────

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='BKT EM Parameter Fitter')
    parser.add_argument('--dry', action='store_true', help='Dry run (print only, no DB writes)')
    parser.add_argument('--trigger', default='cli', help='Trigger source label')
    args = parser.parse_args()

    asyncio.run(fit_all_concepts(dry_run=args.dry, triggered_by=args.trigger))
