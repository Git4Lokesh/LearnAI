# Requirements Document

## Introduction

Overhaul the existing 45-question adaptive diagnostic test into a proper JEE Mains format exam. The new diagnostic presents 90 MCQ questions (30 per subject: Physics, Chemistry, Mathematics) with a 3-hour countdown timer, JEE Mains marking scheme (+4/−1/0), section-based navigation, and a question palette. After submission, the system initializes BKT mastery for all 221 subconcepts using the existing prerequisite graph inference. The test remains optional — students can skip it and start practicing freely.

## Glossary

- **Diagnostic_Test**: The 90-question JEE Mains format assessment presented to new students before they begin practicing on the platform.
- **Section**: One of the three subject groupings within the Diagnostic_Test — Physics, Chemistry, or Mathematics — each containing exactly 30 questions.
- **Question_Palette**: A visual grid of numbered buttons (1–90) showing the status of each question (unattempted, answered, marked-for-review, answered-and-marked).
- **Timer**: A server-validated countdown clock starting at 3:00:00 (3 hours) that auto-submits the test when it reaches 0:00:00.
- **Marking_Scheme**: The JEE Mains scoring rule: +4 for a correct answer, −1 for an incorrect answer, 0 for an unattempted question.
- **Question_Selection_Engine**: The server-side algorithm that selects 90 questions from the seeded question bank, distributing them across subconcepts and difficulty tiers.
- **Session_State**: The server-side (req.session) data structure holding all in-progress test state including answers, timestamps, and question assignments.
- **BKT_Initializer**: The post-submission process that computes BKT mastery for directly-tested subconcepts and infers mastery for untested subconcepts using the prerequisite graph (reuses the existing `initializeRemainingConcepts` logic).
- **Results_Page**: The post-submission view showing total score, section-wise breakdown, and mastery initialization summary.
- **Difficulty_Tier**: The integer difficulty rating of a question — 1 (easy), 2 (medium), or 3 (hard).

## Requirements

### Requirement 1: Question Selection and Test Assembly

**User Story:** As a student, I want the diagnostic test to contain 90 well-distributed questions from the seeded bank, so that the test covers a broad range of subconcepts and difficulty levels for accurate mastery estimation.

#### Acceptance Criteria

1. WHEN a student starts the Diagnostic_Test, THE Question_Selection_Engine SHALL select exactly 90 approved questions from the seeded question bank — 30 for Physics, 30 for Chemistry, and 30 for Mathematics.
2. THE Question_Selection_Engine SHALL distribute questions within each Section using the difficulty mix: 7 questions at Difficulty_Tier 1 (easy), 13 questions at Difficulty_Tier 2 (medium), and 10 questions at Difficulty_Tier 3 (hard).
3. THE Question_Selection_Engine SHALL maximize subconcept coverage by selecting at most one question per subconcept before reusing any subconcept.
4. THE Question_Selection_Engine SHALL assign each selected question a unique sequence number from 1 to 90, with Physics occupying 1–30, Chemistry 31–60, and Mathematics 61–90.
5. IF the seeded question bank does not contain enough approved questions for a given Difficulty_Tier within a subject, THEN THE Question_Selection_Engine SHALL fill the remaining slots from adjacent difficulty tiers within the same subject.
6. THE Question_Selection_Engine SHALL record the concept_id for each selected question in the Session_State so that BKT receives per-subconcept signal after submission.

### Requirement 2: Session State Management

**User Story:** As a student, I want my test progress to be preserved if I accidentally refresh the page, so that I do not lose my answers during the 3-hour exam.

#### Acceptance Criteria

1. WHEN a student starts the Diagnostic_Test, THE Diagnostic_Test SHALL create a Session_State on the server (req.session) containing the 90 selected questions, the student's answers, question statuses, and the test start timestamp.
2. WHILE the Diagnostic_Test is in progress, THE Diagnostic_Test SHALL persist all answer changes to the Session_State on each answer submission.
3. WHEN a student refreshes the browser during the Diagnostic_Test, THE Diagnostic_Test SHALL restore the test from the Session_State with all previously recorded answers and statuses intact.
4. THE Diagnostic_Test SHALL store the test start timestamp in the Session_State so the Timer can be recomputed on page reload.
5. IF a student navigates away and returns while the Timer has not expired, THEN THE Diagnostic_Test SHALL resume the test from the Session_State with the remaining time correctly calculated.

### Requirement 3: Section-Based Navigation

**User Story:** As a student, I want to switch freely between Physics, Chemistry, and Mathematics sections during the test, so that I can manage my time and attempt questions in any order.

#### Acceptance Criteria

1. THE Diagnostic_Test SHALL display three Section tabs (Physics, Chemistry, Mathematics) that the student can click to switch between sections at any time during the test.
2. WHEN a student clicks a Section tab, THE Diagnostic_Test SHALL display the questions belonging to that Section and highlight the currently active Section tab.
3. WHILE viewing a Section, THE Diagnostic_Test SHALL display one question at a time with navigation buttons to move to the previous or next question within the Section.
4. WHEN a student clicks a question number in the Question_Palette, THE Diagnostic_Test SHALL navigate directly to that question regardless of which Section it belongs to.

### Requirement 4: Question Palette

**User Story:** As a student, I want a visual overview of all 90 questions showing which ones I have answered, skipped, or marked for review, so that I can track my progress during the exam.

#### Acceptance Criteria

1. THE Diagnostic_Test SHALL display a Question_Palette containing numbered buttons for all 90 questions, grouped by Section.
2. THE Question_Palette SHALL color-code each question button using four distinct statuses: unattempted (grey), answered (green), marked-for-review (purple), and answered-and-marked (purple with green dot).
3. WHEN a student selects an answer for a question, THE Question_Palette SHALL update that question's button to the answered status.
4. WHEN a student clicks the "Mark for Review" button, THE Question_Palette SHALL update that question's button to the marked-for-review or answered-and-marked status depending on whether an answer has been selected.
5. WHEN a student clicks the "Clear Response" button, THE Diagnostic_Test SHALL remove the selected answer for the current question and update the Question_Palette status to unattempted or marked-for-review.

### Requirement 5: Countdown Timer

**User Story:** As a student, I want a visible countdown timer showing the remaining time, so that I can pace myself during the 3-hour exam.

#### Acceptance Criteria

1. WHEN the Diagnostic_Test starts, THE Timer SHALL begin counting down from 3:00:00 (3 hours) and display the remaining time in HH:MM:SS format.
2. THE Timer SHALL compute remaining time from the server-stored start timestamp so that page refreshes do not reset the countdown.
3. WHEN the Timer reaches 0:00:00, THE Diagnostic_Test SHALL automatically submit the test with all currently recorded answers.
4. WHILE the Timer has less than 15 minutes remaining, THE Timer SHALL display in a warning color (red) to alert the student.
5. THE Timer SHALL be visible at all times during the Diagnostic_Test regardless of which Section the student is viewing.

### Requirement 6: Answer Submission and Navigation Controls

**User Story:** As a student, I want to save my answer, clear it, or mark a question for review, so that I can manage my responses like a real JEE Mains exam.

#### Acceptance Criteria

1. WHEN a student selects an option (A/B/C/D) for a question, THE Diagnostic_Test SHALL save that selection to the Session_State via a server request.
2. WHEN a student clicks "Save & Next", THE Diagnostic_Test SHALL save the current answer and navigate to the next question in the Section.
3. WHEN a student clicks "Clear Response", THE Diagnostic_Test SHALL remove the saved answer for the current question from the Session_State.
4. WHEN a student clicks "Mark for Review & Next", THE Diagnostic_Test SHALL flag the current question as marked-for-review in the Session_State and navigate to the next question.
5. THE Diagnostic_Test SHALL allow the student to change a previously saved answer by selecting a different option and saving again.

### Requirement 7: JEE Mains Marking Scheme and Scoring

**User Story:** As a student, I want my test scored using the official JEE Mains marking scheme, so that the score reflects a realistic exam experience.

#### Acceptance Criteria

1. WHEN the Diagnostic_Test is submitted, THE Marking_Scheme SHALL award +4 marks for each correctly answered question.
2. WHEN the Diagnostic_Test is submitted, THE Marking_Scheme SHALL deduct 1 mark for each incorrectly answered question.
3. WHEN the Diagnostic_Test is submitted, THE Marking_Scheme SHALL award 0 marks for each unattempted question.
4. THE Marking_Scheme SHALL compute a total score and a per-Section score (Physics, Chemistry, Mathematics) separately.
5. THE Marking_Scheme SHALL compute the maximum possible score as 360 (90 questions × 4 marks each).

### Requirement 8: Test Submission and BKT Mastery Initialization

**User Story:** As a student, I want my diagnostic results to initialize my knowledge graph mastery levels, so that my learning path is personalized from the start.

#### Acceptance Criteria

1. WHEN the student clicks "Submit Test" or the Timer auto-submits, THE Diagnostic_Test SHALL process all 90 answers and compute the score using the Marking_Scheme.
2. WHEN the Diagnostic_Test is submitted, THE BKT_Initializer SHALL update BKT mastery for each subconcept that had a question in the test, using the correctness of the student's answer and the question's Difficulty_Tier.
3. WHEN the Diagnostic_Test is submitted, THE BKT_Initializer SHALL initialize mastery for all untested subconcepts using the existing prerequisite graph inference logic (upstream inference, downstream inference, chapter-level performance, subject-level performance).
4. WHEN the Diagnostic_Test is submitted, THE Diagnostic_Test SHALL mark the user's diagnostic_completed flag as true in the database.
5. WHEN the Diagnostic_Test is submitted, THE Diagnostic_Test SHALL log each answered question as a user_question_attempt record with the question_id, correctness, and time metadata.
6. WHEN the student clicks "Submit Test" before the Timer expires, THE Diagnostic_Test SHALL display a confirmation dialog warning that unanswered questions will be scored as 0.

### Requirement 9: Results Page

**User Story:** As a student, I want to see my diagnostic results with a score breakdown and mastery summary, so that I understand my starting position.

#### Acceptance Criteria

1. WHEN the Diagnostic_Test submission is complete, THE Results_Page SHALL display the total score out of 360, the number of correct answers, incorrect answers, and unattempted questions.
2. THE Results_Page SHALL display a per-Section breakdown showing the score, correct count, incorrect count, and unattempted count for Physics, Chemistry, and Mathematics separately.
3. THE Results_Page SHALL display a mastery initialization summary showing the count of subconcepts classified as strong (mastery ≥ 0.4), developing (0.25 ≤ mastery < 0.4), and needs-work (mastery < 0.25).
4. THE Results_Page SHALL provide a button to navigate to the main dashboard.
5. THE Results_Page SHALL store the result data in the session temporarily so that a page refresh on the results page does not lose the data.

### Requirement 10: Optional Test — Skip Flow

**User Story:** As a student, I want the option to skip the diagnostic test entirely, so that I can start practicing immediately without taking a 3-hour exam.

#### Acceptance Criteria

1. THE Diagnostic_Test welcome screen SHALL present two options: "Take Diagnostic Test" and "Skip and Start Fresh".
2. WHEN a student selects "Skip and Start Fresh", THE Diagnostic_Test SHALL set the user's diagnostic_completed flag to true and redirect the student to the main dashboard.
3. WHEN a student skips the Diagnostic_Test, THE Diagnostic_Test SHALL leave all subconcept mastery values at the default (0.2) without running the BKT_Initializer.
4. WHILE a student has not completed or skipped the Diagnostic_Test, THE platform SHALL show the diagnostic welcome screen when the student navigates to the diagnostic route.

### Requirement 11: Professional JEE Mains UI

**User Story:** As a student, I want the test interface to look and feel like a real JEE Mains computer-based test, so that the experience serves as exam practice.

#### Acceptance Criteria

1. THE Diagnostic_Test SHALL display the student's name and a subject indicator in a top header bar, consistent with the JEE Mains CBT layout.
2. THE Diagnostic_Test SHALL render question text and options with MathJax support for mathematical notation.
3. THE Diagnostic_Test SHALL display the Question_Palette in a right-side panel (desktop) or a collapsible panel (mobile) showing all 90 question buttons grouped by Section.
4. THE Diagnostic_Test SHALL display a legend explaining the color codes used in the Question_Palette.
5. THE Diagnostic_Test SHALL use the existing platform dark theme (CSS variables from theme.css) to maintain visual consistency.
