# Implementation Plan: Prerequisite Gating

## Overview

Add server-side prerequisite enforcement to the Learn.ai platform. This involves creating a `gatingService.js` module with two-tiered unlock logic (unit-level and subconcept-level), adding a guard to the `GET /practice/:conceptId` route in `app.js`, and creating a `practice-locked.ejs` view for the 403 response. No database migrations needed — all tables (`chapters`, `chapter_prerequisites`, `concepts`, `concept_prerequisites`, `user_concept_mastery`) already exist.

## Tasks

- [x] 1. Create the Gating Service module
  - [x] 1.1 Create `services/gatingService.js` with `MASTERY_THRESHOLD` constant and `isUnitUnlocked` function
    - Export `MASTERY_THRESHOLD = 0.8`
    - Implement `isUnitUnlocked(db, userId, chapterId)` that returns `{unlocked: boolean, unmetPrereqs: Array}`
    - Query `chapter_prerequisites` joined with `concepts` and `user_concept_mastery` in a single round-trip
    - Return `unlocked: true` with empty `unmetPrereqs` when the unit has no rows in `chapter_prerequisites`
    - Return `unlocked: true` when all subconcepts in all prerequisite units have mastery ≥ 0.8
    - Return `unlocked: false` with `unmetPrereqs` array containing `{id, name, mastery}` for each unmet prerequisite subconcept
    - Use `COALESCE(ucm.mastery, 0.0)` so students with no mastery data get 0.0 (entry points still unlock correctly)
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 4.1_

  - [x] 1.2 Add `isSubconceptUnlocked` function to `services/gatingService.js`
    - Implement `isSubconceptUnlocked(db, userId, conceptId)` that returns `{unlocked: boolean, reason: string|null, unmetPrereqs: Array}`
    - First look up the subconcept's `chapter_id` from the `concepts` table
    - If `chapter_id` is NULL (orphan subconcept), treat as unlocked at unit level and log a warning
    - Call `isUnitUnlocked` for the parent unit; if locked, return `{unlocked: false, reason: 'unit_locked', unmetPrereqs}` with the unit-level unmet prereqs
    - If unit is unlocked, query `concept_prerequisites` joined with `concepts` and `user_concept_mastery` for subconcept-level prereqs
    - Return `unlocked: true` when subconcept has no rows in `concept_prerequisites` and parent unit is unlocked
    - Return `unlocked: false` with `reason: 'prereqs_not_met'` and `unmetPrereqs` array when any direct prerequisite subconcept has mastery < 0.8
    - Cross-chapter prerequisites (e.g., Math → Physics from migration 007) are handled identically — no special-casing needed
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 4.2_

  - [ ]* 1.3 Write property test: Unit unlock equivalence (Property 1)
    - **Property 1: Unit unlock is equivalent to all prerequisite subconcepts being mastered**
    - **Validates: Requirements 1.1, 1.2, 1.3, 4.1**

  - [ ]* 1.4 Write property test: Subconcept unlock requires both unit unlock and prereq mastery (Property 2)
    - **Property 2: Subconcept unlock requires both unit unlock and prerequisite subconcept mastery**
    - **Validates: Requirements 2.1, 2.2, 2.3, 2.4, 4.2**

- [x] 2. Checkpoint - Verify gating service logic
  - Ensure all tests pass, ask the user if questions arise.

- [x] 3. Add gating guard to the practice route
  - [x] 3.1 Import `isSubconceptUnlocked` in `app.js` and add the gating check to `GET /practice/:conceptId`
    - Add `import { isSubconceptUnlocked } from './services/gatingService.js';` to the imports section of `app.js`
    - Insert the gating check after the concept lookup (`conceptRes`) and before the mastery/question-loading logic
    - Call `isSubconceptUnlocked(db, req.user.id, conceptId)` and check the result
    - If `unlocked: false`, respond with `res.status(403).render('practice-locked.ejs', { concept, reason, unmetPrereqs, user: req.user })`
    - If `unlocked: true`, continue to the existing question-loading logic unchanged
    - Database errors in the gating check propagate to the existing catch block → HTTP 500 + `console.error`, never default to unlocked
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [ ]* 3.2 Write property test: Practice route HTTP status matches gating result (Property 3)
    - **Property 3: Practice route HTTP status matches gating result**
    - **Validates: Requirements 3.1, 3.2, 4.3**

- [x] 4. Create the locked practice view
  - [x] 4.1 Create `views/practice-locked.ejs` template
    - Use the same Bootstrap 5 + theme.css styling as `practice.ejs` (dark theme, nav bar with back button)
    - Show the subconcept name the student tried to access
    - Display the reason it's locked: "Unit prerequisites not met" or "Subconcept prerequisites not met"
    - Render a list of unmet prerequisites with their names and current mastery percentages (e.g., "Basic Differentiation — 45%")
    - Include a "Back to Dashboard" link pointing to `/dashboard`
    - Ensure the page is accessible (proper heading hierarchy, semantic HTML, sufficient color contrast)
    - _Requirements: 3.1, 4.3_

- [x] 5. Handle entry points for new students
  - [x] 5.1 Verify that starting units and starting subconcepts are unlocked by default
    - Confirm that `isUnitUnlocked` returns `unlocked: true` for units with no `chapter_prerequisites` rows (the SQL query returns 0 rows → unlocked)
    - Confirm that `isSubconceptUnlocked` returns `unlocked: true` for subconcepts with no `concept_prerequisites` rows in an unlocked unit
    - Confirm that a new student with no `user_concept_mastery` entries can access starting subconcepts without 403
    - This is a verification step — the logic is already implemented in tasks 1.1 and 1.2, but explicitly test the entry-point path
    - _Requirements: 4.1, 4.2, 4.3_

  - [ ]* 5.2 Write unit tests for edge cases
    - New student (no mastery data) accessing a starting subconcept → unlocked
    - Student with all prereqs mastered at exactly 0.8 → unlocked
    - Student with one prereq at 0.79 → locked
    - Cross-chapter prerequisite enforcement (Math → Physics)
    - Database error during gating → HTTP 500, not default unlocked
    - Orphan subconcept with NULL `chapter_id` → treated as unlocked at unit level with warning
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 2.4, 3.4, 4.1, 4.2, 4.3_

- [x] 6. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- The design uses JavaScript (ES modules) matching the existing codebase
- No database migrations needed — `chapters`, `chapter_prerequisites`, `concepts`, `concept_prerequisites`, and `user_concept_mastery` tables already exist
- The `MASTERY_THRESHOLD` of 0.8 matches the dashboard's existing client-side logic
- Cross-chapter prerequisites from migration 007 are handled by the same `concept_prerequisites` table — no special code path needed
- Property tests validate universal correctness properties; unit tests validate specific examples and edge cases
