# Requirements Document

## Introduction

This feature implements persistent PostgreSQL storage for Bayesian Knowledge Tracing (BKT) user progress data in an AI-powered EdTech platform. Currently, the Python BKT service stores user mastery probabilities in volatile memory, causing data loss on service restarts. This feature transforms the BKT service into a stateless component backed by PostgreSQL, enabling reliable progress tracking and personalized AI interactions through mastery-aware LLM prompts.

## Glossary

- **BKT_Service**: Python service that calculates student mastery probabilities using Bayesian Knowledge Tracing algorithms
- **User_Progress**: Student mastery probability data for specific skills or concepts
- **Mastery_Probability**: Numerical value (0.0 to 1.0) representing student's estimated knowledge of a skill
- **Node_API**: Node.js backend service that handles HTTP requests and orchestrates business logic
- **LLM_Prompt**: Text input sent to Perplexity AI that includes context and instructions
- **Progress_Store**: PostgreSQL database table storing user mastery data
- **Study_Session**: User interaction where learning occurs and progress is tracked

## Requirements

### Requirement 1: Persist User Progress Data

**User Story:** As a student, I want my learning progress to be saved permanently, so that my mastery levels are preserved across sessions and service restarts.

#### Acceptance Criteria

1. THE Progress_Store SHALL store User_Progress records with user_id, skill_id, mastery_probability, and timestamp fields
2. WHEN the BKT_Service calculates a new Mastery_Probability, THE Node_API SHALL persist the value to the Progress_Store
3. WHEN the BKT_Service restarts, THE Progress_Store SHALL retain all previously stored User_Progress records
4. THE Progress_Store SHALL support concurrent read and write operations from multiple Node_API instances
5. WHEN a User_Progress record is updated, THE Progress_Store SHALL maintain the previous mastery_probability value with its timestamp for historical tracking

### Requirement 2: Retrieve User Progress for BKT Calculations

**User Story:** As the BKT service, I want to retrieve stored mastery probabilities, so that I can continue tracking progress from the last known state rather than starting from default values.

#### Acceptance Criteria

1. WHEN the BKT_Service receives a calculation request, THE Node_API SHALL retrieve the current Mastery_Probability from the Progress_Store
2. IF no User_Progress record exists for a given user_id and skill_id combination, THEN THE BKT_Service SHALL use a default initial mastery probability of 0.0
3. THE Node_API SHALL provide the retrieved Mastery_Probability to the BKT_Service within 100ms of the request
4. WHEN multiple skills are involved in a Study_Session, THE Node_API SHALL retrieve all relevant User_Progress records in a single database query

### Requirement 3: Inject Progress Data into LLM Prompts

**User Story:** As an educator, I want the AI tutor to understand each student's mastery levels, so that it can provide personalized guidance appropriate to their knowledge state.

#### Acceptance Criteria

1. WHEN generating an LLM_Prompt, THE Node_API SHALL retrieve relevant User_Progress records for the student
2. THE Node_API SHALL format Mastery_Probability values into human-readable context within the LLM_Prompt
3. WHEN a student has mastered a skill (mastery_probability >= 0.8), THE LLM_Prompt SHALL indicate high mastery to enable advanced content
4. WHEN a student is struggling with a skill (mastery_probability < 0.4), THE LLM_Prompt SHALL indicate low mastery to enable remedial support
5. THE Node_API SHALL include mastery data for all skills relevant to the current learning context in the LLM_Prompt

### Requirement 4: Make BKT Service Stateless

**User Story:** As a platform engineer, I want the BKT service to be stateless, so that I can scale it horizontally and restart it without data loss.

#### Acceptance Criteria

1. THE BKT_Service SHALL NOT store User_Progress data in memory beyond the duration of a single calculation request
2. WHEN the BKT_Service completes a calculation, THE BKT_Service SHALL return the new Mastery_Probability to the Node_API without persisting it locally
3. THE BKT_Service SHALL accept current Mastery_Probability as input parameters for each calculation request
4. WHEN multiple BKT_Service instances are running, THE Node_API SHALL be able to route requests to any instance without session affinity

### Requirement 5: Handle Database Connection Failures

**User Story:** As a platform engineer, I want graceful error handling for database failures, so that temporary outages don't crash the service or corrupt data.

#### Acceptance Criteria

1. IF the Progress_Store connection fails during a read operation, THEN THE Node_API SHALL return an error response with status code 503
2. IF the Progress_Store connection fails during a write operation, THEN THE Node_API SHALL return an error response and log the failed User_Progress update
3. WHEN the Progress_Store connection is restored, THE Node_API SHALL resume normal operations without requiring a restart
4. THE Node_API SHALL implement connection pooling with automatic retry logic for transient database failures
5. WHEN a database timeout occurs (>5 seconds), THE Node_API SHALL abort the operation and return an error response

### Requirement 6: Maintain Data Integrity

**User Story:** As a data analyst, I want user progress data to be accurate and consistent, so that I can trust the analytics and reporting derived from it.

#### Acceptance Criteria

1. THE Progress_Store SHALL enforce a unique constraint on the combination of user_id and skill_id for current mastery records
2. WHEN updating a User_Progress record, THE Node_API SHALL use database transactions to ensure atomicity
3. THE Progress_Store SHALL validate that mastery_probability values are between 0.0 and 1.0 inclusive
4. WHEN concurrent updates occur for the same user_id and skill_id, THE Progress_Store SHALL process them serially using row-level locking
5. THE Node_API SHALL validate that user_id and skill_id exist in their respective tables before creating User_Progress records

### Requirement 7: Support Progress History Queries

**User Story:** As a student, I want to see how my mastery has improved over time, so that I can track my learning journey and stay motivated.

#### Acceptance Criteria

1. THE Progress_Store SHALL maintain a history table with all historical User_Progress updates
2. WHEN a User_Progress record is updated, THE Node_API SHALL insert the previous value into the history table before updating the current record
3. THE Node_API SHALL provide an endpoint that retrieves User_Progress history for a given user_id and skill_id
4. THE history query SHALL return records ordered by timestamp in descending order
5. WHEN querying progress history, THE Node_API SHALL support filtering by date range

### Requirement 8: Optimize for Read-Heavy Workload

**User Story:** As a platform engineer, I want efficient database queries, so that the system can handle high user concurrency during peak learning hours.

#### Acceptance Criteria

1. THE Progress_Store SHALL have indexes on user_id, skill_id, and the composite key (user_id, skill_id)
2. WHEN retrieving User_Progress for LLM_Prompt generation, THE Node_API SHALL use a single query with JOIN operations rather than multiple sequential queries
3. THE Node_API SHALL implement caching for frequently accessed User_Progress records with a TTL of 60 seconds
4. WHEN cache entries exist, THE Node_API SHALL serve User_Progress data from cache and skip database queries
5. WHEN User_Progress is updated, THE Node_API SHALL invalidate the corresponding cache entry

