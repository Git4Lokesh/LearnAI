# Requirements Document

## Introduction

This document specifies requirements for a Hierarchical (Two-Tier) Knowledge Graph system for Learn.ai, a B2B SaaS platform serving Indian JEE coaching institutes. The system addresses the "hairball problem" of displaying 81 micro-concepts in a flat graph by introducing a two-tier architecture: Tier 1 (Macro) displays chapter-level dependencies for all 73 JEE curriculum chapters across Physics (27 chapters), Chemistry (22 chapters), and Mathematics (23 chapters), and Tier 2 (Micro) provides drill-down views into micro-concepts within each chapter. This aligns with how coaching institutes organize their curriculum while maintaining the underlying Bayesian Knowledge Tracing (BKT) system for student mastery assessment.

## Glossary

- **Chapter**: A curriculum unit from the JEE 11th/12th syllabus (e.g., 'Kinematics', 'Newton's Laws')
- **Micro_Concept**: Granular learning units within a chapter (existing 81 concepts)
- **Macro_Graph**: The top-level dependency graph displaying chapters
- **Micro_Graph**: The drill-down graph displaying micro-concepts within a selected chapter
- **Ghost_Node**: A visual representation of a micro-concept from another chapter that appears in a drill-down view to show cross-chapter dependencies
- **Bridge_Edge**: A dependency edge in the macro graph connecting chapters when their micro-concepts have cross-chapter dependencies
- **Chapter_Mastery**: Aggregated mastery score for a chapter calculated as weighted average of child micro-concept BKT scores
- **BKT_System**: Bayesian Knowledge Tracing microservice that calculates student mastery probabilities
- **Knowledge_Graph**: The complete hierarchical structure of chapters and micro-concepts with their prerequisite relationships
- **Student_Dashboard**: The view where students see their personalized knowledge graph
- **Teacher_Dashboard**: The view where teachers see batch or individual student knowledge graphs
- **Institute**: A coaching center tenant in the multi-tenant system

## Requirements

### Requirement 1: Chapter Data Model

**User Story:** As a platform administrator, I want chapters to be stored with their metadata and relationships, so that the system can render the hierarchical knowledge graph correctly.

#### Acceptance Criteria

1. THE Database SHALL store chapters with id, name, subject, display_order, and description fields
2. THE Database SHALL store chapter prerequisite relationships in a separate table
3. THE Database SHALL link existing micro-concepts to chapters via a chapter_id foreign key
4. THE Database SHALL support all 73 JEE 11th/12th chapters across Physics (27 chapters), Chemistry (22 chapters), and Mathematics (23 chapters)
5. THE Database SHALL support Physics chapters covering Mechanics, Thermodynamics, Electromagnetism, Optics, and Modern Physics
6. THE Database SHALL support Chemistry chapters covering Physical Chemistry, Inorganic Chemistry, and Organic Chemistry
7. THE Database SHALL support Mathematics chapters covering Algebra, Trigonometry, Coordinate Geometry, Calculus, Vectors, and Probability
8. FOR ALL chapters, the display_order field SHALL determine the visual positioning in the macro graph
9. THE Database SHALL enforce referential integrity between chapters and chapter_prerequisites tables

### Requirement 2: Chapter Prerequisite Relationships

**User Story:** As a curriculum designer, I want chapter dependencies to reflect the standard JEE teaching progression, so that students see a logical learning path.

#### Acceptance Criteria

1. THE System SHALL model chapter-to-chapter dependencies based on JEE syllabus progression
2. WHEN a chapter requires mathematical foundations, THE System SHALL create prerequisite relationships to the appropriate Mathematics chapters
3. THE System SHALL represent prerequisite relationships within Mathematics (Algebra, Trigonometry, Calculus, Coordinate Geometry)
4. THE System SHALL represent prerequisite relationships within Physics (Mechanics, Thermodynamics, Electromagnetism, Optics, Modern Physics)
5. THE System SHALL represent prerequisite relationships within Chemistry (Physical, Inorganic, Organic)
6. THE System SHALL represent cross-subject dependencies from Mathematics to Physics
7. THE System SHALL represent cross-subject dependencies from Mathematics to Chemistry
8. THE System SHALL represent cross-subject dependencies from Physics to Chemistry
9. THE System SHALL model that foundational algebra chapters are prerequisites for advanced mathematics topics
10. THE System SHALL model that calculus and vectors are prerequisites for advanced physics topics
11. THE System SHALL prevent circular dependencies in chapter prerequisite relationships


### Requirement 3: Macro Graph Rendering

**User Story:** As a student, I want to see a chapter-level knowledge graph on my dashboard, so that I can understand the high-level curriculum structure without visual overwhelm.

#### Acceptance Criteria

1. WHEN a student views their dashboard, THE Student_Dashboard SHALL render a macro graph displaying chapters as nodes
2. THE Macro_Graph SHALL display chapter names as node labels
3. THE Macro_Graph SHALL display prerequisite relationships as directed edges between chapter nodes
4. THE Macro_Graph SHALL use vis-network library for graph visualization
5. THE Macro_Graph SHALL color-code chapter nodes based on Chapter_Mastery levels
6. WHEN a chapter has Chapter_Mastery above 80 percent, THE Macro_Graph SHALL display the node in green
7. WHEN a chapter has Chapter_Mastery between 50 and 80 percent, THE Macro_Graph SHALL display the node in yellow
8. WHEN a chapter has Chapter_Mastery below 50 percent, THE Macro_Graph SHALL display the node in red
9. WHEN a chapter has no mastery data, THE Macro_Graph SHALL display the node in gray
10. THE Macro_Graph SHALL position nodes using a hierarchical layout algorithm
11. THE Macro_Graph SHALL make chapter nodes clickable for drill-down navigation

### Requirement 4: Micro Graph Drill-Down

**User Story:** As a student, I want to click on a chapter node to see the detailed micro-concepts within that chapter, so that I can focus on specific learning units.

#### Acceptance Criteria

1. WHEN a student clicks a chapter node in the macro graph, THE Student_Dashboard SHALL render a micro graph displaying micro-concepts within that chapter
2. THE Micro_Graph SHALL display micro-concept names as node labels
3. THE Micro_Graph SHALL display prerequisite relationships between micro-concepts as directed edges
4. THE Micro_Graph SHALL use vis-network library for graph visualization
5. THE Micro_Graph SHALL color-code micro-concept nodes based on BKT mastery scores
6. THE Micro_Graph SHALL include a back button to return to the macro graph view
7. THE Micro_Graph SHALL display the chapter name as a header
8. WHEN a micro-concept has a prerequisite from another chapter, THE Micro_Graph SHALL display a Ghost_Node representing that external prerequisite
9. THE Ghost_Node SHALL be visually distinct from regular nodes using a dashed border
10. WHEN a student clicks a Ghost_Node, THE System SHALL navigate to the micro graph of the chapter containing that concept


### Requirement 5: Chapter Mastery Calculation

**User Story:** As a student, I want to see my mastery level for each chapter, so that I can identify which curriculum areas need more attention.

#### Acceptance Criteria

1. THE System SHALL calculate Chapter_Mastery as the weighted average of child micro-concept BKT scores
2. WHEN calculating Chapter_Mastery, THE System SHALL weight each micro-concept equally within its chapter
3. WHEN a chapter has no micro-concepts with mastery data, THE System SHALL return null for Chapter_Mastery
4. THE System SHALL recalculate Chapter_Mastery whenever a student answers questions related to micro-concepts in that chapter
5. THE System SHALL store Chapter_Mastery values in the user_concept_mastery table or equivalent structure
6. THE System SHALL retrieve Chapter_Mastery values efficiently for graph rendering without recalculating on every page load
7. FOR ALL chapters with at least one micro-concept having mastery data, Chapter_Mastery SHALL be a value between 0 and 1

### Requirement 6: Teacher Dashboard Hierarchical View

**User Story:** As a teacher, I want to view hierarchical knowledge graphs for my batches and individual students, so that I can identify learning gaps at both chapter and concept levels.

#### Acceptance Criteria

1. WHEN a teacher views the teacher dashboard, THE Teacher_Dashboard SHALL render a macro graph with aggregated batch mastery data
2. THE Teacher_Dashboard SHALL allow teachers to select individual students to view their personalized hierarchical graphs
3. THE Teacher_Dashboard SHALL allow teachers to select batches to view aggregated batch mastery across chapters
4. WHEN viewing batch data, THE System SHALL calculate batch-level Chapter_Mastery as the average of all students' Chapter_Mastery in that batch
5. THE Teacher_Dashboard SHALL support the same drill-down interaction from macro to micro graphs as the student dashboard
6. THE Teacher_Dashboard SHALL scope all data queries by institute_id for multi-tenant isolation
7. THE Teacher_Dashboard SHALL display the same color-coding scheme for mastery levels as the student dashboard

### Requirement 7: Cross-Chapter Dependency Visualization

**User Story:** As a student, I want to see when a concept I'm studying depends on concepts from other chapters, so that I can identify prerequisite knowledge gaps.

#### Acceptance Criteria

1. WHEN a micro-concept has a prerequisite from a different chapter, THE Micro_Graph SHALL display a Ghost_Node for that prerequisite
2. THE Ghost_Node SHALL display the prerequisite concept name and its chapter name in parentheses
3. THE Ghost_Node SHALL use a dashed border to distinguish it from concepts in the current chapter
4. WHEN multiple micro-concepts in a chapter depend on concepts from another chapter, THE Macro_Graph SHALL display a Bridge_Edge between those chapters
5. THE Bridge_Edge SHALL be visually distinct using a different color or style from regular prerequisite edges
6. THE System SHALL automatically generate Bridge_Edges based on cross-chapter micro-concept dependencies
7. WHEN a student clicks a Ghost_Node, THE System SHALL navigate to the micro graph of the source chapter and highlight the target concept


### Requirement 8: Database Schema Migration

**User Story:** As a platform administrator, I want to migrate the existing flat concept structure to a hierarchical structure, so that the system can support two-tier visualization without data loss.

#### Acceptance Criteria

1. THE System SHALL create a chapters table with columns: id (VARCHAR primary key), name (VARCHAR), subject (VARCHAR), display_order (INTEGER), description (TEXT)
2. THE System SHALL create a chapter_prerequisites table with columns: chapter_id (VARCHAR foreign key), prereq_id (VARCHAR foreign key), and a composite primary key on both columns
3. THE System SHALL add a chapter_id column to the existing concepts table as a nullable VARCHAR foreign key
4. THE System SHALL seed the chapters table with all 73 JEE chapters (27 Physics, 22 Chemistry, 23 Mathematics)
5. THE System SHALL seed the chapter_prerequisites table with prerequisite relationships following JEE curriculum progression
6. THE System SHALL maintain backward compatibility with existing queries on the concepts and concept_prerequisites tables
7. THE System SHALL use PostgreSQL with pg.Client for all database operations
8. THE Migration SHALL be idempotent and safe to run multiple times

### Requirement 9: API Endpoints for Hierarchical Data

**User Story:** As a frontend developer, I want API endpoints that provide hierarchical graph data, so that I can render the two-tier visualization efficiently.

#### Acceptance Criteria

1. THE System SHALL provide an endpoint that returns all chapters with their prerequisite relationships
2. THE System SHALL provide an endpoint that returns all micro-concepts for a specific chapter with their prerequisite relationships
3. THE System SHALL provide an endpoint that returns Chapter_Mastery scores for a specific user across all chapters
4. THE System SHALL provide an endpoint that returns batch-level Chapter_Mastery aggregations for a specific batch
5. WHEN querying chapter data, THE System SHALL include Chapter_Mastery scores in the response
6. WHEN querying micro-concept data, THE System SHALL identify and include Ghost_Nodes for cross-chapter prerequisites
7. THE System SHALL scope all API responses by institute_id for multi-tenant isolation
8. THE System SHALL return data in JSON format compatible with vis-network library
9. THE System SHALL use ES module syntax (import statements) for all new code

### Requirement 10: Graph Interaction and Navigation

**User Story:** As a student, I want intuitive navigation between macro and micro views, so that I can explore the knowledge graph efficiently.

#### Acceptance Criteria

1. WHEN viewing the macro graph, THE System SHALL display a legend explaining node colors and mastery levels
2. WHEN viewing the micro graph, THE System SHALL display a breadcrumb showing "All Chapters > [Chapter Name]"
3. THE System SHALL provide a back button in the micro graph view that returns to the macro graph
4. WHEN a student clicks a chapter node, THE System SHALL animate the transition to the micro graph view
5. THE System SHALL preserve the user's position and zoom level when navigating back to the macro graph
6. THE System SHALL support keyboard navigation with Escape key returning to the macro graph from micro view
7. THE System SHALL display loading indicators during graph data fetching and rendering
8. WHEN a graph has no data to display, THE System SHALL show an informative message instead of an empty graph


### Requirement 11: Performance and Scalability

**User Story:** As a platform administrator, I want the hierarchical graph to render quickly even with many students and concepts, so that the user experience remains smooth.

#### Acceptance Criteria

1. WHEN rendering the macro graph, THE System SHALL load and display chapter data within 500 milliseconds
2. WHEN rendering the micro graph, THE System SHALL load and display micro-concept data within 500 milliseconds
3. THE System SHALL cache Chapter_Mastery calculations to avoid recalculating on every page load
4. THE System SHALL use database indexes on chapter_id, concept_id, and user_id columns for efficient queries
5. WHEN calculating batch-level aggregations, THE System SHALL use efficient SQL aggregation queries rather than application-level loops
6. THE System SHALL limit the number of nodes displayed in a single graph view to prevent browser performance degradation
7. WHEN a chapter contains more than 50 micro-concepts, THE System SHALL paginate or provide filtering options

### Requirement 12: Multi-Tenant Data Isolation

**User Story:** As an institute administrator, I want my institute's knowledge graph data to be isolated from other institutes, so that student privacy and data security are maintained.

#### Acceptance Criteria

1. THE System SHALL scope all chapter and concept queries by institute_id
2. THE System SHALL prevent cross-institute data access through API endpoints
3. THE System SHALL validate institute_id from the authenticated user session before returning graph data
4. THE System SHALL store institute-specific chapter customizations if institutes modify the standard JEE curriculum
5. WHERE an institute has custom chapters, THE System SHALL display those chapters in addition to standard JEE chapters
6. THE System SHALL maintain separate mastery data for students across different institutes
7. THE System SHALL enforce row-level security for all database queries involving student mastery data

### Requirement 13: Integration with Existing BKT System

**User Story:** As a student, I want my knowledge graph to reflect my actual learning progress tracked by the BKT system, so that I see accurate mastery levels.

#### Acceptance Criteria

1. THE System SHALL retrieve micro-concept mastery scores from the existing user_concept_mastery table
2. WHEN the BKT_System updates mastery scores, THE System SHALL reflect those updates in the knowledge graph
3. THE System SHALL use the existing BKT microservice on port 8000 for mastery calculations
4. THE System SHALL maintain the existing mastery calculation logic (questions_answered, correct_answers fields)
5. THE System SHALL aggregate micro-concept BKT scores into Chapter_Mastery without modifying the BKT algorithm
6. THE System SHALL preserve the existing concept_prerequisites table for micro-concept dependencies
7. THE System SHALL support the existing multi-tenant architecture with institute_id scoping


### Requirement 14: EJS View Integration

**User Story:** As a frontend developer, I want to integrate the hierarchical graph into existing EJS views, so that students and teachers can access it through the current UI.

#### Acceptance Criteria

1. THE System SHALL modify views/dashboard.ejs to render the hierarchical knowledge graph for students
2. THE System SHALL modify views/institute-teacher-dashboard.ejs to render the hierarchical knowledge graph for teachers
3. THE System SHALL use the existing vis-network CDN library already loaded in the views
4. THE System SHALL use server-rendered EJS templates with client-side JavaScript for graph interactivity
5. THE System SHALL maintain the existing Express routing structure for dashboard views
6. THE System SHALL pass chapter and mastery data from Express route handlers to EJS templates
7. THE System SHALL use inline JavaScript in EJS templates for vis-network initialization and event handling
8. THE System SHALL maintain consistent styling with the existing dashboard UI

### Requirement 15: Error Handling and Edge Cases

**User Story:** As a student, I want the system to handle errors gracefully, so that I can still use the platform even when data is incomplete or unavailable.

#### Acceptance Criteria

1. WHEN a chapter has no assigned micro-concepts, THE Micro_Graph SHALL display a message "No concepts available for this chapter"
2. WHEN database queries fail, THE System SHALL log the error and display a user-friendly error message
3. WHEN a student has no mastery data, THE Macro_Graph SHALL display all chapters in gray with a message explaining how to start learning
4. WHEN the BKT_System is unavailable, THE System SHALL display cached mastery data with a warning indicator
5. IF a chapter prerequisite relationship creates a cycle, THE System SHALL log an error and exclude the problematic edge from the graph
6. WHEN a Ghost_Node references a non-existent concept, THE System SHALL log a warning and exclude that ghost node from rendering
7. THE System SHALL validate all user inputs for chapter_id and concept_id parameters to prevent SQL injection
8. WHEN vis-network fails to load, THE System SHALL display a fallback message with instructions to refresh the page

## Notes

- The existing 81 micro-concepts will be assigned to chapters in a future phase (NOT part of this specification)
- The system uses Express with EJS views, NOT React
- Database operations use pg.Client, NOT pg.Pool
- All code uses ES modules (import syntax)
- The vis-network library is already loaded via CDN in existing views
- Chapter prerequisite relationships follow standard JEE 11th/12th syllabus progression across all 73 chapters
- Ghost nodes and bridge edges are essential for handling cross-chapter dependencies
- Chapter mastery aggregation must be efficient to support real-time dashboard rendering with 73 chapters
- The complete JEE syllabus includes: 27 Physics chapters (Mechanics, Thermodynamics, Electromagnetism, Optics, Modern Physics), 22 Chemistry chapters (Physical, Inorganic, Organic), and 23 Mathematics chapters (Algebra, Trigonometry, Coordinate Geometry, Calculus, Vectors, Probability)
