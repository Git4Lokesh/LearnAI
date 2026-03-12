# Requirements Document

## Introduction

This document defines the MVP requirements for transforming the existing Learn.ai adaptive learning platform into a B2B2C SaaS product for JEE coaching centers. The platform currently serves individual students with BKT-based adaptive learning, knowledge graphs (81 concepts with prerequisites), quiz generation, flashcards, quicknotes, chat, group study, practice mode, and mastery mode. The MVP adds three pillars needed to sell to coaching centers and pitch to investors: multi-tenancy (institute accounts), a question ingestion pipeline (bulk upload with AI concept-tagging), and a teacher/admin dashboard (batch-level mastery analytics).

## Glossary

- **Platform**: The Learn.ai Node.js/Express web application and its PostgreSQL database
- **Institute**: A coaching center organization that subscribes to the Platform; the top-level tenant entity
- **Institute_Admin**: A user with role `institute_admin` who manages an Institute's settings, teachers, and students
- **Teacher**: A user with role `teacher` scoped to an Institute, who reviews questions and views student analytics
- **Student**: A user with role `student` scoped to an Institute, who uses adaptive learning features
- **Batch**: A named grouping of Students within an Institute (e.g., "JEE 2026 Batch A")
- **Question_Ingestion_Pipeline**: The end-to-end flow from CSV/Excel upload through AI concept-tagging to admin review
- **Concept**: One of the 81 knowledge-graph nodes (e.g., `projectile_motion`) stored in the `concepts` table
- **Mastery**: A numeric value (0.0–1.0) representing a Student's BKT-computed proficiency on a Concept
- **Upload_Job**: A record tracking a single bulk question upload through its processing stages
- **Review_Queue**: The set of uploaded questions awaiting Teacher or Institute_Admin approval
- **Heatmap**: A visual matrix showing Mastery levels across Students (rows) and Concepts (columns)
- **Stuck_Student**: A Student with Mastery below 0.5 and more than 10 attempts on a given Concept
- **Prerequisite_Gap**: A Concept whose Mastery is below 0.7 that is a prerequisite of a target Concept the Student is working on

## Requirements

### Requirement 1: Institute Entity and Multi-Tenancy Schema

**User Story:** As a platform operator, I want coaching centers to exist as first-class entities in the database, so that users, questions, and data are scoped per institute.

#### Acceptance Criteria

1. THE Platform SHALL provide an `institutes` table with columns: `id` (serial primary key), `name` (text, not null), `slug` (varchar, unique, not null), `contact_email` (text), `subscription_status` (enum: trial, active, suspended, cancelled), `max_students` (integer, default 500), `created_at` (timestamptz), `updated_at` (timestamptz)
2. THE Platform SHALL add an `institute_id` (integer, nullable, foreign key to `institutes.id`) column to the `users` table
3. THE Platform SHALL add an `institute_id` (integer, nullable, foreign key to `institutes.id`) column to the `questions` table
4. THE Platform SHALL provide a `batches` table with columns: `id` (serial primary key), `institute_id` (integer, not null, foreign key to `institutes.id`), `name` (varchar, not null), `created_at` (timestamptz)
5. THE Platform SHALL provide a `batch_students` table with columns: `batch_id` (integer, foreign key to `batches.id`), `user_id` (integer, foreign key to `users.id`), primary key on both columns
6. THE Platform SHALL extend the `users.role` column to support values: `student`, `teacher`, `institute_admin`, `admin`
7. WHEN a Student is created within an Institute, THE Platform SHALL set the Student's `institute_id` to that Institute's id
8. WHEN a Question is uploaded by an Institute user, THE Platform SHALL set the Question's `institute_id` to that user's Institute

### Requirement 2: Institute Registration and Management

**User Story:** As a coaching center owner, I want to register my institute on the platform, so that I can onboard my teachers and students.

#### Acceptance Criteria

1. THE Platform SHALL provide a `/institute/register` page with fields: institute name, contact email, and admin user details (name, email, password)
2. WHEN an institute registration form is submitted with valid data, THE Platform SHALL create an Institute record with `subscription_status` set to `trial` and create an Institute_Admin user linked to that Institute
3. IF the institute slug or admin email already exists, THEN THE Platform SHALL display a descriptive error message without creating any records
4. THE Platform SHALL provide an `/institute/dashboard` page accessible only to Institute_Admin users
5. WHEN an Institute_Admin visits the institute dashboard, THE Platform SHALL display: institute name, subscription status, count of teachers, count of students, and count of approved questions

### Requirement 3: User Onboarding Within an Institute

**User Story:** As an Institute_Admin, I want to add teachers and students to my institute, so that they can use the platform under my organization.

#### Acceptance Criteria

1. THE Platform SHALL provide an `/institute/invite` page accessible to Institute_Admin users
2. WHEN an Institute_Admin submits a teacher invitation with a valid email, THE Platform SHALL create a user with role `teacher` and `institute_id` set to the Institute_Admin's institute
3. WHEN an Institute_Admin submits a student invitation with a valid email, THE Platform SHALL create a user with role `student` and `institute_id` set to the Institute_Admin's institute
4. IF the invited email already belongs to a user in a different Institute, THEN THE Platform SHALL reject the invitation with a descriptive error
5. WHEN an Institute_Admin creates a Batch and assigns Students to the Batch, THE Platform SHALL insert records into `batch_students` linking each Student to the Batch
6. WHILE a Student belongs to an Institute, THE Platform SHALL scope the Student's practice and mastery mode to show only questions where `questions.institute_id` matches the Student's `institute_id` OR `questions.institute_id IS NULL` (shared platform questions)

### Requirement 4: Question Bulk Upload

**User Story:** As a Teacher at a coaching center, I want to upload questions in bulk via CSV or Excel, so that I can quickly populate the question bank for my institute.

#### Acceptance Criteria

1. THE Platform SHALL provide a `/institute/questions/upload` page accessible to Teacher and Institute_Admin users
2. THE Platform SHALL accept CSV and XLSX file uploads with a maximum file size of 10 MB
3. THE Platform SHALL expect uploaded files to contain columns: `question_text`, `option1`, `option2`, `option3`, `option4`, `correct_answer`, `solution_text` (optional), `difficulty_tier` (optional, default 2), `source` (optional), `source_year` (optional), `source_paper` (optional), `topic_hint` (optional)
4. WHEN a file is uploaded, THE Platform SHALL validate each row for required fields (`question_text`, `option1`–`option4`, `correct_answer`) and report row-level errors to the user
5. WHEN a row passes validation, THE Platform SHALL insert a question record with `status` set to `pending`, `institute_id` set to the uploader's institute, and `concept_id` left null pending AI tagging
6. THE Platform SHALL provide an `upload_jobs` table with columns: `id` (serial primary key), `institute_id` (integer, foreign key), `uploaded_by` (integer, foreign key to users), `filename` (text), `total_rows` (integer), `processed_rows` (integer, default 0), `failed_rows` (integer, default 0), `status` (enum: processing, completed, failed), `created_at` (timestamptz), `completed_at` (timestamptz)
7. WHEN an upload completes, THE Platform SHALL display a summary showing total rows, successfully inserted rows, and failed rows with error details

### Requirement 5: AI Concept Auto-Tagging

**User Story:** As a Teacher, I want uploaded questions to be automatically tagged with the correct concept from the knowledge graph, so that I do not have to manually classify each question.

#### Acceptance Criteria

1. WHEN a question is inserted with `concept_id` null and `status` pending, THE Platform SHALL send the question text and topic_hint to the Gemini AI API for concept classification
2. THE Platform SHALL provide the AI with the full list of 81 concept IDs and names as classification targets
3. WHEN the AI returns a concept classification, THE Platform SHALL set the question's `concept_id` to the matched concept and set a `concept_confidence` field (numeric 0.0–1.0) on the question
4. IF the AI returns a confidence below 0.6, THEN THE Platform SHALL flag the question with `needs_review_tag` set to true
5. IF the AI call fails or times out after 10 seconds, THEN THE Platform SHALL leave `concept_id` null and set the question status to `pending` with a note in the upload job's error log
6. IF the `topic_hint` column is provided, THEN THE Platform SHALL include the topic hint in the AI prompt to improve classification accuracy

### Requirement 6: Question Review Queue

**User Story:** As a Teacher or Institute_Admin, I want to review uploaded questions before they go live, so that I can ensure quality and correct concept tagging.

#### Acceptance Criteria

1. THE Platform SHALL provide a `/institute/questions/review` page accessible to Teacher and Institute_Admin users
2. WHEN a Teacher visits the review page, THE Platform SHALL display pending questions scoped to the Teacher's institute, ordered by upload date ascending
3. THE Platform SHALL display each pending question with: question text, options, correct answer, solution text, AI-assigned concept (with confidence score), difficulty tier, and source metadata
4. WHEN a reviewer approves a question, THE Platform SHALL set the question's `status` to `approved`, `verified_by` to the reviewer's user id, and `verified_at` to the current timestamp
5. WHEN a reviewer rejects a question, THE Platform SHALL set the question's `status` to `rejected`, `verified_by` to the reviewer's user id, and `verified_at` to the current timestamp
6. WHEN a reviewer edits a question's concept_id, difficulty_tier, or text fields before approving, THE Platform SHALL save the edited values and set `status` to `approved`
7. THE Platform SHALL display review queue statistics: count of pending, approved, and rejected questions for the institute

### Requirement 7: Teacher Dashboard — Batch Mastery Heatmap

**User Story:** As a Teacher, I want to see a heatmap of concept mastery across all students in a batch, so that I can identify which concepts need more classroom attention.

#### Acceptance Criteria

1. THE Platform SHALL provide a `/institute/dashboard/teacher` page accessible to Teacher and Institute_Admin users
2. WHEN a Teacher selects a Batch, THE Platform SHALL display a heatmap matrix with Students as rows and Concepts as columns, where each cell shows the Student's Mastery value for that Concept
3. THE Platform SHALL color-code heatmap cells: red for Mastery below 0.4, yellow for Mastery between 0.4 and 0.7, green for Mastery at or above 0.7
4. THE Platform SHALL allow filtering the heatmap by subject (Mathematics, Physics - Mechanics)
5. THE Platform SHALL compute and display a batch-average Mastery value for each Concept as a summary row at the top of the heatmap

### Requirement 8: Teacher Dashboard — Stuck Students Detection

**User Story:** As a Teacher, I want to identify students who are struggling on specific concepts, so that I can provide targeted intervention.

#### Acceptance Criteria

1. WHEN a Teacher views the teacher dashboard, THE Platform SHALL display a "Stuck Students" panel listing Students whose Mastery is below 0.5 and who have answered more than 10 questions on a given Concept
2. THE Platform SHALL sort stuck students by Mastery ascending, showing the most struggling students first
3. THE Platform SHALL display for each stuck student: student name, concept name, current Mastery value, total questions answered, and correct answer count
4. WHEN a Teacher clicks on a stuck student entry, THE Platform SHALL display the prerequisite gap analysis for that student on that concept using the existing `checkPrerequisiteGaps` function
5. THE Platform SHALL scope stuck student detection to students within the Teacher's institute

### Requirement 9: Teacher Dashboard — Prerequisite Gap Analysis

**User Story:** As a Teacher, I want to see which prerequisite concepts a struggling student is missing, so that I can recommend a remediation path.

#### Acceptance Criteria

1. WHEN a Teacher requests prerequisite gap analysis for a Student on a Concept, THE Platform SHALL use the existing recursive prerequisite chain query to identify all prerequisite Concepts with Mastery below 0.7
2. THE Platform SHALL display prerequisite gaps as a list ordered by depth (deepest prerequisite first), showing: concept name, current Mastery, and depth in the prerequisite chain
3. THE Platform SHALL display a recommended learning path generated by the existing `getOptimalLearningPath` function, showing the ordered sequence of concepts the Student should study
4. THE Platform SHALL provide a visual representation of the prerequisite chain highlighting gaps in red and mastered prerequisites in green

### Requirement 10: Data Isolation and Access Control

**User Story:** As a platform operator, I want institute data to be properly isolated, so that one coaching center cannot see another's students or questions.

#### Acceptance Criteria

1. WHILE a Teacher is logged in, THE Platform SHALL restrict all question queries to return only questions where `institute_id` matches the Teacher's institute or `institute_id IS NULL`
2. WHILE a Teacher is logged in, THE Platform SHALL restrict student mastery queries to return only students whose `institute_id` matches the Teacher's institute
3. WHILE a Student is logged in, THE Platform SHALL restrict question selection in practice and mastery modes to questions where `institute_id` matches the Student's institute or `institute_id IS NULL`
4. IF a user attempts to access an institute dashboard or review queue for an institute other than their own, THEN THE Platform SHALL return a 403 Forbidden response
5. THE Platform SHALL ensure that the existing `admin` role (platform-level) retains access to all institutes' data for platform administration

### Requirement 11: Institute-Scoped Question Statistics API

**User Story:** As an Institute_Admin, I want to see statistics about my institute's question bank, so that I can track content readiness.

#### Acceptance Criteria

1. THE Platform SHALL provide a `/api/institute/questions/stats` endpoint accessible to Institute_Admin and Teacher users
2. WHEN the stats endpoint is called, THE Platform SHALL return: total questions, questions by status (pending, approved, rejected), questions by concept, questions by difficulty tier, and questions uploaded in the last 7 days
3. THE Platform SHALL scope all statistics to the requesting user's institute

