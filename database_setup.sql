-- Learn.ai Database Setup Script
-- Run this in pgAdmin or psql to create the complete database structure
-- This script drops and recreates all tables to match the current schema

-- Create database (run this first)
-- CREATE DATABASE "Content Storage";

-- Connect to the database and run the following:

-- Drop all tables in reverse dependency order (child tables first)
DROP TABLE IF EXISTS quiz_leaderboard CASCADE;
DROP TABLE IF EXISTS group_progress CASCADE;
DROP TABLE IF EXISTS room_notes_edits CASCADE;
DROP TABLE IF EXISTS room_annotations CASCADE;
DROP TABLE IF EXISTS session_notes CASCADE;
DROP TABLE IF EXISTS session_participants CASCADE;
DROP TABLE IF EXISTS study_sessions CASCADE;
DROP TABLE IF EXISTS room_chat_messages CASCADE;
DROP TABLE IF EXISTS room_content CASCADE;
DROP TABLE IF EXISTS room_members CASCADE;
DROP TABLE IF EXISTS study_rooms CASCADE;
DROP TABLE IF EXISTS quiz CASCADE;
DROP TABLE IF EXISTS flashcards CASCADE;
DROP TABLE IF EXISTS quicknotes CASCADE;
DROP TABLE IF EXISTS user_question_attempts CASCADE;
DROP TABLE IF EXISTS user_concept_mastery CASCADE;
DROP TABLE IF EXISTS upload_jobs CASCADE;
DROP TABLE IF EXISTS batch_students CASCADE;
DROP TABLE IF EXISTS batches CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS concept_prerequisites CASCADE;
DROP TABLE IF EXISTS concepts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS institutes CASCADE;

-- Drop and recreate custom types
DROP TYPE IF EXISTS question_status;
DROP TYPE IF EXISTS subscription_status;
DROP TYPE IF EXISTS upload_job_status;
CREATE TYPE question_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE subscription_status AS ENUM ('trial', 'active', 'suspended', 'cancelled');
CREATE TYPE upload_job_status AS ENUM ('processing', 'completed', 'failed');

-- Create tables
CREATE TABLE institutes (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    contact_email TEXT,
    subscription_status subscription_status DEFAULT 'trial',
    max_students INTEGER DEFAULT 500,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    role VARCHAR(20) DEFAULT 'student',
    institute_id INTEGER REFERENCES institutes(id)
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
    concept_id VARCHAR(100),
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
    institute_id INTEGER REFERENCES institutes(id),
    concept_confidence NUMERIC(3,2),
    needs_review_tag BOOLEAN DEFAULT false,
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

CREATE TABLE batches (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER NOT NULL REFERENCES institutes(id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE batch_students (
    batch_id INTEGER REFERENCES batches(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (batch_id, user_id)
);

CREATE TABLE upload_jobs (
    id SERIAL PRIMARY KEY,
    institute_id INTEGER REFERENCES institutes(id),
    uploaded_by INTEGER REFERENCES users(id),
    filename TEXT,
    total_rows INTEGER,
    processed_rows INTEGER DEFAULT 0,
    failed_rows INTEGER DEFAULT 0,
    status upload_job_status DEFAULT 'processing',
    error_log JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ
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

-- Indexes for query performance
CREATE INDEX idx_users_institute ON users(institute_id);
CREATE INDEX idx_questions_institute ON questions(institute_id);
CREATE INDEX idx_questions_status_institute ON questions(status, institute_id);
CREATE INDEX idx_batch_students_user ON batch_students(user_id);
CREATE INDEX idx_upload_jobs_institute ON upload_jobs(institute_id);
CREATE INDEX idx_user_concept_mastery_mastery ON user_concept_mastery(mastery);

-- Insert concept data (JEE Physics & Mathematics knowledge graph)
INSERT INTO concepts (id, name, subject) VALUES
('algebra_basic', 'Basic Algebraic Manipulation', 'Mathematics'),
('linear_equations_one_variable', 'Linear Equations in One Variable', 'Mathematics'),
('quadratic_equations', 'Quadratic Equations', 'Mathematics'),
('coordinate_geometry_2d', 'Coordinate Geometry in 2D', 'Mathematics'),
('trigonometry_basic_ratios', 'Basic Trigonometric Ratios', 'Mathematics'),
('trigonometry_identities', 'Standard Trigonometric Identities', 'Mathematics'),
('vectors_basics_scalars_vectors', 'Vectors and Scalars Basics', 'Mathematics'),
('vectors_addition_resolution', 'Vector Addition and Resolution', 'Mathematics'),
('vectors_dot_product', 'Dot Product of Vectors', 'Mathematics'),
('vectors_cross_product', 'Cross Product of Vectors', 'Mathematics'),
('calculus_limits', 'Limits and Continuity', 'Mathematics'),
('calculus_differentiation_basic', 'Basic Differentiation', 'Mathematics'),
('calculus_integration_basic', 'Basic Integration', 'Mathematics'),
('area_under_curve', 'Area Under a Curve', 'Mathematics'),
('units_dimensions', 'Units, Dimensions and Measurement', 'Physics - Mechanics'),
('scalars_vectors_physics', 'Scalars and Vectors in Physics', 'Physics - Mechanics'),
('motion_basic_terminology', 'Position, Displacement and Distance', 'Physics - Mechanics'),
('kinematics_1d_velocity', 'Speed and Velocity in 1D', 'Physics - Mechanics'),
('kinematics_1d_acceleration', 'Acceleration in 1D', 'Physics - Mechanics'),
('kinematics_1d_equations_uniform', 'Equations of Motion (Uniform Acceleration)', 'Physics - Mechanics'),
('kinematics_graphs_1d', 'x-t, v-t and a-t Graphs in 1D', 'Physics - Mechanics'),
('relative_velocity_1d', 'Relative Velocity in 1D', 'Physics - Mechanics'),
('kinematics_2d_vectors', '2D Motion and Vector Decomposition', 'Physics - Mechanics'),
('projectile_motion', 'Projectile Motion in a Plane', 'Physics - Mechanics'),
('relative_velocity_2d', 'Relative Velocity in 2D', 'Physics - Mechanics'),
('uniform_circular_motion_kinematics', 'Uniform Circular Motion Kinematics', 'Physics - Mechanics'),
('ucm_radial_tangential_acc', 'Radial and Tangential Acceleration in UCM', 'Physics - Mechanics'),
('concept_of_force_inertia', 'Concept of Force, Mass and Inertia', 'Physics - Mechanics'),
('newtons_first_law', 'Newton''s First Law of Motion', 'Physics - Mechanics'),
('newtons_second_law', 'Newton''s Second Law (F = ma)', 'Physics - Mechanics'),
('newtons_third_law', 'Newton''s Third Law and Action-Reaction', 'Physics - Mechanics'),
('free_body_diagrams', 'Free Body Diagrams (FBD)', 'Physics - Mechanics'),
('normal_reaction_tension', 'Normal Reaction and Tension Forces', 'Physics - Mechanics'),
('friction_static_kinetic', 'Static and Kinetic Friction', 'Physics - Mechanics'),
('motion_on_inclined_plane', 'Motion on Inclined Plane', 'Physics - Mechanics'),
('pulley_block_systems', 'Connected Bodies and Pulley Systems', 'Physics - Mechanics'),
('circular_motion_dynamics', 'Dynamics of Uniform Circular Motion', 'Physics - Mechanics'),
('vehicle_on_level_curve', 'Vehicle on Level Circular Road', 'Physics - Mechanics'),
('vehicle_on_banked_road', 'Vehicle on Banked Road', 'Physics - Mechanics'),
('pseudo_force_non_inertial', 'Pseudo Forces and Non-inertial Frames', 'Physics - Mechanics'),
('work_constant_force', 'Work by a Constant Force', 'Physics - Mechanics'),
('work_variable_force', 'Work by a Variable Force', 'Physics - Mechanics'),
('kinetic_energy', 'Kinetic Energy', 'Physics - Mechanics'),
('potential_energy_near_earth', 'Gravitational Potential Energy Near Earth', 'Physics - Mechanics'),
('potential_energy_spring', 'Elastic Potential Energy of a Spring', 'Physics - Mechanics'),
('work_energy_theorem', 'Work-Energy Theorem', 'Physics - Mechanics'),
('power_instantaneous', 'Average and Instantaneous Power', 'Physics - Mechanics'),
('conservation_energy', 'Conservation of Mechanical Energy', 'Physics - Mechanics'),
('linear_momentum_impulse', 'Linear Momentum and Impulse', 'Physics - Mechanics'),
('conservation_linear_momentum', 'Conservation of Linear Momentum', 'Physics - Mechanics'),
('collision_1d', 'Elastic and Inelastic Collisions in 1D', 'Physics - Mechanics'),
('coefficient_of_restitution', 'Coefficient of Restitution', 'Physics - Mechanics'),
('collision_2d_oblique', 'Oblique Collisions in 2D', 'Physics - Mechanics'),
('centre_of_mass_discrete', 'Centre of Mass of Discrete Systems', 'Physics - Mechanics'),
('centre_of_mass_continuous', 'Centre of Mass of Continuous Bodies', 'Physics - Mechanics'),
('motion_of_centre_of_mass', 'Motion of Centre of Mass', 'Physics - Mechanics'),
('shm_basics', 'Simple Harmonic Motion - Kinematics', 'Physics - Mechanics'),
('shm_energy', 'Energy in Simple Harmonic Motion', 'Physics - Mechanics'),
('spring_mass_system', 'Spring-Mass System and Oscillations', 'Physics - Mechanics'),
('angular_kinematics_rigid_body', 'Angular Displacement, Velocity and Acceleration', 'Physics - Mechanics'),
('torque_basic', 'Torque as r x F', 'Physics - Mechanics'),
('rotational_equilibrium', 'Rotational Equilibrium of Rigid Bodies', 'Physics - Mechanics'),
('moment_of_inertia_definition', 'Definition of Moment of Inertia', 'Physics - Mechanics'),
('moment_of_inertia_standard_bodies', 'Moment of Inertia of Standard Bodies', 'Physics - Mechanics'),
('parallel_axis_theorem', 'Parallel Axis Theorem', 'Physics - Mechanics'),
('perpendicular_axis_theorem', 'Perpendicular Axis Theorem', 'Physics - Mechanics'),
('rotational_kinetic_energy', 'Rotational Kinetic Energy', 'Physics - Mechanics'),
('angular_momentum_rigid_body', 'Angular Momentum of a Rigid Body', 'Physics - Mechanics'),
('conservation_angular_momentum', 'Conservation of Angular Momentum', 'Physics - Mechanics'),
('rolling_without_slipping', 'Rolling Without Slipping', 'Physics - Mechanics'),
('rolling_energy_distribution', 'Energy in Rolling Motion', 'Physics - Mechanics'),
('universal_law_gravitation', 'Newton''s Law of Gravitation', 'Physics - Mechanics'),
('gravitational_field_intensity', 'Gravitational Field and Acceleration', 'Physics - Mechanics'),
('gravitational_potential_energy', 'Gravitational Potential and Potential Energy', 'Physics - Mechanics'),
('acceleration_due_to_gravity_surface', 'Acceleration Due to Gravity at Surface', 'Physics - Mechanics'),
('variation_g_height_depth', 'Variation of g with Height and Depth', 'Physics - Mechanics'),
('keplers_laws', 'Kepler''s Laws of Planetary Motion', 'Physics - Mechanics'),
('orbital_velocity_satellite', 'Orbital Velocity and Time Period of Satellites', 'Physics - Mechanics'),
('energy_of_orbiting_satellite', 'Energy of an Orbiting Satellite', 'Physics - Mechanics'),
('escape_velocity', 'Escape Velocity from a Planet', 'Physics - Mechanics'),
('geostationary_satellites', 'Geostationary and Geosynchronous Satellites', 'Physics - Mechanics');

-- Insert prerequisite relationships
INSERT INTO concept_prerequisites (concept_id, prereq_id) VALUES
('acceleration_due_to_gravity_surface', 'universal_law_gravitation'),
('angular_kinematics_rigid_body', 'uniform_circular_motion_kinematics'),
('angular_momentum_rigid_body', 'angular_kinematics_rigid_body'),
('angular_momentum_rigid_body', 'moment_of_inertia_definition'),
('angular_momentum_rigid_body', 'vectors_cross_product'),
('area_under_curve', 'calculus_integration_basic'),
('calculus_differentiation_basic', 'calculus_limits'),
('calculus_integration_basic', 'calculus_limits'),
('calculus_limits', 'algebra_basic'),
('centre_of_mass_continuous', 'calculus_integration_basic'),
('centre_of_mass_continuous', 'centre_of_mass_discrete'),
('centre_of_mass_discrete', 'conservation_linear_momentum'),
('centre_of_mass_discrete', 'vectors_addition_resolution'),
('circular_motion_dynamics', 'newtons_second_law'),
('circular_motion_dynamics', 'ucm_radial_tangential_acc'),
('coefficient_of_restitution', 'collision_1d'),
('collision_1d', 'conservation_linear_momentum'),
('collision_1d', 'kinetic_energy'),
('collision_2d_oblique', 'collision_1d'),
('collision_2d_oblique', 'vectors_addition_resolution'),
('concept_of_force_inertia', 'kinematics_1d_equations_uniform'),
('conservation_angular_momentum', 'angular_momentum_rigid_body'),
('conservation_energy', 'kinetic_energy'),
('conservation_energy', 'potential_energy_near_earth'),
('conservation_energy', 'work_energy_theorem'),
('conservation_linear_momentum', 'linear_momentum_impulse'),
('conservation_linear_momentum', 'newtons_third_law'),
('coordinate_geometry_2d', 'algebra_basic'),
('coordinate_geometry_2d', 'linear_equations_one_variable'),
('energy_of_orbiting_satellite', 'gravitational_potential_energy'),
('energy_of_orbiting_satellite', 'orbital_velocity_satellite'),
('escape_velocity', 'gravitational_potential_energy'),
('escape_velocity', 'kinetic_energy'),
('free_body_diagrams', 'newtons_second_law'),
('free_body_diagrams', 'scalars_vectors_physics'),
('friction_static_kinetic', 'free_body_diagrams'),
('geostationary_satellites', 'keplers_laws'),
('geostationary_satellites', 'orbital_velocity_satellite'),
('gravitational_field_intensity', 'universal_law_gravitation'),
('gravitational_potential_energy', 'calculus_integration_basic'),
('gravitational_potential_energy', 'universal_law_gravitation'),
('keplers_laws', 'coordinate_geometry_2d'),
('keplers_laws', 'universal_law_gravitation'),
('kinematics_1d_acceleration', 'calculus_differentiation_basic'),
('kinematics_1d_acceleration', 'kinematics_1d_velocity'),
('kinematics_1d_equations_uniform', 'algebra_basic'),
('kinematics_1d_equations_uniform', 'kinematics_1d_acceleration'),
('kinematics_1d_velocity', 'calculus_limits'),
('kinematics_1d_velocity', 'motion_basic_terminology'),
('kinematics_2d_vectors', 'kinematics_1d_velocity'),
('kinematics_2d_vectors', 'vectors_addition_resolution'),
('kinematics_graphs_1d', 'area_under_curve'),
('kinematics_graphs_1d', 'kinematics_1d_velocity'),
('kinetic_energy', 'work_constant_force'),
('linear_equations_one_variable', 'algebra_basic'),
('linear_momentum_impulse', 'calculus_integration_basic'),
('linear_momentum_impulse', 'newtons_second_law'),
('moment_of_inertia_definition', 'angular_kinematics_rigid_body'),
('moment_of_inertia_standard_bodies', 'calculus_integration_basic'),
('moment_of_inertia_standard_bodies', 'moment_of_inertia_definition'),
('motion_basic_terminology', 'coordinate_geometry_2d'),
('motion_basic_terminology', 'units_dimensions'),
('motion_of_centre_of_mass', 'centre_of_mass_discrete'),
('motion_of_centre_of_mass', 'linear_momentum_impulse'),
('motion_on_inclined_plane', 'free_body_diagrams'),
('motion_on_inclined_plane', 'trigonometry_basic_ratios'),
('newtons_first_law', 'concept_of_force_inertia'),
('newtons_second_law', 'concept_of_force_inertia'),
('newtons_second_law', 'kinematics_1d_acceleration'),
('newtons_second_law', 'scalars_vectors_physics'),
('newtons_third_law', 'concept_of_force_inertia'),
('newtons_third_law', 'scalars_vectors_physics'),
('normal_reaction_tension', 'free_body_diagrams'),
('orbital_velocity_satellite', 'circular_motion_dynamics'),
('orbital_velocity_satellite', 'universal_law_gravitation'),
('parallel_axis_theorem', 'moment_of_inertia_definition'),
('perpendicular_axis_theorem', 'moment_of_inertia_definition'),
('potential_energy_near_earth', 'work_constant_force'),
('potential_energy_spring', 'work_variable_force'),
('power_instantaneous', 'calculus_differentiation_basic'),
('power_instantaneous', 'work_constant_force'),
('projectile_motion', 'kinematics_2d_vectors'),
('projectile_motion', 'trigonometry_identities'),
('pseudo_force_non_inertial', 'kinematics_1d_acceleration'),
('pseudo_force_non_inertial', 'newtons_second_law'),
('pulley_block_systems', 'free_body_diagrams'),
('pulley_block_systems', 'motion_on_inclined_plane'),
('quadratic_equations', 'algebra_basic'),
('relative_velocity_1d', 'kinematics_1d_velocity'),
('relative_velocity_2d', 'relative_velocity_1d'),
('relative_velocity_2d', 'vectors_addition_resolution'),
('rolling_energy_distribution', 'rolling_without_slipping'),
('rolling_energy_distribution', 'rotational_kinetic_energy'),
('rolling_without_slipping', 'angular_kinematics_rigid_body'),
('rolling_without_slipping', 'friction_static_kinetic'),
('rotational_equilibrium', 'free_body_diagrams'),
('rotational_equilibrium', 'torque_basic'),
('rotational_kinetic_energy', 'angular_kinematics_rigid_body'),
('rotational_kinetic_energy', 'moment_of_inertia_definition'),
('scalars_vectors_physics', 'vectors_basics_scalars_vectors'),
('shm_basics', 'calculus_differentiation_basic'),
('shm_basics', 'newtons_second_law'),
('shm_basics', 'trigonometry_identities'),
('shm_energy', 'conservation_energy'),
('shm_energy', 'potential_energy_spring'),
('shm_energy', 'shm_basics'),
('spring_mass_system', 'potential_energy_spring'),
('spring_mass_system', 'shm_basics'),
('torque_basic', 'free_body_diagrams'),
('torque_basic', 'vectors_cross_product'),
('trigonometry_basic_ratios', 'algebra_basic'),
('trigonometry_identities', 'trigonometry_basic_ratios'),
('ucm_radial_tangential_acc', 'calculus_differentiation_basic'),
('ucm_radial_tangential_acc', 'uniform_circular_motion_kinematics'),
('uniform_circular_motion_kinematics', 'kinematics_2d_vectors'),
('uniform_circular_motion_kinematics', 'trigonometry_basic_ratios'),
('units_dimensions', 'algebra_basic'),
('universal_law_gravitation', 'newtons_third_law'),
('universal_law_gravitation', 'scalars_vectors_physics'),
('variation_g_height_depth', 'acceleration_due_to_gravity_surface'),
('variation_g_height_depth', 'calculus_differentiation_basic'),
('vectors_addition_resolution', 'trigonometry_basic_ratios'),
('vectors_addition_resolution', 'vectors_basics_scalars_vectors'),
('vectors_basics_scalars_vectors', 'coordinate_geometry_2d'),
('vectors_cross_product', 'vectors_addition_resolution'),
('vectors_dot_product', 'vectors_addition_resolution'),
('vehicle_on_banked_road', 'circular_motion_dynamics'),
('vehicle_on_banked_road', 'trigonometry_basic_ratios'),
('vehicle_on_level_curve', 'circular_motion_dynamics'),
('vehicle_on_level_curve', 'friction_static_kinetic'),
('work_constant_force', 'newtons_second_law'),
('work_constant_force', 'vectors_dot_product'),
('work_energy_theorem', 'kinetic_energy'),
('work_energy_theorem', 'work_constant_force'),
('work_variable_force', 'area_under_curve'),
('work_variable_force', 'calculus_integration_basic'),
('work_variable_force', 'work_constant_force');
