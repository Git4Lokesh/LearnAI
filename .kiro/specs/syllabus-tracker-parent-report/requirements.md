# Requirements Document

## Introduction

This feature adds two capabilities to the Learn.ai coaching center platform:

1. **Syllabus Tracker** — Teachers mark chapters as "Taught in Class" on the Knowledge Graph. The system computes a delta between class progress and batch-level BKT mastery, triggering warnings when classroom teaching is not translating to student mastery.

2. **Parent Report Card Generator** — A one-click PDF export of a student's personal Knowledge Graph showing concept-by-concept mastery. Coaching centers use this report to justify the "Tech Fee" to parents.

Both features build on the existing hierarchical Knowledge Graph (54 NTA chapters, ~221 micro-concepts), the BKT mastery service, and the institute multi-tenancy model.

## Glossary

- **Teacher_Dashboard**: The existing teacher-facing page at `/institute/dashboard/teacher` that displays batch selection, knowledge graph overlay, and stuck students panel.
- **Syllabus_Tracker**: The component on the Teacher_Dashboard that allows teachers to mark chapters as taught and view the class-progress-vs-mastery delta.
- **Chapter**: One of the 54 NTA JEE Mains units stored in the `chapters` table, each containing multiple micro-concepts.
- **Micro_Concept**: One of the ~221 NTA subconcepts stored in the `concepts` table, each belonging to a Chapter.
- **BKT_Service**: The Python FastAPI microservice that computes per-concept mastery using Bayesian Knowledge Tracing.
- **Mastery**: A numeric value between 0 and 1 computed by the BKT_Service for each student-concept pair, stored in `user_concept_mastery`.
- **Batch**: A group of students within an institute, stored in the `batches` table.
- **Batch_Mastery**: The average Mastery across all students in a Batch for a given Chapter or Micro_Concept.
- **Teaching_Status**: A per-chapter, per-batch record indicating whether a teacher has marked the chapter as "Taught in Class", along with the date it was marked.
- **Delta_Warning**: An alert triggered when a chapter is marked as taught but 80% or more of the batch has chapter-level mastery below 50%.
- **Report_Card**: A PDF document showing a student's concept-by-concept mastery across the Knowledge Graph.
- **Report_Generator**: The server-side component that compiles student mastery data and renders the Report_Card PDF.
- **Institute_Admin**: A user with role `institute_admin` who manages the coaching center.
- **Teacher**: A user with role `teacher` who belongs to an institute.

## Requirements

### Requirement 1: Chapter Teaching Status Storage

**User Story:** As a teacher, I want the system to persist which chapters I have marked as taught for each batch, so that the data survives page reloads and is available for delta computation.

#### Acceptance Criteria

1. THE Syllabus_Tracker SHALL store Teaching_Status records with the chapter_id, batch_id, teacher_id (the user who marked it), and the timestamp of marking.
2. WHEN a teacher marks a chapter as taught, THE Syllabus_Tracker SHALL create a Teaching_Status record for that chapter and batch combination.
3. WHEN a teacher unmarks a previously taught chapter, THE Syllabus_Tracker SHALL delete the corresponding Teaching_Status record.
4. THE Syllabus_Tracker SHALL enforce a unique constraint on the (chapter_id, batch_id) pair so that each chapter can only be marked once per batch.
5. IF a teacher attempts to mark a chapter for a batch that does not belong to the teacher's institute, THEN THE Syllabus_Tracker SHALL reject the request with a 403 status.

### Requirement 2: Teacher Dashboard — Mark Chapters as Taught

**User Story:** As a teacher, I want to mark chapters as "Taught in Class" directly on the Knowledge Graph in my dashboard, so that I can track syllabus coverage for each batch.

#### Acceptance Criteria

1. WHEN a batch is selected on the Teacher_Dashboard, THE Syllabus_Tracker SHALL display a toggle or checkbox on each chapter node allowing the teacher to mark the chapter as "Taught in Class".
2. WHEN the teacher toggles a chapter to "Taught", THE Syllabus_Tracker SHALL send a request to the server and persist the Teaching_Status without requiring a full page reload.
3. WHEN the teacher toggles a chapter to "Not Taught", THE Syllabus_Tracker SHALL send a request to the server and remove the Teaching_Status without requiring a full page reload.
4. WHILE a batch is selected, THE Syllabus_Tracker SHALL visually distinguish taught chapters from untaught chapters on the Knowledge Graph (e.g., a checkmark badge or distinct border).
5. WHEN the Teacher_Dashboard loads with a selected batch, THE Syllabus_Tracker SHALL fetch and display the current Teaching_Status for all chapters in that batch.

### Requirement 3: Class Progress vs. Student Mastery Delta

**User Story:** As a teacher, I want to see a summary comparing which chapters I have taught against the batch's actual mastery levels, so that I can identify where classroom teaching is not translating to student understanding.

#### Acceptance Criteria

1. WHILE a batch is selected on the Teacher_Dashboard, THE Syllabus_Tracker SHALL display a "Syllabus Progress" panel showing the count of chapters marked as taught versus total chapters.
2. WHEN a chapter is marked as taught, THE Syllabus_Tracker SHALL compute the Batch_Mastery for that chapter by averaging the mastery of all students in the batch across the chapter's Micro_Concepts.
3. THE Syllabus_Tracker SHALL display each taught chapter alongside its Batch_Mastery percentage, color-coded: green for mastery ≥ 80%, yellow for mastery between 50% and 80%, red for mastery below 50%.
4. THE Syllabus_Tracker SHALL sort the taught chapters list so that chapters with the lowest Batch_Mastery appear first.

### Requirement 4: Delta Warning System

**User Story:** As a teacher, I want the system to warn me when a chapter I have taught is not being mastered by the batch, so that I can take corrective action such as re-teaching or assigning targeted practice.

#### Acceptance Criteria

1. WHEN a chapter is marked as taught AND 80% or more of the students in the batch have chapter-level mastery below 50%, THEN THE Syllabus_Tracker SHALL trigger a Delta_Warning for that chapter.
2. THE Syllabus_Tracker SHALL display Delta_Warnings prominently on the Teacher_Dashboard with the chapter name, the percentage of students below 50% mastery, and the batch average mastery for that chapter.
3. WHEN the batch mastery data changes (e.g., students practice and improve), THE Syllabus_Tracker SHALL re-evaluate Delta_Warnings on the next Teacher_Dashboard load.
4. WHEN a chapter no longer meets the Delta_Warning threshold (fewer than 80% of students below 50% mastery), THE Syllabus_Tracker SHALL stop displaying the warning for that chapter.

### Requirement 5: Parent Report Card Data Compilation

**User Story:** As an institute admin or teacher, I want the system to compile a student's complete mastery data organized by chapter and concept, so that it can be rendered into a report card.

#### Acceptance Criteria

1. WHEN a report is requested for a student, THE Report_Generator SHALL retrieve the student's mastery for all Micro_Concepts from the `user_concept_mastery` table.
2. THE Report_Generator SHALL group the mastery data by Chapter, computing a chapter-level mastery as the average of the chapter's Micro_Concept masteries.
3. THE Report_Generator SHALL organize chapters by subject (Physics, Chemistry, Mathematics) and display_order.
4. THE Report_Generator SHALL compute an overall subject-level mastery as the average of all chapter masteries within that subject.
5. THE Report_Generator SHALL include the student's name, the institute name, and the generation date in the compiled data.
6. IF a student has no mastery records for a Micro_Concept, THEN THE Report_Generator SHALL treat that concept's mastery as 0.2 (the BKT prior).

### Requirement 6: Parent Report Card PDF Generation

**User Story:** As an institute admin or teacher, I want to export a student's mastery data as a PDF report card, so that I can share it with parents to show concept-by-concept understanding.

#### Acceptance Criteria

1. WHEN the "Export Report Card" button is clicked for a student, THE Report_Generator SHALL generate a PDF document containing the compiled mastery data.
2. THE Report_Card PDF SHALL display a subject-wise summary section showing each subject's overall mastery percentage with a color-coded indicator (green ≥ 80%, yellow 50-80%, red < 50%).
3. THE Report_Card PDF SHALL display a chapter breakdown section listing each chapter with its mastery percentage and a visual bar or indicator.
4. THE Report_Card PDF SHALL display a concept detail section for each chapter listing individual Micro_Concept names and their mastery percentages.
5. THE Report_Card PDF SHALL include a header with the Learn.ai branding, the student's name, the institute name, and the report generation date.
6. THE Report_Card PDF SHALL be downloadable as a file named `{student_name}_report_card_{date}.pdf`.
7. IF the PDF generation fails, THEN THE Report_Generator SHALL return an error message to the user without crashing the application.

### Requirement 7: Report Card Access Control

**User Story:** As an institute admin, I want only authorized users within my institute to generate report cards for students, so that student data remains private.

#### Acceptance Criteria

1. THE Report_Generator SHALL restrict report generation to users with the role of Teacher or Institute_Admin.
2. WHEN a Teacher or Institute_Admin requests a report for a student, THE Report_Generator SHALL verify that the student belongs to the same institute as the requesting user.
3. IF an unauthorized user attempts to generate a report, THEN THE Report_Generator SHALL return a 403 Forbidden response.
4. IF a user requests a report for a student from a different institute, THEN THE Report_Generator SHALL return a 403 Forbidden response.

### Requirement 8: Report Card Trigger from Teacher Dashboard

**User Story:** As a teacher, I want to generate a report card for any student in my selected batch directly from the Teacher Dashboard, so that I can quickly produce reports without navigating away.

#### Acceptance Criteria

1. WHILE a batch is selected on the Teacher_Dashboard, THE Teacher_Dashboard SHALL display an "Export Report Card" button or icon next to each student's name in the student selector.
2. WHEN the teacher clicks the "Export Report Card" button for a student, THE Report_Generator SHALL generate and download the PDF for that student.
3. WHILE the PDF is being generated, THE Teacher_Dashboard SHALL display a loading indicator on the button to signal that generation is in progress.
4. WHEN the PDF generation completes, THE Teacher_Dashboard SHALL trigger a browser download of the generated PDF file.
