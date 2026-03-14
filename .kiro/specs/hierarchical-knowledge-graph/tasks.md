# Implementation Plan: Hierarchical Knowledge Graph

## Overview

This implementation plan breaks down the hierarchical knowledge graph feature into discrete coding tasks. Each task builds on previous steps, following the design's implementation notes. The plan progresses from database schema changes through API endpoints, business logic, UI modifications, and testing.

## Tasks

- [x] 1. Database schema migration
  - [x] 1.1 Create migration file with chapters and chapter_prerequisites tables
    - Create `migrations/002_hierarchical_knowledge_graph.sql`
    - Define chapters table with id, name, subject, display_order, description columns
    - Define chapter_prerequisites table with composite primary key
    - Add chapter_id column to concepts table (nullable)
    - Create indexes for performance (chapter_id, subject, display_order)
    - _Requirements: 8.1, 8.2, 8.3, 8.7, 11.4_
  
  - [ ]* 1.2 Write property test for migration idempotence
    - **Property 9: Migration Idempotence**
    - **Validates: Requirements 8.8**
  
  - [x] 1.3 Run migration and verify schema
    - Execute migration script against PostgreSQL database
    - Verify tables exist with correct columns and constraints
    - Verify indexes are created
    - _Requirements: 8.1, 8.2, 8.3_

- [x] 2. Seed JEE chapter data
  - [x] 2.1 Create seed data SQL for 73 JEE chapters
    - Insert 27 Physics chapters (Mechanics, Thermodynamics, Electromagnetism, Optics, Modern Physics)
    - Insert 22 Chemistry chapters (Physical, Inorganic, Organic Chemistry)
    - Insert 23 Mathematics chapters (Algebra, Trigonometry, Coordinate Geometry, Calculus, Vectors, Probability)
    - Use display_order to match JEE curriculum progression
    - _Requirements: 1.1, 1.4, 1.5, 8.4_
  
  - [x] 2.2 Create seed data SQL for chapter prerequisite relationships
    - Insert Mathematics foundation prerequisites (basic_algebra → trigonometry, etc.)
    - Insert Physics mechanics progression prerequisites
    - Insert cross-subject dependencies (trigonometry → kinematics_2d, etc.)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10, 8.5_
  
  - [ ]* 2.3 Write property test for circular dependency prevention
    - **Property 8: Circular Dependency Prevention**
    - **Validates: Requirements 2.11**
  
  - [x] 2.4 Execute seed data and verify relationships
    - Run seed SQL script
    - Verify all 73 chapters inserted
    - Verify prerequisite relationships match design specification
    - _Requirements: 8.4, 8.5_

- [ ] 3. Checkpoint - Verify database setup
  - Ensure all tests pass, ask the user if questions arise.

- [x] 4. API endpoint for chapters data
  - [x] 4.1 Create GET /api/chapters endpoint
    - Query chapters table with optional subject filter
    - Query chapter_prerequisites table for relationships
    - Return JSON with chapters array and prerequisites array
    - Add institute_id scoping for multi-tenant isolation
    - _Requirements: 9.1, 9.7, 9.8, 9.9, 12.1, 12.3_
  
  - [ ]* 4.2 Write unit tests for GET /api/chapters endpoint
    - Test returns all chapters
    - Test subject filter works correctly
    - Test multi-tenant scoping (different institutes see different data)
    - Test error handling for database failures
    - _Requirements: 9.1, 12.2_
  
  - [ ]* 4.3 Write property test for API response completeness
    - **Property 10: API Response Completeness**
    - **Validates: Requirements 9.5, 9.6, 9.8**

- [x] 5. API endpoint for chapter concepts
  - [x] 5.1 Create GET /api/chapters/:chapterId/concepts endpoint
    - Query concepts table filtered by chapter_id
    - Query concept_prerequisites for relationships
    - Identify cross-chapter prerequisites (ghost nodes)
    - Return JSON with concepts, prerequisites, and ghostNodes arrays
    - Add institute_id scoping
    - _Requirements: 9.2, 9.6, 9.7, 9.8, 9.9, 12.1_
  
  - [ ]* 5.2 Write property test for ghost node generation
    - **Property 3: Ghost Node Generation for Cross-Chapter Dependencies**
    - **Validates: Requirements 4.8, 7.1, 7.2**
  
  - [ ]* 5.3 Write unit tests for GET /api/chapters/:chapterId/concepts endpoint
    - Test returns concepts for specific chapter
    - Test ghost nodes included for cross-chapter prerequisites
    - Test multi-tenant scoping
    - Test 404 for invalid chapter_id
    - _Requirements: 9.2, 9.6, 15.6_

- [x] 6. Chapter mastery calculation logic
  - [x] 6.1 Implement calculateChapterMastery function
    - Query all concepts in chapter from concepts table
    - Query mastery scores from user_concept_mastery table
    - Calculate weighted average (equal weights for all concepts)
    - Return null if no mastery data exists
    - _Requirements: 5.1, 5.2, 5.3, 13.1, 13.5_
  
  - [ ]* 6.2 Write property test for chapter mastery calculation
    - **Property 5: Chapter Mastery Calculation**
    - **Validates: Requirements 5.1, 5.2, 5.7**
  
  - [ ]* 6.3 Write property test for null mastery handling
    - **Property 6: Null Mastery for Empty Chapters**
    - **Validates: Requirements 5.3**
  
  - [ ]* 6.4 Write unit tests for calculateChapterMastery function
    - Test with known concept mastery values
    - Test with empty chapter (no concepts)
    - Test with chapter having no mastery data
    - Test mastery value is between 0 and 1
    - _Requirements: 5.1, 5.2, 5.3, 5.7_

- [x] 7. API endpoint for user chapter mastery
  - [x] 7.1 Create GET /api/user/:userId/chapter-mastery endpoint
    - Query all chapters
    - Calculate chapter mastery for each chapter using calculateChapterMastery
    - Return JSON with userId and chapterMastery array
    - Add institute_id scoping
    - _Requirements: 9.3, 9.5, 9.7, 9.9, 12.1_
  
  - [ ]* 7.2 Write property test for BKT integration consistency
    - **Property 13: BKT Integration Consistency**
    - **Validates: Requirements 13.1, 13.2, 13.5**
  
  - [ ]* 7.3 Write unit tests for GET /api/user/:userId/chapter-mastery endpoint
    - Test returns mastery for all chapters
    - Test multi-tenant scoping
    - Test handles user with no mastery data
    - _Requirements: 9.3, 15.3_

- [x] 8. Batch chapter mastery aggregation
  - [x] 8.1 Implement calculateBatchChapterMastery function
    - Query all students in batch from batch_students table
    - Aggregate mastery by chapter using SQL AVG, MIN, MAX
    - Count students with mastery >= 0.8 for each chapter
    - Return array with chapter_id, avg_mastery, min_mastery, max_mastery, students_mastered
    - _Requirements: 6.4, 11.5_
  
  - [ ]* 8.2 Write unit tests for calculateBatchChapterMastery function
    - Test with known student mastery data
    - Test with empty batch (no students)
    - Test aggregation calculations are correct
    - _Requirements: 6.4_

- [x] 9. API endpoint for batch chapter mastery
  - [x] 9.1 Create GET /api/batch/:batchId/chapter-mastery endpoint
    - Use calculateBatchChapterMastery function
    - Return JSON with batchId, studentCount, and chapterMastery array
    - Add institute_id scoping
    - _Requirements: 9.4, 9.7, 9.9, 12.1_
  
  - [ ]* 9.2 Write property test for multi-tenant data isolation
    - **Property 11: Multi-Tenant Data Isolation**
    - **Validates: Requirements 9.7, 12.1, 12.2, 12.3, 12.7**
  
  - [ ]* 9.3 Write unit tests for GET /api/batch/:batchId/chapter-mastery endpoint
    - Test returns batch aggregation
    - Test multi-tenant scoping
    - Test handles batch with no students
    - _Requirements: 9.4, 12.2_

- [ ] 10. Checkpoint - Verify API endpoints
  - Ensure all tests pass, ask the user if questions arise.

- [x] 11. Student dashboard macro graph view
  - [x] 11.1 Modify views/dashboard.ejs to add macro graph container
    - Add div container for macro graph visualization
    - Add legend explaining node colors and mastery levels
    - Add loading indicator for graph data fetching
    - _Requirements: 3.1, 10.1, 10.7, 14.1_
  
  - [x] 11.2 Add client-side JavaScript for macro graph rendering
    - Fetch chapter data from GET /api/chapters endpoint
    - Fetch user chapter mastery from GET /api/user/:userId/chapter-mastery endpoint
    - Initialize vis-network with chapter nodes and edges
    - Color-code nodes based on mastery levels (green >= 0.8, yellow 0.5-0.8, red < 0.5, gray no data)
    - Use hierarchical layout algorithm
    - Add click event handlers for drill-down navigation
    - _Requirements: 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11, 14.3, 14.7_
  
  - [ ]* 11.3 Write property test for chapter node color-coding
    - **Property 1: Chapter Node Color-Coding**
    - **Validates: Requirements 3.5, 3.6, 3.7, 3.8, 3.9**
  
  - [ ]* 11.4 Write property test for hierarchical node positioning
    - **Property 2: Hierarchical Node Positioning**
    - **Validates: Requirements 1.6, 3.10**

- [x] 12. Student dashboard micro graph drill-down
  - [x] 12.1 Add micro graph container to views/dashboard.ejs
    - Add div container for micro graph (initially hidden)
    - Add breadcrumb showing "All Chapters > [Chapter Name]"
    - Add back button to return to macro graph
    - Add chapter name header
    - _Requirements: 4.1, 4.6, 4.7, 10.2, 10.3, 14.1_
  
  - [x] 12.2 Add client-side JavaScript for micro graph rendering
    - Fetch micro-concepts from GET /api/chapters/:chapterId/concepts endpoint
    - Initialize vis-network with concept nodes and edges
    - Render ghost nodes with dashed borders for cross-chapter prerequisites
    - Color-code nodes based on BKT mastery scores
    - Add click handler for ghost nodes to navigate to source chapter
    - Add back button handler to return to macro graph
    - Preserve zoom level and position when navigating back
    - _Requirements: 4.2, 4.3, 4.4, 4.5, 4.8, 4.9, 4.10, 10.3, 10.4, 10.5, 14.3, 14.7_
  
  - [ ]* 12.3 Write property test for ghost node visual distinction
    - **Property 4: Ghost Node Visual Distinction**
    - **Validates: Requirements 4.9, 7.3, 7.5**
  
  - [ ]* 12.4 Write unit tests for micro graph interactions
    - Test drill-down navigation on chapter click
    - Test back button returns to macro graph
    - Test ghost node click navigates to source chapter
    - Test keyboard navigation (Escape key)
    - _Requirements: 4.1, 4.10, 10.3, 10.6_

- [x] 13. Teacher dashboard macro graph view
  - [x] 13.1 Modify views/institute-teacher-dashboard.ejs to add macro graph container
    - Add div container for macro graph visualization
    - Add batch selector dropdown
    - Add student selector dropdown
    - Add legend explaining node colors and mastery levels
    - _Requirements: 6.1, 6.2, 6.3, 14.2_
  
  - [x] 13.2 Add client-side JavaScript for teacher macro graph rendering
    - Fetch chapter data from GET /api/chapters endpoint
    - Fetch batch chapter mastery from GET /api/batch/:batchId/chapter-mastery endpoint
    - Initialize vis-network with chapter nodes and edges
    - Color-code nodes based on batch average mastery
    - Add click event handlers for drill-down navigation
    - _Requirements: 6.1, 6.4, 6.5, 6.6, 6.7, 14.3, 14.7_
  
  - [ ]* 13.3 Write unit tests for teacher dashboard batch selection
    - Test batch selector updates graph data
    - Test student selector updates graph data
    - Test multi-tenant scoping
    - _Requirements: 6.2, 6.3, 6.6_

- [x] 14. Teacher dashboard micro graph drill-down
  - [x] 14.1 Add micro graph container to views/institute-teacher-dashboard.ejs
    - Add div container for micro graph (initially hidden)
    - Add breadcrumb and back button
    - Add chapter name header
    - _Requirements: 6.5, 14.2_
  
  - [x] 14.2 Add client-side JavaScript for teacher micro graph rendering
    - Fetch micro-concepts from GET /api/chapters/:chapterId/concepts endpoint
    - Initialize vis-network with concept nodes and edges
    - Render ghost nodes with dashed borders
    - Color-code nodes based on batch average or individual student mastery
    - Add click handler for ghost nodes
    - Add back button handler
    - _Requirements: 6.5, 14.3, 14.7_

- [x] 15. Ghost node and bridge edge generation
  - [x] 15.1 Implement generateGhostNodes function
    - Query all concepts in target chapter
    - Find prerequisites that are NOT in the same chapter
    - Return array of ghost nodes with concept id, name, chapter_id, chapter_name
    - _Requirements: 7.1, 7.2_
  
  - [x] 15.2 Implement calculateBridgeEdges function
    - Query all cross-chapter concept dependencies
    - Aggregate by source and target chapter
    - Count number of cross-chapter dependencies
    - Return array of bridge edges with from_chapter, to_chapter, concept_count
    - _Requirements: 7.4, 7.6_
  
  - [ ]* 15.3 Write property test for bridge edge generation
    - **Property 7: Bridge Edge Generation**
    - **Validates: Requirements 7.4, 7.6**
  
  - [ ]* 15.4 Write unit tests for ghost node and bridge edge functions
    - Test ghost nodes generated for cross-chapter prerequisites
    - Test bridge edges calculated correctly
    - Test no ghost nodes for same-chapter prerequisites
    - _Requirements: 7.1, 7.2, 7.4_

- [x] 16. Integrate bridge edges into macro graph rendering
  - [x] 16.1 Update macro graph rendering to display bridge edges
    - Fetch bridge edges using calculateBridgeEdges function
    - Add bridge edges to vis-network graph with distinct styling
    - Use different color or dashed style for bridge edges
    - _Requirements: 7.4, 7.5_
  
  - [ ]* 16.2 Write unit tests for bridge edge display
    - Test bridge edges appear in macro graph
    - Test bridge edges have distinct styling
    - _Requirements: 7.4, 7.5_

- [x] 17. Error handling and edge cases
  - [x] 17.1 Add error handling for empty chapters
    - Display message "No concepts available for this chapter" when chapter has no concepts
    - _Requirements: 15.1_
  
  - [x] 17.2 Add error handling for database failures
    - Wrap all database queries in try-catch blocks
    - Log errors with query context
    - Display user-friendly error messages
    - Return appropriate HTTP status codes
    - _Requirements: 15.2_
  
  - [x] 17.3 Add error handling for missing mastery data
    - Display all chapters in gray when student has no mastery data
    - Show message explaining how to start learning
    - _Requirements: 15.3_
  
  - [x] 17.4 Add error handling for BKT service unavailability
    - Display cached mastery data with warning indicator
    - _Requirements: 15.4_
  
  - [x] 17.5 Add validation for circular dependencies
    - Log error and exclude problematic edge from graph
    - _Requirements: 15.5_
  
  - [x] 17.6 Add validation for invalid ghost nodes
    - Log warning and exclude ghost node from rendering
    - _Requirements: 15.6_
  
  - [x] 17.7 Add input validation for API parameters
    - Validate chapter_id, concept_id, user_id parameters
    - Prevent SQL injection
    - _Requirements: 15.7_
  
  - [x] 17.8 Add fallback for vis-network load failure
    - Display fallback message with instructions to refresh
    - _Requirements: 15.8_
  
  - [ ]* 17.9 Write unit tests for error handling
    - Test empty chapter message
    - Test database error handling
    - Test missing mastery data handling
    - Test input validation
    - _Requirements: 15.1, 15.2, 15.3, 15.7_

- [ ] 18. Performance optimizations
  - [ ] 18.1 Add caching for chapter mastery calculations
    - Implement caching mechanism (Redis or in-memory)
    - Cache chapter mastery values
    - Invalidate cache on BKT score updates
    - _Requirements: 5.4, 5.6, 11.3_
  
  - [ ] 18.2 Optimize database queries with connection pooling
    - Configure pg connection pooling
    - Batch database queries where possible
    - _Requirements: 11.1, 11.2_
  
  - [x] 18.3 Add pagination for large concept sets
    - Implement pagination when chapter has > 50 concepts
    - Add filtering options
    - _Requirements: 11.6, 11.7_
  
  - [ ]* 18.4 Write property test for node display limit
    - **Property 14: Node Display Limit**
    - **Validates: Requirements 11.6, 11.7**
  
  - [ ]* 18.5 Write performance tests
    - Test macro graph renders within 500ms
    - Test micro graph renders within 500ms
    - Test batch aggregation completes within 1s
    - _Requirements: 11.1, 11.2, 11.5_

- [x] 19. Integration and wiring
  - [x] 19.1 Wire all API endpoints into Express app
    - Add routes for all new endpoints
    - Add middleware for authentication and institute_id validation
    - Add error handling middleware
    - _Requirements: 9.9, 12.3, 14.5_
  
  - [x] 19.2 Update Express route handlers for dashboard views
    - Pass chapter and mastery data to EJS templates
    - Add institute_id scoping to all queries
    - _Requirements: 14.5, 14.6_
  
  - [x] 19.3 Ensure backward compatibility with existing features
    - Verify existing concept queries still work
    - Verify BKT system integration unchanged
    - Verify multi-tenant isolation maintained
    - _Requirements: 8.6, 13.3, 13.4, 13.6_
  
  - [ ]* 19.4 Write property test for backward compatibility
    - **Property 12: Backward Compatibility**
    - **Validates: Requirements 8.6**
  
  - [ ]* 19.5 Write integration tests for end-to-end scenarios
    - Test student views dashboard → macro graph → micro graph → ghost node navigation
    - Test teacher selects batch → views batch graph → drills down
    - Test student answers questions → BKT updates → chapter mastery recalculates
    - _Requirements: 3.1, 4.1, 6.1, 13.2, 13.4_

- [ ] 20. Final checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- The implementation uses JavaScript with Node.js, Express, PostgreSQL, and vis-network
- All code uses ES module syntax (import/export)
- Multi-tenant isolation with institute_id scoping is critical throughout
