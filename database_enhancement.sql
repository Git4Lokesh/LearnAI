-- 1. Create the table without inline indexes
CREATE TABLE IF NOT EXISTS user_question_attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    correct BOOLEAN NOT NULL,
    time_taken_seconds INTEGER,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create the indexes separately
CREATE INDEX idx_user_question_attempts_user_question 
    ON user_question_attempts(user_id, question_id);

CREATE INDEX idx_user_question_attempts_user_attempted 
    ON user_question_attempts(user_id, attempted_at);

-- 3. Enhanced practice route function
CREATE OR REPLACE FUNCTION get_next_concept_with_prerequisites(p_user_id INTEGER, p_subject VARCHAR DEFAULT 'physics')
RETURNS TABLE(
    concept_id VARCHAR, -- Change to INTEGER if concepts.id is an INT
    concept_name VARCHAR,
    mastery DECIMAL,
    has_prerequisite_gaps BOOLEAN,
    prerequisite_gaps JSONB
) AS $$
BEGIN
    RETURN QUERY
    WITH concept_mastery AS (
        SELECT c.id, c.name, COALESCE(ucm.mastery, 0.2) as mastery
        FROM concepts c
        LEFT JOIN user_concept_mastery ucm ON c.id = ucm.concept_id AND ucm.user_id = p_user_id
        WHERE c.subject = p_subject
    ),
    prerequisite_check AS (
        SELECT cm.id, cm.name, cm.mastery,
               CASE WHEN EXISTS(
                   SELECT 1 FROM concept_prerequisites cp
                   JOIN user_concept_mastery prereq_ucm ON cp.prereq_id = prereq_ucm.concept_id
                   WHERE cp.concept_id = cm.id AND prereq_ucm.user_id = p_user_id 
                   AND prereq_ucm.mastery < 0.7
               ) THEN true ELSE false END as has_gaps,
               (SELECT jsonb_agg(jsonb_build_object('concept_id', cp.prereq_id, 'name', prereq_c.name, 'mastery', COALESCE(prereq_ucm.mastery, 0.2)))
                FROM concept_prerequisites cp
                JOIN concepts prereq_c ON cp.prereq_id = prereq_c.id
                LEFT JOIN user_concept_mastery prereq_ucm ON cp.prereq_id = prereq_ucm.concept_id AND prereq_ucm.user_id = p_user_id
                WHERE cp.concept_id = cm.id AND COALESCE(prereq_ucm.mastery, 0.2) < 0.7
               ) as gaps
        FROM concept_mastery cm
    )
    SELECT pc.id, pc.name, pc.mastery, pc.has_gaps, COALESCE(pc.gaps, '[]'::jsonb)
    FROM prerequisite_check pc
    WHERE pc.mastery < 0.8
    ORDER BY pc.has_gaps ASC, pc.mastery ASC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;