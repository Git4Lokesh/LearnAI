/**
 * Mock Mastery Data Script with Realistic Prerequisite Dependencies
 * Usage: node scripts/mock_mastery.js <user_id>
 */

import dotenv from 'dotenv';
import pg from 'pg';
import path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const userId = process.argv[2];

if (!userId) {
    console.error('Usage: node scripts/mock_mastery.js <user_id>');
    console.error('Example: node scripts/mock_mastery.js 2');
    process.exit(1);
}

const db = new pg.Client({
    host: 'localhost', port: 5432, user: 'postgres',
    password: process.env.db_password, database: 'Content Storage'
});

async function main() {
    await db.connect();

    // Get all concepts and prerequisites
    const [conceptsRes, prereqsRes] = await Promise.all([
        db.query('SELECT id, name, subject FROM concepts ORDER BY id'),
        db.query('SELECT concept_id, prereq_id FROM concept_prerequisites')
    ]);
    
    const concepts = conceptsRes.rows;
    const prereqs = prereqsRes.rows;
    
    console.log(`Found ${concepts.length} concepts with ${prereqs.length} prerequisite relationships`);

    // Clear existing mastery data
    await db.query('DELETE FROM user_concept_mastery WHERE user_id = $1', [userId]);
    console.log('Cleared existing mastery data');

    // Insert simple random mastery data
    let inserted = 0;
    for (const concept of concepts) {
        // Simple random distribution: 30% green, 30% orange, 40% blue/grey
        const rand = Math.random();
        let mastery;
        if (rand < 0.3) {
            mastery = 0.8 + Math.random() * 0.15; // GREEN (80-95%)
        } else if (rand < 0.6) {
            mastery = 0.4 + Math.random() * 0.4; // ORANGE (40-80%)
        } else {
            mastery = 0.2 + Math.random() * 0.2; // BLUE (20-40%)
        }

        const questions_answered = Math.floor(Math.random() * 20) + 5;
        const correct_answers = Math.floor(questions_answered * mastery);

        await db.query(`
            INSERT INTO user_concept_mastery 
            (user_id, concept_id, mastery, questions_answered, correct_answers, last_updated)
            VALUES ($1, $2, $3, $4, $5, NOW())
        `, [userId, concept.id, mastery, questions_answered, correct_answers]);

        inserted++;
    }

    await db.end();
    
    console.log(`\n✅ Simple random mastery data created for user ${userId}!`);
    console.log(`📊 Should see GREEN, ORANGE, and BLUE nodes on dashboard!`);
}

main().catch(e => {
    console.error('Error:', e);
    process.exit(1);
});