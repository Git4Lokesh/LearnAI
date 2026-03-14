# BKT Implementation in Learn.ai

## Architecture Overview
The Bayesian Knowledge Tracing (BKT) service models a student's cognitive mastery of different concepts over time. It operates as a dual-layer system:
1. **Real-time Inference Server (`main.py`)**: A FastAPI application that handles live student attempts, computing Bayesian probability updates and maintaining the active DB state of user mastery.
2. **Batch Parameter Learner (`em_fitter.py`)**: An asynchronous background service that applies Expectation-Maximization to fit empirical response data into optimal BKT parameters for specific concepts.

---

## 1. The Core BKT Model
BKT acts as a Hidden Markov Model (HMM) where the hidden state is a boolean (Mastered vs. Unmastered), and the observations are correct/incorrect answers. The model relies on four main parameters:
- **`p_init`**: Probability of knowing the concept before any practice.
- **`p_learn`**: Probability of learning the concept (transitioning from Unmastered to Mastered) during a single practice attempt.
- **`p_guess`**: Probability of getting the correct answer despite not having mastered the concept.
- **`p_slip`**: Probability of getting the answer wrong despite having mastered the concept.

---

## 2. Real-time Inference & Updating (`main.py`)
The active progression of a user's mastery is dictated by several sophisticated mechanisms upon every question attempt.

### Bayesian State Update
For every question answered via `/update-concept`, the math executes in two phases:
1. **Emission Step (`_bayes_update`)**: Updates the prior mastery using Bayes' rule based on the observed correctness.
2. **Transition Step (`_apply_learning`)**: Adds the baseline probability of learning the concept simply by engaging with the question. 

### Custom Extensions to Standard BKT
- **Time-based Learning Boost**: A custom modifier (`_time_multiplier`) boosts the `p_learn` value up to 1.3x if the student answers a question correctly much faster than the expected baseline time for that difficulty tier.
- **Continuous Knowledge Decay**: The `_decay_mastery` function implements a continuous time decay model ($e^{-0.05 \times \text{days}}$) preventing permanent mastery without practice. Mastery floors out at 0.10.
- **Hybrid BKT-IRT Tiering**: To reflect Item Response Theory concepts, `p_guess` and `p_slip` are resolved at the *item* level (Difficulty Tier), while `p_init` and `p_learn` are treated as *concept-wide* cognitive variables (averaged across tiers when overriding defaults).

---

## 3. Parameter Fitting via Expectation-Maximization (`em_fitter.py`)
Rather than keeping global standard parameters permanently, the system acts dynamically.

### Constructing Sequences
When launched, `em_fitter` groups student answers chronologically from `user_question_attempts` strictly by `concept_id` and `difficulty_tier` into continuous sets of boolean results.

### The Baum-Welch Algorithm
It executes a Forward-Backward algorithm over these sequences:
1. **E-Step**: It computes trailing probabilities (`gamma` and `xi`) predicting exactly at what chronological step the student transitioned from unmastered to mastered for a given sequence.
2. **M-Step**: Through aggregation, it refines estimates for `p_init`, `p_learn`, `p_guess`, and `p_slip` to maximize overall log-likelihood.

### Validation and DB Commit
The parameters are bounded tightly (e.g. `p_guess` capped at 0.45, `p_guess + p_slip` prevented from approaching random noise thresholds). If passing internal validations, they are versioned and stored into `concept_bkt_params` where the active microservice seamlessly caches them.
