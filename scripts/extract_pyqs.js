/**
 * PYQ Extraction Script
 * Usage: node scripts/extract_pyqs.js <path-to-pdf> [year] [paper]
 */

import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
import pg from 'pg';
import { GoogleGenerativeAI, SchemaType } from '@google/generative-ai';
import { extractTextFromPDF } from '../services/pdfService.js';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const pdfPath = process.argv[2];
const year    = process.argv[3] || 'unknown';
const paper   = process.argv[4] || '1';

if (!pdfPath) {
    console.error('Usage: node scripts/extract_pyqs.js <path-to-pdf> [year] [paper]');
    process.exit(1);
}

const db = new pg.Client({
    host: 'localhost', port: 5432, user: 'postgres',
    password: process.env.db_password, database: 'Content Storage'
});

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

// Semantic chunking: split on '# Q' boundaries (LlamaParse format), target 10k-15k chars
function chunkMarkdown(text, targetSize = 12000) {
    const chunks = [];
    const parts = text.split(/(?=\n#\s*Q\d+\.)/i);
    let current = '';
    for (const part of parts) {
        if (current.length + part.length > targetSize && current.length > 0) {
            chunks.push(current.trim());
            current = part;
        } else {
            current += part;
        }
    }
    if (current.trim()) chunks.push(current.trim());
    return chunks.filter(c => c.length > 200);
}

const responseSchema = {
    type: SchemaType.ARRAY,
    items: {
        type: SchemaType.OBJECT,
        properties: {
            question_text:  { type: SchemaType.STRING },
            option1:        { type: SchemaType.STRING },
            option2:        { type: SchemaType.STRING },
            option3:        { type: SchemaType.STRING },
            option4:        { type: SchemaType.STRING },
            correct_answer: { type: SchemaType.STRING, enum: ['option1','option2','option3','option4'] },
            solution_text:  { type: SchemaType.STRING },
            topic_hint:     { type: SchemaType.STRING },
            concept_id:     { type: SchemaType.STRING },
            difficulty_tier:{ type: SchemaType.INTEGER },
        },
        required: ['question_text','option1','option2','option3','option4','correct_answer','concept_id','difficulty_tier']
    }
};

async function extractFromChunk(chunk, conceptList) {
    const model = genAI.getGenerativeModel({
        model: 'gemini-2.5-flash',
        generationConfig: {
            responseMimeType: 'application/json',
            responseSchema
        },
        systemInstruction: `You are a JEE Physics question extractor. Extract ONLY Physics MCQs — skip any Maths or Chemistry questions.
- Preserve LaTeX exactly as-is using $$...$$ for display math, $...$ for inline
- concept_id must be one of the provided slugs, or omit the question if none fit
- difficulty_tier: 1=easy, 2=medium, 3=hard by JEE standards
- correct_answer must be "option1"|"option2"|"option3"|"option4"

Available concept IDs:
${conceptList}`
    });

    const result = await model.generateContent(`Extract all MCQ questions from this JEE paper markdown:\n\n${chunk}`);
    const raw = result.response.text();
    try {
        return JSON.parse(raw);
    } catch {
        return [];
    }
}

async function main() {
    await db.connect();

    const { rows: concepts } = await db.query('SELECT id, name FROM concepts ORDER BY id');
    const conceptList = concepts.map(c => `${c.id}: ${c.name}`).join('\n');
    const validIds = new Set(concepts.map(c => c.id));
    console.log(`Loaded ${concepts.length} concepts`);

    console.log('Parsing PDF via LlamaParse...');
    const buffer = fs.readFileSync(pdfPath);
    const markdown = await extractTextFromPDF(buffer, path.basename(pdfPath));
    console.log(`Got ${markdown.length} chars of markdown`);
    const chunks = chunkMarkdown(markdown);
    console.log(`Split into ${chunks.length} chunks`);

    let totalInserted = 0, totalSkipped = 0;

    for (let i = 0; i < chunks.length; i++) {
        console.log(`Processing chunk ${i + 1}/${chunks.length}...`);
        let questions;
        try {
            questions = await extractFromChunk(chunks[i], conceptList);
        } catch (e) {
            console.warn(`  Chunk ${i + 1} failed: ${e.message}`);
            continue;
        }
        if (!Array.isArray(questions)) { console.warn('  Non-array response, skipping'); continue; }
        console.log(`  Found ${questions.length} questions`);

        for (const q of questions) {
            if (!q.question_text || !q.option1 || !q.option2 || !q.option3 || !q.option4) { console.warn(`  Skip: missing fields`); totalSkipped++; continue; }
            if (!/^option[1-4]$/.test(q.correct_answer)) { console.warn(`  Skip: bad correct_answer: ${q.correct_answer}`); totalSkipped++; continue; }
            if (!q.concept_id || !validIds.has(q.concept_id)) { console.warn(`  Skip: unknown concept_id: ${q.concept_id}`); totalSkipped++; continue; }
            if (![1,2,3].includes(Number(q.difficulty_tier))) { console.warn(`  Skip: bad difficulty_tier: ${q.difficulty_tier}`); totalSkipped++; continue; }

            try {
                await db.query(`
                    INSERT INTO questions
                        (question_text, option1, option2, option3, option4, correct_answer,
                         solution_text, concept_id, difficulty_tier, source_year, source_paper, topic_hint, status)
                    VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,'pending')
                `, [
                    q.question_text.trim(),
                    q.option1.trim(), q.option2.trim(), q.option3.trim(), q.option4.trim(),
                    q.correct_answer,
                    q.solution_text || null,
                    q.concept_id,
                    Number(q.difficulty_tier),
                    year, paper,
                    q.topic_hint || null
                ]);
                totalInserted++;
            } catch (e) {
                console.warn(`  Insert failed: ${e.message}`);
                totalSkipped++;
            }
        }

        if (i < chunks.length - 1) await new Promise(r => setTimeout(r, 1000));
    }

    await db.end();
    console.log(`\nDone. Inserted: ${totalInserted}, Skipped: ${totalSkipped}`);
    console.log('Visit /admin/verify to start reviewing.');
}

main().catch(e => { console.error(e); process.exit(1); });
