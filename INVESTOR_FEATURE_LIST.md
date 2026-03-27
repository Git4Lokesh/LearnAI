# Learn.ai — MVP Feature List (Investor Brief)

## What It Is
Learn.ai is an adaptive learning platform for JEE Mains exam preparation, being evolved into a B2B SaaS product for coaching centers across India. The platform uses Bayesian Knowledge Tracing (BKT) to personalize each student's learning path, and provides coaching center owners with analytics dashboards, question management, and parent-facing report cards.

---

## 1. ADAPTIVE LEARNING ENGINE (Core IP)

### Bayesian Knowledge Tracing (BKT) Microservice
- Custom Python FastAPI microservice implementing BKT with per-concept, per-difficulty-tier parameters
- Expectation-Maximization (EM) algorithm for learning optimal parameters from student response data
- Mastery decay function: student mastery degrades over time if they don't practice (models forgetting)
- Time-weighted updates: faster correct answers boost mastery more; slow correct answers or fast wrong answers are weighted differently
- Per-tier difficulty parameters (easy/medium/hard) — not one-size-fits-all
- Learned parameter persistence in PostgreSQL with hot-reload capability

### Adaptive Question Selection
- Spaced repetition: questions the student got wrong recently are prioritized
- Difficulty auto-adjustment based on current mastery (very_easy → easy → medium → hard → very_hard)
- Excludes recently-seen questions to avoid repetition
- Falls back gracefully across difficulty tiers if no questions available at target difficulty

### Mastery Tracking
- Per-concept mastery scores (0.0 to 1.0) for every student
- Questions answered count, correct answer count, last activity timestamp
- Mastery decay over time (configurable half-life)
- Chapter-level mastery computed as average of constituent concept masteries

---

## 2. HIERARCHICAL KNOWLEDGE GRAPH

### Structure
- **73 JEE chapters** across Physics (27), Chemistry (27), Mathematics (19) — mapped to NTA official syllabus
- **221 subconcepts** (micro-concepts) mapped to chapters: Physics (84), Chemistry (81), Mathematics (56)
- **Prerequisite relationships** at both chapter and concept level
- Cross-subject prerequisites supported (e.g., Math calculus → Physics mechanics)

### Interactive Dashboard
- Force-directed graph visualization of the knowledge graph (D3.js)
- Nodes color-coded by mastery: red (< 30%), orange (30-50%), yellow (50-70%), green (70-90%), bright green (> 90%)
- Chapter unlock logic: chapters unlock only when prerequisites are sufficiently mastered
- Click-to-expand: chapters expand to show constituent subconcepts
- Sidebar search with instant filtering
- Info panel showing concept details, mastery stats, and sparkline history

---

## 3. DIAGNOSTIC ONBOARDING ASSESSMENT

- 30-question adaptive diagnostic test administered to new students on first login
- Covers all three subjects (Physics, Chemistry, Mathematics)
- Adaptive: question difficulty adjusts based on responses during the test
- Results page shows per-subject and per-chapter mastery breakdown
- Seeds the BKT model with initial mastery estimates so the adaptive engine works from day one
- Students can skip the diagnostic and start with default mastery values
- `diagnostic_completed` flag on user record controls the onboarding flow

---

## 4. ADVANCED PREREQUISITE DIAGNOSIS ENGINE

- When a student struggles with a concept, the system traces back through the prerequisite graph
- Identifies root-cause gaps: "You're struggling with Electromagnetic Induction because your Calculus (Integration) mastery is low"
- Computes readiness scores combining: decayed mastery, confidence (based on question count), recency, accuracy, and calibration
- Divergence analysis: detects when mastery score doesn't match actual performance
- Impact scoring: ranks prerequisites by how much fixing them would improve the target concept
- Generates optimal study paths (up to 10 steps) with reasons for each step
- Floating diagnosis panel in the UI with rich visualization

---

## 5. B2B COACHING CENTER PLATFORM (Multi-Tenant SaaS)

### Institute Management
- Institute registration with slug-based URLs
- Subscription tiers: trial → active → suspended → cancelled
- Max student caps per subscription tier (default 500)
- Institute admin dashboard with aggregate analytics

### Batch Management
- Create batches (e.g., "JEE 2025 Batch A")
- Assign students to batches
- Batch-level analytics and mastery heatmaps

### Teacher Dashboard
- Per-batch mastery heatmap: rows = students, columns = chapters, cells = color-coded mastery
- Click any cell to drill into a student's prerequisite gaps for that chapter
- Prerequisite gap analysis view: shows exactly which foundational concepts a student is missing
- Syllabus tracker: teachers mark chapters as "taught in class" per batch

### Question Management
- Bulk upload questions via CSV/XLSX (with validation and error reporting)
- AI-powered concept auto-tagging using Google Gemini: uploaded questions are automatically classified to the correct NTA subconcept with confidence scores
- Question review queue: teachers review AI-tagged questions, approve/reject
- Institute-scoped questions: each coaching center's custom questions are isolated
- Platform-wide seed questions available to all institutes

### Student Invitation System
- Teachers/admins invite students via email
- Invited students are auto-assigned to the institute and batch on signup

### Parent Report Card
- PDF report card generation (PDFKit)
- Subject → Chapter → Concept hierarchy with mastery percentages
- Color-coded mastery bars (green ≥ 80%, yellow 50-80%, red < 50%)
- Institute branding (name, date)
- Downloadable PDF for parent meetings

---

## 6. QUESTION BANK

### Seed Questions (Pre-loaded)
- **~3,500+ hand-crafted JEE-level MCQs** across Physics and Mathematics
- Physics: ~1,660 questions across 84 subconcepts (Units 1-20)
- Mathematics: ~1,180 questions across 56 subconcepts
- Additional ~660 NTA-aligned seed questions
- Every question has: 4 options, correct answer, detailed solution text, concept mapping, difficulty tier (1-3)
- LaTeX math notation throughout ($...$)

### Question Schema
- question_text, option1-4, correct_answer, solution_text
- concept_id (mapped to NTA subconcept), difficulty_tier (1/2/3)
- source, status (pending/approved/rejected)
- institute_id (for multi-tenant isolation)
- concept_confidence (AI tagging confidence score)
- needs_review_tag (flagged for human review)

---

## 7. AI-POWERED FEATURES

### Content Generation (Google Gemini 2.5 Flash)
- Quick Notes generation from topic, PDF, or YouTube video
- Flashcard generation with spaced repetition
- Quiz generation with explanations
- Text expansion API: click any concept in notes to get a deeper explanation

### AI Chat Assistant
- Conversational AI tutor powered by Gemini
- PDF ingestion: upload a textbook PDF and ask questions about it
- Context-aware responses with LaTeX math rendering

### AI Concept Tagger
- Automatically classifies uploaded questions to the correct NTA subconcept
- Returns confidence score (0-1) for human review
- Uses the full concept taxonomy as context for accurate classification

### Multi-Language Translation
- Translate any content to Hindi or other Indian languages
- Batch translation API for bulk content

---

## 8. TECH STACK

| Layer | Technology |
|-------|-----------|
| Backend | Node.js / Express 5 (ES modules) |
| Frontend | EJS templates + vanilla JS + D3.js |
| Database | PostgreSQL (pg driver) |
| ML Microservice | Python FastAPI (BKT engine) |
| AI | Google Gemini 2.5 Flash API |
| Real-time | Socket.io |
| Auth | Passport.js + bcrypt (12 rounds) |
| PDF | PDFKit (generation), pdf-parse + LlamaParse (extraction) |
| File Processing | multer, xlsx |
| Containerization | Docker + Docker Compose |
| Rate Limiting | express-rate-limit |

### Architecture
- Monolithic Express app (~4,000 lines) with service layer extraction
- Python BKT microservice communicates via REST API
- PostgreSQL with 9 migration files for schema evolution
- Docker Compose for local development (app + BKT service + PostgreSQL)
- Session-based auth with role-based access control (student, teacher, institute_admin, admin)

---

## 9. DATABASE SCHEMA (Key Tables)

| Table | Purpose |
|-------|---------|
| users | Students, teachers, admins with role and institute_id |
| institutes | Coaching centers with subscription status |
| batches / batch_students | Batch management |
| chapters (73) | JEE chapter hierarchy |
| concepts (221) | NTA subconcepts mapped to chapters |
| concept_prerequisites / chapter_prerequisites | Knowledge graph edges |
| questions (~3,500+) | MCQ bank with difficulty tiers |
| user_concept_mastery | Per-student, per-concept mastery tracking |
| user_question_attempts | Every answer attempt with timing |
| upload_jobs | Bulk question upload tracking with error logs |
| chapter_teaching_status | Syllabus tracker per batch |
| bkt_learned_params | EM-fitted BKT parameters per concept |

---

## 10. WHAT'S NOT INCLUDED IN THIS LIST

The following features exist in the codebase but are considered "legacy/v1" features, not part of the core MVP pitch:
- Group Study Rooms (real-time collaborative study with Socket.io)
- AI content generation from YouTube transcripts
- Flashcard and Quiz saving/viewing/exporting
- Admin verification and payout pages
