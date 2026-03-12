/**
 * AI concept classification service for JEE questions.
 * Uses Gemini AI to classify questions into one of the 81 knowledge-graph concepts.
 */

/**
 * Classify a question into a concept from the knowledge graph using AI.
 *
 * @param {string} questionText - The question text to classify
 * @param {string|null} topicHint - Optional topic hint to improve classification
 * @param {Array<{id: number, name: string}>} conceptList - List of all concepts (id + name)
 * @param {Function} geminiGenerateFn - The geminiGenerate function from app.js
 * @returns {Promise<{concept_id: number, confidence: number}>} Classification result
 * @throws {Error} On AI failure, timeout, or invalid response
 */
export async function classifyQuestionConcept(questionText, topicHint, conceptList, geminiGenerateFn) {
    const conceptListStr = conceptList.map(c => `${c.id}: ${c.name}`).join('\n');

    const systemPrompt = `You are a JEE Physics/Mathematics question classifier.
Given a question, classify it into exactly one concept from the list below.
Return ONLY a JSON object with no extra text: {"concept_id": <number>, "confidence": <number between 0.0 and 1.0>}

Concepts:
${conceptListStr}`;

    const userPrompt = topicHint
        ? `Question: ${questionText}\nTopic hint: ${topicHint}`
        : `Question: ${questionText}`;

    // Race the AI call against a 10-second timeout
    const timeoutPromise = new Promise((_, reject) =>
        setTimeout(() => reject(new Error('AI classification timed out after 10 seconds')), 10000)
    );

    const aiPromise = geminiGenerateFn(systemPrompt, userPrompt);

    const rawResponse = await Promise.race([aiPromise, timeoutPromise]);

    // Strip markdown code fences if present, then parse JSON
    const cleaned = rawResponse.replace(/```json\n?|\n?```/g, '').trim();
    const parsed = JSON.parse(cleaned);

    if (typeof parsed.concept_id === 'undefined' || typeof parsed.confidence === 'undefined') {
        throw new Error('AI response missing concept_id or confidence');
    }

    return {
        concept_id: Number(parsed.concept_id),
        confidence: Number(parsed.confidence)
    };
}
