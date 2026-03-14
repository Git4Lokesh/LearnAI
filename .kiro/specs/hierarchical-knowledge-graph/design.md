# Design Document: Hierarchical Knowledge Graph

## Overview

The Hierarchical Knowledge Graph feature introduces a two-tier visualization system to address the "hairball problem" of displaying 81 micro-concepts in a flat graph. The system provides:

1. **Macro View (Tier 1)**: Chapter-level dependency graph showing 73 JEE curriculum chapters across Physics (27), Chemistry (22), and Mathematics (23)
2. **Micro View (Tier 2)**: Drill-down views displaying micro-concepts within each chapter

This design aligns with how Indian JEE coaching institutes organize their curriculum while maintaining the underlying Bayesian Knowledge Tracing (BKT) system for student mastery assessment.

### Key Design Principles

- **Curriculum Alignment**: Chapter structure follows standard JEE 11th/12th syllabus progression
- **Progressive Disclosure**: Users see high-level structure first, then drill down to details
- **Cross-Chapter Dependencies**: Ghost nodes and bridge edges visualize dependencies across chapters
- **Multi-Tenant Isolation**: All data scoped by institute_id for B2B SaaS architecture
- **Performance**: Efficient aggregation and caching for real-time dashboard rendering

## Architecture

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Client Layer (Browser)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ dashboard.ejs│  │ teacher-dash │  │ vis-network  │      │
│  │              │  │     .ejs     │  │   library    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTP/JSON
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Express Application Layer                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  API Endpoints                                        │   │
│  │  • GET /api/chapters                                  │   │
│  │  • GET /api/chapters/:id/concepts                     │   │
│  │  • GET /api/user/:userId/chapter-mastery              │   │
│  │  • GET /api/batch/:batchId/chapter-mastery            │   │
│  └──────────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Business Logic                                       │   │
│  │  • Chapter mastery aggregation                        │   │
│  │  • Ghost node generation                              │   │
│  │  • Bridge edge calculation                            │   │
│  │  • Multi-tenant data scoping                          │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ SQL Queries
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   chapters   │  │   concepts   │  │user_concept_ │      │
│  │              │  │              │  │   mastery    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │   chapter_   │  │   concept_   │                        │
│  │prerequisites │  │prerequisites │                        │
│  └──────────────┘  └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

#### Macro Graph Rendering
1. Client requests dashboard page
2. Server queries chapters table with prerequisites
3. Server calculates chapter mastery for user/batch
4. Server renders EJS template with graph data
5. Client-side JavaScript initializes vis-network with chapter nodes
6. User sees color-coded chapter graph based on mastery levels

#### Micro Graph Drill-Down
1. User clicks chapter node in macro graph
2. Client requests micro-concepts for chapter
3. Server queries concepts filtered by chapter_id
4. Server identifies cross-chapter prerequisites (ghost nodes)
5. Server returns concept graph data with ghost nodes
6. Client renders micro graph with drill-down view

## Components and Interfaces

### Database Schema

#### New Tables

**chapters**
```sql
CREATE TABLE chapters (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    display_order INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
```

**chapter_prerequisites**
```sql
CREATE TABLE chapter_prerequisites (
    chapter_id VARCHAR(100) NOT NULL,
    prereq_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (chapter_id, prereq_id),
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES chapters(id) ON DELETE CASCADE
);
```

#### Modified Tables

**concepts** (add chapter_id column)
```sql
ALTER TABLE concepts 
ADD COLUMN chapter_id VARCHAR(100) REFERENCES chapters(id);

CREATE INDEX idx_concepts_chapter ON concepts(chapter_id);
```

#### Indexes for Performance
```sql
CREATE INDEX idx_chapters_subject ON chapters(subject);
CREATE INDEX idx_chapters_display_order ON chapters(display_order);
CREATE INDEX idx_chapter_prereqs_chapter ON chapter_prerequisites(chapter_id);
CREATE INDEX idx_chapter_prereqs_prereq ON chapter_prerequisites(prereq_id);
```

### API Endpoints

#### GET /api/chapters
Returns all chapters with prerequisite relationships.

**Query Parameters:**
- `subject` (optional): Filter by subject (e.g., "Physics - Mechanics", "Mathematics")
- `instituteId` (required): Institute ID for multi-tenant scoping

**Response:**
```json
{
  "chapters": [
    {
      "id": "kinematics_1d",
      "name": "Kinematics (1D)",
      "subject": "Physics - Mechanics",
      "display_order": 2,
      "description": "Motion in one dimension"
    }
  ],
  "prerequisites": [
    {
      "chapter_id": "kinematics_2d",
      "prereq_id": "kinematics_1d"
    }
  ]
}
```

#### GET /api/chapters/:chapterId/concepts
Returns micro-concepts for a specific chapter with prerequisites.

**Query Parameters:**
- `userId` (optional): User ID for mastery data
- `instituteId` (required): Institute ID for multi-tenant scoping

**Response:**
```json
{
  "chapter": {
    "id": "kinematics_1d",
    "name": "Kinematics (1D)"
  },
  "concepts": [
    {
      "id": "kinematics_1d_velocity",
      "name": "Speed and Velocity in 1D",
      "chapter_id": "kinematics_1d"
    }
  ],
  "prerequisites": [
    {
      "concept_id": "kinematics_1d_velocity",
      "prereq_id": "motion_basic_terminology"
    }
  ],
  "ghostNodes": [
    {
      "id": "motion_basic_terminology",
      "name": "Position, Displacement and Distance",
      "chapter_id": "units_measurements",
      "chapter_name": "Units & Measurements"
    }
  ]
}
```

#### GET /api/user/:userId/chapter-mastery
Returns chapter mastery scores for a specific user.

**Query Parameters:**
- `instituteId` (required): Institute ID for multi-tenant scoping

**Response:**
```json
{
  "userId": 123,
  "chapterMastery": [
    {
      "chapter_id": "kinematics_1d",
      "mastery": 0.75,
      "concept_count": 8,
      "mastered_count": 6
    }
  ]
}
```

#### GET /api/batch/:batchId/chapter-mastery
Returns aggregated chapter mastery for a batch.

**Query Parameters:**
- `instituteId` (required): Institute ID for multi-tenant scoping

**Response:**
```json
{
  "batchId": 5,
  "studentCount": 25,
  "chapterMastery": [
    {
      "chapter_id": "kinematics_1d",
      "avg_mastery": 0.68,
      "min_mastery": 0.35,
      "max_mastery": 0.95,
      "students_mastered": 18
    }
  ]
}
```

### Graph Rendering Components

#### Macro Graph Renderer
**Location:** `views/dashboard.ejs` and `views/institute-teacher-dashboard.ejs`

**Responsibilities:**
- Initialize vis-network with chapter nodes
- Color-code nodes based on chapter mastery
- Handle click events for drill-down navigation
- Display legend and controls

**Node Styling:**
```javascript
{
  id: 'kinematics_1d',
  label: 'Kinematics (1D)',
  color: {
    background: masteryColor(0.75), // Green for ≥80%, Yellow for 50-80%, Red for <50%
    border: masteryColor(0.75)
  },
  shape: 'dot',
  size: 20 + (mastery * 15) // Size scales with mastery
}
```

#### Micro Graph Renderer
**Location:** Client-side JavaScript in EJS templates

**Responsibilities:**
- Render micro-concepts within selected chapter
- Display ghost nodes for cross-chapter prerequisites
- Style ghost nodes with dashed borders
- Handle navigation back to macro view
- Handle ghost node clicks to navigate to source chapter

**Ghost Node Styling:**
```javascript
{
  id: 'motion_basic_terminology',
  label: 'Position, Displacement\n(Units & Measurements)',
  color: {
    background: '#6B7280',
    border: '#9CA3AF'
  },
  shape: 'dot',
  borderWidth: 2,
  borderWidthSelected: 3,
  shapeProperties: {
    borderDashes: [5, 5] // Dashed border
  }
}
```

## Data Models

### Chapter Model
```typescript
interface Chapter {
  id: string;              // e.g., "kinematics_1d"
  name: string;            // e.g., "Kinematics (1D)"
  subject: string;         // e.g., "Physics - Mechanics"
  display_order: number;   // For visual positioning
  description: string;     // Optional description
  created_at: Date;
}
```

### Chapter Prerequisite Model
```typescript
interface ChapterPrerequisite {
  chapter_id: string;      // Target chapter
  prereq_id: string;       // Prerequisite chapter
}
```

### Chapter Mastery Model
```typescript
interface ChapterMastery {
  chapter_id: string;
  user_id: number;
  mastery: number;         // 0.0 to 1.0
  concept_count: number;   // Total concepts in chapter
  mastered_count: number;  // Concepts with mastery ≥ 0.8
  last_updated: Date;
}
```

### Ghost Node Model
```typescript
interface GhostNode {
  id: string;              // Concept ID
  name: string;            // Concept name
  chapter_id: string;      // Source chapter ID
  chapter_name: string;    // Source chapter name
  mastery?: number;        // Optional mastery score
}
```

### Bridge Edge Model
```typescript
interface BridgeEdge {
  from_chapter: string;    // Source chapter
  to_chapter: string;      // Target chapter
  concept_count: number;   // Number of cross-chapter dependencies
}
```

### JEE Chapter Seed Data

#### Physics Chapters (27)

**Mechanics (10 chapters):**
1. **units_measurements**: Units & Measurements
2. **kinematics_1d**: Kinematics (1D)
3. **kinematics_2d**: Kinematics (2D)
4. **laws_of_motion**: Laws of Motion
5. **circular_motion**: Circular Motion
6. **work_energy_power**: Work Energy & Power
7. **com_momentum_collisions**: Centre of Mass Momentum & Collisions
8. **simple_harmonic_motion**: Simple Harmonic Motion
9. **rotational_mechanics**: Rotational Mechanics
10. **gravitation**: Gravitation

**Thermodynamics (4 chapters):**
11. **thermal_properties**: Thermal Properties of Matter
12. **thermodynamics**: Thermodynamics
13. **kinetic_theory**: Kinetic Theory of Gases
14. **calorimetry**: Calorimetry and Heat Transfer

**Electromagnetism (8 chapters):**
15. **electrostatics**: Electrostatics
16. **capacitance**: Capacitance
17. **current_electricity**: Current Electricity
18. **magnetic_effects**: Magnetic Effects of Current
19. **magnetism**: Magnetism and Matter
20. **electromagnetic_induction**: Electromagnetic Induction
21. **ac_circuits**: AC Circuits
22. **electromagnetic_waves**: Electromagnetic Waves

**Optics (3 chapters):**
23. **ray_optics**: Ray Optics
24. **wave_optics**: Wave Optics
25. **optical_instruments**: Optical Instruments

**Modern Physics (2 chapters):**
26. **dual_nature**: Dual Nature of Matter and Radiation
27. **atoms_nuclei**: Atoms and Nuclei

#### Chemistry Chapters (22)

**Physical Chemistry (8 chapters):**
28. **atomic_structure**: Atomic Structure
29. **chemical_bonding**: Chemical Bonding
30. **states_of_matter**: States of Matter
31. **thermodynamics_chem**: Thermodynamics (Chemistry)
32. **chemical_equilibrium**: Chemical Equilibrium
33. **ionic_equilibrium**: Ionic Equilibrium
34. **redox_reactions**: Redox Reactions and Electrochemistry
35. **chemical_kinetics**: Chemical Kinetics

**Inorganic Chemistry (7 chapters):**
36. **periodic_table**: Periodic Table and Periodicity
37. **s_block**: s-Block Elements
38. **p_block**: p-Block Elements
39. **d_block**: d-Block and f-Block Elements
40. **coordination_compounds**: Coordination Compounds
41. **metallurgy**: Metallurgy
42. **qualitative_analysis**: Qualitative Analysis

**Organic Chemistry (7 chapters):**
43. **basic_organic**: Basic Organic Chemistry
44. **hydrocarbons**: Hydrocarbons
45. **organic_compounds_oxygen**: Organic Compounds with Oxygen
46. **organic_compounds_nitrogen**: Organic Compounds with Nitrogen
47. **polymers**: Polymers
48. **biomolecules**: Biomolecules
49. **chemistry_everyday**: Chemistry in Everyday Life

#### Mathematics Chapters (23)

**Algebra (7 chapters):**
50. **sets_relations**: Sets and Relations
51. **complex_numbers**: Complex Numbers
52. **quadratic_equations**: Quadratic Equations
53. **sequences_series**: Sequences and Series
54. **permutations_combinations**: Permutations and Combinations
55. **binomial_theorem**: Binomial Theorem
56. **matrices_determinants**: Matrices and Determinants

**Trigonometry (3 chapters):**
57. **trigonometric_functions**: Trigonometric Functions
58. **inverse_trigonometry**: Inverse Trigonometry
59. **trigonometric_equations**: Trigonometric Equations

**Coordinate Geometry (4 chapters):**
60. **straight_lines**: Straight Lines
61. **circles**: Circles
62. **conic_sections**: Conic Sections
63. **3d_geometry**: Three Dimensional Geometry

**Calculus (5 chapters):**
64. **limits_continuity**: Limits and Continuity
65. **differentiation**: Differentiation
66. **applications_derivatives**: Applications of Derivatives
67. **integration**: Integration
68. **applications_integrals**: Applications of Integrals
69. **differential_equations**: Differential Equations

**Vectors and Probability (4 chapters):**
70. **vectors_3d**: Vectors
71. **probability**: Probability
72. **statistics**: Statistics
73. **mathematical_reasoning**: Mathematical Reasoning

### Chapter Prerequisite Relationships

Based on JEE syllabus progression:

**Mathematics Foundation:**
- sets_relations → complex_numbers
- sets_relations → sequences_series
- sets_relations → probability
- complex_numbers → quadratic_equations
- quadratic_equations → sequences_series
- sequences_series → binomial_theorem
- permutations_combinations → binomial_theorem
- permutations_combinations → probability
- matrices_determinants → vectors_3d
- trigonometric_functions → inverse_trigonometry
- trigonometric_functions → trigonometric_equations
- trigonometric_functions → limits_continuity
- limits_continuity → differentiation
- differentiation → applications_derivatives
- differentiation → integration
- integration → applications_integrals
- integration → differential_equations
- straight_lines → circles
- circles → conic_sections
- vectors_3d → 3d_geometry
- probability → statistics

**Physics Mechanics Progression:**
- units_measurements → kinematics_1d
- kinematics_1d → kinematics_2d
- kinematics_1d → laws_of_motion
- kinematics_1d → work_energy_power
- laws_of_motion → circular_motion
- laws_of_motion → work_energy_power
- laws_of_motion → com_momentum_collisions
- laws_of_motion → rotational_mechanics
- circular_motion → rotational_mechanics
- circular_motion → gravitation
- work_energy_power → simple_harmonic_motion

**Physics Thermodynamics Progression:**
- thermal_properties → calorimetry
- thermal_properties → kinetic_theory
- kinetic_theory → thermodynamics
- calorimetry → thermodynamics

**Physics Electromagnetism Progression:**
- electrostatics → capacitance
- electrostatics → current_electricity
- current_electricity → magnetic_effects
- magnetic_effects → magnetism
- magnetic_effects → electromagnetic_induction
- electromagnetic_induction → ac_circuits
- ac_circuits → electromagnetic_waves

**Physics Optics Progression:**
- ray_optics → optical_instruments
- wave_optics → optical_instruments

**Physics Modern Physics Progression:**
- dual_nature → atoms_nuclei

**Chemistry Physical Chemistry Progression:**
- atomic_structure → chemical_bonding
- chemical_bonding → states_of_matter
- atomic_structure → periodic_table
- thermodynamics_chem → chemical_equilibrium
- chemical_equilibrium → ionic_equilibrium
- redox_reactions → chemical_kinetics

**Chemistry Inorganic Chemistry Progression:**
- periodic_table → s_block
- periodic_table → p_block
- periodic_table → d_block
- d_block → coordination_compounds
- periodic_table → metallurgy
- ionic_equilibrium → qualitative_analysis

**Chemistry Organic Chemistry Progression:**
- basic_organic → hydrocarbons
- hydrocarbons → organic_compounds_oxygen
- hydrocarbons → organic_compounds_nitrogen
- organic_compounds_oxygen → polymers
- organic_compounds_oxygen → biomolecules
- organic_compounds_nitrogen → biomolecules
- biomolecules → chemistry_everyday

**Cross-Subject Dependencies (Math → Physics):**
- trigonometric_functions → kinematics_2d
- trigonometric_functions → circular_motion
- vectors_3d → kinematics_2d
- vectors_3d → laws_of_motion
- vectors_3d → com_momentum_collisions
- vectors_3d → electrostatics
- vectors_3d → magnetic_effects
- differentiation → work_energy_power
- differentiation → simple_harmonic_motion
- differentiation → rotational_mechanics
- integration → work_energy_power
- integration → gravitation
- integration → electrostatics
- differential_equations → simple_harmonic_motion
- differential_equations → ac_circuits

**Cross-Subject Dependencies (Math → Chemistry):**
- sets_relations → atomic_structure
- complex_numbers → chemical_bonding
- differentiation → chemical_kinetics
- integration → thermodynamics_chem
- probability → chemical_equilibrium

**Cross-Subject Dependencies (Physics → Chemistry):**
- electrostatics → redox_reactions
- thermodynamics → thermodynamics_chem
- kinetic_theory → states_of_matter
- dual_nature → atomic_structure

## Algorithms

### Chapter Mastery Calculation

**Algorithm:** Weighted average of child micro-concept BKT scores

```javascript
function calculateChapterMastery(userId, chapterId) {
  // Query all concepts in chapter
  const concepts = await db.query(
    'SELECT id FROM concepts WHERE chapter_id = $1',
    [chapterId]
  );
  
  if (concepts.rows.length === 0) return null;
  
  // Query mastery for each concept
  const masteryData = await db.query(
    `SELECT concept_id, mastery 
     FROM user_concept_mastery 
     WHERE user_id = $1 AND concept_id = ANY($2)`,
    [userId, concepts.rows.map(c => c.id)]
  );
  
  // If no mastery data, return null
  if (masteryData.rows.length === 0) return null;
  
  // Calculate weighted average (equal weights)
  const totalMastery = masteryData.rows.reduce(
    (sum, row) => sum + row.mastery, 
    0
  );
  
  return totalMastery / masteryData.rows.length;
}
```

**Optimization:** Cache chapter mastery in a materialized view or separate table, updated on BKT score changes.

### Ghost Node Generation

**Algorithm:** Identify cross-chapter prerequisites for concepts in a chapter

```javascript
function generateGhostNodes(chapterId) {
  // Get all concepts in the target chapter
  const chapterConcepts = await db.query(
    'SELECT id FROM concepts WHERE chapter_id = $1',
    [chapterId]
  );
  
  const conceptIds = chapterConcepts.rows.map(c => c.id);
  
  // Find prerequisites that are NOT in the same chapter
  const ghostNodes = await db.query(
    `SELECT DISTINCT 
       c.id, 
       c.name, 
       c.chapter_id,
       ch.name as chapter_name
     FROM concept_prerequisites cp
     JOIN concepts c ON c.id = cp.prereq_id
     JOIN chapters ch ON ch.id = c.chapter_id
     WHERE cp.concept_id = ANY($1)
       AND c.chapter_id != $2
       AND c.chapter_id IS NOT NULL`,
    [conceptIds, chapterId]
  );
  
  return ghostNodes.rows;
}
```

### Bridge Edge Calculation

**Algorithm:** Aggregate cross-chapter dependencies to create chapter-level edges

```javascript
function calculateBridgeEdges(subject) {
  // Find all cross-chapter concept dependencies
  const bridges = await db.query(
    `SELECT 
       c1.chapter_id as from_chapter,
       c2.chapter_id as to_chapter,
       COUNT(*) as concept_count
     FROM concept_prerequisites cp
     JOIN concepts c1 ON c1.id = cp.prereq_id
     JOIN concepts c2 ON c2.id = cp.concept_id
     JOIN chapters ch1 ON ch1.id = c1.chapter_id
     JOIN chapters ch2 ON ch2.id = c2.chapter_id
     WHERE c1.chapter_id != c2.chapter_id
       AND c1.chapter_id IS NOT NULL
       AND c2.chapter_id IS NOT NULL
       AND ch1.subject = $1
       AND ch2.subject = $1
     GROUP BY c1.chapter_id, c2.chapter_id`,
    [subject]
  );
  
  return bridges.rows;
}
```

### Batch Chapter Mastery Aggregation

**Algorithm:** Calculate average chapter mastery across all students in a batch

```javascript
async function calculateBatchChapterMastery(batchId, instituteId) {
  // Get all students in batch
  const students = await db.query(
    `SELECT user_id 
     FROM batch_students 
     WHERE batch_id = $1`,
    [batchId]
  );
  
  const studentIds = students.rows.map(s => s.user_id);
  
  if (studentIds.length === 0) return [];
  
  // Aggregate mastery by chapter
  const batchMastery = await db.query(
    `SELECT 
       c.chapter_id,
       AVG(ucm.mastery) as avg_mastery,
       MIN(ucm.mastery) as min_mastery,
       MAX(ucm.mastery) as max_mastery,
       COUNT(DISTINCT CASE WHEN ucm.mastery >= 0.8 THEN ucm.user_id END) as students_mastered
     FROM concepts c
     JOIN user_concept_mastery ucm ON ucm.concept_id = c.id
     WHERE ucm.user_id = ANY($1)
       AND c.chapter_id IS NOT NULL
     GROUP BY c.chapter_id`,
    [studentIds]
  );
  
  return batchMastery.rows;
}
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property Reflection

After analyzing all acceptance criteria, I identified the following testable properties and eliminated redundancies:

**Redundancies Eliminated:**
- Requirements 3.6-3.9 (specific mastery color ranges) are edge cases of Property 1 (color-coding based on mastery)
- Requirements 4.8 and 7.1-7.2 (ghost node display) are combined into Property 3 (ghost node generation)
- Requirements 4.9 and 7.3 (ghost node visual distinction) are combined into Property 4 (ghost node styling)
- Requirements 5.1 and 5.2 (mastery calculation and equal weighting) are combined into Property 5 (chapter mastery calculation)
- Requirements 7.4 and 7.6 (bridge edge display and generation) are combined into Property 7 (bridge edge generation)
- Requirements 9.5-9.6 (API response content) are combined into Property 10 (API response completeness)
- Requirements 12.1-12.3 (multi-tenant scoping) are combined into Property 11 (multi-tenant data isolation)

### Property 1: Chapter Node Color-Coding

*For any* chapter node in the macro graph with a mastery score, the node color SHALL match the mastery level: green for mastery ≥ 0.8, yellow for 0.5 ≤ mastery < 0.8, red for mastery < 0.5, and gray for no mastery data.

**Validates: Requirements 3.5, 3.6, 3.7, 3.8, 3.9**

### Property 2: Hierarchical Node Positioning

*For any* chapter node in the macro graph, if chapter A is a prerequisite of chapter B, then chapter A SHALL be positioned before chapter B in the hierarchical layout (left-to-right or top-to-bottom depending on layout direction).

**Validates: Requirements 1.6, 3.10**

### Property 3: Ghost Node Generation for Cross-Chapter Dependencies

*For any* micro-concept in a chapter that has a prerequisite from a different chapter, the micro graph SHALL include a ghost node representing that cross-chapter prerequisite.

**Validates: Requirements 4.8, 7.1, 7.2**

### Property 4: Ghost Node Visual Distinction

*For any* ghost node in a micro graph, the node SHALL have a dashed border to distinguish it from regular concept nodes within the chapter.

**Validates: Requirements 4.9, 7.3, 7.5**

### Property 5: Chapter Mastery Calculation

*For any* chapter with at least one micro-concept having mastery data, the chapter mastery SHALL equal the arithmetic mean of all child micro-concept BKT scores, and the result SHALL be between 0 and 1.

**Validates: Requirements 5.1, 5.2, 5.7**

### Property 6: Null Mastery for Empty Chapters

*For any* chapter with no micro-concepts having mastery data, the chapter mastery SHALL be null.

**Validates: Requirements 5.3**

### Property 7: Bridge Edge Generation

*For any* pair of chapters (A, B) where at least one micro-concept in chapter B has a prerequisite in chapter A, the macro graph SHALL display a bridge edge from chapter A to chapter B.

**Validates: Requirements 7.4, 7.6**

### Property 8: Circular Dependency Prevention

*For any* set of chapter prerequisite relationships, the prerequisite graph SHALL be acyclic (no circular dependencies).

**Validates: Requirements 2.11**

### Property 9: Migration Idempotence

*For any* database state, running the migration script multiple times SHALL produce the same final schema and seed data without errors.

**Validates: Requirements 8.8**

### Property 10: API Response Completeness

*For any* API endpoint returning graph data, the response SHALL include all required fields for vis-network rendering: nodes with id and label, edges with from and to, and mastery data where applicable.

**Validates: Requirements 9.5, 9.6, 9.8**

### Property 11: Multi-Tenant Data Isolation

*For any* API request with an institute_id, the response SHALL contain only data belonging to that institute, and SHALL NOT include data from other institutes.

**Validates: Requirements 9.7, 12.1, 12.2, 12.3, 12.7**

### Property 12: Backward Compatibility

*For any* existing database query on the concepts or concept_prerequisites tables that worked before the migration, the query SHALL continue to work after adding the chapter_id column.

**Validates: Requirements 8.6**

### Property 13: BKT Integration Consistency

*For any* micro-concept mastery score displayed in the hierarchical graph, the score SHALL match the value in the user_concept_mastery table calculated by the BKT system.

**Validates: Requirements 13.1, 13.2, 13.5**

### Property 14: Node Display Limit

*For any* graph view (macro or micro), if the number of nodes exceeds 50, the system SHALL either paginate or provide filtering to limit the displayed nodes.

**Validates: Requirements 11.6, 11.7**

## Error Handling

### Database Errors

**Connection Failures:**
- Catch PostgreSQL connection errors
- Log error details with timestamp and query context
- Return user-friendly message: "Unable to load graph data. Please refresh the page."
- Maintain existing session state

**Query Failures:**
- Wrap all database queries in try-catch blocks
- Log SQL errors with query text and parameters (sanitized)
- Return appropriate HTTP status codes (500 for server errors)
- Display fallback UI with error message

**Foreign Key Violations:**
- Validate chapter_id and concept_id before insertion
- Return 400 Bad Request with descriptive error message
- Prevent orphaned records through database constraints

### Graph Rendering Errors

**vis-network Load Failure:**
- Detect if vis-network library fails to load from CDN
- Display fallback message: "Graph visualization unavailable. Please refresh the page or check your internet connection."
- Provide alternative text-based view of concepts

**Empty Data Sets:**
- When chapter has no concepts: Display "No concepts available for this chapter"
- When user has no mastery data: Display all nodes in gray with message "Start practicing to see your progress"
- When batch has no students: Display "No students in this batch"

**Invalid Chapter/Concept IDs:**
- Validate IDs against database before querying
- Return 404 Not Found for non-existent resources
- Log warning for potential data integrity issues

### Cross-Chapter Dependency Errors

**Missing Ghost Node Concepts:**
- If a prerequisite concept doesn't exist in database, log warning
- Exclude the ghost node from rendering
- Continue rendering other valid ghost nodes

**Circular Dependencies:**
- Detect cycles during prerequisite graph construction
- Log error with cycle path (e.g., "A → B → C → A")
- Exclude problematic edge from graph rendering
- Alert administrators through error log

### Multi-Tenant Isolation Errors

**Missing institute_id:**
- Validate institute_id from user session before all queries
- Return 403 Forbidden if institute_id is missing or invalid
- Log security warning for potential unauthorized access attempts

**Cross-Institute Data Leakage:**
- Add institute_id filter to ALL queries involving user/batch data
- Use parameterized queries to prevent SQL injection
- Audit log all data access with institute_id and user_id

### BKT System Integration Errors

**BKT Service Unavailable:**
- Detect if BKT microservice on port 8000 is unreachable
- Use cached mastery data from user_concept_mastery table
- Display warning indicator: "Using cached mastery data (BKT service unavailable)"
- Retry BKT service connection on next request

**Mastery Data Inconsistency:**
- If BKT returns mastery outside [0, 1] range, clamp to valid range
- Log warning for data quality issue
- Continue rendering with clamped value

## Testing Strategy

### Dual Testing Approach

This feature requires both unit tests and property-based tests for comprehensive coverage:

**Unit Tests** focus on:
- Specific examples of chapter prerequisite relationships (e.g., "kinematics_1d → kinematics_2d")
- Database schema validation (tables exist with correct columns)
- API endpoint responses for specific inputs
- UI rendering for specific scenarios (e.g., clicking a chapter node)
- Error handling for specific edge cases (e.g., empty chapter, missing concept)

**Property-Based Tests** focus on:
- Universal properties that hold for all inputs (e.g., chapter mastery always between 0 and 1)
- Graph algorithms (e.g., no circular dependencies, correct ghost node generation)
- Multi-tenant isolation (e.g., all queries scoped by institute_id)
- Data consistency (e.g., BKT scores match displayed mastery)

### Property-Based Testing Configuration

**Library Selection:**
- JavaScript/Node.js: Use `fast-check` library for property-based testing
- Install: `npm install --save-dev fast-check`

**Test Configuration:**
- Minimum 100 iterations per property test
- Each test tagged with comment referencing design property
- Tag format: `// Feature: hierarchical-knowledge-graph, Property {number}: {property_text}`

**Example Property Test Structure:**
```javascript
import fc from 'fast-check';

// Feature: hierarchical-knowledge-graph, Property 5: Chapter Mastery Calculation
test('Chapter mastery equals mean of concept masteries', () => {
  fc.assert(
    fc.property(
      fc.array(fc.float({ min: 0, max: 1 }), { minLength: 1 }),
      (conceptMasteries) => {
        const chapterMastery = calculateChapterMastery(conceptMasteries);
        const expectedMean = conceptMasteries.reduce((a, b) => a + b) / conceptMasteries.length;
        expect(chapterMastery).toBeCloseTo(expectedMean, 4);
        expect(chapterMastery).toBeGreaterThanOrEqual(0);
        expect(chapterMastery).toBeLessThanOrEqual(1);
      }
    ),
    { numRuns: 100 }
  );
});
```

### Unit Testing Strategy

**Database Tests:**
- Test schema creation (chapters, chapter_prerequisites tables)
- Test foreign key constraints
- Test indexes exist on critical columns
- Test seed data insertion (73 chapters, prerequisite relationships)
- Test migration idempotence (run twice, verify same result)

**API Tests:**
- Test GET /api/chapters returns all chapters
- Test GET /api/chapters/:id/concepts returns concepts for chapter
- Test GET /api/user/:userId/chapter-mastery returns mastery data
- Test GET /api/batch/:batchId/chapter-mastery returns batch aggregation
- Test multi-tenant scoping (different institutes see different data)
- Test error responses (404 for invalid IDs, 403 for unauthorized access)

**Algorithm Tests:**
- Test chapter mastery calculation with known inputs
- Test ghost node generation for cross-chapter prerequisites
- Test bridge edge calculation for cross-chapter dependencies
- Test batch mastery aggregation with known student data
- Test circular dependency detection

**UI Tests:**
- Test macro graph renders with chapter nodes
- Test micro graph renders on chapter click
- Test ghost nodes appear for cross-chapter prerequisites
- Test color-coding based on mastery levels
- Test navigation (drill-down, back button, ghost node click)
- Test error states (empty chapter, no mastery data)

### Integration Tests

**End-to-End Scenarios:**
1. Student views dashboard → sees macro graph → clicks chapter → sees micro graph → clicks ghost node → navigates to source chapter
2. Teacher selects batch → sees batch average graph → selects individual student → sees student graph
3. Student answers questions → BKT updates mastery → chapter mastery recalculates → graph colors update
4. Admin creates new chapter → assigns concepts → students see updated graph

**Performance Tests:**
- Macro graph renders within 500ms (load 73 chapters)
- Micro graph renders within 500ms (load up to 50 concepts)
- Batch aggregation completes within 1s (25 students, 73 chapters)
- Database queries use indexes (verify with EXPLAIN ANALYZE)

### Test Data Generation

**For Property Tests:**
- Generate random mastery scores in [0, 1]
- Generate random chapter graphs (acyclic)
- Generate random concept-to-chapter assignments
- Generate random cross-chapter prerequisites

**For Unit Tests:**
- Use fixed JEE chapter data (73 chapters)
- Use fixed prerequisite relationships (based on JEE syllabus)
- Use fixed test users and batches
- Use fixed mastery scores for predictable outcomes

### Continuous Integration

**Pre-Commit Checks:**
- Run all unit tests
- Run property tests with 100 iterations
- Check code coverage (target: 80% for new code)
- Lint JavaScript code (ESLint)

**Post-Merge Checks:**
- Run full test suite including integration tests
- Run property tests with 1000 iterations
- Performance benchmarks (graph rendering times)
- Database migration tests (fresh database)

## Implementation Notes

### Technology Stack

- **Backend:** Node.js with Express.js
- **Database:** PostgreSQL with pg.Client
- **Frontend:** EJS templates with server-side rendering
- **Graph Library:** vis-network (loaded via CDN)
- **Module System:** ES modules (import/export syntax)
- **Testing:** Jest for unit tests, fast-check for property-based tests

### Database Migration Strategy

**Migration File:** `migrations/002_hierarchical_knowledge_graph.sql`

**Migration Steps:**
1. Create chapters table
2. Create chapter_prerequisites table
3. Add chapter_id column to concepts table (nullable)
4. Create indexes
5. Insert seed data (73 chapters)
6. Insert chapter prerequisite relationships
7. Verify referential integrity

**Rollback Strategy:**
- Drop chapter_prerequisites table
- Drop chapters table
- Remove chapter_id column from concepts table
- Drop indexes

### Performance Optimizations

**Database Level:**
- Index on concepts.chapter_id for fast filtering
- Index on chapter_prerequisites for fast prerequisite lookups
- Materialized view for chapter mastery (updated on BKT changes)
- Connection pooling for concurrent requests

**Application Level:**
- Cache chapter mastery calculations (Redis or in-memory)
- Batch database queries (fetch all chapters in one query)
- Lazy load micro graphs (only fetch on drill-down)
- Debounce graph rendering (avoid re-rendering on rapid clicks)

**Frontend Level:**
- Use vis-network's hierarchical layout (optimized for DAGs)
- Limit node count per view (paginate if > 50 nodes)
- Virtualize large graphs (render only visible nodes)
- Preload ghost node data (fetch on macro graph load)

### Security Considerations

**SQL Injection Prevention:**
- Use parameterized queries for all database operations
- Validate and sanitize all user inputs (chapter_id, concept_id, user_id)
- Escape special characters in concept names

**Multi-Tenant Isolation:**
- Add institute_id filter to ALL queries
- Validate institute_id from authenticated session
- Use row-level security policies in PostgreSQL
- Audit log all cross-institute access attempts

**Authorization:**
- Students can only view their own graphs
- Teachers can view graphs for their institute's batches
- Institute admins can view all graphs for their institute
- Platform admins can view all graphs (for debugging)

### Monitoring and Observability

**Metrics to Track:**
- Graph rendering time (p50, p95, p99)
- Database query time (per endpoint)
- Chapter mastery calculation time
- API error rates (by endpoint and error type)
- User engagement (drill-down rate, ghost node clicks)

**Logging:**
- Log all database errors with query context
- Log all API requests with institute_id and user_id
- Log graph rendering errors with browser info
- Log performance metrics (slow queries > 1s)

**Alerts:**
- Alert if graph rendering time > 1s (p95)
- Alert if API error rate > 5%
- Alert if BKT service unavailable > 5 minutes
- Alert if circular dependency detected

## Future Enhancements

### Phase 2: Concept-to-Chapter Assignment
- Assign existing 81 micro-concepts to appropriate chapters
- Migrate historical mastery data to new structure
- Update BKT system to track chapter-level mastery

### Phase 3: Custom Chapters
- Allow institutes to create custom chapters
- Support custom prerequisite relationships
- Enable chapter reordering and customization

### Phase 4: Advanced Visualizations
- Heatmap view for batch mastery across chapters
- Timeline view showing mastery progression over time
- Comparison view (student vs. batch average)
- Export graphs as images (PNG, SVG)

### Phase 5: Adaptive Learning Paths
- Generate personalized learning paths based on weak chapters
- Recommend next chapter to study based on prerequisites
- Predict time to mastery for each chapter
- Gamification (badges for mastering chapters)

## Appendix: JEE Chapter Seed Data

### SQL Seed Script

```sql
-- Insert all 73 JEE chapters
INSERT INTO chapters (id, name, subject, display_order, description) VALUES
-- Physics - Mechanics (10 chapters)
('units_measurements', 'Units & Measurements', 'Physics - Mechanics', 1, 'Fundamental units, dimensional analysis, and measurement techniques'),
('kinematics_1d', 'Kinematics (1D)', 'Physics - Mechanics', 2, 'Motion in one dimension: velocity, acceleration, equations of motion'),
('kinematics_2d', 'Kinematics (2D)', 'Physics - Mechanics', 3, 'Motion in two dimensions: projectile motion, relative velocity'),
('laws_of_motion', 'Laws of Motion', 'Physics - Mechanics', 4, 'Newton''s laws, free body diagrams, friction, pulleys'),
('circular_motion', 'Circular Motion', 'Physics - Mechanics', 5, 'Uniform circular motion, centripetal force, banking'),
('work_energy_power', 'Work Energy & Power', 'Physics - Mechanics', 6, 'Work, kinetic energy, potential energy, conservation of energy'),
('com_momentum_collisions', 'Centre of Mass Momentum & Collisions', 'Physics - Mechanics', 7, 'Centre of mass, linear momentum, collisions'),
('simple_harmonic_motion', 'Simple Harmonic Motion', 'Physics - Mechanics', 8, 'SHM kinematics, energy, spring-mass systems'),
('rotational_mechanics', 'Rotational Mechanics', 'Physics - Mechanics', 9, 'Angular kinematics, torque, moment of inertia, rolling motion'),
('gravitation', 'Gravitation', 'Physics - Mechanics', 10, 'Universal gravitation, gravitational potential, satellites'),

-- Physics - Thermodynamics (4 chapters)
('thermal_properties', 'Thermal Properties of Matter', 'Physics - Thermodynamics', 11, 'Temperature, thermal expansion, specific heat'),
('thermodynamics', 'Thermodynamics', 'Physics - Thermodynamics', 12, 'Laws of thermodynamics, heat engines, entropy'),
('kinetic_theory', 'Kinetic Theory of Gases', 'Physics - Thermodynamics', 13, 'Molecular theory, ideal gas laws, mean free path'),
('calorimetry', 'Calorimetry and Heat Transfer', 'Physics - Thermodynamics', 14, 'Heat transfer, calorimetry, phase changes'),

-- Physics - Electromagnetism (8 chapters)
('electrostatics', 'Electrostatics', 'Physics - Electromagnetism', 15, 'Electric charge, Coulomb''s law, electric field and potential'),
('capacitance', 'Capacitance', 'Physics - Electromagnetism', 16, 'Capacitors, dielectrics, energy storage'),
('current_electricity', 'Current Electricity', 'Physics - Electromagnetism', 17, 'Current, resistance, Ohm''s law, circuits'),
('magnetic_effects', 'Magnetic Effects of Current', 'Physics - Electromagnetism', 18, 'Magnetic field, Biot-Savart law, Ampere''s law'),
('magnetism', 'Magnetism and Matter', 'Physics - Electromagnetism', 19, 'Magnetic materials, hysteresis, earth''s magnetism'),
('electromagnetic_induction', 'Electromagnetic Induction', 'Physics - Electromagnetism', 20, 'Faraday''s law, Lenz''s law, inductance'),
('ac_circuits', 'AC Circuits', 'Physics - Electromagnetism', 21, 'AC voltage, impedance, resonance, power'),
('electromagnetic_waves', 'Electromagnetic Waves', 'Physics - Electromagnetism', 22, 'EM spectrum, wave propagation, Maxwell''s equations'),

-- Physics - Optics (3 chapters)
('ray_optics', 'Ray Optics', 'Physics - Optics', 23, 'Reflection, refraction, mirrors, lenses'),
('wave_optics', 'Wave Optics', 'Physics - Optics', 24, 'Interference, diffraction, polarization'),
('optical_instruments', 'Optical Instruments', 'Physics - Optics', 25, 'Microscopes, telescopes, optical devices'),

-- Physics - Modern Physics (2 chapters)
('dual_nature', 'Dual Nature of Matter and Radiation', 'Physics - Modern Physics', 26, 'Photoelectric effect, de Broglie wavelength, matter waves'),
('atoms_nuclei', 'Atoms and Nuclei', 'Physics - Modern Physics', 27, 'Atomic models, nuclear physics, radioactivity'),

-- Chemistry - Physical Chemistry (8 chapters)
('atomic_structure', 'Atomic Structure', 'Chemistry - Physical', 28, 'Atomic models, quantum numbers, electronic configuration'),
('chemical_bonding', 'Chemical Bonding', 'Chemistry - Physical', 29, 'Ionic, covalent, metallic bonds, molecular orbital theory'),
('states_of_matter', 'States of Matter', 'Chemistry - Physical', 30, 'Gases, liquids, solids, intermolecular forces'),
('thermodynamics_chem', 'Thermodynamics', 'Chemistry - Physical', 31, 'Enthalpy, entropy, Gibbs energy, thermochemistry'),
('chemical_equilibrium', 'Chemical Equilibrium', 'Chemistry - Physical', 32, 'Equilibrium constant, Le Chatelier''s principle'),
('ionic_equilibrium', 'Ionic Equilibrium', 'Chemistry - Physical', 33, 'Acids, bases, pH, buffer solutions, solubility'),
('redox_reactions', 'Redox Reactions and Electrochemistry', 'Chemistry - Physical', 34, 'Oxidation-reduction, electrochemical cells, Nernst equation'),
('chemical_kinetics', 'Chemical Kinetics', 'Chemistry - Physical', 35, 'Reaction rates, rate laws, activation energy'),

-- Chemistry - Inorganic Chemistry (7 chapters)
('periodic_table', 'Periodic Table and Periodicity', 'Chemistry - Inorganic', 36, 'Periodic trends, classification of elements'),
('s_block', 's-Block Elements', 'Chemistry - Inorganic', 37, 'Alkali and alkaline earth metals'),
('p_block', 'p-Block Elements', 'Chemistry - Inorganic', 38, 'Groups 13-18 elements and their compounds'),
('d_block', 'd-Block and f-Block Elements', 'Chemistry - Inorganic', 39, 'Transition metals, lanthanides, actinides'),
('coordination_compounds', 'Coordination Compounds', 'Chemistry - Inorganic', 40, 'Complex ions, ligands, crystal field theory'),
('metallurgy', 'Metallurgy', 'Chemistry - Inorganic', 41, 'Extraction of metals, refining processes'),
('qualitative_analysis', 'Qualitative Analysis', 'Chemistry - Inorganic', 42, 'Salt analysis, identification of ions'),

-- Chemistry - Organic Chemistry (7 chapters)
('basic_organic', 'Basic Organic Chemistry', 'Chemistry - Organic', 43, 'Nomenclature, isomerism, reaction mechanisms'),
('hydrocarbons', 'Hydrocarbons', 'Chemistry - Organic', 44, 'Alkanes, alkenes, alkynes, aromatic compounds'),
('organic_compounds_oxygen', 'Organic Compounds with Oxygen', 'Chemistry - Organic', 45, 'Alcohols, phenols, ethers, aldehydes, ketones, carboxylic acids'),
('organic_compounds_nitrogen', 'Organic Compounds with Nitrogen', 'Chemistry - Organic', 46, 'Amines, diazonium salts, cyanides'),
('polymers', 'Polymers', 'Chemistry - Organic', 47, 'Natural and synthetic polymers, polymerization'),
('biomolecules', 'Biomolecules', 'Chemistry - Organic', 48, 'Carbohydrates, proteins, nucleic acids, vitamins'),
('chemistry_everyday', 'Chemistry in Everyday Life', 'Chemistry - Organic', 49, 'Drugs, detergents, food chemistry'),

-- Mathematics - Algebra (7 chapters)
('sets_relations', 'Sets and Relations', 'Mathematics - Algebra', 50, 'Set theory, relations, functions'),
('complex_numbers', 'Complex Numbers', 'Mathematics - Algebra', 51, 'Complex plane, operations, De Moivre''s theorem'),
('quadratic_equations', 'Quadratic Equations', 'Mathematics - Algebra', 52, 'Solving quadratics, discriminant, roots'),
('sequences_series', 'Sequences and Series', 'Mathematics - Algebra', 53, 'AP, GP, HP, special series'),
('permutations_combinations', 'Permutations and Combinations', 'Mathematics - Algebra', 54, 'Counting principles, arrangements, selections'),
('binomial_theorem', 'Binomial Theorem', 'Mathematics - Algebra', 55, 'Binomial expansion, coefficients, applications'),
('matrices_determinants', 'Matrices and Determinants', 'Mathematics - Algebra', 56, 'Matrix operations, determinants, systems of equations'),

-- Mathematics - Trigonometry (3 chapters)
('trigonometric_functions', 'Trigonometric Functions', 'Mathematics - Trigonometry', 57, 'Ratios, identities, graphs'),
('inverse_trigonometry', 'Inverse Trigonometry', 'Mathematics - Trigonometry', 58, 'Inverse functions, properties, equations'),
('trigonometric_equations', 'Trigonometric Equations', 'Mathematics - Trigonometry', 59, 'Solving trigonometric equations'),

-- Mathematics - Coordinate Geometry (4 chapters)
('straight_lines', 'Straight Lines', 'Mathematics - Coordinate Geometry', 60, 'Slopes, equations of lines, distance'),
('circles', 'Circles', 'Mathematics - Coordinate Geometry', 61, 'Equations of circles, tangents, normals'),
('conic_sections', 'Conic Sections', 'Mathematics - Coordinate Geometry', 62, 'Parabola, ellipse, hyperbola'),
('3d_geometry', 'Three Dimensional Geometry', 'Mathematics - Coordinate Geometry', 63, 'Lines and planes in 3D space'),

-- Mathematics - Calculus (6 chapters)
('limits_continuity', 'Limits and Continuity', 'Mathematics - Calculus', 64, 'Limits, continuity, differentiability'),
('differentiation', 'Differentiation', 'Mathematics - Calculus', 65, 'Derivatives, rules, techniques'),
('applications_derivatives', 'Applications of Derivatives', 'Mathematics - Calculus', 66, 'Tangents, maxima-minima, rate of change'),
('integration', 'Integration', 'Mathematics - Calculus', 67, 'Indefinite and definite integrals, techniques'),
('applications_integrals', 'Applications of Integrals', 'Mathematics - Calculus', 68, 'Area, volume, applications'),
('differential_equations', 'Differential Equations', 'Mathematics - Calculus', 69, 'First order, linear differential equations'),

-- Mathematics - Vectors and Probability (4 chapters)
('vectors_3d', 'Vectors', 'Mathematics - Vectors', 70, 'Vector operations, dot product, cross product'),
('probability', 'Probability', 'Mathematics - Probability', 71, 'Probability theory, conditional probability, Bayes theorem'),
('statistics', 'Statistics', 'Mathematics - Probability', 72, 'Mean, variance, distributions'),
('mathematical_reasoning', 'Mathematical Reasoning', 'Mathematics - Logic', 73, 'Logic, statements, reasoning');

-- Insert all chapter prerequisite relationships
INSERT INTO chapter_prerequisites (chapter_id, prereq_id) VALUES
-- Mathematics - Algebra progression
('complex_numbers', 'sets_relations'),
('sequences_series', 'sets_relations'),
('probability', 'sets_relations'),
('quadratic_equations', 'complex_numbers'),
('sequences_series', 'quadratic_equations'),
('binomial_theorem', 'sequences_series'),
('binomial_theorem', 'permutations_combinations'),
('probability', 'permutations_combinations'),
('vectors_3d', 'matrices_determinants'),

-- Mathematics - Trigonometry progression
('inverse_trigonometry', 'trigonometric_functions'),
('trigonometric_equations', 'trigonometric_functions'),
('limits_continuity', 'trigonometric_functions'),

-- Mathematics - Calculus progression
('differentiation', 'limits_continuity'),
('applications_derivatives', 'differentiation'),
('integration', 'differentiation'),
('applications_integrals', 'integration'),
('differential_equations', 'integration'),

-- Mathematics - Coordinate Geometry progression
('circles', 'straight_lines'),
('conic_sections', 'circles'),
('3d_geometry', 'vectors_3d'),

-- Mathematics - Probability progression
('statistics', 'probability'),

-- Physics - Mechanics progression
('kinematics_1d', 'units_measurements'),
('kinematics_2d', 'kinematics_1d'),
('laws_of_motion', 'kinematics_1d'),
('work_energy_power', 'kinematics_1d'),
('circular_motion', 'laws_of_motion'),
('work_energy_power', 'laws_of_motion'),
('com_momentum_collisions', 'laws_of_motion'),
('rotational_mechanics', 'laws_of_motion'),
('rotational_mechanics', 'circular_motion'),
('gravitation', 'circular_motion'),
('simple_harmonic_motion', 'work_energy_power'),

-- Physics - Thermodynamics progression
('calorimetry', 'thermal_properties'),
('kinetic_theory', 'thermal_properties'),
('thermodynamics', 'kinetic_theory'),
('thermodynamics', 'calorimetry'),

-- Physics - Electromagnetism progression
('capacitance', 'electrostatics'),
('current_electricity', 'electrostatics'),
('magnetic_effects', 'current_electricity'),
('magnetism', 'magnetic_effects'),
('electromagnetic_induction', 'magnetic_effects'),
('ac_circuits', 'electromagnetic_induction'),
('electromagnetic_waves', 'ac_circuits'),

-- Physics - Optics progression
('optical_instruments', 'ray_optics'),
('optical_instruments', 'wave_optics'),

-- Physics - Modern Physics progression
('atoms_nuclei', 'dual_nature'),

-- Chemistry - Physical Chemistry progression
('chemical_bonding', 'atomic_structure'),
('states_of_matter', 'chemical_bonding'),
('periodic_table', 'atomic_structure'),
('chemical_equilibrium', 'thermodynamics_chem'),
('ionic_equilibrium', 'chemical_equilibrium'),
('chemical_kinetics', 'redox_reactions'),

-- Chemistry - Inorganic Chemistry progression
('s_block', 'periodic_table'),
('p_block', 'periodic_table'),
('d_block', 'periodic_table'),
('coordination_compounds', 'd_block'),
('metallurgy', 'periodic_table'),
('qualitative_analysis', 'ionic_equilibrium'),

-- Chemistry - Organic Chemistry progression
('hydrocarbons', 'basic_organic'),
('organic_compounds_oxygen', 'hydrocarbons'),
('organic_compounds_nitrogen', 'hydrocarbons'),
('polymers', 'organic_compounds_oxygen'),
('biomolecules', 'organic_compounds_oxygen'),
('biomolecules', 'organic_compounds_nitrogen'),
('chemistry_everyday', 'biomolecules'),

-- Cross-subject: Math → Physics
('kinematics_2d', 'trigonometric_functions'),
('circular_motion', 'trigonometric_functions'),
('kinematics_2d', 'vectors_3d'),
('laws_of_motion', 'vectors_3d'),
('com_momentum_collisions', 'vectors_3d'),
('electrostatics', 'vectors_3d'),
('magnetic_effects', 'vectors_3d'),
('work_energy_power', 'differentiation'),
('simple_harmonic_motion', 'differentiation'),
('rotational_mechanics', 'differentiation'),
('work_energy_power', 'integration'),
('gravitation', 'integration'),
('electrostatics', 'integration'),
('simple_harmonic_motion', 'differential_equations'),
('ac_circuits', 'differential_equations'),

-- Cross-subject: Math → Chemistry
('atomic_structure', 'sets_relations'),
('chemical_bonding', 'complex_numbers'),
('chemical_kinetics', 'differentiation'),
('thermodynamics_chem', 'integration'),
('chemical_equilibrium', 'probability'),

-- Cross-subject: Physics → Chemistry
('redox_reactions', 'electrostatics'),
('thermodynamics_chem', 'thermodynamics'),
('states_of_matter', 'kinetic_theory'),
('atomic_structure', 'dual_nature');
```

### Chapter Prerequisite Graph Visualization

```
Mathematics - Algebra:
  sets_relations → complex_numbers → quadratic_equations → sequences_series → binomial_theorem
  sets_relations → probability → statistics
  permutations_combinations → binomial_theorem
  permutations_combinations → probability
  matrices_determinants → vectors_3d

Mathematics - Trigonometry:
  trigonometric_functions → inverse_trigonometry
  trigonometric_functions → trigonometric_equations
  trigonometric_functions → limits_continuity

Mathematics - Calculus:
  limits_continuity → differentiation → applications_derivatives
                                      → integration → applications_integrals
                                                   → differential_equations

Mathematics - Coordinate Geometry:
  straight_lines → circles → conic_sections
  vectors_3d → 3d_geometry

Physics - Mechanics:
  units_measurements → kinematics_1d → kinematics_2d
                                     → laws_of_motion → circular_motion → gravitation
                                                      → work_energy_power → simple_harmonic_motion
                                                      → com_momentum_collisions
                                                      → rotational_mechanics

Physics - Thermodynamics:
  thermal_properties → calorimetry → thermodynamics
                    → kinetic_theory → thermodynamics

Physics - Electromagnetism:
  electrostatics → capacitance
                → current_electricity → magnetic_effects → magnetism
                                                        → electromagnetic_induction → ac_circuits → electromagnetic_waves

Physics - Optics:
  ray_optics → optical_instruments
  wave_optics → optical_instruments

Physics - Modern Physics:
  dual_nature → atoms_nuclei

Chemistry - Physical:
  atomic_structure → chemical_bonding → states_of_matter
                  → periodic_table
  thermodynamics_chem → chemical_equilibrium → ionic_equilibrium
  redox_reactions → chemical_kinetics

Chemistry - Inorganic:
  periodic_table → s_block
                → p_block
                → d_block → coordination_compounds
                → metallurgy
  ionic_equilibrium → qualitative_analysis

Chemistry - Organic:
  basic_organic → hydrocarbons → organic_compounds_oxygen → polymers
                               → organic_compounds_nitrogen → biomolecules → chemistry_everyday

Cross-Subject (Math → Physics):
  trigonometric_functions → kinematics_2d, circular_motion
  vectors_3d → kinematics_2d, laws_of_motion, com_momentum_collisions, electrostatics, magnetic_effects
  differentiation → work_energy_power, simple_harmonic_motion, rotational_mechanics
  integration → work_energy_power, gravitation, electrostatics
  differential_equations → simple_harmonic_motion, ac_circuits

Cross-Subject (Math → Chemistry):
  sets_relations → atomic_structure
  complex_numbers → chemical_bonding
  differentiation → chemical_kinetics
  integration → thermodynamics_chem
  probability → chemical_equilibrium

Cross-Subject (Physics → Chemistry):
  electrostatics → redox_reactions
  thermodynamics → thermodynamics_chem
  kinetic_theory → states_of_matter
  dual_nature → atomic_structure
```

---

**Document Version:** 1.0  
**Last Updated:** 2024  
**Status:** Ready for Review
