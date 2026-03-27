import db from '../config/db.js';

export async function getUserConceptMastery(userId, conceptId) {
    const r = await db.query(
        'SELECT mastery, questions_answered, correct_answers FROM user_concept_mastery WHERE user_id=$1 AND concept_id=$2',
        [userId, conceptId]
    );
    return r.rows[0] ?? { mastery: 0.2, questions_answered: 0, correct_answers: 0 };
}

export function masteryToTier(mastery) {
    if (mastery < 0.4) return 1;
    if (mastery < 0.7) return 2;
    return 3;
}

export function applyDecay(mastery, lastUpdated) {
    if (!lastUpdated) return mastery;
    const now = new Date();
    const last = new Date(lastUpdated);
    const daysSince = (now - last) / (1000 * 60 * 60 * 24);
    if (daysSince < 1) return mastery;
    const lambda = 0.05;
    const decayed = mastery * Math.exp(-lambda * daysSince);
    return Math.max(0.1, decayed);
}

export function processMathContent(content) {
    let processedContent = content;
    processedContent = processedContent.replace(/\$\$(.*?)\$\$/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\\\\(.*?)\\\\/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\/\/(.*?)\/\//g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\\\((.*?)\\\)/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    processedContent = processedContent.replace(/\\\[(.*?)\\\]/g, (match, equation) => {
        return `<span class="math-equation">${equation.trim()}</span>`;
    });
    return processedContent;
}
