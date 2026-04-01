# Requirements Document

## Introduction

The LMS Assignment System enables teachers at coaching institutes to create structured assignments by selecting questions from the existing question bank, assign them to student batches with deadlines, and review detailed submission analytics. Students receive notifications of pending assignments on their dashboard, take assignments in a locked test-like UI (reusing the practice UI pattern), and receive JEE-pattern scoring (+4/−1/0). On submission, per-concept BKT mastery is updated automatically. Teachers get a submissions dashboard with per-student scores, time taken, and concept-wise performance breakdowns.

## Glossary

- **Assignment_System**: The set of backend routes, database tables, and frontend views that manage the full lifecycle of assignments (creation, notification, taking, submission, scoring, analytics).
- **Teacher**: A user with role `teacher` or `institute_admin` associated with an institute, authorized to create and manage assignments.
- **Student**: A user with role `student` who belongs to one or more batches within an institute.
- **Batch**: A group of students within an institute (existing `batches` / `batch_students` tables).
- **Question_Bank**: The existing `questions` table containing approved questions with subject, concept_id, and difficulty_tier fields.
- **Assignment**: A named collection of questions assigned to a batch with a deadline.
- **Submission**: A student's completed attempt at an assignment, including all answers, score, and time taken.
- **Notification_System**: The mechanism that alerts students of pending assignments on their dashboard.
- **Scoring_Engine**: The component that calculates assignment scores using JEE-pattern marking: +4 for correct, −1 for wrong, 0 for unanswered.
- **BKT_Service**: The existing Python FastAPI Bayesian Knowledge Tracing service running on port 8000 that computes mastery updates per concept.
- **Dashboard**: The existing student dashboard view (`dashboard.ejs`) where students see their knowledge graph and learning status.
- **Teacher_Dashboard**: The existing teacher dashboard view (`institute-teacher-dashboard.ejs`) where teachers monitor batch performance.

## Requirements

### Requirement 1: Assignment Creation

**User Story:** As a Teacher, I want to create an assignment by selecting questions from the Question_Bank filtered by subject, concept, and difficulty, so that I can assign targeted practice to my batches.

#### Acceptance Criteria

1. WHEN a Teacher navigates to the assignment creation page, THE Assignment_System SHALL display filter controls for subject, concept_id, and difficulty_tier to browse the Question_Bank.
2. WHEN a Teacher applies filters, THE Assignment_System SHALL display matching approved questions from the Question_Bank scoped to the Teacher's institute (institute-owned and global questions).
3. WHEN a Teacher selects questions and specifies a batch, assignment title, and deadline, THE Assignment_System SHALL create an assignment record and associate the selected questions with the assignment.
4. THE Assignment_System SHALL validate that the deadline is a future date-time before creating the assignment.
5. THE Assignment_System SHALL validate that at least one question is selected before creating the assignment.
6. IF the Teacher specifies a batch that does not belong to the Teacher's institute, THEN THE Assignment_System SHALL reject the request with a 403 Forbidden response.

### Requirement 2: Assignment Notification

**User Story:** As a Student, I want to see pending assignments on my dashboard, so that I know what work is due.

#### Acceptance Criteria

1. WHEN an assignment is created for a batch, THE Notification_System SHALL create a notification record for each Student in that batch.
2. WHEN a Student loads the Dashboard, THE Assignment_System SHALL display a list of pending assignments with title, deadline, and question count.
3. WHILE an assignment deadline has not passed and the Student has not submitted, THE Assignment_System SHALL display the assignment as "Pending" on the Dashboard.
4. WHEN a Student has submitted an assignment, THE Assignment_System SHALL display the assignment as "Completed" with the score on the Dashboard.
5. WHEN an assignment deadline has passed and the Student has not submitted, THE Assignment_System SHALL display the assignment as "Missed" on the Dashboard.

### Requirement 3: Assignment Taking

**User Story:** As a Student, I want to take an assignment with a locked question set in a test-like UI, so that I can complete the assigned work under controlled conditions.

#### Acceptance Criteria

1. WHEN a Student opens a pending assignment, THE Assignment_System SHALL display all assignment questions in a sequential UI similar to the existing practice view.
2. THE Assignment_System SHALL present questions with four options (option1 through option4) and allow the Student to select one option or leave the question unanswered.
3. THE Assignment_System SHALL display a question navigation panel showing answered, unanswered, and current question status.
4. WHILE a Student is taking an assignment, THE Assignment_System SHALL track the total time elapsed from when the Student started the assignment.
5. IF a Student attempts to open an assignment after the deadline has passed, THEN THE Assignment_System SHALL reject access and display a "Deadline passed" message.
6. IF a Student has already submitted the assignment, THEN THE Assignment_System SHALL reject re-submission and display the existing submission results.
7. THE Assignment_System SHALL lock the question set so that the Student sees the same questions in the same order throughout the assignment session.

### Requirement 4: Scoring and Submission

**User Story:** As a Student, I want my assignment to be scored using JEE-pattern marking on submission, so that I get an accurate assessment of my performance.

#### Acceptance Criteria

1. WHEN a Student submits an assignment, THE Scoring_Engine SHALL calculate the total score using +4 for each correct answer, −1 for each wrong answer, and 0 for each unanswered question.
2. WHEN a Student submits an assignment, THE Assignment_System SHALL record each individual answer (selected option or unanswered) in the assignment_answers table.
3. WHEN a Student submits an assignment, THE Assignment_System SHALL record the submission with total score, maximum possible score, and total time taken in seconds.
4. THE Scoring_Engine SHALL calculate the maximum possible score as (number of questions × 4).
5. WHEN a Student submits an assignment, THE Assignment_System SHALL record the time_taken_seconds as the elapsed time from assignment start to submission.

### Requirement 5: BKT Mastery Update on Submission

**User Story:** As a Student, I want my concept mastery to be updated based on my assignment answers, so that my knowledge graph reflects my latest performance.

#### Acceptance Criteria

1. WHEN a Student submits an assignment, THE Assignment_System SHALL call the BKT_Service to update mastery for each concept represented in the assignment questions.
2. THE Assignment_System SHALL group the Student's answers by concept_id and send one BKT update per concept with the correctness of each answer.
3. WHEN a Student submits an assignment, THE Assignment_System SHALL log each answer as a user_question_attempt record for consistency with the existing practice tracking.
4. IF the BKT_Service is unavailable during submission, THEN THE Assignment_System SHALL still save the submission and answers, and log a warning for deferred mastery update.

### Requirement 6: Teacher Submissions Dashboard

**User Story:** As a Teacher, I want to view assignment submissions with per-student scores, time taken, and concept-wise breakdowns, so that I can assess student performance and identify weak areas.

#### Acceptance Criteria

1. WHEN a Teacher navigates to the submissions view for an assignment, THE Assignment_System SHALL display a table of all students in the assigned batch with their submission status (submitted, pending, missed).
2. WHEN a Teacher views submissions, THE Assignment_System SHALL display each submitted student's total score, maximum possible score, percentage, and time taken.
3. WHEN a Teacher views submissions, THE Assignment_System SHALL display a concept-wise breakdown showing per-concept correct count, total count, and percentage for each student.
4. THE Assignment_System SHALL display batch-level aggregate statistics: average score, highest score, lowest score, and average time taken.
5. WHEN a Teacher views submissions, THE Assignment_System SHALL sort students by score in descending order by default.

### Requirement 7: Assignment Management

**User Story:** As a Teacher, I want to view and manage my created assignments, so that I can track assignment status and deadlines.

#### Acceptance Criteria

1. WHEN a Teacher navigates to the assignments list page, THE Assignment_System SHALL display all assignments created by the Teacher with title, batch name, deadline, question count, and submission count.
2. THE Assignment_System SHALL display assignments sorted by deadline in descending order (most recent first).
3. WHEN a Teacher views the assignment list, THE Assignment_System SHALL indicate whether each assignment is active (deadline in future), closed (deadline passed), or fully submitted (all students submitted).

### Requirement 8: Database Schema

**User Story:** As a developer, I want the assignment system to have a well-structured database schema, so that data integrity is maintained across assignments, submissions, and notifications.

#### Acceptance Criteria

1. THE Assignment_System SHALL store assignments in an `assignments` table with columns: id, institute_id, batch_id, created_by (teacher user_id), title, deadline (TIMESTAMPTZ), created_at.
2. THE Assignment_System SHALL store assignment-question mappings in an `assignment_questions` table with columns: assignment_id, question_id, question_order.
3. THE Assignment_System SHALL store submissions in an `assignment_submissions` table with columns: id, assignment_id, user_id, score, max_score, time_taken_seconds, submitted_at, started_at.
4. THE Assignment_System SHALL store individual answers in an `assignment_answers` table with columns: id, submission_id, question_id, selected_option (nullable for unanswered), is_correct.
5. THE Assignment_System SHALL store notifications in a `notifications` table with columns: id, user_id, type, reference_id, title, message, is_read, created_at.
6. THE Assignment_System SHALL enforce foreign key constraints between assignments and institutes, batches, and users tables.
7. THE Assignment_System SHALL create indexes on assignment_submissions(assignment_id), assignment_submissions(user_id), assignment_answers(submission_id), and notifications(user_id, is_read) for query performance.

### Requirement 9: Authorization and Multi-Tenancy

**User Story:** As an institute admin, I want the assignment system to respect institute boundaries, so that teachers and students only access assignments within their own institute.

#### Acceptance Criteria

1. THE Assignment_System SHALL restrict assignment creation to users with role `teacher` or `institute_admin` who have an associated institute_id.
2. THE Assignment_System SHALL restrict assignment access so that Students can only view and take assignments assigned to batches they belong to.
3. THE Assignment_System SHALL restrict the submissions dashboard so that only the Teacher who created the assignment (or an institute_admin of the same institute) can view submission details.
4. WHEN a Teacher creates an assignment, THE Assignment_System SHALL automatically associate the assignment with the Teacher's institute_id.
