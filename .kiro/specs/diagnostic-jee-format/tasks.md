# Implementation Plan: JEE Mains Format Diagnostic Test

## Overview

Rewrite the diagnostic test from a 45-question adaptive flow into a full JEE Mains CBT format: 90 MCQs (30 per subject), 3-hour timer, section tabs, question palette, +4/−1/0 marking, and post-submission BKT initialization. The existing `initializeRemainingConcepts` function is preserved. No database migrations needed.

## Tasks

- [x] 1. Rewrite routes/diagnostic.js — Question Selection Engine and Session State
  - [x] 1.1 Implement `selectDiagnosticQuestions()` function
    - Query 30 questions per subject (Physics, Chemistry%, Mathematics) with difficulty distribution: 7 tier-1, 13 tier-2, 10 tier-3
    - Use window function `ROW_NUMBER() OVER (PARTITION BY q.concept_id ORDER BY RANDOM())` to maximize subconcept coverage (at most 1 question per subconcept before reuse)
    - Implement adjacent-tier fallback when a tier has insufficient questions
    - Assign sequence numbers: Physics 1–30, Chemistry 31–60, Mathematics 61–90
    - Each question object includes: id, question_text, option1–option4, correct_answer, solution_text, concept_id, difficulty_tier, seq, section
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6_

  - [x] 1.2 Implement GET /diagnostic route handler
    - If `req.user.diagnostic_completed` → redirect to `/`
    - If `req.session.diagnostic?.started` → check time expiry (`Date.now() - startTimestamp >= durationMs`), auto-submit if expired, otherwise render test UI (resume)
    - Else → render welcome screen (`started: false`)
    - Pass sanitized questions to template (strip `correct_answer` and `solution_text`)
    - _Requirements: 2.3, 2.4, 2.5, 10.4_

  - [x] 1.3 Implement POST /diagnostic/start route handler
    - Call `selectDiagnosticQuestions()` to get 90 questions
    - Create session state: `{ started, startTimestamp: Date.now(), durationMs: 10800000, questions, answers: {}, markedForReview: {} }`
    - Record concept_id for each question in session
    - Render diagnostic.ejs with full test UI
    - _Requirements: 1.1, 2.1, 2.4_

  - [x] 1.4 Implement POST /diagnostic/answer, POST /diagnostic/clear, POST /diagnostic/mark-review endpoints
    - `/answer`: body `{ seq, answer }` → validate seq 1–90, answer is option1–option4 → set `session.answers[seq] = answer` → respond JSON `{ ok: true }`
    - `/clear`: body `{ seq }` → delete `session.answers[seq]` → respond JSON `{ ok: true }`
    - `/mark-review`: body `{ seq, marked }` → toggle `session.markedForReview[seq]` → respond JSON `{ ok: true }`
    - All endpoints validate session exists and test is in progress
    - _Requirements: 2.2, 4.3, 4.4, 4.5, 6.1, 6.3, 6.4, 6.5_

  - [x] 1.5 Implement `computeScore()` function and POST /diagnostic/submit handler
    - Scoring: +4 correct, −1 incorrect, 0 unattempted; compute total and per-section (Physics/Chemistry/Mathematics)
    - For each answered question: fetch mastery via `getUserConceptMastery`, call `bktUpdateConcept`, upsert `user_concept_mastery`
    - Log each answered question to `user_question_attempts`
    - Call `initializeRemainingConcepts(userId, diagData)` for untested concepts (build compatible diagData object)
    - Set `diagnostic_completed = true` in users table
    - Store result in `req.session.diagnosticResult`, delete `req.session.diagnostic`
    - Respond JSON `{ ok: true, redirect: '/diagnostic/results' }`
    - Wrap BKT calls in try/catch — if BKT fails, still complete submission
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

  - [x] 1.6 Preserve `initializeRemainingConcepts()` function
    - Keep the existing function as-is (upstream/downstream inference, chapter-level, subject-level fallback)
    - Ensure the diagData object passed from submit handler is compatible with the function's expected shape (answers array with conceptId/correct/difficultyTier, sampledConcepts array)
    - _Requirements: 8.3_

  - [x] 1.7 Implement GET /diagnostic/results and GET /diagnostic/skip handlers
    - `/results`: read `req.session.diagnosticResult`, query mastery summary (strong ≥ 0.4, developing 0.25–0.4, needs-work < 0.25), render `diagnostic-results.ejs`
    - `/skip`: set `diagnostic_completed = true`, delete session state, redirect to `/`
    - _Requirements: 9.1, 9.5, 10.2, 10.3_

- [x] 2. Checkpoint — Verify route logic compiles and handlers are wired
  - Ensure all tests pass, ask the user if questions arise.

- [x] 3. Rewrite views/diagnostic.ejs — JEE Mains CBT Interface
  - [x] 3.1 Implement welcome screen
    - Display student name, test info (90 questions, 3 subjects, 3 hours, +4/−1/0 marking)
    - "Take Diagnostic Test" button → POST /diagnostic/start
    - "Skip and Start Fresh" link → GET /diagnostic/skip
    - Use dark theme CSS variables from theme.css
    - _Requirements: 10.1, 10.2, 10.4, 11.5_

  - [x] 3.2 Implement test UI layout — header, section tabs, question area, palette, footer
    - Header bar: Learn.ai logo, student name, subject indicator, countdown timer (HH:MM:SS)
    - Section tabs: Physics, Chemistry, Mathematics — click to switch sections (client-side, no reload)
    - Question display area: question number, question text, 4 radio options (A/B/C/D)
    - Right-side question palette: 90 numbered buttons grouped by section, color-coded (grey=unattempted, green=answered, purple=marked, purple+green-dot=answered+marked)
    - Palette legend explaining color codes
    - Footer: "Mark for Review & Next", "Clear Response", "Save & Next", "Previous", "Submit Test" buttons
    - Desktop: palette in right panel. Mobile: collapsible drawer with toggle button
    - _Requirements: 3.1, 3.2, 3.3, 4.1, 4.2, 4.3, 4.4, 5.5, 6.2, 6.3, 6.4, 11.1, 11.3, 11.4, 11.5_

  - [x] 3.3 Implement client-side JavaScript — navigation, answer management, timer
    - Embed sanitized questions as JSON (no correct_answer/solution_text): `const questions = <%- JSON.stringify(sanitizedQuestions) %>;`
    - Embed current answers and markedForReview from session state
    - Section switching: filter questions by section, show first question of selected section
    - Question navigation: Previous/Next within section, palette click jumps to any question (switching section if needed)
    - Answer save: on radio select or "Save & Next", fetch POST /diagnostic/answer with `{ seq, answer }`
    - Clear response: fetch POST /diagnostic/clear with `{ seq }`, deselect radio
    - Mark for review: fetch POST /diagnostic/mark-review with `{ seq, marked }`
    - Update palette button colors after each action
    - Timer: compute `remainingMs = durationMs - (Date.now() - startTimestamp)`, setInterval(1000) countdown, display HH:MM:SS, red warning when < 15 min, auto-submit at 0
    - Submit: confirmation dialog if unanswered questions exist, fetch POST /diagnostic/submit, redirect on success
    - MathJax: call `MathJax.typesetPromise()` after each question render
    - _Requirements: 2.3, 2.5, 3.1, 3.2, 3.3, 3.4, 4.2, 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4, 6.1, 6.2, 6.3, 6.4, 6.5, 8.6, 11.2_

- [x] 4. Checkpoint — Verify diagnostic.ejs renders and client-side navigation works
  - Ensure all tests pass, ask the user if questions arise.

- [x] 5. Update views/diagnostic-results.ejs — Section-wise Scoring Display
  - [x] 5.1 Update results page with JEE Mains scoring display
    - Total score out of 360 (not percentage-based)
    - Correct, incorrect, unattempted counts
    - Per-section breakdown table: Physics, Chemistry, Mathematics — each showing score, correct, incorrect, unattempted
    - Mastery initialization summary: strong (≥ 0.4), developing (0.25–0.4), needs-work (< 0.25) counts
    - "Go to Dashboard" button
    - Store result in session so page refresh doesn't lose data
    - Use dark theme CSS variables
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5, 11.5_

- [x] 6. Final checkpoint — Full end-to-end flow verification
  - Ensure all tests pass, ask the user if questions arise.
  - Verify: welcome screen → start test → navigate sections → save/clear/mark answers → timer countdown → submit → results page → dashboard redirect
  - Verify: skip flow → dashboard with default mastery
  - Verify: page refresh during test resumes correctly with answers intact

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- The existing `initializeRemainingConcepts` function is preserved verbatim — only the diagData interface needs to match
- No database migrations required — all existing tables are reused
- The view uses `fetch()` for all answer/clear/mark/submit operations — no full page reloads during the test
- MathJax CDN is loaded for math notation rendering
- Client-side questions JSON is sanitized (no correct_answer/solution_text) to prevent cheating
