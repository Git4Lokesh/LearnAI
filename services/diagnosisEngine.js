/**
 * Learn.ai — Prerequisite Diagnosis Engine
 * 
 * A multi-signal graph analysis algorithm that combines:
 *   1. BKT mastery posteriors (with time-decay correction)
 *   2. Confidence estimation from sample size + accuracy variance
 *   3. Recency/staleness detection
 *   4. Graph-theoretic impact analysis (downstream blocking, critical path)
 *   5. Composite "readiness score" per node
 *   6. Optimal study path via weighted topological ordering
 *
 * The core insight: raw mastery alone is insufficient. A student at 0.78 mastery
 * after 50 questions is fundamentally different from 0.78 after 3 questions.
 * A concept mastered 3 months ago with no practice is different from one
 * practiced yesterday. This engine fuses all available signals.
 */

// ─── Constants ──────────────────────────────────────────────────────────────

const MASTERY_THRESHOLD = 0.80;   // BKT mastery considered "mastered"
const WEAK_THRESHOLD    = 0.50;   // Below this = significant gap
const DECAY_LAMBDA      = 0.03;   // Must match BKT service & app.js
const MASTERY_FLOOR     = 0.10;   // Decay floor

// Confidence estimation constants
const CONFIDENCE_SAMPLES_HIGH = 15;  // >= this many questions = high confidence
const CONFIDENCE_SAMPLES_MED  = 5;   // >= this many = medium confidence

// Staleness thresholds (days)
const STALE_DAYS_WARNING  = 14;   // 2 weeks without practice = stale warning
const STALE_DAYS_CRITICAL = 30;   // 1 month = critically stale

// Readiness score weights (must sum to 1.0)
const W_MASTERY    = 0.30;  // How well they know it (BKT posterior)
const W_CONFIDENCE = 0.20;  // How sure we are about the mastery estimate
const W_RECENCY    = 0.15;  // How recently they practiced
const W_ACCURACY   = 0.15;  // Raw accuracy trend (correct/total)
const W_CALIBRATION = 0.20; // How well BKT model agrees with raw performance


// ─── Core Functions ─────────────────────────────────────────────────────────

/**
 * Apply exponential time decay to a mastery value.
 * Matches the BKT service's _decay_mastery and app.js applyDecay.
 */
function decayMastery(mastery, lastUpdated) {
    if (!lastUpdated) return mastery;
    const now = Date.now();
    const then = new Date(lastUpdated).getTime();
    const days = (now - then) / 86400000;
    return Math.max(mastery * Math.exp(-DECAY_LAMBDA * days), MASTERY_FLOOR);
}

/**
 * Compute a confidence score [0, 1] for a mastery estimate.
 * 
 * Based on two signals:
 *   - Sample size: more questions answered = more confident
 *   - Accuracy stability: if accuracy ≈ mastery, the estimate is stable
 * 
 * A student with 3 questions answered has low confidence regardless of mastery.
 * A student with 50 questions where accuracy diverges from BKT mastery has
 * medium confidence (the model may be miscalibrated for them).
 */
function computeConfidence(questionsAnswered, correctAnswers, mastery) {
    if (questionsAnswered === 0) return 0;

    // Sample size component: sigmoid curve, saturates around 15-20 questions
    // f(n) = 1 - e^(-n/8), gives ~0.47 at n=5, ~0.85 at n=15, ~0.95 at n=25
    const sampleScore = 1 - Math.exp(-questionsAnswered / 8);

    // Accuracy-mastery agreement: if raw accuracy and BKT mastery agree,
    // the model is well-calibrated for this student-concept pair
    const accuracy = correctAnswers / questionsAnswered;
    const divergence = Math.abs(accuracy - mastery);
    // Agreement score: 1.0 when perfect agreement, drops as they diverge
    // A divergence of 0.3+ means the model is poorly calibrated
    const agreementScore = Math.max(0, 1 - divergence * 2.5);

    // Weighted combination: sample size matters more than agreement
    return 0.7 * sampleScore + 0.3 * agreementScore;
}

/**
 * Compute a recency score [0, 1] based on days since last practice.
 * 1.0 = practiced today, decays smoothly, 0.0 = never practiced.
 */
function computeRecency(lastUpdated) {
    if (!lastUpdated) return 0;
    const days = (Date.now() - new Date(lastUpdated).getTime()) / 86400000;
    if (days < 1) return 1.0;
    if (days < 3) return 0.95;
    if (days < 7) return 0.85;
    if (days < 14) return 0.70;
    if (days < 30) return 0.45;
    if (days < 60) return 0.25;
    return Math.max(0.05, 0.25 * Math.exp(-0.02 * (days - 60)));
}

/**
 * Compute the composite "readiness score" for a concept.
 * 
 * This is the heart of the diagnosis: a single [0, 1] score that fuses
 * all available signals into "how ready is this student for this concept?"
 * 
 * A high readiness score means: high mastery + high confidence + recent practice + good accuracy + well-calibrated model.
 * A low readiness score means: the student needs work here, and we're fairly sure about that.
 */
function computeReadiness(decayedMastery, confidence, recency, accuracy, calibration) {
    return (
        W_MASTERY     * decayedMastery +
        W_CONFIDENCE  * confidence +
        W_RECENCY     * recency +
        W_ACCURACY    * accuracy +
        W_CALIBRATION * calibration
    );
}

/**
 * Analyze the divergence between BKT mastery and raw accuracy.
 * 
 * This is a powerful diagnostic signal. When BKT and raw accuracy disagree
 * significantly, it reveals specific student patterns:
 * 
 *   - High accuracy, low BKT mastery ("underestimated"):
 *     Student is performing well but BKT hasn't caught up. Could mean:
 *     - Recent rapid improvement (BKT is lagging)
 *     - Questions are too easy for this concept (p_guess is too low)
 *     - Student is good at guessing (test-taking skill, not mastery)
 * 
 *   - Low accuracy, high BKT mastery ("overestimated"):
 *     BKT thinks they know it but they keep getting questions wrong. Could mean:
 *     - Knowledge decay not captured by the model
 *     - Student got lucky early on (inflated mastery)
 *     - Concept has tricky edge cases the student hasn't encountered
 * 
 *   - Agreement ("well-calibrated"):
 *     BKT and accuracy roughly agree. The model is working well for this student-concept pair.
 * 
 * Returns:
 *   calibration: [0, 1] score where 1.0 = perfect agreement
 *   divergenceType: 'underestimated' | 'overestimated' | 'calibrated' | null
 *   divergenceMagnitude: absolute difference (0 to 1)
 */
function analyzeDivergence(decayedMastery, questionsAnswered, correctAnswers) {
    if (questionsAnswered < 3) {
        // Not enough data to detect divergence
        return { calibration: 0.5, divergenceType: null, divergenceMagnitude: 0 };
    }

    const accuracy = correctAnswers / questionsAnswered;
    const divergence = accuracy - decayedMastery;
    const absDivergence = Math.abs(divergence);

    // Calibration score: 1.0 when perfect agreement, drops as they diverge
    // Use a softer curve than before — small divergences are normal
    const calibration = Math.max(0, 1 - absDivergence * 2);

    // Classify the divergence
    let divergenceType = 'calibrated';
    // Only flag significant divergences (>15% gap with enough data)
    if (absDivergence > 0.15 && questionsAnswered >= 5) {
        if (divergence > 0) {
            divergenceType = 'underestimated'; // accuracy > mastery
        } else {
            divergenceType = 'overestimated';  // mastery > accuracy
        }
    }

    return {
        calibration,
        divergenceType,
        divergenceMagnitude: Math.round(absDivergence * 100)
    };
}

/**
 * Use learned EM-fitted BKT parameters to refine the effort estimate.
 * 
 * If we have learned p_learn for a concept, we can estimate how many
 * questions it takes to reach mastery more accurately than the default heuristic.
 * 
 * The math: starting from mastery m, after n correct answers with learning rate p_learn,
 * mastery ≈ 1 - (1-m) * (1-p_learn)^n. Solving for n to reach threshold T:
 *   n = log(1-T) / log(1-p_learn) - log(1-m) / log(1-p_learn)
 * 
 * This accounts for concept difficulty: a concept with p_learn=0.05 (hard to learn)
 * needs way more questions than one with p_learn=0.25 (easy to learn).
 */
function estimateQuestionsNeeded(currentMastery, learnedParams) {
    const target = MASTERY_THRESHOLD;
    if (currentMastery >= target) return 0;

    const pLearn = learnedParams?.p_learn ?? 0.15; // default if no learned params
    
    // Avoid log(0) or log(1)
    const effectivePLearn = Math.max(0.02, Math.min(0.40, pLearn));
    
    // Geometric series: questions needed assuming ~60% correct rate
    // Each correct answer: mastery += (1-mastery) * p_learn
    // Each wrong answer: mastery gets Bayesian penalty
    // Net effect per question ≈ p_learn * 0.6 (expected correct rate for struggling student)
    const effectiveLearnPerQ = effectivePLearn * 0.6;
    
    if (effectiveLearnPerQ <= 0.001) return 50; // cap at 50 if learning rate is tiny
    
    const gap = target - currentMastery;
    // Approximate: n ≈ -log(1 - gap/(1-currentMastery)) / log(1/(1-effectiveLearnPerQ))
    // Simplified: n ≈ gap / (effectiveLearnPerQ * (1 - currentMastery/2))
    const n = gap / (effectiveLearnPerQ * Math.max(0.3, 1 - currentMastery / 2));
    
    return Math.min(50, Math.max(1, Math.ceil(n)));
}


/**
 * Classify a node's severity based on multi-signal analysis.
 * 
 * Categories (in order of urgency):
 *   - root_cause:  Unmastered, no unmastered prereqs of its own. This is WHERE TO START.
 *   - critical:    Below weak threshold with unmastered prereqs above it. Deep problem.
 *   - weak:        Between weak and mastery threshold. Needs reinforcement.
 *   - stale:       Was mastered but hasn't been practiced in a long time. At risk.
 *   - ok:          Mastered with reasonable confidence and recency.
 * 
 * The key distinction from the old algorithm: "stale" is a new category.
 * A concept that was mastered 2 months ago but never revisited is NOT the same
 * as one mastered yesterday. The BKT decay handles the math, but the UX needs
 * to surface this as a distinct state.
 */
function classifyNode(node, hasUnmasteredPrereq) {
    const { decayedMastery, confidence, recency, readiness, questionsAnswered, daysSinceLastPractice } = node;

    // Never attempted — distinct from "attempted and failed"
    if (questionsAnswered === 0) {
        if (!hasUnmasteredPrereq) return 'root_cause';
        return 'critical';
    }

    const mastered = decayedMastery >= MASTERY_THRESHOLD;

    // Stale detection: was likely mastered at some point but hasn't been practiced
    // and decay has brought it below threshold, OR it's still above threshold but
    // the recency is very low (practiced long ago)
    if (mastered && daysSinceLastPractice > STALE_DAYS_CRITICAL) {
        return 'stale';
    }

    if (mastered) return 'ok';

    // Below mastery threshold — classify by severity
    if (decayedMastery < WEAK_THRESHOLD) {
        // Low mastery. Is this a root cause or a downstream effect?
        if (!hasUnmasteredPrereq) return 'root_cause';
        return 'critical';
    }

    // Between weak and mastery threshold (0.5 - 0.8)
    // Check if this is stale (was higher, decayed down)
    if (daysSinceLastPractice > STALE_DAYS_WARNING) return 'stale';

    // If no unmastered prereqs, this is a root cause (just needs more practice)
    if (!hasUnmasteredPrereq) return 'root_cause';

    return 'weak';
}


// ─── Graph Analysis ─────────────────────────────────────────────────────────

/**
 * Compute the "impact score" of a node: how many downstream concepts it blocks,
 * weighted by the severity of those downstream concepts.
 * 
 * A root cause that blocks 5 critical nodes is more impactful than one that
 * blocks 2 ok nodes. This drives study path prioritization.
 */
function computeImpactScore(nodeId, dependsOn, nodeMap, targetId) {
    const visited = new Set();
    const queue = [nodeId];
    let impact = 0;

    while (queue.length > 0) {
        const cur = queue.shift();
        for (const dep of (dependsOn[cur] || [])) {
            if (!visited.has(dep) && dep !== targetId) {
                visited.add(dep);
                queue.push(dep);
                // Weight by how unmastered the downstream node is
                const downstream = nodeMap.get(dep);
                if (downstream) {
                    // Unmastered downstream nodes contribute more to impact
                    impact += (1 - downstream.decayedMastery);
                } else {
                    impact += 0.5; // Unknown node, assume moderate impact
                }
            }
        }
    }

    return { blocksCount: visited.size, impactScore: Math.round(impact * 100) / 100 };
}


/**
 * Generate the optimal study path using a modified topological sort.
 * 
 * Standard topological sort gives a valid ordering but doesn't optimize for
 * learning efficiency. We use a priority-based approach:
 * 
 * 1. Start from root causes (no unmastered prereqs)
 * 2. Among available nodes, pick the one with highest "study priority"
 * 3. Study priority = impactScore * (1 - readiness) * depthWeight
 *    - High impact = fixes more downstream problems
 *    - Low readiness = needs the most work
 *    - Deep nodes first = build from foundations up
 * 4. After "completing" a node, unlock its dependents
 * 
 * This produces a path that maximizes learning ROI: study the concepts
 * that will unblock the most progress first.
 */
function computeStudyPath(nodes, prereqOf, dependsOn, targetId, maxSteps = 10) {
    // Build a map of unmastered nodes and their prereq counts
    const unmastered = new Map();
    const inDegree = new Map();

    for (const node of nodes) {
        if (node.severity === 'ok') continue; // Skip mastered nodes
        unmastered.set(node.id, node);

        // Count how many unmastered prereqs this node has
        const prereqs = prereqOf[node.id] || [];
        let unmasteredPrereqCount = 0;
        for (const pid of prereqs) {
            const pNode = nodes.find(n => n.id === pid);
            if (pNode && pNode.severity !== 'ok') {
                unmasteredPrereqCount++;
            }
        }
        inDegree.set(node.id, unmasteredPrereqCount);
    }

    const path = [];
    const completed = new Set();

    while (path.length < maxSteps && unmastered.size > 0) {
        // Find all "available" nodes: unmastered prereqs are all completed or mastered
        const available = [];
        for (const [id, node] of unmastered) {
            if (completed.has(id)) continue;
            if ((inDegree.get(id) || 0) <= 0) {
                available.push(node);
            }
        }

        if (available.length === 0) break; // Cycle or all done

        // Pick the best node to study next
        // Priority: high impact * low readiness * depth bonus
        available.sort((a, b) => {
            const prioA = a.impactScore * (1 - a.readiness) * (1 + a.depth * 0.1);
            const prioB = b.impactScore * (1 - b.readiness) * (1 + b.depth * 0.1);
            if (Math.abs(prioA - prioB) > 0.01) return prioB - prioA;
            // Tiebreak: deeper first (build foundations), then lower mastery
            if (a.depth !== b.depth) return b.depth - a.depth;
            return a.decayedMastery - b.decayedMastery;
        });

        const chosen = available[0];
        path.push({
            id: chosen.id,
            name: chosen.name,
            mastery: chosen.masteryPct,
            readiness: Math.round(chosen.readiness * 100),
            impactScore: chosen.impactScore,
            depth: chosen.depth,
            severity: chosen.severity,
            reason: buildStudyReason(chosen)
        });

        // "Complete" this node: reduce in-degree of its dependents
        completed.add(chosen.id);
        unmastered.delete(chosen.id);
        for (const dep of (dependsOn[chosen.id] || [])) {
            if (inDegree.has(dep)) {
                inDegree.set(dep, (inDegree.get(dep) || 1) - 1);
            }
        }
    }

    return path;
}


/**
 * Generate a human-readable reason for why this concept is in the study path.
 */
function buildStudyReason(node) {
    const parts = [];

    if (node.questionsAnswered === 0) {
        parts.push('Never attempted.');
        if (node.blocksCount > 0) {
            parts.push(`Blocks ${node.blocksCount} other concept${node.blocksCount > 1 ? 's' : ''}.`);
        } else {
            parts.push('Start here to build foundations.');
        }
        return parts.join(' ');
    }

    if (node.severity === 'stale') {
        parts.push(`Last practiced ${node.daysSinceLastPractice}d ago. Mastery has decayed — needs review.`);
        return parts.join(' ');
    }

    parts.push(`${node.masteryPct}% mastery after ${node.questionsAnswered} questions.`);

    if (node.blocksCount > 0) parts.push(`Blocks ${node.blocksCount} downstream.`);
    if (node.confidence < 0.5) parts.push('Low confidence — needs more practice data.');

    // Divergence insight
    if (node.divergenceType === 'overestimated' && node.divergenceMagnitude > 15) {
        parts.push(`⚠ Model may overestimate — accuracy is only ${node.accuracy}%.`);
    } else if (node.divergenceType === 'underestimated' && node.divergenceMagnitude > 15) {
        parts.push(`Performing better than model predicts (${node.accuracy}% accuracy).`);
    }

    // Learned params insight
    if (node.hasLearnedParams) {
        parts.push('EM-calibrated.');
    }

    return parts.join(' ');
}


// ─── Main Diagnosis Function ────────────────────────────────────────────────

/**
 * diagnosePrerequisites — The main entry point.
 * 
 * Given a target concept and a user, performs deep recursive analysis of the
 * entire prerequisite chain and returns a rich diagnosis with:
 *   - Per-node readiness scores and classifications
 *   - Root cause identification
 *   - Impact analysis (what each gap blocks)
 *   - Optimal study path
 *   - Summary statistics
 * 
 * Algorithm overview:
 *   1. BFS to discover the full prerequisite DAG from the target
 *   2. Batch-fetch mastery + attempt history for all nodes
 *   3. For each node: compute decayed mastery, confidence, recency, accuracy, readiness
 *   4. Classify each node (root_cause, critical, weak, stale, ok)
 *   5. Compute impact scores (downstream blocking analysis)
 *   6. Generate optimal study path via priority-weighted topological sort
 *   7. Compute summary statistics and return
 * 
 * @param {object} db - PostgreSQL client
 * @param {number} userId - The student's user ID
 * @param {string} conceptId - The target concept to diagnose
 * @returns {object} Full diagnosis result
 */
export async function diagnosePrerequisites(db, userId, conceptId) {
    // ── Step 1: Build the full prerequisite DAG via BFS ──
    const prereqOf  = {};   // concept_id -> [prereq_ids]
    const dependsOn = {};   // prereq_id  -> [concepts that need it]
    const allIds = new Set();
    const queue = [conceptId];
    allIds.add(conceptId);

    while (queue.length > 0) {
        const batch = [...queue];
        queue.length = 0;
        const prereqRes = await db.query(
            'SELECT concept_id, prereq_id FROM concept_prerequisites WHERE concept_id = ANY($1)',
            [batch]
        );
        for (const row of prereqRes.rows) {
            if (!prereqOf[row.concept_id]) prereqOf[row.concept_id] = [];
            prereqOf[row.concept_id].push(row.prereq_id);
            if (!dependsOn[row.prereq_id]) dependsOn[row.prereq_id] = [];
            dependsOn[row.prereq_id].push(row.concept_id);
            if (!allIds.has(row.prereq_id)) {
                allIds.add(row.prereq_id);
                queue.push(row.prereq_id);
            }
        }
    }

    const allIdArr = [...allIds];

    // ── Step 2: Batch-fetch all data we need ──
    const [masteryRes, conceptRes, recentAttemptsRes, learnedParamsRes] = await Promise.all([
        db.query(
            `SELECT concept_id, mastery, questions_answered, correct_answers, last_updated
             FROM user_concept_mastery WHERE user_id = $1 AND concept_id = ANY($2)`,
            [userId, allIdArr]
        ),
        db.query(
            'SELECT id, name, subject, chapter_id FROM concepts WHERE id = ANY($1)',
            [allIdArr]
        ),
        // Fetch recent attempt stats per concept: last 20 attempts for accuracy trend
        db.query(
            `SELECT concept_id, correct, time_taken_seconds, attempted_at
             FROM (
                 SELECT q.concept_id, uqa.correct, uqa.time_taken_seconds, uqa.attempted_at,
                        ROW_NUMBER() OVER (PARTITION BY q.concept_id ORDER BY uqa.attempted_at DESC) as rn
                 FROM user_question_attempts uqa
                 JOIN questions q ON q.id = uqa.question_id
                 WHERE uqa.user_id = $1 AND q.concept_id = ANY($2)
             ) sub WHERE rn <= 20`,
            [userId, allIdArr]
        ),
        // Fetch EM-learned BKT params for all concepts in the chain
        db.query(
            `SELECT concept_id, difficulty_tier, p_init, p_learn, p_guess, p_slip,
                    source, sample_size
             FROM concept_bkt_params
             WHERE concept_id = ANY($1) AND is_active = true`,
            [allIdArr]
        ).catch(() => ({ rows: [] })) // Graceful fallback if table doesn't exist yet
    ]);

    // Build lookup maps
    const masteryMap = {};
    masteryRes.rows.forEach(r => {
        masteryMap[r.concept_id] = {
            mastery: parseFloat(r.mastery),
            qa: r.questions_answered,
            ca: r.correct_answers,
            lastUpdated: r.last_updated
        };
    });

    const nameMap = {};
    conceptRes.rows.forEach(r => {
        nameMap[r.id] = { name: r.name, subject: r.subject, chapter_id: r.chapter_id };
    });

    // Build recent attempts map: concept_id -> [{correct, time, date}]
    const attemptsMap = {};
    recentAttemptsRes.rows.forEach(r => {
        if (!attemptsMap[r.concept_id]) attemptsMap[r.concept_id] = [];
        attemptsMap[r.concept_id].push({
            correct: r.correct,
            time: r.time_taken_seconds,
            date: r.attempted_at
        });
    });

    // Build learned BKT params map: concept_id -> { p_learn, p_guess, p_slip, p_init, hasLearned }
    // Averages across tiers for concept-level params, keeps tier-specific for guess/slip
    const learnedParamsMap = {};
    learnedParamsRes.rows.forEach(r => {
        if (!learnedParamsMap[r.concept_id]) {
            learnedParamsMap[r.concept_id] = {
                p_init: parseFloat(r.p_init),
                p_learn: parseFloat(r.p_learn),
                p_guess_avg: 0, p_slip_avg: 0,
                tierCount: 0,
                sampleSize: r.sample_size,
                hasLearned: true
            };
        }
        const lp = learnedParamsMap[r.concept_id];
        lp.p_guess_avg += parseFloat(r.p_guess);
        lp.p_slip_avg += parseFloat(r.p_slip);
        lp.tierCount++;
    });
    // Finalize averages
    for (const lp of Object.values(learnedParamsMap)) {
        if (lp.tierCount > 0) {
            lp.p_guess_avg /= lp.tierCount;
            lp.p_slip_avg /= lp.tierCount;
        }
    }

    // ── Step 3: Compute depth from target (BFS) ──
    const depth = {};
    depth[conceptId] = 0;
    const depthQueue = [conceptId];
    while (depthQueue.length > 0) {
        const cid = depthQueue.shift();
        for (const pid of (prereqOf[cid] || [])) {
            if (depth[pid] === undefined) {
                depth[pid] = depth[cid] + 1;
                depthQueue.push(pid);
            }
        }
    }

    // ── Step 4: Analyze each node ──
    const nodeMap = new Map();
    const nodes = allIdArr
        .filter(id => id !== conceptId)
        .map(id => {
            const m = masteryMap[id];
            const rawMastery = m?.mastery ?? 0.2;
            const qa = m?.qa ?? 0;
            const ca = m?.ca ?? 0;
            const lastUpdated = m?.lastUpdated ?? null;
            const info = nameMap[id] || { name: id, subject: '', chapter_id: null };
            const attempts = attemptsMap[id] || [];

            // Compute all signals
            const decayedMastery = lastUpdated ? decayMastery(rawMastery, lastUpdated) : rawMastery;
            const confidence = computeConfidence(qa, ca, decayedMastery);
            const recency = computeRecency(lastUpdated);
            const accuracy = qa > 0 ? ca / qa : 0;
            
            // Divergence analysis: does BKT agree with raw performance?
            const { calibration, divergenceType, divergenceMagnitude } = analyzeDivergence(decayedMastery, qa, ca);
            
            const readiness = computeReadiness(decayedMastery, confidence, recency, accuracy, calibration);

            // Learned BKT params for this concept (if EM has fitted them)
            const learnedParams = learnedParamsMap[id] || null;

            // Days since last practice
            const daysSinceLastPractice = lastUpdated
                ? Math.round((Date.now() - new Date(lastUpdated).getTime()) / 86400000)
                : null;

            // Recent accuracy trend (last 10 vs previous 10)
            let recentTrend = null;
            if (attempts.length >= 6) {
                const half = Math.floor(attempts.length / 2);
                const recentHalf = attempts.slice(0, half);
                const olderHalf = attempts.slice(half);
                const recentAcc = recentHalf.filter(a => a.correct).length / recentHalf.length;
                const olderAcc = olderHalf.filter(a => a.correct).length / olderHalf.length;
                recentTrend = Math.round((recentAcc - olderAcc) * 100); // positive = improving
            }

            const node = {
                id,
                name: info.name,
                subject: info.subject,
                chapter_id: info.chapter_id,
                depth: depth[id] || 0,
                // Raw data
                rawMastery,
                questionsAnswered: qa,
                correctAnswers: ca,
                lastUpdated,
                daysSinceLastPractice,
                // Computed signals
                decayedMastery,
                masteryPct: Math.round(decayedMastery * 100),
                confidence: Math.round(confidence * 100) / 100,
                recency: Math.round(recency * 100) / 100,
                accuracy: qa > 0 ? Math.round((ca / qa) * 100) : null,
                readiness: Math.round(readiness * 100) / 100,
                recentTrend,
                // Divergence analysis
                calibration: Math.round(calibration * 100) / 100,
                divergenceType,
                divergenceMagnitude,
                // Learned BKT params
                learnedParams,
                hasLearnedParams: !!learnedParams,
                // Will be filled in next steps
                severity: null,
                blocksCount: 0,
                impactScore: 0
            };

            nodeMap.set(id, node);
            return node;
        });

    // ── Step 5: Classify each node ──
    for (const node of nodes) {
        const ownPrereqs = prereqOf[node.id] || [];
        const hasUnmasteredPrereq = ownPrereqs.some(pid => {
            const pNode = nodeMap.get(pid);
            return pNode ? pNode.decayedMastery < MASTERY_THRESHOLD : true;
        });
        node.severity = classifyNode(node, hasUnmasteredPrereq);
    }

    // ── Step 6: Compute impact scores ──
    for (const node of nodes) {
        const { blocksCount, impactScore } = computeImpactScore(
            node.id, dependsOn, nodeMap, conceptId
        );
        node.blocksCount = blocksCount;
        node.impactScore = impactScore;
    }

    // ── Step 7: Sort nodes by severity, then impact, then depth ──
    const sevOrder = { root_cause: 0, critical: 1, stale: 2, weak: 3, ok: 4 };
    nodes.sort((a, b) => {
        if (sevOrder[a.severity] !== sevOrder[b.severity]) {
            return sevOrder[a.severity] - sevOrder[b.severity];
        }
        if (a.impactScore !== b.impactScore) return b.impactScore - a.impactScore;
        if (a.depth !== b.depth) return b.depth - a.depth;
        return a.readiness - b.readiness;
    });

    // ── Step 8: Generate optimal study path ──
    const studyPath = computeStudyPath(nodes, prereqOf, dependsOn, conceptId);

    // ── Step 9: Target concept analysis ──
    const targetM = masteryMap[conceptId];
    const targetRaw = targetM?.mastery ?? 0.2;
    const targetDecayed = targetM?.lastUpdated ? decayMastery(targetRaw, targetM.lastUpdated) : targetRaw;
    const targetInfo = nameMap[conceptId] || { name: conceptId };

    // ── Step 10: Summary statistics ──
    const rootCauses = nodes.filter(n => n.severity === 'root_cause');
    const critical   = nodes.filter(n => n.severity === 'critical');
    const stale      = nodes.filter(n => n.severity === 'stale');
    const weak       = nodes.filter(n => n.severity === 'weak');
    const mastered   = nodes.filter(n => n.severity === 'ok');

    // Overall "readiness to learn target" score
    // Based on: what fraction of prereqs are ready, weighted by their impact
    let totalWeight = 0;
    let weightedReadiness = 0;
    for (const node of nodes) {
        const weight = 1 + node.impactScore;
        totalWeight += weight;
        weightedReadiness += node.readiness * weight;
    }
    const overallReadiness = totalWeight > 0
        ? Math.round((weightedReadiness / totalWeight) * 100)
        : 100; // No prereqs = fully ready

    // Estimated study effort: uses learned p_learn when available for accuracy
    const estimatedEffort = studyPath.reduce((sum, step) => {
        const node = nodeMap.get(step.id);
        if (!node) return sum;
        return sum + estimateQuestionsNeeded(node.decayedMastery, node.learnedParams);
    }, 0);

    // Collect divergence insights (concepts where model disagrees with performance)
    const divergenceInsights = nodes
        .filter(n => n.divergenceType && n.divergenceType !== 'calibrated' && n.questionsAnswered >= 5)
        .map(n => ({
            id: n.id,
            name: n.name,
            type: n.divergenceType,
            magnitude: n.divergenceMagnitude,
            mastery: n.masteryPct,
            accuracy: n.accuracy,
            questionsAnswered: n.questionsAnswered
        }))
        .sort((a, b) => b.magnitude - a.magnitude)
        .slice(0, 5); // Top 5 most divergent

    return {
        target: {
            id: conceptId,
            name: targetInfo.name,
            mastery: Math.round(targetDecayed * 100),
            rawMastery: Math.round(targetRaw * 100)
        },
        overallReadiness,
        estimatedEffort,
        totalPrereqs: nodes.length,
        summary: {
            rootCauses: rootCauses.length,
            critical: critical.length,
            stale: stale.length,
            weak: weak.length,
            mastered: mastered.length
        },
        rootCauses: rootCauses.map(formatNode),
        critical: critical.map(formatNode),
        stale: stale.map(formatNode),
        weak: weak.map(formatNode),
        mastered: mastered.map(formatNode),
        suggestedPath: studyPath,
        divergenceInsights,
        learnedParamsAvailable: Object.keys(learnedParamsMap).length
    };
}


/**
 * Format a node for the API response.
 * Strips internal fields, keeps what the frontend needs.
 */
function formatNode(node) {
    return {
        id: node.id,
        name: node.name,
        subject: node.subject,
        chapter_id: node.chapter_id,
        mastery: node.masteryPct,
        rawMastery: Math.round(node.rawMastery * 100),
        questionsAnswered: node.questionsAnswered,
        accuracy: node.accuracy,
        confidence: Math.round(node.confidence * 100),
        recency: Math.round(node.recency * 100),
        readiness: Math.round(node.readiness * 100),
        calibration: Math.round(node.calibration * 100),
        divergenceType: node.divergenceType,
        divergenceMagnitude: node.divergenceMagnitude,
        depth: node.depth,
        severity: node.severity,
        blocksCount: node.blocksCount,
        impactScore: node.impactScore,
        daysSinceLastPractice: node.daysSinceLastPractice,
        recentTrend: node.recentTrend,
        hasLearnedParams: node.hasLearnedParams
    };
}
