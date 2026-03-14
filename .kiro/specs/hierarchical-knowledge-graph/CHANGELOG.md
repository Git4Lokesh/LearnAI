# Hierarchical Knowledge Graph - Changelog

## 2024 - Complete JEE Syllabus Expansion

### Summary
Expanded the hierarchical knowledge graph specification from 15 chapters to the complete JEE 11th/12th syllabus with 73 chapters.

### Changes Made

#### 1. Chapter Structure Expansion
- **Previous**: 15 chapters (10 Physics Mechanics + 5 Mathematics)
- **Updated**: 73 chapters total
  - Physics: 27 chapters (Mechanics, Thermodynamics, Electromagnetism, Optics, Modern Physics)
  - Chemistry: 22 chapters (Physical, Inorganic, Organic)
  - Mathematics: 23 chapters (Algebra, Trigonometry, Coordinate Geometry, Calculus, Vectors, Probability)

#### 2. Files Updated

**design.md**:
- Updated Overview section with 73-chapter structure
- Expanded "JEE Chapter Seed Data" section with all 73 chapters organized by subject
- Added complete prerequisite relationships (within-subject and cross-subject)
- Updated SQL seed script with all 73 chapters and ~150 prerequisite relationships
- Updated Chapter Prerequisite Graph Visualization
- Updated all references from "15 chapters" to "73 chapters"
- Updated performance benchmarks to reflect larger dataset

**requirements.md**:
- Updated Introduction with complete chapter breakdown
- Updated Requirement 1 (Chapter Data Model) to include all 73 chapters
- Updated Requirement 2 (Chapter Prerequisite Relationships) to be more general and cover all subjects
- Updated Requirement 8 (Database Schema Migration) to reflect 73 chapters
- Updated Notes section with complete syllabus details

**tasks.md**:
- Updated Task 2.1 to reflect 73 chapters across all subjects
- Updated Task 2.4 verification step to check for 73 chapters

#### 3. Prerequisite Relationships Added

**Mathematics** (internal):
- Algebra progression (7 chapters)
- Trigonometry progression (3 chapters)
- Calculus progression (6 chapters)
- Coordinate Geometry progression (4 chapters)
- Probability progression (2 chapters)

**Physics** (internal):
- Mechanics progression (10 chapters)
- Thermodynamics progression (4 chapters)
- Electromagnetism progression (8 chapters)
- Optics progression (3 chapters)
- Modern Physics progression (2 chapters)

**Chemistry** (internal):
- Physical Chemistry progression (8 chapters)
- Inorganic Chemistry progression (7 chapters)
- Organic Chemistry progression (7 chapters)

**Cross-Subject Dependencies**:
- Math → Physics (15 relationships)
- Math → Chemistry (5 relationships)
- Physics → Chemistry (4 relationships)

#### 4. What Remained Unchanged

- Requirements document structure and acceptance criteria format
- Tasks document structure and implementation approach
- Design document architecture and algorithms
- Correctness properties (still valid for 73 chapters)
- Testing strategy
- API endpoint specifications
- Multi-tenant isolation approach
- BKT system integration

### Total Prerequisite Relationships
Approximately 150+ prerequisite relationships across all 73 chapters, ensuring pedagogically sound learning paths.

### Notes
- The 81 existing micro-concepts will be mapped to these 73 chapters in a future phase
- All prerequisite relationships follow standard JEE 11th/12th teaching progression
- Cross-subject dependencies ensure students have mathematical foundations before tackling advanced physics/chemistry topics
