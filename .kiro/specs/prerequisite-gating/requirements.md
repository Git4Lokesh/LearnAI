# Requirements Document

## Introduction

The Learn.ai dashboard already renders locked/unlocked/mastered visual states, cross-chapter prerequisite edges, and tooltip messaging. What is missing is the server-side enforcement layer: a Gating_Service that evaluates prerequisite mastery and a guard on the practice route (`GET /practice/:conceptId`) that blocks access to locked subconcepts. Currently, students can practice any subconcept by navigating directly to its URL, bypassing the intended prerequisite sequence.

This spec covers only the gating logic and route enforcement. Dashboard visuals, cross-chapter edge rendering, and redirect page design are out of scope (already implemented).

## Glossary

- **Subconcept**: A row in the `concepts` table belonging to a parent unit via `chapter_id`. There are 221 NTA subconcepts.
- **Unit**: A row in the `chapters` table representing an NTA syllabus unit. There are 54 units across Physics (20), Chemistry (20), and Mathematics (14).
- **Mastery**: A numeric value (0.0–1.0) tracked per student per subconcept in `user_concept_mastery`, computed by the BKT microservice.
- **Mastery_Threshold**: The mastery value of 0.8 at or above which a subconcept is considered mastered.
- **Unit_Prerequisite**: A row in `chapter_prerequisites` indicating that one unit must be completed before another.
- **Subconcept_Prerequisite**: A row in `concept_prerequisites` indicating that one subconcept must be mastered before another (including cross-chapter edges from migration 007).
- **Locked_State**: A subconcept or unit whose prerequisites have not been met, making it unavailable for practice.
- **Unlocked_State**: A subconcept or unit whose prerequisites are all met, making it available for practice.
- **Starting_Unit**: A unit with no rows in `chapter_prerequisites` (as `chapter_id`), i.e., no prerequisite units.
- **Starting_Subconcept**: A subconcept within an unlocked unit that has no rows in `concept_prerequisites` (as `concept_id`).
- **Practice_Route**: The Express route `GET /practice/:conceptId` in `app.js` that loads a practice session.
- **Gating_Service**: A new server-side module (`services/gatingService.js`) that evaluates whether a student has met all prerequisites for a given subconcept or unit.

## Requirements

### Requirement 1: Unit Unlock Logic

**User Story:** As a student, I want units to unlock only after I have mastered all subconcepts in their prerequisite units, so that I build a solid foundation before advancing.

#### Acceptance Criteria

1. THE Gating_Service SHALL consider a unit unlocked when every subconcept belonging to each of the unit's prerequisite units (looked up via `chapter_prerequisites`) has mastery ≥ Mastery_Threshold for the requesting student.
2. WHEN a unit has no entries in `chapter_prerequisites` as a dependent, THE Gating_Service SHALL treat that unit as unlocked for all students.
3. WHEN a student's mastery for any subconcept in any prerequisite unit is below Mastery_Threshold, THE Gating_Service SHALL treat the dependent unit as locked.
4. THE Gating_Service SHALL evaluate unit unlock status by querying `user_concept_mastery` joined with `concepts` and `chapter_prerequisites` in a single database round-trip.

### Requirement 2: Subconcept Unlock Logic

**User Story:** As a student, I want subconcepts to unlock only when their parent unit is unlocked and their direct prerequisite subconcepts are mastered, so that I follow the correct learning sequence.

#### Acceptance Criteria

1. THE Gating_Service SHALL consider a subconcept unlocked only when both conditions are met: (a) the subconcept's parent unit is in Unlocked_State, and (b) every subconcept listed as a prerequisite in `concept_prerequisites` has mastery ≥ Mastery_Threshold for the requesting student.
2. WHEN a subconcept has no entries in `concept_prerequisites` as a dependent and its parent unit is unlocked, THE Gating_Service SHALL treat that subconcept as unlocked.
3. WHEN a subconcept's parent unit is in Locked_State, THE Gating_Service SHALL treat the subconcept as locked regardless of subconcept-level prerequisite mastery.
4. THE Gating_Service SHALL enforce cross-chapter subconcept prerequisites (e.g., Math subconcepts required for Physics subconcepts from `concept_prerequisites`) identically to within-chapter prerequisites.

### Requirement 3: Server-Side Practice Route Enforcement

**User Story:** As a student, I want the system to prevent me from accessing locked subconcepts via direct URL navigation, so that I cannot bypass the prerequisite sequence.

#### Acceptance Criteria

1. WHEN a student navigates to `GET /practice/:conceptId` for a subconcept in Locked_State, THE Practice_Route SHALL respond with HTTP 403 and render a message listing the unmet prerequisite subconcepts with their current mastery percentages.
2. WHEN a student navigates to `GET /practice/:conceptId` for a subconcept in Unlocked_State, THE Practice_Route SHALL load the practice session as normal.
3. THE Practice_Route SHALL call the Gating_Service to evaluate unlock status on every request, without relying on cached or dashboard-computed state.
4. IF the Gating_Service encounters a database error during prerequisite evaluation, THEN THE Practice_Route SHALL respond with HTTP 500 and log the error, rather than defaulting to unlocked.

### Requirement 4: Default Unlock for Entry Points

**User Story:** As a new student, I want the first units in each subject and their prerequisite-free subconcepts to be available immediately, so that I can start learning without any prior mastery.

#### Acceptance Criteria

1. THE Gating_Service SHALL treat every unit with no rows in `chapter_prerequisites` (as `chapter_id`) as unlocked for all students, including students with no mastery data.
2. THE Gating_Service SHALL treat every subconcept with no rows in `concept_prerequisites` (as `concept_id`) within an unlocked unit as unlocked for all students.
3. WHEN a new student with no entries in `user_concept_mastery` accesses any Starting_Subconcept via the Practice_Route, THE Practice_Route SHALL load the practice session without returning 403.
