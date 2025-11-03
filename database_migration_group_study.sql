-- Group Study Feature Database Schema Migration
-- Run this SQL script to add group study tables to your database

-- Study Rooms Table
CREATE TABLE IF NOT EXISTS study_rooms (
    id SERIAL PRIMARY KEY,
    room_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    description TEXT,
    privacy VARCHAR(20) NOT NULL DEFAULT 'public', -- 'public', 'private', 'invite-only'
    max_participants INTEGER DEFAULT 50,
    study_material_type VARCHAR(50), -- 'notes', 'flashcards', 'quiz', 'mixed'
    owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Room Members Table
CREATE TABLE IF NOT EXISTS room_members (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES study_rooms(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'member', -- 'owner', 'admin', 'member'
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(room_id, user_id)
);

-- Shared Content in Rooms
CREATE TABLE IF NOT EXISTS room_content (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES study_rooms(id) ON DELETE CASCADE,
    content_type VARCHAR(50) NOT NULL, -- 'quicknotes', 'flashcards', 'quiz'
    content_id INTEGER, -- Reference to original quicknotes/flashcards/quiz id
    title VARCHAR(255),
    topic VARCHAR(255),
    grade_level VARCHAR(50),
    content_data JSONB, -- Stored content (notes HTML, flashcards JSON, quiz JSON)
    shared_by INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Collaborative Notes Edits (for real-time editing)
CREATE TABLE IF NOT EXISTS room_notes_edits (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL REFERENCES room_content(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    edit_type VARCHAR(50) NOT NULL, -- 'insert', 'delete', 'update'
    position INTEGER, -- Character position for edits
    content TEXT, -- Edited content
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Room Chat Messages
CREATE TABLE IF NOT EXISTS room_chat_messages (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES study_rooms(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Study Sessions (scheduled)
CREATE TABLE IF NOT EXISTS study_sessions (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES study_rooms(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_at TIMESTAMP NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'active', 'completed', 'cancelled'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    ended_at TIMESTAMP
);

-- Session Participants
CREATE TABLE IF NOT EXISTS session_participants (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL REFERENCES study_sessions(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(session_id, user_id)
);

-- Session Notes/Recordings
CREATE TABLE IF NOT EXISTS session_notes (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL REFERENCES study_sessions(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notes_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Group Progress Tracking (aggregate BKT scores)
CREATE TABLE IF NOT EXISTS group_progress (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES study_rooms(id) ON DELETE CASCADE,
    skill_id VARCHAR(255) NOT NULL, -- Topic/skill being tracked
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    mastery_score DECIMAL(5,4) DEFAULT 0.0, -- BKT mastery score
    questions_answered INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(room_id, skill_id, user_id)
);

-- Room Annotations (for collaborative annotations on shared notes)
CREATE TABLE IF NOT EXISTS room_annotations (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL REFERENCES room_content(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    annotation_text TEXT,
    position_start INTEGER,
    position_end INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Quiz Leaderboard (for group quizzes)
CREATE TABLE IF NOT EXISTS quiz_leaderboard (
    id SERIAL PRIMARY KEY,
    room_content_id INTEGER NOT NULL REFERENCES room_content(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    score INTEGER NOT NULL,
    total_questions INTEGER NOT NULL,
    time_taken_seconds INTEGER,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(room_content_id, user_id)
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_room_members_room ON room_members(room_id);
CREATE INDEX IF NOT EXISTS idx_room_members_user ON room_members(user_id);
CREATE INDEX IF NOT EXISTS idx_room_content_room ON room_content(room_id);
CREATE INDEX IF NOT EXISTS idx_room_chat_room ON room_chat_messages(room_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_room ON study_sessions(room_id);
CREATE INDEX IF NOT EXISTS idx_group_progress_room ON group_progress(room_id);
CREATE INDEX IF NOT EXISTS idx_study_rooms_code ON study_rooms(room_code);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_study_rooms_updated_at BEFORE UPDATE ON study_rooms
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_room_content_updated_at BEFORE UPDATE ON room_content
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_room_annotations_updated_at BEFORE UPDATE ON room_annotations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_session_notes_updated_at BEFORE UPDATE ON session_notes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

