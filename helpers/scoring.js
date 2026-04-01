/**
 * JEE-pattern scoring: +4 correct, −1 wrong, 0 unanswered.
 *
 * @param {Array} questions - Array of question objects, each with a `correct_answer` field
 *                            and a sequential key (e.g. `seq` or index-based).
 * @param {Object} answers  - Map of questionKey → selectedOption (e.g. { "1": "option2", "3": "option1" }).
 *                            Missing keys or null values are treated as unanswered.
 * @param {string} [keyField='seq'] - The field on each question used as the key into `answers`.
 * @returns {{ total: number, correct: number, incorrect: number, unanswered: number, maxScore: number }}
 */
export function computeJeeScore(questions, answers, keyField = 'seq') {
    let total = 0;
    let correct = 0;
    let incorrect = 0;
    let unanswered = 0;

    for (const q of questions) {
        const key = String(q[keyField]);
        const selected = answers[key];

        if (!selected) {
            unanswered++;
        } else if (selected === q.correct_answer) {
            total += 4;
            correct++;
        } else {
            total -= 1;
            incorrect++;
        }
    }

    return {
        total,
        correct,
        incorrect,
        unanswered,
        maxScore: questions.length * 4,
    };
}

/**
 * Compute assignment status for a student.
 *
 * @param {Date|string} deadline - Assignment deadline
 * @param {boolean} hasSubmission - Whether the student has submitted
 * @param {Date} [now=new Date()] - Current time (injectable for testing)
 * @returns {'Pending'|'Completed'|'Missed'}
 */
export function computeAssignmentStatus(deadline, hasSubmission, now = new Date()) {
    if (hasSubmission) return 'Completed';
    const dl = new Date(deadline);
    if (dl > now) return 'Pending';
    return 'Missed';
}
