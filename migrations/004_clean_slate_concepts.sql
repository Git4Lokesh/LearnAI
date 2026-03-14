-- Migration: Clean slate for chapter-by-chapter concept rebuild
-- Removes all old concepts, prerequisites, questions, and related data
-- Order matters due to foreign key constraints

-- 1. Clear mastery data (references concepts and users)
DELETE FROM user_concept_mastery;

-- 2. Clear question attempts (references questions)
DELETE FROM user_question_attempts;

-- 3. Clear questions (references concepts)
DELETE FROM questions;

-- 4. Clear concept prerequisites (references concepts)
DELETE FROM concept_prerequisites;

-- 5. Clear concepts themselves
DELETE FROM concepts;
