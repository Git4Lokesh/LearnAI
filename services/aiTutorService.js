// AI Tutor Service — Gemini-powered hints, diagnosis, and chat
// All features grounded in student's BKT mastery data and prerequisite graph
import { geminiGenerate } from '../helpers/gemini.js';
import { getUserConceptMastery } from '../helpers/mastery.js';
import { checkPrerequisiteGaps } from './prerequisiteService.js';
import { diagnosePrerequisites } from './diagnosisEngine.js';
import db from '../config/db.js';

const MODEL = 'gemini-2.5-flash';

// ── Prompt Builders ──

function buildHintSystemPrompt() {
    return `You are a patient JEE tutor. The student is looking at a question and wants a hint to help them think through it.

Your job:
1. Give a conceptual nudge that helps them approach the problem — what formula, principle, or technique applies
2. Do NOT give the answer or work through the full solution
3. If they have weak prerequisites, mention which foundational concept they should review
4. Keep it to 2-3 short paragraphs max
5. Use $...$ for inline math, $$...$$ for display math
6. Sound like a helpful senior student, not a textbook`;
}

function buildHintUserPrompt(params) {
    const optionMap = { option1: 'A', option2: 'B', option3: 'C', option4: 'D' };

    let prereqSection = 'None — all prerequisites are strong.';
    if (params.weakPrereqs && params.weakPrereqs.length > 0) {
        prereqSection = params.weakPrereqs.map(p =>
            `- ${p.name} (${Math.round(p.mastery * 100)}% mastery)`
        ).join('\n');
    }

    // If selectedAnswer is provided, this is "advice" mode (wrong answer specific)
    if (params.selectedAnswer && params.correctAnswer && params.selectedAnswer !== params.correctAnswer) {
        const selectedLetter = optionMap[params.selectedAnswer] || '?';
        const correctLetter = optionMap[params.correctAnswer] || '?';
        return `**Question:** ${params.questionText}

**Options:**
A) ${params.option1}
B) ${params.option2}
C) ${params.option3}
D) ${params.option4}

**Student selected:** ${selectedLetter}) ${params[params.selectedAnswer]} (WRONG)
**Correct answer:** ${correctLetter}) ${params[params.correctAnswer]}

**Concept:** ${params.conceptName} (${params.masteryPct}% mastery)

**Weak prerequisites:**
${prereqSection}

Explain why their answer is wrong and guide them toward the correct reasoning. Be specific about the misconception.`;
    }

    // Hint mode — no wrong answer, just help with the question
    return `**Question:** ${params.questionText}

**Options:**
A) ${params.option1}
B) ${params.option2}
C) ${params.option3}
D) ${params.option4}

**Concept:** ${params.conceptName} (${params.masteryPct}% mastery)

**Weak prerequisites:**
${prereqSection}

Give a hint to help approach this problem. What concept or technique should they think about?`;
}

function buildDiagnosisSystemPrompt() {
    return `You are a concise, insightful JEE preparation advisor. Analyze the student's learning data and give actionable advice.

Rules:
1. Be CONCISE — no filler, no generic motivational fluff. Every sentence should contain useful information.
2. If all prerequisites are mastered, DON'T list them. Instead focus on:
   - What specific problem-solving strategies to try (e.g., "try drawing free body diagrams before writing equations")
   - Common JEE traps and misconceptions for this topic
   - Which types of problems to practice (numerical, conceptual, multi-step)
   - How this topic connects to other JEE topics they might see in the exam
3. If there ARE prerequisite gaps, be specific about the cause-and-effect: "You're weak at X, which means you can't do Y because Z"
4. Give concrete next steps, not vague advice
5. Use markdown formatting. Use $...$ for math. Keep it under 200 words.
6. Sound like a smart senior student helping a junior, not a textbook.`;
}

function buildDiagnosisUserPrompt(conceptName, masteryPct, diagnosis) {
    const gaps = diagnosis.gaps || [];
    const studyPath = diagnosis.studyPath || [];
    const questionsAnswered = diagnosis.questionsAnswered || 0;

    if (gaps.length === 0) {
        return `**Concept:** ${conceptName} (${masteryPct}% mastery, ${questionsAnswered} questions attempted)

All prerequisites are mastered. The student needs help improving on this specific topic.

Give insight on:
- Common mistakes JEE students make on this topic
- Specific problem-solving approaches that work
- What types of questions to focus on (easy conceptual vs hard numerical)
- How this topic typically appears in JEE Mains`;
    }

    const gapSection = gaps.slice(0, 8).map(g => {
        const emoji = g.severity === 'root_cause' ? '🔴' : g.severity === 'critical' ? '🟠' : g.severity === 'stale' ? '🔵' : '🟡';
        return `- ${emoji} ${g.name}: ${Math.round((g.mastery || 0) * 100)}%`;
    }).join('\n');

    const pathSection = studyPath.slice(0, 5).map((s, i) =>
        `${i + 1}. ${s.name} (${Math.round((s.mastery || 0) * 100)}%)`
    ).join('\n');

    return `**Concept:** ${conceptName} (${masteryPct}% mastery)

**Gaps:**
${gapSection}

**Study order:**
${pathSection}

Explain WHY these gaps matter for ${conceptName} and what to do about it.`;
}

function buildChatSystemPrompt(masteryProfile, recentAttempts, gaps) {
    // Group mastery by subject
    const bySubject = {};
    for (const m of masteryProfile) {
        const subj = m.subject || 'Other';
        if (!bySubject[subj]) bySubject[subj] = { weak: [], moderate: [], strong: [] };
        const pct = Math.round((parseFloat(m.mastery) || 0.2) * 100);
        const entry = `${m.name} (${pct}%)`;
        if (pct < 50) bySubject[subj].weak.push(entry);
        else if (pct < 80) bySubject[subj].moderate.push(entry);
        else bySubject[subj].strong.push(entry);
    }

    let profileSummary = '';
    for (const [subj, data] of Object.entries(bySubject)) {
        profileSummary += `\n**${subj}:**\n`;
        if (data.strong.length) profileSummary += `  Strong (≥80%): ${data.strong.slice(0, 10).join(', ')}${data.strong.length > 10 ? ` (+${data.strong.length - 10} more)` : ''}\n`;
        if (data.moderate.length) profileSummary += `  Moderate (50-80%): ${data.moderate.slice(0, 10).join(', ')}${data.moderate.length > 10 ? ` (+${data.moderate.length - 10} more)` : ''}\n`;
        if (data.weak.length) profileSummary += `  Weak (<50%): ${data.weak.slice(0, 10).join(', ')}${data.weak.length > 10 ? ` (+${data.weak.length - 10} more)` : ''}\n`;
    }

    let recentSection = 'No recent practice data.';
    if (recentAttempts.length > 0) {
        recentSection = recentAttempts.map(a =>
            `- ${a.concept_name}: ${a.correct ? '✓' : '✗'} (Tier ${a.difficulty_tier})`
        ).join('\n');
    }

    let gapSection = 'No significant prerequisite gaps.';
    if (gaps.length > 0) {
        gapSection = gaps.map(g => `- ${g.name} (${Math.round((g.mastery || 0) * 100)}%)`).slice(0, 15).join('\n');
    }

    return `You are an AI study tutor for a JEE Mains/Advanced preparation student on the Learn.ai platform. You have access to the student's complete learning profile.

Your capabilities:
- Answer conceptual questions about Physics, Chemistry, and Mathematics
- Recommend what to study next based on their mastery data
- Explain topics at the right level based on their current understanding
- Provide study strategies and exam tips

Rules:
1. Always ground your advice in the student's actual mastery data provided below
2. When recommending topics, reference their specific weak areas
3. Use LaTeX ($...$) for math notation
4. Use markdown for formatting (headers, bold, lists)
5. Be encouraging but honest about areas that need work
6. Keep responses focused and actionable
7. If asked about a topic, check their mastery on related concepts before explaining

**Student Mastery Profile:**
${profileSummary}

**Recent Practice (last 20 attempts):**
${recentSection}

**Current Prerequisite Gaps:**
${gapSection}`;
}

// ── Exported Functions ──

export async function generateHint({ userId, questionText, option1, option2, option3, option4, correctAnswer, selectedAnswer, conceptId, conceptName }) {
    try {
        // Fetch mastery and weak prereqs
        const mastery = await getUserConceptMastery(userId, conceptId);
        const masteryPct = Math.round(parseFloat(mastery.mastery) * 100);

        const gapsRes = await checkPrerequisiteGaps(db, userId, conceptId);
        const weakPrereqs = gapsRes.filter(g => parseFloat(g.mastery) < 0.7);

        const systemPrompt = buildHintSystemPrompt();
        const userPrompt = buildHintUserPrompt({
            questionText, option1, option2, option3, option4,
            correctAnswer, selectedAnswer, conceptName, masteryPct, weakPrereqs
        });

        const hint = await geminiGenerate(systemPrompt, userPrompt, MODEL);
        return { hint: hint || 'Could not generate a hint. Please review the solution text.' };
    } catch (err) {
        console.error('generateHint error:', err.message);
        return { hint: 'Hint temporarily unavailable. Please review the solution text below.' };
    }
}

export async function generateDiagnosis({ userId, conceptId }) {
    let rawDiagnosis = null;
    try {
        // Get full diagnosis from existing engine
        rawDiagnosis = await diagnosePrerequisites(db, userId, conceptId);

        // Get concept name and mastery
        const conceptRes = await db.query('SELECT name FROM concepts WHERE id=$1', [conceptId]);
        const conceptName = conceptRes.rows[0]?.name || conceptId;
        const mastery = await getUserConceptMastery(userId, conceptId);
        const masteryPct = Math.round(parseFloat(mastery.mastery) * 100);

        const systemPrompt = buildDiagnosisSystemPrompt();
        const userPrompt = buildDiagnosisUserPrompt(conceptName, masteryPct, {
            ...rawDiagnosis,
            questionsAnswered: parseInt(mastery.questions_answered) || 0
        });

        const explanation = await geminiGenerate(systemPrompt, userPrompt, MODEL);

        return {
            explanation: explanation || 'Could not generate diagnosis. See the study path below.',
            studyPath: rawDiagnosis.studyPath || [],
            rawDiagnosis
        };
    } catch (err) {
        console.error('generateDiagnosis error:', err.message);
        return {
            explanation: 'AI diagnosis temporarily unavailable. Here are your prerequisite gaps:',
            studyPath: rawDiagnosis?.studyPath || [],
            rawDiagnosis: rawDiagnosis || { gaps: [], studyPath: [] }
        };
    }
}

export async function generateChatResponse({ userId, message, conversationHistory = [], currentConcept = null, currentConceptId = null, currentQuestion = null }) {
    try {
        // Fetch full mastery profile
        const masteryRes = await db.query(`
            SELECT c.id, c.name, c.subject, COALESCE(ucm.mastery, 0.2) as mastery,
                   COALESCE(ucm.questions_answered, 0) as questions_answered
            FROM concepts c
            LEFT JOIN user_concept_mastery ucm ON ucm.concept_id = c.id AND ucm.user_id = $1
            ORDER BY c.subject, c.name
        `, [userId]);

        // Fetch recent 20 attempts
        const recentRes = await db.query(`
            SELECT c.name as concept_name, uqa.correct, q.difficulty_tier
            FROM user_question_attempts uqa
            JOIN questions q ON q.id = uqa.question_id
            JOIN concepts c ON c.id = q.concept_id
            WHERE uqa.user_id = $1
            ORDER BY uqa.attempted_at DESC
            LIMIT 20
        `, [userId]);

        // Fetch prerequisite gaps (concepts with mastery < 0.7 that block others)
        const gapsRes = await db.query(`
            SELECT DISTINCT c.name, COALESCE(ucm.mastery, 0.2) as mastery
            FROM concept_prerequisites cp
            JOIN concepts c ON c.id = cp.prereq_id
            LEFT JOIN user_concept_mastery ucm ON ucm.concept_id = cp.prereq_id AND ucm.user_id = $1
            WHERE COALESCE(ucm.mastery, 0.2) < 0.7
            ORDER BY COALESCE(ucm.mastery, 0.2) ASC
            LIMIT 20
        `, [userId]);

        const systemPrompt = buildChatSystemPrompt(masteryRes.rows, recentRes.rows, gapsRes.rows);

        // Build conversation context for Gemini
        let userPrompt = '';

        // Add current concept context if on practice page
        if (currentConcept && currentConceptId) {
            const conceptMastery = await getUserConceptMastery(userId, currentConceptId);
            const conceptPct = Math.round(parseFloat(conceptMastery.mastery) * 100);
            userPrompt += `[The student is currently practicing: ${currentConcept} (${conceptPct}% mastery, ${conceptMastery.questions_answered} questions answered)]\n`;
            if (currentQuestion) {
                userPrompt += `[Current question on screen:\n"${currentQuestion.text}"\nA) ${currentQuestion.option1}\nB) ${currentQuestion.option2}\nC) ${currentQuestion.option3}\nD) ${currentQuestion.option4}\nDifficulty: Tier ${currentQuestion.tier}]\n`;
            }
            userPrompt += '\n';
        }

        if (conversationHistory.length > 0) {
            userPrompt += 'Previous conversation:\n';
            for (const msg of conversationHistory.slice(-10)) { // last 10 messages for context window
                userPrompt += `${msg.role === 'user' ? 'Student' : 'Tutor'}: ${msg.content}\n\n`;
            }
            userPrompt += '---\n\n';
        }
        userPrompt += `Student: ${message}`;

        const response = await geminiGenerate(systemPrompt, userPrompt, MODEL);
        return { response: response || 'I\'m having trouble responding right now. Please try again.' };
    } catch (err) {
        console.error('generateChatResponse error:', err.message);
        return { response: 'I\'m having trouble connecting right now. Please try again in a moment.' };
    }
}
