#!/usr/bin/env node
/**
 * seed_jee_questions.js
 * 
 * Generates ~21 JEE Mains MCQs per NTA subconcept using Gemini AI.
 * Distribution: 7 easy (tier 1), 7 medium (tier 2), 7 hard (tier 3)
 * 
 * Usage:
 *   node scripts/seed_jee_questions.js                  # seed all concepts
 *   node scripts/seed_jee_questions.js --subject Math    # seed only Mathematics
 *   node scripts/seed_jee_questions.js --concept m_sets_representation  # seed one concept
 *   node scripts/seed_jee_questions.js --dry-run         # preview without inserting
 *   node scripts/seed_jee_questions.js --batch-size 3    # questions per Gemini call (default 7)
 * 
 * Resumable: skips concepts that already have ≥21 approved questions.
 */

import dotenv from 'dotenv';
import pg from 'pg';
import { GoogleGenerativeAI } from '@google/generative-ai';

dotenv.config();

// ── Config ──────────────────────────────────────────────────
const QUESTIONS_PER_TIER = 7;
const TIERS = [
  { tier: 1, label: 'Easy', desc: 'straightforward single-concept recall or one-step computation' },
  { tier: 2, label: 'Medium', desc: 'requires 2-3 steps, combining sub-ideas within the concept' },
  { tier: 3, label: 'Hard', desc: 'JEE Mains competition-level, multi-step reasoning, tricky distractors' },
];
const BATCH_SIZE = parseInt(process.argv.find((_, i, a) => a[i - 1] === '--batch-size') || '7', 10);
const DRY_RUN = process.argv.includes('--dry-run');
const SUBJECT_FILTER = process.argv.find((_, i, a) => a[i - 1] === '--subject') || null;
const CONCEPT_FILTER = process.argv.find((_, i, a) => a[i - 1] === '--concept') || null;
const RETRY_LIMIT = 3;
const DELAY_MS = 1500; // delay between Gemini calls to respect rate limits

// ── DB + Gemini setup ───────────────────────────────────────
const db = new pg.Client({
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  password: process.env.db_password,
  database: 'Content Storage',
});

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function geminiGenerate(systemPrompt, userPrompt) {
  const model = genAI.getGenerativeModel({
    model: 'gemini-2.5-flash',
    systemInstruction: systemPrompt,
  });
  const result = await model.generateContent(userPrompt);
  return result.response.text();
}


// ── Prompt builder ──────────────────────────────────────────
function buildPrompt(concept, tier, count) {
  const { id, name, subject, chapter_id } = concept;
  const { label, desc } = tier;

  return {
    system: `You are an expert JEE Mains question paper setter. Generate exactly ${count} multiple-choice questions as a JSON array.

RULES:
- Each question must be a JSON object with keys: question, option1, option2, option3, option4, answer, solution
- "answer" must be one of "option1", "option2", "option3", "option4"
- "solution" is a concise step-by-step explanation (2-4 sentences)
- Use LaTeX math notation with $...$ for all mathematical expressions
- All 4 options must be plausible; exactly one correct
- Questions must be original, not copied from any source
- Difficulty: ${label} — ${desc}
- Subject: ${subject}
- Return ONLY a JSON array, no markdown fences, no extra text`,

    user: `Generate ${count} ${label} (${desc}) JEE Mains MCQs.

Subject: ${subject}
Chapter: ${chapter_id.replace(/_/g, ' ')}
Subconcept: ${name} (ID: ${id})

These questions should test a student's understanding of "${name}" at the ${label} level for JEE Mains examination. Ensure variety — don't repeat the same pattern across questions.`
  };
}

// ── Parse Gemini response ───────────────────────────────────
function parseQuestions(raw) {
  let text = raw.trim();
  // Strip markdown code fences if present
  if (text.startsWith('```')) {
    text = text.replace(/^```(?:json)?\s*\n?/, '').replace(/\n?```\s*$/, '');
  }
  let parsed = JSON.parse(text);
  if (!Array.isArray(parsed)) parsed = [parsed];

  return parsed.map(q => {
    const lower = {};
    for (const [k, v] of Object.entries(q)) lower[k.toLowerCase()] = v;

    // Handle options array format
    if (!lower.option1 && Array.isArray(lower.options) && lower.options.length >= 4) {
      lower.option1 = lower.options[0];
      lower.option2 = lower.options[1];
      lower.option3 = lower.options[2];
      lower.option4 = lower.options[3];
    }

    const normalized = {
      question: String(lower.question || '').trim(),
      option1: String(lower.option1 || '').trim(),
      option2: String(lower.option2 || '').trim(),
      option3: String(lower.option3 || '').trim(),
      option4: String(lower.option4 || '').trim(),
      answer: String(lower.answer || lower.correct || '').trim(),
      solution: String(lower.solution || lower.explanation || '').trim(),
    };

    // Map text answer to option key
    if (!/^option[1-4]$/.test(normalized.answer)) {
      const ansText = normalized.answer.toLowerCase().trim();
      const matchIdx = [1, 2, 3, 4].find(
        i => normalized[`option${i}`].toLowerCase().trim() === ansText
      );
      normalized.answer = matchIdx ? `option${matchIdx}` : 'option1';
    }

    // Validate completeness
    if (!normalized.question || !normalized.option1 || !normalized.option2 ||
        !normalized.option3 || !normalized.option4) {
      return null;
    }
    return normalized;
  }).filter(Boolean);
}


// ── Generate questions for one concept + tier ───────────────
async function generateForTier(concept, tier, needed) {
  const questions = [];
  let remaining = needed;

  while (remaining > 0) {
    const batchCount = Math.min(remaining, BATCH_SIZE);
    const { system, user } = buildPrompt(concept, tier, batchCount);

    let attempt = 0;
    let batch = [];
    while (attempt < RETRY_LIMIT && batch.length === 0) {
      attempt++;
      try {
        const raw = await geminiGenerate(system, user);
        batch = parseQuestions(raw);
        if (batch.length === 0) {
          console.warn(`    ⚠ Empty parse on attempt ${attempt}, retrying...`);
        }
      } catch (err) {
        console.warn(`    ⚠ Attempt ${attempt} failed: ${err.message}`);
        if (attempt < RETRY_LIMIT) await sleep(DELAY_MS * 2);
      }
    }

    if (batch.length === 0) {
      console.error(`    ✗ Failed to generate after ${RETRY_LIMIT} attempts`);
      break;
    }

    questions.push(...batch.slice(0, remaining));
    remaining -= batch.length;
    if (remaining > 0) await sleep(DELAY_MS);
  }

  return questions;
}

// ── Insert questions into DB ────────────────────────────────
async function insertQuestions(conceptId, tierNum, questions) {
  let inserted = 0;
  for (const q of questions) {
    try {
      await db.query(
        `INSERT INTO questions 
         (question_text, option1, option2, option3, option4, correct_answer, solution_text, 
          concept_id, difficulty_tier, source, status)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)`,
        [
          q.question, q.option1, q.option2, q.option3, q.option4,
          q.answer, q.solution,
          conceptId, tierNum, 'AI Generated - JEE Mains', 'approved'
        ]
      );
      inserted++;
    } catch (err) {
      console.warn(`    ⚠ Insert failed: ${err.message.slice(0, 80)}`);
    }
  }
  return inserted;
}

// ── Helpers ─────────────────────────────────────────────────
const sleep = ms => new Promise(r => setTimeout(r, ms));

function formatDuration(ms) {
  const s = Math.floor(ms / 1000);
  const m = Math.floor(s / 60);
  return m > 0 ? `${m}m ${s % 60}s` : `${s}s`;
}


// ── Main ────────────────────────────────────────────────────
async function main() {
  await db.connect();
  console.log('🔌 Connected to database\n');

  // Fetch all concepts
  let conceptQuery = 'SELECT id, name, subject, chapter_id FROM concepts ORDER BY subject, chapter_id, id';
  const params = [];

  if (CONCEPT_FILTER) {
    conceptQuery = 'SELECT id, name, subject, chapter_id FROM concepts WHERE id = $1';
    params.push(CONCEPT_FILTER);
  } else if (SUBJECT_FILTER) {
    conceptQuery = 'SELECT id, name, subject, chapter_id FROM concepts WHERE subject ILIKE $1 ORDER BY chapter_id, id';
    params.push(`%${SUBJECT_FILTER}%`);
  }

  const { rows: concepts } = await db.query(conceptQuery, params);
  console.log(`📚 Found ${concepts.length} concepts to process\n`);

  if (concepts.length === 0) {
    console.log('No concepts found. Check your filter or run migrations first.');
    await db.end();
    return;
  }

  let totalInserted = 0;
  let conceptsProcessed = 0;
  let conceptsSkipped = 0;
  const startTime = Date.now();

  for (let ci = 0; ci < concepts.length; ci++) {
    const concept = concepts[ci];
    const progress = `[${ci + 1}/${concepts.length}]`;

    // Check existing question count per tier
    const { rows: existing } = await db.query(
      `SELECT difficulty_tier, COUNT(*)::int as cnt 
       FROM questions WHERE concept_id = $1 AND status = 'approved'
       GROUP BY difficulty_tier`,
      [concept.id]
    );
    const existingByTier = {};
    let totalExisting = 0;
    for (const row of existing) {
      existingByTier[row.difficulty_tier] = row.cnt;
      totalExisting += row.cnt;
    }

    if (totalExisting >= QUESTIONS_PER_TIER * 3) {
      console.log(`${progress} ⏭  ${concept.id} — already has ${totalExisting} questions, skipping`);
      conceptsSkipped++;
      continue;
    }

    console.log(`${progress} 🎯 ${concept.id} (${concept.name.slice(0, 60)})`);
    console.log(`     Subject: ${concept.subject} | Chapter: ${concept.chapter_id}`);
    if (totalExisting > 0) console.log(`     Existing: ${totalExisting} questions`);

    let conceptInserted = 0;

    for (const tierDef of TIERS) {
      const existCount = existingByTier[tierDef.tier] || 0;
      const needed = QUESTIONS_PER_TIER - existCount;

      if (needed <= 0) {
        console.log(`     Tier ${tierDef.tier} (${tierDef.label}): ✓ already has ${existCount}`);
        continue;
      }

      console.log(`     Tier ${tierDef.tier} (${tierDef.label}): generating ${needed}...`);

      const questions = await generateForTier(concept, tierDef, needed);

      if (DRY_RUN) {
        console.log(`     [DRY RUN] Would insert ${questions.length} questions`);
        if (questions.length > 0) {
          console.log(`       Sample: "${questions[0].question.slice(0, 80)}..."`);
        }
      } else {
        const inserted = await insertQuestions(concept.id, tierDef.tier, questions);
        conceptInserted += inserted;
        console.log(`     ✓ Inserted ${inserted}/${needed}`);
      }

      await sleep(DELAY_MS);
    }

    totalInserted += conceptInserted;
    conceptsProcessed++;

    // Progress summary every 10 concepts
    if (conceptsProcessed % 10 === 0) {
      const elapsed = Date.now() - startTime;
      const rate = conceptsProcessed / (elapsed / 60000);
      const remaining = (concepts.length - ci - 1) / rate;
      console.log(`\n  📊 Progress: ${conceptsProcessed} done, ${totalInserted} questions inserted`);
      console.log(`     Rate: ${rate.toFixed(1)} concepts/min | ETA: ~${Math.ceil(remaining)} min\n`);
    }
  }

  const elapsed = Date.now() - startTime;
  console.log('\n════════════════════════════════════════');
  console.log(`✅ Done in ${formatDuration(elapsed)}`);
  console.log(`   Concepts processed: ${conceptsProcessed}`);
  console.log(`   Concepts skipped (already seeded): ${conceptsSkipped}`);
  console.log(`   Total questions inserted: ${totalInserted}`);
  console.log('════════════════════════════════════════');

  await db.end();
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
