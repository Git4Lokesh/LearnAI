-- Learn.ai Database Setup Script
-- Run this in pgAdmin or psql to create the complete database structure

-- Create database (run this first)
-- CREATE DATABASE "Content Storage";

-- Connect to the database and run the following:

-- Create custom types
CREATE TYPE question_status AS ENUM ('pending', 'approved', 'rejected');

-- Create tables
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    role VARCHAR(20) DEFAULT 'student'
);

CREATE TABLE concepts (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL
);

CREATE TABLE concept_prerequisites (
    concept_id VARCHAR(100) NOT NULL,
    prereq_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (concept_id, prereq_id),
    FOREIGN KEY (concept_id) REFERENCES concepts(id),
    FOREIGN KEY (prereq_id) REFERENCES concepts(id)
);

CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    question_text TEXT NOT NULL,
    option1 TEXT NOT NULL,
    option2 TEXT NOT NULL,
    option3 TEXT NOT NULL,
    option4 TEXT NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    solution_text TEXT,
    concept_id VARCHAR(100) NOT NULL,
    difficulty_tier INTEGER NOT NULL,
    source VARCHAR(255),
    status question_status DEFAULT 'pending',
    extracted_by_ai_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_by INTEGER,
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_year VARCHAR(10),
    source_paper VARCHAR(10),
    topic_hint VARCHAR(255),
    FOREIGN KEY (concept_id) REFERENCES concepts(id),
    FOREIGN KEY (verified_by) REFERENCES users(id)
);

CREATE TABLE user_concept_mastery (
    user_id INTEGER NOT NULL,
    concept_id VARCHAR(100) NOT NULL,
    mastery NUMERIC(5,4) DEFAULT 0.2,
    questions_answered INTEGER NOT NULL DEFAULT 0,
    correct_answers INTEGER NOT NULL DEFAULT 0,
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, concept_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE TABLE user_question_attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    correct BOOLEAN NOT NULL,
    time_taken_seconds INTEGER,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE quicknotes (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    grade_level TEXT NOT NULL,
    note_content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE flashcards (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    grade_level TEXT NOT NULL,
    card_content JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE quiz (
    id SERIAL PRIMARY KEY,
    topic TEXT NOT NULL,
    grade_level TEXT NOT NULL,
    content JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE study_rooms (
    id SERIAL PRIMARY KEY,
    room_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    description TEXT,
    privacy VARCHAR(20) NOT NULL DEFAULT 'public',
    max_participants INTEGER DEFAULT 50,
    study_material_type VARCHAR(50),
    owner_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE room_members (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES study_rooms(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE room_content (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    content_id INTEGER,
    title VARCHAR(255),
    topic VARCHAR(255),
    grade_level VARCHAR(50),
    content_data JSONB,
    shared_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES study_rooms(id),
    FOREIGN KEY (shared_by) REFERENCES users(id)
);

CREATE TABLE room_chat_messages (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES study_rooms(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE study_sessions (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_at TIMESTAMP NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    created_by INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES study_rooms(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE session_participants (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES study_sessions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE session_notes (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    notes_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES study_sessions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE room_annotations (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    annotation_text TEXT,
    position_start INTEGER,
    position_end INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_content_id) REFERENCES room_content(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE room_notes_edits (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    edit_type VARCHAR(50) NOT NULL,
    position INTEGER,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_content_id) REFERENCES room_content(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE quiz_leaderboard (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    score INTEGER NOT NULL,
    total_questions INTEGER NOT NULL,
    time_taken_seconds INTEGER,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_content_id) REFERENCES room_content(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE group_progress (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL,
    skill_id VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL,
    mastery_score NUMERIC(5,4) DEFAULT 0.0,
    questions_answered INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES study_rooms(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);