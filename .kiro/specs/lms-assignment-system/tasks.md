# Implementation Plan: LMS Assignment System

## Overview

Implement the LMS Assignment System following the existing Express/EJS/PostgreSQL patterns. The system adds assignment creation (teacher), assignment taking (student, diagnostic-style UI), JEE scoring, BKT mastery updates, notifications on the student dashboard, and a teacher submissions analytics dashboard. Migration 011 creates the new tables. A shared scoring helper is extracted. Routes follow the `routes/assignments.js` pattern. Views follow the diagnostic.ejs test-taking UI pattern.

## Tasks

- [x] 1. Create database migration and shared scoring helper
  - [x] 1.1 Create `migrations/011_assignments.sql` with all new tables, indexes, and foreign keys
    - Create `assignments` table (id, institute_id, batch_id, created_by, title, deadline, created_at)
    - Create `assignment_questions` table (assignment_id, question_id, question_order) with composite PK
    - Create `assignment_submissions` table (id, assignment_id, user_id, score, max_score, time_taken_seconds, started_at, submitted_at) with UNIQUE(assignment_id, user_id)
    - Create `assignment_answers` table (id, submission_id, question_id, selected_option, is_correct)
    - Create `notifications` table (id, user_id, type, reference_id, title, message, is_read, created_at)
    - Add all foreign key constraints and indexes per design document
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7_

  - [x] 1.2 Create `helpers/scoring.js` with `computeJeeScore` function
    - Extract JEE scoring logic: +4 correct, −1 wrong, 0 unanswered
    - Accept questions array and answers object, return { total, correct, incorrect, unanswered, maxScore }
    - maxScore = questions.length × 4
    - _Requirements: 4.1, 4.4_

  - [ ]* 1.3 Write property test for JEE Scoring (Property 1)
    - **Property 1: JEE Scoring Correctness**
    - Generate random question arrays with random answers using fast-check
    - Verify score = 4 × correct_count − 1 × wrong_count, maxScore = questions × 4
    - **Validates: Requirements 4.1, 4.4**

  - [ ]* 1.4 Write property test for Assignment Status Computation (Property 2)
    - **Property 2: Assignment Status Computation**
    - Generate random (deadline, hasSubmission, now) tuples
    - Verify status is "Pending", "Completed", or "Missed" per rules
    - **Validates: Requirements 2.3, 2.4, 2.5, 7.3**

  - [ ]* 1.5 Write property test for Deadline Validation (Property 4)
    - **Property 4: Deadline Validation**
    - Generate random timestamps relative to now
    - Verify past dates rejected, future dates accepted
    - **Validates: Requirements 1.4**

- [x] 2. Checkpoint - Ensure migration and scoring helper are correct
  - Ensure all tests pass, ask the user if questions arise.

- [x] 3. Implement assignment creation routes and view
  - [x] 3.1 Create `routes/assignments.js` with teacher assignment creation endpoints
    - `GET /assignments` — list teacher's assignments (sorted by deadline desc)
    - `GET /assignments/create` — render creation form
    - `POST /assignments/create` — validate inputs (future deadline, at least 1 question, batch belongs to teacher's institute), insert assignment + assignment_questions, create notifications for all batch students, redirect to list
    - `GET /api/assignments/questions` — AJAX endpoint to fetch filtered questions (subject, concept_id, difficulty_tier) scoped to teacher's institute
    - Use `ensureInstituteUser` middleware for teacher routes
    - Auto-associate assignment with teacher's institute_id
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 2.1, 9.1, 9.4_

  - [x] 3.2 Create `views/assignment-create.ejs` — assignment creation form
    - Filter controls for subject, concept_id, difficulty_tier to browse question bank
    - Question list with checkboxes for selection
    - Batch selector (from teacher's institute batches), title input, deadline datetime picker
    - AJAX-driven question filtering
    - _Requirements: 1.1, 1.2, 1.3_

  - [x] 3.3 Create `views/assignment-list.ejs` — teacher's assignment management list
    - Display all assignments with title, batch name, deadline, question count, submission count
    - Sorted by deadline descending
    - Status indicators: active (deadline future), closed (deadline passed), fully submitted
    - Links to submissions dashboard per assignment
    - _Requirements: 7.1, 7.2, 7.3_

  - [ ]* 3.4 Write property test for Question Filter Scoping (Property 3)
    - **Property 3: Question Filter Scoping**
    - Generate random filter combinations and question sets
    - Verify all returned questions match filters and institute scope (approved, correct institute)
    - **Validates: Requirements 1.2**

  - [ ]* 3.5 Write property test for Batch Authorization (Property 5)
    - **Property 5: Batch Authorization**
    - Generate random (teacher_institute, batch_institute) pairs
    - Verify rejection when mismatched
    - **Validates: Requirements 1.6, 9.2**

  - [ ]* 3.6 Write property test for Notification Count (Property 6)
    - **Property 6: Assignment Creation Produces Notifications**
    - Generate random batch sizes
    - Verify notification count equals student count with correct reference_id
    - **Validates: Requirements 2.1, 1.3**

  - [ ]* 3.7 Write property test for Institute Association (Property 13)
    - **Property 13: Institute Auto-Association**
    - Generate random teacher/institute pairs
    - Verify assignment inherits teacher's institute_id
    - **Validates: Requirements 9.1, 9.4**

- [x] 4. Checkpoint - Ensure assignment creation flow works end-to-end
  - Ensure all tests pass, ask the user if questions arise.

- [x] 5. Implement assignment taking (student) routes and view
  - [x] 5.1 Add student assignment-taking endpoints to `routes/assignments.js`
    - `GET /assignments/:id/take` — check deadline not passed, check no existing submission, load questions into session, render test UI
    - `POST /assignments/:id/answer` — save answer to session (AJAX)
    - `POST /assignments/:id/clear` — clear answer from session (AJAX)
    - `POST /assignments/:id/submit` — score with `computeJeeScore`, save submission + answers to DB, trigger BKT updates per concept, log user_question_attempts, handle BKT failure gracefully
    - `GET /assignments/:id/results` — show student's own submission results
    - Enforce student belongs to assignment's batch
    - Reject access after deadline, reject re-submission (redirect to results)
    - Use `ensureAuthenticated` middleware
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4, 9.2_

  - [x] 5.2 Create `views/assignment-take.ejs` — test-taking UI modeled after diagnostic.ejs
    - Question panel with option selection (option1–option4)
    - Question navigation palette showing answered/unanswered/current status
    - Time elapsed display (not countdown — assignments are deadline-bound)
    - Submit button with confirmation dialog
    - AJAX answer saving and clearing
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [ ]* 5.3 Write property test for Submission Idempotency (Property 7)
    - **Property 7: Submission Idempotency**
    - Generate random submissions, attempt double-submit
    - Verify rejection and original submission unchanged
    - **Validates: Requirements 3.6**

  - [ ]* 5.4 Write property test for Question Order Immutability (Property 8)
    - **Property 8: Question Order Immutability**
    - Generate random question sets, verify order preserved across reads
    - **Validates: Requirements 3.7**

  - [ ]* 5.5 Write property test for Submission Record Completeness (Property 9)
    - **Property 9: Submission Record Completeness**
    - Generate random answer sets for Q questions
    - Verify exactly Q assignment_answers records created, one user_question_attempt per answered question
    - **Validates: Requirements 4.2, 5.3**

  - [ ]* 5.6 Write property test for BKT Updates Grouped by Concept (Property 10)
    - **Property 10: BKT Updates Grouped by Concept**
    - Generate random questions across multiple concepts with random answers
    - Verify one BKT call per distinct concept_id with correct correctness data
    - **Validates: Requirements 5.2**

  - [ ]* 5.7 Write property test for Deadline Blocks Access (Property 15)
    - **Property 15: Deadline Blocks Assignment Access**
    - Generate random (deadline, now) pairs where deadline < now
    - Verify access denied
    - **Validates: Requirements 3.5**

- [x] 6. Checkpoint - Ensure assignment taking and submission flow works
  - Ensure all tests pass, ask the user if questions arise.

- [x] 7. Implement dashboard notifications and teacher submissions view
  - [x] 7.1 Add `GET /api/assignments/pending` endpoint to `routes/assignments.js`
    - Return pending assignments for the authenticated student (title, deadline, question count, status)
    - Compute status: Pending, Completed, or Missed per student
    - _Requirements: 2.2, 2.3, 2.4, 2.5_

  - [x] 7.2 Modify `views/dashboard.ejs` to display pending assignments widget
    - Add an assignments section showing pending/completed/missed assignments
    - Fetch from `/api/assignments/pending` via AJAX on page load
    - Show title, deadline, question count, and status badge
    - Link to take assignment or view results
    - _Requirements: 2.2, 2.3, 2.4, 2.5_

  - [x] 7.3 Add teacher submissions dashboard endpoint and view
    - `GET /assignments/:id/submissions` — aggregate scores, concept breakdowns, batch stats
    - Restrict to assignment creator or institute_admin of same institute
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 9.3_

  - [x] 7.4 Create `views/assignment-submissions.ejs` — teacher submissions analytics
    - Student table: name, status (submitted/pending/missed), score, max_score, percentage, time taken
    - Sorted by score descending by default
    - Concept-wise breakdown per student: correct/total/percentage per concept
    - Batch aggregate stats: average score, highest, lowest, average time
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

  - [ ]* 7.5 Write property test for Concept-Wise Breakdown Correctness (Property 11)
    - **Property 11: Concept-Wise Breakdown Correctness**
    - Generate random per-concept answer distributions
    - Verify correct + incorrect + unanswered = total per concept, percentage = correct/total × 100
    - **Validates: Requirements 6.3**

  - [ ]* 7.6 Write property test for Batch Aggregate Statistics (Property 12)
    - **Property 12: Batch Aggregate Statistics**
    - Generate random score arrays
    - Verify avg = sum/count, max, min, avg_time computations
    - **Validates: Requirements 6.4**

  - [ ]* 7.7 Write property test for Submissions Dashboard Authorization (Property 14)
    - **Property 14: Submissions Dashboard Authorization**
    - Generate random (user_role, user_institute, creator_id, assignment_institute) tuples
    - Verify access denied for unauthorized users
    - **Validates: Requirements 9.3**

- [x] 8. Wire assignments route into app.js and final integration
  - [x] 8.1 Register assignments route in `app.js`
    - Import `assignmentRoutes` from `routes/assignments.js`
    - Mount with `app.use(assignmentRoutes)`
    - Add navigation links to teacher dashboard for assignment management
    - _Requirements: 1.1, 7.1_

  - [x] 8.2 Add assignment links to `views/institute-teacher-dashboard.ejs`
    - Add "Assignments" navigation link/button to the teacher dashboard
    - _Requirements: 7.1_

- [x] 9. Final checkpoint - Ensure all tests pass and full integration works
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- The diagnostic.ejs pattern is the primary reference for the assignment-taking UI
- BKT failures are handled gracefully — submissions are saved even if BKT service is down
- Session-based state is used during assignment taking, matching the diagnostic test pattern
