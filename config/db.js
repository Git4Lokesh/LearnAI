import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const db = new pg.Client({
    host: process.env.DB_HOST || 'localhost',
    port: 5432,
    user: 'postgres',
    password: process.env.db_password,
    database: 'Content Storage',
});

await db.connect();

export default db;
