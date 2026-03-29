import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const db = new pg.Pool({
    host: process.env.DB_HOST || 'localhost',
    port: 5432,
    user: 'postgres',
    password: process.env.db_password,
    database: 'Content Storage',
    max: 20,              // max connections in pool
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 5000,
});

export default db;
