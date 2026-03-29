# Requirements Document

## Introduction

This feature adds three AI-powered capabilities to Learn.ai using Google Gemini Flash, all grounded in the student's real BKT mastery data and prerequisite dependency graph. The three features are: (1) BKT-Aware Hints during practice when a student answers incorrectly, (2) AI Prerequisite Diagnosis Explanation that explains why a student is stuck and what to study first, and (3) an AI Study Plan Chatbot where students can ask personalized learning questions. All Gemini calls are rate-limited per student to prevent abuse.

## Glossary

- **Hint_Generator**: The server-side service that constructs a Gemini prompt from the question context, student's wrong answer, concept mastery, and weak prerequisites, then returns a personalized hint explaining why the answer is wrong and guiding the student toward understanding.
- **Diagnosis_Explainer**: The server-side service that takes the output of diagnosisEngine.js (prerequisite gaps, stagnation data, readiness scores, study path) and sends it to Gemini to produce a natural-language explanation of why the student is struggling and what to study first.
- **Study_Chatbot**: The server-side chat service that maintains per-session conversation history and sends each student message to Gemini along with the student's full mastery profile (all 221 subconcept masteries), recent practice history, prerequisite gaps, and dependency graph structure as context.
- **Rate_Limiter**: The middleware that tracks the number of AI (Gemini) API calls per student per day and rejects requests that exceed the daily limit.
- **Practice_View**: The existing practice.ejs page where students answer questions and receive feedback.
- **Dashboard**: The existing dashboard.ejs knowledge graph view where students see their concept mastery.
- **Mastery_Profile**: The complete set of BKT mastery values, questions answered, correct answers, and last-updated timestamps for all 221 subconcepts for a given student.
- **Prerequisite_Graph**: The directed acyclic graph of concept_prerequisites defining which subconcepts depend on which others.
- **Stagnation**: A state detected when a student has answered 5 or more questions on a concept but mastery remains below 0.5.
- **Chat_Session**: An in-memory conversation history (array of user and assistant messages) maintained for the duration of a browser session, not persisted to the database.

## Requirements

### Requirement 1: BKT-Aware Hint Generation API

**User Story:** As a student, I want to receive a personalized AI hint when I answer a question wrong during practice, so that I understand why my answer is incorrect and can learn the concept rather than just seeing the correct answer.

#### Acceptance Criteria

1. WHEN a student answers a question incorrectly during practice, THE Practice_View SHALL display a "Get AI Hint" button in the feedback area below the question.
2. WHEN the student clicks the "Get AI Hint" button, THE Practice_View SHALL send a POST request to the `/api/ai/hint` endpoint with the question ID, the student's selected answer, the correct answer, the question text, and the concept ID.
3. WHEN the `/api/ai/hint` endpoint receives a valid request, THE Hint_Generator SHALL fetch the student's current BKT mastery for the concept and the student's weak prerequisites (mastery below 0.7) for that concept from the database.
4. WHEN the Hint_Generator has gathered the mastery context, THE Hint_Generator SHALL construct a Gemini prompt that includes: the question text, all four options, the correct answer, the student's selected wrong answer, the concept name, the student's mastery percentage, and a list of weak prerequisite concept names with their mastery percentages.
5. WHEN the Gemini prompt is constructed, THE Hint_Generator SHALL call the Gemini Flash model (gemini-2.0-flash) with a system instruction that directs Gemini to act as a patient tutor, explain why the selected answer is wrong, guide the student toward the correct reasoning without directly stating the answer, and reference weak prerequisites if relevant.
6. WHEN the Gemini response is received, THE Practice_View SHALL display the hint text inside a collapsible panel below the feedback area with a typing animation that reveals the text progressively.
7. WHEN the hint is displayed, THE Practice_View SHALL render any mathematical notation in the hint using MathJax and render markdown formatting (bold, italic, lists) for readability.
8. IF the Gemini API call fails or times out after 15 seconds, THEN THE Hint_Generator SHALL return a fallback message indicating the hint is temporarily unavailable and the student should review the solution text.
9. WHILE the hint is loading, THE Practice_View SHALL display a pulsing animation indicator with the text "Your AI tutor is thinking..." to provide visual feedback.

### Requirement 2: AI Prerequisite Diagnosis Explanation

**User Story:** As a student who is struggling with a concept, I want to understand why I am stuck and what I should study first, so that I can follow a clear path to improve instead of repeatedly failing.

#### Acceptance Criteria

1. WHEN a student is practicing a concept and stagnation is detected (5 or more questions answered with mastery below 0.5), THE Practice_View SHALL display a "Why am I stuck?" button in the stagnation feedback area.
2. WHEN the student clicks the "Why am I stuck?" button, THE Practice_View SHALL send a POST request to the `/api/ai/diagnose` endpoint with the concept ID.
3. WHEN the `/api/ai/diagnose` endpoint receives a valid request, THE Diagnosis_Explainer SHALL call the existing `diagnosePrerequisites()` function from diagnosisEngine.js to obtain the full diagnosis result including prerequisite gaps, severity classifications, readiness scores, and the optimal study path.
4. WHEN the diagnosis data is obtained, THE Diagnosis_Explainer SHALL construct a Gemini prompt that includes: the target concept name and mastery, the list of prerequisite gaps with their names, mastery percentages, severity levels (root_cause, critical, weak, stale), and the recommended study path with reasons.
5. WHEN the Gemini prompt is constructed, THE Diagnosis_Explainer SHALL call the Gemini Flash model with a system instruction that directs Gemini to explain in a supportive, encouraging tone: what specific prerequisite gaps are causing the struggle, why those gaps matter for the target concept, and a step-by-step recommended study order with estimated effort.
6. WHEN the Gemini response is received, THE Practice_View SHALL display the diagnosis explanation in a styled card panel with markdown rendering and MathJax support.
7. WHEN the diagnosis explanation is displayed, THE Practice_View SHALL include clickable links for each recommended prerequisite concept that navigate the student to the practice page for that concept.
8. IF the student has no prerequisite gaps (all prerequisites mastered), THEN THE Diagnosis_Explainer SHALL instruct Gemini to focus the explanation on the target concept itself, suggesting more practice and different problem-solving strategies.
9. IF the Gemini API call fails or times out after 20 seconds, THEN THE Diagnosis_Explainer SHALL return the raw diagnosis data (prerequisite gaps and study path) formatted as a structured fallback without AI narration.

### Requirement 3: AI Study Plan Chatbot

**User Story:** As a student, I want to chat with an AI tutor that knows my complete learning state, so that I can ask personalized questions like "what should I study next?" or "explain torque to me" and get advice grounded in my actual mastery data.

#### Acceptance Criteria

1. THE Practice_View and THE Dashboard SHALL display a floating chat icon button (fixed position, bottom-right corner) that opens the AI Study Plan Chatbot.
2. WHEN the student clicks the chat icon, THE Study_Chatbot SHALL open a chat panel (slide-up drawer or modal) with a polished dark-themed UI matching the Learn.ai design system (glass morphism, purple/gold accents, Inter font).
3. WHEN the chat panel opens for the first time in a session, THE Study_Chatbot SHALL fetch the student's full Mastery_Profile (all 221 subconcept masteries, questions answered, correct answers) and prerequisite gap summary from the database and store it in the Chat_Session context.
4. WHEN the student sends a message, THE Study_Chatbot SHALL send a POST request to the `/api/ai/chat` endpoint with the message text and the session ID.
5. WHEN the `/api/ai/chat` endpoint receives a message, THE Study_Chatbot SHALL construct a Gemini prompt that includes: a system instruction with the student's full mastery profile summary (grouped by subject, showing weak and strong areas), the prerequisite graph structure for relevant concepts, recent practice history (last 20 attempts), and the full conversation history from the Chat_Session.
6. WHEN the Gemini response is received, THE Study_Chatbot SHALL display the response in the chat panel with markdown rendering (headings, bold, lists, code blocks), MathJax support for equations, and a typing animation that reveals the text progressively.
7. THE Study_Chatbot SHALL maintain the Chat_Session conversation history in server-side session storage, appending each user message and assistant response, for the duration of the browser session.
8. WHEN the student sends a message, THE Study_Chatbot SHALL display a typing indicator (animated dots) in the chat panel while waiting for the Gemini response.
9. THE Study_Chatbot chat panel SHALL include a text input field with placeholder text "Ask your AI tutor anything...", a send button, and keyboard support (Enter to send, Shift+Enter for newline).
10. THE Study_Chatbot SHALL be accessible via a dedicated `/chat` route that renders a full-page chat interface as an alternative to the floating panel.

### Requirement 4: AI Rate Limiting

**User Story:** As a platform operator, I want to limit the number of AI calls each student can make per day, so that API costs remain controlled and no single student can abuse the system.

#### Acceptance Criteria

1. THE Rate_Limiter SHALL track the number of Gemini API calls per student per calendar day using an in-memory counter (keyed by user ID and date).
2. WHEN a student makes a request to any AI endpoint (`/api/ai/hint`, `/api/ai/diagnose`, `/api/ai/chat`), THE Rate_Limiter SHALL check the student's daily call count before processing the request.
3. IF the student's daily call count has reached 50, THEN THE Rate_Limiter SHALL reject the request with HTTP status 429 and a JSON response containing a message indicating the daily AI limit has been reached and the student should try again tomorrow.
4. WHEN a request passes the rate limit check, THE Rate_Limiter SHALL increment the student's daily call count by 1.
5. WHEN a new calendar day begins (midnight UTC), THE Rate_Limiter SHALL reset all student counters to 0.

### Requirement 5: AI Response UI Quality

**User Story:** As a student, I want the AI responses to look polished and professional with smooth animations, so that the AI features feel like a premium, integrated part of the platform.

#### Acceptance Criteria

1. THE Practice_View SHALL render AI hint text and diagnosis text using a typing animation that reveals characters at a rate of approximately 20 characters per frame (using requestAnimationFrame), creating a smooth "AI is writing" effect.
2. THE Study_Chatbot SHALL render each AI response message using the same typing animation, with the chat panel auto-scrolling to keep the latest text visible during the animation.
3. THE Practice_View and THE Study_Chatbot SHALL render all AI response text through a markdown parser that supports bold, italic, headings, ordered lists, unordered lists, and inline code.
4. THE Practice_View and THE Study_Chatbot SHALL trigger MathJax typesetting on AI response containers after the typing animation completes, so that any LaTeX notation (using `$...$` or `$$...$$` delimiters) renders as formatted equations.
5. WHILE an AI response is loading, THE Practice_View SHALL display a pulsing gradient skeleton loader inside the hint/diagnosis panel, and THE Study_Chatbot SHALL display an animated three-dot typing indicator in the chat message area.
6. THE Study_Chatbot chat panel SHALL use the Learn.ai dark theme design tokens (--bg, --surface, --glass-bg, --purple, --gold, --text, --border) and glass morphism styling (backdrop-filter blur, semi-transparent backgrounds, subtle borders) consistent with the existing UI.
7. THE Study_Chatbot chat panel SHALL be responsive, occupying the full viewport width on mobile devices (below 768px) and appearing as a fixed-position panel (400px wide, 600px tall) on desktop.
