/**
 * PDF Question Extraction Pipeline Test Script
 * 
 * Tests the full flow: PDF → LlamaParse → Gemini structuring → Concept tagging
 * Run: node scripts/test_pdf_extraction.js [path-to-pdf]
 * Default: uses "JEE Mains Detailed Syllabus.pdf" in project root
 */
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
dotenv.config();

// ── Logging helpers ──
const LOG = {
    step: (n, msg) => console.log(`\n${'═'.repeat(60)}\n  STEP ${n}: ${msg}\n${'═'.repeat(60)}`),
    info: (msg) => console.log(`  ℹ️  ${msg}`),
    ok: (msg) => console.log(`  ✅ ${msg}`),
    warn: (msg) => console.log(`  ⚠️  ${msg}`),
    err: (msg) => console.log(`  ❌ ${msg}`),
    data: (label, obj) => console.log(`  📦 ${label}:`, typeof obj === 'string' ? obj.substring(0, 200) : JSON.stringify(obj, null, 2).substring(0, 500)),
    divider: () => console.log(`  ${'─'.repeat(50)}`),
};

async function main() {
    const startTime = Date.now();
    const pdfPath = process.argv[2] || 'JEE Mains Detailed Syllabus.pdf';

    console.log('\n🔬 PDF Question Extraction Pipeline Test');
    console.log(`   File: ${pdfPath}`);
    console.log(`   Time: ${new Date().toISOString()}\n`);

    // ── Pre-flight checks ──
    LOG.step(0, 'PRE-FLIGHT CHECKS');

    if (!process.env.LLAMA_CLOUD_API_KEY) {
        LOG.err('LLAMA_CLOUD_API_KEY not set in .env');
        process.exit(1);
    }
    LOG.ok('LLAMA_CLOUD_API_KEY found');

    if (!process.env.GEMINI_API_KEY) {
        LOG.err('GEMINI_API_KEY not set in .env');
        process.exit(1);
    }
    LOG.ok('GEMINI_API_KEY found');

    if (!fs.existsSync(pdfPath)) {
        LOG.err(`PDF file not found: ${pdfPath}`);
        LOG.info('Usage: node scripts/test_pdf_extraction.js [path-to-pdf]');
        process.exit(1);
    }
    const fileBuffer = fs.readFileSync(pdfPath);
    const fileSizeKB = Math.round(fileBuffer.length / 1024);
    LOG.ok(`PDF loaded: ${fileSizeKB} KB`);

    // ── Step 1: LlamaParse PDF → Text ──
    LOG.step(1, 'LLAMAPARSE: PDF → Markdown Text');
    let rawText;
    try {
        const { extractTextFromPDF } = await import('../services/pdfService.js');
        LOG.info('Uploading PDF to LlamaIndex Cloud...');
        const t1 = Date.now();
        rawText = await extractTextFromPDF(fileBuffer, path.basename(pdfPath));
        const elapsed = ((Date.now() - t1) / 1000).toFixed(1);
        LOG.ok(`Text extracted in ${elapsed}s`);
        LOG.info(`Raw text length: ${rawText.length} characters`);
        LOG.info(`Estimated pages: ~${Math.ceil(rawText.length / 3000)}`);
        LOG.divider();
        LOG.data('First 300 chars', rawText.substring(0, 300));
    } catch (err) {
        LOG.err(`LlamaParse failed: ${err.message}`);
        LOG.info('Check your LLAMA_CLOUD_API_KEY and network connection.');
        process.exit(1);
    }

    // ── Step 2: Gemini Question Structuring ──
    LOG.step(2, 'GEMINI: Raw Text → Structured Questions');
    let extractedQuestions;
    try {
        const { extractQuestionsFromRawText } = await import('../services/pdfQuestionExtractor.js');
        LOG.info('Sending text chunks to Gemini for question extraction...');
        const t2 = Date.now();
        extractedQuestions = await extractQuestionsFromRawText(rawText, {
            subject: 'Physics',
            source: 'Test Script - JEE PYQ',
        });
        const elapsed = ((Date.now() - t2) / 1000).toFixed(1);
        LOG.ok(`Extraction complete in ${elapsed}s`);
        LOG.info(`Questions extracted: ${extractedQuestions.length}`);

        if (extractedQuestions.length === 0) {
            LOG.warn('No questions extracted. The PDF might not contain MCQs, or the format was not recognized.');
            LOG.info('This could happen with a syllabus PDF (no actual questions). Try with a PYQ paper.');
        } else {
            LOG.divider();
            LOG.info('Sample questions:');
            extractedQuestions.slice(0, 3).forEach((q, i) => {
                console.log(`\n  📝 Question ${i + 1}:`);
                console.log(`     Text: ${q.question_text.substring(0, 120)}...`);
                console.log(`     Options: A) ${q.option1.substring(0, 40)}  B) ${q.option2.substring(0, 40)}`);
                console.log(`     Correct: ${q.correct_answer}  |  Needs review: ${q.needs_review}`);
            });
        }
    } catch (err) {
        LOG.err(`Question extraction failed: ${err.message}`);
        console.error(err);
        process.exit(1);
    }

    // ── Step 3: Concept Tagging ──
    LOG.step(3, 'GEMINI: Concept Classification');
    if (extractedQuestions.length === 0) {
        LOG.warn('Skipping concept tagging — no questions to tag.');
    } else {
        try {
            const { geminiGenerate } = await import('../helpers/gemini.js');
            const { classifyQuestionConcept } = await import('../services/conceptTagger.js');
            const db = (await import('../config/db.js')).default;

            LOG.info('Loading concept list from database...');
            const conceptsResult = await db.query('SELECT id, name FROM concepts ORDER BY name');
            LOG.ok(`${conceptsResult.rowCount} concepts loaded`);

            // Tag first 3 questions as a test
            const testCount = Math.min(3, extractedQuestions.length);
            LOG.info(`Tagging ${testCount} questions (of ${extractedQuestions.length} total)...`);

            for (let i = 0; i < testCount; i++) {
                const q = extractedQuestions[i];
                LOG.divider();
                LOG.info(`Tagging Q${i + 1}: "${q.question_text.substring(0, 80)}..."`);
                try {
                    const t3 = Date.now();
                    const result = await classifyQuestionConcept(
                        q.question_text, 'Physics', conceptsResult.rows, geminiGenerate
                    );
                    const elapsed = ((Date.now() - t3) / 1000).toFixed(1);
                    LOG.ok(`Tagged in ${elapsed}s → concept_id: ${result.concept_id}, confidence: ${result.confidence}`);
                    // Look up concept name
                    const concept = conceptsResult.rows.find(c => c.id === result.concept_id || c.id === String(result.concept_id));
                    if (concept) LOG.info(`Concept: ${concept.name}`);
                } catch (tagErr) {
                    LOG.err(`Tagging failed: ${tagErr.message}`);
                }
            }

            await db.end();
        } catch (err) {
            LOG.err(`Concept tagging setup failed: ${err.message}`);
            console.error(err);
        }
    }

    // ── Summary ──
    const totalTime = ((Date.now() - startTime) / 1000).toFixed(1);
    LOG.step('✓', 'PIPELINE TEST COMPLETE');
    console.log(`  📊 Results:`);
    console.log(`     PDF size:           ${fileSizeKB} KB`);
    console.log(`     Raw text length:    ${rawText ? rawText.length : 0} chars`);
    console.log(`     Questions found:    ${extractedQuestions ? extractedQuestions.length : 0}`);
    console.log(`     Needs review:       ${extractedQuestions ? extractedQuestions.filter(q => q.needs_review).length : 0}`);
    console.log(`     Total time:         ${totalTime}s`);
    console.log(`\n  💡 Next: Upload a JEE PYQ paper PDF for best results.`);
    console.log(`     The syllabus PDF won't have MCQs to extract.\n`);
}

main().catch(err => {
    console.error('\n❌ Unhandled error:', err);
    process.exit(1);
});
