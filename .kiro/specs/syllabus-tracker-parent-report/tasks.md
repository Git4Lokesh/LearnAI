# Implementation Plan: Syllabus Tracker + Parent Report Card

## Overview

Incrementally build the Syllabus Tracker and Parent Report Card features on the existing Node.js/Express monolith. Start with the database migration, then the backend API routes, then the report card service, and finally wire the UI into the existing Teacher Dashboard EJS template.

## Tasks

- [x] 1. Database migration and dependency setup
  - [x] 1.1 Create `migrations/009_syllabus_tracker.sql` with the `chapter_teaching_status` table
    - Table columns: `id SERIAL PRIMARY KEY`, `chapter_id VARCHAR(100) NOT NULL REFERENCES chapters(id) ON DELETE CASCADE`, `batch_id INTEGER NOT NULL REFERENCES batches(id) ON DELETE CASCADE`, `teacher_id INTEGER NOT NULL REFERENCES users(id)`, `marked_at TIMESTAMPTZ DEFAULT now()`
    - Add `UNIQUE (chapter_id, batch_id)` constraint
    - Add indexes: `idx_teaching_status_batch` on `batch_id`, `idx_teaching_status_chapter` on `chapter_id`
    - _Requirements: 1.1, 1.4_

  - [x] 1.2 Add `pdfkit` to `package.json` dependencies
    - Run `npm install pdfkit` or add to dependencies manually
    - _Requirements: 6.1_

- [x] 2. Implement Syllabus Tracker API routes in `app.js`
  - [x] 2.1 Add `POST /api/syllabus/mark` route
    - Use `ensureInstituteUser` middleware
    - Accept `{ chapterId, batchId }` in request body
    - Validate that the batch belongs to the teacher's institute via a JOIN query on `batches` and `users`
    - INSERT into `chapter_teaching_status`; on unique constraint violation return 409
    - Return 201 with the created record
    - _Requirements: 1.1, 1.2, 1.5_

  - [x] 2.2 Add `DELETE /api/syllabus/unmark` route
    - Use `ensureInstituteUser` middleware
    - Accept `{ chapterId, batchId }` in request body
    - Validate batch belongs to teacher's institute
    - DELETE from `chapter_teaching_status` WHERE `chapter_id` and `batch_id` match; return 404 if no row deleted
    - Return 200 with `{ success: true }`
    - _Requirements: 1.3, 1.5_

  - [x] 2.3 Add `GET /api/syllabus/status/:batchId` route
    - Use `ensureInstituteUser` middleware
    - Validate batch belongs to teacher's institute
    - SELECT all rows from `chapter_teaching_status` WHERE `batch_id` matches
    - Return `{ batchId, statuses: [...] }`
    - _Requirements: 2.5_

  - [x] 2.4 Add `GET /api/syllabus/delta/:batchId` route
    - Use `ensureInstituteUser` middleware
    - Validate batch belongs to teacher's institute
    - Query taught chapters joined with `batch_students`, `concepts`, and `user_concept_mastery` to compute per-chapter batch mastery (average of student averages, default 0.2 for missing mastery)
    - Compute `students_below_50` percentage and `is_warning` flag (true if ≥ 80% below 50%)
    - Sort taught chapters by ascending `batch_mastery`
    - Return `{ batchId, totalChapters, taughtCount, taughtChapters: [...] }`
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 4.1, 4.4_

  - [ ]* 2.5 Write property tests for syllabus tracker API logic
    - **Property 1: Mark/Unmark Teaching Status Round-Trip**
    - **Property 2: Unique Constraint on Teaching Status**
    - **Property 3: Cross-Institute Syllabus Access Rejection**
    - **Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5**

  - [ ]* 2.6 Write property tests for delta computation
    - **Property 4: Taught Count Consistency**
    - **Property 5: Batch Mastery Computation**
    - **Property 7: Taught Chapters Sorted by Ascending Mastery**
    - **Property 8: Delta Warning Threshold**
    - **Validates: Requirements 3.1, 3.2, 3.4, 4.1, 4.4**

- [x] 3. Checkpoint — Syllabus Tracker backend complete
  - Ensure all tests pass, ask the user if questions arise.

- [x] 4. Implement Report Card service and API route
  - [x] 4.1 Create `services/reportCardService.js` with `compileReportData` function
    - Accept `db`, `studentId`, `instituteId` parameters
    - Query `user_concept_mastery` joined with `concepts` and `chapters` for the student
    - Group by subject → chapter → concept; use 0.2 default for missing mastery
    - Compute chapter mastery as average of concept masteries
    - Compute subject mastery as average of chapter masteries
    - Order chapters by `display_order` within each subject group (Physics, Chemistry, Mathematics)
    - Include student name, institute name, generation date
    - Return structured `ReportData` object
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6_

  - [x] 4.2 Add `generateReportPDF` function to `services/reportCardService.js`
    - Accept compiled `ReportData` object
    - Use PDFKit to generate PDF with: header (Learn.ai branding, student name, institute name, date), subject summary with color-coded mastery indicators (green ≥ 80%, yellow 50-80%, red < 50%), chapter breakdown with mastery bars, concept detail listing
    - Return a PDFKit document stream
    - Sanitize student name for filename: replace spaces with underscores, remove special characters
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

  - [x] 4.3 Add `GET /api/report-card/:studentId` route in `app.js`
    - Use `ensureInstituteUser` middleware
    - Accept optional `batchId` query parameter
    - Validate that the student belongs to the same institute as the requesting user
    - Call `compileReportData` and `generateReportPDF`
    - Set `Content-Type: application/pdf` and `Content-Disposition: attachment; filename="{name}_report_card_{date}.pdf"`
    - Pipe the PDF stream to the response
    - On error, return 500 with JSON error message; do not crash the process
    - Return 403 if user is not teacher/institute_admin or student is from a different institute
    - _Requirements: 6.1, 6.6, 6.7, 7.1, 7.2, 7.3, 7.4_

  - [ ]* 4.4 Write property tests for report card data compilation
    - **Property 9: Report Data Completeness**
    - **Property 10: Chapter Mastery is Average of Concept Masteries**
    - **Property 11: Chapters Ordered by Subject and Display Order**
    - **Property 12: Subject Mastery is Average of Chapter Masteries**
    - **Validates: Requirements 5.1, 5.2, 5.3, 5.4, 5.5, 5.6**

  - [ ]* 4.5 Write property tests for PDF generation and access control
    - **Property 6: Mastery Color-Coding Thresholds**
    - **Property 13: PDF Generation Produces Valid Output**
    - **Property 14: Report Filename Format**
    - **Property 15: Report Access Control**
    - **Validates: Requirements 6.1, 6.6, 7.1, 7.2, 7.3, 7.4**

- [x] 5. Checkpoint — Report Card backend complete
  - Ensure all tests pass, ask the user if questions arise.

- [x] 6. Update Teacher Dashboard UI for Syllabus Tracker
  - [x] 6.1 Add chapter teaching toggle to the macro graph in `views/institute-teacher-dashboard.ejs`
    - When a batch is selected, add a small checkbox/toggle overlay on each chapter node in the vis-network macro graph
    - On toggle ON: send `fetch POST /api/syllabus/mark` with `{ chapterId, batchId }`; on success add a checkmark badge to the node
    - On toggle OFF: send `fetch DELETE /api/syllabus/unmark` with `{ chapterId, batchId }`; on success remove the badge
    - On page load with a selected batch: call `GET /api/syllabus/status/:batchId` and apply visual badges to taught chapters
    - Visually distinguish taught chapters (e.g., distinct border or checkmark icon on the node)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5_

  - [x] 6.2 Add Syllabus Progress panel to `views/institute-teacher-dashboard.ejs`
    - Add a new card section below the filter bar (before the graph container)
    - Show "X / 54 chapters taught" with a progress bar
    - List taught chapters sorted by ascending batch mastery, each with its mastery percentage color-coded (green ≥ 80%, yellow 50-80%, red < 50%)
    - Fetch data from `GET /api/syllabus/delta/:batchId` on page load and after mark/unmark actions
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [x] 6.3 Add Delta Warning alerts to the Syllabus Progress panel
    - Display red alert cards at the top of the Syllabus Progress panel for chapters where `is_warning` is true
    - Show chapter name, percentage of students below 50% mastery, and batch average mastery
    - Warnings update when delta data is refreshed
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [x] 7. Update Teacher Dashboard UI for Report Card export
  - [x] 7.1 Add "Export Report Card" button next to each student chip in `views/institute-teacher-dashboard.ejs`
    - Add a small PDF icon/button next to each student chip in the student selector area
    - On click: open `GET /api/report-card/:studentId?batchId=X` in a new tab via `window.open()`
    - Show a loading spinner on the button while the PDF is being generated
    - On completion, the browser handles the PDF download automatically via Content-Disposition header
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [x] 8. Final checkpoint — All features integrated
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- The existing `ensureInstituteUser` middleware in `app.js` handles auth for teacher and institute_admin roles
- PDFKit is added as a new dependency; all other dependencies already exist in the project
