import express from 'express';
import db from '../config/db.js';
import { ensureAuthenticated } from '../middleware/auth.js';
import { getUserConceptMastery } from '../helpers/mastery.js';
import { bktUpdateConcept } from '../services/bktClient.js';

const router = express.Router();

// ============================================================
// JEE Mains Format Diagnostic Test — 90 MCQs, 3-hour timer
// 30 Physics + 30 Chemistry + 30 Mathematics
// +4 correct, −1 incorrect, 0 unattempted
// ============================================================

// --- Task 1.1: Question Selection Engine ---

const SUBJECT_CONFIGS = [
  { section: 'Physics',     filter: 'Physics',      seqOffset: 0  },
  { section: 'Chemistry',   filter: 'Chemistry%',   seqOffset: 30 },
  { section: 'Mathematics', filter: 'Mathematics',  seqOffset: 60 },
];

const TIER_TARGETS = [
  { tier: 1, count: 7  },
  { tier: 2, count: 13 },
  { tier: 3, count: 10 },
];

// Adjacent tiers for fallback when a tier has insufficient questions
const ADJACENT_TIERS = {
  1: [2],
  2: [1, 3],
  3: [2],
};

async function selectDiagnosticQuestions() {
  const allSelected = [];

  for (const { section, filter, seqOffset } of SUBJECT_CONFIGS) {
    const subjectQuestions = [];
    const usedConceptIds = [];

    for (const { tier, count } of TIER_TARGETS) {
      // Primary query: 1 question per subconcept using ROW_NUMBER window function
      const primary = await db.query(`
        SELECT * FROM (
          SELECT q.id, q.question_text, q.option1, q.option2, q.option3, q.option4,
                 q.correct_answer, q.solution_text, q.concept_id, q.difficulty_tier,
                 ROW_NUMBER() OVER (PARTITION BY q.concept_id ORDER BY RANDOM()) AS rn
          FROM questions q
          JOIN concepts c ON q.concept_id = c.id
          WHERE q.status = 'approved'
            AND q.difficulty_tier = $1
            AND c.subject LIKE $2
            AND q.concept_id NOT IN (SELECT UNNEST($3::text[]))
            AND q.question_text NOT LIKE '%Sample Q%'
            AND q.source != 'Seed'
        ) sub WHERE rn = 1
        ORDER BY RANDOM()
        LIMIT $4
      `, [tier, filter, usedConceptIds.length > 0 ? usedConceptIds : ['__none__'], count]);

      for (const row of primary.rows) {
        subjectQuestions.push(row);
        usedConceptIds.push(row.concept_id);
      }

      // Adjacent-tier fallback if we didn't get enough
      let deficit = count - primary.rows.length;
      if (deficit > 0) {
        const adjacentTiers = ADJACENT_TIERS[tier];
        for (const adjTier of adjacentTiers) {
          if (deficit <= 0) break;
          const fallback = await db.query(`
            SELECT * FROM (
              SELECT q.id, q.question_text, q.option1, q.option2, q.option3, q.option4,
                     q.correct_answer, q.solution_text, q.concept_id, q.difficulty_tier,
                     ROW_NUMBER() OVER (PARTITION BY q.concept_id ORDER BY RANDOM()) AS rn
              FROM questions q
              JOIN concepts c ON q.concept_id = c.id
              WHERE q.status = 'approved'
                AND q.difficulty_tier = $1
                AND c.subject LIKE $2
                AND q.concept_id NOT IN (SELECT UNNEST($3::text[]))
                AND q.question_text NOT LIKE '%Sample Q%'
                AND q.source != 'Seed'
            ) sub WHERE rn = 1
            ORDER BY RANDOM()
            LIMIT $4
          `, [adjTier, filter, usedConceptIds.length > 0 ? usedConceptIds : ['__none__'], deficit]);

          for (const row of fallback.rows) {
            subjectQuestions.push(row);
            usedConceptIds.push(row.concept_id);
          }
          deficit -= fallback.rows.length;
        }
      }

      // If still short after adjacency fill, allow duplicate subconcepts
      if (deficit > 0) {
        const alreadySelectedIds = subjectQuestions.map(q => q.id);
        const dupFill = await db.query(`
          SELECT q.id, q.question_text, q.option1, q.option2, q.option3, q.option4,
                 q.correct_answer, q.solution_text, q.concept_id, q.difficulty_tier
          FROM questions q
          JOIN concepts c ON q.concept_id = c.id
          WHERE q.status = 'approved'
            AND c.subject LIKE $1
            AND q.id != ALL($2::int[])
            AND q.question_text NOT LIKE '%Sample Q%'
            AND q.source != 'Seed'
          ORDER BY RANDOM()
          LIMIT $3
        `, [filter, alreadySelectedIds.length > 0 ? alreadySelectedIds : [0], deficit]);

        for (const row of dupFill.rows) {
          subjectQuestions.push(row);
        }
      }
    }

    // Assign sequence numbers for this subject
    subjectQuestions.forEach((q, i) => {
      allSelected.push({
        id: q.id,
        question_text: q.question_text,
        option1: q.option1,
        option2: q.option2,
        option3: q.option3,
        option4: q.option4,
        correct_answer: q.correct_answer,
        solution_text: q.solution_text,
        concept_id: q.concept_id,
        difficulty_tier: q.difficulty_tier,
        seq: seqOffset + i + 1,
        section,
      });
    });
  }

  return allSelected;
}

// --- Task 1.5: Scoring Engine ---

function computeScore(questions, answers) {
  let total = 0, correct = 0, incorrect = 0, unattempted = 0;
  const sections = {
    Physics:     { score: 0, correct: 0, incorrect: 0, unattempted: 0 },
    Chemistry:   { score: 0, correct: 0, incorrect: 0, unattempted: 0 },
    Mathematics: { score: 0, correct: 0, incorrect: 0, unattempted: 0 },
  };

  for (const q of questions) {
    const studentAnswer = answers[String(q.seq)];
    const sec = sections[q.section];

    if (!studentAnswer) {
      unattempted++;
      sec.unattempted++;
    } else if (studentAnswer === q.correct_answer) {
      total += 4;
      correct++;
      sec.score += 4;
      sec.correct++;
    } else {
      total -= 1;
      incorrect++;
      sec.score -= 1;
      sec.incorrect++;
    }
  }

  return { total, correct, incorrect, unattempted, maxScore: 360, sections };
}

// --- Helper: sanitize questions for client (strip correct_answer, solution_text) ---

function sanitizeQuestions(questions) {
  return questions.map(q => ({
    seq: q.seq,
    section: q.section,
    id: q.id,
    question_text: q.question_text,
    option1: q.option1,
    option2: q.option2,
    option3: q.option3,
    option4: q.option4,
    difficulty_tier: q.difficulty_tier,
  }));
}

// --- Helper: auto-submit logic (shared by GET expiry check and POST submit) ---

async function performSubmission(req) {
  const userId = req.user.id;
  const diag = req.session.diagnostic;
  const { questions, answers } = diag;

  // Score
  const result = computeScore(questions, answers);

  // BKT update for each answered question (wrapped in try/catch)
  for (const q of questions) {
    const studentAnswer = answers[String(q.seq)];
    if (!studentAnswer) continue;

    const isCorrect = studentAnswer === q.correct_answer;

    try {
      const prev = await getUserConceptMastery(userId, q.concept_id);
      const updated = await bktUpdateConcept({
        userId,
        skillId: q.concept_id,
        correct: isCorrect,
        p_mastery: parseFloat(prev.mastery),
        difficulty_tier: q.difficulty_tier,
      });
      const newMastery = updated.posterior_mastery;
      const newQA = prev.questions_answered + 1;
      const newCA = prev.correct_answers + (isCorrect ? 1 : 0);

      await db.query(`
        INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
        VALUES ($1,$2,$3,$4,$5,CURRENT_TIMESTAMP)
        ON CONFLICT (user_id, concept_id) DO UPDATE
        SET mastery=$3, questions_answered=$4, correct_answers=$5, last_updated=CURRENT_TIMESTAMP`,
        [userId, q.concept_id, newMastery, newQA, newCA]
      );
    } catch (bktErr) {
      console.error('BKT update failed for concept', q.concept_id, bktErr.message);
    }
  }

  // Log answered questions to user_question_attempts
  for (const q of questions) {
    const studentAnswer = answers[String(q.seq)];
    if (!studentAnswer) continue;
    const isCorrect = studentAnswer === q.correct_answer;
    try {
      await db.query(
        'INSERT INTO user_question_attempts (user_id, question_id, correct, time_taken_seconds) VALUES ($1,$2,$3,$4)',
        [userId, q.id, isCorrect, null]
      );
    } catch (logErr) {
      console.error('Failed to log attempt for question', q.id, logErr.message);
    }
  }

  // Build diagData compatible with initializeRemainingConcepts
  const diagData = {
    answers: questions
      .filter(q => answers[String(q.seq)])
      .map(q => ({
        conceptId: q.concept_id,
        correct: answers[String(q.seq)] === q.correct_answer,
        difficultyTier: q.difficulty_tier,
      })),
    sampledConcepts: questions.map(q => ({
      conceptId: q.concept_id,
      subject: q.section, // initializeRemainingConcepts uses DB subject values via allConcepts query
    })),
  };

  // Initialize remaining concepts
  await initializeRemainingConcepts(userId, diagData);

  // Mark diagnostic completed
  await db.query('UPDATE users SET diagnostic_completed = true WHERE id = $1', [userId]);
  req.user.diagnostic_completed = true;

  // Store result in session
  req.session.diagnosticResult = {
    totalScore: result.total,
    maxScore: result.maxScore,
    correct: result.correct,
    incorrect: result.incorrect,
    unattempted: result.unattempted,
    sections: result.sections,
  };

  // Clean up diagnostic session
  delete req.session.diagnostic;

  return result;
}

// --- Task 1.2: GET /diagnostic ---

router.get('/diagnostic', ensureAuthenticated, async (req, res) => {
  try {
    if (req.user.diagnostic_completed) return res.redirect('/');

    if (req.session.diagnostic?.started) {
      const { startTimestamp, durationMs } = req.session.diagnostic;

      // Check time expiry — auto-submit if expired
      if (Date.now() - startTimestamp >= durationMs) {
        await performSubmission(req);
        return res.redirect('/diagnostic/results');
      }

      // Resume: render test UI with sanitized questions
      const sanitizedQuestions = sanitizeQuestions(req.session.diagnostic.questions);
      return res.render('diagnostic.ejs', {
        diagnostic: {
          started: true,
          startTimestamp,
          durationMs,
          answers: req.session.diagnostic.answers,
          markedForReview: req.session.diagnostic.markedForReview,
        },
        questions: sanitizedQuestions,
        user: req.user,
      });
    }

    // Not started — render welcome screen
    res.render('diagnostic.ejs', {
      diagnostic: { started: false },
      questions: [],
      user: req.user,
    });
  } catch (e) {
    console.error('GET /diagnostic error:', e);
    res.status(500).send('Failed to load diagnostic test');
  }
});

// --- Task 1.3: POST /diagnostic/start ---

router.post('/diagnostic/start', ensureAuthenticated, async (req, res) => {
  try {
    if (req.user.diagnostic_completed) return res.redirect('/');

    const questions = await selectDiagnosticQuestions();

    if (questions.length === 0) {
      return res.status(500).send('No questions available for the diagnostic test');
    }

    req.session.diagnostic = {
      started: true,
      startTimestamp: Date.now(),
      durationMs: 10800000, // 3 hours
      questions,
      answers: {},
      markedForReview: {},
    };

    return res.redirect('/diagnostic');
  } catch (e) {
    console.error('POST /diagnostic/start error:', e);
    res.status(500).send('Failed to start diagnostic test');
  }
});

// --- Task 1.4: POST /diagnostic/answer, /clear, /mark-review ---

router.post('/diagnostic/answer', ensureAuthenticated, (req, res) => {
  const diag = req.session.diagnostic;
  if (!diag?.started) return res.status(400).json({ ok: false, error: 'No test in progress' });

  const { seq, answer } = req.body;
  const seqNum = Number(seq);

  if (!Number.isInteger(seqNum) || seqNum < 1 || seqNum > 90) {
    return res.status(400).json({ ok: false, error: 'Invalid sequence number' });
  }
  if (!['option1', 'option2', 'option3', 'option4'].includes(answer)) {
    return res.status(400).json({ ok: false, error: 'Invalid answer option' });
  }

  diag.answers[String(seqNum)] = answer;
  return res.json({ ok: true });
});

router.post('/diagnostic/clear', ensureAuthenticated, (req, res) => {
  const diag = req.session.diagnostic;
  if (!diag?.started) return res.status(400).json({ ok: false, error: 'No test in progress' });

  const { seq } = req.body;
  const seqNum = Number(seq);

  if (!Number.isInteger(seqNum) || seqNum < 1 || seqNum > 90) {
    return res.status(400).json({ ok: false, error: 'Invalid sequence number' });
  }

  delete diag.answers[String(seqNum)];
  return res.json({ ok: true });
});

router.post('/diagnostic/mark-review', ensureAuthenticated, (req, res) => {
  const diag = req.session.diagnostic;
  if (!diag?.started) return res.status(400).json({ ok: false, error: 'No test in progress' });

  const { seq, marked } = req.body;
  const seqNum = Number(seq);

  if (!Number.isInteger(seqNum) || seqNum < 1 || seqNum > 90) {
    return res.status(400).json({ ok: false, error: 'Invalid sequence number' });
  }

  if (marked) {
    diag.markedForReview[String(seqNum)] = true;
  } else {
    delete diag.markedForReview[String(seqNum)];
  }
  return res.json({ ok: true });
});

// --- Task 1.5: POST /diagnostic/submit ---

router.post('/diagnostic/submit', ensureAuthenticated, async (req, res) => {
  try {
    const diag = req.session.diagnostic;
    if (!diag?.started) return res.status(400).json({ ok: false, error: 'No test in progress' });

    await performSubmission(req);
    return res.json({ ok: true, redirect: '/diagnostic/results' });
  } catch (e) {
    console.error('POST /diagnostic/submit error:', e);
    res.status(500).json({ ok: false, error: 'Failed to submit diagnostic test' });
  }
});

// --- Task 1.6: Preserved initializeRemainingConcepts (verbatim from original) ---

// Initialize mastery for concepts not directly tested in the diagnostic
async function initializeRemainingConcepts(userId, diag) {
    // ── Prerequisite-aware mastery inference ──
    // Uses 4 signals (strongest → weakest):
    //   1. Prerequisite graph: if you got a hard concept right, you likely know its prerequisites
    //   2. Reverse prereqs: if you got a prerequisite wrong, downstream concepts are likely weak too
    //   3. Same chapter performance (2 data points per chapter now)
    //   4. Same subject performance (fallback)
    
    const allConcepts = await db.query('SELECT id, subject, chapter_id FROM concepts');
    const prereqRes = await db.query('SELECT concept_id, prereq_id FROM concept_prerequisites');
    const testedConcepts = new Set(diag.answers.map(a => a.conceptId));
    
    // Build prerequisite graph (both directions)
    const prereqsOf = {};    // concept → [its prerequisites]
    const dependentsOf = {}; // concept → [concepts that depend on it]
    for (const row of prereqRes.rows) {
        if (!prereqsOf[row.concept_id]) prereqsOf[row.concept_id] = [];
        prereqsOf[row.concept_id].push(row.prereq_id);
        if (!dependentsOf[row.prereq_id]) dependentsOf[row.prereq_id] = [];
        dependentsOf[row.prereq_id].push(row.concept_id);
    }
    
    // Build tested concept mastery map from diagnostic answers
    const testedMastery = {};
    for (const answer of diag.answers) {
        // Use the actual BKT-computed mastery from the DB
        const mRow = await db.query(
            'SELECT mastery FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2',
            [userId, answer.conceptId]
        );
        testedMastery[answer.conceptId] = mRow.rows[0] ? parseFloat(mRow.rows[0].mastery) : 0.2;
    }
    
    // Build chapter and subject performance
    const chapterPerformance = {};
    const subjectPerformance = {};
    for (const answer of diag.answers) {
        const concept = diag.sampledConcepts.find(c => c.conceptId === answer.conceptId);
        if (!concept) continue;
        
        const cRow = allConcepts.rows.find(r => r.id === answer.conceptId);
        if (cRow && cRow.chapter_id) {
            if (!chapterPerformance[cRow.chapter_id]) chapterPerformance[cRow.chapter_id] = { correct: 0, total: 0 };
            chapterPerformance[cRow.chapter_id].correct += answer.correct ? 1 : 0;
            chapterPerformance[cRow.chapter_id].total += 1;
        }
        
        if (!subjectPerformance[concept.subject]) subjectPerformance[concept.subject] = { correct: 0, total: 0 };
        subjectPerformance[concept.subject].correct += answer.correct ? 1 : 0;
        subjectPerformance[concept.subject].total += 1;
    }
    
    // ── Traverse prerequisite graph to propagate mastery ──
    // Walk UP from tested concepts: if student got concept X right,
    // its prerequisites are likely known (with decay per hop)
    function getUpstreamInference(conceptId, visited = new Set(), depth = 0) {
        if (depth > 5 || visited.has(conceptId)) return null;
        visited.add(conceptId);
        
        // Check if this concept was directly tested
        if (testedMastery[conceptId] !== undefined) {
            return { mastery: testedMastery[conceptId], depth };
        }
        
        // Check if any dependent (downstream) concept was tested
        const dependents = dependentsOf[conceptId] || [];
        let bestSignal = null;
        for (const dep of dependents) {
            const signal = getUpstreamInference(dep, new Set(visited), depth + 1);
            if (signal && (!bestSignal || signal.mastery > bestSignal.mastery)) {
                bestSignal = signal;
            }
        }
        return bestSignal;
    }
    
    // Walk DOWN from tested concepts: if student got prerequisite X wrong,
    // downstream concepts are likely weak too (with decay per hop)
    function getDownstreamInference(conceptId, visited = new Set(), depth = 0) {
        if (depth > 5 || visited.has(conceptId)) return null;
        visited.add(conceptId);
        
        if (testedMastery[conceptId] !== undefined) {
            return { mastery: testedMastery[conceptId], depth };
        }
        
        const prereqs = prereqsOf[conceptId] || [];
        let bestSignal = null;
        for (const pre of prereqs) {
            const signal = getDownstreamInference(pre, new Set(visited), depth + 1);
            if (signal && (!bestSignal || signal.depth < bestSignal.depth)) {
                bestSignal = signal;
            }
        }
        return bestSignal;
    }
    
    const values = [];
    for (const concept of allConcepts.rows) {
        if (testedConcepts.has(concept.id)) continue;
        
        let inferredMastery = null;
        let source = 'default';
        
        // Signal 1: Upstream inference (student got a harder dependent concept right)
        // If you can do Integration by Parts, you likely know basic Integration
        const upstream = getUpstreamInference(concept.id);
        if (upstream) {
            // Decay factor: 0.85 per hop — prerequisites of tested concepts get high credit
            // e.g., depth=1 → 85% of tested mastery, depth=2 → 72%, depth=3 → 61%
            const decayFactor = Math.pow(0.85, upstream.depth);
            // Upstream means the tested concept DEPENDS on this one,
            // so if they got the dependent right, this prerequisite is likely strong
            // Cap at 0.6 — we don't want to over-credit from inference alone
            inferredMastery = Math.min(0.6, upstream.mastery * decayFactor);
            source = 'upstream';
        }
        
        // Signal 2: Downstream inference (student got a prerequisite wrong)
        // If you can't do basic Kinematics, Rotational Motion is likely weak
        const downstream = getDownstreamInference(concept.id);
        if (downstream) {
            const decayFactor = Math.pow(0.8, downstream.depth);
            // Downstream: the tested concept is a PREREQUISITE of this one
            // If prereq is weak, this concept is likely weaker
            // If prereq is strong, this concept might still be unknown
            const downstreamMastery = downstream.mastery < 0.5
                ? Math.min(0.3, downstream.mastery * decayFactor * 0.7) // weak prereq → very weak
                : Math.min(0.45, downstream.mastery * decayFactor * 0.6); // strong prereq → moderate
            
            // Take the lower of upstream and downstream (conservative)
            if (inferredMastery === null || downstreamMastery < inferredMastery) {
                inferredMastery = downstreamMastery;
                source = 'downstream';
            }
        }
        
        // Signal 3: Chapter-level performance (2 data points per chapter)
        if (inferredMastery === null && concept.chapter_id && chapterPerformance[concept.chapter_id]) {
            const cp = chapterPerformance[concept.chapter_id];
            const accuracy = cp.correct / cp.total;
            // With 2 questions per chapter: 2/2 → 0.50, 1/2 → 0.30, 0/2 → 0.15
            inferredMastery = 0.15 + accuracy * 0.35;
            source = 'chapter';
        }
        
        // Signal 4: Subject-level performance (weakest signal)
        if (inferredMastery === null && subjectPerformance[concept.subject]) {
            const sp = subjectPerformance[concept.subject];
            const accuracy = sp.correct / sp.total;
            inferredMastery = 0.15 + accuracy * 0.25;
            source = 'subject';
        }
        
        // Default: no signal at all
        if (inferredMastery === null) {
            inferredMastery = 0.2;
        }
        
        // Clamp to valid range
        inferredMastery = Math.max(0.1, Math.min(0.6, inferredMastery));
        
        values.push(`(${userId}, '${concept.id}', ${inferredMastery.toFixed(4)}, 0, 0, CURRENT_TIMESTAMP)`);
    }
    
    if (values.length > 0) {
        const chunkSize = 100;
        for (let i = 0; i < values.length; i += chunkSize) {
            const chunk = values.slice(i, i + chunkSize);
            await db.query(`
                INSERT INTO user_concept_mastery (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
                VALUES ${chunk.join(',')}
                ON CONFLICT (user_id, concept_id) DO NOTHING
            `);
        }
    }
}

// --- Task 1.7: GET /diagnostic/results and GET /diagnostic/skip ---

router.get('/diagnostic/results', ensureAuthenticated, async (req, res) => {
    const result = req.session.diagnosticResult;
    if (!result) return res.redirect('/');
    
    // Get the initialized mastery data for the summary
    const masteryRes = await db.query(
        'SELECT concept_id, mastery FROM user_concept_mastery WHERE user_id=$1 ORDER BY mastery DESC',
        [req.user.id]
    );
    
    const strong = masteryRes.rows.filter(r => parseFloat(r.mastery) >= 0.4).length;
    const developing = masteryRes.rows.filter(r => parseFloat(r.mastery) >= 0.25 && parseFloat(r.mastery) < 0.4).length;
    const needsWork = masteryRes.rows.filter(r => parseFloat(r.mastery) < 0.25).length;
    
    res.render('diagnostic-results.ejs', {
        result,
        summary: { strong, developing, needsWork, total: masteryRes.rows.length },
        user: req.user
    });
});

router.get('/diagnostic/skip', ensureAuthenticated, async (req, res) => {
    // Allow students to skip diagnostic (they'll start with default 0.2 mastery)
    await db.query('UPDATE users SET diagnostic_completed = true WHERE id = $1', [req.user.id]);
    req.user.diagnostic_completed = true;
    if (req.session.diagnostic) delete req.session.diagnostic;
    res.redirect('/');
});

export default router;
