# Implementation Plan: MVP Coaching Center Platform

## Overview

This plan extends the existing Learn.ai Node.js/Express monolith with multi-tenancy, a question ingestion pipeline, and a teacher dashboard. Tasks are ordered so each step builds on the previous: schema first, then auth middleware, then routes and views, then dashboard analytics. All code is JavaScript (Node.js) with EJS views and PostgreSQL.

## Tasks

- [x] 1. Database schema migration and new tables
  - [x] 1.1 Create the schema migration SQL file
    - Create `migrations/001_institute_multi_tenancy.sql` with:
    - `CREATE TYPE subscription_status AS ENUM ('trial', 'active', 'suspended', 'cancelled')`
    - `CREATE TYPE upload_job_status AS ENUM ('processing', 'completed', 'failed')`
    - `CREATE TABLE institutes` with columns: id, name, slug, contact_email, subscription_status, max_students, created_at, updated_at
    - `CREATE TABLE batches` with columns: id, institute_id (FK), name, created_at
    - `CREATE TABLE batch_students` with composite PK (batch_id, user_id), FKs with ON DELETE CASCADE
    - `CREATE TABLE upload_jobs` with columns: id, institute_id, uploaded_by, filename, total_rows, processed_rows, failed_rows, status, error_log (JSONB DEFAULT '[]'), created_at, completed_at
    - `ALTER TABLE users ADD COLUMN institute_id INTEGER REFERENCES institutes(id)`
    - `ALTER TABLE questions ADD COLUMN institute_id INTEGER REFERENCES institutes(id)`
    - `ALTER TABLE questions ADD COLUMN concept_confidence NUMERIC(3,2)`
    - `ALTER TABLE questions ADD COLUMN needs_review_tag BOOLEAN DEFAULT false`
    - `ALTER TABLE questions ALTER COLUMN concept_id DROP NOT NULL`
    - Add indexes: idx_users_institute, idx_questions_institute, idx_questions_status_institute, idx_batch_students_user, idx_upload_jobs_institute, idx_user_concept_mastery_mastery
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 4.6_

  - [x] 1.2 Update `database_setup.sql` to include new tables and columns for fresh installs
    - Add the enum types, new tables, altered columns, and indexes into the existing `database_setup.sql` so new environments get the full schema
    - Ensure `concept_id` on `questions` is nullable in the CREATE TABLE statement
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 4.6_

- [x] 2. Authentication middleware and role extensions
  - [x] 2.1 Add institute-scoped middleware functions in `app.js`
    - Add `ensureInstituteAdmin(req, res, next)` — allows only `institute_admin` with non-null `institute_id`
    - Add `ensureInstituteUser(req, res, next)` — allows `teacher` and `institute_admin` with non-null `institute_id`
    - Both return 403 Forbidden on failure
    - Place these after the existing `ensureAuthenticated` and `ensureAdmin` functions
    - _Requirements: 10.4, 10.5_

  - [ ]* 2.2 Write property test for institute access control
    - **Property 22: Institute Access Control**
    - Test that for any user/role/institute combination, access is granted iff user's institute_id matches target OR user role is admin; all others get 403
    - **Validates: Requirements 10.4, 10.5**

- [x] 3. Institute registration and management
  - [x] 3.1 Implement `POST /institute/register` and `GET /institute/register` routes
    - GET renders `views/institute-register.ejs` with form fields: institute name, contact email, admin name, admin email, admin password
    - POST handler: generate slug from institute name (lowercase, hyphenated), validate uniqueness of slug and admin email
    - On success: INSERT into `institutes` with `subscription_status = 'trial'`, INSERT into `users` with `role = 'institute_admin'` and `institute_id` set, redirect to `/institute/dashboard`
    - On duplicate slug or email: flash error, re-render form, create no records
    - _Requirements: 2.1, 2.2, 2.3_

  - [x] 3.2 Create `views/institute-register.ejs` registration form
    - Form with fields: institute name, contact email, admin name, admin email, admin password
    - Display flash error messages for validation failures
    - _Requirements: 2.1, 2.3_

  - [ ]* 3.3 Write property test for registration
    - **Property 3: Registration Creates Trial Institute and Admin**
    - For any valid payload (unique slug, unique email), verify exactly one institute with status 'trial' and one user with role 'institute_admin' are created
    - **Validates: Requirements 2.2**

  - [ ]* 3.4 Write property test for duplicate registration rejection
    - **Property 4: Duplicate Registration Rejection**
    - For any registration where slug or email already exists, verify no new records are created
    - **Validates: Requirements 2.3**

- [x] 4. Institute dashboard and user onboarding
  - [x] 4.1 Implement `GET /institute/dashboard` route with `ensureInstituteAdmin` middleware
    - Query institute name, subscription_status, count of teachers, count of students, count of approved questions (all scoped to institute_id)
    - Render `views/institute-dashboard.ejs` with these stats
    - _Requirements: 2.4, 2.5_

  - [x] 4.2 Create `views/institute-dashboard.ejs`
    - Display institute name, subscription status, teacher count, student count, approved question count
    - Navigation links to invite, batches, upload, review, teacher dashboard
    - _Requirements: 2.4, 2.5_

  - [x] 4.3 Implement `GET/POST /institute/invite` with `ensureInstituteAdmin` middleware
    - GET renders `views/institute-invite.ejs` with form: email, role (teacher/student)
    - POST: validate email not already in a different institute, create user with selected role and `institute_id` from req.user, generate a temporary password (bcrypt hashed)
    - Reject if email belongs to user in different institute with descriptive error
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [x] 4.4 Create `views/institute-invite.ejs`
    - Form with email field and role dropdown (teacher/student)
    - Display flash messages for success/error
    - _Requirements: 3.1_

  - [ ]* 4.5 Write property test for cross-institute invitation rejection
    - **Property 5: Cross-Institute Invitation Rejection**
    - For any invitation where target email belongs to a user in a different institute, verify rejection and no new user created
    - **Validates: Requirements 3.4**

  - [ ]* 4.6 Write property test for institute ID propagation
    - **Property 1: Institute ID Propagation**
    - For any user created within an institute, verify the user's institute_id equals the creating admin's institute_id
    - **Validates: Requirements 1.7, 1.8, 3.2, 3.3**

- [x] 5. Batch management
  - [x] 5.1 Implement `GET/POST /institute/batches` with `ensureInstituteAdmin` middleware
    - GET: query batches for the admin's institute, render `views/institute-batches.ejs` with batch list and students per batch
    - POST (create batch): insert into `batches` with institute_id from req.user
    - POST (assign students): insert into `batch_students`, validate each student's institute_id matches the batch's institute
    - _Requirements: 3.5, 1.4, 1.5_

  - [x] 5.2 Create `views/institute-batches.ejs`
    - Form to create new batch (name field)
    - List existing batches with student assignment UI (checkboxes for institute students)
    - _Requirements: 3.5_

  - [ ]* 5.3 Write property test for batch student assignment integrity
    - **Property 6: Batch Student Assignment Integrity**
    - For any batch and set of student IDs, verify exactly one row per (batch_id, user_id) and all students have matching institute_id
    - **Validates: Requirements 3.5**

- [x] 6. Checkpoint — Schema, auth, registration, and batch management
  - Ensure all tests pass, ask the user if questions arise.

- [x] 7. Question bulk upload and CSV/XLSX parsing
  - [x] 7.1 Install `xlsx` dependency and create file parsing utility
    - Run `npm install xlsx`
    - Create `services/fileParser.js` with `parseUploadedFile(buffer, filename)` function
    - Use `XLSX.read(buffer, { type: 'buffer' })` to parse both CSV and XLSX
    - Return array of row objects with column headers as keys
    - _Requirements: 4.2, 4.3_

  - [x] 7.2 Implement `GET/POST /institute/questions/upload` with `ensureInstituteUser` middleware
    - GET: render `views/institute-upload.ejs` with upload form
    - POST: use multer with 10MB file size limit, accept only .csv and .xlsx extensions
    - Validate each row for required fields: question_text, option1–option4, correct_answer
    - For valid rows: INSERT into `questions` with status='pending', institute_id from req.user, concept_id=null
    - Create `upload_jobs` record tracking total_rows, processed_rows, failed_rows
    - Report row-level errors in the upload summary
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

  - [x] 7.3 Create `views/institute-upload.ejs`
    - File upload form (accept .csv, .xlsx)
    - Display upload summary after POST: total rows, successful inserts, failed rows with error details
    - _Requirements: 4.1, 4.7_

  - [ ]* 7.4 Write property test for upload file validation
    - **Property 7: Upload File Validation**
    - For any file exceeding 10MB or with invalid extension, verify rejection and no records created
    - **Validates: Requirements 4.2**

  - [ ]* 7.5 Write property test for row validation error reporting
    - **Property 8: Row Validation Error Reporting**
    - For any row missing required fields, verify error reported for that row number and no question inserted
    - **Validates: Requirements 4.4**

  - [ ]* 7.6 Write property test for upload summary count accuracy
    - **Property 9: Upload Summary Count Accuracy**
    - For any completed upload, verify total_rows == processed_rows + failed_rows
    - **Validates: Requirements 4.7**

- [x] 8. AI concept auto-tagging
  - [x] 8.1 Create `services/conceptTagger.js` with AI classification function
    - Implement `classifyQuestionConcept(questionText, topicHint, conceptList)` using existing `geminiGenerate`
    - Build system prompt with all 81 concept IDs and names as classification targets
    - Include topic_hint in user prompt when provided
    - Parse JSON response, extract concept_id and confidence
    - Set 10-second timeout on the AI call
    - _Requirements: 5.1, 5.2, 5.3, 5.6_

  - [x] 8.2 Integrate AI tagging into the upload POST handler
    - After inserting each valid question row, call `classifyQuestionConcept`
    - If confidence >= 0.6: UPDATE question SET concept_id, concept_confidence, needs_review_tag=false
    - If confidence < 0.6: UPDATE question SET concept_id, concept_confidence, needs_review_tag=true
    - If AI fails/timeout: leave concept_id null, status='pending', append error to upload_job.error_log
    - Update upload_jobs.processed_rows after each row
    - _Requirements: 5.1, 5.3, 5.4, 5.5_

  - [ ]* 8.3 Write property test for AI classification result handling
    - **Property 10: AI Classification Result Handling**
    - For any AI response, verify concept_id is set, concept_confidence matches, and needs_review_tag is true iff confidence < 0.6
    - **Validates: Requirements 5.3, 5.4**

  - [ ]* 8.4 Write property test for AI failure graceful handling
    - **Property 11: AI Failure Graceful Handling**
    - For any failed/timed-out AI call, verify concept_id remains null, status remains pending, and error_log has an entry
    - **Validates: Requirements 5.5**

- [x] 9. Question review queue
  - [x] 9.1 Implement `GET /institute/questions/review` with `ensureInstituteUser` middleware
    - Query pending questions scoped to user's institute_id, ordered by created_at ASC
    - Include question text, options, correct answer, solution, AI-assigned concept (with confidence), difficulty, source metadata
    - Query review stats: count of pending, approved, rejected for the institute
    - Render `views/institute-review.ejs`
    - _Requirements: 6.1, 6.2, 6.3, 6.7_

  - [x] 9.2 Implement `POST /institute/questions/review/:id` with `ensureInstituteUser` middleware
    - Accept action: approve, reject, or edit-then-approve
    - Approve: SET status='approved', verified_by=req.user.id, verified_at=now()
    - Reject: SET status='rejected', verified_by=req.user.id, verified_at=now()
    - Edit: update concept_id, difficulty_tier, question_text as submitted, then approve
    - Validate question belongs to user's institute before acting
    - _Requirements: 6.4, 6.5, 6.6_

  - [x] 9.3 Create `views/institute-review.ejs`
    - Display pending questions with all metadata, approve/reject/edit buttons
    - Show review queue statistics (pending/approved/rejected counts)
    - Edit form for concept_id (dropdown of 81 concepts), difficulty_tier, question_text
    - _Requirements: 6.1, 6.3, 6.7_

  - [ ]* 9.4 Write property test for review action state transition
    - **Property 12: Review Action State Transition**
    - For any review action on a pending question, verify status, verified_by, verified_at, and edited fields are correctly set
    - **Validates: Requirements 6.4, 6.5, 6.6**

  - [ ]* 9.5 Write property test for review queue statistics accuracy
    - **Property 13: Review Queue Statistics Accuracy**
    - For any institute, verify pending + approved + rejected == total questions for that institute
    - **Validates: Requirements 6.7**

- [ ] 10. Checkpoint — Upload pipeline and review queue
  - Ensure all tests pass, ask the user if questions arise.

- [x] 11. Teacher dashboard — batch mastery heatmap
  - [x] 11.1 Implement `GET /institute/dashboard/teacher` with `ensureInstituteUser` middleware
    - Query batches for the user's institute
    - When a batch is selected (query param `batchId`), run the heatmap aggregation query:
      - JOIN batch_students, users, CROSS JOIN concepts, LEFT JOIN user_concept_mastery
      - Default mastery to 0.2 where no record exists
    - Support subject filter query param to filter concepts
    - Compute batch-average mastery per concept as a summary row
    - Render `views/institute-teacher-dashboard.ejs`
    - _Requirements: 7.1, 7.2, 7.4, 7.5_

  - [x] 11.2 Create `views/institute-teacher-dashboard.ejs`
    - Batch selector dropdown
    - Subject filter dropdown (Mathematics, Physics - Mechanics)
    - Heatmap table: students as rows, concepts as columns, cells color-coded (red < 0.4, yellow 0.4–0.7, green >= 0.7)
    - Batch-average summary row at top
    - Client-side JS for color-coding cells based on mastery values
    - _Requirements: 7.2, 7.3, 7.4, 7.5_

  - [ ]* 11.3 Write property test for heatmap data completeness
    - **Property 14: Heatmap Data Completeness**
    - For any batch with N students and M concepts, verify exactly N × M entries with default 0.2 for missing mastery
    - **Validates: Requirements 7.2**

  - [ ]* 11.4 Write property test for heatmap color coding
    - **Property 15: Heatmap Color Coding**
    - For any mastery value, verify: red if < 0.4, yellow if 0.4 ≤ m < 0.7, green if ≥ 0.7
    - **Validates: Requirements 7.3**

  - [ ]* 11.5 Write property test for heatmap subject filtering
    - **Property 16: Heatmap Subject Filtering**
    - For any subject filter, verify all returned concepts match the filter and no matching concepts are excluded
    - **Validates: Requirements 7.4**

  - [ ]* 11.6 Write property test for batch average mastery correctness
    - **Property 17: Batch Average Mastery Correctness**
    - For any batch and concept, verify the average equals arithmetic mean of all students' mastery (default 0.2)
    - **Validates: Requirements 7.5**

- [x] 12. Teacher dashboard — stuck students and prerequisite gaps
  - [x] 12.1 Add stuck students panel to the teacher dashboard route
    - Query user_concept_mastery WHERE institute_id matches, mastery < 0.5, questions_answered > 10
    - ORDER BY mastery ASC
    - Include student name, concept name, mastery, questions_answered, correct_answers
    - Add stuck students data to the teacher dashboard render
    - _Requirements: 8.1, 8.2, 8.3, 8.5_

  - [x] 12.2 Implement `GET /institute/dashboard/teacher/gaps/:userId/:conceptId` with `ensureInstituteUser` middleware
    - Validate the target student belongs to the teacher's institute
    - Call existing `checkPrerequisiteGaps(db, userId, conceptId)` from `services/prerequisiteService.js`
    - Call existing `getOptimalLearningPath(db, userId, conceptId)` from `services/prerequisiteService.js`
    - Render `views/institute-prereq-gaps.ejs` with gaps list and learning path
    - _Requirements: 8.4, 9.1, 9.2, 9.3_

  - [x] 12.3 Create `views/institute-prereq-gaps.ejs`
    - Display prerequisite gaps ordered by depth (deepest first), with concept name, mastery, depth
    - Color-code: red for gaps (mastery < 0.7), green for mastered
    - Display recommended learning path as ordered sequence
    - _Requirements: 9.2, 9.3, 9.4_

  - [x] 12.4 Update `views/institute-teacher-dashboard.ejs` to include stuck students panel
    - Stuck students table with columns: student name, concept, mastery, questions answered, correct answers
    - Each row links to `/institute/dashboard/teacher/gaps/:userId/:conceptId`
    - _Requirements: 8.1, 8.3_

  - [ ]* 12.5 Write property test for stuck student detection
    - **Property 18: Stuck Student Detection**
    - For any set of mastery records, verify stuck list contains exactly those with mastery < 0.5 AND questions_answered > 10, scoped to institute
    - **Validates: Requirements 8.1, 8.5**

  - [ ]* 12.6 Write property test for stuck students ordering
    - **Property 19: Stuck Students Ordering**
    - For any stuck students list, verify sorted by mastery ascending
    - **Validates: Requirements 8.2**

  - [ ]* 12.7 Write property test for prerequisite gaps depth ordering
    - **Property 20: Prerequisite Gaps Depth Ordering**
    - For any student and concept, verify gaps ordered by depth descending and all have mastery < 0.7
    - **Validates: Requirements 9.1, 9.2**

  - [ ]* 12.8 Write property test for learning path structure
    - **Property 21: Learning Path Structure**
    - For any student and target concept, verify path ends with target and all intermediate concepts have mastery < 0.7
    - **Validates: Requirements 9.3**

- [x] 13. Data isolation and question scoping
  - [x] 13.1 Update existing question queries in practice and mastery mode routes
    - Modify `getQuestionFromDB` in `app.js` to accept an optional `instituteId` parameter
    - When `instituteId` is provided, add `AND (institute_id = $N OR institute_id IS NULL)` to the WHERE clause
    - Pass `req.user.institute_id` from practice and mastery route handlers
    - _Requirements: 3.6, 10.1, 10.3_

  - [x] 13.2 Add institute scoping to all teacher/student data queries
    - Ensure all mastery queries in dashboard routes filter by `u.institute_id = req.user.institute_id`
    - Ensure review queue queries filter by `q.institute_id = req.user.institute_id`
    - Verify cross-institute access returns 403 on all institute routes
    - _Requirements: 10.1, 10.2, 10.4_

  - [x] 13.3 Ensure platform admin retains full access
    - In `ensureInstituteUser` and `ensureInstituteAdmin`, also allow `role = 'admin'` to pass through
    - Admin queries should not filter by institute_id
    - _Requirements: 10.5_

  - [ ]* 13.4 Write property test for data isolation scoping
    - **Property 2: Data Isolation Scoping**
    - For any institute-scoped query by a user with non-null institute_id, verify every returned record has matching institute_id or institute_id IS NULL
    - **Validates: Requirements 3.6, 10.1, 10.3, 11.3**

- [ ] 14. Institute-scoped question statistics API
  - [~] 14.1 Implement `GET /api/institute/questions/stats` with `ensureInstituteUser` middleware
    - Query and return JSON: total questions, count by status (pending/approved/rejected), count by concept, count by difficulty_tier, count uploaded in last 7 days
    - All scoped to `req.user.institute_id`
    - _Requirements: 11.1, 11.2, 11.3_

- [ ] 15. Final checkpoint — Full integration
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document (22 properties total)
- The `xlsx` package is the only new dependency needed
- All new routes follow the existing Express/EJS pattern in `app.js`
- Existing `geminiGenerate`, `checkPrerequisiteGaps`, and `getOptimalLearningPath` functions are reused directly
