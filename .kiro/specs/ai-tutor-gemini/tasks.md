# Implementation Plan: AI Tutor with Gemini

## Overview

Implement three AI-powered features (BKT-Aware Hints, AI Prerequisite Diagnosis, AI Study Chatbot) using Google Gemini Flash, with shared rate limiting middleware, a unified service module, new API routes, and frontend integration into practice.ejs, dashboard.ejs, and chat.ejs. All code uses the existing Express/EJS/PostgreSQL stack and the existing `helpers/gemini.js` helper.

## Tasks

- [ ] 1. Create rate limiter middleware and AI tutor service
  - [ ] 1.1 Create `middleware/aiRateLimit.js` — in-memory rate limiter (50 calls/day/student)
    - Export `aiRateLimiter` middleware: tracks calls per `userId:YYYY-MM-DD` key using a `Map`
    - Returns 429 with `{ error, message, remaining: 0 }` when limit exceeded
    - Sets `X-AI-Remaining` response header with remaining count
    - Probabilistic cleanup of stale date keys (1% chance per request)
    - Export `getAiUsage(userId)` helper returning `{ used, remaining, limit }`
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

  - [ ]* 1.2 Write property test for rate limiter (Property 6)
    - **Property 6: Rate limiter allows exactly 50 requests per user per day**
    - Generate random user IDs and request counts (1–100), simulate requests through the middleware
    - Assert first 50 pass, rest rejected with 429; cross-user and cross-day independence
    - **Validates: Requirements 4.1, 4.3, 4.4, 4.5**

  - [ ] 1.3 Create `services/aiTutorService.js` with prompt builders and three exported functions
    - Import `geminiGenerate` from `helpers/gemini.js`, `getUserConceptMastery` from `helpers/mastery.js`, `checkPrerequisiteGaps` from `services/prerequisiteService.js`, `diagnosePrerequisites` from `services/diagnosisEngine.js`, `db` from `config/db.js`
    - Implement internal prompt builder helpers: `buildHintSystemPrompt()`, `buildHintUserPrompt(params)`, `buildDiagnosisSystemPrompt()`, `buildDiagnosisUserPrompt(diagnosisResult)`, `buildChatSystemPrompt(masteryProfile, recentAttempts, gaps)`, `buildChatUserPrompt(message, conversationHistory)`
    - Use the exact prompt templates from the design document (JEE tutor persona, severity emojis, mastery data formatting)
    - Implement `generateHint({ userId, questionId, questionText, option1..4, correctAnswer, selectedAnswer, conceptId, conceptName })`:
      - Fetch student mastery + weak prereqs (mastery < 0.7) from DB
      - Build prompt, call `geminiGenerate` with `gemini-2.0-flash` and 15s timeout via AbortController
      - Return `{ hint }` or fallback message on error
    - Implement `generateDiagnosis({ userId, conceptId })`:
      - Call `diagnosePrerequisites(db, userId, conceptId)` to get full diagnosis
      - Build prompt from diagnosis result, call Gemini with 20s timeout
      - Return `{ explanation, studyPath, rawDiagnosis }` or raw diagnosis as fallback on error
    - Implement `generateChatResponse({ userId, message, conversationHistory })`:
      - Fetch full mastery profile (all subconcepts), recent 20 attempts, prerequisite gaps from DB
      - Build system prompt with mastery summary grouped by subject, build user prompt with conversation history + new message
      - Call Gemini with 15s timeout
      - Return `{ response }` or fallback message on error
    - _Requirements: 1.3, 1.4, 1.5, 1.8, 2.3, 2.4, 2.5, 2.8, 2.9, 3.3, 3.5_

  - [ ]* 1.4 Write property test for hint prompt completeness (Property 1)
    - **Property 1: Hint prompt contains all required context**
    - Generate random question text, options, concept names, mastery values (0–1), prerequisite lists
    - Call `buildHintUserPrompt` and assert the resulting string contains all input values
    - **Validates: Requirements 1.3, 1.4**

  - [ ]* 1.5 Write property test for diagnosis prompt completeness (Property 2)
    - **Property 2: Diagnosis prompt contains all required diagnosis fields**
    - Generate random diagnosis result objects matching `diagnosePrerequisites` output shape
    - Call `buildDiagnosisUserPrompt` and assert all gap names, severities, mastery values, study path steps present
    - **Validates: Requirements 2.3, 2.4**

  - [ ]* 1.6 Write property test for chat prompt completeness (Property 3)
    - **Property 3: Chat prompt contains full mastery context**
    - Generate random mastery profiles, conversation histories, and messages
    - Call `buildChatSystemPrompt` + `buildChatUserPrompt` and assert mastery summary, conversation entries, and user message present
    - **Validates: Requirements 3.3, 3.5**

  - [ ]* 1.7 Write property test for Gemini failure fallback (Property 4)
    - **Property 4: Gemini failure returns fallback response**
    - Mock `geminiGenerate` to throw random errors for each AI function
    - Assert each returns a valid response object (not throws) with a fallback string
    - For diagnosis, assert fallback includes raw diagnosis data
    - **Validates: Requirements 1.8, 2.9**

- [ ] 2. Checkpoint — Ensure rate limiter and service tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 3. Create AI API routes and mount in app.js
  - [ ] 3.1 Create `routes/ai.js` with three POST endpoints
    - `POST /api/ai/hint`: validate required fields (questionText, option1–4, correctAnswer, selectedAnswer, conceptId, conceptName), call `generateHint`, return `{ hint }` or 400/500
    - `POST /api/ai/diagnose`: validate conceptId, call `generateDiagnosis`, return `{ explanation, studyPath, rawDiagnosis }` or 400/500
    - `POST /api/ai/chat`: validate message is non-empty, read/write `req.session.aiChatHistory`, call `generateChatResponse` with conversation history, append user+assistant messages to session, return `{ response }` or 400/500
    - All routes use `ensureAuthenticated` + `aiRateLimiter` middleware
    - _Requirements: 1.2, 1.5, 1.8, 2.2, 2.5, 2.9, 3.4, 3.5, 3.7, 4.2_

  - [ ]* 3.2 Write property test for conversation history accumulation (Property 5)
    - **Property 5: Conversation history accumulates correctly**
    - Simulate N chat exchanges (1–20), passing accumulated history each time
    - Assert history length = 2N, roles alternate user/assistant, content matches
    - **Validates: Requirements 3.7**

  - [ ] 3.3 Mount AI routes in `app.js`
    - Import `aiRoutes` from `./routes/ai.js`
    - Add `app.use(aiRoutes)` alongside existing route mounts
    - _Requirements: 1.2, 2.2, 3.4_

- [ ] 4. Checkpoint — Ensure API routes work end-to-end
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. Update practice.ejs — AI hint panel, diagnosis panel, and floating chat widget
  - [ ] 5.1 Add marked.js CDN script tag to practice.ejs `<head>`
    - Add `<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>` before the closing `</head>`
    - _Requirements: 5.3_

  - [ ] 5.2 Add AI hint panel HTML and "Get AI Hint" button to practice.ejs
    - Add `#aiHintPanel` collapsible panel below the feedback area (inside `renderQuestion()` output)
    - Show "Get AI Hint" button only when answer is wrong (inside `submitAnswer()` after incorrect feedback)
    - Button calls `fetchAiHint()` which POSTs to `/api/ai/hint` with question context
    - Display pulsing loader ("Your AI tutor is thinking...") while loading
    - On response, render hint with `typewriterRender()` into the panel, then trigger MathJax typeset
    - Handle 429 (rate limit) by showing remaining count message
    - Handle errors with fallback message
    - _Requirements: 1.1, 1.2, 1.6, 1.7, 1.8, 1.9, 5.1, 5.3, 5.4, 5.5_

  - [ ] 5.3 Add AI diagnosis panel HTML and "Why am I stuck?" button to practice.ejs
    - Add `#aiDiagnosisPanel` styled card panel below stagnation warning
    - Show "Why am I stuck?" button when stagnation is detected (existing `data.stagnating` flag)
    - Button calls `fetchAiDiagnosis()` which POSTs to `/api/ai/diagnose` with conceptId
    - Display pulsing loader while loading
    - On response, render explanation with `typewriterRender()`, then MathJax typeset
    - Render clickable links for each study path concept: `<a href="/practice/{id}">{name}</a>`
    - Handle 429 and errors gracefully
    - _Requirements: 2.1, 2.2, 2.6, 2.7, 2.8, 2.9, 5.1, 5.3, 5.4, 5.5_

  - [ ] 5.4 Add shared client-side AI rendering functions to practice.ejs
    - `typewriterRender(container, fullText, onComplete)`: requestAnimationFrame-based, ~20 chars/frame, parses markdown via `marked.parse()`, triggers MathJax on complete
    - `showAiLoader(container)`: pulsing gradient skeleton with "Your AI tutor is thinking..." text
    - CSS for `.ai-panel`, `.ai-panel-header`, `.ai-panel-body`, `.ai-loader`, `.ai-loader-bar` (glass morphism, dark theme tokens)
    - _Requirements: 5.1, 5.3, 5.4, 5.5_

  - [ ] 5.5 Add floating chat widget to practice.ejs
    - Fixed-position button (bottom-right, 56px circle, purple gradient, gold border, robot icon)
    - Clicking toggles a 400×600px slide-up chat panel (glass morphism, dark theme)
    - Chat panel: header with title + close button, scrollable messages area, textarea input with placeholder "Ask your AI tutor anything...", send button
    - Enter to send, Shift+Enter for newline
    - On send: POST to `/api/ai/chat`, show typing indicator (animated dots), render response with `typewriterRender()`, auto-scroll
    - Full-width on mobile (below 768px)
    - Handle 429 rate limit display
    - _Requirements: 3.1, 3.2, 3.4, 3.6, 3.8, 3.9, 5.1, 5.2, 5.5, 5.6, 5.7_

- [ ] 6. Update chat.ejs — full-page AI chat with Gemini backend
  - [ ] 6.1 Update `views/chat.ejs` to use `/api/ai/chat` endpoint and add markdown/MathJax rendering
    - Change fetch URL from `/api/chat` to `/api/ai/chat`
    - Add marked.js CDN script tag
    - Add MathJax configuration and script tag (matching practice.ejs setup)
    - Replace `formatMessage()` with `marked.parse()` for markdown rendering
    - Add `typewriterRender()` function for AI response animation
    - Trigger `MathJax.typesetPromise()` after each response renders
    - Add typing indicator (animated dots) while waiting for response
    - Update placeholder text to "Ask your AI tutor anything..."
    - Apply glass morphism styling using Learn.ai theme tokens (--bg, --surface, --glass-bg, --purple, --gold, --text, --border)
    - _Requirements: 3.6, 3.8, 3.9, 3.10, 5.2, 5.3, 5.4, 5.6_

- [ ] 7. Add floating chat widget to dashboard.ejs
  - [ ] 7.1 Add the same floating chat widget HTML/CSS/JS to `views/dashboard.ejs`
    - Same widget as practice.ejs (fixed bottom-right button, slide-up panel, glass morphism)
    - POSTs to `/api/ai/chat`, typing animation, markdown + MathJax rendering
    - Add marked.js CDN script tag to dashboard.ejs `<head>`
    - MathJax not currently loaded in dashboard — add MathJax config + script tag
    - _Requirements: 3.1, 3.2, 3.4, 3.6, 3.8, 3.9, 5.2, 5.5, 5.6, 5.7_

- [ ] 8. Final checkpoint — Ensure all features are wired together
  - Ensure all tests pass, ask the user if questions arise.
  - Verify: practice.ejs shows "Get AI Hint" on wrong answer, "Why am I stuck?" on stagnation, floating chat widget
  - Verify: dashboard.ejs shows floating chat widget
  - Verify: chat.ejs uses new `/api/ai/chat` endpoint with markdown + MathJax
  - Verify: rate limiter applies to all `/api/ai/*` routes
  - Verify: all three AI endpoints return proper fallbacks on Gemini failure

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- The project uses ES modules (`import`/`export`) throughout — all new files must use ESM syntax
- The existing `helpers/gemini.js` exports `geminiGenerate(systemPrompt, userPrompt, model)` — the service calls this with model `gemini-2.0-flash`
- The existing `views/chat.ejs` currently uses `/api/chat` (Perplexity-based) — task 6 migrates it to the new Gemini-based `/api/ai/chat`
