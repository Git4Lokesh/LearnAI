/**
 * PDF Question Extraction Service
 * Takes a PDF buffer, extracts text via LlamaIndex Cloud, then uses Gemini
 * to structure the raw text into question objects ready for the question bank.
 */
import { extractTextFromPDF } from './pdfService.js';
import { geminiGenerate } from '../helpers/gemini.js';

/**
 * Extract structured questions from a PDF file.
 *
 * @param {Buffer} fileBuffer - PDF file contents
 * @param {string} filename - Original filename
 * @param {Object} options - Optional hints
 * @param {string} [options.subject] - Subject hint (e.g. "Physics")
 * @param {string} [options.source] - Source label (e.g. "Manthan Workbook Ch.3")
 * @returns {Promise<Array<Object>>} Array of question objects
 */
export async function extractQuestionsFromPDF(fileBuffer, filename, options = {}) {
    // Step 1: Extract raw text/markdown from PDF
    const rawText = await extractTextFromPDF(fileBuffer, filename);
    return extractQuestionsFromText_chunks(rawText, options);
}

/**
 * Extract questions from already-extracted text (skips LlamaParse).
 * Useful for testing or when you already have the text.
 */
export async function extractQuestionsFromRawText(rawText, options = {}) {
    return extractQuestionsFromText_chunks(rawText, options);
}

async function extractQuestionsFromText_chunks(rawText, options) {
    const chunks = splitIntoChunks(rawText, 12000);
    const allQuestions = [];

    for (let i = 0; i < chunks.length; i++) {
        const questions = await extractQuestionsFromText(chunks[i], options, i + 1, chunks.length);
        allQuestions.push(...questions);
    }

    return allQuestions;
}

/**
 * Use Gemini to extract structured questions from a text chunk.
 */
async function extractQuestionsFromText(text, options, chunkNum, totalChunks) {
    const subjectHint = options.subject ? `The subject is ${options.subject}.` : '';
    const sourceHint = options.source ? `Source: ${options.source}.` : '';

    const systemPrompt = [
        'You are a JEE question extraction engine. Given raw text from a PDF containing MCQs (possibly with solutions), extract each question into a structured JSON array.',
        '',
        'Rules:',
        '- Return ONLY a valid JSON array, no extra text',
        '- Each object: question_text, option1, option2, option3, option4, correct_answer, solution_text',
        '- correct_answer must be "option1", "option2", "option3", or "option4"',
        '- Map answers: (A)/(1) = option1, (B)/(2) = option2, (C)/(3) = option3, (D)/(4) = option4',
        '- If answer unclear, set correct_answer to "option1" and add "needs_review": true',
        '- Include solution in solution_text if present, otherwise empty string',
        '- For math in JSON, double-escape backslashes for valid JSON',
        '- Skip non-question content (headers, watermarks, page numbers)',
        subjectHint,
        sourceHint,
    ].join('\n');

    const userPrompt = `Extract all MCQ questions from this text (chunk ${chunkNum}/${totalChunks}):\n\n${text}`;

    try {
        const raw = await geminiGenerate(systemPrompt, userPrompt);
        const cleaned = raw.replace(/```json\n?|\n?```/g, '').trim();

        const start = cleaned.indexOf('[');
        const end = cleaned.lastIndexOf(']');
        if (start === -1 || end === -1) return [];

        let jsonStr = cleaned.slice(start, end + 1);

        // Fix unescaped backslashes that break JSON (common with LaTeX)
        // Only fix backslashes NOT followed by valid JSON escape chars or already doubled
        jsonStr = jsonStr.replace(/(?<!\\)\\(?!["\\/bfnrtu\\])/g, '\\\\');

        let parsed;
        try {
            parsed = JSON.parse(jsonStr);
        } catch (parseErr) {
            console.error(`  JSON parse attempt 1 failed: ${parseErr.message}`);
            // More aggressive fix: replace ALL lone backslashes
            jsonStr = cleaned.slice(start, end + 1);
            // First, normalize newlines
            jsonStr = jsonStr.replace(/\r\n/g, '\n');
            // Replace backslash followed by anything that's not a valid JSON escape
            jsonStr = jsonStr.replace(/\\([^"\\\/bfnrtu])/g, '\\\\$1');
            try {
                parsed = JSON.parse(jsonStr);
            } catch (parseErr2) {
                console.error(`  JSON parse attempt 2 failed: ${parseErr2.message}`);
                // Last resort: try eval-like approach with Function constructor
                try {
                    // Remove actual newlines inside strings by replacing them
                    const singleLine = jsonStr.replace(/\n\s*/g, ' ');
                    parsed = JSON.parse(singleLine);
                } catch (parseErr3) {
                    console.error(`  JSON parse attempt 3 failed: ${parseErr3.message}`);
                    console.error(`  First 300 chars: ${jsonStr.substring(0, 300)}`);
                    return [];
                }
            }
        }

        if (!Array.isArray(parsed)) return [];

        return parsed.map((q) => ({
            question_text: String(q.question_text || q.question || '').trim(),
            option1: String(q.option1 || '').trim(),
            option2: String(q.option2 || '').trim(),
            option3: String(q.option3 || '').trim(),
            option4: String(q.option4 || '').trim(),
            correct_answer: /^option[1-4]$/.test(q.correct_answer) ? q.correct_answer : 'option1',
            solution_text: String(q.solution_text || q.solution || '').trim(),
            needs_review: q.needs_review || !/^option[1-4]$/.test(q.correct_answer),
            source: options.source || '',
        })).filter(q => q.question_text.length > 10 && q.option1 && q.option2);
    } catch (err) {
        console.error(`Failed to extract questions from chunk ${chunkNum}:`, err.message);
        return [];
    }
}

/**
 * Split text into chunks of roughly maxChars, breaking at paragraph boundaries.
 */
function splitIntoChunks(text, maxChars) {
    if (text.length <= maxChars) return [text];
    const chunks = [];
    let remaining = text;
    while (remaining.length > 0) {
        if (remaining.length <= maxChars) {
            chunks.push(remaining);
            break;
        }
        // Find a good break point (double newline near the limit)
        let breakAt = remaining.lastIndexOf('\n\n', maxChars);
        if (breakAt < maxChars * 0.5) breakAt = remaining.lastIndexOf('\n', maxChars);
        if (breakAt < maxChars * 0.5) breakAt = maxChars;
        chunks.push(remaining.slice(0, breakAt));
        remaining = remaining.slice(breakAt).trim();
    }
    return chunks;
}
