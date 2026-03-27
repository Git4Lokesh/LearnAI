import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';
dotenv.config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

export async function geminiGenerate(systemPrompt, userPrompt, model = 'gemini-2.5-flash') {
    const m = genAI.getGenerativeModel({ model, systemInstruction: systemPrompt });
    const result = await m.generateContent(userPrompt);
    return result.response.text();
}

export async function generateSingleQuestion(topic, level, difficulty, contextText) {
    const system = {
        role: "system",
        content: "You are an expert educational assessment creator. Generate ONE multiple choice question in strict JSON. Return ONLY JSON with keys: question, option1, option2, option3, option4, answer (answer is one of 'option1'..'option4'). Adjust difficulty appropriately. Use $...$ for any math."
    };
    const user = {
        role: "user",
        content: `Create ONE ${difficulty || 'medium'} difficulty multiple choice question for ${level} level.

${topic ? `Topic: ${topic}` : ''}
${contextText ? `
CONTEXT (use only this content for the question):
${contextText.substring(0, 6000)}
` : ''}

Requirements:
- Return only JSON object, no text outside JSON
- Keys: question, option1, option2, option3, option4, answer
- Options must be plausible, exactly one correct
- Use clear, grade-appropriate language
- If mathematical, use $...$ notation`
    };
    const content = await geminiGenerate(system.content, user.content, 'gemini-2.5-pro');
    let parsed;
    try {
        parsed = JSON.parse(content);
    } catch (e) {
        const start = content.indexOf('{');
        const end = content.lastIndexOf('}');
        if (start !== -1 && end !== -1 && end > start) {
            parsed = JSON.parse(content.slice(start, end + 1));
        } else {
            throw new Error('Model did not return valid JSON');
        }
    }
    let obj = Array.isArray(parsed) ? parsed[0] : parsed;
    if (!obj || typeof obj !== 'object') throw new Error('Invalid question object');
    const lower = {};
    for (const [k, v] of Object.entries(obj)) lower[k.toLowerCase()] = v;
    if (!lower.question && lower.prompt) lower.question = lower.prompt;
    if (!lower.answer && lower.correct) lower.answer = lower.correct;
    if (!lower.answer && lower.correctoption) lower.answer = lower.correctoption;
    if (!lower.option1 && Array.isArray(lower.options) && lower.options.length >= 4) {
        lower.option1 = lower.options[0];
        lower.option2 = lower.options[1];
        lower.option3 = lower.options[2];
        lower.option4 = lower.options[3];
        if (typeof lower.correctindex === 'number') {
            lower.answer = `option${(lower.correctindex + 1)}`;
        }
    }
    const normalized = {
        question: String(lower.question || '').trim(),
        option1: String(lower.option1 || '').trim(),
        option2: String(lower.option2 || '').trim(),
        option3: String(lower.option3 || '').trim(),
        option4: String(lower.option4 || '').trim(),
        answer: String(lower.answer || '').trim()
    };
    if (!/^option[1-4]$/.test(normalized.answer)) {
        const ansText = normalized.answer.toLowerCase();
        const matchIndex = [1, 2, 3, 4].find(i => normalized[`option${i}`].toLowerCase() === ansText);
        if (matchIndex) normalized.answer = `option${matchIndex}`;
    }
    if (!normalized.question || !normalized.option1 || !normalized.option2 || !normalized.option3 || !normalized.option4) {
        throw new Error('Incomplete question fields');
    }
    if (!/^option[1-4]$/.test(normalized.answer)) {
        normalized.answer = 'option1';
    }
    return normalized;
}
