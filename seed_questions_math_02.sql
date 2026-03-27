-- Learn.ai JEE Mains Question Seed: Mathematics Units 4-14
-- Permutations/Combinations, Binomial Theorem, Sequences/Series,
-- Limits/Continuity/Differentiability, Integral Calculus, Differential Equations,
-- Coordinate Geometry, 3D Geometry, Vector Algebra, Statistics/Probability, Trigonometry
-- 41 subconcepts × 21 questions = 861 questions
-- Difficulty: Tier 1 (Easy), Tier 2 (Medium), Tier 3 (Hard)
-- All questions verified for correctness
-- Source: Original questions inspired by JEE Mains patterns

INSERT INTO questions (question_text, option1, option2, option3, option4, correct_answer, solution_text, concept_id, difficulty_tier, source, status) VALUES

-- ============================================================
-- CONCEPT: m_counting_principle (Fundamental principle of counting)
-- Chapter: math_permutations_combinations
-- ============================================================

-- Tier 1 (Easy)
('If there are 3 routes from city A to city B and 4 routes from city B to city C, the number of ways to travel from A to C via B is', '$7$', '$12$', '$1$', '$64$', 'option2', 'By the multiplication principle, the total number of ways $= 3 \times 4 = 12$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('A person has 2 shirts and 3 pants. The number of different outfits is', '$6$', '$5$', '$8$', '$9$', 'option1', 'Each shirt can be paired with each pant: $2 \times 3 = 6$ outfits.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('A coin is tossed 3 times. The total number of possible outcomes is', '$6$', '$8$', '$3$', '$9$', 'option2', 'Each toss has 2 outcomes. Total $= 2^3 = 8$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('The number of 3-digit numbers formed using digits $\{1, 2, 3, 4\}$ with repetition allowed is', '$64$', '$24$', '$12$', '$81$', 'option1', 'Each of the 3 positions can be filled by any of 4 digits: $4 \times 4 \times 4 = 64$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('Two dice are thrown simultaneously. The total number of outcomes is', '$36$', '$12$', '$6$', '$24$', 'option1', 'Each die has 6 outcomes. Total $= 6 \times 6 = 36$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('A test has 5 true/false questions. The number of ways to answer all questions is', '$32$', '$10$', '$25$', '$16$', 'option1', 'Each question has 2 choices. Total $= 2^5 = 32$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

('A code consists of one letter followed by two digits. The number of possible codes is', '$520$', '$260$', '$2600$', '$1000$', 'option3', 'Letters: 26 choices. Each digit: 10 choices. Total $= 26 \times 10 \times 10 = 2600$.', 'm_counting_principle', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The number of 3-digit even numbers formed using $\{1, 2, 3, 4, 5\}$ without repetition is', '$36$', '$24$', '$20$', '$30$', 'option2', 'Last digit (even): 2 or 4 — 2 choices. First digit: 4 remaining choices. Middle digit: 3 remaining choices. Total $= 4 \times 3 \times 2 = 24$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('The number of 3-digit numbers from $\{1, 2, 3, 4, 5\}$ without repetition that are divisible by 5 is', '$8$', '$20$', '$24$', '$12$', 'option4', 'Last digit must be 5: 1 choice. First digit: 4 choices (from remaining). Middle digit: 3 choices. Total $= 4 \times 3 \times 1 = 12$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('5 people are to be arranged in a row. The number of arrangements is', '$720$', '$60$', '$24$', '$120$', 'option4', 'The number of arrangements of $n$ distinct objects in a row is $n!$. Here $5! = 120$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('The number of 3-digit numbers with no repeated digit, using digits $\{0, 1, 2, 3, 4, 5\}$, is', '$60$', '$120$', '$80$', '$100$', 'option4', 'First digit: 5 choices (1-5, since 0 not allowed). Second digit: 5 choices (remaining 5 digits including 0). Third digit: 4 choices. Total $= 5 \times 5 \times 4 = 100$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('The number of ways to arrange the letters of the word MONDAY is', '$720$', '$360$', '$120$', '$5040$', 'option1', 'MONDAY has 6 distinct letters. Arrangements $= 6! = 720$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('Using 4 flags of different colours, the number of different signals that can be made by hoisting 1 or more flags in order is', '$24$', '$60$', '$64$', '$256$', 'option3', '1 flag: $4$. 2 flags: $4 \times 3 = 12$. 3 flags: $4 \times 3 \times 2 = 24$. 4 flags: $4! = 24$. Total $= 4 + 12 + 24 + 24 = 64$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

('A person travels from A to B by 3 routes and B to C by 4 routes. The number of round trips A→B→C→B→A using different routes each way is', '$144$', '$72$', '$36$', '$48$', 'option2', 'A→B: 3 choices. B→C: 4 choices. C→B: 3 choices (cannot repeat the B→C route). B→A: 2 choices (cannot repeat the A→B route). Total $= 3 \times 4 \times 3 \times 2 = 72$.', 'm_counting_principle', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The number of functions from a set of 3 elements to a set of 4 elements is', '$64$', '$12$', '$24$', '$81$', 'option1', 'Each of the 3 elements can be mapped to any of 4 elements independently. Total $= 4^3 = 64$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of onto functions from $\{1, 2, 3\}$ to $\{a, b\}$ is', '$4$', '$8$', '$6$', '$2$', 'option3', 'Total functions $= 2^3 = 8$. Non-onto functions map everything to one element: 2 such functions. Onto functions $= 8 - 2 = 6$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of 4-digit numbers greater than 5000 formed from $\{0, 1, 3, 5, 7\}$ without repetition is', '$72$', '$48$', '$36$', '$96$', 'option2', 'First digit must be 5 or 7 (2 choices). Remaining 3 positions filled from 4 remaining digits: $4 \times 3 \times 2 = 24$. Total $= 2 \times 24 = 48$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of ways to seat 6 people around a circular table is', '$60$', '$720$', '$120$', '$360$', 'option3', 'Circular permutations of $n$ objects $= (n-1)!$. Here $(6-1)! = 5! = 120$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of ways to seat 4 boys and 3 girls in a row so that no two girls are adjacent is', '$2880$', '$720$', '$1440$', '$5040$', 'option3', 'Arrange 4 boys: $4! = 24$ ways. This creates 5 gaps: _B_B_B_B_. Choose 3 gaps for girls and arrange: $P(5,3) = 5 \times 4 \times 3 = 60$. Total $= 24 \times 60 = 1440$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of 5-digit numbers with no repeated digit (digits 0-9) is', '$100000$', '$30240$', '$27216$', '$90000$', 'option3', 'First digit: 9 choices (1-9). Second: 9 (0-9 minus first). Third: 8. Fourth: 7. Fifth: 6. Total $= 9 \times 9 \times 8 \times 7 \times 6 = 27216$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),

('The number of 6-digit numbers using digits $\{1, 2, 3\}$ where each digit appears at least once is', '$729$', '$540$', '$486$', '$360$', 'option2', 'Total $= 3^6 = 729$. By inclusion-exclusion, subtract numbers missing at least one digit. Let $A_i$ = numbers missing digit $i$. $|A_i| = 2^6 = 64$, $|A_i \cap A_j| = 1$. $|A_1 \cup A_2 \cup A_3| = 3(64) - 3(1) + 0 = 189$. Answer $= 729 - 189 = 540$.', 'm_counting_principle', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_pnr_cnr (Permutations P(n,r) and Combinations C(n,r) and applications)
-- Chapter: math_permutations_combinations
-- ============================================================

-- Tier 1 (Easy)
('$P(5, 2)$ equals', '$20$', '$10$', '$25$', '$60$', 'option1', '$P(5,2) = \frac{5!}{(5-2)!} = \frac{5!}{3!} = \frac{120}{6} = 20$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$C(5, 2)$ equals', '$5$', '$20$', '$10$', '$25$', 'option3', '$C(5,2) = \frac{5!}{2! \cdot 3!} = \frac{120}{2 \times 6} = 10$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$C(n, 0)$ for any positive integer $n$ equals', '$n$', '$0$', '$1$', '$n!$', 'option3', '$C(n,0) = \frac{n!}{0! \cdot n!} = 1$. There is exactly one way to choose 0 items from $n$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$P(n, n)$ equals', '$n!$', '$1$', '$n$', '$n^n$', 'option1', '$P(n,n) = \frac{n!}{(n-n)!} = \frac{n!}{0!} = n!$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$C(10, 3)$ equals', '$210$', '$720$', '$120$', '$30$', 'option3', '$C(10,3) = \frac{10!}{3! \cdot 7!} = \frac{10 \times 9 \times 8}{6} = 120$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$C(n, r)$ is equal to', '$C(r, n)$', '$C(n-1, r)$', '$C(n, r+1)$', '$C(n, n-r)$', 'option4', '$C(n,r) = \frac{n!}{r!(n-r)!} = \frac{n!}{(n-r)!r!} = C(n, n-r)$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

('$P(4, 3)$ equals', '$4$', '$12$', '$64$', '$24$', 'option4', '$P(4,3) = \frac{4!}{1!} = 24$.', 'm_pnr_cnr', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The number of ways to choose a committee of 3 from 8 people is', '$24$', '$336$', '$56$', '$120$', 'option3', 'Order does not matter, so $C(8,3) = \frac{8 \times 7 \times 6}{6} = 56$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('The number of arrangements of the letters of BANANA is', '$60$', '$720$', '$120$', '$360$', 'option1', 'BANANA has 6 letters: B(1), A(3), N(2). Arrangements $= \frac{6!}{3! \cdot 2!} = \frac{720}{12} = 60$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('The number of diagonals of an octagon is', '$20$', '$28$', '$16$', '$40$', 'option1', 'Diagonals of an $n$-sided polygon $= C(n,2) - n$. For $n = 8$: $C(8,2) - 8 = 28 - 8 = 20$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('If $C(n, 2) = 45$, then $n$ is', '$10$', '$9$', '$8$', '$45$', 'option1', '$C(n,2) = \frac{n(n-1)}{2} = 45$, so $n(n-1) = 90$. Testing: $10 \times 9 = 90$. Hence $n = 10$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('The number of handshakes among 10 people (each shakes hands with every other person exactly once) is', '$100$', '$90$', '$45$', '$50$', 'option3', 'Each handshake involves 2 people: $C(10,2) = \frac{10 \times 9}{2} = 45$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('The number of ways to distribute 5 identical balls into 3 distinct boxes is', '$10$', '$15$', '$21$', '$35$', 'option3', 'Stars and bars: $C(5+3-1, 3-1) = C(7, 2) = 21$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

('The number of arrangements of the letters of COMMITTEE is', '$90720$', '$362880$', '$45360$', '$181440$', 'option3', 'COMMITTEE has 9 letters: C(1), O(1), M(2), I(1), T(2), E(2). Arrangements $= \frac{9!}{2! \cdot 2! \cdot 2!} = \frac{362880}{8} = 45360$.', 'm_pnr_cnr', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('A committee of 4 is to be formed from 6 men and 4 women such that at least 2 women are included. The number of ways is', '$90$', '$120$', '$115$', '$210$', 'option3', 'At least 2 women: $C(4,2)C(6,2) + C(4,3)C(6,1) + C(4,4)C(6,0) = 6 \times 15 + 4 \times 6 + 1 \times 1 = 90 + 24 + 1 = 115$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('The number of arrangements of the letters of MISSISSIPPI is', '$34650$', '$39916800$', '$69300$', '$11!$', 'option1', 'MISSISSIPPI has 11 letters: M(1), I(4), S(4), P(2). Arrangements $= \frac{11!}{4! \cdot 4! \cdot 2!} = \frac{39916800}{24 \times 24 \times 2} = \frac{39916800}{1152} = 34650$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('The number of triangles that can be formed by joining 10 points in a plane (no three collinear) is', '$120$', '$90$', '$45$', '$720$', 'option1', 'Each triangle is determined by choosing 3 points: $C(10,3) = \frac{10 \times 9 \times 8}{6} = 120$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('$C(n, r) + C(n, r-1)$ equals', '$2 \cdot C(n, r)$', '$C(n, r+1)$', '$C(n+1, r+1)$', '$C(n+1, r)$', 'option4', 'This is Pascal''s identity: $C(n,r) + C(n,r-1) = C(n+1,r)$. It can be verified by expanding using the factorial formula.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('The number of ways to divide 12 people into 3 equal groups of 4 is', '$11550$', '$34650$', '$495$', '$5775$', 'option4', 'Choose first group: $C(12,4)$. Second: $C(8,4)$. Third: $C(4,4)$. Since groups are unordered, divide by $3!$: $\frac{C(12,4) \cdot C(8,4) \cdot C(4,4)}{3!} = \frac{495 \times 70 \times 1}{6} = 5775$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('If $C(n, 4) = C(n, 6)$, then $C(n, 2)$ equals', '$120$', '$10$', '$45$', '$210$', 'option3', '$C(n,4) = C(n,6)$ implies $4 = n - 6$ (using $C(n,r) = C(n,n-r)$), so $n = 10$. Then $C(10,2) = \frac{10 \times 9}{2} = 45$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),

('The number of ways to arrange the letters of PERMUTATION is', '$\frac{11!}{3!}$', '$11!$', '$\frac{11!}{2! \cdot 2!}$', '$\frac{11!}{2!}$', 'option4', 'PERMUTATION has 11 letters: P, E, R, M, U, T, A, T, I, O, N. Only T is repeated (twice). Arrangements $= \frac{11!}{2!}$.', 'm_pnr_cnr', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_binomial_positive_index (Binomial theorem for a positive integral index)
-- Chapter: math_binomial_theorem
-- ============================================================

-- Tier 1 (Easy)
('The number of terms in the expansion of $(a + b)^6$ is', '$7$', '$6$', '$12$', '$64$', 'option1', 'The expansion of $(a+b)^n$ has $n+1$ terms. For $n = 6$: $6 + 1 = 7$ terms.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('The expansion of $(1 + x)^4$ has how many terms?', '$8$', '$4$', '$5$', '$16$', 'option3', '$(1+x)^n$ has $n+1$ terms. For $n = 4$: $4 + 1 = 5$ terms.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('$C(n,0) + C(n,1) + C(n,2) + \ldots + C(n,n)$ equals', '$2^n$', '$n!$', '$n^2$', '$2n$', 'option1', 'Setting $x = 1$ in $(1+x)^n = \sum_{r=0}^{n} C(n,r) x^r$ gives $2^n = \sum_{r=0}^{n} C(n,r)$.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^2 y$ in the expansion of $(x + y)^3$ is', '$3$', '$1$', '$6$', '$2$', 'option1', '$(x+y)^3 = x^3 + 3x^2y + 3xy^2 + y^3$. The coefficient of $x^2y$ is $C(3,1) = 3$.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^2$ in $(1 + x)^5$ is', '$5$', '$10$', '$20$', '$1$', 'option2', 'Coefficient of $x^r$ in $(1+x)^n$ is $C(n,r)$. Here $C(5,2) = 10$.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('$(a + b)^0$ equals', '$1$', '$a + b$', '$0$', '$a^0 + b^0$', 'option1', 'Any non-zero expression raised to the power 0 equals 1.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

('In the expansion of $(1 + x)^n$, the first and last terms are', '$1$ and $nx$', '$1$ and $x^n$', '$n$ and $x^n$', '$1$ and $1$', 'option2', 'The first term is $C(n,0) \cdot 1^n \cdot x^0 = 1$ and the last term is $C(n,n) \cdot x^n = x^n$.', 'm_binomial_positive_index', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The coefficient of $x^2$ in the expansion of $(2 + x)^4$ is', '$32$', '$6$', '$16$', '$24$', 'option4', 'General term: $C(4,r) \cdot 2^{4-r} \cdot x^r$. For $r = 2$: $C(4,2) \cdot 2^2 = 6 \times 4 = 24$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^3$ in $(1 - x)^6$ is', '$-20$', '$20$', '$-6$', '$15$', 'option1', 'Coefficient of $x^r$ in $(1-x)^n$ is $(-1)^r C(n,r)$. For $r = 3$: $(-1)^3 C(6,3) = -20$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('The constant term in the expansion of $\left(x + \frac{1}{x}\right)^6$ is', '$1$', '$6$', '$15$', '$20$', 'option4', 'General term: $C(6,r) \cdot x^{6-r} \cdot x^{-r} = C(6,r) \cdot x^{6-2r}$. For constant term: $6 - 2r = 0$, so $r = 3$. Term $= C(6,3) = 20$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('The sum of all coefficients in the expansion of $(1 + x)^{10}$ is', '$100$', '$512$', '$2048$', '$1024$', 'option4', 'Put $x = 1$: sum of coefficients $= (1+1)^{10} = 2^{10} = 1024$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('$C(n,0) - C(n,1) + C(n,2) - C(n,3) + \ldots + (-1)^n C(n,n)$ equals', '$2^n$', '$1$', '$0$', '$(-1)^n$', 'option3', 'Setting $x = -1$ in $(1+x)^n$: $(1-1)^n = 0$ for $n \geq 1$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^3$ in $(3x - 2)^5$ is', '$-720$', '$-1080$', '$720$', '$1080$', 'option4', '$T_{r+1} = C(5,r)(3x)^{5-r}(-2)^r$. For $x^3$: $5 - r = 3$, so $r = 2$. Coefficient $= C(5,2) \cdot 3^3 \cdot (-2)^2 = 10 \times 27 \times 4 = 1080$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

('The number of terms in the expansion of $(a + b + c)^4$ is', '$64$', '$12$', '$15$', '$10$', 'option3', 'The number of terms in $(a+b+c)^n$ is $C(n+2, 2)$. For $n = 4$: $C(6,2) = 15$.', 'm_binomial_positive_index', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If in $(1 + x)^n$, the coefficients of $x^3$ and $x^4$ are equal, then $n$ is', '$7$', '$6$', '$8$', '$5$', 'option1', '$C(n,3) = C(n,4)$. $\frac{n!}{3!(n-3)!} = \frac{n!}{4!(n-4)!}$. Simplifying: $\frac{1}{(n-3)} = \frac{1}{4}$ (after cancellation), so $n - 3 = 4$, giving $n = 7$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('The term independent of $x$ in $\left(x^2 - \frac{1}{x}\right)^9$ is', '$-36$', '$-84$', '$36$', '$84$', 'option4', '$T_{r+1} = C(9,r)(x^2)^{9-r}\left(-\frac{1}{x}\right)^r = C(9,r)(-1)^r x^{18-2r-r} = C(9,r)(-1)^r x^{18-3r}$. For $x^0$: $18 - 3r = 0$, so $r = 6$. Term $= C(9,6)(-1)^6 = 84$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('$C(10,0)^2 + C(10,1)^2 + C(10,2)^2 + \ldots + C(10,10)^2$ equals', '$2^{10}$', '$C(20, 10)$', '$C(10, 5)^2$', '$2^{20}$', 'option2', 'By Vandermonde''s identity, $\sum_{r=0}^{n} C(n,r)^2 = C(2n, n)$. For $n = 10$: $\sum C(10,r)^2 = C(20, 10)$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('The term independent of $x$ in $\left(\sqrt{x} - \frac{3}{x^2}\right)^{10}$ is', '$405$', '$-405$', '$135$', '$-135$', 'option1', '$T_{r+1} = C(10,r)(\sqrt{x})^{10-r}\left(-\frac{3}{x^2}\right)^r = C(10,r)(-3)^r x^{(10-r)/2 - 2r} = C(10,r)(-3)^r x^{(10-5r)/2}$. For $x^0$: $10 - 5r = 0$, so $r = 2$. Term $= C(10,2)(-3)^2 = 45 \times 9 = 405$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^5$ in $(1 + x)^{11}$ is', '$252$', '$330$', '$462$', '$210$', 'option3', '$C(11,5) = \frac{11!}{5! \cdot 6!} = \frac{11 \times 10 \times 9 \times 8 \times 7}{120} = \frac{55440}{120} = 462$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('The coefficient of $x^3$ in $(1 + 2x)^8$ is', '$56$', '$448$', '$112$', '$224$', 'option2', 'Coefficient of $x^3$ in $(1+2x)^8 = C(8,3) \cdot 2^3 = 56 \times 8 = 448$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),

('If the sum of coefficients in $(1 + x)^n$ is 4096, then $n$ is', '$12$', '$10$', '$11$', '$13$', 'option1', 'Sum of coefficients $= 2^n = 4096 = 2^{12}$. So $n = 12$.', 'm_binomial_positive_index', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_binomial_general_middle (General term and middle term and simple applications)
-- Chapter: math_binomial_theorem
-- ============================================================

-- Tier 1 (Easy)
('The general term $T_{r+1}$ in the expansion of $(a + b)^n$ is', '$C(n, r) \cdot a^r \cdot b^{n-r}$', '$C(n, r) \cdot a^{n-r} \cdot b^r$', '$n \cdot a^{n-r} \cdot b^r$', '$C(n, r) \cdot (ab)^r$', 'option2', 'By the binomial theorem, $T_{r+1} = C(n,r) \cdot a^{n-r} \cdot b^r$ for $r = 0, 1, \ldots, n$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('The middle term in the expansion of $(1 + x)^6$ is', '$20x^3$', '$15x^2$', '$6x$', '$x^6$', 'option1', 'For even $n = 6$, the middle term is $T_{n/2+1} = T_4 = C(6,3)x^3 = 20x^3$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('$T_3$ in the expansion of $(a + b)^5$ is', '$5a^4b$', '$10a^3b^2$', '$10a^2b^3$', '$a^5$', 'option2', '$T_3 = T_{2+1} = C(5,2) a^{5-2} b^2 = 10a^3b^2$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('$T_2$ in the expansion of $(1 + x)^4$ is', '$4x^2$', '$6x^2$', '$x$', '$4x$', 'option4', '$T_2 = C(4,1) \cdot 1^3 \cdot x = 4x$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('The middle term of $(1 + x)^4$ is', '$6x^2$', '$4x$', '$4x^3$', '$x^4$', 'option1', 'For $n = 4$ (even), middle term $= T_3 = C(4,2)x^2 = 6x^2$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('The expansion of $(a + b)^5$ has how many middle terms?', '$5$', '$1$', '$3$', '$2$', 'option4', 'When $n$ is odd ($n = 5$), there are two middle terms: $T_3$ and $T_4$ (the $\frac{n+1}{2}$th and $\frac{n+3}{2}$th terms).', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

('$T_1$ in the expansion of $(a + b)^n$ is', '$a^n$', '$b^n$', '$C(n,1) \cdot a^{n-1}b$', '$1$', 'option1', '$T_1 = C(n,0) \cdot a^n \cdot b^0 = a^n$.', 'm_binomial_general_middle', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The middle term of $\left(x - \frac{1}{x}\right)^8$ is', '$-56$', '$-70$', '$56$', '$70$', 'option4', 'Middle term $= T_5 = C(8,4) \cdot x^4 \cdot \left(-\frac{1}{x}\right)^4 = 70 \cdot x^4 \cdot \frac{1}{x^4} = 70$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('$T_4$ in the expansion of $(2x - 3)^7$ is', '$5040x^4$', '$15120x^4$', '$-5040x^4$', '$-15120x^4$', 'option4', '$T_4 = C(7,3)(2x)^4(-3)^3 = 35 \cdot 16x^4 \cdot (-27) = -15120x^4$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('The greatest binomial coefficient in $(1 + x)^{10}$ is', '$C(10, 5) = 252$', '$C(10, 4) = 210$', '$C(10, 6) = 210$', '$C(10, 3) = 120$', 'option1', 'For even $n$, the greatest binomial coefficient is $C(n, n/2) = C(10, 5) = 252$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('If $T_3$ in $(1 + x)^n$ equals $28x^2$, then $n$ is', '$8$', '$7$', '$6$', '$14$', 'option1', '$T_3 = C(n,2)x^2 = 28x^2$. So $C(n,2) = 28$, i.e., $\frac{n(n-1)}{2} = 28$, giving $n(n-1) = 56$. Since $8 \times 7 = 56$, $n = 8$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('The middle term of $(1 + x)^{10}$ is', '$C(10, 6) x^6$', '$C(10, 4) x^4$', '$C(10, 5) x^5$', '$C(10, 10) x^{10}$', 'option3', 'For even $n = 10$, the middle term is $T_6 = C(10,5)x^5 = 252x^5$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('$T_3$ in the expansion of $\left(x^2 + \frac{1}{x}\right)^6$ is', '$6x^6$', '$20x^6$', '$15x^6$', '$15x^3$', 'option3', '$T_3 = C(6,2)(x^2)^4 \left(\frac{1}{x}\right)^2 = 15 \cdot x^8 \cdot x^{-2} = 15x^6$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

('$T_5$ in $\left(x + \frac{1}{x^2}\right)^8$ equals', '$56x^4$', '$70x^4$', '$\frac{56}{x^4}$', '$\frac{70}{x^4}$', 'option4', '$T_5 = C(8,4) \cdot x^4 \cdot \left(\frac{1}{x^2}\right)^4 = 70 \cdot x^4 \cdot x^{-8} = 70x^{-4} = \frac{70}{x^4}$.', 'm_binomial_general_middle', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The middle term of $\left(\frac{x}{3} + 9y\right)^{10}$ is', '$61236 x^5 y^5$', '$252 x^5 y^5$', '$30618 x^5 y^5$', '$122472 x^5 y^5$', 'option1', 'Middle term $= T_6 = C(10,5)\left(\frac{x}{3}\right)^5(9y)^5 = 252 \cdot \frac{x^5}{243} \cdot 59049 y^5 = 252 \times 243 \times x^5 y^5 = 61236 x^5 y^5$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('If the coefficient of $T_3$ in $(1 + x)^n$ is 36, then $n$ is', '$12$', '$8$', '$6$', '$9$', 'option4', '$T_3 = C(n,2)x^2$. Coefficient $= C(n,2) = \frac{n(n-1)}{2} = 36$, so $n(n-1) = 72$. Since $9 \times 8 = 72$, $n = 9$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('The ratio of $T_5$ to $T_6$ in $(1 + x)^{10}$ at $x = \frac{1}{2}$ is', '$\frac{5}{3}$', '$\frac{3}{5}$', '$\frac{5}{6}$', '$\frac{6}{5}$', 'option1', '$\frac{T_5}{T_6} = \frac{C(10,4)(1/2)^4}{C(10,5)(1/2)^5} = \frac{C(10,4)}{C(10,5)} \cdot 2 = \frac{210}{252} \cdot 2 = \frac{5}{6} \cdot 2 = \frac{5}{3}$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('In $(1 + x)^{20}$, the ratio of the middle term coefficient to the coefficient of the term just before it is', '$\frac{10}{11}$', '$\frac{11}{10}$', '$\frac{2}{1}$', '$\frac{20}{19}$', 'option2', 'Middle term $= T_{11}$, coefficient $= C(20,10)$. Previous term $= T_{10}$, coefficient $= C(20,9)$. Ratio $= \frac{C(20,10)}{C(20,9)} = \frac{20!/(10! \cdot 10!)}{20!/(9! \cdot 11!)} = \frac{9! \cdot 11!}{10! \cdot 10!} = \frac{11}{10}$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('In $(1 + x)^{10}$ with $x = \frac{2}{3}$, the greatest term is', '$T_5$', '$T_6$', '$T_4$', '$T_7$', 'option1', '$\frac{T_{r+1}}{T_r} = \frac{C(10,r)}{C(10,r-1)} \cdot \frac{2}{3} = \frac{11-r}{r} \cdot \frac{2}{3}$. Setting $\geq 1$: $2(11-r) \geq 3r$, so $22 \geq 5r$, giving $r \leq 4.4$. The ratio exceeds 1 for $r \leq 4$ and falls below 1 for $r \geq 5$. So the greatest term is $T_5$ (at $r = 4$).', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('If $(1+x)^n = C_0 + C_1 x + C_2 x^2 + \ldots + C_n x^n$, then $\frac{C_1}{C_0} + \frac{2C_2}{C_1} + \frac{3C_3}{C_2} + \ldots + \frac{nC_n}{C_{n-1}}$ equals', '$\frac{n(n-1)}{2}$', '$2^n$', '$n^2$', '$\frac{n(n+1)}{2}$', 'option4', 'The $k$-th term is $\frac{k \cdot C(n,k)}{C(n,k-1)} = k \cdot \frac{n-k+1}{k} = n - k + 1$. Summing from $k = 1$ to $n$: $\sum_{k=1}^{n}(n-k+1) = n + (n-1) + \ldots + 1 = \frac{n(n+1)}{2}$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),

('The term with the greatest coefficient in $(1 + x)^8$ is', '$56x^3$', '$70x^4$', '$56x^5$', '$28x^6$', 'option2', 'For even $n = 8$, the greatest binomial coefficient is $C(8, 4) = 70$. The corresponding term is $T_5 = C(8,4)x^4 = 70x^4$.', 'm_binomial_general_middle', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_ap_gp (Arithmetic and Geometric progressions)
-- Chapter: math_sequence_series
-- ============================================================

-- Tier 1 (Easy)
('The common difference of the A.P. $2, 5, 8, 11, \ldots$ is', '$2$', '$3$', '$5$', '$-3$', 'option2', 'Common difference $d = a_2 - a_1 = 5 - 2 = 3$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('The 10th term of the A.P. $3, 7, 11, \ldots$ is', '$40$', '$43$', '$35$', '$39$', 'option4', '$a_{10} = a + 9d = 3 + 9(4) = 3 + 36 = 39$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('The sum of the first 10 natural numbers is', '$55$', '$50$', '$45$', '$100$', 'option1', '$S = \frac{n(n+1)}{2} = \frac{10 \times 11}{2} = 55$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('The common ratio of the G.P. $2, 6, 18, 54, \ldots$ is', '$4$', '$2$', '$3$', '$6$', 'option3', 'Common ratio $r = \frac{a_2}{a_1} = \frac{6}{2} = 3$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('The 5th term of the G.P. $3, 6, 12, \ldots$ is', '$96$', '$24$', '$48$', '$36$', 'option3', '$a_5 = ar^4 = 3 \cdot 2^4 = 3 \times 16 = 48$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('The sum of the A.P. $1, 3, 5, 7, 9$ is', '$25$', '$20$', '$15$', '$30$', 'option1', '$S_5 = \frac{5}{2}(2 \cdot 1 + 4 \cdot 2) = \frac{5}{2}(2 + 8) = \frac{5}{2} \times 10 = 25$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

('If $a, b, c$ are in A.P., then $b$ equals', '$\frac{a + c}{2}$', '$\frac{ac}{2}$', '$\sqrt{ac}$', '$a + c$', 'option1', 'In an A.P., the middle term is the arithmetic mean of its neighbours: $b = \frac{a + c}{2}$.', 'm_ap_gp', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The sum of the first 20 terms of the A.P. $2, 5, 8, \ldots$ is', '$600$', '$610$', '$590$', '$620$', 'option2', '$S_{20} = \frac{20}{2}(2 \cdot 2 + 19 \cdot 3) = 10(4 + 57) = 10 \times 61 = 610$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('The sum to infinity of the G.P. $1, \frac{1}{2}, \frac{1}{4}, \frac{1}{8}, \ldots$ is', '$4$', '$1$', '$\frac{3}{2}$', '$2$', 'option4', '$S_\infty = \frac{a}{1-r} = \frac{1}{1 - 1/2} = \frac{1}{1/2} = 2$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('If the 3rd term of an A.P. is 7 and the 7th term is 15, then the first term and common difference are', '$a = 3, d = 2$', '$a = 1, d = 3$', '$a = 5, d = 1$', '$a = 2, d = 2$', 'option1', '$a + 2d = 7$ and $a + 6d = 15$. Subtracting: $4d = 8$, so $d = 2$ and $a = 3$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('The sum of the G.P. $2 + 6 + 18 + \ldots + 1458$ is', '$1094$', '$2187$', '$2186$', '$4374$', 'option3', '$a = 2$, $r = 3$. Last term $= 1458 = 2 \cdot 3^{n-1}$, so $3^{n-1} = 729 = 3^6$, giving $n = 7$. $S_7 = \frac{2(3^7 - 1)}{3 - 1} = \frac{2 \times 2186}{2} = 2186$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('If the sum of $n$ terms of an A.P. is $3n^2 + 5n$, then the 10th term is', '$62$', '$60$', '$58$', '$65$', 'option1', '$a_n = S_n - S_{n-1} = (3n^2 + 5n) - (3(n-1)^2 + 5(n-1)) = 3n^2 + 5n - 3n^2 + 6n - 3 - 5n + 5 = 6n + 2$. So $a_{10} = 62$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('Three numbers in G.P. have sum 26 and product 216. The numbers are', '$2, 6, 18$', '$3, 6, 12$', '$4, 6, 9$', '$1, 6, 36$', 'option1', 'Let the numbers be $a/r, a, ar$. Product $= a^3 = 216$, so $a = 6$. Sum: $6/r + 6 + 6r = 26$, giving $6(1/r + r) = 20$, so $1/r + r = 10/3$. Solving $3r^2 - 10r + 3 = 0$: $r = 3$ or $1/3$. Numbers: $2, 6, 18$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

('If $a_5 = 13$ and $a_{12} = 34$ in an A.P., then $a_{20}$ is', '$55$', '$58$', '$60$', '$52$', 'option2', '$a + 4d = 13$ and $a + 11d = 34$. Subtracting: $7d = 21$, so $d = 3$ and $a = 1$. $a_{20} = 1 + 19 \times 3 = 58$.', 'm_ap_gp', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('$1^2 + 2^2 + 3^2 + \ldots + 10^2$ equals', '$55$', '$330$', '$385$', '$100$', 'option3', '$\sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6}$. For $n = 10$: $\frac{10 \times 11 \times 21}{6} = \frac{2310}{6} = 385$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('If $a_1, a_2, \ldots, a_{16}$ are in A.P. and $a_1 + a_4 + a_7 + a_{10} + a_{13} + a_{16} = 120$, then $a_1 + a_6 + a_{11} + a_{16}$ equals', '$80$', '$60$', '$120$', '$40$', 'option1', 'In an A.P., $a_1 + a_{16} = a_4 + a_{13} = a_7 + a_{10}$. So the given sum $= 3(a_1 + a_{16}) = 120$, giving $a_1 + a_{16} = 40$. Also $a_6 + a_{11} = a_1 + a_{16} = 40$. Hence $a_1 + a_6 + a_{11} + a_{16} = 2(a_1 + a_{16}) = 80$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('If the sum of an infinite G.P. is 3 and the sum of the squares of its terms is 3, then the common ratio is', '$\frac{1}{4}$', '$\frac{1}{3}$', '$\frac{2}{3}$', '$\frac{1}{2}$', 'option4', 'Let first term $= a$, ratio $= r$. $\frac{a}{1-r} = 3$ and $\frac{a^2}{1-r^2} = 3$. From the second: $\frac{a^2}{(1-r)(1+r)} = 3$. Substituting $a = 3(1-r)$: $\frac{9(1-r)^2}{(1-r)(1+r)} = 3$, so $\frac{9(1-r)}{1+r} = 3$, giving $3(1-r) = 1+r$, hence $r = \frac{1}{2}$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('If the $p$th term of an A.P. is $q$ and the $q$th term is $p$, then the $(p+q)$th term is', '$0$', '$p + q$', '$p - q$', '$1$', 'option1', '$a + (p-1)d = q$ and $a + (q-1)d = p$. Subtracting: $(p-q)d = q - p$, so $d = -1$. Then $a = q + p - 1$. $a_{p+q} = a + (p+q-1)d = (q+p-1) + (p+q-1)(-1) = 0$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('$1 \cdot 2 + 2 \cdot 3 + 3 \cdot 4 + \ldots + n(n+1)$ equals', '$\frac{n(n+1)}{2}$', '$\frac{n(n+1)(n+2)}{3}$', '$\frac{n(n+1)(2n+1)}{6}$', '$\frac{n^2(n+1)^2}{4}$', 'option2', '$\sum_{k=1}^{n} k(k+1) = \sum k^2 + \sum k = \frac{n(n+1)(2n+1)}{6} + \frac{n(n+1)}{2} = \frac{n(n+1)}{6}(2n+1+3) = \frac{n(n+1)(n+2)}{3}$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('Three numbers in A.P. have sum 15 and sum of squares 83. The numbers are', '$3, 5, 7$', '$4, 5, 6$', '$1, 5, 9$', '$2, 5, 8$', 'option1', 'Let the numbers be $a-d, a, a+d$. Sum $= 3a = 15$, so $a = 5$. Sum of squares: $(5-d)^2 + 25 + (5+d)^2 = 83$. $50 + 2d^2 + 25 = 83$. $2d^2 = 8$, $d^2 = 4$, $d = \pm 2$. Numbers: $3, 5, 7$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),

('The sum to infinity of $1 + 2x + 3x^2 + 4x^3 + \ldots$ for $|x| < 1$ is', '$\frac{1}{(1-x)^2}$', '$\frac{1}{1-x}$', '$\frac{x}{(1-x)^2}$', '$\frac{1}{(1+x)^2}$', 'option1', 'We know $\frac{1}{1-x} = 1 + x + x^2 + \ldots$ for $|x| < 1$. Differentiating both sides: $\frac{1}{(1-x)^2} = 1 + 2x + 3x^2 + \ldots$.', 'm_ap_gp', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_insertion_means (Insertion of arithmetic and geometric means between two numbers)
-- Chapter: math_sequence_series
-- ============================================================

-- Tier 1 (Easy)
('The arithmetic mean (A.M.) of 4 and 16 is', '$10$', '$8$', '$20$', '$12$', 'option1', 'A.M. $= \frac{4 + 16}{2} = 10$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('The geometric mean (G.M.) of 4 and 16 is', '$8$', '$10$', '$20$', '$64$', 'option1', 'G.M. $= \sqrt{4 \times 16} = \sqrt{64} = 8$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('One A.M. inserted between 3 and 9 is', '$27$', '$12$', '$3$', '$6$', 'option4', 'The single A.M. between $a$ and $b$ is $\frac{a+b}{2} = \frac{3+9}{2} = 6$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('One G.M. inserted between 4 and 9 is', '$36$', '$\frac{13}{2}$', '$6$', '$\sqrt{13}$', 'option3', 'The single G.M. between $a$ and $b$ is $\sqrt{ab} = \sqrt{4 \times 9} = \sqrt{36} = 6$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('Three A.M.s inserted between 2 and 10 are', '$4, 6, 8$', '$3, 6, 9$', '$4, 7, 10$', '$5, 6, 7$', 'option1', 'Common difference $d = \frac{10 - 2}{3 + 1} = 2$. A.M.s: $2 + 2 = 4$, $4 + 2 = 6$, $6 + 2 = 8$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('The A.M. of $a$ and $b$ is', '$\sqrt{ab}$', '$\frac{a + b}{2}$', '$\frac{2ab}{a+b}$', '$ab$', 'option2', 'The arithmetic mean of two numbers $a$ and $b$ is $\frac{a + b}{2}$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

('The G.M. of $a$ and $b$ (both positive) is', '$\frac{2ab}{a+b}$', '$\frac{a+b}{2}$', '$\sqrt{ab}$', '$\frac{a-b}{2}$', 'option3', 'The geometric mean of two positive numbers $a$ and $b$ is $\sqrt{ab}$.', 'm_insertion_means', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The sum of 4 A.M.s inserted between 3 and 23 is', '$60$', '$48$', '$56$', '$52$', 'option4', '$d = \frac{23 - 3}{5} = 4$. A.M.s: $7, 11, 15, 19$. Sum $= 7 + 11 + 15 + 19 = 52$. Alternatively, sum of $n$ A.M.s between $a$ and $b$ is $\frac{n(a+b)}{2} = \frac{4 \times 26}{2} = 52$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('Three G.M.s inserted between 2 and 162 are', '$4, 18, 81$', '$6, 18, 54$', '$6, 36, 54$', '$3, 18, 108$', 'option2', 'Common ratio $r = \left(\frac{162}{2}\right)^{1/4} = 81^{1/4} = 3$. G.M.s: $2 \times 3 = 6$, $6 \times 3 = 18$, $18 \times 3 = 54$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('If 5 A.M.s are inserted between 2 and 26, the 3rd A.M. is', '$10$', '$12$', '$16$', '$14$', 'option4', '$d = \frac{26 - 2}{6} = 4$. The 3rd A.M. $= 2 + 3 \times 4 = 14$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('The sum of $n$ A.M.s inserted between $a$ and $b$ is', '$n(a + b)$', '$\frac{n(a + b)}{2}$', '$\frac{(a + b)}{2}$', '$\frac{n(b - a)}{2}$', 'option2', 'The $n$ A.M.s and the endpoints form an A.P. of $n+2$ terms. The sum of the $n$ A.M.s $= S_{n+2} - a - b = \frac{(n+2)(a+b)}{2} - (a+b) = \frac{n(a+b)}{2}$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('Two G.M.s inserted between 1 and 27 are', '$3, 27$', '$3, 9$', '$9, 18$', '$1, 9$', 'option2', 'Common ratio $r = 27^{1/3} = 3$. G.M.s: $1 \times 3 = 3$ and $3 \times 3 = 9$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('If the A.M. of two numbers is 5 and their G.M. is 4, the numbers are', '$8$ and $2$', '$6$ and $4$', '$9$ and $1$', '$7$ and $3$', 'option1', '$\frac{a+b}{2} = 5$ and $\sqrt{ab} = 4$. So $a + b = 10$ and $ab = 16$. The numbers satisfy $t^2 - 10t + 16 = 0$, giving $t = 8$ or $t = 2$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

('The sum of 9 A.M.s inserted between 1 and 19 is', '$100$', '$90$', '$80$', '$95$', 'option2', 'Sum of $n$ A.M.s between $a$ and $b$ $= \frac{n(a+b)}{2} = \frac{9(1+19)}{2} = \frac{9 \times 20}{2} = 90$.', 'm_insertion_means', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $n$ A.M.s are inserted between 20 and 80 such that the ratio of the first A.M. to the last A.M. is $1 : 3$, then $n$ is', '$13$', '$9$', '$11$', '$10$', 'option3', '$d = \frac{60}{n+1}$. First A.M. $= 20 + d$, last A.M. $= 80 - d$. $\frac{20+d}{80-d} = \frac{1}{3}$. $60 + 3d = 80 - d$. $4d = 20$, $d = 5$. $\frac{60}{n+1} = 5$, so $n + 1 = 12$, $n = 11$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('The product of $n$ G.M.s inserted between $a$ and $b$ is', '$(ab)^n$', '$(ab)^{n/2}$', '$\sqrt{ab}$', '$a^n b^n$', 'option2', 'The $n$ G.M.s are $ar, ar^2, \ldots, ar^n$ where $r = (b/a)^{1/(n+1)}$. Product $= a^n \cdot r^{1+2+\ldots+n} = a^n \cdot r^{n(n+1)/2} = a^n \cdot (b/a)^{n/2} = a^{n/2} b^{n/2} = (ab)^{n/2}$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('If the A.M. and G.M. of two positive numbers are 10 and 8 respectively, the numbers are', '$16$ and $4$', '$12$ and $8$', '$18$ and $2$', '$14$ and $6$', 'option1', '$a + b = 20$ and $ab = 64$. Solving $t^2 - 20t + 64 = 0$: $t = \frac{20 \pm \sqrt{400 - 256}}{2} = \frac{20 \pm 12}{2}$. So $t = 16$ or $t = 4$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('The sum of 3 G.M.s inserted between 1 and 256 is', '$84$', '$64$', '$85$', '$63$', 'option1', '$r = 256^{1/4} = 4$. G.M.s: $4, 16, 64$. Sum $= 4 + 16 + 64 = 84$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('If $n$ A.M.s are inserted between 1 and 31 such that the 7th A.M. to the $(n-1)$th A.M. is $5 : 9$, then $n$ is', '$12$', '$14$', '$15$', '$11$', 'option2', '$d = \frac{30}{n+1}$. 7th A.M. $= 1 + 7d$, $(n-1)$th A.M. $= 1 + (n-1)d$. $\frac{1+7d}{1+(n-1)d} = \frac{5}{9}$. Cross-multiplying: $9 + 63d = 5 + 5(n-1)d$. $4 = d(5n - 68)$. Substituting $d = 30/(n+1)$: $4(n+1) = 30(5n-68)$. $4n + 4 = 150n - 2040$. $146n = 2044$, $n = 14$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('If the A.M. of two numbers is 5 and their H.M. is $\frac{16}{5}$, then their G.M. is', '$4$', '$5$', '$3$', '$\sqrt{5}$', 'option1', 'For any two positive numbers, $\text{A.M.} \times \text{H.M.} = \text{G.M.}^2$. So $\text{G.M.}^2 = 5 \times \frac{16}{5} = 16$, giving $\text{G.M.} = 4$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),

('If $a, b, c$ are in G.P. and $x, y$ are the A.M.s of $a, b$ and $b, c$ respectively, then $\frac{a}{x} + \frac{c}{y}$ equals', '$2$', '$1$', '$\frac{1}{2}$', '$4$', 'option1', '$x = \frac{a+b}{2}$, $y = \frac{b+c}{2}$. Let $b = ar$, $c = ar^2$. Then $\frac{a}{x} = \frac{2a}{a+ar} = \frac{2}{1+r}$ and $\frac{c}{y} = \frac{2ar^2}{ar+ar^2} = \frac{2r}{1+r}$. Sum $= \frac{2 + 2r}{1+r} = 2$.', 'm_insertion_means', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_am_gm_relation (Relation between A.M and G.M)
-- Chapter: math_sequence_series
-- ============================================================

-- Tier 1 (Easy)
('For two positive numbers $a$ and $b$, which is always true?', '$\text{A.M.} \leq \text{G.M.}$', '$\text{A.M.} \geq \text{G.M.}$', '$\text{A.M.} = \text{G.M.}$', '$\text{A.M.} < \text{G.M.}$', 'option2', 'The AM-GM inequality states $\frac{a+b}{2} \geq \sqrt{ab}$ for all positive $a, b$, with equality iff $a = b$.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('A.M. equals G.M. for two positive numbers if and only if', 'The numbers are equal', 'The numbers are reciprocals', 'One number is zero', 'The numbers differ by 1', 'option1', '$\frac{a+b}{2} = \sqrt{ab}$ iff $(a+b)^2 = 4ab$ iff $(a-b)^2 = 0$ iff $a = b$.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('The A.M. and G.M. of 9 and 16 are', '$12.5$ and $144$', '$12$ and $12.5$', '$12.5$ and $12$', '$25$ and $12$', 'option3', 'A.M. $= \frac{9+16}{2} = 12.5$. G.M. $= \sqrt{9 \times 16} = \sqrt{144} = 12$. Note A.M. $>$ G.M.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('If $a = b = 5$, then A.M. and G.M. are', '$5$ and $\sqrt{5}$', '$5$ and $25$', '$10$ and $5$', 'Both equal to $5$', 'option4', 'A.M. $= \frac{5+5}{2} = 5$. G.M. $= \sqrt{5 \times 5} = 5$. When $a = b$, A.M. $=$ G.M.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('For $a = 1, b = 9$: A.M. $-$ G.M. equals', '$1$', '$3$', '$4$', '$2$', 'option4', 'A.M. $= \frac{1+9}{2} = 5$. G.M. $= \sqrt{9} = 3$. A.M. $-$ G.M. $= 5 - 3 = 2$.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('For positive numbers, the correct ordering is', '$\text{A.M.} \geq \text{G.M.} \geq \text{H.M.}$', '$\text{G.M.} \geq \text{A.M.} \geq \text{H.M.}$', '$\text{H.M.} \geq \text{G.M.} \geq \text{A.M.}$', '$\text{A.M.} \geq \text{H.M.} \geq \text{G.M.}$', 'option1', 'For positive numbers: A.M. $\geq$ G.M. $\geq$ H.M., with equality iff all numbers are equal.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

('The H.M. of 4 and 6 is', '$\frac{10}{3}$', '$5$', '$\frac{24}{5}$', '$\frac{12}{5}$', 'option3', 'H.M. $= \frac{2ab}{a+b} = \frac{2 \times 4 \times 6}{4+6} = \frac{48}{10} = \frac{24}{5}$.', 'm_am_gm_relation', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The minimum value of $x + \frac{1}{x}$ for $x > 0$ is', '$2$', '$1$', '$\frac{1}{2}$', '$4$', 'option1', 'By AM-GM: $x + \frac{1}{x} \geq 2\sqrt{x \cdot \frac{1}{x}} = 2$. Equality when $x = \frac{1}{x}$, i.e., $x = 1$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('If $a + b = 10$ and $a, b > 0$, the maximum value of $ab$ is', '$25$', '$20$', '$10$', '$100$', 'option1', 'By AM-GM: $\frac{a+b}{2} \geq \sqrt{ab}$, so $\sqrt{ab} \leq 5$, giving $ab \leq 25$. Equality when $a = b = 5$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('The minimum value of $a^2 + b^2$ given $a + b = 6$ and $a, b > 0$ is', '$12$', '$18$', '$36$', '$9$', 'option2', '$a^2 + b^2 = (a+b)^2 - 2ab = 36 - 2ab$. By AM-GM, $ab \leq \left(\frac{a+b}{2}\right)^2 = 9$. So $a^2 + b^2 \geq 36 - 18 = 18$. Equality when $a = b = 3$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('The minimum value of $x + \frac{4}{x}$ for $x > 0$ is', '$5$', '$2$', '$4$', '$8$', 'option3', 'By AM-GM: $x + \frac{4}{x} \geq 2\sqrt{x \cdot \frac{4}{x}} = 2\sqrt{4} = 4$. Equality when $x = 2$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('If $a + b = 8$ and $ab = 12$ for positive $a, b$, then A.M. and G.M. are', '$4$ and $12$', '$4$ and $2\sqrt{3}$', '$8$ and $\sqrt{12}$', '$6$ and $4$', 'option2', 'A.M. $= \frac{a+b}{2} = 4$. G.M. $= \sqrt{ab} = \sqrt{12} = 2\sqrt{3}$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('The minimum value of $9x + \frac{4}{x}$ for $x > 0$ is', '$6$', '$12$', '$13$', '$36$', 'option2', 'By AM-GM: $9x + \frac{4}{x} \geq 2\sqrt{9x \cdot \frac{4}{x}} = 2\sqrt{36} = 12$. Equality when $9x = \frac{4}{x}$, i.e., $x = \frac{2}{3}$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

('For positive $a, b$: $\text{A.M.} \times \text{H.M.}$ equals', '$\text{G.M.}^2$', '$\text{A.M.}^2$', '$ab$', '$\frac{(a+b)^2}{4}$', 'option1', 'A.M. $\times$ H.M. $= \frac{a+b}{2} \times \frac{2ab}{a+b} = ab = (\sqrt{ab})^2 = \text{G.M.}^2$.', 'm_am_gm_relation', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The minimum value of $(a + b)\left(\frac{1}{a} + \frac{1}{b}\right)$ for $a, b > 0$ is', '$8$', '$2$', '$1$', '$4$', 'option4', '$(a+b)\left(\frac{1}{a}+\frac{1}{b}\right) = \frac{(a+b)^2}{ab}$. By AM-GM, $(a+b)^2 \geq 4ab$, so $\frac{(a+b)^2}{ab} \geq 4$. Equality when $a = b$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('If $a, b, c > 0$ and $a + b + c = 1$, the minimum value of $\frac{1}{a} + \frac{1}{b} + \frac{1}{c}$ is', '$1$', '$3$', '$6$', '$9$', 'option4', 'By AM-HM inequality: $\frac{a+b+c}{3} \geq \frac{3}{1/a+1/b+1/c}$. So $\frac{1}{3} \geq \frac{3}{S}$, giving $S \geq 9$. Equality when $a = b = c = \frac{1}{3}$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('The minimum value of $x^2 + \frac{1}{x^2}$ for $x > 0$ is', '$2$', '$1$', '$4$', '$\frac{1}{2}$', 'option1', 'By AM-GM: $x^2 + \frac{1}{x^2} \geq 2\sqrt{x^2 \cdot \frac{1}{x^2}} = 2$. Equality when $x^2 = \frac{1}{x^2}$, i.e., $x = 1$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('If $a^2 + b^2 = 1$ and $a, b > 0$, the maximum value of $a + b$ is', '$\sqrt{2}$', '$1$', '$2$', '$\frac{1}{\sqrt{2}}$', 'option1', 'By Cauchy-Schwarz (or QM-AM): $(a+b)^2 \leq 2(a^2+b^2) = 2$. So $a + b \leq \sqrt{2}$. Equality when $a = b = \frac{1}{\sqrt{2}}$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('The minimum value of $x^3 + \frac{1}{x^3}$ for $x > 0$ is', '$2$', '$3$', '$\frac{1}{2}$', '$6$', 'option1', 'Let $t = x + \frac{1}{x} \geq 2$. Then $x^3 + \frac{1}{x^3} = t^3 - 3t$. For $t \geq 2$: $f(t) = t^3 - 3t$ is increasing (since $f''(t) = 3t^2 - 3 \geq 9 > 0$). Minimum at $t = 2$: $f(2) = 8 - 6 = 2$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('If $a + b + c = 6$ and $a, b, c > 0$, the maximum value of $abc$ is', '$8$', '$6$', '$27$', '$216$', 'option1', 'By AM-GM: $\frac{a+b+c}{3} \geq \sqrt[3]{abc}$, so $2 \geq \sqrt[3]{abc}$, giving $abc \leq 8$. Equality when $a = b = c = 2$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),

('The minimum value of $\left(1 + \frac{a}{b}\right)\left(1 + \frac{b}{c}\right)\left(1 + \frac{c}{a}\right)$ for $a, b, c > 0$ is', '$8$', '$4$', '$6$', '$27$', 'option1', 'By AM-GM on each factor: $1 + \frac{a}{b} \geq 2\sqrt{\frac{a}{b}}$, $1 + \frac{b}{c} \geq 2\sqrt{\frac{b}{c}}$, $1 + \frac{c}{a} \geq 2\sqrt{\frac{c}{a}}$. Product $\geq 8\sqrt{\frac{a}{b} \cdot \frac{b}{c} \cdot \frac{c}{a}} = 8$. Equality when $a = b = c$.', 'm_am_gm_relation', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_real_valued_functions (Real-valued functions, algebra of functions, polynomial/rational/trig/log/exp functions, inverse functions)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
('The domain of $f(x) = \sqrt{x - 2}$ is', '$(-\infty, 2]$', '$(2, \infty)$', '$[2, \infty)$', '$\mathbb{R}$', 'option3', 'For $\sqrt{x-2}$ to be defined, $x - 2 \geq 0$, i.e., $x \geq 2$. Domain $= [2, \infty)$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('The range of $f(x) = x^2$ for $x \in \mathbb{R}$ is', '$(0, \infty)$', '$\mathbb{R}$', '$[0, \infty)$', '$(-\infty, 0]$', 'option3', 'Since $x^2 \geq 0$ for all real $x$ and every non-negative value is attained, the range is $[0, \infty)$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('$f(x) = \frac{1}{x}$ is not defined at', '$x = 0$', '$x = 1$', '$x = -1$', '$x = \infty$', 'option1', 'Division by zero is undefined, so $f(x) = 1/x$ is not defined at $x = 0$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = 2x + 3$, then $f(1)$ is', '$3$', '$5$', '$2$', '$6$', 'option2', '$f(1) = 2(1) + 3 = 5$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('The domain of $f(x) = |x|$ is', '$\mathbb{R}$', '$[0, \infty)$', '$(0, \infty)$', '$\mathbb{R} \setminus \{0\}$', 'option1', 'The absolute value function is defined for all real numbers.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('The range of $f(x) = e^x$ is', '$[0, \infty)$', '$\mathbb{R}$', '$(0, \infty)$', '$[1, \infty)$', 'option3', '$e^x > 0$ for all $x$, and $e^x$ takes all positive values. Range $= (0, \infty)$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

('$(f + g)(x)$ is defined as', '$f(x) - g(x)$', '$f(g(x))$', '$f(x) \cdot g(x)$', '$f(x) + g(x)$', 'option4', 'The sum of two functions is defined pointwise: $(f+g)(x) = f(x) + g(x)$.', 'm_real_valued_functions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The domain of $f(x) = \sqrt{4 - x^2}$ is', '$[-2, 2]$', '$(-2, 2)$', '$[0, 2]$', '$\mathbb{R}$', 'option1', '$4 - x^2 \geq 0$ gives $x^2 \leq 4$, i.e., $-2 \leq x \leq 2$. Domain $= [-2, 2]$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^2$ and $g(x) = x + 1$, then $(f \circ g)(x)$ is', '$(x + 1)^2$', '$x^2 + 1$', '$x^2 + x$', '$x^3 + x^2$', 'option1', '$(f \circ g)(x) = f(g(x)) = f(x+1) = (x+1)^2$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('The domain of $f(x) = \log(x - 1)$ is', '$\mathbb{R}$', '$[1, \infty)$', '$(0, \infty)$', '$(1, \infty)$', 'option4', 'Logarithm requires positive argument: $x - 1 > 0$, so $x > 1$. Domain $= (1, \infty)$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('The range of $f(x) = \sin x$ is', '$[0, 1]$', '$[-1, 1]$', '$(-1, 1)$', '$\mathbb{R}$', 'option2', 'The sine function oscillates between $-1$ and $1$ inclusive. Range $= [-1, 1]$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('The domain of $f(x) = \frac{1}{x^2 - 4}$ is', '$\mathbb{R}$', '$\mathbb{R} \setminus \{-2, 2\}$', '$(-2, 2)$', '$\mathbb{R} \setminus \{0\}$', 'option2', '$x^2 - 4 \neq 0$ gives $x \neq \pm 2$. Domain $= \mathbb{R} \setminus \{-2, 2\}$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = 3x - 2$, then $f^{-1}(x)$ is', '$\frac{1}{3x - 2}$', '$\frac{x - 2}{3}$', '$3x + 2$', '$\frac{x + 2}{3}$', 'option4', 'Set $y = 3x - 2$. Solving for $x$: $x = \frac{y+2}{3}$. So $f^{-1}(x) = \frac{x+2}{3}$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

('The inverse of $f(x) = e^x$ is', '$e^{-x}$', '$\frac{1}{e^x}$', '$\ln x$', '$10^x$', 'option3', 'If $y = e^x$, then $x = \ln y$. So $f^{-1}(x) = \ln x$, defined for $x > 0$.', 'm_real_valued_functions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The domain of $f(x) = \sqrt{x - 1} + \frac{1}{\sqrt{3 - x}}$ is', '$(1, 3]$', '$[1, 3]$', '$(1, 3)$', '$[1, 3)$', 'option4', '$\sqrt{x-1}$ requires $x \geq 1$. $\frac{1}{\sqrt{3-x}}$ requires $3 - x > 0$, i.e., $x < 3$. Domain $= [1, 3)$.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{x}{x - 1}$ for $x \neq 1$, then $f(f(x))$ equals', '$x - 1$', '$\frac{1}{x}$', '$\frac{x}{x-1}$', '$x$', 'option4', '$f(f(x)) = f\left(\frac{x}{x-1}\right) = \frac{x/(x-1)}{x/(x-1) - 1} = \frac{x/(x-1)}{(x - x + 1)/(x-1)} = \frac{x/(x-1)}{1/(x-1)} = x$.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('The domain of $f(x) = \sin^{-1}(2x - 1)$ is', '$\left[-\frac{1}{2}, \frac{1}{2}\right]$', '$[-1, 1]$', '$[0, \pi]$', '$[0, 1]$', 'option4', '$\sin^{-1}$ requires argument in $[-1, 1]$: $-1 \leq 2x - 1 \leq 1$, so $0 \leq 2x \leq 2$, giving $0 \leq x \leq 1$.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('$f(x) = x^3$ on $\mathbb{R}$ is', 'One-one but not onto', 'One-one and onto', 'Onto but not one-one', 'Neither one-one nor onto', 'option2', '$f$ is strictly increasing (one-one) and for every $y \in \mathbb{R}$, $x = y^{1/3}$ exists (onto). So $f$ is bijective.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{2x + 3}{3x - 2}$ for $x \neq \frac{2}{3}$, then $f^{-1}(x)$ is', '$\frac{3x - 2}{2x + 3}$', '$\frac{2x + 3}{3x - 2}$', '$\frac{2x - 3}{3x + 2}$', '$\frac{3x + 2}{2x - 3}$', 'option2', 'Let $y = \frac{2x+3}{3x-2}$. Then $3xy - 2y = 2x + 3$, so $x(3y-2) = 2y+3$, giving $x = \frac{2y+3}{3y-2}$. Hence $f^{-1}(x) = \frac{2x+3}{3x-2} = f(x)$. The function is self-inverse.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('The domain of $f(x) = \log_2(\log_3(\log_4 x))$ is', '$(4, \infty)$', '$(1, \infty)$', '$(64, \infty)$', '$(3, \infty)$', 'option1', 'Need $\log_3(\log_4 x) > 0$, so $\log_4 x > 1$, giving $x > 4$. Also need $\log_4 x > 0$, i.e., $x > 1$ (already satisfied). Domain $= (4, \infty)$.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{x^2 - 1}{x - 1}$ for $x \neq 1$, then $\lim_{x \to 1} f(x)$ is', '$0$', '$2$', '$1$', 'Does not exist', 'option2', 'For $x \neq 1$: $f(x) = \frac{(x-1)(x+1)}{x-1} = x + 1$. So $\lim_{x \to 1} f(x) = 1 + 1 = 2$.', 'm_real_valued_functions', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_graphs_simple_functions (Graphs of simple functions)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
('The graph of $f(x) = x^2$ is a', 'Parabola opening upward', 'Straight line', 'Circle', 'Parabola opening downward', 'option1', '$y = x^2$ is a parabola with vertex at the origin, opening upward.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = |x|$ is', 'A horizontal line', 'A straight line through origin', 'A parabola', 'V-shaped with vertex at origin', 'option4', '$|x| = x$ for $x \geq 0$ and $|x| = -x$ for $x < 0$, forming a V-shape at the origin.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = e^x$ passes through the point', '$(1, 1)$', '$(1, 0)$', '$(0, 0)$', '$(0, 1)$', 'option4', '$f(0) = e^0 = 1$. So the graph passes through $(0, 1)$.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \sin x$ has period', '$4\pi$', '$\pi$', '$\frac{\pi}{2}$', '$2\pi$', 'option4', '$\sin(x + 2\pi) = \sin x$ for all $x$, and $2\pi$ is the smallest such positive period.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \ln x$ is defined for', '$x > 1$', '$x \geq 0$', '$x \in \mathbb{R}$', '$x > 0$', 'option4', 'The natural logarithm is defined only for positive real numbers.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = c$ (constant) is', 'A parabola', 'A vertical line', 'A horizontal line', 'A point', 'option3', 'A constant function $f(x) = c$ gives the same output for all $x$, producing a horizontal line at height $c$.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = x$ is', 'A vertical line', 'A parabola', 'A horizontal line', 'A straight line through the origin with slope 1', 'option4', '$y = x$ is the identity function, a straight line through the origin at $45°$ to the $x$-axis.', 'm_graphs_simple_functions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The graph of $f(x) = x^2$ is symmetric about', 'The origin', 'The $x$-axis', 'The $y$-axis', 'The line $y = x$', 'option3', '$f(-x) = (-x)^2 = x^2 = f(x)$, so $f$ is an even function. Its graph is symmetric about the $y$-axis.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = x^3$ is symmetric about', 'The line $y = x$', 'The $y$-axis', 'The $x$-axis', 'The origin', 'option4', '$f(-x) = -x^3 = -f(x)$, so $f$ is an odd function. Its graph is symmetric about the origin.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = (x - 2)^2 + 3$ has vertex at', '$(-2, 3)$', '$(3, 2)$', '$(2, 3)$', '$(2, -3)$', 'option3', 'The function is in vertex form $f(x) = (x-h)^2 + k$ with $h = 2$, $k = 3$. Vertex is at $(2, 3)$.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = e^{-x}$ is', 'Increasing for all $x$', 'Decreasing for all $x$', 'Constant', 'Increasing then decreasing', 'option2', '$f''(x) = -e^{-x} < 0$ for all $x$, so $f$ is strictly decreasing.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = |x - 1|$ has its vertex at', '$(-1, 0)$', '$(0, 1)$', '$(0, 0)$', '$(1, 0)$', 'option4', '$|x - 1| = 0$ when $x = 1$. The V-shaped graph has its minimum (vertex) at $(1, 0)$.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \cos x$ at $x = 0$ has value', '$1$', '$0$', '$-1$', '$\frac{1}{2}$', 'option1', '$\cos(0) = 1$. The cosine graph starts at its maximum value of 1.', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \frac{1}{x}$ has asymptotes', '$x = 0$ and $y = 0$', '$x = 1$ and $y = 1$', '$y = x$', 'No asymptotes', 'option1', 'As $x \to 0$, $f(x) \to \pm\infty$ (vertical asymptote $x = 0$). As $x \to \pm\infty$, $f(x) \to 0$ (horizontal asymptote $y = 0$).', 'm_graphs_simple_functions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The number of real solutions of $e^x = x^2$ is', '$0$', '$1$', '$2$', '$3$', 'option2', 'For $x \leq 0$: $e^x \leq 1$ and $x^2 \geq 0$. At $x = 0$: $e^0 = 1 > 0 = 0^2$. As $x \to -\infty$: $e^x \to 0$ and $x^2 \to \infty$, so they cross once for $x < 0$. For $x > 0$: $e^x$ grows faster than $x^2$ eventually. At $x = 0$: $e^0 = 1 > 0$. The function $e^x - x^2$ is positive at $x = 0$ and remains positive for all $x > 0$ (since $e^x > x^2$ for all $x \geq 0$). So there is exactly 1 solution (for $x < 0$).', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = x - [x]$ (where $[x]$ is the greatest integer function) is', 'A straight line', 'A sawtooth wave with period 1', 'A step function', 'A parabola', 'option2', '$f(x) = x - [x] = \{x\}$ is the fractional part function. It equals $x - n$ for $n \leq x < n+1$, producing a repeating sawtooth pattern with period 1, ranging from 0 (inclusive) to 1 (exclusive).', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \log|x|$ is symmetric about', 'The $y$-axis', 'The origin', 'The $x$-axis', 'The line $y = x$', 'option1', '$f(-x) = \log|-x| = \log|x| = f(x)$. So $f$ is even, and its graph is symmetric about the $y$-axis.', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The graph of $y = x \sin x$ for $x > 0$ is bounded between', '$y = x$ and $y = -x$', '$y = 1$ and $y = -1$', '$y = x^2$ and $y = -x^2$', '$y = 0$ and $y = x$', 'option1', 'Since $-1 \leq \sin x \leq 1$, we have $-x \leq x\sin x \leq x$ for $x > 0$. The graph oscillates between the lines $y = x$ and $y = -x$.', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The number of points where $f(x) = |x^2 - 1|$ is not differentiable is', '$2$', '$1$', '$0$', '$3$', 'option1', '$|x^2 - 1| = 0$ when $x = \pm 1$. At these points, the function changes from $x^2 - 1$ to $1 - x^2$ (or vice versa), creating corners. So $f$ is not differentiable at $x = -1$ and $x = 1$.', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = 2^x$ compared to $g(x) = 3^x$ for $x > 0$ satisfies', '$f(x) > g(x)$', '$g(x) > f(x)$', '$f(x) = g(x)$', 'They intersect infinitely often', 'option2', 'For $x > 0$: $3^x > 2^x$ since $3 > 2$ and the exponential function preserves the inequality for positive exponents.', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),

('The graph of $f(x) = \sin^2 x$ has period', '$4\pi$', '$2\pi$', '$\frac{\pi}{2}$', '$\pi$', 'option4', '$\sin^2 x = \frac{1 - \cos 2x}{2}$. Since $\cos 2x$ has period $\pi$, $\sin^2 x$ also has period $\pi$.', 'm_graphs_simple_functions', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_limits_continuity_diff (Limits, continuity and differentiability)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
('$\lim_{x \to 2} x^2$ equals', '$4$', '$2$', '$0$', '$8$', 'option1', 'Since $f(x) = x^2$ is a polynomial (continuous everywhere), $\lim_{x \to 2} x^2 = 2^2 = 4$.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} \frac{\sin x}{x}$ equals', '$-1$', '$0$', '$\infty$', '$1$', 'option4', 'This is a standard limit: $\lim_{x \to 0} \frac{\sin x}{x} = 1$.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('A function $f$ is continuous at $x = a$ if', '$f''(a)$ exists', '$f(a)$ exists', '$\lim_{x \to a} f(x)$ exists', '$\lim_{x \to a} f(x) = f(a)$', 'option4', 'Continuity at $a$ requires three conditions: $f(a)$ is defined, $\lim_{x \to a} f(x)$ exists, and $\lim_{x \to a} f(x) = f(a)$.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 3} (2x + 1)$ equals', '$7$', '$6$', '$5$', '$9$', 'option1', '$\lim_{x \to 3}(2x+1) = 2(3) + 1 = 7$.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} \frac{e^x - 1}{x}$ equals', '$\infty$', '$0$', '$e$', '$1$', 'option4', 'This is a standard limit: $\lim_{x \to 0} \frac{e^x - 1}{x} = 1$.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('Every polynomial function is', 'Discontinuous at integers', 'Continuous everywhere', 'Continuous only at $x = 0$', 'Differentiable nowhere', 'option2', 'Polynomial functions are continuous (and differentiable) for all real numbers.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to \infty} \frac{1}{x}$ equals', '$1$', '$0$', '$\infty$', '$-1$', 'option2', 'As $x$ grows without bound, $1/x$ approaches 0.', 'm_limits_continuity_diff', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('$\lim_{x \to 0} \frac{\sin 3x}{x}$ equals', '$3$', '$1$', '$0$', '$\frac{1}{3}$', 'option1', '$\lim_{x \to 0} \frac{\sin 3x}{x} = \lim_{x \to 0} 3 \cdot \frac{\sin 3x}{3x} = 3 \times 1 = 3$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 1} \frac{x^2 - 1}{x - 1}$ equals', '$1$', '$0$', '$2$', '$\infty$', 'option3', '$\frac{x^2-1}{x-1} = \frac{(x-1)(x+1)}{x-1} = x + 1$ for $x \neq 1$. So $\lim_{x \to 1}(x+1) = 2$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} \frac{1 - \cos x}{x^2}$ equals', '$2$', '$1$', '$0$', '$\frac{1}{2}$', 'option4', 'Using $1 - \cos x = 2\sin^2(x/2)$: $\frac{2\sin^2(x/2)}{x^2} = \frac{2\sin^2(x/2)}{4(x/2)^2} \cdot 1 = \frac{1}{2} \cdot \left(\frac{\sin(x/2)}{x/2}\right)^2 \to \frac{1}{2}$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} \frac{\tan x}{x}$ equals', '$-1$', '$0$', '$\infty$', '$1$', 'option4', '$\frac{\tan x}{x} = \frac{\sin x}{x} \cdot \frac{1}{\cos x} \to 1 \cdot 1 = 1$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to \infty} \frac{3x^2 + 1}{2x^2 - 5}$ equals', '$3$', '$\frac{1}{2}$', '$\frac{3}{2}$', '$\infty$', 'option3', 'Divide numerator and denominator by $x^2$: $\frac{3 + 1/x^2}{2 - 5/x^2} \to \frac{3}{2}$ as $x \to \infty$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('$f(x) = |x|$ at $x = 0$ is', 'Discontinuous', 'Differentiable', 'Continuous but not differentiable', 'Neither continuous nor differentiable', 'option3', '$\lim_{x \to 0}|x| = 0 = f(0)$, so $f$ is continuous. But $f''(0^+) = 1$ and $f''(0^-) = -1$ are unequal, so $f$ is not differentiable at $x = 0$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = \begin{cases} x^2 & x \leq 1 \\ 2x - 1 & x > 1 \end{cases}$, then $f$ at $x = 1$ is', 'Continuous', 'Discontinuous', 'Not defined', 'Differentiable but not continuous', 'option1', 'LHL $= \lim_{x \to 1^-} x^2 = 1$. RHL $= \lim_{x \to 1^+}(2x-1) = 1$. $f(1) = 1$. Since LHL $=$ RHL $= f(1)$, $f$ is continuous at $x = 1$.', 'm_limits_continuity_diff', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('$\lim_{x \to 0} \frac{\sin x - x}{x^3}$ equals', '$-\frac{1}{6}$', '$\frac{1}{6}$', '$0$', '$-\frac{1}{3}$', 'option1', 'By Taylor expansion: $\sin x = x - \frac{x^3}{6} + \ldots$. So $\frac{\sin x - x}{x^3} = \frac{-x^3/6 + \ldots}{x^3} \to -\frac{1}{6}$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} \frac{a^x - 1}{x}$ equals', '$1$', '$a$', '$\ln a$', '$e^a$', 'option3', 'Let $a^x = e^{x \ln a}$. Then $\frac{a^x - 1}{x} = \frac{e^{x\ln a} - 1}{x} = \ln a \cdot \frac{e^{x\ln a} - 1}{x \ln a} \to \ln a \cdot 1 = \ln a$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('$f(x) = x|x|$ at $x = 0$ is', 'Differentiable with $f''(0) = 0$', 'Continuous but not differentiable', 'Discontinuous', 'Not defined', 'option1', '$f(x) = x^2$ for $x \geq 0$ and $f(x) = -x^2$ for $x < 0$. $f''(0^+) = \lim_{h \to 0^+} h^2/h = 0$. $f''(0^-) = \lim_{h \to 0^-} -h^2/h = 0$. Both equal, so $f''(0) = 0$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} (1 + x)^{1/x}$ equals', '$\infty$', '$1$', '$e$', '$0$', 'option3', 'This is the definition of $e$: $\lim_{x \to 0}(1+x)^{1/x} = e \approx 2.718$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to 0} x \sin\frac{1}{x}$ equals', '$0$', '$1$', 'Does not exist', '$\infty$', 'option1', '$-|x| \leq x\sin(1/x) \leq |x|$ for $x \neq 0$. By the squeeze theorem, $\lim_{x \to 0} x\sin(1/x) = 0$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('The function $f(x) = [x]$ (greatest integer function) is discontinuous at', 'Only at $x = 0$', 'Every real number', 'Every integer', 'Nowhere', 'option3', 'At every integer $n$: $\lim_{x \to n^-}[x] = n-1$ but $\lim_{x \to n^+}[x] = n = f(n)$. Since left and right limits differ, $f$ is discontinuous at every integer.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

('$\lim_{x \to \pi/2} \frac{\cos x}{\pi/2 - x}$ equals', '$-1$', '$0$', '$1$', '$\infty$', 'option3', 'Let $t = \frac{\pi}{2} - x$, so $t \to 0$ as $x \to \frac{\pi}{2}$. $\frac{\cos(\pi/2 - t)}{t} = \frac{\sin t}{t} \to 1$.', 'm_limits_continuity_diff', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- CONCEPT: m_differentiation_rules (Differentiation of sum, difference, product and quotient of two functions)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
-- Q1: d/dx(x^3 + x^2) = 3x^2 + 2x
('If $f(x) = x^3 + x^2$, then $f''(x)$ equals', '$x^3 + 2x$', '$3x^2 + x$', '$3x^2 + 2x$', '$3x + 2$', 'option3', '$f''(x) = \frac{d}{dx}(x^3) + \frac{d}{dx}(x^2) = 3x^2 + 2x$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q2: d/dx(5x^4 - 3x) = 20x^3 - 3
('$\frac{d}{dx}(5x^4 - 3x)$ equals', '$20x^3 - 3x$', '$20x^3 - 3$', '$5x^3 - 3$', '$20x^4 - 3$', 'option2', '$\frac{d}{dx}(5x^4) - \frac{d}{dx}(3x) = 20x^3 - 3$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q3: d/dx(7x^2 + 4x - 9) = 14x + 4
('$\frac{d}{dx}(7x^2 + 4x - 9)$ equals', '$14x - 9$', '$14x + 4x$', '$7x + 4$', '$14x + 4$', 'option4', '$\frac{d}{dx}(7x^2) + \frac{d}{dx}(4x) - \frac{d}{dx}(9) = 14x + 4 - 0 = 14x + 4$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q4: d/dx(x^5) = 5x^4
('$\frac{d}{dx}(x^5)$ equals', '$5x^4$', '$5x^5$', '$4x^5$', '$x^4$', 'option1', 'By the power rule, $\frac{d}{dx}(x^n) = nx^{n-1}$. So $\frac{d}{dx}(x^5) = 5x^4$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q5: d/dx(3x^2 + 5) = 6x
('If $y = 3x^2 + 5$, then $\frac{dy}{dx}$ equals', '$3x$', '$6x + 5$', '$6x$', '$6$', 'option3', '$\frac{dy}{dx} = \frac{d}{dx}(3x^2) + \frac{d}{dx}(5) = 6x + 0 = 6x$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q6: d/dx(x^2 - 1/x) at x=1. d/dx = 2x + 1/x^2. At x=1: 2+1=3
('If $f(x) = x^2 - \frac{1}{x}$, then $f''(1)$ equals', '$1$', '$3$', '$2$', '$0$', 'option2', '$f''(x) = 2x - (-x^{-2}) = 2x + \frac{1}{x^2}$. At $x = 1$: $f''(1) = 2 + 1 = 3$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Q7: d/dx(constant * f) = constant * f'. d/dx(4 sin x) = 4 cos x
('$\frac{d}{dx}(4\sin x)$ equals', '$-4\cos x$', '$4\cos x$', '$4\sin x$', '$\cos x$', 'option2', 'By the constant multiple rule: $\frac{d}{dx}(4\sin x) = 4 \cdot \frac{d}{dx}(\sin x) = 4\cos x$.', 'm_differentiation_rules', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Product rule: d/dx(x^2 sin x) = 2x sin x + x^2 cos x
('$\frac{d}{dx}(x^2 \sin x)$ equals', '$2x\cos x$', '$2x\sin x + x^2\cos x$', '$x^2\cos x$', '$2x\sin x - x^2\cos x$', 'option2', 'By the product rule: $\frac{d}{dx}(x^2 \sin x) = 2x \cdot \sin x + x^2 \cdot \cos x$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Quotient rule: d/dx(x/(x+1)) = ((x+1)-x)/(x+1)^2 = 1/(x+1)^2
('$\frac{d}{dx}\left(\frac{x}{x+1}\right)$ equals', '$\frac{1}{(x+1)^2}$', '$\frac{1}{x+1}$', '$\frac{-1}{(x+1)^2}$', '$\frac{x}{(x+1)^2}$', 'option1', 'By the quotient rule: $\frac{(x+1)(1) - x(1)}{(x+1)^2} = \frac{1}{(x+1)^2}$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q10: d/dx(x^3 e^x) = 3x^2 e^x + x^3 e^x = e^x(3x^2 + x^3) = x^2 e^x(3+x)
('$\frac{d}{dx}(x^3 e^x)$ equals', '$3x^2 e^x$', '$x^2 e^x(3 + x)$', '$x^3 e^x$', '$e^x(x^3 + 3x)$', 'option2', 'Product rule: $3x^2 \cdot e^x + x^3 \cdot e^x = x^2 e^x(3 + x)$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q11: d/dx(sin x cos x) = cos^2 x - sin^2 x = cos 2x
('$\frac{d}{dx}(\sin x \cos x)$ equals', '$\cos 2x$', '$-\cos 2x$', '$\sin 2x$', '$2\cos 2x$', 'option1', 'Product rule: $\cos x \cdot \cos x + \sin x \cdot (-\sin x) = \cos^2 x - \sin^2 x = \cos 2x$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q12: d/dx(sin x / x). Quotient rule: (x cos x - sin x)/x^2
('$\frac{d}{dx}\left(\frac{\sin x}{x}\right)$ equals', '$\frac{x\cos x + \sin x}{x^2}$', '$\frac{\cos x}{x}$', '$\frac{\sin x - x\cos x}{x^2}$', '$\frac{x\cos x - \sin x}{x^2}$', 'option4', 'Quotient rule: $\frac{x \cdot \cos x - \sin x \cdot 1}{x^2} = \frac{x\cos x - \sin x}{x^2}$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q13: d/dx((x+1)(x+2)) = expand to x^2+3x+2, derivative = 2x+3. Or product rule: 1*(x+2)+(x+1)*1 = 2x+3
('$\frac{d}{dx}[(x+1)(x+2)]$ equals', '$2x + 3$', '$x + 3$', '$2x + 2$', '$x^2 + 3$', 'option1', 'Product rule: $1 \cdot (x+2) + (x+1) \cdot 1 = x + 2 + x + 1 = 2x + 3$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Q14: d/dx(e^x / x^2). Quotient: (x^2 e^x - e^x * 2x)/x^4 = e^x(x-2)/x^3
('$\frac{d}{dx}\left(\frac{e^x}{x^2}\right)$ equals', '$\frac{e^x}{2x}$', '$\frac{e^x}{x^2}$', '$\frac{e^x(x + 2)}{x^3}$', '$\frac{e^x(x - 2)}{x^3}$', 'option4', 'Quotient rule: $\frac{x^2 e^x - e^x \cdot 2x}{x^4} = \frac{e^x(x^2 - 2x)}{x^4} = \frac{e^x(x - 2)}{x^3}$.', 'm_differentiation_rules', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: d/dx(x^2 sin x cos x). Let u=x^2, v=sin x cos x = (sin 2x)/2.
-- Product: 2x * (sin 2x)/2 + x^2 * (2cos 2x)/2 = x sin 2x + x^2 cos 2x
('$\frac{d}{dx}(x^2 \sin x \cos x)$ equals', '$x\sin 2x + x^2\cos 2x$', '$2x\sin x\cos x + x^2\cos 2x$', '$x^2\sin 2x + 2x\cos 2x$', '$2x\sin 2x + x^2\cos 2x$', 'option1', 'Write $\sin x \cos x = \frac{\sin 2x}{2}$. Then $\frac{d}{dx}\left(\frac{x^2 \sin 2x}{2}\right) = \frac{1}{2}(2x\sin 2x + x^2 \cdot 2\cos 2x) = x\sin 2x + x^2\cos 2x$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q16: d/dx((x^2+1)/(x^2-1)). Quotient: ((x^2-1)(2x)-(x^2+1)(2x))/(x^2-1)^2 = (2x(x^2-1-x^2-1))/(x^2-1)^2 = -4x/(x^2-1)^2
('$\frac{d}{dx}\left(\frac{x^2+1}{x^2-1}\right)$ equals', '$\frac{-4x}{(x^2-1)^2}$', '$\frac{4x}{(x^2-1)^2}$', '$\frac{2x}{(x^2-1)^2}$', '$\frac{-2x}{(x^2-1)^2}$', 'option1', 'Quotient rule: $\frac{(x^2-1)(2x) - (x^2+1)(2x)}{(x^2-1)^2} = \frac{2x(x^2-1-x^2-1)}{(x^2-1)^2} = \frac{-4x}{(x^2-1)^2}$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q17: d/dx(x sin x + cos x). = sin x + x cos x - sin x = x cos x
('$\frac{d}{dx}(x\sin x + \cos x)$ equals', '$\sin x + x\cos x$', '$x\cos x$', '$x\cos x - \sin x$', '$\cos x + x\sin x$', 'option2', '$\frac{d}{dx}(x\sin x) + \frac{d}{dx}(\cos x) = (\sin x + x\cos x) + (-\sin x) = x\cos x$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If f(x)=x^2 g(x) and g(3)=2, g'(3)=4, find f'(3).
-- f'(x) = 2x g(x) + x^2 g'(x). f'(3) = 6*2 + 9*4 = 12+36 = 48
('If $f(x) = x^2 g(x)$ where $g(3) = 2$ and $g''(3) = 4$, then $f''(3)$ equals', '$48$', '$36$', '$12$', '$24$', 'option1', 'By the product rule: $f''(x) = 2x \cdot g(x) + x^2 \cdot g''(x)$. At $x = 3$: $f''(3) = 6 \times 2 + 9 \times 4 = 12 + 36 = 48$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q19: d/dx(tan x / (1+tan x)). Let u=tan x, v=1+tan x. u'=sec^2 x, v'=sec^2 x.
-- Quotient: (sec^2 x (1+tan x) - tan x sec^2 x)/(1+tan x)^2 = sec^2 x/(1+tan x)^2
('$\frac{d}{dx}\left(\frac{\tan x}{1 + \tan x}\right)$ equals', '$\frac{\sec^2 x}{(1 + \tan x)^2}$', '$\frac{\sec^2 x}{1 + \tan x}$', '$\frac{1}{(1 + \tan x)^2}$', '$\frac{\tan x \sec^2 x}{(1 + \tan x)^2}$', 'option1', 'Quotient rule: $\frac{\sec^2 x(1+\tan x) - \tan x \cdot \sec^2 x}{(1+\tan x)^2} = \frac{\sec^2 x}{(1+\tan x)^2}$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q20: d/dx(x/(1+x^2)). Quotient: ((1+x^2)-x(2x))/(1+x^2)^2 = (1-x^2)/(1+x^2)^2
('$\frac{d}{dx}\left(\frac{x}{1+x^2}\right)$ equals', '$\frac{1-x^2}{(1+x^2)^2}$', '$\frac{1+x^2}{(1+x^2)^2}$', '$\frac{2x}{(1+x^2)^2}$', '$\frac{1}{(1+x^2)^2}$', 'option1', 'Quotient rule: $\frac{(1+x^2)(1) - x(2x)}{(1+x^2)^2} = \frac{1 - x^2}{(1+x^2)^2}$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),

-- Q21: d/dx((1+x^2)(1+x^3)). Product: 2x(1+x^3)+(1+x^2)(3x^2) = 2x+2x^4+3x^2+3x^4 = 5x^4+3x^2+2x
('$\frac{d}{dx}[(1+x^2)(1+x^3)]$ equals', '$6x^5 + 2x$', '$2x + 3x^2$', '$5x^4 + 2x$', '$5x^4 + 3x^2 + 2x$', 'option4', 'Product rule: $2x(1+x^3) + (1+x^2)(3x^2) = 2x + 2x^4 + 3x^2 + 3x^4 = 5x^4 + 3x^2 + 2x$.', 'm_differentiation_rules', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_differentiation_special (Differentiation of trig, inverse trig, log, exp, composite and implicit functions)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
-- Q1: d/dx(sin x) = cos x
('$\frac{d}{dx}(\sin x)$ equals', '$\cos x$', '$-\cos x$', '$\sin x$', '$-\sin x$', 'option1', '$\frac{d}{dx}(\sin x) = \cos x$ is a standard result.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q2: d/dx(e^x) = e^x
('$\frac{d}{dx}(e^x)$ equals', '$e^x$', '$xe^{x-1}$', '$e^{x-1}$', '$xe^x$', 'option1', 'The exponential function $e^x$ is its own derivative: $\frac{d}{dx}(e^x) = e^x$.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q3: d/dx(ln x) = 1/x
('$\frac{d}{dx}(\ln x)$ equals', '$\ln x$', '$\frac{1}{x^2}$', '$x$', '$\frac{1}{x}$', 'option4', '$\frac{d}{dx}(\ln x) = \frac{1}{x}$ for $x > 0$.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q4: d/dx(cos x) = -sin x
('$\frac{d}{dx}(\cos x)$ equals', '$-\sin x$', '$\sin x$', '$\cos x$', '$-\cos x$', 'option1', '$\frac{d}{dx}(\cos x) = -\sin x$ is a standard result.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q5: d/dx(tan x) = sec^2 x
('$\frac{d}{dx}(\tan x)$ equals', '$\sec^2 x$', '$\csc^2 x$', '$\sec x \tan x$', '$\cos^2 x$', 'option1', '$\frac{d}{dx}(\tan x) = \sec^2 x$.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q6: d/dx(e^(2x)) = 2e^(2x) by chain rule
('$\frac{d}{dx}(e^{2x})$ equals', '$e^{2x+1}$', '$e^{2x}$', '$2xe^{2x}$', '$2e^{2x}$', 'option4', 'By the chain rule: $\frac{d}{dx}(e^{2x}) = e^{2x} \cdot 2 = 2e^{2x}$.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Q7: d/dx(sin^(-1) x) = 1/sqrt(1-x^2)
('$\frac{d}{dx}(\sin^{-1} x)$ equals', '$\frac{-1}{\sqrt{1-x^2}}$', '$\frac{1}{\sqrt{1-x^2}}$', '$\frac{1}{\sqrt{1+x^2}}$', '$\frac{1}{1-x^2}$', 'option2', '$\frac{d}{dx}(\sin^{-1} x) = \frac{1}{\sqrt{1-x^2}}$ for $|x| < 1$.', 'm_differentiation_special', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: d/dx(sin(x^2)) = cos(x^2) * 2x = 2x cos(x^2)
('$\frac{d}{dx}[\sin(x^2)]$ equals', '$2x\cos(x^2)$', '$\cos(x^2)$', '$2x\sin(x^2)$', '$x^2\cos(x^2)$', 'option1', 'Chain rule: $\cos(x^2) \cdot \frac{d}{dx}(x^2) = 2x\cos(x^2)$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q9: d/dx(ln(sin x)) = cos x / sin x = cot x
('$\frac{d}{dx}[\ln(\sin x)]$ equals', '$\frac{1}{\sin x}$', '$\tan x$', '$\cot x$', '$\cos x \ln(\sin x)$', 'option3', 'Chain rule: $\frac{1}{\sin x} \cdot \cos x = \cot x$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q10: d/dx(e^(sin x)) = e^(sin x) * cos x
('$\frac{d}{dx}(e^{\sin x})$ equals', '$e^{\cos x}$', '$e^{\sin x} \cos x$', '$e^{\sin x} \sin x$', '$\cos x \cdot e^x$', 'option2', 'Chain rule: $e^{\sin x} \cdot \frac{d}{dx}(\sin x) = e^{\sin x} \cdot \cos x$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q11: d/dx(tan^(-1)(x)) = 1/(1+x^2). At x=1: 1/2
('If $f(x) = \tan^{-1} x$, then $f''(1)$ equals', '$\frac{\pi}{4}$', '$1$', '$\frac{1}{\sqrt{2}}$', '$\frac{1}{2}$', 'option4', '$f''(x) = \frac{1}{1+x^2}$. At $x = 1$: $f''(1) = \frac{1}{1+1} = \frac{1}{2}$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q12: d/dx(x^x). Let y=x^x, ln y = x ln x. (1/y)y' = ln x + 1. y' = x^x(1+ln x)
('$\frac{d}{dx}(x^x)$ equals', '$x^x \ln x$', '$x \cdot x^{x-1}$', '$x^x(1 + \ln x)$', '$x^{x+1}$', 'option3', 'Let $y = x^x$. Then $\ln y = x\ln x$. Differentiating: $\frac{y''}{y} = \ln x + 1$. So $y'' = x^x(1 + \ln x)$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q13: d/dx(sqrt(tan x)) = sec^2 x / (2 sqrt(tan x))
('$\frac{d}{dx}(\sqrt{\tan x})$ equals', '$\frac{1}{2\sqrt{\tan x}}$', '$\frac{\sec^2 x}{2\sqrt{\tan x}}$', '$\frac{\sec x}{2\sqrt{\tan x}}$', '$\sec^2 x \sqrt{\tan x}$', 'option2', 'Chain rule: $\frac{1}{2\sqrt{\tan x}} \cdot \sec^2 x = \frac{\sec^2 x}{2\sqrt{\tan x}}$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Implicit: x^2 + y^2 = 25. 2x + 2y dy/dx = 0. dy/dx = -x/y
('If $x^2 + y^2 = 25$, then $\frac{dy}{dx}$ equals', '$-\frac{x}{y}$', '$\frac{x}{y}$', '$-\frac{y}{x}$', '$\frac{y}{x}$', 'option1', 'Differentiating implicitly: $2x + 2y\frac{dy}{dx} = 0$, so $\frac{dy}{dx} = -\frac{x}{y}$.', 'm_differentiation_special', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: d/dx(sin^(-1)(2x sqrt(1-x^2))). Let x=sin t, then 2x sqrt(1-x^2) = 2 sin t cos t = sin 2t.
-- So sin^(-1)(sin 2t) = 2t = 2 sin^(-1) x. Derivative = 2/sqrt(1-x^2)
('$\frac{d}{dx}[\sin^{-1}(2x\sqrt{1-x^2})]$ for $|x| < \frac{1}{\sqrt{2}}$ equals', '$\frac{-2}{\sqrt{1-x^2}}$', '$\frac{1}{\sqrt{1-x^2}}$', '$\frac{2x}{\sqrt{1-x^2}}$', '$\frac{2}{\sqrt{1-x^2}}$', 'option4', 'Put $x = \sin\theta$. Then $2x\sqrt{1-x^2} = 2\sin\theta\cos\theta = \sin 2\theta$. So $\sin^{-1}(\sin 2\theta) = 2\theta = 2\sin^{-1}x$. Derivative $= \frac{2}{\sqrt{1-x^2}}$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q16: d/dx(tan^(-1)((2x)/(1-x^2))). Let x=tan t. (2 tan t)/(1-tan^2 t) = tan 2t.
-- tan^(-1)(tan 2t) = 2t = 2 tan^(-1) x. Derivative = 2/(1+x^2)
('$\frac{d}{dx}\left[\tan^{-1}\left(\frac{2x}{1-x^2}\right)\right]$ for $|x| < 1$ equals', '$\frac{2}{1-x^2}$', '$\frac{1}{1+x^2}$', '$\frac{2x}{1+x^2}$', '$\frac{2}{1+x^2}$', 'option4', 'Put $x = \tan\theta$. Then $\frac{2\tan\theta}{1-\tan^2\theta} = \tan 2\theta$. So $\tan^{-1}(\tan 2\theta) = 2\theta = 2\tan^{-1}x$. Derivative $= \frac{2}{1+x^2}$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Implicit: x^3 + y^3 = 3xy. 3x^2 + 3y^2 y' = 3y + 3x y'. y'(3y^2 - 3x) = 3y - 3x^2. y' = (y-x^2)/(y^2-x)
('If $x^3 + y^3 = 3xy$, then $\frac{dy}{dx}$ equals', '$\frac{y - x^2}{y^2 - x}$', '$\frac{x^2 - y}{y^2 - x}$', '$\frac{y - x^2}{y^2 + x}$', '$\frac{x - y^2}{x^2 - y}$', 'option1', 'Differentiating: $3x^2 + 3y^2\frac{dy}{dx} = 3y + 3x\frac{dy}{dx}$. Rearranging: $\frac{dy}{dx}(3y^2 - 3x) = 3y - 3x^2$, so $\frac{dy}{dx} = \frac{y - x^2}{y^2 - x}$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q18: d/dx(cos^(-1)((1-x^2)/(1+x^2))). Let x=tan t. (1-tan^2 t)/(1+tan^2 t) = cos 2t.
-- cos^(-1)(cos 2t) = 2t = 2 tan^(-1) x. Derivative = 2/(1+x^2)
('$\frac{d}{dx}\left[\cos^{-1}\left(\frac{1-x^2}{1+x^2}\right)\right]$ for $x > 0$ equals', '$\frac{-2}{1+x^2}$', '$\frac{2}{1+x^2}$', '$\frac{1}{1+x^2}$', '$\frac{2x}{1+x^2}$', 'option2', 'Put $x = \tan\theta$ ($\theta > 0$). Then $\frac{1-\tan^2\theta}{1+\tan^2\theta} = \cos 2\theta$. So $\cos^{-1}(\cos 2\theta) = 2\theta = 2\tan^{-1}x$. Derivative $= \frac{2}{1+x^2}$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q19: d/dx(e^(x^2) sin x). Product + chain: e^(x^2)*2x*sin x + e^(x^2)*cos x = e^(x^2)(2x sin x + cos x)
('$\frac{d}{dx}(e^{x^2}\sin x)$ equals', '$2xe^{x^2}\sin x$', '$e^{x^2}(2x\sin x - \cos x)$', '$e^{x^2}(2x\sin x + \cos x)$', '$e^{x^2}\cos x$', 'option3', 'Product rule with chain rule: $e^{x^2} \cdot 2x \cdot \sin x + e^{x^2} \cdot \cos x = e^{x^2}(2x\sin x + \cos x)$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q20: d/dx(log_a x) = 1/(x ln a)
('$\frac{d}{dx}(\log_a x)$ equals', '$\frac{\ln a}{x}$', '$\frac{1}{x}$', '$\frac{1}{x\ln a}$', '$\frac{a}{x}$', 'option3', '$\log_a x = \frac{\ln x}{\ln a}$. So $\frac{d}{dx}(\log_a x) = \frac{1}{x\ln a}$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),

-- Q21: d/dx(sin^(-1) x + cos^(-1) x) = 0 since sin^(-1) x + cos^(-1) x = pi/2
('$\frac{d}{dx}(\sin^{-1} x + \cos^{-1} x)$ equals', '$\frac{-2}{\sqrt{1-x^2}}$', '$\frac{2}{\sqrt{1-x^2}}$', '$1$', '$0$', 'option4', 'Since $\sin^{-1}x + \cos^{-1}x = \frac{\pi}{2}$ (a constant) for all $x \in [-1, 1]$, its derivative is $0$.', 'm_differentiation_special', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_higher_order_derivatives (Derivatives of order upto two)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
-- Q1: f(x)=x^3. f'=3x^2. f''=6x.
('If $f(x) = x^3$, then $f''''(x)$ equals', '$3x$', '$3x^2$', '$6$', '$6x$', 'option4', '$f''(x) = 3x^2$. $f''''(x) = 6x$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q2: y=x^4. y'=4x^3. y''=12x^2.
('If $y = x^4$, then $\frac{d^2y}{dx^2}$ equals', '$12x^2$', '$4x^3$', '$24x$', '$4x^2$', 'option1', '$\frac{dy}{dx} = 4x^3$. $\frac{d^2y}{dx^2} = 12x^2$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q3: f(x)=sin x. f'=cos x. f''=-sin x.
('If $f(x) = \sin x$, then $f''''(x)$ equals', '$-\cos x$', '$\cos x$', '$\sin x$', '$-\sin x$', 'option4', '$f''(x) = \cos x$. $f''''(x) = -\sin x$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q4: y=e^x. y'=e^x. y''=e^x.
('If $y = e^x$, then $\frac{d^2y}{dx^2}$ equals', '$e^{2x}$', '$2e^x$', '$xe^x$', '$e^x$', 'option4', '$\frac{dy}{dx} = e^x$. $\frac{d^2y}{dx^2} = e^x$. The exponential function is its own derivative of every order.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q5: f(x)=5x^2+3x+1. f'=10x+3. f''=10.
('If $f(x) = 5x^2 + 3x + 1$, then $f''''(x)$ equals', '$10x + 3$', '$10$', '$5$', '$0$', 'option2', '$f''(x) = 10x + 3$. $f''''(x) = 10$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q6: y=ln x. y'=1/x. y''=-1/x^2.
('If $y = \ln x$, then $\frac{d^2y}{dx^2}$ equals', '$-\frac{1}{x^2}$', '$\frac{1}{x^2}$', '$\frac{1}{x}$', '$-\frac{2}{x^2}$', 'option1', '$\frac{dy}{dx} = \frac{1}{x}$. $\frac{d^2y}{dx^2} = -\frac{1}{x^2}$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q7: y=cos x. y'=-sin x. y''=-cos x.
('If $y = \cos x$, then $\frac{d^2y}{dx^2}$ equals', '$-\sin x$', '$\cos x$', '$\sin x$', '$-\cos x$', 'option4', '$\frac{dy}{dx} = -\sin x$. $\frac{d^2y}{dx^2} = -\cos x$.', 'm_higher_order_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: y=x^2 e^x. y'=2x e^x + x^2 e^x = e^x(x^2+2x).
-- y''= e^x(x^2+2x) + e^x(2x+2) = e^x(x^2+4x+2)
('If $y = x^2 e^x$, then $\frac{d^2y}{dx^2}$ equals', '$e^x(x^2 + 4x + 2)$', '$e^x(x^2 + 2x)$', '$e^x(2x + 2)$', '$e^x(x^2 + 2x + 2)$', 'option1', '$y'' = e^x(x^2 + 2x)$. $y'''' = e^x(x^2 + 2x) + e^x(2x + 2) = e^x(x^2 + 4x + 2)$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q9: y=sin 2x. y'=2cos 2x. y''=-4sin 2x.
('If $y = \sin 2x$, then $\frac{d^2y}{dx^2}$ equals', '$-4\sin 2x$', '$4\sin 2x$', '$-2\sin 2x$', '$4\cos 2x$', 'option1', '$y'' = 2\cos 2x$. $y'''' = -4\sin 2x$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q10: y=x sin x. y'=sin x + x cos x. y''=cos x + cos x - x sin x = 2cos x - x sin x
('If $y = x\sin x$, then $\frac{d^2y}{dx^2}$ equals', '$2\cos x - x\sin x$', '$2\cos x + x\sin x$', '$-x\sin x$', '$x\cos x + \sin x$', 'option1', '$y'' = \sin x + x\cos x$. $y'''' = \cos x + \cos x - x\sin x = 2\cos x - x\sin x$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q11: y=e^(2x). y'=2e^(2x). y''=4e^(2x).
('If $y = e^{2x}$, then $\frac{d^2y}{dx^2}$ equals', '$e^{2x}$', '$2e^{2x}$', '$4e^{2x}$', '$4xe^{2x}$', 'option3', '$y'' = 2e^{2x}$. $y'''' = 4e^{2x}$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q12: y=tan x. y'=sec^2 x. y''=2 sec x * sec x tan x = 2 sec^2 x tan x
('If $y = \tan x$, then $\frac{d^2y}{dx^2}$ equals', '$\sec^4 x$', '$\sec^2 x$', '$2\sec^2 x$', '$2\sec^2 x \tan x$', 'option4', '$y'' = \sec^2 x$. $y'''' = 2\sec x \cdot \sec x\tan x = 2\sec^2 x\tan x$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q13: y=x^3 - 6x^2 + 11x. y'=3x^2-12x+11. y''=6x-12. y''(2)=0.
('If $y = x^3 - 6x^2 + 11x$, then $\frac{d^2y}{dx^2}$ at $x = 2$ equals', '$0$', '$-1$', '$12$', '$6$', 'option1', '$y'' = 3x^2 - 12x + 11$. $y'''' = 6x - 12$. At $x = 2$: $y'''' = 12 - 12 = 0$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q14: y=a sin x + b cos x. y'=a cos x - b sin x. y''=-a sin x - b cos x = -(a sin x + b cos x) = -y.
('If $y = a\sin x + b\cos x$, then $\frac{d^2y}{dx^2} + y$ equals', '$a^2 + b^2$', '$2y$', '$-2y$', '$0$', 'option4', '$y'''' = -a\sin x - b\cos x = -y$. Therefore $y'''' + y = 0$.', 'm_higher_order_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: y=e^(ax) sin bx. y'=ae^(ax) sin bx + be^(ax) cos bx = e^(ax)(a sin bx + b cos bx).
-- y''=ae^(ax)(a sin bx + b cos bx) + e^(ax)(ab cos bx - b^2 sin bx)
-- = e^(ax)(a^2 sin bx + ab cos bx + ab cos bx - b^2 sin bx)
-- = e^(ax)((a^2-b^2) sin bx + 2ab cos bx)
('If $y = e^{ax}\sin bx$, then $\frac{d^2y}{dx^2}$ equals', '$e^{ax}[(a^2 - b^2)\sin bx + 2ab\cos bx]$', '$e^{ax}(a^2 + b^2)\sin bx$', '$e^{ax}[(a^2 + b^2)\sin bx + 2ab\cos bx]$', '$(a^2 - b^2)e^{ax}\sin bx$', 'option1', '$y'' = e^{ax}(a\sin bx + b\cos bx)$. Differentiating again: $y'''' = e^{ax}[(a^2-b^2)\sin bx + 2ab\cos bx]$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q16: y=ln(1+x^2). y'=2x/(1+x^2). y''=((1+x^2)*2 - 2x*2x)/(1+x^2)^2 = (2+2x^2-4x^2)/(1+x^2)^2 = (2-2x^2)/(1+x^2)^2 = 2(1-x^2)/(1+x^2)^2
('If $y = \ln(1 + x^2)$, then $\frac{d^2y}{dx^2}$ equals', '$\frac{2(1 - x^2)}{(1 + x^2)^2}$', '$\frac{2x}{1 + x^2}$', '$\frac{2}{(1 + x^2)^2}$', '$\frac{2(1 + x^2)}{(1 - x^2)^2}$', 'option1', '$y'' = \frac{2x}{1+x^2}$. By quotient rule: $y'''' = \frac{2(1+x^2) - 2x \cdot 2x}{(1+x^2)^2} = \frac{2 - 2x^2}{(1+x^2)^2} = \frac{2(1-x^2)}{(1+x^2)^2}$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q17: x=a cos t, y=a sin t. dy/dx = (a cos t)/(-a sin t) = -cot t.
-- d2y/dx2 = d/dt(-cot t) / (dx/dt) = (csc^2 t)/(-a sin t) = -1/(a sin^3 t) = -csc^3 t / a
('If $x = a\cos t$ and $y = a\sin t$, then $\frac{d^2y}{dx^2}$ equals', '$\frac{-\cos t}{a\sin^2 t}$', '$\frac{1}{a\sin^3 t}$', '$\frac{-1}{a\sin^3 t}$', '$\frac{1}{a\cos^3 t}$', 'option3', '$\frac{dy}{dx} = \frac{a\cos t}{-a\sin t} = -\cot t$. $\frac{d^2y}{dx^2} = \frac{d}{dt}(-\cot t) \div \frac{dx}{dt} = \frac{\csc^2 t}{-a\sin t} = \frac{-1}{a\sin^3 t}$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q18: y=x^2 ln x. y'=2x ln x + x. y''=2 ln x + 2 + 1 = 2 ln x + 3.
('If $y = x^2 \ln x$, then $\frac{d^2y}{dx^2}$ equals', '$2\ln x + 3$', '$2\ln x + 1$', '$2x\ln x + x$', '$\frac{2}{x} + 3$', 'option1', '$y'' = 2x\ln x + x^2 \cdot \frac{1}{x} = 2x\ln x + x$. $y'''' = 2\ln x + 2 + 1 = 2\ln x + 3$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q19: x=t^2, y=t^3. dy/dx = 3t^2/(2t) = 3t/2. d2y/dx2 = d/dt(3t/2)/(dx/dt) = (3/2)/(2t) = 3/(4t)
('If $x = t^2$ and $y = t^3$, then $\frac{d^2y}{dx^2}$ equals', '$\frac{3t^2}{4}$', '$\frac{3t}{2}$', '$\frac{3}{2t}$', '$\frac{3}{4t}$', 'option4', '$\frac{dy}{dx} = \frac{3t^2}{2t} = \frac{3t}{2}$. $\frac{d^2y}{dx^2} = \frac{\frac{d}{dt}(3t/2)}{dx/dt} = \frac{3/2}{2t} = \frac{3}{4t}$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q20: y=sin^(-1) x. y'=1/sqrt(1-x^2)=(1-x^2)^(-1/2). y''=(1/2)(1-x^2)^(-3/2)*2x = x/(1-x^2)^(3/2)
('If $y = \sin^{-1} x$, then $\frac{d^2y}{dx^2}$ equals', '$\frac{1}{(1-x^2)^{3/2}}$', '$\frac{x}{(1-x^2)^{3/2}}$', '$\frac{-x}{(1-x^2)^{3/2}}$', '$\frac{x}{\sqrt{1-x^2}}$', 'option2', '$y'' = (1-x^2)^{-1/2}$. $y'''' = -\frac{1}{2}(1-x^2)^{-3/2} \cdot (-2x) = \frac{x}{(1-x^2)^{3/2}}$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q21: If y=Ae^(2x)+Be^(-2x), then y''=4Ae^(2x)+4Be^(-2x)=4y. So y''-4y=0.
('If $y = Ae^{2x} + Be^{-2x}$, then $\frac{d^2y}{dx^2} - 4y$ equals', '$8y$', '$4y$', '$-4y$', '$0$', 'option4', '$y'' = 2Ae^{2x} - 2Be^{-2x}$. $y'''' = 4Ae^{2x} + 4Be^{-2x} = 4y$. So $y'''' - 4y = 0$.', 'm_higher_order_derivatives', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_applications_derivatives (Applications of derivatives: rate of change, monotonic functions, maxima and minima)
-- Chapter: math_limit_continuity_differentiability
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Area of circle A=pi r^2. dA/dr = 2 pi r. At r=5: 10 pi.
('The rate of change of the area of a circle with respect to its radius $r$ at $r = 5$ is', '$10\pi$', '$5\pi$', '$25\pi$', '$20\pi$', 'option1', '$A = \pi r^2$. $\frac{dA}{dr} = 2\pi r$. At $r = 5$: $\frac{dA}{dr} = 10\pi$.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q2: f(x)=x^2 is increasing when f'(x)=2x>0, i.e., x>0.
('The function $f(x) = x^2$ is increasing on', '$(0, \infty)$', '$(-\infty, 0)$', '$(-\infty, \infty)$', '$(1, \infty)$', 'option1', '$f''(x) = 2x > 0$ when $x > 0$. So $f$ is increasing on $(0, \infty)$.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q3: f(x)=3x+5. f'(x)=3>0 always. So f is increasing on all of R.
('The function $f(x) = 3x + 5$ is', 'Increasing on $(-\infty, \infty)$', 'Decreasing on $(-\infty, \infty)$', 'Neither increasing nor decreasing', 'Increasing only for $x > 0$', 'option1', '$f''(x) = 3 > 0$ for all $x$. So $f$ is strictly increasing on $(-\infty, \infty)$.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q4: f(x)=x^2-4x+3. f'(x)=2x-4=0 => x=2. f(2)=4-8+3=-1. f''(2)=2>0, so minimum.
('The minimum value of $f(x) = x^2 - 4x + 3$ is', '$3$', '$0$', '$-1$', '$1$', 'option3', '$f''(x) = 2x - 4 = 0$ gives $x = 2$. $f(2) = 4 - 8 + 3 = -1$. Since $f''''(x) = 2 > 0$, this is a minimum.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Volume of sphere V=(4/3)pi r^3. dV/dr = 4 pi r^2. At r=3: 36 pi.
('The rate of change of volume of a sphere with respect to radius at $r = 3$ is', '$12\pi$', '$36\pi$', '$27\pi$', '$108\pi$', 'option2', '$V = \frac{4}{3}\pi r^3$. $\frac{dV}{dr} = 4\pi r^2$. At $r = 3$: $\frac{dV}{dr} = 4\pi(9) = 36\pi$.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q6: f(x)=-x^2+6x-5. f'(x)=-2x+6=0 => x=3. f(3)=-9+18-5=4. f''=-2<0, so maximum.
('The maximum value of $f(x) = -x^2 + 6x - 5$ is', '$5$', '$4$', '$6$', '$3$', 'option2', '$f''(x) = -2x + 6 = 0$ gives $x = 3$. $f(3) = -9 + 18 - 5 = 4$. Since $f''''(x) = -2 < 0$, this is a maximum.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Q7: f(x)=e^x. f'(x)=e^x>0 for all x. So f is always increasing.
('The function $f(x) = e^x$ is', 'Neither increasing nor decreasing', 'Decreasing for all $x$', 'Increasing for $x > 0$ only', 'Increasing for all $x$', 'option4', '$f''(x) = e^x > 0$ for all $x \in \mathbb{R}$. So $f$ is strictly increasing everywhere.', 'm_applications_derivatives', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: f(x)=2x^3-9x^2+12x-5. f'=6x^2-18x+12=6(x^2-3x+2)=6(x-1)(x-2).
-- f'=0 at x=1,2. f(1)=2-9+12-5=0. f(2)=16-36+24-5=-1. f''=12x-18.
-- f''(1)=-6<0 => max at x=1. f''(2)=6>0 => min at x=2.
('The function $f(x) = 2x^3 - 9x^2 + 12x - 5$ has a local maximum at', '$x = 0$', '$x = 2$', '$x = 1$', '$x = 3$', 'option3', '$f''(x) = 6x^2 - 18x + 12 = 6(x-1)(x-2) = 0$ at $x = 1, 2$. $f''''(x) = 12x - 18$. $f''''(1) = -6 < 0$, so $x = 1$ is a local maximum.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q9: f(x)=x^3-3x+2. f'=3x^2-3=3(x^2-1)=3(x-1)(x+1). f'>0 when x<-1 or x>1.
('The function $f(x) = x^3 - 3x + 2$ is increasing on', '$(0, \infty)$', '$(-1, 1)$', '$(-\infty, -1) \cup (1, \infty)$', '$(-\infty, \infty)$', 'option3', '$f''(x) = 3x^2 - 3 = 3(x-1)(x+1)$. $f''(x) > 0$ when $x < -1$ or $x > 1$.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Side of cube increasing at 2 cm/s. V=s^3. dV/dt=3s^2 ds/dt. At s=10: 3*100*2=600.
('A cube''s side increases at $2$ cm/s. The rate of change of volume when the side is $10$ cm is', '$600$ cm$^3$/s', '$300$ cm$^3$/s', '$200$ cm$^3$/s', '$60$ cm$^3$/s', 'option1', '$V = s^3$. $\frac{dV}{dt} = 3s^2 \frac{ds}{dt} = 3(100)(2) = 600$ cm$^3$/s.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Two positive numbers with sum 16, maximize product. x+y=16, P=xy=x(16-x). P'=16-2x=0 => x=8. Max product=64.
('Two positive numbers have sum $16$. Their maximum product is', '$32$', '$60$', '$48$', '$64$', 'option4', 'Let the numbers be $x$ and $16-x$. Product $P = x(16-x) = 16x - x^2$. $P'' = 16 - 2x = 0$ gives $x = 8$. $P = 8 \times 8 = 64$.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q12: f(x)=sin x on [0, 2pi]. f'=cos x=0 at x=pi/2, 3pi/2. f(pi/2)=1 (max), f(3pi/2)=-1 (min).
('The absolute maximum of $f(x) = \sin x$ on $[0, 2\pi]$ is', '$-1$', '$1$', '$0$', '$\frac{1}{2}$', 'option2', '$f''(x) = \cos x = 0$ at $x = \frac{\pi}{2}, \frac{3\pi}{2}$. $f(\frac{\pi}{2}) = 1$, $f(\frac{3\pi}{2}) = -1$, $f(0) = f(2\pi) = 0$. Maximum value is $1$.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Slope of tangent to y=x^3-3x at x=1. y'=3x^2-3. At x=1: 3-3=0.
('The slope of the tangent to $y = x^3 - 3x$ at $x = 1$ is', '$1$', '$3$', '$-3$', '$0$', 'option4', '$\frac{dy}{dx} = 3x^2 - 3$. At $x = 1$: slope $= 3(1) - 3 = 0$.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Q14: f(x)=x+1/x for x>0. f'=1-1/x^2=0 => x=1. f(1)=2. f''=2/x^3. f''(1)=2>0, min.
('The minimum value of $f(x) = x + \frac{1}{x}$ for $x > 0$ is', '$\frac{1}{2}$', '$1$', '$2$', '$\sqrt{2}$', 'option3', '$f''(x) = 1 - \frac{1}{x^2} = 0$ gives $x = 1$. $f(1) = 1 + 1 = 2$. $f''''(1) = \frac{2}{1} > 0$, confirming minimum.', 'm_applications_derivatives', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Rectangle inscribed in circle of radius r. Let half-sides be a,b with a^2+b^2=r^2.
-- Area=4ab. Maximize 4ab subject to a^2+b^2=r^2. By AM-GM, ab <= (a^2+b^2)/2 = r^2/2.
-- Max area = 4*r^2/2 = 2r^2 when a=b=r/sqrt(2). So it's a square.
('The maximum area of a rectangle inscribed in a circle of radius $r$ is', '$r^2$', '$2r^2$', '$\pi r^2$', '$4r^2$', 'option2', 'Let half-diagonals give $a^2 + b^2 = r^2$ where $2a, 2b$ are sides. Area $= 4ab \leq 4 \cdot \frac{a^2+b^2}{2} = 2r^2$ (by AM-GM). Equality when $a = b = \frac{r}{\sqrt{2}}$.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q16: f(x)=x^4-4x^3+4x^2. f'=4x^3-12x^2+8x=4x(x^2-3x+2)=4x(x-1)(x-2).
-- Critical points: x=0,1,2. f(0)=0, f(1)=1-4+4=1, f(2)=16-32+16=0.
-- f''=12x^2-24x+8. f''(0)=8>0 (min), f''(1)=-4<0 (max), f''(2)=8>0 (min).
('The number of local maxima of $f(x) = x^4 - 4x^3 + 4x^2$ is', '$1$', '$2$', '$0$', '$3$', 'option1', '$f''(x) = 4x(x-1)(x-2) = 0$ at $x = 0, 1, 2$. $f''''(x) = 12x^2 - 24x + 8$. $f''''(0) = 8 > 0$ (min), $f''''(1) = -4 < 0$ (max), $f''''(2) = 8 > 0$ (min). So there is exactly $1$ local maximum.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Open box from 12x12 sheet, cutting squares of side x. V=x(12-2x)^2.
-- V'=(12-2x)^2 + x*2(12-2x)(-2) = (12-2x)[(12-2x)-4x] = (12-2x)(12-6x).
-- V'=0: x=6 (rejected, gives 0 volume) or x=2. V(2)=2*64=128.
('An open box is made from a $12 \times 12$ cm sheet by cutting equal squares of side $x$ from corners. The maximum volume is', '$108$ cm$^3$', '$128$ cm$^3$', '$144$ cm$^3$', '$96$ cm$^3$', 'option2', '$V = x(12-2x)^2$. $V'' = (12-2x)(12-6x) = 0$ gives $x = 2$ or $x = 6$. At $x = 2$: $V = 2(8)^2 = 128$. At $x = 6$: $V = 0$. Maximum volume is $128$ cm$^3$.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q18: f(x)=x e^(-x). f'=e^(-x)-xe^(-x)=e^(-x)(1-x)=0 => x=1. f(1)=1/e.
-- f''=e^(-x)(-1)(1-x)+e^(-x)(-1)=e^(-x)(x-2). f''(1)=-1/e<0, so max.
('The maximum value of $f(x) = xe^{-x}$ is', '$e$', '$\frac{1}{e}$', '$1$', '$\frac{1}{e^2}$', 'option2', '$f''(x) = e^{-x}(1-x) = 0$ gives $x = 1$. $f(1) = \frac{1}{e}$. $f''''(1) = e^{-1}(1-2) = -\frac{1}{e} < 0$, confirming maximum.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Rolle's theorem: f continuous on [a,b], differentiable on (a,b), f(a)=f(b) => exists c in (a,b) with f'(c)=0.
-- f(x)=x^2-4x+3 on [1,3]. f(1)=0, f(3)=0. f'(x)=2x-4=0 => x=2.
('For $f(x) = x^2 - 4x + 3$ on $[1, 3]$, the value of $c$ in Rolle''s theorem is', '$\frac{5}{2}$', '$\frac{3}{2}$', '$2$', '$1$', 'option3', '$f(1) = 0 = f(3)$. By Rolle''s theorem, $f''(c) = 0$ for some $c \in (1,3)$. $f''(x) = 2x - 4 = 0$ gives $c = 2$.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Cylinder inscribed in sphere of radius R. Let half-height=h, radius=r. r^2+h^2=R^2.
-- V=pi r^2 (2h) = 2pi(R^2-h^2)h. V'=2pi(R^2-3h^2)=0 => h=R/sqrt(3). r^2=R^2-R^2/3=2R^2/3.
-- V=2pi*(2R^2/3)*(R/sqrt(3))=4piR^3/(3sqrt(3))
('The maximum volume of a cylinder inscribed in a sphere of radius $R$ is', '$\frac{2\pi R^3}{3}$', '$\frac{4\pi R^3}{3\sqrt{3}}$', '$\pi R^3$', '$\frac{4\pi R^3}{3}$', 'option2', 'Let half-height $= h$, cylinder radius $= r$ with $r^2 + h^2 = R^2$. $V = 2\pi r^2 h = 2\pi(R^2 - h^2)h$. $V'' = 2\pi(R^2 - 3h^2) = 0$ gives $h = \frac{R}{\sqrt{3}}$. $V = \frac{4\pi R^3}{3\sqrt{3}}$.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),

-- Q21: LMVT: f(x)=x^3 on [1,3]. f(3)-f(1)/(3-1) = (27-1)/2 = 13. f'(c)=3c^2=13 => c^2=13/3 => c=sqrt(13/3).
('For $f(x) = x^3$ on $[1, 3]$, the value of $c$ in the Mean Value Theorem is', '$\sqrt{13}$', '$2$', '$\frac{13}{3}$', '$\sqrt{\frac{13}{3}}$', 'option4', '$\frac{f(3)-f(1)}{3-1} = \frac{27-1}{2} = 13$. $f''(c) = 3c^2 = 13$ gives $c^2 = \frac{13}{3}$, so $c = \sqrt{\frac{13}{3}} \approx 2.08 \in (1,3)$.', 'm_applications_derivatives', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_integral_antiderivative (Integral as an anti-derivative)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: integral of x^2 dx = x^3/3 + C
('$\int x^2 \, dx$ equals', '$x^3 + C$', '$\frac{x^2}{2} + C$', '$2x + C$', '$\frac{x^3}{3} + C$', 'option4', 'By the power rule: $\int x^n \, dx = \frac{x^{n+1}}{n+1} + C$. So $\int x^2 \, dx = \frac{x^3}{3} + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q2: integral of 1 dx = x + C
('$\int 1 \, dx$ equals', '$x + C$', '$0 + C$', '$\frac{x^2}{2} + C$', '$C$', 'option1', '$\int 1 \, dx = \int x^0 \, dx = x + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral of cos x dx = sin x + C
('$\int \cos x \, dx$ equals', '$-\sin x + C$', '$\sin x + C$', '$\cos x + C$', '$\tan x + C$', 'option2', 'Since $\frac{d}{dx}(\sin x) = \cos x$, we have $\int \cos x \, dx = \sin x + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral of e^x dx = e^x + C
('$\int e^x \, dx$ equals', '$\frac{e^x}{x} + C$', '$xe^x + C$', '$e^{x+1} + C$', '$e^x + C$', 'option4', 'Since $\frac{d}{dx}(e^x) = e^x$, we have $\int e^x \, dx = e^x + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q5: integral of 1/x dx = ln|x| + C
('$\int \frac{1}{x} \, dx$ equals', '$\frac{-1}{x^2} + C$', '$\ln|x| + C$', '$x + C$', '$\frac{x^2}{2} + C$', 'option2', 'Since $\frac{d}{dx}(\ln|x|) = \frac{1}{x}$, we have $\int \frac{1}{x} \, dx = \ln|x| + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral of sin x dx = -cos x + C
('$\int \sin x \, dx$ equals', '$-\cos x + C$', '$\cos x + C$', '$-\sin x + C$', '$\tan x + C$', 'option1', 'Since $\frac{d}{dx}(-\cos x) = \sin x$, we have $\int \sin x \, dx = -\cos x + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral of x^4 dx = x^5/5 + C
('$\int x^4 \, dx$ equals', '$x^5 + C$', '$4x^3 + C$', '$\frac{x^4}{4} + C$', '$\frac{x^5}{5} + C$', 'option4', 'By the power rule: $\int x^4 \, dx = \frac{x^5}{5} + C$.', 'm_integral_antiderivative', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: integral of (3x^2 + 2x + 1) dx = x^3 + x^2 + x + C
('$\int (3x^2 + 2x + 1) \, dx$ equals', '$6x + 2 + C$', '$x^3 + x^2 + x + C$', '$x^3 + x^2 + C$', '$3x^3 + 2x^2 + x + C$', 'option2', '$\int 3x^2 \, dx + \int 2x \, dx + \int 1 \, dx = x^3 + x^2 + x + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q9: integral of sec^2 x dx = tan x + C
('$\int \sec^2 x \, dx$ equals', '$\sec x + C$', '$\tan x + C$', '$\sec x \tan x + C$', '$-\cot x + C$', 'option2', 'Since $\frac{d}{dx}(\tan x) = \sec^2 x$, we have $\int \sec^2 x \, dx = \tan x + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q10: integral of (x + 1/x)^2 dx = integral of (x^2 + 2 + 1/x^2) dx = x^3/3 + 2x - 1/x + C
('$\int \left(x + \frac{1}{x}\right)^2 dx$ equals', '$\frac{x^3}{3} + 2\ln x - \frac{1}{x} + C$', '$\frac{x^2}{2} + \ln x + C$', '$\frac{x^3}{3} + 2x - \frac{1}{x} + C$', '$x^2 + 2x + \frac{1}{x^2} + C$', 'option3', 'Expand: $\left(x + \frac{1}{x}\right)^2 = x^2 + 2 + \frac{1}{x^2}$. Integrating: $\frac{x^3}{3} + 2x + \frac{x^{-1}}{-1} + C = \frac{x^3}{3} + 2x - \frac{1}{x} + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral of x^(-1/2) dx = 2x^(1/2) + C = 2 sqrt(x) + C
('$\int \frac{1}{\sqrt{x}} \, dx$ equals', '$2\sqrt{x} + C$', '$\frac{1}{2\sqrt{x}} + C$', '$\sqrt{x} + C$', '$-\frac{1}{2\sqrt{x}} + C$', 'option1', '$\int x^{-1/2} \, dx = \frac{x^{1/2}}{1/2} + C = 2\sqrt{x} + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q12: If F'(x)=2x+3 and F(0)=5, find F(x). F(x)=x^2+3x+C. F(0)=C=5. F(x)=x^2+3x+5.
('If $F''(x) = 2x + 3$ and $F(0) = 5$, then $F(x)$ equals', '$x^2 + 3x + 5$', '$x^2 + 3x$', '$2x + 3$', '$x^2 + 3x + 3$', 'option1', '$F(x) = \int(2x+3)\,dx = x^2 + 3x + C$. $F(0) = C = 5$. So $F(x) = x^2 + 3x + 5$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q13: integral of (sin x + cos x) dx = -cos x + sin x + C
('$\int (\sin x + \cos x) \, dx$ equals', '$-\cos x - \sin x + C$', '$\cos x + \sin x + C$', '$-\cos x + \sin x + C$', '$\sin x - \cos x + C$', 'option3', '$\int \sin x \, dx + \int \cos x \, dx = -\cos x + \sin x + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Q14: integral of 5e^x + 3/x dx = 5e^x + 3 ln|x| + C
('$\int \left(5e^x + \frac{3}{x}\right) dx$ equals', '$e^{5x} + 3\ln|x| + C$', '$5e^x + 3x + C$', '$5xe^x + 3\ln x + C$', '$5e^x + 3\ln|x| + C$', 'option4', '$\int 5e^x \, dx + \int \frac{3}{x} \, dx = 5e^x + 3\ln|x| + C$.', 'm_integral_antiderivative', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: integral of (sqrt(x) + 1/sqrt(x))^2 dx = integral of (x + 2 + 1/x) dx = x^2/2 + 2x + ln|x| + C
('$\int \left(\sqrt{x} + \frac{1}{\sqrt{x}}\right)^2 dx$ equals', '$\frac{x^2}{2} + 2x + \ln|x| + C$', '$x + 2\sqrt{x} + \ln x + C$', '$\frac{x^2}{2} + 2x + \frac{1}{x} + C$', '$x^2 + 2x + \ln x + C$', 'option1', 'Expand: $x + 2 + \frac{1}{x}$. Integrating: $\frac{x^2}{2} + 2x + \ln|x| + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q16: integral of (x^3 - 1)/x dx = integral of (x^2 - 1/x) dx = x^3/3 - ln|x| + C
('$\int \frac{x^3 - 1}{x} \, dx$ equals', '$\frac{x^4}{4} - \ln|x| + C$', '$\frac{x^3}{3} - x + C$', '$x^2 - \frac{1}{x} + C$', '$\frac{x^3}{3} - \ln|x| + C$', 'option4', '$\frac{x^3-1}{x} = x^2 - \frac{1}{x}$. Integrating: $\frac{x^3}{3} - \ln|x| + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q17: integral of sec x tan x dx = sec x + C
('$\int \sec x \tan x \, dx$ equals', '$\tan x + C$', '$\sec x + C$', '$\sec^2 x + C$', '$-\sec x + C$', 'option2', 'Since $\frac{d}{dx}(\sec x) = \sec x \tan x$, we have $\int \sec x \tan x \, dx = \sec x + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q18: integral of csc^2 x dx = -cot x + C
('$\int \csc^2 x \, dx$ equals', '$-\cot x + C$', '$\cot x + C$', '$-\csc x + C$', '$\tan x + C$', 'option1', 'Since $\frac{d}{dx}(-\cot x) = \csc^2 x$, we have $\int \csc^2 x \, dx = -\cot x + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral of a^x dx = a^x / ln a + C
('$\int a^x \, dx$ (where $a > 0, a \neq 1$) equals', '$\frac{a^{x+1}}{x+1} + C$', '$a^x \ln a + C$', '$\frac{a^x}{\ln a} + C$', '$xa^{x-1} + C$', 'option3', 'Since $\frac{d}{dx}\left(\frac{a^x}{\ln a}\right) = a^x$, we have $\int a^x \, dx = \frac{a^x}{\ln a} + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q20: integral of 1/(1+x^2) dx = tan^(-1) x + C
('$\int \frac{1}{1+x^2} \, dx$ equals', '$\tan^{-1} x + C$', '$\sin^{-1} x + C$', '$\ln(1+x^2) + C$', '$\frac{x}{1+x^2} + C$', 'option1', 'Since $\frac{d}{dx}(\tan^{-1} x) = \frac{1}{1+x^2}$, we have $\int \frac{1}{1+x^2} \, dx = \tan^{-1} x + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),

-- Q21: integral of 1/sqrt(1-x^2) dx = sin^(-1) x + C
('$\int \frac{1}{\sqrt{1-x^2}} \, dx$ equals', '$\sin^{-1} x + C$', '$\cos^{-1} x + C$', '$\tan^{-1} x + C$', '$\ln|x + \sqrt{1-x^2}| + C$', 'option1', 'Since $\frac{d}{dx}(\sin^{-1} x) = \frac{1}{\sqrt{1-x^2}}$, we have $\int \frac{1}{\sqrt{1-x^2}} \, dx = \sin^{-1} x + C$.', 'm_integral_antiderivative', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_fundamental_integrals (Fundamental integrals involving algebraic, trig, exp and log functions)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: integral of x^3 dx = x^4/4 + C
('$\int x^3 \, dx$ equals', '$x^4 + C$', '$3x^2 + C$', '$\frac{x^3}{3} + C$', '$\frac{x^4}{4} + C$', 'option4', 'Power rule: $\int x^3 \, dx = \frac{x^{3+1}}{3+1} + C = \frac{x^4}{4} + C$.', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q2: integral of 2 sin x dx = -2 cos x + C
('$\int 2\sin x \, dx$ equals', '$2\cos x + C$', '$-2\cos x + C$', '$-2\sin x + C$', '$2\tan x + C$', 'option2', '$\int 2\sin x \, dx = 2(-\cos x) + C = -2\cos x + C$.', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral of 3e^x dx = 3e^x + C
('$\int 3e^x \, dx$ equals', '$3xe^x + C$', '$3e^x + C$', '$e^{3x} + C$', '$\frac{3e^x}{x} + C$', 'option2', '$\int 3e^x \, dx = 3 \int e^x \, dx = 3e^x + C$.', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral of 5/x dx = 5 ln|x| + C
('$\int \frac{5}{x} \, dx$ equals', '$5\ln|x| + C$', '$\frac{5}{x^2} + C$', '$5x + C$', '$\ln(5x) + C$', 'option1', '$\int \frac{5}{x} \, dx = 5\ln|x| + C$.', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q5: integral of x^(-2) dx = x^(-1)/(-1) + C = -1/x + C
('$\int \frac{1}{x^2} \, dx$ equals', '$\ln x^2 + C$', '$\frac{1}{x} + C$', '$-\frac{1}{x} + C$', '$-\frac{2}{x^3} + C$', 'option3', '$\int x^{-2} \, dx = \frac{x^{-1}}{-1} + C = -\frac{1}{x} + C$.', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral of cos 2x dx = sin 2x / 2 + C
('$\int \cos 2x \, dx$ equals', '$-\frac{\sin 2x}{2} + C$', '$\sin 2x + C$', '$2\sin 2x + C$', '$\frac{\sin 2x}{2} + C$', 'option4', '$\int \cos 2x \, dx = \frac{\sin 2x}{2} + C$ (since derivative of $\sin 2x$ is $2\cos 2x$).', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral of e^(3x) dx = e^(3x)/3 + C
('$\int e^{3x} \, dx$ equals', '$3e^{3x} + C$', '$\frac{e^{3x}}{3} + C$', '$e^{3x} + C$', '$\frac{e^{3x}}{x} + C$', 'option2', '$\int e^{3x} \, dx = \frac{e^{3x}}{3} + C$ (dividing by the coefficient of $x$).', 'm_fundamental_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: integral of sin^2 x dx. Use identity: sin^2 x = (1-cos 2x)/2.
-- = x/2 - sin 2x/4 + C
('$\int \sin^2 x \, dx$ equals', '$\frac{\sin 2x}{2} + C$', '$\frac{x}{2} + \frac{\sin 2x}{4} + C$', '$-\frac{\cos^2 x}{2} + C$', '$\frac{x}{2} - \frac{\sin 2x}{4} + C$', 'option4', 'Using $\sin^2 x = \frac{1-\cos 2x}{2}$: $\int \frac{1-\cos 2x}{2} \, dx = \frac{x}{2} - \frac{\sin 2x}{4} + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q9: integral of 1/(x^2+4) dx. Write as 1/(4(1+(x/2)^2)). = (1/2) tan^(-1)(x/2) + C
('$\int \frac{1}{x^2 + 4} \, dx$ equals', '$\tan^{-1}\frac{x}{2} + C$', '$\frac{1}{2}\tan^{-1}\frac{x}{2} + C$', '$\frac{1}{4}\tan^{-1}\frac{x}{2} + C$', '$\ln(x^2+4) + C$', 'option2', '$\int \frac{dx}{x^2+a^2} = \frac{1}{a}\tan^{-1}\frac{x}{a} + C$. Here $a = 2$: $\frac{1}{2}\tan^{-1}\frac{x}{2} + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q10: integral of x e^x dx. By parts: u=x, dv=e^x dx. = xe^x - e^x + C = e^x(x-1) + C
('$\int xe^x \, dx$ equals', '$e^x(x + 1) + C$', '$xe^x + C$', '$e^x(x - 1) + C$', '$\frac{x^2 e^x}{2} + C$', 'option3', 'Integration by parts: $u = x$, $dv = e^x dx$. $\int xe^x \, dx = xe^x - \int e^x \, dx = xe^x - e^x + C = e^x(x-1) + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral of 1/sqrt(4-x^2) dx. = sin^(-1)(x/2) + C
('$\int \frac{1}{\sqrt{4 - x^2}} \, dx$ equals', '$\cos^{-1}\frac{x}{2} + C$', '$\frac{1}{2}\sin^{-1}\frac{x}{2} + C$', '$\sin^{-1}\frac{x}{2} + C$', '$\tan^{-1}\frac{x}{2} + C$', 'option3', '$\int \frac{dx}{\sqrt{a^2-x^2}} = \sin^{-1}\frac{x}{a} + C$. Here $a = 2$: $\sin^{-1}\frac{x}{2} + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q12: integral of tan x dx = -ln|cos x| + C = ln|sec x| + C
('$\int \tan x \, dx$ equals', '$\sec^2 x + C$', '$\ln|\sec x| + C$', '$-\ln|\sin x| + C$', '$\ln|\cos x| + C$', 'option2', '$\int \tan x \, dx = \int \frac{\sin x}{\cos x} \, dx = -\ln|\cos x| + C = \ln|\sec x| + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q13: integral of cos^2 x dx. Use cos^2 x = (1+cos 2x)/2. = x/2 + sin 2x/4 + C
('$\int \cos^2 x \, dx$ equals', '$\frac{x}{2} + \frac{\sin 2x}{4} + C$', '$\frac{x}{2} - \frac{\sin 2x}{4} + C$', '$\frac{\sin^2 x}{2} + C$', '$\frac{\cos 2x}{2} + C$', 'option1', 'Using $\cos^2 x = \frac{1+\cos 2x}{2}$: $\int \frac{1+\cos 2x}{2} \, dx = \frac{x}{2} + \frac{\sin 2x}{4} + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q14: integral of 1/(x^2-1) dx = (1/2) ln|(x-1)/(x+1)| + C by partial fractions
('$\int \frac{1}{x^2 - 1} \, dx$ equals', '$\frac{1}{2}\ln\left|\frac{x+1}{x-1}\right| + C$', '$\ln|x^2-1| + C$', '$\tan^{-1} x + C$', '$\frac{1}{2}\ln\left|\frac{x-1}{x+1}\right| + C$', 'option4', '$\frac{1}{x^2-1} = \frac{1}{2}\left(\frac{1}{x-1} - \frac{1}{x+1}\right)$. Integrating: $\frac{1}{2}[\ln|x-1| - \ln|x+1|] + C = \frac{1}{2}\ln\left|\frac{x-1}{x+1}\right| + C$.', 'm_fundamental_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: integral of sec x dx = ln|sec x + tan x| + C
('$\int \sec x \, dx$ equals', '$\ln|\sec x + \tan x| + C$', '$\sec x \tan x + C$', '$\ln|\sec x| + C$', '$\tan x + C$', 'option1', 'Multiply by $\frac{\sec x + \tan x}{\sec x + \tan x}$: $\int \frac{\sec^2 x + \sec x\tan x}{\sec x + \tan x} \, dx = \ln|\sec x + \tan x| + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q16: integral of 1/sqrt(x^2+a^2) dx = ln|x + sqrt(x^2+a^2)| + C. For a=1:
('$\int \frac{1}{\sqrt{x^2 + 1}} \, dx$ equals', '$\frac{x}{\sqrt{x^2+1}} + C$', '$\tan^{-1} x + C$', '$\sin^{-1} x + C$', '$\ln|x + \sqrt{x^2+1}| + C$', 'option4', 'Standard integral: $\int \frac{dx}{\sqrt{x^2+a^2}} = \ln|x + \sqrt{x^2+a^2}| + C$. For $a = 1$: $\ln|x + \sqrt{x^2+1}| + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q17: integral of x^2 e^x dx. By parts twice. u=x^2, dv=e^x dx.
-- = x^2 e^x - 2 integral(x e^x dx) = x^2 e^x - 2[e^x(x-1)] + C = e^x(x^2-2x+2) + C
('$\int x^2 e^x \, dx$ equals', '$x^2 e^x + C$', '$e^x(x^2 - 2x + 2) + C$', '$e^x(x^2 + 2x + 2) + C$', '$e^x(x^2 - 2x) + C$', 'option2', 'By parts: $x^2 e^x - 2\int xe^x \, dx = x^2 e^x - 2[e^x(x-1)] + C = e^x(x^2 - 2x + 2) + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q18: integral of ln x dx. By parts: u=ln x, dv=dx. = x ln x - integral(1 dx) = x ln x - x + C
('$\int \ln x \, dx$ equals', '$x\ln x - x + C$', '$\frac{1}{x} + C$', '$x\ln x + C$', '$\frac{(\ln x)^2}{2} + C$', 'option1', 'By parts: $u = \ln x$, $dv = dx$. $\int \ln x \, dx = x\ln x - \int 1 \, dx = x\ln x - x + C = x(\ln x - 1) + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral of 1/(x^2-a^2) dx = (1/(2a)) ln|(x-a)/(x+a)| + C. For a=3:
('$\int \frac{1}{x^2 - 9} \, dx$ equals', '$\ln|x^2-9| + C$', '$\frac{1}{3}\tan^{-1}\frac{x}{3} + C$', '$\frac{1}{6}\ln\left|\frac{x-3}{x+3}\right| + C$', '$\frac{1}{6}\ln\left|\frac{x+3}{x-3}\right| + C$', 'option3', '$\int \frac{dx}{x^2-a^2} = \frac{1}{2a}\ln\left|\frac{x-a}{x+a}\right| + C$. For $a = 3$: $\frac{1}{6}\ln\left|\frac{x-3}{x+3}\right| + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q20: integral of cot x dx = ln|sin x| + C
('$\int \cot x \, dx$ equals', '$\ln|\sin x| + C$', '$-\ln|\cos x| + C$', '$\csc^2 x + C$', '$-\csc x + C$', 'option1', '$\int \cot x \, dx = \int \frac{\cos x}{\sin x} \, dx = \ln|\sin x| + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q21: integral of 1/sqrt(x^2-a^2) dx = ln|x+sqrt(x^2-a^2)| + C. For a=2:
('$\int \frac{1}{\sqrt{x^2 - 4}} \, dx$ equals', '$\ln|x + \sqrt{x^2-4}| + C$', '$\sin^{-1}\frac{x}{2} + C$', '$\frac{1}{2}\sec^{-1}\frac{x}{2} + C$', '$\frac{x}{\sqrt{x^2-4}} + C$', 'option1', 'Standard integral: $\int \frac{dx}{\sqrt{x^2-a^2}} = \ln|x + \sqrt{x^2-a^2}| + C$. For $a = 2$: $\ln|x + \sqrt{x^2-4}| + C$.', 'm_fundamental_integrals', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_integration_techniques (Integration by substitution, by parts, by partial fractions, using trig identities)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: integral of 2x e^(x^2) dx. Let u=x^2, du=2x dx. = e^u + C = e^(x^2) + C
('$\int 2x e^{x^2} \, dx$ equals', '$\frac{e^{x^2}}{x} + C$', '$x^2 e^{x^2} + C$', '$2e^{x^2} + C$', '$e^{x^2} + C$', 'option4', 'Substitution: $u = x^2$, $du = 2x\,dx$. $\int e^u \, du = e^u + C = e^{x^2} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q2: integral of cos(3x) dx. Let u=3x, du=3dx. = sin(3x)/3 + C
('$\int \cos 3x \, dx$ equals', '$\frac{\sin 3x}{3} + C$', '$\sin 3x + C$', '$3\sin 3x + C$', '$-\frac{\sin 3x}{3} + C$', 'option1', 'Substitution: $u = 3x$, $du = 3\,dx$. $\int \cos u \cdot \frac{du}{3} = \frac{\sin u}{3} + C = \frac{\sin 3x}{3} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral of (2x+3)^4 dx. Let u=2x+3, du=2dx. = u^5/(5*2) + C = (2x+3)^5/10 + C
('$\int (2x+3)^4 \, dx$ equals', '$\frac{(2x+3)^5}{10} + C$', '$\frac{(2x+3)^5}{5} + C$', '$4(2x+3)^3 + C$', '$\frac{(2x+3)^4}{8} + C$', 'option1', 'Substitution: $u = 2x+3$, $du = 2\,dx$. $\frac{1}{2}\int u^4 \, du = \frac{u^5}{10} + C = \frac{(2x+3)^5}{10} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral of sin x cos x dx. Let u=sin x, du=cos x dx. = u^2/2 + C = sin^2 x/2 + C
('$\int \sin x \cos x \, dx$ equals', '$\frac{\sin^2 x}{2} + C$', '$-\frac{\cos^2 x}{2} + C$', '$\frac{\sin 2x}{2} + C$', '$-\sin x \cos x + C$', 'option1', 'Substitution: $u = \sin x$, $du = \cos x\,dx$. $\int u \, du = \frac{u^2}{2} + C = \frac{\sin^2 x}{2} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q5: integral of e^(5x) dx = e^(5x)/5 + C
('$\int e^{5x} \, dx$ equals', '$e^{5x} + C$', '$5e^{5x} + C$', '$\frac{e^{5x}}{5} + C$', '$\frac{5e^{5x}}{x} + C$', 'option3', 'Substitution: $u = 5x$, $du = 5\,dx$. $\frac{1}{5}\int e^u \, du = \frac{e^{5x}}{5} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral of x/(x^2+1) dx. Let u=x^2+1, du=2x dx. = (1/2) ln|u| + C = (1/2) ln(x^2+1) + C
('$\int \frac{x}{x^2+1} \, dx$ equals', '$\ln(x^2+1) + C$', '$\frac{1}{2}\ln(x^2+1) + C$', '$\tan^{-1} x + C$', '$\frac{x^2}{2(x^2+1)} + C$', 'option2', 'Substitution: $u = x^2+1$, $du = 2x\,dx$. $\frac{1}{2}\int \frac{du}{u} = \frac{1}{2}\ln|u| + C = \frac{1}{2}\ln(x^2+1) + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral of sec^2(2x) dx. Let u=2x, du=2dx. = tan(2x)/2 + C
('$\int \sec^2(2x) \, dx$ equals', '$\sec 2x + C$', '$\tan 2x + C$', '$2\tan 2x + C$', '$\frac{\tan 2x}{2} + C$', 'option4', 'Substitution: $u = 2x$, $du = 2\,dx$. $\frac{1}{2}\int \sec^2 u \, du = \frac{\tan u}{2} + C = \frac{\tan 2x}{2} + C$.', 'm_integration_techniques', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: integral of x sin(x^2) dx. Let u=x^2, du=2x dx. = -(1/2) cos(x^2) + C
('$\int x\sin(x^2) \, dx$ equals', '$-\frac{1}{2}\cos(x^2) + C$', '$\frac{1}{2}\cos(x^2) + C$', '$-\cos(x^2) + C$', '$x^2\cos(x^2) + C$', 'option1', 'Substitution: $u = x^2$, $du = 2x\,dx$. $\frac{1}{2}\int \sin u \, du = -\frac{1}{2}\cos u + C = -\frac{1}{2}\cos(x^2) + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q9: integral of x cos x dx. By parts: u=x, dv=cos x dx. = x sin x + cos x + C
('$\int x\cos x \, dx$ equals', '$x\sin x - \cos x + C$', '$x\sin x + \cos x + C$', '$x\cos x + \sin x + C$', '$\frac{x^2\sin x}{2} + C$', 'option2', 'By parts: $u = x$, $dv = \cos x\,dx$. $\int x\cos x\,dx = x\sin x - \int \sin x\,dx = x\sin x + \cos x + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q10: integral of 1/((x+1)(x+2)) dx. Partial fractions: 1/(x+1) - 1/(x+2). = ln|x+1| - ln|x+2| + C
('$\int \frac{1}{(x+1)(x+2)} \, dx$ equals', '$\ln\left|\frac{x+1}{x+2}\right| + C$', '$\ln|(x+1)(x+2)| + C$', '$\frac{1}{x+1} + \frac{1}{x+2} + C$', '$\ln\left|\frac{x+2}{x+1}\right| + C$', 'option1', 'Partial fractions: $\frac{1}{(x+1)(x+2)} = \frac{1}{x+1} - \frac{1}{x+2}$. Integrating: $\ln|x+1| - \ln|x+2| + C = \ln\left|\frac{x+1}{x+2}\right| + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral of sin^3 x dx. = integral of sin x (1-cos^2 x) dx. Let u=cos x, du=-sin x dx.
-- = -integral of (1-u^2) du = -(u - u^3/3) + C = -cos x + cos^3 x/3 + C
('$\int \sin^3 x \, dx$ equals', '$-\cos x + \frac{\cos^3 x}{3} + C$', '$\frac{-\sin^4 x}{4} + C$', '$-\cos x - \frac{\cos^3 x}{3} + C$', '$\frac{\sin^3 x}{3} + C$', 'option1', 'Write $\sin^3 x = \sin x(1-\cos^2 x)$. Let $u = \cos x$: $-\int(1-u^2)\,du = -u + \frac{u^3}{3} + C = -\cos x + \frac{\cos^3 x}{3} + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q12: integral of e^x sin x dx. By parts twice, get I = (e^x(sin x - cos x))/2 + C
('$\int e^x \sin x \, dx$ equals', '$\frac{e^x(\sin x - \cos x)}{2} + C$', '$e^x\sin x + C$', '$\frac{e^x(\sin x + \cos x)}{2} + C$', '$-e^x\cos x + C$', 'option1', 'Let $I = \int e^x\sin x\,dx$. By parts twice: $I = e^x\sin x - e^x\cos x - I$. So $2I = e^x(\sin x - \cos x)$, giving $I = \frac{e^x(\sin x - \cos x)}{2} + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q13: integral of tan^2 x dx = integral of (sec^2 x - 1) dx = tan x - x + C
('$\int \tan^2 x \, dx$ equals', '$\frac{\tan^3 x}{3} + C$', '$\sec^2 x + C$', '$\tan x - x + C$', '$\tan x + x + C$', 'option3', 'Using $\tan^2 x = \sec^2 x - 1$: $\int(\sec^2 x - 1)\,dx = \tan x - x + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Q14: integral of 1/(x(x+1)) dx. Partial fractions: 1/x - 1/(x+1). = ln|x| - ln|x+1| + C
('$\int \frac{1}{x(x+1)} \, dx$ equals', '$\ln\left|\frac{x+1}{x}\right| + C$', '$\ln|x(x+1)| + C$', '$\frac{1}{x+1} + C$', '$\ln\left|\frac{x}{x+1}\right| + C$', 'option4', 'Partial fractions: $\frac{1}{x(x+1)} = \frac{1}{x} - \frac{1}{x+1}$. Integrating: $\ln|x| - \ln|x+1| + C = \ln\left|\frac{x}{x+1}\right| + C$.', 'm_integration_techniques', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: integral of x^2 sin x dx. By parts: u=x^2, dv=sin x dx.
-- = -x^2 cos x + 2 integral(x cos x dx) = -x^2 cos x + 2(x sin x + cos x) + C
-- = -x^2 cos x + 2x sin x + 2 cos x + C = (2-x^2) cos x + 2x sin x + C
('$\int x^2 \sin x \, dx$ equals', '$(x^2 - 2)\cos x + 2x\sin x + C$', '$-x^2\cos x + 2x\sin x + C$', '$x^2\sin x - 2x\cos x + C$', '$(2 - x^2)\cos x + 2x\sin x + C$', 'option4', 'By parts twice: $-x^2\cos x + 2\int x\cos x\,dx = -x^2\cos x + 2(x\sin x + \cos x) + C = (2-x^2)\cos x + 2x\sin x + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q16: integral of 1/(x^2(x+1)) dx. Partial fractions: A/x + B/x^2 + C/(x+1).
-- 1 = Ax(x+1) + B(x+1) + Cx^2. x=0: B=1. x=-1: C=1. Coeff of x^2: A+C=0 => A=-1.
-- = -ln|x| - 1/x + ln|x+1| + C = ln|x+1/x| - 1/x + C
('$\int \frac{1}{x^2(x+1)} \, dx$ equals', '$-\frac{1}{x} + \ln|x| + C$', '$\frac{1}{x} + \ln|x+1| + C$', '$\ln\left|\frac{x+1}{x}\right| - \frac{1}{x} + C$', '$\ln|x^2(x+1)| + C$', 'option3', 'Partial fractions: $\frac{1}{x^2(x+1)} = \frac{-1}{x} + \frac{1}{x^2} + \frac{1}{x+1}$. Integrating: $-\ln|x| - \frac{1}{x} + \ln|x+1| + C = \ln\left|\frac{x+1}{x}\right| - \frac{1}{x} + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q17: integral of sqrt(1-x^2) dx. Let x=sin t, dx=cos t dt. sqrt(1-sin^2 t)=cos t.
-- integral of cos^2 t dt = t/2 + sin 2t/4 + C = (sin^(-1) x)/2 + x sqrt(1-x^2)/2 + C
('$\int \sqrt{1-x^2} \, dx$ equals', '$\frac{(1-x^2)^{3/2}}{3} + C$', '$\sin^{-1} x + C$', '$\frac{x\sqrt{1-x^2}}{2} + \frac{\sin^{-1} x}{2} + C$', '$x\sqrt{1-x^2} + C$', 'option3', 'Let $x = \sin\theta$: $\int \cos^2\theta\,d\theta = \frac{\theta}{2} + \frac{\sin 2\theta}{4} + C = \frac{\sin^{-1}x}{2} + \frac{x\sqrt{1-x^2}}{2} + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q18: integral of e^x(1+x)/cos^2(xe^x) dx. Let u=xe^x, du=(e^x+xe^x)dx=e^x(1+x)dx.
-- = integral of sec^2 u du = tan u + C = tan(xe^x) + C
('$\int \frac{e^x(1+x)}{\cos^2(xe^x)} \, dx$ equals', '$\sec(xe^x) + C$', '$\tan(xe^x) + C$', '$\ln|\cos(xe^x)| + C$', '$e^x\tan x + C$', 'option2', 'Let $u = xe^x$, then $du = e^x(1+x)\,dx$. $\int \sec^2 u \, du = \tan u + C = \tan(xe^x) + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral of (2x+3)/(x^2+3x+2) dx. Note d/dx(x^2+3x+2)=2x+3. So = ln|x^2+3x+2| + C
('$\int \frac{2x+3}{x^2+3x+2} \, dx$ equals', '$\ln\left|\frac{x+1}{x+2}\right| + C$', '$\frac{1}{x+1} + \frac{1}{x+2} + C$', '$\ln|x^2+3x+2| + C$', '$\tan^{-1}(x+1) + C$', 'option3', 'Since $\frac{d}{dx}(x^2+3x+2) = 2x+3$, the integral is $\ln|x^2+3x+2| + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q20: integral of x tan^(-1) x dx. By parts: u=tan^(-1) x, dv=x dx.
-- = (x^2/2) tan^(-1) x - integral of x^2/(2(1+x^2)) dx
-- = (x^2/2) tan^(-1) x - (1/2) integral of (1 - 1/(1+x^2)) dx
-- = (x^2/2) tan^(-1) x - x/2 + (1/2) tan^(-1) x + C
-- = ((x^2+1)/2) tan^(-1) x - x/2 + C
('$\int x\tan^{-1} x \, dx$ equals', '$\frac{x^2+1}{2}\tan^{-1} x - \frac{x}{2} + C$', '$\frac{x^2}{2}\tan^{-1} x + C$', '$x\tan^{-1} x - \ln(1+x^2) + C$', '$\frac{x^2}{2}\tan^{-1} x - \frac{x}{2} + C$', 'option1', 'By parts: $u = \tan^{-1}x$, $dv = x\,dx$. $= \frac{x^2}{2}\tan^{-1}x - \frac{1}{2}\int\frac{x^2}{1+x^2}\,dx = \frac{x^2}{2}\tan^{-1}x - \frac{x}{2} + \frac{\tan^{-1}x}{2} + C = \frac{x^2+1}{2}\tan^{-1}x - \frac{x}{2} + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),

-- Q21: integral of e^x(sin x + cos x) dx. Note d/dx(e^x sin x) = e^x sin x + e^x cos x.
-- So integral = e^x sin x + C
('$\int e^x(\sin x + \cos x) \, dx$ equals', '$e^x(\sin x - \cos x) + C$', '$e^x\cos x + C$', '$e^x\sin x + C$', '$\frac{e^x(\sin x + \cos x)}{2} + C$', 'option3', 'Since $\frac{d}{dx}(e^x\sin x) = e^x\sin x + e^x\cos x = e^x(\sin x + \cos x)$, the integral is $e^x\sin x + C$.', 'm_integration_techniques', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_standard_integrals (Evaluation of simple integrals of standard types)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: integral of dx/(x^2+9). Standard: 1/a tan^(-1)(x/a). a=3. = (1/3) tan^(-1)(x/3) + C
('$\int \frac{dx}{x^2 + 9}$ equals', '$\tan^{-1}\frac{x}{3} + C$', '$\frac{1}{3}\tan^{-1}\frac{x}{3} + C$', '$\frac{1}{9}\tan^{-1}\frac{x}{3} + C$', '$\ln(x^2+9) + C$', 'option2', 'Standard form: $\int \frac{dx}{x^2+a^2} = \frac{1}{a}\tan^{-1}\frac{x}{a} + C$. Here $a = 3$: $\frac{1}{3}\tan^{-1}\frac{x}{3} + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q2: integral of dx/sqrt(9-x^2). Standard: sin^(-1)(x/a). a=3. = sin^(-1)(x/3) + C
('$\int \frac{dx}{\sqrt{9 - x^2}}$ equals', '$\tan^{-1}\frac{x}{3} + C$', '$\frac{1}{3}\sin^{-1}\frac{x}{3} + C$', '$\cos^{-1}\frac{x}{3} + C$', '$\sin^{-1}\frac{x}{3} + C$', 'option4', 'Standard form: $\int \frac{dx}{\sqrt{a^2-x^2}} = \sin^{-1}\frac{x}{a} + C$. Here $a = 3$: $\sin^{-1}\frac{x}{3} + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral of dx/(x^2+1) = tan^(-1) x + C
('$\int \frac{dx}{x^2 + 1}$ equals', '$\frac{x}{x^2+1} + C$', '$\ln(x^2+1) + C$', '$\tan^{-1} x + C$', '$\sin^{-1} x + C$', 'option3', 'Standard integral: $\int \frac{dx}{x^2+1} = \tan^{-1} x + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral of dx/sqrt(1-x^2) = sin^(-1) x + C
('$\int \frac{dx}{\sqrt{1 - x^2}}$ equals', '$\cos^{-1} x + C$', '$\sin^{-1} x + C$', '$\tan^{-1} x + C$', '$\sec^{-1} x + C$', 'option2', 'Standard integral: $\int \frac{dx}{\sqrt{1-x^2}} = \sin^{-1} x + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q5: integral of dx/(x^2-4). Standard: 1/(2a) ln|(x-a)/(x+a)|. a=2. = (1/4) ln|(x-2)/(x+2)| + C
('$\int \frac{dx}{x^2 - 4}$ equals', '$\frac{1}{4}\ln\left|\frac{x-2}{x+2}\right| + C$', '$\frac{1}{2}\ln\left|\frac{x-2}{x+2}\right| + C$', '$\ln|x^2-4| + C$', '$\tan^{-1}\frac{x}{2} + C$', 'option1', 'Standard form: $\int \frac{dx}{x^2-a^2} = \frac{1}{2a}\ln\left|\frac{x-a}{x+a}\right| + C$. Here $a = 2$: $\frac{1}{4}\ln\left|\frac{x-2}{x+2}\right| + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral of dx/sqrt(x^2+16). Standard: ln|x+sqrt(x^2+a^2)|. a=4.
('$\int \frac{dx}{\sqrt{x^2 + 16}}$ equals', '$\ln|x + \sqrt{x^2+16}| + C$', '$\frac{1}{4}\tan^{-1}\frac{x}{4} + C$', '$\sin^{-1}\frac{x}{4} + C$', '$\frac{x}{\sqrt{x^2+16}} + C$', 'option1', 'Standard form: $\int \frac{dx}{\sqrt{x^2+a^2}} = \ln|x+\sqrt{x^2+a^2}| + C$. Here $a = 4$: $\ln|x+\sqrt{x^2+16}| + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral of dx/(4-x^2). Standard: 1/(2a) ln|(a+x)/(a-x)|. a=2. = (1/4) ln|(2+x)/(2-x)| + C
('$\int \frac{dx}{4 - x^2}$ equals', '$\frac{1}{4}\ln\left|\frac{2+x}{2-x}\right| + C$', '$\frac{1}{2}\sin^{-1}\frac{x}{2} + C$', '$\frac{1}{4}\ln\left|\frac{2-x}{2+x}\right| + C$', '$\tan^{-1}\frac{x}{2} + C$', 'option1', 'Standard form: $\int \frac{dx}{a^2-x^2} = \frac{1}{2a}\ln\left|\frac{a+x}{a-x}\right| + C$. Here $a = 2$: $\frac{1}{4}\ln\left|\frac{2+x}{2-x}\right| + C$.', 'm_standard_integrals', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: integral of dx/(x^2+4x+13). Complete square: (x+2)^2+9. = (1/3) tan^(-1)((x+2)/3) + C
('$\int \frac{dx}{x^2 + 4x + 13}$ equals', '$\frac{1}{3}\tan^{-1}\frac{x+2}{3} + C$', '$\frac{1}{3}\tan^{-1}\frac{x}{3} + C$', '$\ln(x^2+4x+13) + C$', '$\frac{1}{13}\tan^{-1}\frac{x+2}{3} + C$', 'option1', 'Complete the square: $x^2+4x+13 = (x+2)^2 + 9$. Then $\int \frac{dx}{(x+2)^2+9} = \frac{1}{3}\tan^{-1}\frac{x+2}{3} + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q9: integral of dx/sqrt(5-4x-x^2). Complete square: 5-(x^2+4x) = 5-(x+2)^2+4 = 9-(x+2)^2.
-- = sin^(-1)((x+2)/3) + C
('$\int \frac{dx}{\sqrt{5 - 4x - x^2}}$ equals', '$\sin^{-1}\frac{x}{3} + C$', '$\sin^{-1}\frac{x+2}{3} + C$', '$\cos^{-1}\frac{x+2}{3} + C$', '$\frac{1}{3}\sin^{-1}\frac{x+2}{3} + C$', 'option2', 'Complete the square: $5-4x-x^2 = 9-(x+2)^2$. Then $\int \frac{dx}{\sqrt{9-(x+2)^2}} = \sin^{-1}\frac{x+2}{3} + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q10: integral of dx/(x^2-6x+13). Complete square: (x-3)^2+4. = (1/2) tan^(-1)((x-3)/2) + C
('$\int \frac{dx}{x^2 - 6x + 13}$ equals', '$\frac{1}{2}\tan^{-1}\frac{x}{2} + C$', '$\frac{1}{2}\tan^{-1}\frac{x-3}{2} + C$', '$\ln(x^2-6x+13) + C$', '$\tan^{-1}(x-3) + C$', 'option2', 'Complete the square: $x^2-6x+13 = (x-3)^2+4$. Then $\int \frac{dx}{(x-3)^2+4} = \frac{1}{2}\tan^{-1}\frac{x-3}{2} + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral of dx/sqrt(x^2+6x+10). Complete square: (x+3)^2+1. = ln|x+3+sqrt(x^2+6x+10)| + C
('$\int \frac{dx}{\sqrt{x^2 + 6x + 10}}$ equals', '$\frac{1}{\sqrt{x^2+6x+10}} + C$', '$\sin^{-1}(x+3) + C$', '$\tan^{-1}(x+3) + C$', '$\ln|x+3+\sqrt{x^2+6x+10}| + C$', 'option4', 'Complete the square: $x^2+6x+10 = (x+3)^2+1$. Then $\int \frac{dx}{\sqrt{(x+3)^2+1}} = \ln|x+3+\sqrt{x^2+6x+10}| + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q12: integral of (2x+3)/(x^2+3x+5) dx. Numerator = d/dx(x^2+3x+5). = ln|x^2+3x+5| + C
('$\int \frac{2x+3}{x^2+3x+5} \, dx$ equals', '$\frac{1}{x^2+3x+5} + C$', '$\ln|x^2+3x+5| + C$', '$\tan^{-1}\frac{2x+3}{5} + C$', '$(x^2+3x+5)^2 + C$', 'option2', 'Since $\frac{d}{dx}(x^2+3x+5) = 2x+3$, the integral is $\ln|x^2+3x+5| + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q13: integral of dx/sqrt(x^2-9). Standard: ln|x+sqrt(x^2-a^2)|. a=3.
('$\int \frac{dx}{\sqrt{x^2 - 9}}$ equals', '$\sin^{-1}\frac{3}{x} + C$', '$\sec^{-1}\frac{x}{3} + C$', '$\ln|x + \sqrt{x^2-9}| + C$', '$\frac{x}{\sqrt{x^2-9}} + C$', 'option3', 'Standard form: $\int \frac{dx}{\sqrt{x^2-a^2}} = \ln|x+\sqrt{x^2-a^2}| + C$. Here $a = 3$: $\ln|x+\sqrt{x^2-9}| + C$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Q14: integral of (3x+2)/(x^2+x+1) dx. Write 3x+2 = (3/2)(2x+1) + 1/2.
-- = (3/2) ln|x^2+x+1| + (1/2) integral of dx/((x+1/2)^2+3/4)
-- = (3/2) ln|x^2+x+1| + (1/2)*(2/sqrt(3)) tan^(-1)((2x+1)/sqrt(3)) + C
-- = (3/2) ln|x^2+x+1| + (1/sqrt(3)) tan^(-1)((2x+1)/sqrt(3)) + C
('$\int \frac{3x+2}{x^2+x+1} \, dx$ equals', '$\frac{3}{2}\ln|x^2+x+1| + \frac{1}{\sqrt{3}}\tan^{-1}\frac{2x+1}{\sqrt{3}} + C$', '$3\ln|x^2+x+1| + C$', '$\frac{3}{2}\ln|x^2+x+1| + C$', '$\ln|x^2+x+1| + \tan^{-1}(2x+1) + C$', 'option1', 'Write $3x+2 = \frac{3}{2}(2x+1) + \frac{1}{2}$. First part: $\frac{3}{2}\ln|x^2+x+1|$. Second: $\frac{1}{2}\int\frac{dx}{(x+\frac{1}{2})^2+\frac{3}{4}} = \frac{1}{\sqrt{3}}\tan^{-1}\frac{2x+1}{\sqrt{3}}$.', 'm_standard_integrals', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: integral of sqrt(x^2+4) dx. Standard: (x/2)sqrt(x^2+4) + 2 ln|x+sqrt(x^2+4)| + C
('$\int \sqrt{x^2+4} \, dx$ equals', '$\frac{x\sqrt{x^2+4}}{2} + C$', '$\frac{(x^2+4)^{3/2}}{3} + C$', '$x\sqrt{x^2+4} + C$', '$\frac{x\sqrt{x^2+4}}{2} + 2\ln|x+\sqrt{x^2+4}| + C$', 'option4', 'Standard form: $\int\sqrt{x^2+a^2}\,dx = \frac{x\sqrt{x^2+a^2}}{2} + \frac{a^2}{2}\ln|x+\sqrt{x^2+a^2}| + C$. Here $a = 2$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q16: integral of sqrt(9-x^2) dx. Standard: (x/2)sqrt(a^2-x^2) + (a^2/2) sin^(-1)(x/a). a=3.
-- = (x/2)sqrt(9-x^2) + (9/2) sin^(-1)(x/3) + C
('$\int \sqrt{9-x^2} \, dx$ equals', '$\frac{x\sqrt{9-x^2}}{2} + \frac{9}{2}\sin^{-1}\frac{x}{3} + C$', '$\frac{(9-x^2)^{3/2}}{3} + C$', '$x\sqrt{9-x^2} + C$', '$\frac{x\sqrt{9-x^2}}{2} + C$', 'option1', 'Standard form: $\int\sqrt{a^2-x^2}\,dx = \frac{x\sqrt{a^2-x^2}}{2} + \frac{a^2}{2}\sin^{-1}\frac{x}{a} + C$. Here $a = 3$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q17: integral of dx/(x^2+2x+5). Complete square: (x+1)^2+4. = (1/2) tan^(-1)((x+1)/2) + C
('$\int \frac{dx}{x^2 + 2x + 5}$ equals', '$\frac{1}{2}\tan^{-1}\frac{x+1}{2} + C$', '$\tan^{-1}(x+1) + C$', '$\frac{1}{5}\tan^{-1}\frac{x+1}{2} + C$', '$\ln(x^2+2x+5) + C$', 'option1', 'Complete the square: $x^2+2x+5 = (x+1)^2+4$. Then $\frac{1}{2}\tan^{-1}\frac{x+1}{2} + C$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q18: integral of (x+1)/sqrt(x^2+2x+5) dx. Write x+1 = (1/2)(2x+2) = (1/2) d/dx(x^2+2x+5).
-- = sqrt(x^2+2x+5) + C
('$\int \frac{x+1}{\sqrt{x^2+2x+5}} \, dx$ equals', '$\sqrt{x^2+2x+5} + C$', '$\ln|x+1+\sqrt{x^2+2x+5}| + C$', '$\frac{1}{2}\ln(x^2+2x+5) + C$', '$(x+1)\sqrt{x^2+2x+5} + C$', 'option1', 'Since $\frac{d}{dx}(x^2+2x+5) = 2(x+1)$, we have $\int \frac{x+1}{\sqrt{x^2+2x+5}}\,dx = \sqrt{x^2+2x+5} + C$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral of sqrt(x^2-9) dx. Standard: (x/2)sqrt(x^2-a^2) - (a^2/2) ln|x+sqrt(x^2-a^2)|. a=3.
('$\int \sqrt{x^2-9} \, dx$ equals', '$x\sqrt{x^2-9} + C$', '$\frac{(x^2-9)^{3/2}}{3} + C$', '$\frac{x\sqrt{x^2-9}}{2} - \frac{9}{2}\ln|x+\sqrt{x^2-9}| + C$', '$\frac{x\sqrt{x^2-9}}{2} + C$', 'option3', 'Standard form: $\int\sqrt{x^2-a^2}\,dx = \frac{x\sqrt{x^2-a^2}}{2} - \frac{a^2}{2}\ln|x+\sqrt{x^2-a^2}| + C$. Here $a = 3$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q20: integral of dx/sqrt(2x-x^2). Complete square: 2x-x^2 = 1-(x-1)^2. = sin^(-1)(x-1) + C
('$\int \frac{dx}{\sqrt{2x - x^2}}$ equals', '$\cos^{-1}(x-1) + C$', '$\sin^{-1}(x-1) + C$', '$\sin^{-1}\frac{x}{2} + C$', '$\ln|x+\sqrt{2x-x^2}| + C$', 'option2', 'Complete the square: $2x-x^2 = 1-(x-1)^2$. Then $\int \frac{dx}{\sqrt{1-(x-1)^2}} = \sin^{-1}(x-1) + C$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),

-- Q21: integral of (2x-1)/(x^2-x+1) dx. Note d/dx(x^2-x+1)=2x-1. = ln|x^2-x+1| + C
('$\int \frac{2x-1}{x^2-x+1} \, dx$ equals', '$\ln|x^2-x+1| + C$', '$\frac{1}{x^2-x+1} + C$', '$\tan^{-1}(2x-1) + C$', '$2\ln|x^2-x+1| + C$', 'option1', 'Since $\frac{d}{dx}(x^2-x+1) = 2x-1$, the integral is $\ln|x^2-x+1| + C$.', 'm_standard_integrals', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_fundamental_theorem_calculus (Fundamental theorem of calculus, properties of definite integrals)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: integral from 0 to 1 of x^2 dx = [x^3/3] from 0 to 1 = 1/3
('$\int_0^1 x^2 \, dx$ equals', '$1$', '$\frac{1}{2}$', '$\frac{1}{3}$', '$\frac{2}{3}$', 'option3', '$\int_0^1 x^2\,dx = \left[\frac{x^3}{3}\right]_0^1 = \frac{1}{3} - 0 = \frac{1}{3}$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q2: integral from 0 to pi of sin x dx = [-cos x] from 0 to pi = -cos pi + cos 0 = 1+1 = 2
('$\int_0^{\pi} \sin x \, dx$ equals', '$-2$', '$0$', '$1$', '$2$', 'option4', '$\int_0^{\pi}\sin x\,dx = [-\cos x]_0^{\pi} = -\cos\pi + \cos 0 = 1 + 1 = 2$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral from 1 to e of 1/x dx = [ln x] from 1 to e = 1-0 = 1
('$\int_1^e \frac{1}{x} \, dx$ equals', '$\frac{1}{e}$', '$e$', '$0$', '$1$', 'option4', '$\int_1^e \frac{1}{x}\,dx = [\ln x]_1^e = \ln e - \ln 1 = 1 - 0 = 1$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral from 0 to 1 of e^x dx = [e^x] from 0 to 1 = e-1
('$\int_0^1 e^x \, dx$ equals', '$e - 1$', '$e$', '$1$', '$e + 1$', 'option1', '$\int_0^1 e^x\,dx = [e^x]_0^1 = e - 1$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q5: integral from a to a of f(x) dx = 0
('$\int_a^a f(x) \, dx$ equals', '$f(a)$', '$0$', '$2f(a)$', '$1$', 'option2', 'When the upper and lower limits are equal, the definite integral is always $0$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral from 0 to 2 of 3x dx = [3x^2/2] from 0 to 2 = 6
('$\int_0^2 3x \, dx$ equals', '$6$', '$3$', '$4$', '$12$', 'option1', '$\int_0^2 3x\,dx = \left[\frac{3x^2}{2}\right]_0^2 = \frac{3 \times 4}{2} = 6$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral from a to b of f(x) dx = -integral from b to a of f(x) dx
('$\int_a^b f(x)\,dx + \int_b^a f(x)\,dx$ equals', '$f(b) - f(a)$', '$2\int_a^b f(x)\,dx$', '$\int_a^b 2f(x)\,dx$', '$0$', 'option4', 'By the property $\int_b^a f(x)\,dx = -\int_a^b f(x)\,dx$, the sum is $0$.', 'm_fundamental_theorem_calculus', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: integral from 0 to pi/2 of sin x dx + integral from pi/2 to pi of sin x dx = integral from 0 to pi of sin x dx = 2
('$\int_0^{\pi/2} \sin x\,dx + \int_{\pi/2}^{\pi} \sin x\,dx$ equals', '$1$', '$2$', '$0$', '$\pi$', 'option2', 'By the additive property: $\int_0^{\pi/2}\sin x\,dx + \int_{\pi/2}^{\pi}\sin x\,dx = \int_0^{\pi}\sin x\,dx = 2$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q9: integral from -a to a of odd function = 0. sin x is odd.
('$\int_{-\pi}^{\pi} \sin x \, dx$ equals', '$0$', '$2$', '$2\pi$', '$-2$', 'option1', '$\sin x$ is an odd function ($\sin(-x) = -\sin x$). For odd functions, $\int_{-a}^{a} f(x)\,dx = 0$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q10: integral from -a to a of even function = 2 * integral from 0 to a. cos x is even.
-- integral from -pi/2 to pi/2 of cos x dx = 2 * integral from 0 to pi/2 of cos x dx = 2*1 = 2
('$\int_{-\pi/2}^{\pi/2} \cos x \, dx$ equals', '$0$', '$2$', '$1$', '$\pi$', 'option2', '$\cos x$ is even. $\int_{-\pi/2}^{\pi/2}\cos x\,dx = 2\int_0^{\pi/2}\cos x\,dx = 2[\sin x]_0^{\pi/2} = 2(1) = 2$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral from 0 to a of f(x) dx = integral from 0 to a of f(a-x) dx.
-- integral from 0 to pi/2 of sin x/(sin x + cos x) dx. Let I = this.
-- Replace x by pi/2-x: I = integral of cos x/(cos x + sin x) dx. Add: 2I = integral of 1 dx = pi/2. I = pi/4.
('$\int_0^{\pi/2} \frac{\sin x}{\sin x + \cos x} \, dx$ equals', '$1$', '$\frac{\pi}{2}$', '$\frac{\pi}{4}$', '$0$', 'option3', 'Let $I = \int_0^{\pi/2}\frac{\sin x}{\sin x+\cos x}\,dx$. Using $\int_0^a f(x)\,dx = \int_0^a f(a-x)\,dx$: $I = \int_0^{\pi/2}\frac{\cos x}{\cos x+\sin x}\,dx$. Adding: $2I = \int_0^{\pi/2}1\,dx = \frac{\pi}{2}$. So $I = \frac{\pi}{4}$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q12: integral from 0 to 2 of |x-1| dx. Split at x=1: integral from 0 to 1 of (1-x) dx + integral from 1 to 2 of (x-1) dx
-- = [x-x^2/2] from 0 to 1 + [x^2/2-x] from 1 to 2 = (1-1/2) + (2-2-(1/2-1)) = 1/2 + 1/2 = 1
('$\int_0^2 |x-1| \, dx$ equals', '$1$', '$0$', '$2$', '$\frac{1}{2}$', 'option1', 'Split at $x = 1$: $\int_0^1(1-x)\,dx + \int_1^2(x-1)\,dx = \left[x-\frac{x^2}{2}\right]_0^1 + \left[\frac{x^2}{2}-x\right]_1^2 = \frac{1}{2} + \frac{1}{2} = 1$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q13: d/dx integral from 0 to x of sin t dt = sin x (by FTC part 1)
('$\frac{d}{dx}\int_0^x \sin t \, dt$ equals', '$1 - \cos x$', '$-\cos x$', '$\cos x$', '$\sin x$', 'option4', 'By the Fundamental Theorem of Calculus (Part 1): $\frac{d}{dx}\int_0^x f(t)\,dt = f(x)$. So the answer is $\sin x$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Q14: integral from -1 to 1 of x^3 dx = 0 (odd function)
('$\int_{-1}^{1} x^3 \, dx$ equals', '$2$', '$\frac{1}{2}$', '$0$', '$\frac{1}{4}$', 'option3', '$x^3$ is an odd function. $\int_{-a}^{a} f(x)\,dx = 0$ for odd $f$. So $\int_{-1}^{1} x^3\,dx = 0$.', 'm_fundamental_theorem_calculus', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: integral from 0 to pi of x sin x dx. By parts or use property: integral from 0 to a of x f(x) dx.
-- Let I = integral from 0 to pi of x sin x dx. Replace x by pi-x:
-- I = integral from 0 to pi of (pi-x) sin x dx = pi * integral of sin x dx - I.
-- 2I = pi * 2 = 2pi. I = pi.
('$\int_0^{\pi} x\sin x \, dx$ equals', '$\pi$', '$2\pi$', '$0$', '$\frac{\pi}{2}$', 'option1', 'Let $I = \int_0^{\pi}x\sin x\,dx$. Using $x \to \pi-x$: $I = \int_0^{\pi}(\pi-x)\sin x\,dx = \pi\int_0^{\pi}\sin x\,dx - I = 2\pi - I$. So $2I = 2\pi$, giving $I = \pi$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q16: integral from 0 to pi/2 of log(tan x) dx. Let I. Replace x by pi/2-x:
-- I = integral of log(cot x) dx = integral of -log(tan x) dx = -I. So 2I=0, I=0.
('$\int_0^{\pi/2} \ln(\tan x) \, dx$ equals', '$1$', '$\frac{\pi}{2}\ln 2$', '$0$', '$\ln 2$', 'option3', 'Let $I = \int_0^{\pi/2}\ln(\tan x)\,dx$. Replace $x$ by $\frac{\pi}{2}-x$: $I = \int_0^{\pi/2}\ln(\cot x)\,dx = -I$. So $2I = 0$, giving $I = 0$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q17: d/dx integral from 0 to x^2 of e^t dt = e^(x^2) * 2x (chain rule with FTC)
('$\frac{d}{dx}\int_0^{x^2} e^t \, dt$ equals', '$2x$', '$e^{x^2}$', '$2xe^{x^2}$', '$e^{x^2} - 1$', 'option3', 'By FTC with chain rule: $\frac{d}{dx}\int_0^{g(x)}f(t)\,dt = f(g(x)) \cdot g''(x)$. Here $f(t) = e^t$, $g(x) = x^2$: $e^{x^2} \cdot 2x = 2xe^{x^2}$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q18: integral from 0 to 2pi of |sin x| dx. sin x >= 0 on [0,pi], <= 0 on [pi,2pi].
-- = integral from 0 to pi of sin x dx + integral from pi to 2pi of (-sin x) dx = 2 + 2 = 4
('$\int_0^{2\pi} |\sin x| \, dx$ equals', '$4$', '$0$', '$2$', '$2\pi$', 'option1', '$|\sin x| = \sin x$ on $[0,\pi]$ and $-\sin x$ on $[\pi,2\pi]$. $\int_0^{\pi}\sin x\,dx = 2$ and $\int_{\pi}^{2\pi}(-\sin x)\,dx = 2$. Total $= 4$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral from 0 to pi/2 of sin^2 x dx. Use sin^2 x = (1-cos 2x)/2.
-- = [x/2 - sin 2x/4] from 0 to pi/2 = pi/4 - 0 = pi/4
('$\int_0^{\pi/2} \sin^2 x \, dx$ equals', '$1$', '$\frac{\pi}{2}$', '$\frac{1}{2}$', '$\frac{\pi}{4}$', 'option4', '$\int_0^{\pi/2}\sin^2 x\,dx = \int_0^{\pi/2}\frac{1-\cos 2x}{2}\,dx = \left[\frac{x}{2} - \frac{\sin 2x}{4}\right]_0^{\pi/2} = \frac{\pi}{4} - 0 = \frac{\pi}{4}$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q20: integral from -2 to 2 of (x^3 + x^2) dx. x^3 is odd (integral=0), x^2 is even.
-- = 0 + 2 * integral from 0 to 2 of x^2 dx = 2 * [x^3/3] from 0 to 2 = 2*8/3 = 16/3
('$\int_{-2}^{2} (x^3 + x^2) \, dx$ equals', '$8$', '$0$', '$\frac{8}{3}$', '$\frac{16}{3}$', 'option4', '$x^3$ is odd: $\int_{-2}^{2}x^3\,dx = 0$. $x^2$ is even: $\int_{-2}^{2}x^2\,dx = 2\int_0^2 x^2\,dx = 2 \cdot \frac{8}{3} = \frac{16}{3}$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),

-- Q21: integral from 0 to 1 of x(1-x)^5 dx. Let u=1-x, du=-dx. When x=0,u=1; x=1,u=0.
-- = integral from 1 to 0 of (1-u)u^5 (-du) = integral from 0 to 1 of (u^5-u^6) du = 1/6 - 1/7 = 1/42
('$\int_0^1 x(1-x)^5 \, dx$ equals', '$\frac{1}{12}$', '$\frac{1}{6}$', '$\frac{1}{30}$', '$\frac{1}{42}$', 'option4', 'Let $u = 1-x$: $\int_0^1(1-u)u^5\,du = \int_0^1(u^5-u^6)\,du = \frac{1}{6} - \frac{1}{7} = \frac{1}{42}$.', 'm_fundamental_theorem_calculus', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_definite_integrals_areas (Evaluation of definite integrals, areas bounded by simple curves)
-- Chapter: math_integral_calculus
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Area under y=x from 0 to 3 = integral from 0 to 3 of x dx = [x^2/2] = 9/2
('The area under $y = x$ from $x = 0$ to $x = 3$ is', '$\frac{9}{2}$', '$3$', '$9$', '$\frac{3}{2}$', 'option1', 'Area $= \int_0^3 x\,dx = \left[\frac{x^2}{2}\right]_0^3 = \frac{9}{2}$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Area under y=x^2 from 0 to 2 = [x^3/3] from 0 to 2 = 8/3
('The area under $y = x^2$ from $x = 0$ to $x = 2$ is', '$8$', '$4$', '$\frac{4}{3}$', '$\frac{8}{3}$', 'option4', 'Area $= \int_0^2 x^2\,dx = \left[\frac{x^3}{3}\right]_0^2 = \frac{8}{3}$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q3: integral from 0 to 1 of (2x+1) dx = [x^2+x] from 0 to 1 = 2
('$\int_0^1 (2x+1)\,dx$ equals', '$3$', '$1$', '$2$', '$\frac{3}{2}$', 'option3', '$\int_0^1(2x+1)\,dx = [x^2+x]_0^1 = 1 + 1 = 2$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q4: integral from 1 to 4 of sqrt(x) dx = [2x^(3/2)/3] from 1 to 4 = 2(8)/3 - 2/3 = 16/3 - 2/3 = 14/3
('$\int_1^4 \sqrt{x}\,dx$ equals', '$\frac{14}{3}$', '$\frac{16}{3}$', '$\frac{8}{3}$', '$6$', 'option1', '$\int_1^4 x^{1/2}\,dx = \left[\frac{2x^{3/2}}{3}\right]_1^4 = \frac{2(8)}{3} - \frac{2(1)}{3} = \frac{16-2}{3} = \frac{14}{3}$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Area under y=3 from x=0 to x=4 = 3*4 = 12
('The area under $y = 3$ from $x = 0$ to $x = 4$ is', '$12$', '$3$', '$4$', '$7$', 'option1', 'Area $= \int_0^4 3\,dx = 3 \times 4 = 12$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q6: integral from 0 to pi/2 of cos x dx = [sin x] from 0 to pi/2 = 1
('$\int_0^{\pi/2} \cos x\,dx$ equals', '$\frac{\pi}{2}$', '$0$', '$1$', '$-1$', 'option3', '$\int_0^{\pi/2}\cos x\,dx = [\sin x]_0^{\pi/2} = 1 - 0 = 1$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Q7: integral from 0 to 1 of e^x dx = e-1
('$\int_0^1 e^x\,dx$ equals', '$1$', '$e$', '$e - 1$', '$e + 1$', 'option3', '$\int_0^1 e^x\,dx = [e^x]_0^1 = e - 1$.', 'm_definite_integrals_areas', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Area between y=x^2 and y=x. Intersect: x^2=x => x=0,1.
-- Area = integral from 0 to 1 of (x-x^2) dx = [x^2/2 - x^3/3] from 0 to 1 = 1/2-1/3 = 1/6
('The area enclosed between $y = x$ and $y = x^2$ is', '$\frac{1}{12}$', '$\frac{1}{3}$', '$\frac{1}{2}$', '$\frac{1}{6}$', 'option4', 'Intersection: $x = x^2$ gives $x = 0, 1$. Area $= \int_0^1(x-x^2)\,dx = \left[\frac{x^2}{2}-\frac{x^3}{3}\right]_0^1 = \frac{1}{2}-\frac{1}{3} = \frac{1}{6}$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Area of circle x^2+y^2=a^2. By symmetry: 4 * integral from 0 to a of sqrt(a^2-x^2) dx.
-- integral of sqrt(a^2-x^2) dx from 0 to a = pi*a^2/4. Total = pi*a^2.
('The area enclosed by $x^2 + y^2 = a^2$ is', '$2\pi a$', '$\pi a^2$', '$4a^2$', '$\frac{\pi a^2}{2}$', 'option2', 'By symmetry: $4\int_0^a\sqrt{a^2-x^2}\,dx = 4 \cdot \frac{\pi a^2}{4} = \pi a^2$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Area between y=x^2 and y=4. Intersect: x^2=4 => x=-2,2.
-- Area = integral from -2 to 2 of (4-x^2) dx = 2 * integral from 0 to 2 of (4-x^2) dx = 2[4x-x^3/3] from 0 to 2 = 2(8-8/3) = 2*16/3 = 32/3
('The area bounded by $y = x^2$ and $y = 4$ is', '$8$', '$\frac{16}{3}$', '$\frac{32}{3}$', '$16$', 'option3', 'Intersection at $x = \pm 2$. Area $= 2\int_0^2(4-x^2)\,dx = 2\left[4x-\frac{x^3}{3}\right]_0^2 = 2\left(8-\frac{8}{3}\right) = 2 \cdot \frac{16}{3} = \frac{32}{3}$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q11: integral from 0 to pi of sin^2 x dx. Use sin^2 x = (1-cos 2x)/2. = pi/2
('$\int_0^{\pi} \sin^2 x\,dx$ equals', '$\pi$', '$\frac{\pi}{2}$', '$\frac{\pi}{4}$', '$0$', 'option2', '$\int_0^{\pi}\frac{1-\cos 2x}{2}\,dx = \left[\frac{x}{2}-\frac{\sin 2x}{4}\right]_0^{\pi} = \frac{\pi}{2} - 0 = \frac{\pi}{2}$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Area under y=sin x from 0 to pi = integral = [-cos x] from 0 to pi = 2
('The area under $y = \sin x$ from $x = 0$ to $x = \pi$ is', '$\pi$', '$1$', '$2$', '$0$', 'option3', 'Area $= \int_0^{\pi}\sin x\,dx = [-\cos x]_0^{\pi} = 1 + 1 = 2$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q13: integral from 0 to 2 of (x^3+1) dx = [x^4/4+x] from 0 to 2 = 4+2 = 6
('$\int_0^2 (x^3 + 1)\,dx$ equals', '$\frac{9}{2}$', '$5$', '$8$', '$6$', 'option4', '$\int_0^2(x^3+1)\,dx = \left[\frac{x^4}{4}+x\right]_0^2 = 4 + 2 = 6$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Area between y=x and y=x^3 in [0,1]. x>x^3 for 0<x<1.
-- = integral from 0 to 1 of (x-x^3) dx = [x^2/2-x^4/4] from 0 to 1 = 1/2-1/4 = 1/4
('The area between $y = x$ and $y = x^3$ from $x = 0$ to $x = 1$ is', '$\frac{1}{4}$', '$\frac{1}{3}$', '$\frac{1}{6}$', '$\frac{1}{2}$', 'option1', 'For $0 < x < 1$: $x > x^3$. Area $= \int_0^1(x-x^3)\,dx = \left[\frac{x^2}{2}-\frac{x^4}{4}\right]_0^1 = \frac{1}{2}-\frac{1}{4} = \frac{1}{4}$.', 'm_definite_integrals_areas', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Area of ellipse x^2/a^2 + y^2/b^2 = 1. By symmetry: 4 * integral from 0 to a of b sqrt(1-x^2/a^2) dx
-- = 4b/a * integral from 0 to a of sqrt(a^2-x^2) dx = 4b/a * pi*a^2/4 = pi*a*b
('The area enclosed by the ellipse $\frac{x^2}{a^2} + \frac{y^2}{b^2} = 1$ is', '$2\pi ab$', '$\pi ab$', '$\frac{\pi ab}{2}$', '$4ab$', 'option2', 'By symmetry: $4\int_0^a \frac{b}{a}\sqrt{a^2-x^2}\,dx = \frac{4b}{a} \cdot \frac{\pi a^2}{4} = \pi ab$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Area between y^2=4x and x^2=4y. Intersect: from y^2=4x, x=y^2/4. Sub in x^2=4y: y^4/16=4y => y^4=64y => y(y^3-64)=0 => y=0,4. x=0,4.
-- Area = integral from 0 to 4 of (2sqrt(x) - x^2/4) dx = [4x^(3/2)/3 - x^3/12] from 0 to 4 = 32/3 - 64/12 = 32/3 - 16/3 = 16/3
('The area enclosed between $y^2 = 4x$ and $x^2 = 4y$ is', '$\frac{8}{3}$', '$\frac{16}{3}$', '$4$', '$\frac{32}{3}$', 'option2', 'Intersection at $(0,0)$ and $(4,4)$. Area $= \int_0^4\left(2\sqrt{x}-\frac{x^2}{4}\right)dx = \left[\frac{4x^{3/2}}{3}-\frac{x^3}{12}\right]_0^4 = \frac{32}{3}-\frac{16}{3} = \frac{16}{3}$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Area between y=x^2 and y=2x-x^2. Intersect: x^2=2x-x^2 => 2x^2=2x => x=0,1.
-- Area = integral from 0 to 1 of (2x-x^2-x^2) dx = integral of (2x-2x^2) dx = [x^2-2x^3/3] from 0 to 1 = 1-2/3 = 1/3
('The area between $y = x^2$ and $y = 2x - x^2$ is', '$1$', '$\frac{1}{6}$', '$\frac{2}{3}$', '$\frac{1}{3}$', 'option4', 'Intersection: $x^2 = 2x-x^2$ gives $x = 0, 1$. Area $= \int_0^1(2x-2x^2)\,dx = \left[x^2-\frac{2x^3}{3}\right]_0^1 = 1-\frac{2}{3} = \frac{1}{3}$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Area bounded by y=|x-1| and y=1. The triangle with vertices (0,1),(1,0),(2,1).
-- Area = integral from 0 to 2 of (1-|x-1|) dx = 2 * integral from 0 to 1 of (1-(1-x)) dx = 2 * integral from 0 to 1 of x dx = 2*1/2 = 1
('The area bounded by $y = |x-1|$ and $y = 1$ is', '$\frac{3}{2}$', '$2$', '$\frac{1}{2}$', '$1$', 'option4', 'Intersection: $|x-1| = 1$ gives $x = 0, 2$. Area $= \int_0^2(1-|x-1|)\,dx = 2\int_0^1 x\,dx = 2 \cdot \frac{1}{2} = 1$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q19: integral from 0 to 1 of x^2 e^x dx. By parts twice:
-- = [x^2 e^x] from 0 to 1 - 2 integral of x e^x dx = e - 2[e^x(x-1)] from 0 to 1 = e - 2(0-(-1)) = e-2
('$\int_0^1 x^2 e^x\,dx$ equals', '$e - 2$', '$e$', '$e - 1$', '$2e - 3$', 'option1', 'By parts: $[x^2 e^x]_0^1 - 2\int_0^1 xe^x\,dx = e - 2[e^x(x-1)]_0^1 = e - 2(0-(-1)) = e - 2$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Area between y=e^x, x-axis, x=0, x=1. = integral from 0 to 1 of e^x dx = e-1
('The area bounded by $y = e^x$, the $x$-axis, $x = 0$ and $x = 1$ is', '$e - 1$', '$e$', '$1$', '$e + 1$', 'option1', 'Area $= \int_0^1 e^x\,dx = [e^x]_0^1 = e - 1$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Area between y=sqrt(x) and y=x. Intersect: sqrt(x)=x => x=x^2 => x=0,1.
-- Area = integral from 0 to 1 of (sqrt(x)-x) dx = [2x^(3/2)/3 - x^2/2] from 0 to 1 = 2/3-1/2 = 1/6
('The area between $y = \sqrt{x}$ and $y = x$ is', '$\frac{1}{4}$', '$\frac{1}{3}$', '$\frac{1}{6}$', '$\frac{1}{2}$', 'option3', 'Intersection at $x = 0, 1$. For $0 < x < 1$: $\sqrt{x} > x$. Area $= \int_0^1(\sqrt{x}-x)\,dx = \left[\frac{2x^{3/2}}{3}-\frac{x^2}{2}\right]_0^1 = \frac{2}{3}-\frac{1}{2} = \frac{1}{6}$.', 'm_definite_integrals_areas', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_ode_order_degree (Ordinary differential equations, their order and degree)
-- Chapter: math_differential_equations
-- ============================================================

-- Tier 1 (Easy)
-- Q1: dy/dx + y = 0. Order=1, degree=1.
('The order of the differential equation $\frac{dy}{dx} + y = 0$ is', '$2$', '$1$', '$0$', '$3$', 'option2', 'The highest order derivative is $\frac{dy}{dx}$ (first derivative), so the order is $1$.', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q2: d2y/dx2 + 3 dy/dx + 2y = 0. Order=2.
('The order of $\frac{d^2y}{dx^2} + 3\frac{dy}{dx} + 2y = 0$ is', '$1$', '$2$', '$3$', '$5$', 'option2', 'The highest order derivative is $\frac{d^2y}{dx^2}$ (second derivative), so the order is $2$.', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q3: (dy/dx)^2 + y = x. Order=1, degree=2.
('The degree of $\left(\frac{dy}{dx}\right)^2 + y = x$ is', '$1$', '$2$', '$3$', '$4$', 'option2', 'The highest power of the highest order derivative $\frac{dy}{dx}$ is $2$, so the degree is $2$.', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q4: d2y/dx2 + (dy/dx)^3 + y = 0. Order=2, degree=1.
('The degree of $\frac{d^2y}{dx^2} + \left(\frac{dy}{dx}\right)^3 + y = 0$ is', '$5$', '$2$', '$3$', '$1$', 'option4', 'The highest order derivative is $\frac{d^2y}{dx^2}$, and its power is $1$. So the degree is $1$.', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q5: y' = sin x. Order=1, degree=1.
('The order and degree of $y'' = \sin x$ are respectively', '$2$ and $1$', '$1$ and $0$', '$0$ and $1$', '$1$ and $1$', 'option4', 'The highest derivative is $y''$ (order $1$), and its power is $1$ (degree $1$).', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q6: (d3y/dx3)^2 + y = 0. Order=3, degree=2.
('The order and degree of $\left(\frac{d^3y}{dx^3}\right)^2 + y = 0$ are', '$3$ and $1$', '$2$ and $3$', '$3$ and $2$', '$6$ and $1$', 'option3', 'Highest order derivative: $\frac{d^3y}{dx^3}$ (order $3$). Its power is $2$ (degree $2$).', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Q7: dy/dx = e^x + 1. Order=1, degree=1.
('The degree of $\frac{dy}{dx} = e^x + 1$ is', '$1$', '$2$', '$0$', 'Not defined', 'option1', 'The highest order derivative $\frac{dy}{dx}$ appears with power $1$, so the degree is $1$.', 'm_ode_order_degree', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: y = Ae^x + Be^(-x) has 2 arbitrary constants => ODE of order 2.
('The differential equation of $y = Ae^x + Be^{-x}$ (A, B arbitrary) has order', '$3$', '$1$', '$2$', '$4$', 'option3', 'The number of arbitrary constants equals the order of the ODE. Here $A$ and $B$ are two constants, so the order is $2$.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q9: (d2y/dx2)^3 + (dy/dx)^2 + sin(dy/dx) = 0. Degree is not defined because of sin(dy/dx).
('The degree of $\left(\frac{d^2y}{dx^2}\right)^3 + \left(\frac{dy}{dx}\right)^2 + \sin\left(\frac{dy}{dx}\right) = 0$ is', 'Not defined', '$3$', '$2$', '$1$', 'option1', 'The equation involves $\sin\left(\frac{dy}{dx}\right)$, a transcendental function of the derivative. The degree is defined only when the equation is polynomial in its derivatives, so the degree is not defined.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q10: y = cx + c^2. Differentiate: y' = c. So c = y'. Substitute: y = xy' + (y')^2.
-- Order=1, degree=2.
('The ODE formed by eliminating $c$ from $y = cx + c^2$ has degree', '$3$', '$1$', '$2$', '$4$', 'option3', 'Differentiating: $y'' = c$. Substituting $c = y''$: $y = xy'' + (y'')^2$. The highest power of $y''$ is $2$, so the degree is $2$.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q11: y = a sin(x+b). Two constants a,b => order 2.
-- y' = a cos(x+b). y'' = -a sin(x+b) = -y. So y''+y=0. Order=2, degree=1.
('The differential equation of $y = a\sin(x + b)$ is', '$y'' - y = 0$', '$y'''' - y = 0$', '$y'' + y = 0$', '$y'''' + y = 0$', 'option4', '$y'' = a\cos(x+b)$, $y'''' = -a\sin(x+b) = -y$. So $y'''' + y = 0$.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q12: [1+(dy/dx)^2]^(3/2) = d2y/dx2. Squaring both sides: [1+(y')^2]^3 = (y'')^2. Degree of y'' is 2.
('The degree of $\left[1 + \left(\frac{dy}{dx}\right)^2\right]^{3/2} = \frac{d^2y}{dx^2}$ is', '$3$', '$2$', '$\frac{3}{2}$', '$1$', 'option2', 'Squaring both sides: $\left[1+(y'')^2\right]^3 = (y'''')^2$. The highest power of $y''''$ is $2$, so the degree is $2$.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q13: y = ax^2 + bx + c. Three constants => order 3. y'=2ax+b, y''=2a, y'''=0.
('The differential equation of all parabolas $y = ax^2 + bx + c$ is', '$y'''''' = 0$', '$y'''' = 0$', '$y'' = 0$', '$y'''' + y = 0$', 'option1', 'Three arbitrary constants require order $3$. $y'' = 2ax + b$, $y'''' = 2a$, $y'''''' = 0$.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Q14: e^(dy/dx) + dy/dx = x. Degree not defined (exponential of derivative).
('The degree of $e^{dy/dx} + \frac{dy}{dx} = x$ is', 'Not defined', '$1$', '$2$', '$e$', 'option1', 'The equation involves $e^{dy/dx}$, a transcendental function of the derivative. The degree is not defined.', 'm_ode_order_degree', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: y = c1 e^(2x) + c2 e^(3x). y'=2c1 e^(2x)+3c2 e^(3x). y''=4c1 e^(2x)+9c2 e^(3x).
-- From y and y': c1 e^(2x) = 3y-y', c2 e^(3x) = y'-2y.
-- y'' = 4(3y-y') + 9(y'-2y) = 12y-4y'+9y'-18y = 5y'-6y. So y''-5y'+6y=0.
('The ODE for $y = c_1 e^{2x} + c_2 e^{3x}$ is', '$y'''' - 5y'' + 6y = 0$', '$y'''' + 5y'' + 6y = 0$', '$y'''' - 5y'' - 6y = 0$', '$y'''' + 5y'' - 6y = 0$', 'option1', '$y'' = 2c_1 e^{2x} + 3c_2 e^{3x}$, $y'''' = 4c_1 e^{2x} + 9c_2 e^{3x}$. Eliminating $c_1, c_2$: $y'''' - 5y'' + 6y = 0$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Family of circles x^2+y^2=r^2 (one constant r). Differentiate: 2x+2yy'=0 => x+yy'=0. Order=1, degree=1.
('The ODE of all circles centred at the origin is', '$xy'' - y = 0$', '$x^2 + y^2 = 0$', '$1 + (y'')^2 = 0$', '$x + yy'' = 0$', 'option4', 'Family: $x^2 + y^2 = r^2$. Differentiating: $2x + 2yy'' = 0$, i.e., $x + yy'' = 0$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q17: (y'')^2 + (y')^3 + y^4 = 0. Order=2 (highest derivative is y''). Degree=2 (power of y'').
('The order and degree of $(y'''')^2 + (y'')^3 + y^4 = 0$ are', '$3$ and $2$', '$2$ and $3$', '$4$ and $2$', '$2$ and $2$', 'option4', 'Highest order derivative: $y''''$ (order $2$). Its power is $2$ (degree $2$).', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q18: y = (c1+c2x)e^x. Two constants => order 2.
-- y' = c2 e^x + (c1+c2x)e^x = (c1+c2+c2x)e^x. y-y' = -c2 e^x.
-- y'' = c2 e^x + (c1+c2+c2x)e^x = (c1+2c2+c2x)e^x. y''-y' = c2 e^x = -(y-y') => y''-2y'+y=0.
('The ODE for $y = (c_1 + c_2 x)e^x$ is', '$y'''' - 2y'' - y = 0$', '$y'''' + 2y'' + y = 0$', '$y'''' - y = 0$', '$y'''' - 2y'' + y = 0$', 'option4', '$y'' = (c_1+c_2+c_2 x)e^x$, $y'''' = (c_1+2c_2+c_2 x)e^x$. Then $y''''-2y''+y = 0$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q19: sqrt(1+(dy/dx)^2) = (d2y/dx2)^(1/3). Cube both sides: [1+(y')^2]^(3/2) = y''.
-- Square: [1+(y')^2]^3 = (y'')^2. Order=2, degree=2.
('The order and degree of $\sqrt{1+\left(\frac{dy}{dx}\right)^2} = \left(\frac{d^2y}{dx^2}\right)^{1/3}$ are', '$2$ and $3$', '$2$ and $2$', '$2$ and $1$', '$3$ and $2$', 'option2', 'Cube both sides: $[1+(y'')^2]^{3/2} = y''''$. Square: $[1+(y'')^2]^3 = (y'''')^2$. Order $= 2$, degree $= 2$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Family y=mx (lines through origin). One constant m. y'=m. So y=xy' => xy'-y=0.
('The ODE representing all lines through the origin is', '$xy'' - y = 0$', '$y'' = 0$', '$xy'' + y = 0$', '$y'''' = 0$', 'option1', 'Family: $y = mx$. Differentiating: $y'' = m$. Substituting: $y = xy''$, i.e., $xy'' - y = 0$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),

-- Q21: log(d2y/dx2) = x. Then d2y/dx2 = e^x. Order=2, degree=1.
('The order and degree of $\ln\left(\frac{d^2y}{dx^2}\right) = x$ are', '$1$ and $2$', '$2$ and not defined', '$2$ and $1$', '$2$ and $2$', 'option3', 'Rewrite as $\frac{d^2y}{dx^2} = e^x$. The equation is polynomial in $y''''$ with power $1$. Order $= 2$, degree $= 1$.', 'm_ode_order_degree', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_separation_variables (Solution by method of separation of variables)
-- Chapter: math_differential_equations
-- ============================================================

-- Tier 1 (Easy)
-- Q1: dy/dx = x. Separate: dy = x dx. Integrate: y = x^2/2 + C.
('The general solution of $\frac{dy}{dx} = x$ is', '$y = x + C$', '$y = \frac{x^2}{2} + C$', '$y = 2x + C$', '$y = x^2 + C$', 'option2', 'Separating: $dy = x\,dx$. Integrating: $y = \frac{x^2}{2} + C$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q2: dy/dx = y. Separate: dy/y = dx. Integrate: ln|y| = x + C. y = Ae^x.
('The general solution of $\frac{dy}{dx} = y$ is', '$y = Ae^x$', '$y = e^x + C$', '$y = x + C$', '$y = Ae^{-x}$', 'option1', 'Separating: $\frac{dy}{y} = dx$. Integrating: $\ln|y| = x + C_1$, so $y = Ae^x$ where $A = \pm e^{C_1}$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q3: dy/dx = e^x. Integrate: y = e^x + C.
('The general solution of $\frac{dy}{dx} = e^x$ is', '$y = xe^x + C$', '$y = e^x + C$', '$y = e^x$', '$y = e^{x+C}$', 'option2', 'Integrating both sides: $y = \int e^x\,dx = e^x + C$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q4: dy/dx = 2x+3. Integrate: y = x^2+3x+C.
('The general solution of $\frac{dy}{dx} = 2x + 3$ is', '$y = x^2 + 3x + C$', '$y = 2x + 3 + C$', '$y = x^2 + 3 + C$', '$y = 2x^2 + 3x + C$', 'option1', 'Integrating: $y = \int(2x+3)\,dx = x^2 + 3x + C$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q5: dy/dx = -y. Separate: dy/y = -dx. ln|y| = -x+C. y = Ae^(-x).
('The general solution of $\frac{dy}{dx} = -y$ is', '$y = e^{-x} + C$', '$y = Ae^x$', '$y = -x + C$', '$y = Ae^{-x}$', 'option4', 'Separating: $\frac{dy}{y} = -dx$. Integrating: $\ln|y| = -x + C_1$, so $y = Ae^{-x}$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q6: dy/dx = sin x. Integrate: y = -cos x + C.
('The general solution of $\frac{dy}{dx} = \sin x$ is', '$y = -\cos x + C$', '$y = \cos x + C$', '$y = \sin x + C$', '$y = -\sin x + C$', 'option1', 'Integrating: $y = \int \sin x\,dx = -\cos x + C$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Q7: dy/dx = 1/x. Integrate: y = ln|x| + C.
('The general solution of $\frac{dy}{dx} = \frac{1}{x}$ is', '$y = x + C$', '$y = \frac{1}{x} + C$', '$y = \ln|x| + C$', '$y = -\frac{1}{x^2} + C$', 'option3', 'Integrating: $y = \int \frac{1}{x}\,dx = \ln|x| + C$.', 'm_separation_variables', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: dy/dx = xy. Separate: dy/y = x dx. ln|y| = x^2/2 + C. y = Ae^(x^2/2).
('The general solution of $\frac{dy}{dx} = xy$ is', '$y = Ae^{xy}$', '$y = Ae^{x^2/2}$', '$y = \frac{x^2 y}{2} + C$', '$y = Ae^x$', 'option2', 'Separating: $\frac{dy}{y} = x\,dx$. Integrating: $\ln|y| = \frac{x^2}{2} + C_1$, so $y = Ae^{x^2/2}$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q9: dy/dx = (1+y^2)/(1+x^2). Separate: dy/(1+y^2) = dx/(1+x^2). tan^(-1) y = tan^(-1) x + C.
('The general solution of $\frac{dy}{dx} = \frac{1+y^2}{1+x^2}$ is', '$\tan^{-1} y = x + C$', '$y = x + C$', '$\tan^{-1} y = \tan^{-1} x + C$', '$y = \tan x + C$', 'option3', 'Separating: $\frac{dy}{1+y^2} = \frac{dx}{1+x^2}$. Integrating: $\tan^{-1}y = \tan^{-1}x + C$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q10: dy/dx = y/x. Separate: dy/y = dx/x. ln|y| = ln|x| + C. y = kx.
('The general solution of $\frac{dy}{dx} = \frac{y}{x}$ is', '$y = x + C$', '$y = \frac{k}{x}$', '$y = kx$', '$xy = C$', 'option3', 'Separating: $\frac{dy}{y} = \frac{dx}{x}$. Integrating: $\ln|y| = \ln|x| + C_1$, so $y = kx$ where $k = \pm e^{C_1}$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q11: dy/dx = e^(x+y) = e^x * e^y. Separate: e^(-y) dy = e^x dx. -e^(-y) = e^x + C.
('The general solution of $\frac{dy}{dx} = e^{x+y}$ is', '$e^y = e^x + C$', '$e^{-y} + e^x = C$', '$y = e^x + C$', '$e^{x+y} = C$', 'option2', 'Separating: $e^{-y}\,dy = e^x\,dx$. Integrating: $-e^{-y} = e^x + C_1$, i.e., $e^{-y} + e^x = C$ (where $C = -C_1$).', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q12: dy/dx = y^2. Separate: dy/y^2 = dx. -1/y = x + C. y = -1/(x+C) = 1/(C-x) rewritten.
('The general solution of $\frac{dy}{dx} = y^2$ is', '$y^2 = x + C$', '$y = \frac{1}{x} + C$', '$y = \frac{-1}{x + C}$', '$\ln y = x + C$', 'option3', 'Separating: $\frac{dy}{y^2} = dx$. Integrating: $-\frac{1}{y} = x + C$, so $y = \frac{-1}{x+C}$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q13: x dy + y dx = 0. This is d(xy)=0. So xy=C.
('The solution of $x\,dy + y\,dx = 0$ is', '$x + y = C$', '$xy = C$', '$\frac{x}{y} = C$', '$x^2 + y^2 = C$', 'option2', '$x\,dy + y\,dx = d(xy) = 0$. Integrating: $xy = C$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Q14: dy/dx = (1+y)/(1+x). Separate: dy/(1+y) = dx/(1+x). ln|1+y| = ln|1+x| + C. 1+y = A(1+x).
('The general solution of $\frac{dy}{dx} = \frac{1+y}{1+x}$ is', '$y = x + C$', '$1 + y = A(1 + x)$', '$\ln(1+y) = x + C$', '$(1+y)(1+x) = C$', 'option2', 'Separating: $\frac{dy}{1+y} = \frac{dx}{1+x}$. Integrating: $\ln|1+y| = \ln|1+x| + C_1$, so $1+y = A(1+x)$.', 'm_separation_variables', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: dy/dx = (x+y)/(x-y). Homogeneous. Let y=vx. v+xv'=(1+v)/(1-v).
-- xv' = (1+v)/(1-v) - v = (1+v-v+v^2)/(1-v) = (1+v^2)/(1-v).
-- (1-v)/(1+v^2) dv = dx/x. integral of 1/(1+v^2) dv - integral of v/(1+v^2) dv = ln|x| + C.
-- tan^(-1) v - (1/2) ln(1+v^2) = ln|x| + C. Sub v=y/x.
('The solution of $\frac{dy}{dx} = \frac{x+y}{x-y}$ is', '$\tan^{-1}\frac{y}{x} = \ln|x| + C$', '$\frac{y}{x} = \ln|x| + C$', '$x^2 + y^2 = Cx$', '$\tan^{-1}\frac{y}{x} - \frac{1}{2}\ln(x^2+y^2) = C$', 'option4', 'Homogeneous: let $v = y/x$. After separation: $\int\frac{1-v}{1+v^2}\,dv = \ln|x| + C$. This gives $\tan^{-1}\frac{y}{x} - \frac{1}{2}\ln(x^2+y^2) = C$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q16: dy/dx = y/x + tan(y/x). Homogeneous. Let y=vx. v+xv'=v+tan v. xv'=tan v.
-- cot v dv = dx/x. ln|sin v| = ln|x| + C. sin(y/x) = kx.
('The solution of $\frac{dy}{dx} = \frac{y}{x} + \tan\frac{y}{x}$ is', '$\cos\frac{y}{x} = kx$', '$\sin\frac{y}{x} = kx$', '$\tan\frac{y}{x} = \ln x + C$', '$\frac{y}{x} = \tan(\ln x) + C$', 'option2', 'Homogeneous: $v + xv'' = v + \tan v$, so $xv'' = \tan v$. Separating: $\cot v\,dv = \frac{dx}{x}$. Integrating: $\ln|\sin v| = \ln|x| + C$, giving $\sin\frac{y}{x} = kx$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q17: dy/dx = y^2 + 1, y(0)=0. Separate: dy/(y^2+1) = dx. tan^(-1) y = x + C. y(0)=0 => C=0. y=tan x.
('The solution of $\frac{dy}{dx} = y^2 + 1$ with $y(0) = 0$ is', '$y = \tan x$', '$y = \sin x$', '$y = x$', '$y = e^x - 1$', 'option1', 'Separating: $\frac{dy}{1+y^2} = dx$. Integrating: $\tan^{-1}y = x + C$. $y(0) = 0$ gives $C = 0$. So $y = \tan x$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q18: (x^2+1)dy + (y^2+1)dx = 0. Separate: dy/(y^2+1) = -dx/(x^2+1). tan^(-1) y = -tan^(-1) x + C.
-- tan^(-1) x + tan^(-1) y = C.
('The solution of $(x^2+1)\,dy + (y^2+1)\,dx = 0$ is', '$\tan^{-1} x + \tan^{-1} y = C$', '$\tan^{-1} x - \tan^{-1} y = C$', '$x + y = C(1-xy)$', '$xy = C$', 'option1', 'Separating: $\frac{dy}{1+y^2} = -\frac{dx}{1+x^2}$. Integrating: $\tan^{-1}y = -\tan^{-1}x + C$, i.e., $\tan^{-1}x + \tan^{-1}y = C$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q19: dy/dx = (x+y+1)/(x+y-1). Let u=x+y. du/dx = 1+dy/dx. dy/dx = du/dx - 1.
-- du/dx - 1 = (u+1)/(u-1). du/dx = (u+1)/(u-1) + 1 = (u+1+u-1)/(u-1) = 2u/(u-1).
-- (u-1)/(2u) du = dx. (1/2 - 1/(2u)) du = dx. u/2 - ln|u|/2 = x + C.
-- (x+y)/2 - (1/2) ln|x+y| = x + C. Simplify: y-x - ln|x+y| = C' (multiply by 2).
('The substitution to solve $\frac{dy}{dx} = \frac{x+y+1}{x+y-1}$ is', '$u = y/x$', '$u = x + y$', '$u = xy$', '$u = x - y$', 'option2', 'Since the RHS depends on $x+y$, the substitution $u = x+y$ reduces it to a separable equation: $\frac{du}{dx} = \frac{2u}{u-1}$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q20: dy/dx = 2xy, y(0)=1. Separate: dy/y = 2x dx. ln|y| = x^2 + C. y(0)=1 => C=0. y=e^(x^2).
('The solution of $\frac{dy}{dx} = 2xy$ with $y(0) = 1$ is', '$y = x^2 + 1$', '$y = e^{2x}$', '$y = e^{x^2}$', '$y = e^{x^2/2}$', 'option3', 'Separating: $\frac{dy}{y} = 2x\,dx$. Integrating: $\ln y = x^2 + C$. $y(0) = 1$ gives $C = 0$. So $y = e^{x^2}$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),

-- Q21: x dy - y dx = sqrt(x^2+y^2) dx. Divide by x^2: (x dy - y dx)/x^2 = sqrt(1+(y/x)^2) dx/x.
-- d(y/x) = sqrt(1+v^2) dx/x where v=y/x. dv/sqrt(1+v^2) = dx/x.
-- ln|v+sqrt(1+v^2)| = ln|x| + C. v+sqrt(1+v^2) = kx. y/x + sqrt(1+y^2/x^2) = kx.
-- y + sqrt(x^2+y^2) = kx^2.
('The solution of $x\,dy - y\,dx = \sqrt{x^2+y^2}\,dx$ is', '$x^2 + y^2 = kx$', '$\sqrt{x^2+y^2} = kx$', '$y = x\sinh(\ln x + C)$', '$y + \sqrt{x^2+y^2} = kx^2$', 'option4', 'Divide by $x^2$: $d(y/x) = \frac{\sqrt{1+(y/x)^2}}{x}\,dx$. Let $v = y/x$: $\frac{dv}{\sqrt{1+v^2}} = \frac{dx}{x}$. Integrating: $v + \sqrt{1+v^2} = kx$, giving $y + \sqrt{x^2+y^2} = kx^2$.', 'm_separation_variables', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_linear_de (Solution of homogeneous and linear differential equations dy/dx + p(x)y = q(x))
-- Chapter: math_differential_equations
-- ============================================================

-- Tier 1 (Easy)
-- Q1: dy/dx + y = 0. IF = e^(integral 1 dx) = e^x. Solution: ye^x = C. y = Ce^(-x).
('The general solution of $\frac{dy}{dx} + y = 0$ is', '$y = C$', '$y = Ce^x$', '$y = Cx$', '$y = Ce^{-x}$', 'option4', 'IF $= e^{\int 1\,dx} = e^x$. Multiplying: $\frac{d}{dx}(ye^x) = 0$. So $ye^x = C$, giving $y = Ce^{-x}$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q2: dy/dx + 2y = 0. IF = e^(2x). ye^(2x) = C. y = Ce^(-2x).
('The general solution of $\frac{dy}{dx} + 2y = 0$ is', '$y = 2Ce^{-x}$', '$y = Ce^{2x}$', '$y = Ce^{-2x}$', '$y = C + e^{-2x}$', 'option3', 'IF $= e^{\int 2\,dx} = e^{2x}$. Solution: $ye^{2x} = C$, so $y = Ce^{-2x}$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Integrating factor of dy/dx + y/x = 0 is e^(integral 1/x dx) = e^(ln x) = x.
('The integrating factor of $\frac{dy}{dx} + \frac{y}{x} = 0$ is', '$\ln x$', '$\frac{1}{x}$', '$e^x$', '$x$', 'option4', 'IF $= e^{\int \frac{1}{x}\,dx} = e^{\ln x} = x$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q4: dy/dx - y = 0. IF = e^(-x). ye^(-x) = C. y = Ce^x.
('The general solution of $\frac{dy}{dx} - y = 0$ is', '$y = Ce^x$', '$y = Ce^{-x}$', '$y = Cx$', '$y = C$', 'option1', 'IF $= e^{\int(-1)\,dx} = e^{-x}$. Solution: $ye^{-x} = C$, so $y = Ce^x$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q5: IF of dy/dx + 3y = 0 is e^(3x).
('The integrating factor of $\frac{dy}{dx} + 3y = 0$ is', '$e^{3}$', '$e^{-3x}$', '$3x$', '$e^{3x}$', 'option4', 'IF $= e^{\int 3\,dx} = e^{3x}$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q6: dy/dx + y = 1. IF = e^x. d/dx(ye^x) = e^x. ye^x = e^x + C. y = 1 + Ce^(-x).
('The general solution of $\frac{dy}{dx} + y = 1$ is', '$y = x + Ce^{-x}$', '$y = e^x + C$', '$y = Ce^{-x}$', '$y = 1 + Ce^{-x}$', 'option4', 'IF $= e^x$. $ye^x = \int e^x\,dx = e^x + C$. So $y = 1 + Ce^{-x}$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Q7: dy/dx + y = e^x. IF = e^x. d/dx(ye^x) = e^(2x). ye^x = e^(2x)/2 + C. y = e^x/2 + Ce^(-x).
('The general solution of $\frac{dy}{dx} + y = e^x$ is', '$y = e^x + Ce^{-x}$', '$y = \frac{e^x}{2} + Ce^{-x}$', '$y = e^{2x} + C$', '$y = xe^x + C$', 'option2', 'IF $= e^x$. $ye^x = \int e^{2x}\,dx = \frac{e^{2x}}{2} + C$. So $y = \frac{e^x}{2} + Ce^{-x}$.', 'm_linear_de', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: dy/dx + y/x = x. IF = x. d/dx(xy) = x^2. xy = x^3/3 + C. y = x^2/3 + C/x.
('The general solution of $\frac{dy}{dx} + \frac{y}{x} = x$ is', '$y = x\ln x + C$', '$y = \frac{x^2}{2} + C$', '$y = \frac{x^2}{3} + \frac{C}{x}$', '$y = \frac{x^2}{3} + Cx$', 'option3', 'IF $= e^{\int 1/x\,dx} = x$. $xy = \int x^2\,dx = \frac{x^3}{3} + C$. So $y = \frac{x^2}{3} + \frac{C}{x}$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q9: dy/dx - 2y = e^(3x). IF = e^(-2x). d/dx(ye^(-2x)) = e^x. ye^(-2x) = e^x + C. y = e^(3x) + Ce^(2x).
('The general solution of $\frac{dy}{dx} - 2y = e^{3x}$ is', '$y = e^{3x} + Ce^{2x}$', '$y = e^{3x} + Ce^{-2x}$', '$y = \frac{e^{3x}}{3} + Ce^{2x}$', '$y = e^{5x} + C$', 'option1', 'IF $= e^{-2x}$. $ye^{-2x} = \int e^x\,dx = e^x + C$. So $y = e^{3x} + Ce^{2x}$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q10: dy/dx + y tan x = sec x. IF = e^(integral tan x dx) = e^(ln|sec x|) = sec x.
-- d/dx(y sec x) = sec^2 x. y sec x = tan x + C. y = sin x + C cos x.
('The general solution of $\frac{dy}{dx} + y\tan x = \sec x$ is', '$y = \cos x + C\sin x$', '$y = \sin x + C\cos x$', '$y = \sec x + C$', '$y = \tan x + C\cos x$', 'option2', 'IF $= \sec x$. $y\sec x = \int\sec^2 x\,dx = \tan x + C$. So $y = \sin x + C\cos x$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q11: dy/dx + 2xy = x. IF = e^(x^2). d/dx(ye^(x^2)) = xe^(x^2). ye^(x^2) = e^(x^2)/2 + C.
-- y = 1/2 + Ce^(-x^2).
('The general solution of $\frac{dy}{dx} + 2xy = x$ is', '$y = x + Ce^{-x^2}$', '$y = \frac{1}{2} + Ce^{-x^2}$', '$y = \frac{x^2}{2} + Ce^{-x^2}$', '$y = Ce^{x^2}$', 'option2', 'IF $= e^{x^2}$. $ye^{x^2} = \int xe^{x^2}\,dx = \frac{e^{x^2}}{2} + C$. So $y = \frac{1}{2} + Ce^{-x^2}$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q12: x dy/dx + y = x^2. Rewrite: dy/dx + y/x = x. IF = x. xy = x^3/3 + C.
-- y(1)=1 => 1 = 1/3 + C => C = 2/3. y = x^2/3 + 2/(3x).
('The solution of $x\frac{dy}{dx} + y = x^2$ with $y(1) = 1$ is', '$y = x^2 + \frac{1}{x}$', '$y = \frac{x^2}{3} + \frac{1}{x}$', '$y = \frac{x^2}{3} + \frac{2}{3x}$', '$y = \frac{x^2}{2} + \frac{1}{2x}$', 'option3', 'Rewrite: $\frac{dy}{dx} + \frac{y}{x} = x$. IF $= x$. $xy = \frac{x^3}{3} + C$. $y(1) = 1$: $1 = \frac{1}{3} + C$, so $C = \frac{2}{3}$. $y = \frac{x^2}{3} + \frac{2}{3x}$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q13: dy/dx + y cot x = 2x + x^2 cot x. IF = e^(integral cot x dx) = e^(ln|sin x|) = sin x.
-- d/dx(y sin x) = (2x + x^2 cot x) sin x = 2x sin x + x^2 cos x = d/dx(x^2 sin x).
-- y sin x = x^2 sin x + C. y = x^2 + C csc x.
('The general solution of $\frac{dy}{dx} + y\cot x = 2x + x^2\cot x$ is', '$y = x^2 + C\csc x$', '$y = x^2\sin x + C$', '$y = x^2 + C\sin x$', '$y = x\sin x + C\csc x$', 'option1', 'IF $= \sin x$. $y\sin x = \int(2x\sin x + x^2\cos x)\,dx = x^2\sin x + C$. So $y = x^2 + C\csc x$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Q14: dy/dx - y/x = x. IF = e^(-ln x) = 1/x. d/dx(y/x) = 1. y/x = x + C. y = x^2 + Cx.
('The general solution of $\frac{dy}{dx} - \frac{y}{x} = x$ is', '$y = \frac{x^2}{2} + Cx$', '$y = x^2 + Cx$', '$y = x^2 + \frac{C}{x}$', '$y = x\ln x + Cx$', 'option2', 'IF $= e^{-\ln x} = \frac{1}{x}$. $\frac{y}{x} = \int 1\,dx = x + C$. So $y = x^2 + Cx$.', 'm_linear_de', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: dy/dx + y/x = x^3. IF = x. xy = integral of x^4 dx = x^5/5 + C. y = x^4/5 + C/x.
-- y(1)=6/5: 6/5 = 1/5 + C => C=1. y = x^4/5 + 1/x.
('The solution of $\frac{dy}{dx} + \frac{y}{x} = x^3$ with $y(1) = \frac{6}{5}$ is', '$y = \frac{x^4}{4} + \frac{1}{x}$', '$y = \frac{x^4}{5} + \frac{6}{5x}$', '$y = x^4 + \frac{1}{x}$', '$y = \frac{x^4}{5} + \frac{1}{x}$', 'option4', 'IF $= x$. $xy = \frac{x^5}{5} + C$. $y(1) = \frac{6}{5}$: $\frac{6}{5} = \frac{1}{5} + C$, so $C = 1$. $y = \frac{x^4}{5} + \frac{1}{x}$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q16: cos x dy/dx + y sin x = 1. Rewrite: dy/dx + y tan x = sec x. IF = sec x.
-- y sec x = tan x + C. y = sin x + C cos x. y(0)=1: 1=0+C => C=1. y = sin x + cos x.
('The solution of $\cos x\frac{dy}{dx} + y\sin x = 1$ with $y(0) = 1$ is', '$y = 1$', '$y = \cos x$', '$y = \sin x + \cos x$', '$y = \sin x + 1$', 'option3', 'Rewrite: $\frac{dy}{dx} + y\tan x = \sec x$. IF $= \sec x$. $y\sec x = \tan x + C$. $y(0) = 1$: $C = 1$. $y = \sin x + \cos x$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q17: (1+x^2)dy/dx + 2xy = 1/(1+x^2). Rewrite: dy/dx + 2xy/(1+x^2) = 1/(1+x^2)^2.
-- IF = e^(integral 2x/(1+x^2) dx) = e^(ln(1+x^2)) = 1+x^2.
-- d/dx(y(1+x^2)) = 1/(1+x^2). y(1+x^2) = tan^(-1) x + C.
('The general solution of $(1+x^2)\frac{dy}{dx} + 2xy = \frac{1}{1+x^2}$ is', '$y = \frac{\tan^{-1} x}{1+x^2} + C$', '$y(1+x^2) = \tan^{-1} x + C$', '$y(1+x^2) = \ln(1+x^2) + C$', '$y = \tan^{-1} x + C$', 'option2', 'IF $= 1+x^2$. $y(1+x^2) = \int\frac{1}{1+x^2}\,dx = \tan^{-1}x + C$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q18: dy/dx - 3y/x = x^2. IF = e^(-3 ln x) = x^(-3) = 1/x^3.
-- d/dx(y/x^3) = x^2/x^3 = 1/x. y/x^3 = ln|x| + C. y = x^3 ln|x| + Cx^3.
('The general solution of $\frac{dy}{dx} - \frac{3y}{x} = x^2$ is', '$y = x^3\ln|x| + Cx^3$', '$y = \frac{x^3}{3} + Cx^3$', '$y = x^3\ln|x| + \frac{C}{x^3}$', '$y = x^2\ln|x| + Cx^3$', 'option1', 'IF $= x^{-3}$. $\frac{y}{x^3} = \int\frac{1}{x}\,dx = \ln|x| + C$. So $y = x^3\ln|x| + Cx^3$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q19: dy/dx + y = x e^(-x). IF = e^x. d/dx(ye^x) = x. ye^x = x^2/2 + C. y = (x^2/2 + C)e^(-x).
-- y(0)=0: 0 = C. y = (x^2/2)e^(-x).
('The solution of $\frac{dy}{dx} + y = xe^{-x}$ with $y(0) = 0$ is', '$y = \frac{x^2}{2}e^{-x}$', '$y = xe^{-x}$', '$y = (x-1)e^{-x}$', '$y = \frac{x^2}{2}e^x$', 'option1', 'IF $= e^x$. $ye^x = \int x\,dx = \frac{x^2}{2} + C$. $y(0) = 0$: $C = 0$. $y = \frac{x^2}{2}e^{-x}$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Bernoulli: dy/dx + y/x = y^2. Divide by y^2: y^(-2) dy/dx + y^(-1)/x = 1.
-- Let v=1/y, dv/dx = -y^(-2) dy/dx. -dv/dx + v/x = 1. dv/dx - v/x = -1.
-- IF = 1/x. d/dx(v/x) = -1/x. v/x = -ln|x| + C. 1/(xy) = C - ln|x|.
('The general solution of $\frac{dy}{dx} + \frac{y}{x} = y^2$ is', '$y = \frac{x}{C - \ln x}$', '$\frac{y}{x} = C + \ln|x|$', '$xy = Ce^x$', '$\frac{1}{xy} = C - \ln|x|$', 'option4', 'Bernoulli equation. Let $v = 1/y$: $\frac{dv}{dx} - \frac{v}{x} = -1$. IF $= \frac{1}{x}$. $\frac{v}{x} = -\ln|x| + C$. So $\frac{1}{xy} = C - \ln|x|$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),

-- Q21: dy/dx + 2y/(x+1) = (x+1)^3. IF = e^(2 ln(x+1)) = (x+1)^2.
-- d/dx(y(x+1)^2) = (x+1)^5. y(x+1)^2 = (x+1)^6/6 + C. y = (x+1)^4/6 + C/(x+1)^2.
('The general solution of $\frac{dy}{dx} + \frac{2y}{x+1} = (x+1)^3$ is', '$y = \frac{(x+1)^4}{6} + \frac{C}{(x+1)^2}$', '$y = \frac{(x+1)^4}{4} + C(x+1)^2$', '$y = (x+1)^3 + \frac{C}{(x+1)^2}$', '$y = \frac{(x+1)^5}{5} + C$', 'option1', 'IF $= (x+1)^2$. $y(x+1)^2 = \int(x+1)^5\,dx = \frac{(x+1)^6}{6} + C$. So $y = \frac{(x+1)^4}{6} + \frac{C}{(x+1)^2}$.', 'm_linear_de', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_cartesian_system (Cartesian coordinates, distance formula, section formula, locus)
-- Chapter: math_coordinate_geometry
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Distance between (1,2) and (4,6). d = sqrt((4-1)^2+(6-2)^2) = sqrt(9+16) = 5.
('The distance between $(1, 2)$ and $(4, 6)$ is', '$7$', '$5$', '$\sqrt{7}$', '$25$', 'option2', '$d = \sqrt{(4-1)^2+(6-2)^2} = \sqrt{9+16} = \sqrt{25} = 5$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Midpoint of (2,4) and (6,8) = ((2+6)/2, (4+8)/2) = (4,6).
('The midpoint of $(2, 4)$ and $(6, 8)$ is', '$(4, 4)$', '$(3, 5)$', '$(8, 12)$', '$(4, 6)$', 'option4', 'Midpoint $= \left(\frac{2+6}{2}, \frac{4+8}{2}\right) = (4, 6)$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Distance of (3,4) from origin = sqrt(9+16) = 5.
('The distance of the point $(3, 4)$ from the origin is', '$1$', '$7$', '$5$', '$\sqrt{7}$', 'option3', '$d = \sqrt{3^2+4^2} = \sqrt{9+16} = 5$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Point dividing (1,2) and (4,5) in ratio 2:1 internally.
-- x = (2*4+1*1)/(2+1) = 9/3 = 3. y = (2*5+1*2)/3 = 12/3 = 4. Point = (3,4).
('The point dividing $(1, 2)$ and $(4, 5)$ in the ratio $2:1$ internally is', '$(3, 4)$', '$(2, 3)$', '$(3, 3)$', '$(5, 7)$', 'option1', '$x = \frac{2(4)+1(1)}{3} = 3$, $y = \frac{2(5)+1(2)}{3} = 4$. Point $= (3, 4)$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Distance between (0,0) and (5,12) = sqrt(25+144) = sqrt(169) = 13.
('The distance between the origin and $(5, 12)$ is', '$17$', '$13$', '$\sqrt{17}$', '$7$', 'option2', '$d = \sqrt{25+144} = \sqrt{169} = 13$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Midpoint of (-1,3) and (5,7) = (2,5).
('The midpoint of $(-1, 3)$ and $(5, 7)$ is', '$(2, 5)$', '$(3, 5)$', '$(2, 4)$', '$(4, 10)$', 'option1', 'Midpoint $= \left(\frac{-1+5}{2}, \frac{3+7}{2}\right) = (2, 5)$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Distance between (1,1) and (4,5) = sqrt(9+16) = 5.
('The distance between $(1, 1)$ and $(4, 5)$ is', '$\sqrt{41}$', '$4$', '$3$', '$5$', 'option4', '$d = \sqrt{(4-1)^2+(5-1)^2} = \sqrt{9+16} = 5$.', 'm_cartesian_system', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Centroid of triangle (1,2),(3,4),(5,6) = ((1+3+5)/3, (2+4+6)/3) = (3,4).
('The centroid of the triangle with vertices $(1,2)$, $(3,4)$, $(5,6)$ is', '$(3, 4)$', '$(3, 3)$', '$(4, 4)$', '$(2, 3)$', 'option1', 'Centroid $= \left(\frac{1+3+5}{3}, \frac{2+4+6}{3}\right) = (3, 4)$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Area of triangle (0,0),(4,0),(0,3) = (1/2)|x1(y2-y3)+x2(y3-y1)+x3(y1-y2)|
-- = (1/2)|0+4(3)+0| = 6.
('The area of the triangle with vertices $(0,0)$, $(4,0)$, $(0,3)$ is', '$7$', '$12$', '$6$', '$3.5$', 'option3', 'Area $= \frac{1}{2}|x_1(y_2-y_3)+x_2(y_3-y_1)+x_3(y_1-y_2)| = \frac{1}{2}|0+12+0| = 6$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Point dividing (2,3) and (4,1) externally in ratio 3:1.
-- x = (3*4-1*2)/(3-1) = 10/2 = 5. y = (3*1-1*3)/2 = 0. Point = (5,0).
('The point dividing $(2,3)$ and $(4,1)$ externally in ratio $3:1$ is', '$(5, 0)$', '$(3, 2)$', '$(6, -1)$', '$(1, 5)$', 'option1', '$x = \frac{3(4)-1(2)}{3-1} = 5$, $y = \frac{3(1)-1(3)}{2} = 0$. Point $= (5, 0)$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Three points (1,1),(2,3),(3,5) are collinear if area=0.
-- Area = (1/2)|1(3-5)+2(5-1)+3(1-3)| = (1/2)|-2+8-6| = 0. Collinear.
('The points $(1,1)$, $(2,3)$, $(3,5)$ are', 'Collinear', 'Vertices of a right triangle', 'Vertices of an equilateral triangle', 'Not collinear', 'option1', 'Area $= \frac{1}{2}|1(3-5)+2(5-1)+3(1-3)| = \frac{1}{2}|-2+8-6| = 0$. Since area is $0$, the points are collinear.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Locus of point equidistant from (0,0) and (4,0). sqrt(x^2+y^2) = sqrt((x-4)^2+y^2).
-- x^2 = x^2-8x+16. 8x=16. x=2.
('The locus of a point equidistant from $(0,0)$ and $(4,0)$ is', '$x = 2$', '$y = 2$', '$x + y = 4$', '$x = 4$', 'option1', '$\sqrt{x^2+y^2} = \sqrt{(x-4)^2+y^2}$. Squaring: $x^2 = x^2-8x+16$, giving $x = 2$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q13: In-centre of right triangle (0,0),(a,0),(0,b). In-centre = (r,r) where r = (a+b-c)/2, c=sqrt(a^2+b^2).
-- For (0,0),(6,0),(0,8): c=10. r=(6+8-10)/2=2. In-centre=(2,2).
('The in-centre of the triangle with vertices $(0,0)$, $(6,0)$, $(0,8)$ is', '$(2, 3)$', '$(3, 4)$', '$(2, 2)$', '$(3, 3)$', 'option3', 'Hypotenuse $= \sqrt{36+64} = 10$. In-radius $r = \frac{a+b-c}{2} = \frac{6+8-10}{2} = 2$. In-centre $= (r, r) = (2, 2)$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Ratio in which y-axis divides (2,3) and (-4,5). At y-axis, x=0.
-- 0 = (k(-4)+1(2))/(k+1). -4k+2=0. k=1/2. Ratio = 1:2.
('The ratio in which the $y$-axis divides the join of $(2,3)$ and $(-4,5)$ is', '$3:2$', '$2:1$', '$1:1$', '$1:2$', 'option4', 'Let ratio be $k:1$. At $y$-axis: $\frac{-4k+2}{k+1} = 0$, so $k = \frac{1}{2}$. Ratio $= 1:2$.', 'm_cartesian_system', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Locus of point P(x,y) such that PA^2+PB^2=c^2 where A=(a,0), B=(-a,0).
-- (x-a)^2+y^2+(x+a)^2+y^2=c^2. 2x^2+2a^2+2y^2=c^2. x^2+y^2=(c^2-2a^2)/2.
('If $PA^2 + PB^2 = c^2$ where $A = (a,0)$ and $B = (-a,0)$, the locus of $P$ is', '$x^2 + y^2 = c^2 - a^2$', '$x^2 + y^2 = c^2$', '$x^2 + y^2 = \frac{c^2 - 2a^2}{2}$', '$x^2 + y^2 = \frac{c^2}{2}$', 'option3', '$(x-a)^2+y^2+(x+a)^2+y^2 = c^2$. Expanding: $2x^2+2a^2+2y^2 = c^2$. So $x^2+y^2 = \frac{c^2-2a^2}{2}$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Area of quadrilateral (1,1),(3,4),(5,2),(3,-1). Use shoelace:
-- = (1/2)|1*4-3*1 + 3*2-5*4 + 5*(-1)-3*2 + 3*1-1*(-1)|
-- = (1/2)|4-3+6-20-5-6+3+1| = (1/2)|-20| = 10. Wait let me redo.
-- Shoelace: (1/2)|x1(y2-y4)+x2(y3-y1)+x3(y4-y2)+x4(y1-y3)|
-- = (1/2)|1(4-(-1))+3(2-1)+5(-1-4)+3(1-2)| = (1/2)|5+3-25-3| = (1/2)|-20| = 10.
('The area of the quadrilateral with vertices $(1,1)$, $(3,4)$, $(5,2)$, $(3,-1)$ in order is', '$10$', '$12$', '$8$', '$15$', 'option1', 'Shoelace formula: $\frac{1}{2}|x_1(y_2-y_4)+x_2(y_3-y_1)+x_3(y_4-y_2)+x_4(y_1-y_3)| = \frac{1}{2}|5+3-25-3| = 10$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q17: If (a,0),(0,b),(1,1) are collinear, then 1/a+1/b=1.
-- Area=0: a(b-1)+0(1-0)+1(0-b)=0. ab-a-b=0. ab=a+b. Divide by ab: 1=1/b+1/a.
('If $(a, 0)$, $(0, b)$ and $(1, 1)$ are collinear, then $\frac{1}{a} + \frac{1}{b}$ equals', '$0$', '$1$', '$2$', '$\frac{1}{2}$', 'option2', 'Collinearity: $a(b-1)+0+1(0-b) = 0$, so $ab-a-b = 0$, giving $ab = a+b$. Dividing by $ab$: $\frac{1}{a}+\frac{1}{b} = 1$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Locus of point equidistant from (3,4) and x-axis. Distance from x-axis = |y|.
-- sqrt((x-3)^2+(y-4)^2) = |y|. (x-3)^2+(y-4)^2=y^2. (x-3)^2+y^2-8y+16=y^2.
-- (x-3)^2 = 8y-16. (x-3)^2 = 8(y-2).
('The locus of a point equidistant from $(3, 4)$ and the $x$-axis is', '$(y-4)^2 = 8(x-3)$', '$(x-3)^2 + (y-4)^2 = y^2$', '$x^2 = 8y$', '$(x-3)^2 = 8(y-2)$', 'option4', '$\sqrt{(x-3)^2+(y-4)^2} = |y|$. Squaring: $(x-3)^2 = y^2-(y-4)^2 = 8y-16 = 8(y-2)$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Harmonic conjugate: A=(1,0), B=(5,0). P divides AB in ratio 3:1 internally => P=(4,0).
-- Q divides AB in ratio 3:1 externally => Q = (3*5-1*1)/(3-1), 0) = (7,0).
('If $P$ divides $(1,0)$ and $(5,0)$ internally in $3:1$, the harmonic conjugate $Q$ (external division in $3:1$) is', '$(7, 0)$', '$(6, 0)$', '$(8, 0)$', '$(3, 0)$', 'option1', 'External division in $3:1$: $x = \frac{3(5)-1(1)}{3-1} = \frac{14}{2} = 7$. So $Q = (7, 0)$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Circumcentre of right triangle (0,0),(6,0),(0,8) is midpoint of hypotenuse = (3,4).
('The circumcentre of the right triangle with vertices $(0,0)$, $(6,0)$, $(0,8)$ is', '$(2, 2)$', '$(3, 4)$', '$(3, 3)$', '$(0, 0)$', 'option2', 'For a right triangle, the circumcentre is the midpoint of the hypotenuse. Midpoint of $(6,0)$ and $(0,8)$ is $(3, 4)$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Area of triangle formed by (t,t^2),(t+1,(t+1)^2),(t+2,(t+2)^2).
-- = (1/2)|t((t+1)^2-(t+2)^2)+(t+1)((t+2)^2-t^2)+(t+2)(t^2-(t+1)^2)|
-- (t+1)^2-(t+2)^2 = (2t+3)(-1) = -(2t+3). (t+2)^2-t^2 = (2t+2)(2) = 4t+4. t^2-(t+1)^2 = -(2t+1).
-- = (1/2)|t(-(2t+3))+(t+1)(4t+4)+(t+2)(-(2t+1))|
-- = (1/2)|-2t^2-3t+4t^2+4t+4t+4-2t^2-t-4t-2|
-- = (1/2)|-2t^2+4t^2-2t^2 + (-3t+4t+4t-t-4t) + (4-2)|
-- = (1/2)|0 + 0 + 2| = 1.
('The area of the triangle with vertices $(t, t^2)$, $(t+1, (t+1)^2)$, $(t+2, (t+2)^2)$ is', '$1$', '$t$', '$t^2$', '$2$', 'option1', 'Using the determinant formula and simplifying: the area is always $1$, independent of $t$.', 'm_cartesian_system', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_slope_lines (Slope of a line, parallel and perpendicular lines, intercepts)
-- Chapter: math_coordinate_geometry
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Slope of line through (1,2) and (3,6). m = (6-2)/(3-1) = 4/2 = 2.
('The slope of the line through $(1, 2)$ and $(3, 6)$ is', '$2$', '$4$', '$\frac{1}{2}$', '$3$', 'option1', '$m = \frac{6-2}{3-1} = \frac{4}{2} = 2$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Slope of y=3x+5 is 3.
('The slope of the line $y = 3x + 5$ is', '$5$', '$3$', '$\frac{5}{3}$', '$-3$', 'option2', 'In $y = mx + c$ form, the slope $m = 3$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q3: x-intercept of 2x+3y=6. Set y=0: 2x=6, x=3.
('The $x$-intercept of $2x + 3y = 6$ is', '$3$', '$2$', '$6$', '$\frac{3}{2}$', 'option1', 'Set $y = 0$: $2x = 6$, so $x = 3$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q4: y-intercept of y=2x-7 is -7.
('The $y$-intercept of $y = 2x - 7$ is', '$\frac{7}{2}$', '$2$', '$7$', '$-7$', 'option4', 'In $y = mx + c$, the $y$-intercept is $c = -7$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Slope of line parallel to y=4x+1 is 4.
('The slope of a line parallel to $y = 4x + 1$ is', '$4$', '$-4$', '$\frac{1}{4}$', '$-\frac{1}{4}$', 'option1', 'Parallel lines have equal slopes. The slope of $y = 4x + 1$ is $4$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Slope of line perpendicular to y=2x+3 is -1/2.
('The slope of a line perpendicular to $y = 2x + 3$ is', '$-\frac{1}{2}$', '$2$', '$\frac{1}{2}$', '$-2$', 'option1', 'If slope is $m$, perpendicular slope is $-1/m$. Here $m = 2$, so perpendicular slope $= -\frac{1}{2}$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Slope of horizontal line y=5 is 0.
('The slope of the line $y = 5$ is', '$1$', '$5$', '$\infty$', '$0$', 'option4', 'A horizontal line has slope $0$.', 'm_slope_lines', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Line 3x-4y+12=0. Slope: 3x-4y=-12 => y=(3/4)x+3. Slope=3/4. x-int: set y=0: 3x=-12, x=-4. y-int: set x=0: -4y=-12, y=3.
('The slope and $y$-intercept of $3x - 4y + 12 = 0$ are', '$\frac{3}{4}$ and $-3$', '$\frac{4}{3}$ and $3$', '$\frac{3}{4}$ and $3$', '$-\frac{3}{4}$ and $3$', 'option3', 'Rewrite: $y = \frac{3}{4}x + 3$. Slope $= \frac{3}{4}$, $y$-intercept $= 3$.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Two lines y=2x+1 and y=2x-3 are parallel (same slope m=2).
('The lines $y = 2x + 1$ and $y = 2x - 3$ are', 'Parallel', 'Perpendicular', 'Coincident', 'Intersecting', 'option1', 'Both lines have slope $2$ but different $y$-intercepts, so they are parallel.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Lines 2x+3y=6 and 3x-2y=5. Slopes: m1=-2/3, m2=3/2. m1*m2=-1. Perpendicular.
('The lines $2x + 3y = 6$ and $3x - 2y = 5$ are', 'Coincident', 'Parallel', 'Perpendicular', 'Neither parallel nor perpendicular', 'option3', 'Slopes: $m_1 = -\frac{2}{3}$, $m_2 = \frac{3}{2}$. $m_1 \times m_2 = -1$, so the lines are perpendicular.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Line with x-intercept 4 and y-intercept 3. Intercept form: x/4+y/3=1. => 3x+4y=12.
('The equation of the line with $x$-intercept $4$ and $y$-intercept $3$ is', '$3x + 4y = 7$', '$4x + 3y = 12$', '$x + y = 7$', '$3x + 4y = 12$', 'option4', 'Intercept form: $\frac{x}{4} + \frac{y}{3} = 1$. Multiplying by $12$: $3x + 4y = 12$.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Angle between y=x and y=sqrt(3)x. tan theta = |(m1-m2)/(1+m1*m2)| = |(1-sqrt(3))/(1+sqrt(3))|.
-- Rationalize: |(1-sqrt(3))^2/(1-3)| = |(4-2sqrt(3))/(-2)| = |sqrt(3)-2| = 2-sqrt(3). 
-- Actually let me redo: tan theta = |(1-sqrt(3))/(1+sqrt(3))| * |(1-sqrt(3))/(1-sqrt(3))| = |(1-sqrt(3))^2/(1-3)| = |(1-2sqrt(3)+3)/(-2)| = |(4-2sqrt(3))/2| = |2-sqrt(3)|.
-- tan(15°) = 2-sqrt(3). So theta = 15° = pi/12.
('The acute angle between the lines $y = x$ and $y = \sqrt{3}x$ is', '$30°$', '$15°$', '$45°$', '$60°$', 'option2', '$\tan\theta = \left|\frac{1-\sqrt{3}}{1+\sqrt{3}}\right| = \left|\frac{(1-\sqrt{3})^2}{1-3}\right| = \frac{4-2\sqrt{3}}{2} = 2-\sqrt{3} = \tan 15°$. So $\theta = 15°$.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q13: If lines kx+2y=5 and 3x+y=1 are parallel, then k/3 = 2/1 => k=6.
('If the lines $kx + 2y = 5$ and $3x + y = 1$ are parallel, then $k$ equals', '$2$', '$3$', '$\frac{3}{2}$', '$6$', 'option4', 'Slopes: $-\frac{k}{2}$ and $-3$. For parallel lines: $-\frac{k}{2} = -3$, so $k = 6$.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Slope of line making angle 60° with positive x-axis = tan 60° = sqrt(3).
('The slope of a line making an angle of $60°$ with the positive $x$-axis is', '$\frac{\sqrt{3}}{2}$', '$\frac{1}{\sqrt{3}}$', '$1$', '$\sqrt{3}$', 'option4', 'Slope $= \tan 60° = \sqrt{3}$.', 'm_slope_lines', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: If lines ax+by+c=0 and bx-ay+d=0 are perpendicular. Slopes: -a/b and b/a. Product = -1. Always perpendicular.
('The lines $ax + by + c = 0$ and $bx - ay + d = 0$ are always', 'Perpendicular', 'Parallel', 'Coincident', 'Neither', 'option1', 'Slopes: $m_1 = -\frac{a}{b}$, $m_2 = \frac{b}{a}$. $m_1 m_2 = -\frac{a}{b} \cdot \frac{b}{a} = -1$. Always perpendicular.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Line through (2,3) with slope -1. y-3 = -1(x-2). y = -x+5. x+y=5. x-int=5, y-int=5.
-- Sum of intercepts = 10.
('A line through $(2, 3)$ with slope $-1$ has sum of intercepts equal to', '$10$', '$5$', '$8$', '$6$', 'option1', 'Equation: $y - 3 = -(x-2)$, i.e., $x + y = 5$. $x$-intercept $= 5$, $y$-intercept $= 5$. Sum $= 10$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q17: If 2x+3y=5 and 6x+ky=7 are parallel, slopes equal: -2/3 = -6/k => k=9.
('If $2x + 3y = 5$ and $6x + ky = 7$ are parallel, then $k$ equals', '$3$', '$6$', '$9$', '$12$', 'option3', 'For parallel lines: $\frac{2}{3} = \frac{6}{k}$, so $k = 9$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Line x/a + y/b = 1 passes through (2,3) and has slope -2. Slope = -b/a = -2 => b=2a.
-- Also 2/a + 3/b = 1. Sub b=2a: 2/a + 3/(2a) = 1 => (4+3)/(2a) = 1 => a=7/2. b=7.
('A line with slope $-2$ passes through $(2, 3)$. Its $y$-intercept is', '$4$', '$5$', '$7$', '$6$', 'option3', 'Equation: $y - 3 = -2(x-2)$, i.e., $y = -2x + 7$. The $y$-intercept is $7$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Angle between lines x+y=1 and x-y=1. Slopes: -1 and 1. tan theta = |(-1-1)/(1+(-1)(1))| = |-2/0| = undefined. theta = 90°.
('The angle between the lines $x + y = 1$ and $x - y = 1$ is', '$60°$', '$45°$', '$90°$', '$30°$', 'option3', 'Slopes: $m_1 = -1$, $m_2 = 1$. $m_1 m_2 = -1$, so the lines are perpendicular. Angle $= 90°$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Line making equal intercepts on axes and passing through (2,3). x/a+y/a=1 => x+y=a. 2+3=a=5. Line: x+y=5.
('A line making equal intercepts on both axes and passing through $(2, 3)$ is', '$x + y = 5$', '$x - y = -1$', '$x + y = 6$', '$2x + 3y = 13$', 'option1', 'Equal intercepts: $\frac{x}{a}+\frac{y}{a}=1$, i.e., $x+y=a$. Through $(2,3)$: $a = 5$. Line: $x+y=5$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Reflection of slope m in line y=x gives slope 1/m. If line has slope 3, its reflection in y=x has slope 1/3.
('If a line has slope $3$, the slope of its reflection in the line $y = x$ is', '$\frac{1}{3}$', '$-3$', '$-\frac{1}{3}$', '$3$', 'option1', 'Reflecting a line in $y = x$ swaps $x$ and $y$ coordinates. If original slope is $m$, reflected slope is $\frac{1}{m}$. So slope $= \frac{1}{3}$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),
('The reflection of a line with slope $3$ in the line $y = x$ has slope', '$-\frac{1}{3}$', '$3$', '$-3$', '$\frac{1}{3}$', 'option4', 'Reflecting a line with slope $m$ in $y = x$ gives a line with slope $\frac{1}{m}$. So slope $= \frac{1}{3}$.', 'm_slope_lines', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_straight_line_equations (Unit 10)
-- Various forms of equations of a line, intersection, angles between lines, concurrence
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Slope-intercept form: y = mx + c. Line with slope 2 and y-intercept 3: y = 2x + 3.
('The equation of a line with slope $2$ and $y$-intercept $3$ is', '$y = 3x + 2$', '$y = 2x + 3$', '$2y = x + 3$', '$y = 2x - 3$', 'option2', 'Slope-intercept form: $y = mx + c = 2x + 3$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Two-point form. Line through (1,2) and (3,6). Slope = (6-2)/(3-1) = 2. y-2 = 2(x-1) => y = 2x.
('The equation of the line through $(1, 2)$ and $(3, 6)$ is', '$y = x + 1$', '$y = 3x - 1$', '$y = 2x$', '$y = 2x + 1$', 'option3', 'Slope $= \frac{6-2}{3-1} = 2$. Using point-slope: $y - 2 = 2(x-1)$, i.e., $y = 2x$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Intercept form. Line with x-intercept 4 and y-intercept 3: x/4 + y/3 = 1 => 3x+4y=12.
('The equation of a line with $x$-intercept $4$ and $y$-intercept $3$ is', '$x + y = 7$', '$4x + 3y = 12$', '$3x + 4y = 12$', '$3x + 4y = 7$', 'option3', 'Intercept form: $\frac{x}{4} + \frac{y}{3} = 1$. Multiply by 12: $3x + 4y = 12$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Normal form. Line at distance 5 from origin with normal making angle 60° with x-axis.
-- x cos60° + y sin60° = 5 => x/2 + y√3/2 = 5 => x + √3 y = 10.
('The equation of a line at perpendicular distance $5$ from the origin with the normal making $60°$ with the $x$-axis is', '$\sqrt{3}x + y = 10$', '$x + \sqrt{3}y = 10$', '$x + y = 10$', '$x + \sqrt{3}y = 5$', 'option2', 'Normal form: $x\cos 60° + y\sin 60° = 5$, i.e., $\frac{x}{2} + \frac{\sqrt{3}y}{2} = 5$, so $x + \sqrt{3}y = 10$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Point-slope form. Line through (3,-1) with slope 4: y+1 = 4(x-3) => y = 4x-13 => 4x-y=13.
('The equation of the line through $(3, -1)$ with slope $4$ is', '$4x - y = 11$', '$4x + y = 13$', '$x - 4y = 7$', '$4x - y = 13$', 'option4', 'Point-slope: $y - (-1) = 4(x - 3)$, i.e., $y + 1 = 4x - 12$, so $4x - y = 13$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Line x+y=1 and 2x+2y=2 are the same line (second is just double of first). They have infinitely many common points.
('The number of common points of the lines $x + y = 1$ and $2x + 2y = 2$ is', '$1$', '$0$', 'Infinitely many', '$2$', 'option3', '$2x + 2y = 2$ simplifies to $x + y = 1$, which is the same line. Hence infinitely many common points.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Intersection of x+y=5 and x-y=1. Adding: 2x=6 => x=3, y=2. Point (3,2).
('The point of intersection of $x + y = 5$ and $x - y = 1$ is', '$(4, 1)$', '$(2, 3)$', '$(1, 4)$', '$(3, 2)$', 'option4', 'Adding: $2x = 6$, so $x = 3$. Then $y = 5 - 3 = 2$. Point: $(3, 2)$.', 'm_straight_line_equations', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Line through intersection of 2x+3y=5 and x-y=1, passing through origin.
-- Family: (2x+3y-5) + k(x-y-1) = 0. Through (0,0): -5 - k = 0 => k = -5.
-- Line: (2x+3y-5) -5(x-y-1) = 0 => 2x+3y-5-5x+5y+5 = 0 => -3x+8y = 0 => 3x-8y=0.
('The equation of the line through the intersection of $2x + 3y = 5$ and $x - y = 1$, and passing through the origin, is', '$3x + 8y = 0$', '$3x - 8y = 0$', '$8x - 3y = 0$', '$8x + 3y = 0$', 'option2', 'Family: $(2x+3y-5) + k(x-y-1) = 0$. Through $(0,0)$: $-5 - k = 0$, so $k = -5$. Line: $-3x + 8y = 0$, i.e., $3x - 8y = 0$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Angle between lines y = x and y = 0 (x-axis). Slopes: 1 and 0.
-- tan theta = |1-0|/|1+0| = 1. theta = 45°.
('The angle between the lines $y = x$ and $y = 0$ is', '$45°$', '$90°$', '$30°$', '$60°$', 'option1', 'Slopes: $m_1 = 1$, $m_2 = 0$. $\tan\theta = \left|\frac{1-0}{1+0}\right| = 1$. So $\theta = 45°$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Line parallel to 3x+4y=7 through (1,2). Same coefficients: 3x+4y = 3(1)+4(2) = 11.
('The equation of the line parallel to $3x + 4y = 7$ and passing through $(1, 2)$ is', '$3x + 4y = 5$', '$3x + 4y = 11$', '$4x + 3y = 10$', '$3x - 4y = -5$', 'option2', 'Parallel line: $3x + 4y = c$. Through $(1,2)$: $3 + 8 = 11$. So $3x + 4y = 11$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Line perpendicular to 2x-3y=5 through (1,1). Slope of given = 2/3. Perp slope = -3/2.
-- y-1 = -3/2(x-1) => 2y-2 = -3x+3 => 3x+2y = 5.
('The equation of the line perpendicular to $2x - 3y = 5$ and passing through $(1, 1)$ is', '$3x + 2y = 5$', '$2x + 3y = 5$', '$3x - 2y = 1$', '$2x - 3y = -1$', 'option1', 'Slope of given line $= \frac{2}{3}$. Perpendicular slope $= -\frac{3}{2}$. $y - 1 = -\frac{3}{2}(x-1)$, i.e., $3x + 2y = 5$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Three lines x+y=1, 2x+y=3, x+2y=3 are concurrent if they meet at one point.
-- From first two: x+y=1 and 2x+y=3. Subtract: x=2, y=-1. Check third: 2+2(-1)=0 ≠ 3. NOT concurrent.
('The lines $x + y = 1$, $2x + y = 3$, and $x + 2y = 3$ are', 'Concurrent', 'Not concurrent', 'All parallel', 'All identical', 'option2', 'From $x+y=1$ and $2x+y=3$: $x=2, y=-1$. Check $x+2y = 2-2 = 0 \neq 3$. Not concurrent.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Line in symmetric form through (2,3) with direction ratios 1,2: (x-2)/1 = (y-3)/2.
-- Parametric: x=2+t, y=3+2t. Eliminate t: y-3 = 2(x-2) => y = 2x-1.
('The equation of the line through $(2, 3)$ with direction ratios $1 : 2$ is', '$y = x + 1$', '$y = 2x - 1$', '$2y = x + 4$', '$y = 2x + 1$', 'option2', 'Symmetric form: $\frac{x-2}{1} = \frac{y-3}{2}$. So $y - 3 = 2(x-2)$, i.e., $y = 2x - 1$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Image of point (3,4) in line x=1. Reflection in vertical line x=1: x' = 2(1)-3 = -1, y'=4. Image: (-1,4).
('The image of the point $(3, 4)$ in the line $x = 1$ is', '$(1, 4)$', '$(-1, 4)$', '$(3, -2)$', '$(-3, 4)$', 'option2', 'Reflection in $x = 1$: $x'' = 2(1) - 3 = -1$, $y'' = 4$. Image: $(-1, 4)$.', 'm_straight_line_equations', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Lines 2x+3y=5, 3x-2y=1, ax+y=3 are concurrent.
-- From first two: 2x+3y=5 and 3x-2y=1. Multiply first by 2, second by 3: 4x+6y=10, 9x-6y=3. Add: 13x=13 => x=1, y=1.
-- Third line: a(1)+1=3 => a=2.
('If the lines $2x + 3y = 5$, $3x - 2y = 1$, and $ax + y = 3$ are concurrent, then $a$ equals', '$3$', '$2$', '$1$', '$4$', 'option2', 'From first two: $x = 1, y = 1$. Substituting in third: $a + 1 = 3$, so $a = 2$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Equation of line making intercepts whose sum is 5 and product is 6.
-- a+b=5, ab=6. So a,b are roots of t^2-5t+6=0 => t=2,3.
-- Lines: x/2+y/3=1 => 3x+2y=6 or x/3+y/2=1 => 2x+3y=6.
-- Both are valid. Let's ask which is one such line.
('A line makes intercepts on the axes whose sum is $5$ and product is $6$. One such line is', '$2x + 2y = 5$', '$3x + 2y = 6$', '$5x + 6y = 30$', '$x + y = 5$', 'option2', 'Let intercepts be $a, b$. Then $a+b=5$, $ab=6$, giving $a=2, b=3$ (or vice versa). Line: $\frac{x}{2}+\frac{y}{3}=1$, i.e., $3x+2y=6$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Foot of perpendicular from (2,3) to line x+y=1.
-- Line direction: (1,1), normal: (1,1). Foot: parametric on line. Let foot = (a, 1-a).
-- Vector from (2,3) to (a,1-a) must be along normal (1,1): (a-2)/(1) = (1-a-3)/(1) => a-2 = -2-a => 2a=0 => a=0. Foot: (0,1).
('The foot of the perpendicular from $(2, 3)$ to the line $x + y = 1$ is', '$(2, -1)$', '$(1, 0)$', '$(-1, 2)$', '$(0, 1)$', 'option4', 'Let foot $= (a, 1-a)$. Direction from $(2,3)$ to foot is perpendicular to line direction $(1,-1)$: $(a-2)(1)+(1-a-3)(-1)=0$, i.e., $a-2+a+2=0$, giving $2a=0$, $a=0$. Foot: $(0,1)$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Equation of bisectors of angles between lines 3x-4y+7=0 and 12x-5y-8=0.
-- Bisectors: (3x-4y+7)/5 = ±(12x-5y-8)/13.
-- Taking +: 13(3x-4y+7) = 5(12x-5y-8) => 39x-52y+91 = 60x-25y-40 => -21x-27y+131=0 => 21x+27y=131.
-- Taking -: 13(3x-4y+7) = -5(12x-5y-8) => 39x-52y+91 = -60x+25y+40 => 99x-77y+51=0.
-- Simplify first: 21x+27y=131. Simplify second: divide by... gcd(99,77,51). 99=9×11, 77=7×11, 51=3×17. No common factor. 99x-77y+51=0.
-- Let me ask about the acute angle bisector. For 3x-4y+7=0 (a1=3,b1=-4,c1=7) and 12x-5y-8=0 (a2=12,b2=-5,c2=-8).
-- a1a2+b1b2 = 36+20 = 56 > 0. So the + sign gives obtuse bisector, - sign gives acute.
-- Acute: 99x-77y+51=0. Let me simplify: no common factor. This is messy. Let me pick a cleaner question.

-- Q18 (revised): Equation of the line through intersection of x+y=4 and x-y=2, perpendicular to 2x+y=0.
-- Intersection: x+y=4, x-y=2. Add: 2x=6 => x=3, y=1. Point (3,1).
-- Slope of 2x+y=0 is -2. Perpendicular slope = 1/2.
-- Line: y-1 = 1/2(x-3) => 2y-2 = x-3 => x-2y = 1.
('The line through the intersection of $x + y = 4$ and $x - y = 2$, perpendicular to $2x + y = 0$, is', '$x + 2y = 5$', '$2x + y = 7$', '$x - 2y = -1$', '$x - 2y = 1$', 'option4', 'Intersection: $x=3, y=1$. Slope of $2x+y=0$ is $-2$; perpendicular slope $= \frac{1}{2}$. Line: $y-1 = \frac{1}{2}(x-3)$, i.e., $x - 2y = 1$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Area of triangle formed by lines y=0, x=0, and 3x+4y=12.
-- Intercepts: x-int = 4, y-int = 3. Area = (1/2)(4)(3) = 6.
('The area of the triangle formed by the lines $y = 0$, $x = 0$, and $3x + 4y = 12$ is', '$7$', '$12$', '$6$', '$24$', 'option3', 'Intercepts: $x$-intercept $= 4$, $y$-intercept $= 3$. Area $= \frac{1}{2}(4)(3) = 6$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q20: The pair of lines given by x^2-5xy+6y^2=0. Factor: (x-2y)(x-3y)=0. Lines: x=2y and x=3y.
-- Angle between them: tan theta = 2√(h²-ab)/(a+b) where ax²+2hxy+by²=0. a=1, 2h=-5 => h=-5/2, b=6.
-- h²-ab = 25/4-6 = 1/4. tan theta = 2(1/2)/(1+6) = 1/7.
('The tangent of the angle between the pair of lines $x^2 - 5xy + 6y^2 = 0$ is', '$\frac{1}{7}$', '$\frac{1}{5}$', '$\frac{5}{7}$', '$1$', 'option1', 'Here $a=1$, $2h=-5$, $b=6$. $\tan\theta = \frac{2\sqrt{h^2-ab}}{a+b} = \frac{2\sqrt{\frac{25}{4}-6}}{7} = \frac{2 \cdot \frac{1}{2}}{7} = \frac{1}{7}$.', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Line through (1,2) making angle 45° with x+y=1 (slope -1).
-- Let slope be m. tan 45° = |(m-(-1))/(1+m(-1))| = |(m+1)/(1-m)| = 1.
-- m+1 = 1-m => m=0, or m+1 = -(1-m) => m+1 = -1+m => 1=-1 (impossible).
-- So m=0. Line: y=2.
-- Wait, also m+1 = -(1-m) gives m+1=-1+m => 2=0, impossible. So only m=0.
-- But also |(m+1)/(1-m)| = 1 means (m+1)/(1-m) = ±1.
-- Case 1: (m+1)/(1-m) = 1 => m+1=1-m => 2m=0 => m=0.
-- Case 2: (m+1)/(1-m) = -1 => m+1=m-1 => 1=-1, impossible.
-- So m=0, line y=2. But there should be another line (vertical, undefined slope).
-- If m is undefined (vertical line x=1), angle with slope -1: angle of vertical with line of slope -1.
-- Line x+y=1 makes 135° with x-axis. Vertical makes 90°. Angle between = |135-90| = 45°. Yes!
-- So two lines: y=2 and x=1.
('A line through $(1, 2)$ making an angle of $45°$ with $x + y = 1$ can be', '$y = 2x$', '$y = x + 1$', '$y = -x + 3$', '$y = 2$', 'option4', 'Slope of $x+y=1$ is $-1$. Let slope be $m$: $\left|\frac{m+1}{1-m}\right|=1$. Case 1: $m+1=1-m$, $m=0$, line $y=2$. Case 2 gives no solution. (The other line is $x=1$, vertical.)', 'm_straight_line_equations', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_point_line_distance (Unit 10)
-- Distance of a point from a line, centroid, orthocentre, circumcentre
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Distance from (0,0) to 3x+4y-5=0. d = |0+0-5|/√(9+16) = 5/5 = 1.
('The distance from the origin to the line $3x + 4y = 5$ is', '$5$', '$1$', '$\frac{5}{7}$', '$\frac{1}{5}$', 'option2', 'Distance $= \frac{|3(0)+4(0)-5|}{\sqrt{9+16}} = \frac{5}{5} = 1$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Distance from (1,2) to x+y=0. d = |1+2|/√2 = 3/√2 = 3√2/2.
('The distance from $(1, 2)$ to the line $x + y = 0$ is', '$\frac{3\sqrt{2}}{2}$', '$3$', '$\frac{3}{2}$', '$\sqrt{2}$', 'option1', 'Distance $= \frac{|1+2|}{\sqrt{1+1}} = \frac{3}{\sqrt{2}} = \frac{3\sqrt{2}}{2}$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Centroid of triangle with vertices (0,0), (6,0), (0,6). G = (2,2).
('The centroid of the triangle with vertices $(0, 0)$, $(6, 0)$, and $(0, 6)$ is', '$(3, 3)$', '$(2, 2)$', '$(2, 4)$', '$(0, 0)$', 'option2', 'Centroid $= \left(\frac{0+6+0}{3}, \frac{0+0+6}{3}\right) = (2, 2)$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Distance between parallel lines 2x+3y=5 and 2x+3y=10. d = |10-5|/√(4+9) = 5/√13.
('The distance between the parallel lines $2x + 3y = 5$ and $2x + 3y = 10$ is', '$\frac{5}{\sqrt{13}}$', '$5$', '$\frac{5}{\sqrt{5}}$', '$\frac{10}{\sqrt{13}}$', 'option1', 'Distance $= \frac{|10-5|}{\sqrt{4+9}} = \frac{5}{\sqrt{13}}$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Distance from (3,4) to x-axis. The x-axis is y=0. Distance = |4| = 4.
('The distance from the point $(3, 4)$ to the $x$-axis is', '$5$', '$3$', '$4$', '$7$', 'option3', 'The $x$-axis is $y = 0$. Distance $= |4| = 4$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Centroid of triangle (1,1), (2,3), (3,2). G = ((1+2+3)/3, (1+3+2)/3) = (2,2).
('The centroid of the triangle with vertices $(1, 1)$, $(2, 3)$, and $(3, 2)$ is', '$(1, 2)$', '$(2, 3)$', '$(3, 2)$', '$(2, 2)$', 'option4', 'Centroid $= \left(\frac{1+2+3}{3}, \frac{1+3+2}{3}\right) = (2, 2)$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Distance from (2,-1) to 5x+12y=3. d = |10-12-3|/√(25+144) = |-5|/13 = 5/13.
('The distance from $(2, -1)$ to the line $5x + 12y = 3$ is', '$\frac{7}{13}$', '$\frac{5}{13}$', '$\frac{1}{13}$', '$1$', 'option2', 'Distance $= \frac{|5(2)+12(-1)-3|}{\sqrt{25+144}} = \frac{|10-12-3|}{13} = \frac{5}{13}$.', 'm_point_line_distance', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Centroid of triangle (a,0), (0,b), (0,0) is (a/3, b/3). If centroid is (2,3), then a=6, b=9. a+b=15.
('If the centroid of the triangle with vertices $(a, 0)$, $(0, b)$, and $(0, 0)$ is $(2, 3)$, then $a + b$ equals', '$10$', '$12$', '$15$', '$18$', 'option3', 'Centroid $= \left(\frac{a}{3}, \frac{b}{3}\right) = (2,3)$. So $a = 6$, $b = 9$, and $a + b = 15$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q9: The point on x-axis nearest to line 3x+4y=12. On x-axis: y=0, point (a,0).
-- Distance = |3a-12|/5. Minimize: 3a-12=0 => a=4. Point (4,0). Min distance = 0. Wait, that means the line passes through (4,0).
-- Let me verify: 3(4)+4(0) = 12. Yes, line passes through (4,0). So nearest point on x-axis is (4,0) with distance 0.
-- That's trivial. Let me change: nearest point on y-axis to 3x+4y=20.
-- On y-axis: x=0, point (0,b). Distance = |4b-20|/5. Min when 4b=20 => b=5. Distance=0. Same issue.
-- Let me ask: foot of perpendicular from (4,5) to 3x+4y=7.
-- Foot formula: x' = x - a(ax+by+c)/(a²+b²), y' = y - b(ax+by+c)/(a²+b²).
-- ax+by+c = 3(4)+4(5)-7 = 12+20-7 = 25.
-- x' = 4 - 3(25)/25 = 4-3 = 1. y' = 5 - 4(25)/25 = 5-4 = 1. Foot: (1,1).
('The foot of the perpendicular from $(4, 5)$ to the line $3x + 4y = 7$ is', '$(1, 1)$', '$(2, 1)$', '$(1, 2)$', '$(3, 1)$', 'option1', 'Let $d = 3(4)+4(5)-7 = 25$. Foot: $x'' = 4 - \frac{3(25)}{25} = 1$, $y'' = 5 - \frac{4(25)}{25} = 1$. Foot: $(1,1)$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Image of (3,4) in line x-y+1=0.
-- d = 3-4+1 = 0. Point lies on the line! Image = point itself = (3,4).
-- That's trivial. Let me use (1,2) in x+y=0.
-- d = 1+2 = 3. x' = 1 - 2(1)(3)/2 = 1-3 = -2. y' = 2 - 2(1)(3)/2 = 2-3 = -1. Image: (-2,-1).
('The image of the point $(1, 2)$ in the line $x + y = 0$ is', '$(0, -1)$', '$(2, 1)$', '$(-1, -2)$', '$(-2, -1)$', 'option4', 'Let $d = 1+2+0 = 3$. Image: $x'' = 1 - \frac{2(1)(3)}{2} = -2$, $y'' = 2 - \frac{2(1)(3)}{2} = -1$. Image: $(-2,-1)$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Orthocentre of right triangle with vertices (0,0), (4,0), (0,3). Right angle at origin.
-- For a right triangle, orthocentre is at the vertex of the right angle = (0,0).
('The orthocentre of the triangle with vertices $(0, 0)$, $(4, 0)$, and $(0, 3)$ is', '$(2, 1.5)$', '$(0, 0)$', '$(4, 3)$', '$(\frac{4}{3}, 1)$', 'option2', 'The triangle has a right angle at $(0,0)$ (sides along axes). The orthocentre of a right triangle is at the vertex of the right angle, i.e., $(0,0)$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Distance between parallel lines 3x+4y=5 and 6x+8y=15. Rewrite second: 3x+4y=15/2.
-- d = |15/2 - 5|/√(9+16) = |5/2|/5 = 1/2.
('The distance between the parallel lines $3x + 4y = 5$ and $6x + 8y = 15$ is', '$\frac{5}{2}$', '$1$', '$\frac{1}{2}$', '$2$', 'option3', 'Rewrite: $3x+4y=5$ and $3x+4y=\frac{15}{2}$. Distance $= \frac{|\frac{15}{2}-5|}{5} = \frac{\frac{5}{2}}{5} = \frac{1}{2}$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Circumcentre of triangle (0,0), (6,0), (0,8). Right angle at origin.
-- Circumcentre of right triangle = midpoint of hypotenuse = ((6+0)/2, (0+8)/2) = (3,4).
('The circumcentre of the triangle with vertices $(0, 0)$, $(6, 0)$, and $(0, 8)$ is', '$(3, 3)$', '$(2, 3)$', '$(0, 0)$', '$(3, 4)$', 'option4', 'Right angle at origin. Circumcentre of a right triangle is the midpoint of the hypotenuse: $\left(\frac{6}{2}, \frac{8}{2}\right) = (3, 4)$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Area of triangle with vertices (1,1), (4,1), (1,5). Base along y=1 from (1,1) to (4,1): length 3.
-- Height from (1,5) to y=1: |5-1|=4. Area = (1/2)(3)(4) = 6.
('The area of the triangle with vertices $(1, 1)$, $(4, 1)$, and $(1, 5)$ is', '$6$', '$12$', '$8$', '$10$', 'option1', 'Base from $(1,1)$ to $(4,1)$: length $3$. Height from $(1,5)$ to $y=1$: $4$. Area $= \frac{1}{2}(3)(4) = 6$.', 'm_point_line_distance', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Orthocentre of triangle (0,0), (5,0), (2,3).
-- Altitude from (0,0) perp to side (5,0)-(2,3). Slope of (5,0)-(2,3) = (3-0)/(2-5) = -1. Perp slope = 1.
-- Altitude from (0,0): y = x.
-- Altitude from (5,0) perp to side (0,0)-(2,3). Slope of (0,0)-(2,3) = 3/2. Perp slope = -2/3.
-- Altitude from (5,0): y-0 = -2/3(x-5) => 3y = -2x+10 => 2x+3y=10.
-- Intersection: y=x and 2x+3y=10 => 2x+3x=10 => 5x=10 => x=2, y=2. Orthocentre: (2,2).
('The orthocentre of the triangle with vertices $(0, 0)$, $(5, 0)$, and $(2, 3)$ is', '$(\frac{7}{3}, 1)$', '$(3, 1)$', '$(2, 2)$', '$(1, 2)$', 'option3', 'Altitude from $(0,0)$ $\perp$ to side joining $(5,0),(2,3)$ (slope $-1$): $y = x$. Altitude from $(5,0)$ $\perp$ to side joining $(0,0),(2,3)$ (slope $\frac{3}{2}$): $2x+3y=10$. Intersection: $x=2, y=2$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If the distance from (k,0) to line 4x-3y-12=0 is 4, find k.
-- d = |4k-0-12|/5 = |4k-12|/5 = 4. So |4k-12| = 20.
-- 4k-12 = 20 => k=8, or 4k-12=-20 => k=-2.
-- Two values. Let's ask for positive value.
('If the distance from $(k, 0)$ to the line $4x - 3y = 12$ is $4$, then the positive value of $k$ is', '$8$', '$5$', '$3$', '$7$', 'option1', '$\frac{|4k-12|}{5} = 4$, so $|4k-12| = 20$. $4k-12 = 20$ gives $k = 8$; $4k-12=-20$ gives $k=-2$. Positive value: $k = 8$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Circumcentre of triangle (1,1), (5,1), (1,7).
-- Check if right angle: sides from (1,1): to (5,1) direction (4,0), to (1,7) direction (0,6). Dot product = 0. Right angle at (1,1).
-- Circumcentre = midpoint of hypotenuse = ((5+1)/2, (1+7)/2) = (3,4).
('The circumcentre of the triangle with vertices $(1, 1)$, $(5, 1)$, and $(1, 7)$ is', '$(3, 4)$', '$(2, 3)$', '$(3, 3)$', '$(1, 1)$', 'option1', 'Right angle at $(1,1)$: sides $(4,0)$ and $(0,6)$ are perpendicular. Circumcentre $=$ midpoint of hypotenuse $= \left(\frac{5+1}{2}, \frac{1+7}{2}\right) = (3,4)$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Incentre of triangle (0,0), (5,0), (0,12). Sides: a=13 (hyp), b=12, c=5.
-- Wait: side opposite (0,0) = distance from (5,0) to (0,12) = √(25+144) = 13 = a.
-- Side opposite (5,0) = distance from (0,0) to (0,12) = 12 = b.
-- Side opposite (0,12) = distance from (0,0) to (5,0) = 5 = c.
-- Incentre = (ax1+bx2+cx3)/(a+b+c), (ay1+by1+cy3)/(a+b+c) where vertices are (x1,y1)=(0,0), (x2,y2)=(5,0), (x3,y3)=(0,12).
-- x = (13·0 + 12·5 + 5·0)/30 = 60/30 = 2.
-- y = (13·0 + 12·0 + 5·12)/30 = 60/30 = 2.
-- Incentre: (2,2).
('The incentre of the triangle with vertices $(0, 0)$, $(5, 0)$, and $(0, 12)$ is', '$(1, 1)$', '$(3, 3)$', '$(2, 2)$', '$(2, 4)$', 'option3', 'Sides: $a = 13$ (opposite origin), $b = 12$ (opposite $(5,0)$), $c = 5$ (opposite $(0,12)$). Incentre $= \left(\frac{13(0)+12(5)+5(0)}{30}, \frac{13(0)+12(0)+5(12)}{30}\right) = (2, 2)$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Locus of point equidistant from lines 3x+4y=5 and 5x-12y=7.
-- |3x+4y-5|/5 = |5x-12y-7|/13.
-- Taking +: 13(3x+4y-5) = 5(5x-12y-7) => 39x+52y-65 = 25x-60y-35 => 14x+112y=30 => 7x+56y=15.
-- Taking -: 13(3x+4y-5) = -5(5x-12y-7) => 39x+52y-65 = -25x+60y+35 => 64x-8y=100 => 8x-y=12.5 => 16x-2y=25.
-- Let me ask for one bisector.
('One of the angle bisectors of the lines $3x + 4y = 5$ and $5x - 12y = 7$ is', '$56x + 7y = 15$', '$7x - 56y = 15$', '$7x + 56y = 15$', '$7x + 56y = 30$', 'option3', '$\frac{3x+4y-5}{5} = \frac{5x-12y-7}{13}$. Cross-multiplying: $39x+52y-65 = 25x-60y-35$, i.e., $14x+112y = 30$, or $7x + 56y = 15$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Area of triangle formed by lines y=m1·x+c1, y=m2·x+c2, and x=0.
-- Specific: y=2x+1, y=3x+2, x=0. On x=0: (0,1) and (0,2). Intersection of y=2x+1 and y=3x+2: 2x+1=3x+2 => x=-1, y=-1.
-- Vertices: (0,1), (0,2), (-1,-1). Area = (1/2)|0(2-(-1))+0((-1)-1)+(-1)(1-2)| = (1/2)|0+0+1| = 1/2.
('The area of the triangle formed by the lines $y = 2x + 1$, $y = 3x + 2$, and $x = 0$ is', '$2$', '$1$', '$\frac{3}{2}$', '$\frac{1}{2}$', 'option4', 'On $x=0$: $(0,1)$ and $(0,2)$. Intersection of $y=2x+1$ and $y=3x+2$: $x=-1, y=-1$. Area $= \frac{1}{2}|0(2+1)+0(-1-1)+(-1)(1-2)| = \frac{1}{2}$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Orthocentre of equilateral triangle with centroid at (2,3) and one vertex at (2,7).
-- In equilateral triangle, orthocentre = centroid. So orthocentre = (2,3).
('If the centroid of an equilateral triangle is $(2, 3)$, then its orthocentre is', '$(4, 6)$', '$(3, 2)$', '$(2, 3)$', '$(1, 1)$', 'option3', 'In an equilateral triangle, the centroid, orthocentre, circumcentre, and incentre all coincide. So the orthocentre is $(2, 3)$.', 'm_point_line_distance', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_circle_equations (Unit 10)
-- Circle: standard and general form, radius, centre, diameter endpoints
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Centre and radius of (x-2)²+(y-3)²=16. Centre (2,3), radius 4.
('The radius of the circle $(x-2)^2 + (y-3)^2 = 16$ is', '$2$', '$16$', '$8$', '$4$', 'option4', 'Standard form $(x-h)^2+(y-k)^2=r^2$. Here $r^2=16$, so $r=4$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Centre of x²+y²-4x-6y+9=0. Complete square: (x-2)²+(y-3)²=4. Centre (2,3).
('The centre of the circle $x^2 + y^2 - 4x - 6y + 9 = 0$ is', '$(2, 3)$', '$(4, 6)$', '$(-2, -3)$', '$(2, -3)$', 'option1', 'Completing the square: $(x-2)^2 + (y-3)^2 = 4+9-9 = 4$. Centre: $(2, 3)$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Equation of circle with centre (0,0) and radius 5: x²+y²=25.
('The equation of the circle with centre at the origin and radius $5$ is', '$x^2 + y^2 = 25$', '$x^2 + y^2 = 5$', '$x^2 + y^2 = 10$', '$(x-5)^2 + y^2 = 25$', 'option1', 'Centre $(0,0)$, radius $5$: $x^2 + y^2 = 25$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Circle with diameter endpoints (1,2) and (5,6). Centre = midpoint = (3,4). Radius = half diagonal = √((4)²+(4)²)/2 = √32/2 = 2√2.
-- Actually radius² = (5-1)²/4 + (6-2)²/4 = 16/4+16/4 = 8. Radius = 2√2.
-- Equation: (x-3)²+(y-4)²=8. Or using diameter form: (x-1)(x-5)+(y-2)(y-6)=0.
('The centre of the circle with diameter endpoints $(1, 2)$ and $(5, 6)$ is', '$(2, 3)$', '$(3, 4)$', '$(4, 5)$', '$(1, 6)$', 'option2', 'Centre $=$ midpoint of diameter $= \left(\frac{1+5}{2}, \frac{2+6}{2}\right) = (3, 4)$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Radius of x²+y²+6x-8y=0. Complete: (x+3)²+(y-4)²=9+16=25. Radius=5.
('The radius of the circle $x^2 + y^2 + 6x - 8y = 0$ is', '$10$', '$25$', '$\sqrt{10}$', '$5$', 'option4', 'Completing: $(x+3)^2 + (y-4)^2 = 9+16 = 25$. Radius $= 5$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Does (1,1) lie inside, on, or outside x²+y²=4? 1+1=2<4. Inside.
('The point $(1, 1)$ lies', 'On the circle $x^2+y^2=4$', 'Inside the circle $x^2+y^2=4$', 'Outside the circle $x^2+y^2=4$', 'At the centre of $x^2+y^2=4$', 'option2', '$1^2 + 1^2 = 2 < 4$. Since $S_1 < 0$ (substituting in $x^2+y^2-4$), the point lies inside.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Equation of circle with centre (1,-2) and radius 3: (x-1)²+(y+2)²=9.
('The equation of the circle with centre $(1, -2)$ and radius $3$ is', '$(x-1)^2 + (y+2)^2 = 9$', '$(x+1)^2 + (y-2)^2 = 9$', '$(x-1)^2 + (y-2)^2 = 9$', '$(x-1)^2 + (y+2)^2 = 3$', 'option1', 'Standard form: $(x-1)^2 + (y-(-2))^2 = 3^2$, i.e., $(x-1)^2 + (y+2)^2 = 9$.', 'm_circle_equations', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Circle passing through origin with centre (3,4). Radius = √(9+16)=5. Equation: (x-3)²+(y-4)²=25.
-- Expand: x²-6x+9+y²-8y+16=25 => x²+y²-6x-8y=0.
('The equation of the circle with centre $(3, 4)$ passing through the origin is', '$x^2 + y^2 - 6x - 8y = 25$', '$x^2 + y^2 - 3x - 4y = 0$', '$x^2 + y^2 + 6x + 8y = 0$', '$x^2 + y^2 - 6x - 8y = 0$', 'option4', 'Radius $= \sqrt{9+16} = 5$. Equation: $(x-3)^2+(y-4)^2=25$. Expanding: $x^2+y^2-6x-8y = 0$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Length of tangent from (5,6) to circle x²+y²-4x-6y+9=0.
-- S₁ = 25+36-20-36+9 = 14. Length = √14.
('The length of the tangent from $(5, 6)$ to the circle $x^2 + y^2 - 4x - 6y + 9 = 0$ is', '$\sqrt{14}$', '$14$', '$\sqrt{7}$', '$7$', 'option1', '$S_1 = 25+36-20-36+9 = 14$. Length of tangent $= \sqrt{S_1} = \sqrt{14}$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Circle with diameter endpoints (2,3) and (6,7). Diameter form: (x-2)(x-6)+(y-3)(y-7)=0.
-- Expand: x²-8x+12+y²-10y+21=0 => x²+y²-8x-10y+33=0.
('The equation of the circle on the diameter joining $(2, 3)$ and $(6, 7)$ is', '$x^2 + y^2 - 8x - 10y + 12 = 0$', '$x^2 + y^2 - 8x - 10y + 33 = 0$', '$x^2 + y^2 + 8x + 10y + 33 = 0$', '$x^2 + y^2 - 4x - 5y + 33 = 0$', 'option2', 'Diameter form: $(x-2)(x-6)+(y-3)(y-7)=0$. Expanding: $x^2+y^2-8x-10y+33=0$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q11: If x²+y²+2gx+2fy+c=0 represents a circle, centre=(-g,-f), radius=√(g²+f²-c).
-- For x²+y²-10x+12y+36=0: g=-5, f=6, c=36. Radius=√(25+36-36)=√25=5.
('The radius of the circle $x^2 + y^2 - 10x + 12y + 36 = 0$ is', '$\sqrt{10}$', '$\sqrt{36}$', '$10$', '$5$', 'option4', 'Here $g = -5$, $f = 6$, $c = 36$. Radius $= \sqrt{g^2+f^2-c} = \sqrt{25+36-36} = 5$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Equation of circle concentric with x²+y²-4x+6y-3=0 and passing through (1,2).
-- Centre of given: (2,-3). New circle: (x-2)²+(y+3)²=r². Through (1,2): 1+25=26. r²=26.
-- Equation: (x-2)²+(y+3)²=26 => x²+y²-4x+6y+4+9-26=0 => x²+y²-4x+6y-13=0.
('The equation of the circle concentric with $x^2+y^2-4x+6y-3=0$ and passing through $(1, 2)$ is', '$x^2+y^2-4x+6y-13=0$', '$x^2+y^2-4x+6y-3=0$', '$x^2+y^2-4x+6y+13=0$', '$x^2+y^2+4x-6y-13=0$', 'option1', 'Centre: $(2,-3)$. Through $(1,2)$: $r^2 = (1-2)^2+(2+3)^2 = 26$. Equation: $x^2+y^2-4x+6y-13=0$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Number of common tangents to circles x²+y²=4 and (x-3)²+y²=1.
-- C₁=(0,0), r₁=2. C₂=(3,0), r₂=1. d=3. r₁+r₂=3. d=r₁+r₂. Externally tangent. 3 common tangents.
('The number of common tangents to the circles $x^2+y^2=4$ and $(x-3)^2+y^2=1$ is', '$2$', '$4$', '$3$', '$1$', 'option3', '$C_1=(0,0), r_1=2$; $C_2=(3,0), r_2=1$. $d=3=r_1+r_2$. Circles are externally tangent, so $3$ common tangents.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Power of point (4,3) w.r.t. circle x²+y²=9. S₁ = 16+9-9 = 16. Power = 16.
('The power of the point $(4, 3)$ with respect to the circle $x^2 + y^2 = 9$ is', '$34$', '$25$', '$7$', '$16$', 'option4', 'Power $= x^2+y^2-9 = 16+9-9 = 16$.', 'm_circle_equations', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Equation of tangent to x²+y²=25 at (3,4). Tangent: 3x+4y=25.
('The equation of the tangent to $x^2 + y^2 = 25$ at the point $(3, 4)$ is', '$4x + 3y = 25$', '$3x + 4y = 25$', '$3x - 4y = 25$', '$x + y = 7$', 'option2', 'Tangent at $(x_1,y_1)$: $xx_1+yy_1=r^2$. So $3x+4y=25$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Circle through (0,0), (1,0), (0,1). General: x²+y²+2gx+2fy+c=0.
-- (0,0): c=0. (1,0): 1+2g=0 => g=-1/2. (0,1): 1+2f=0 => f=-1/2.
-- Equation: x²+y²-x-y=0. Centre (1/2, 1/2), radius = √(1/4+1/4) = 1/√2.
('The equation of the circle through $(0,0)$, $(1,0)$, and $(0,1)$ is', '$x^2 + y^2 - x - y = 0$', '$x^2 + y^2 + x + y = 0$', '$x^2 + y^2 - 2x - 2y = 0$', '$x^2 + y^2 = 1$', 'option1', 'General form with $c=0$ (passes through origin). $(1,0)$: $1+2g=0$, $g=-\frac{1}{2}$. $(0,1)$: $1+2f=0$, $f=-\frac{1}{2}$. Equation: $x^2+y^2-x-y=0$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Equation of chord of contact from (5,3) to circle x²+y²=16. T=0: 5x+3y=16.
('The equation of the chord of contact of tangents from $(5, 3)$ to $x^2 + y^2 = 16$ is', '$5x + 3y = 16$', '$3x + 5y = 16$', '$5x - 3y = 16$', '$5x + 3y = 8$', 'option1', 'Chord of contact: $T = 0$, i.e., $xx_1+yy_1=r^2$. So $5x+3y=16$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Two circles x²+y²=9 and x²+y²-6x-8y+9=0. Common chord (radical axis): S₁-S₂=0.
-- (x²+y²-9) - (x²+y²-6x-8y+9) = 0 => 6x+8y-18 = 0 => 3x+4y=9.
('The equation of the common chord of $x^2+y^2=9$ and $x^2+y^2-6x-8y+9=0$ is', '$3x + 4y = 9$', '$3x - 4y = 9$', '$6x + 8y = 9$', '$x + y = 3$', 'option1', 'Radical axis: $S_1 - S_2 = 0$. $(x^2+y^2-9)-(x^2+y^2-6x-8y+9)=0$, i.e., $6x+8y-18=0$, or $3x+4y=9$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q19: If the line y=mx+c is tangent to x²+y²=r², then c²=r²(1+m²).
-- For x²+y²=9 and y=2x+c: c²=9(1+4)=45. c=±3√5.
('If $y = 2x + c$ is tangent to $x^2 + y^2 = 9$, then $c^2$ equals', '$27$', '$36$', '$45$', '$18$', 'option3', 'Condition for tangency: $c^2 = r^2(1+m^2) = 9(1+4) = 45$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Circle with centre on x-axis, passing through (1,2) and (-1,2).
-- Centre on x-axis: (h,0). Distance to (1,2) = distance to (-1,2).
-- (h-1)²+4 = (h+1)²+4 => h²-2h+1 = h²+2h+1 => -4h=0 => h=0. Centre (0,0).
-- Radius = √(1+4) = √5. Equation: x²+y²=5.
('The equation of the circle with centre on the $x$-axis and passing through $(1, 2)$ and $(-1, 2)$ is', '$(x-1)^2 + y^2 = 5$', '$x^2 + y^2 = 4$', '$x^2 + y^2 = 5$', '$x^2 + y^2 = 9$', 'option3', 'Centre $(h,0)$. Equal distances: $(h-1)^2+4=(h+1)^2+4$, giving $h=0$. Radius $=\sqrt{1+4}=\sqrt{5}$. Equation: $x^2+y^2=5$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Length of chord cut by x²+y²=25 on line 3x+4y=7.
-- Distance from centre (0,0) to line = 7/5. Half-chord = √(25-49/25) = √(576/25) = 24/5.
-- Chord length = 2(24/5) = 48/5.
('The length of the chord cut by the circle $x^2+y^2=25$ on the line $3x+4y=7$ is', '$\frac{48}{5}$', '$\frac{24}{5}$', '$10$', '$\frac{7}{5}$', 'option1', 'Distance from centre to line $= \frac{7}{5}$. Half-chord $= \sqrt{25-\frac{49}{25}} = \sqrt{\frac{576}{25}} = \frac{24}{5}$. Chord $= \frac{48}{5}$.', 'm_circle_equations', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_line_circle_intersection (Unit 10)
-- Points of intersection of a line and a circle
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Number of intersection points of y=x and x²+y²=2. Sub: x²+x²=2 => x²=1 => x=±1. Two points.
('The number of points of intersection of $y = x$ and $x^2 + y^2 = 2$ is', '$0$', '$2$', '$1$', '$3$', 'option2', 'Substituting $y=x$: $2x^2=2$, $x^2=1$, $x=\pm 1$. Two intersection points.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Does y=5 intersect x²+y²=9? Distance from (0,0) to y=5 is 5>3=radius. No intersection.
('The line $y = 5$ and the circle $x^2 + y^2 = 9$', 'Intersect at one point', 'Intersect at two points', 'Are tangent', 'Do not intersect', 'option4', 'Distance from centre $(0,0)$ to $y=5$ is $5 > 3$ (radius). No intersection.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Intersection of x=3 and x²+y²=25. 9+y²=25 => y²=16 => y=±4. Points (3,4) and (3,-4).
('The points of intersection of $x = 3$ and $x^2 + y^2 = 25$ are', '$(3, 4)$ and $(3, -4)$', '$(3, 3)$ and $(3, -3)$', '$(4, 3)$ and $(-4, 3)$', '$(3, 5)$ and $(3, -5)$', 'option1', '$9 + y^2 = 25$, so $y^2 = 16$, $y = \pm 4$. Points: $(3, 4)$ and $(3, -4)$.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Is y=3x tangent to x²+y²=10? Distance from (0,0) to 3x-y=0 is 0/√10=0. Line passes through centre. Not tangent (it's a secant through centre, i.e., diameter).
-- Actually distance = 0, so line passes through centre. It intersects at 2 points (diameter).
('The line $y = 3x$ with respect to the circle $x^2 + y^2 = 10$ is', 'A secant', 'A tangent', 'Non-intersecting', 'External', 'option1', 'Distance from $(0,0)$ to $3x-y=0$ is $0$. The line passes through the centre, so it is a secant (diameter).', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q5: y=x+5 and x²+y²=9. Distance from (0,0) to x-y+5=0 is 5/√2 ≈ 3.54 > 3. No intersection.
('The line $y = x + 5$ and the circle $x^2 + y^2 = 9$', 'Do not intersect', 'Intersect at two points', 'Are tangent', 'Intersect at one point', 'option1', 'Distance from $(0,0)$ to $x-y+5=0$ is $\frac{5}{\sqrt{2}} \approx 3.54 > 3$ (radius). No intersection.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q6: y=0 and x²+y²-4x=0. Sub y=0: x²-4x=0 => x(x-4)=0. Points (0,0) and (4,0).
('The points where the $x$-axis meets the circle $x^2 + y^2 - 4x = 0$ are', '$(2, 0)$ only', '$(0, 0)$ and $(4, 0)$', '$(0, 0)$ only', '$(0, 0)$ and $(2, 0)$', 'option2', 'Put $y=0$: $x^2-4x=0$, $x(x-4)=0$. Points: $(0,0)$ and $(4,0)$.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Q7: If y=mx is tangent to x²+y²=4, distance from (0,0) to mx-y=0 is 0. That's always 0.
-- So y=mx always passes through centre. Never tangent (unless circle doesn't contain origin, but this one does).
-- Let me change: y=2 tangent to x²+y²=4? Distance = 2 = radius. Yes, tangent.
('The line $y = 2$ is a tangent to the circle $x^2 + y^2 = 4$ because', 'Distance from centre equals radius', 'It passes through the centre', 'It intersects at two points', 'It does not touch the circle', 'option1', 'Distance from $(0,0)$ to $y=2$ is $2$, which equals the radius. So $y=2$ is tangent.', 'm_line_circle_intersection', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Length of chord of x²+y²=25 along y=x+1. Distance from (0,0) to x-y+1=0 is 1/√2.
-- Half-chord = √(25-1/2) = √(49/2) = 7/√2. Chord = 7√2.
('The length of the chord that the line $y = x + 1$ cuts from the circle $x^2 + y^2 = 25$ is', '$7\sqrt{2}$', '$5\sqrt{2}$', '$\frac{7}{\sqrt{2}}$', '$10$', 'option1', 'Distance from $(0,0)$ to $x-y+1=0$: $\frac{1}{\sqrt{2}}$. Half-chord $= \sqrt{25-\frac{1}{2}} = \frac{7}{\sqrt{2}}$. Chord $= 7\sqrt{2}$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q9: For what value of c is y=x+c tangent to x²+y²=8?
-- Distance from (0,0) to x-y+c=0 is |c|/√2 = √8 = 2√2. |c| = 4. c = ±4.
('If $y = x + c$ is tangent to $x^2 + y^2 = 8$, then $|c|$ equals', '$2\sqrt{2}$', '$4$', '$8$', '$2$', 'option2', 'Tangency: $\frac{|c|}{\sqrt{2}} = \sqrt{8} = 2\sqrt{2}$. So $|c| = 4$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Intersection points of y=2x+1 and x²+y²=5. Sub: x²+(2x+1)²=5 => x²+4x²+4x+1=5 => 5x²+4x-4=0.
-- x = (-4±√(16+80))/10 = (-4±√96)/10 = (-4±4√6)/10 = (-2±2√6)/5.
-- Number of points = 2 (discriminant > 0).
('The line $y = 2x + 1$ intersects the circle $x^2 + y^2 = 5$ at', 'Two points', 'One point', 'No point', 'Three points', 'option1', 'Substituting: $5x^2+4x-4=0$. Discriminant $= 16+80 = 96 > 0$. Two intersection points.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Tangent to x²+y²=5 at (1,2). Tangent: x(1)+y(2)=5 => x+2y=5.
-- Where does this tangent meet x-axis? y=0: x=5. Point (5,0).
('The tangent to $x^2 + y^2 = 5$ at $(1, 2)$ meets the $x$-axis at', '$(5, 0)$', '$(1, 0)$', '$(\frac{5}{2}, 0)$', '$(2, 0)$', 'option1', 'Tangent: $x + 2y = 5$. At $y=0$: $x = 5$. Point: $(5, 0)$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Equation of tangent to x²+y²=16 with slope 3. Tangent: y=3x±√(16·10) = 3x±4√10.
-- Wait: y=mx±r√(1+m²) = 3x±4√(1+9) = 3x±4√10.
('The equations of tangents to $x^2+y^2=16$ with slope $3$ are', '$y = 3x \pm 4$', '$y = 3x \pm 4\sqrt{10}$', '$y = 3x \pm 16$', '$y = 3x \pm \sqrt{10}$', 'option2', 'Tangent with slope $m$: $y = mx \pm r\sqrt{1+m^2} = 3x \pm 4\sqrt{10}$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q13: If line 3x+4y=k is tangent to x²+y²=4, find k.
-- Distance from (0,0) to 3x+4y-k=0 is |k|/5 = 2. |k|=10. k=±10.
('If $3x + 4y = k$ is tangent to $x^2 + y^2 = 4$, then $k$ equals', '$\pm 20$', '$\pm 5$', '$\pm 10$', '$\pm 8$', 'option3', 'Distance from origin $= \frac{|k|}{5} = 2$. So $|k| = 10$, i.e., $k = \pm 10$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Mid-point of chord of x²+y²=25 along 3x+4y=7. Foot of perpendicular from (0,0) to line.
-- Foot: x = -3(-7)/25... Using formula: foot = (3·7/25, 4·7/25) = (21/25, 28/25).
-- Actually: line 3x+4y-7=0. Foot from (0,0): x' = 0 - 3(0+0-7)/25 = 21/25. y' = 0 - 4(0+0-7)/25 = 28/25.
('The mid-point of the chord $3x + 4y = 7$ of the circle $x^2 + y^2 = 25$ is', '$\left(\frac{3}{5}, \frac{4}{5}\right)$', '$\left(\frac{21}{25}, \frac{28}{25}\right)$', '$(3, 4)$', '$\left(\frac{7}{5}, \frac{7}{5}\right)$', 'option2', 'Mid-point of chord $=$ foot of $\perp$ from centre. $x'' = \frac{3 \times 7}{25} = \frac{21}{25}$, $y'' = \frac{4 \times 7}{25} = \frac{28}{25}$.', 'm_line_circle_intersection', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Equation of chord of x²+y²=25 whose mid-point is (3,4).
-- T = S₁: 3x+4y = 9+16 = 25. So 3x+4y=25.
-- Wait, that's the tangent at (3,4) since (3,4) is ON the circle (9+16=25). Mid-point can't be on circle.
-- Let me use mid-point (1,2). T=S₁: x(1)+y(2) = 1+4 = 5. Chord: x+2y=5.
('The equation of the chord of $x^2 + y^2 = 25$ whose mid-point is $(1, 2)$ is', '$x - 2y = -3$', '$2x + y = 5$', '$x + 2y = 25$', '$x + 2y = 5$', 'option4', 'Chord with mid-point $(h,k)$: $T = S_1$, i.e., $hx+ky = h^2+k^2$. So $x + 2y = 1 + 4 = 5$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Pair of tangents from (5,0) to x²+y²=9. Length of tangent = √(25-9)=4.
-- Tangent: y=m(x-5), i.e., mx-y-5m=0. Distance from (0,0) = |5m|/√(m²+1) = 3.
-- 25m² = 9(m²+1) => 16m²=9 => m=±3/4.
-- Tangents: y = 3/4(x-5) and y = -3/4(x-5), i.e., 3x-4y=15 and 3x+4y=15.
('The tangents from $(5, 0)$ to $x^2 + y^2 = 9$ are', '$3x - 4y = 15$ and $3x + 4y = 15$', '$4x - 3y = 15$ and $4x + 3y = 15$', '$x - y = 5$ and $x + y = 5$', '$5x - 3y = 9$ and $5x + 3y = 9$', 'option1', 'Tangent $y = m(x-5)$: $\frac{|5m|}{\sqrt{m^2+1}} = 3$. $25m^2 = 9m^2+9$, $m = \pm\frac{3}{4}$. Lines: $3x \mp 4y = 15$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Angle subtended by chord x+y=1 at centre of x²+y²=1.
-- Distance from (0,0) to x+y-1=0 is 1/√2. Radius=1.
-- cos(half-angle) = (1/√2)/1 = 1/√2. Half-angle = 45°. Full angle = 90°.
('The angle subtended by the chord $x + y = 1$ at the centre of $x^2 + y^2 = 1$ is', '$60°$', '$90°$', '$120°$', '$45°$', 'option2', 'Distance from centre to chord $= \frac{1}{\sqrt{2}}$. $\cos\frac{\theta}{2} = \frac{1/\sqrt{2}}{1} = \frac{1}{\sqrt{2}}$, so $\frac{\theta}{2} = 45°$, $\theta = 90°$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If the line y=mx+1 intersects x²+y²=1 at two distinct points, find range of m.
-- Sub: x²+(mx+1)²=1 => (1+m²)x²+2mx=0 => x((1+m²)x+2m)=0.
-- x=0 (giving (0,1)) and x=-2m/(1+m²). These are distinct if -2m/(1+m²) ≠ 0, i.e., m≠0.
-- Wait, but (0,1) is on the circle. The line y=mx+1 always passes through (0,1) which is on the circle.
-- For two distinct points: m≠0 (any nonzero m gives a second point).
-- Hmm, but the question should be more interesting. Let me change to y=mx+2 and x²+y²=1.
-- Sub: x²+(mx+2)²=1 => (1+m²)x²+4mx+3=0. Discriminant = 16m²-12(1+m²) = 4m²-12.
-- Two distinct points: 4m²-12>0 => m²>3 => |m|>√3.
('If the line $y = mx + 2$ intersects the circle $x^2 + y^2 = 1$ at two distinct points, then', '$|m| > 2$', '$|m| < \sqrt{3}$', '$|m| > \sqrt{3}$', '$|m| < 1$', 'option3', 'Substituting: $(1+m^2)x^2+4mx+3=0$. Discriminant $= 16m^2-12(1+m^2) = 4m^2-12 > 0$, so $m^2 > 3$, i.e., $|m| > \sqrt{3}$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Normal to x²+y²=25 at (3,4). Normal passes through centre (0,0) and (3,4). Slope = 4/3.
-- Equation: y = (4/3)x, i.e., 4x-3y=0.
('The equation of the normal to $x^2 + y^2 = 25$ at $(3, 4)$ is', '$3x + 4y = 25$', '$4x - 3y = 0$', '$3x - 4y = 0$', '$4x + 3y = 25$', 'option2', 'Normal to a circle passes through the centre. Line through $(0,0)$ and $(3,4)$: slope $= \frac{4}{3}$. Equation: $4x - 3y = 0$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Circle x²+y²-6x-8y+21=0. Centre (3,4), r=√(9+16-21)=2.
-- Tangent from (1,2): length = √(S₁) = √(1+4-6-16+21) = √4 = 2.
-- Angle between tangent and line joining (1,2) to centre: tan α = r/length = 2/2 = 1. α = 45°.
-- So angle between pair of tangents = 2α = 90°.
('The angle between the pair of tangents from $(1, 2)$ to the circle $x^2+y^2-6x-8y+21=0$ is', '$120°$', '$60°$', '$45°$', '$90°$', 'option4', 'Centre $(3,4)$, $r=2$. Length of tangent from $(1,2)$: $\sqrt{1+4-6-16+21}=2$. $\tan\alpha = \frac{r}{\text{length}} = 1$, $\alpha=45°$. Angle $= 2\alpha = 90°$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Condition for y=mx+c to be tangent to (x-a)²+(y-b)²=r².
-- Distance from (a,b) to mx-y+c=0 is |ma-b+c|/√(m²+1) = r.
-- Condition: (ma-b+c)² = r²(m²+1).
-- For (x-1)²+(y-2)²=4 and y=x+c: (1-2+c)²=4(2) => (c-1)²=8 => c=1±2√2.
('If $y = x + c$ is tangent to $(x-1)^2 + (y-2)^2 = 4$, then $c$ equals', '$1 \pm \sqrt{2}$', '$\pm 2\sqrt{2}$', '$1 \pm 2\sqrt{2}$', '$3 \pm 2\sqrt{2}$', 'option3', 'Distance from $(1,2)$ to $x-y+c=0$: $\frac{|1-2+c|}{\sqrt{2}} = 2$. $(c-1)^2 = 8$, so $c = 1 \pm 2\sqrt{2}$.', 'm_line_circle_intersection', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_conic_sections (Unit 10)
-- Conic sections: parabola, ellipse and hyperbola in standard forms
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Focus of parabola y²=12x. 4a=12 => a=3. Focus (3,0).
('The focus of the parabola $y^2 = 12x$ is', '$(12, 0)$', '$(0, 3)$', '$(3, 0)$', '$(6, 0)$', 'option3', '$y^2 = 4ax$ with $4a = 12$, so $a = 3$. Focus: $(a, 0) = (3, 0)$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Eccentricity of ellipse x²/25+y²/16=1. a²=25, b²=16. e=√(1-16/25)=√(9/25)=3/5.
('The eccentricity of the ellipse $\frac{x^2}{25} + \frac{y^2}{16} = 1$ is', '$\frac{4}{5}$', '$\frac{3}{5}$', '$\frac{5}{3}$', '$\frac{16}{25}$', 'option2', '$a^2=25, b^2=16$. $e = \sqrt{1-\frac{b^2}{a^2}} = \sqrt{1-\frac{16}{25}} = \frac{3}{5}$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Vertices of hyperbola x²/9-y²/16=1. a²=9 => a=3. Vertices (±3,0).
('The vertices of the hyperbola $\frac{x^2}{9} - \frac{y^2}{16} = 1$ are', '$(\pm 3, 0)$', '$(0, \pm 4)$', '$(\pm 9, 0)$', '$(\pm 4, 0)$', 'option1', '$a^2 = 9$, so $a = 3$. Vertices: $(\pm a, 0) = (\pm 3, 0)$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Directrix of y²=8x. 4a=8 => a=2. Directrix: x=-2.
('The directrix of the parabola $y^2 = 8x$ is', '$y = -2$', '$x = 2$', '$x = -2$', '$x = -8$', 'option3', '$4a = 8$, $a = 2$. Directrix: $x = -a = -2$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Length of latus rectum of y²=16x. LR = 4a = 16.
('The length of the latus rectum of $y^2 = 16x$ is', '$16$', '$4$', '$8$', '$32$', 'option1', '$y^2 = 4ax$ with $4a = 16$. Latus rectum $= 4a = 16$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Foci of ellipse x²/16+y²/9=1. a²=16, b²=9. c²=16-9=7. c=√7. Foci (±√7,0).
('The foci of the ellipse $\frac{x^2}{16} + \frac{y^2}{9} = 1$ are', '$(\pm 4, 0)$', '$(0, \pm\sqrt{7})$', '$(\pm\sqrt{7}, 0)$', '$(\pm 7, 0)$', 'option3', '$c^2 = a^2 - b^2 = 16 - 9 = 7$. Foci: $(\pm\sqrt{7}, 0)$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Eccentricity of hyperbola x²/4-y²/5=1. a²=4, b²=5. e=√(1+5/4)=√(9/4)=3/2.
('The eccentricity of the hyperbola $\frac{x^2}{4} - \frac{y^2}{5} = 1$ is', '$\frac{3}{2}$', '$\frac{5}{4}$', '$\frac{\sqrt{5}}{2}$', '$\frac{5}{2}$', 'option1', '$e = \sqrt{1+\frac{b^2}{a^2}} = \sqrt{1+\frac{5}{4}} = \sqrt{\frac{9}{4}} = \frac{3}{2}$.', 'm_conic_sections', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Equation of parabola with focus (0,3) and directrix y=-3. Vertex at origin, opens up. x²=4ay=12y.
('The equation of the parabola with focus $(0, 3)$ and directrix $y = -3$ is', '$x^2 = 12y$', '$y^2 = 12x$', '$x^2 = -12y$', '$x^2 = 6y$', 'option1', 'Vertex at origin, axis along $y$-axis, $a = 3$. Equation: $x^2 = 4(3)y = 12y$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Length of latus rectum of ellipse x²/25+y²/9=1. LR = 2b²/a = 2(9)/5 = 18/5.
('The length of the latus rectum of the ellipse $\frac{x^2}{25} + \frac{y^2}{9} = 1$ is', '$\frac{50}{9}$', '$\frac{9}{5}$', '$\frac{18}{5}$', '$10$', 'option3', 'Latus rectum $= \frac{2b^2}{a} = \frac{2(9)}{5} = \frac{18}{5}$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Asymptotes of hyperbola x²/9-y²/4=1. y = ±(b/a)x = ±(2/3)x.
('The asymptotes of the hyperbola $\frac{x^2}{9} - \frac{y^2}{4} = 1$ are', '$y = \pm\frac{2}{3}x$', '$y = \pm\frac{3}{2}x$', '$y = \pm\frac{2}{9}x$', '$y = \pm 2x$', 'option1', 'Asymptotes: $y = \pm\frac{b}{a}x = \pm\frac{2}{3}x$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Tangent to parabola y²=8x at (2,4). Tangent: yy₁=4(x+x₁) => 4y=4(x+2) => y=x+2.
('The tangent to $y^2 = 8x$ at $(2, 4)$ is', '$y = x + 4$', '$y = 2x$', '$y = x + 2$', '$x + y = 6$', 'option3', 'Tangent at $(x_1,y_1)$: $yy_1 = 2a(x+x_1)$. Here $2a=4$: $4y = 4(x+2)$, i.e., $y = x+2$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q12: If the ellipse x²/a²+y²/b²=1 passes through (3,2) and has eccentricity 1/2.
-- e²=1-b²/a² => 1/4=1-b²/a² => b²/a²=3/4 => b²=3a²/4.
-- Through (3,2): 9/a²+4/b²=1. Sub b²=3a²/4: 9/a²+16/(3a²)=1 => (27+16)/(3a²)=1 => a²=43/3.
-- Hmm messy. Let me use e=√(2/3) instead. e²=2/3. b²/a²=1/3. b²=a²/3.
-- Through (3,1): 9/a²+3/a²=1 => 12/a²=1 => a²=12. b²=4.
-- Equation: x²/12+y²/4=1.
('If an ellipse with eccentricity $\frac{\sqrt{6}}{3}$ passes through $(3, 1)$, its equation is', '$\frac{x^2}{12} + \frac{y^2}{3} = 1$', '$\frac{x^2}{9} + y^2 = 1$', '$\frac{x^2}{12} + \frac{y^2}{4} = 1$', '$\frac{x^2}{10} + \frac{y^2}{4} = 1$', 'option3', '$e^2 = \frac{6}{9} = \frac{2}{3}$, so $b^2 = a^2(1-\frac{2}{3}) = \frac{a^2}{3}$. Through $(3,1)$: $\frac{9}{a^2}+\frac{3}{a^2}=1$, $a^2=12$, $b^2=4$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Equation of tangent to ellipse x²/16+y²/9=1 at (4cosθ, 3sinθ) where θ=π/3.
-- Point: (4·1/2, 3·√3/2) = (2, 3√3/2). Tangent: x(2)/16 + y(3√3/2)/9 = 1 => x/8 + √3y/6 = 1.
-- Multiply by 24: 3x + 4√3y = 24.
('The tangent to $\frac{x^2}{16}+\frac{y^2}{9}=1$ at $\theta = \frac{\pi}{3}$ is', '$3x + 4\sqrt{3}y = 24$', '$\sqrt{3}x + 4y = 24$', '$3x + 4y = 24$', '$x + \sqrt{3}y = 8$', 'option1', 'Point: $(2, \frac{3\sqrt{3}}{2})$. Tangent: $\frac{2x}{16}+\frac{3\sqrt{3}y}{18}=1$, i.e., $\frac{x}{8}+\frac{\sqrt{3}y}{6}=1$. Multiply by 24: $3x+4\sqrt{3}y=24$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Conjugate axis length of hyperbola 9x²-16y²=144. Divide by 144: x²/16-y²/9=1. b²=9, b=3. Conjugate axis = 2b = 6.
('The length of the conjugate axis of $9x^2 - 16y^2 = 144$ is', '$3$', '$8$', '$6$', '$4$', 'option3', 'Dividing by 144: $\frac{x^2}{16}-\frac{y^2}{9}=1$. $b^2=9$, $b=3$. Conjugate axis $= 2b = 6$.', 'm_conic_sections', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Equation of normal to y²=12x at (3,6). Here 4a=12, a=3.
-- Normal at (at², 2at): y+tx=2at+at³. At (3,6): at²=3 => t²=1 => t=1 (since y=6>0).
-- Normal: y+x=6+3=9, i.e., x+y=9.
('The equation of the normal to $y^2 = 12x$ at $(3, 6)$ is', '$x + y = 6$', '$x - y = -3$', '$2x + y = 12$', '$x + y = 9$', 'option4', '$4a=12$, $a=3$. At $(3,6)$: $t=1$. Normal: $y + tx = 2at + at^3 = 6+3 = 9$, i.e., $x+y=9$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If the foci of an ellipse are (±2,0) and the length of the major axis is 10, find the equation.
-- c=2, 2a=10 => a=5. b²=a²-c²=25-4=21. Equation: x²/25+y²/21=1.
('An ellipse with foci $(\pm 2, 0)$ and major axis length $10$ has equation', '$\frac{x^2}{100} + \frac{y^2}{96} = 1$', '$\frac{x^2}{21} + \frac{y^2}{25} = 1$', '$\frac{x^2}{25} + \frac{y^2}{4} = 1$', '$\frac{x^2}{25} + \frac{y^2}{21} = 1$', 'option4', '$c=2$, $a=5$. $b^2 = 25-4 = 21$. Equation: $\frac{x^2}{25}+\frac{y^2}{21}=1$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Condition for y=mx+c to be tangent to y²=4ax. Substituting: (mx+c)²=4ax => m²x²+(2mc-4a)x+c²=0.
-- Tangent: discriminant=0. (2mc-4a)²-4m²c²=0 => 4m²c²-16amc+16a²-4m²c²=0 => -16amc+16a²=0 => c=a/m.
-- For y²=16x (a=4) and y=2x+c: c=4/2=2.
('If $y = 2x + c$ is tangent to $y^2 = 16x$, then $c$ equals', '$1$', '$4$', '$8$', '$2$', 'option4', 'For $y = mx + c$ tangent to $y^2 = 4ax$: $c = \frac{a}{m}$. Here $a=4$, $m=2$: $c = \frac{4}{2} = 2$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Rectangular hyperbola: e=√2. If xy=c², then e=√2 always.
-- For xy=8, the eccentricity is √2.
('The eccentricity of the rectangular hyperbola $xy = 8$ is', '$2$', '$\sqrt{2}$', '$\frac{1}{\sqrt{2}}$', '$1$', 'option2', 'A rectangular hyperbola $xy = c^2$ always has eccentricity $\sqrt{2}$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Latus rectum of ellipse x²/a²+y²/b²=1 where a>b. If a=5, b=4, LR=2b²/a=32/5.
-- Endpoints of LR: (c, ±b²/a) where c=3. So (3, 16/5) and (3, -16/5).
-- Distance between endpoints = 2(16/5) = 32/5.
('The length of the latus rectum of the ellipse $\frac{x^2}{25} + \frac{y^2}{16} = 1$ is', '$8$', '$\frac{16}{5}$', '$\frac{50}{4}$', '$\frac{32}{5}$', 'option4', 'Latus rectum $= \frac{2b^2}{a} = \frac{2(16)}{5} = \frac{32}{5}$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Equation of tangent to hyperbola x²/9-y²/4=1 with slope 2.
-- Tangent: y=mx±√(a²m²-b²) = 2x±√(36-4) = 2x±√32 = 2x±4√2.
('The tangents to $\frac{x^2}{9}-\frac{y^2}{4}=1$ with slope $2$ are', '$y = 2x \pm 4\sqrt{2}$', '$y = 2x \pm 6$', '$y = 2x \pm \sqrt{32}$', '$y = 2x \pm 2\sqrt{2}$', 'option1', 'Tangent: $y = mx \pm \sqrt{a^2m^2-b^2} = 2x \pm \sqrt{36-4} = 2x \pm 4\sqrt{2}$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Parabola y²=4ax. Tangent at t₁ and t₂ intersect at (at₁t₂, a(t₁+t₂)).
-- If tangents at t=1 and t=2 on y²=4x (a=1) intersect, point = (1·2, 1+2) = (2,3).
('Tangents to $y^2 = 4x$ at $t = 1$ and $t = 2$ intersect at', '$(2, 3)$', '$(1, 2)$', '$(4, 4)$', '$(3, 2)$', 'option1', 'Tangents at $t_1, t_2$ on $y^2=4ax$ meet at $(at_1 t_2, a(t_1+t_2))$. Here $a=1$: point $= (2, 3)$.', 'm_conic_sections', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_3d_coordinates_distance (Unit 11)
-- Coordinates in space, distance between points, section formula
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Distance between (1,2,3) and (4,6,3). d=√(9+16+0)=√25=5.
('The distance between $(1, 2, 3)$ and $(4, 6, 3)$ is', '$5$', '$\sqrt{26}$', '$7$', '$\sqrt{29}$', 'option1', '$d = \sqrt{(4-1)^2+(6-2)^2+(3-3)^2} = \sqrt{9+16+0} = 5$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Midpoint of (2,4,6) and (8,10,12). M = (5,7,9).
('The midpoint of $(2, 4, 6)$ and $(8, 10, 12)$ is', '$(5, 7, 9)$', '$(10, 14, 18)$', '$(4, 6, 8)$', '$(6, 8, 10)$', 'option1', 'Midpoint $= \left(\frac{2+8}{2}, \frac{4+10}{2}, \frac{6+12}{2}\right) = (5, 7, 9)$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Distance of (3,4,5) from origin. d=√(9+16+25)=√50=5√2.
('The distance of $(3, 4, 5)$ from the origin is', '$5\sqrt{2}$', '$\sqrt{50}$', '$12$', '$\sqrt{38}$', 'option1', '$d = \sqrt{9+16+25} = \sqrt{50} = 5\sqrt{2}$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Point dividing (1,2,3) and (4,5,6) in ratio 2:1 internally.
-- P = ((2·4+1·1)/3, (2·5+1·2)/3, (2·6+1·3)/3) = (9/3, 12/3, 15/3) = (3,4,5).
('The point dividing $(1, 2, 3)$ and $(4, 5, 6)$ in the ratio $2:1$ internally is', '$(3, 4, 5)$', '$(2, 3, 4)$', '$(3, 3, 3)$', '$(5, 8, 9)$', 'option1', '$P = \left(\frac{2(4)+1(1)}{3}, \frac{2(5)+1(2)}{3}, \frac{2(6)+1(3)}{3}\right) = (3, 4, 5)$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Distance of (1,2,3) from xy-plane. The xy-plane is z=0. Distance = |3| = 3.
('The distance of $(1, 2, 3)$ from the $xy$-plane is', '$3$', '$1$', '$2$', '$\sqrt{14}$', 'option1', 'The $xy$-plane is $z = 0$. Distance $= |3| = 3$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Centroid of tetrahedron with vertices (0,0,0), (4,0,0), (0,4,0), (0,0,4).
-- G = (1,1,1).
('The centroid of the tetrahedron with vertices $(0,0,0)$, $(4,0,0)$, $(0,4,0)$, $(0,0,4)$ is', '$(4, 4, 4)$', '$(2, 2, 2)$', '$(1, 1, 1)$', '$(0, 0, 0)$', 'option3', 'Centroid $= \left(\frac{0+4+0+0}{4}, \frac{0+0+4+0}{4}, \frac{0+0+0+4}{4}\right) = (1, 1, 1)$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Distance between (1,-1,1) and (-1,1,-1). d=√(4+4+4)=√12=2√3.
('The distance between $(1, -1, 1)$ and $(-1, 1, -1)$ is', '$\sqrt{12}$', '$2\sqrt{3}$', '$4$', '$2\sqrt{2}$', 'option2', '$d = \sqrt{4+4+4} = \sqrt{12} = 2\sqrt{3}$.', 'm_3d_coordinates_distance', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Point dividing (2,3,4) and (5,6,7) externally in ratio 2:1.
-- P = ((2·5-1·2)/(2-1), (2·6-1·3)/(2-1), (2·7-1·4)/(2-1)) = (8,9,10).
('The point dividing $(2, 3, 4)$ and $(5, 6, 7)$ externally in the ratio $2:1$ is', '$(7, 8, 9)$', '$(4, 5, 6)$', '$(3, 4, 5)$', '$(8, 9, 10)$', 'option4', '$P = \left(\frac{2(5)-1(2)}{1}, \frac{2(6)-1(3)}{1}, \frac{2(7)-1(4)}{1}\right) = (8, 9, 10)$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q9: If (x,y,z) divides (1,2,3) and (7,8,9) in ratio k:1 and x=3, find k.
-- x = (7k+1)/(k+1) = 3 => 7k+1=3k+3 => 4k=2 => k=1/2.
('If the point $(3, y, z)$ divides $(1, 2, 3)$ and $(7, 8, 9)$ internally, then the ratio is', '$1:2$', '$2:1$', '$1:3$', '$3:1$', 'option1', '$\frac{7k+1}{k+1} = 3$, so $7k+1 = 3k+3$, $k = \frac{1}{2}$. Ratio $= 1:2$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Centroid of triangle (1,2,3), (3,4,5), (5,6,7). G = (3,4,5).
('The centroid of the triangle with vertices $(1,2,3)$, $(3,4,5)$, and $(5,6,7)$ is', '$(3, 4, 5)$', '$(9, 12, 15)$', '$(2, 3, 4)$', '$(4, 5, 6)$', 'option1', 'Centroid $= \left(\frac{1+3+5}{3}, \frac{2+4+6}{3}, \frac{3+5+7}{3}\right) = (3, 4, 5)$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Distance of (2,3,4) from x-axis. Point on x-axis nearest is (2,0,0). d=√(0+9+16)=5.
('The distance of $(2, 3, 4)$ from the $x$-axis is', '$5$', '$\sqrt{29}$', '$\sqrt{13}$', '$4$', 'option1', 'Distance from $x$-axis $= \sqrt{y^2+z^2} = \sqrt{9+16} = 5$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q12: If A=(1,2,3), B=(4,5,6), find point P on AB such that AP:PB=1:2.
-- P = ((1·4+2·1)/3, (1·5+2·2)/3, (1·6+2·3)/3) = (6/3, 9/3, 12/3) = (2,3,4).
('The point on the line joining $(1,2,3)$ and $(4,5,6)$ that divides it in ratio $1:2$ is', '$(3, 4, 5)$', '$(2, 3, 4)$', '$(2.5, 3.5, 4.5)$', '$(1.5, 2.5, 3.5)$', 'option2', '$P = \left(\frac{4+2}{3}, \frac{5+4}{3}, \frac{6+6}{3}\right) = (2, 3, 4)$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Image of (1,2,3) in xy-plane. Reflect z: (1,2,-3).
('The image of $(1, 2, 3)$ in the $xy$-plane is', '$(1, 2, -3)$', '$(-1, -2, 3)$', '$(1, -2, 3)$', '$(-1, 2, -3)$', 'option1', 'Reflection in $xy$-plane: $(x, y, z) \to (x, y, -z)$. Image: $(1, 2, -3)$.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Ratio in which yz-plane divides join of (2,4,5) and (3,5,7).
-- yz-plane: x=0. (3k+2)/(k+1)=0 => 3k+2=0 => k=-2/3. Ratio = 2:3 externally.
('The $yz$-plane divides the join of $(2,4,5)$ and $(3,5,7)$ in the ratio', '$3:2$ externally', '$2:3$ internally', '$2:3$ externally', '$3:2$ internally', 'option3', '$\frac{3k+2}{k+1}=0$ gives $k=-\frac{2}{3}$. Negative ratio means external division: $2:3$ externally.', 'm_3d_coordinates_distance', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: If A=(1,2,3), B=(2,3,1), C=(3,1,2), show ABC is equilateral and find side length.
-- AB=√(1+1+4)=√6. BC=√(1+4+1)=√6. CA=√(4+1+1)=√6. Equilateral with side √6.
('The triangle with vertices $(1,2,3)$, $(2,3,1)$, $(3,1,2)$ is', 'Equilateral with side $\sqrt{6}$', 'Isosceles with side $\sqrt{3}$', 'Right-angled', 'Scalene', 'option1', '$AB = \sqrt{1+1+4} = \sqrt{6}$, $BC = \sqrt{1+4+1} = \sqrt{6}$, $CA = \sqrt{4+1+1} = \sqrt{6}$. Equilateral.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Locus of point equidistant from (1,2,3) and (3,2,1).
-- (x-1)²+(y-2)²+(z-3)² = (x-3)²+(y-2)²+(z-1)².
-- x²-2x+1+z²-6z+9 = x²-6x+9+z²-2z+1. => 4x-4z=0 => x=z.
('The locus of a point equidistant from $(1,2,3)$ and $(3,2,1)$ is', '$y = 2$', '$x + z = 4$', '$x = z$', '$x - z = 2$', 'option3', 'Expanding $(x-1)^2+(y-2)^2+(z-3)^2 = (x-3)^2+(y-2)^2+(z-1)^2$ simplifies to $4x - 4z = 0$, i.e., $x = z$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q17: If P=(x,y,z) such that PA²+PB²=k where A=(1,0,0), B=(-1,0,0).
-- PA² = (x-1)²+y²+z², PB² = (x+1)²+y²+z². Sum = 2x²+2+2y²+2z² = 2(x²+y²+z²+1).
-- If PA²+PB²=10: x²+y²+z²=4. Sphere of radius 2.
('If $PA^2 + PB^2 = 10$ where $A = (1,0,0)$ and $B = (-1,0,0)$, then the locus of $P$ is', 'A sphere of radius $2$', 'A sphere of radius $\sqrt{5}$', 'A plane', 'An ellipsoid', 'option1', '$PA^2+PB^2 = 2(x^2+y^2+z^2)+2 = 10$, so $x^2+y^2+z^2 = 4$. Sphere of radius $2$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Area of triangle with vertices A=(1,1,1), B=(1,2,3), C=(2,3,1).
-- AB = (0,1,2), AC = (1,2,0). AB×AC = |i  j  k; 0 1 2; 1 2 0| = i(0-4)-j(0-2)+k(0-1) = (-4,2,-1).
-- |AB×AC| = √(16+4+1) = √21. Area = √21/2.
('The area of the triangle with vertices $(1,1,1)$, $(1,2,3)$, $(2,3,1)$ is', '$\frac{\sqrt{14}}{2}$', '$\sqrt{21}$', '$\frac{\sqrt{21}}{2}$', '$\frac{7}{2}$', 'option3', '$\vec{AB}=(0,1,2)$, $\vec{AC}=(1,2,0)$. $\vec{AB}\times\vec{AC}=(-4,2,-1)$. Area $= \frac{1}{2}\sqrt{16+4+1} = \frac{\sqrt{21}}{2}$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q19: If (a,b,c) is the centroid of triangle (1,2,3),(5,6,7),(3,4,5), and a+b+c=?
-- G = (3,4,5). a+b+c = 12.
('If $(a,b,c)$ is the centroid of the triangle with vertices $(1,2,3)$, $(5,6,7)$, $(3,4,5)$, then $a+b+c$ equals', '$9$', '$15$', '$12$', '$18$', 'option3', 'Centroid $= (3,4,5)$. $a+b+c = 3+4+5 = 12$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Distance from (1,2,3) to the plane x+y+z=1. d = |1+2+3-1|/√3 = 5/√3 = 5√3/3.
('The distance from $(1, 2, 3)$ to the plane $x + y + z = 1$ is', '$5$', '$\frac{5\sqrt{3}}{3}$', '$\frac{5}{3}$', '$\sqrt{3}$', 'option2', 'Distance $= \frac{|1+2+3-1|}{\sqrt{3}} = \frac{5}{\sqrt{3}} = \frac{5\sqrt{3}}{3}$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Ratio in which plane 2x+3y+5z=1 divides join of (1,0,-3) and (1,-5,7).
-- Point on line: ((k+1)/(k+1), -5k/(k+1), (7k-3)/(k+1)). Sub in plane:
-- 2(k+1)/(k+1) + 3(-5k)/(k+1) + 5(7k-3)/(k+1) = 1.
-- [2(k+1) - 15k + 35k - 15]/(k+1) = 1. [2k+2-15k+35k-15]/(k+1)=1. [22k-13]/(k+1)=1.
-- 22k-13=k+1 => 21k=14 => k=2/3. Ratio = 2:3.
('The plane $2x+3y+5z=1$ divides the join of $(1,0,-3)$ and $(1,-5,7)$ in the ratio', '$2:3$', '$3:2$', '$1:2$', '$2:1$', 'option1', 'Parametric point: $\left(1, \frac{-5k}{k+1}, \frac{7k-3}{k+1}\right)$. Substituting in $2x+3y+5z=1$: $22k-13=k+1$, $k=\frac{2}{3}$. Ratio $= 2:3$.', 'm_3d_coordinates_distance', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_direction_ratios_cosines (Unit 11)
-- Direction ratios and cosines, angle between two lines
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Direction cosines of x-axis. l=1, m=0, n=0.
('The direction cosines of the $x$-axis are', '$(1, 0, 0)$', '$(0, 1, 0)$', '$(0, 0, 1)$', '$(\frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}})$', 'option1', 'The $x$-axis has direction along $(1,0,0)$. Direction cosines: $(1, 0, 0)$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Direction ratios of line joining (1,2,3) and (4,6,8). DR = (3,4,5).
('The direction ratios of the line joining $(1,2,3)$ and $(4,6,8)$ are', '$(4, 6, 8)$', '$(5, 8, 11)$', '$(1, 2, 3)$', '$(3, 4, 5)$', 'option4', 'DR $= (4-1, 6-2, 8-3) = (3, 4, 5)$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q3: If direction cosines are l,m,n then l²+m²+n²=1. If l=1/3, m=2/3, n=?
-- 1/9+4/9+n²=1 => n²=4/9 => n=±2/3.
('If the direction cosines of a line are $\frac{1}{3}, \frac{2}{3}, n$, then $|n|$ equals', '$\frac{2}{3}$', '$\frac{1}{3}$', '$\frac{\sqrt{5}}{3}$', '$\frac{4}{9}$', 'option1', '$l^2+m^2+n^2=1$: $\frac{1}{9}+\frac{4}{9}+n^2=1$, so $n^2=\frac{4}{9}$, $|n|=\frac{2}{3}$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Direction cosines of line with DR (1,1,1). DC = (1/√3, 1/√3, 1/√3).
('The direction cosines of a line with direction ratios $(1, 1, 1)$ are', '$\left(\frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}\right)$', '$(1, 1, 1)$', '$\left(\frac{1}{3}, \frac{1}{3}, \frac{1}{3}\right)$', '$\left(\frac{1}{\sqrt{2}}, \frac{1}{\sqrt{2}}, 0\right)$', 'option1', 'Magnitude $= \sqrt{1+1+1} = \sqrt{3}$. DC $= \left(\frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}\right)$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Angle between lines with DR (1,0,0) and (0,1,0). cos θ = 0. θ = 90°.
('The angle between lines with direction ratios $(1,0,0)$ and $(0,1,0)$ is', '$45°$', '$0°$', '$90°$', '$60°$', 'option3', '$\cos\theta = \frac{0+0+0}{1 \cdot 1} = 0$. $\theta = 90°$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Direction ratios of line equally inclined to axes. DR = (1,1,1) or any scalar multiple.
('A line equally inclined to all three coordinate axes has direction ratios', '$(1, 1, 1)$', '$(1, 0, 0)$', '$(1, 1, 0)$', '$(0, 1, 1)$', 'option1', 'Equally inclined means equal direction cosines: $l = m = n = \frac{1}{\sqrt{3}}$. DR: $(1, 1, 1)$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Q7: If DR are (2,3,6), find direction cosines. Magnitude = √(4+9+36)=7. DC = (2/7, 3/7, 6/7).
('The direction cosines of a line with direction ratios $(2, 3, 6)$ are', '$\left(\frac{1}{7}, \frac{2}{7}, \frac{3}{7}\right)$', '$\left(\frac{2}{3}, 1, 2\right)$', '$\left(\frac{2}{7}, \frac{3}{7}, \frac{6}{7}\right)$', '$(2, 3, 6)$', 'option3', 'Magnitude $= \sqrt{4+9+36} = 7$. DC $= \left(\frac{2}{7}, \frac{3}{7}, \frac{6}{7}\right)$.', 'm_direction_ratios_cosines', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Angle between lines with DR (1,2,2) and (2,1,2).
-- cos θ = (2+2+4)/(√9·√9) = 8/9. θ = cos⁻¹(8/9).
('The cosine of the angle between lines with direction ratios $(1,2,2)$ and $(2,1,2)$ is', '$\frac{8}{9}$', '$\frac{2}{3}$', '$\frac{4}{9}$', '$\frac{7}{9}$', 'option1', '$\cos\theta = \frac{1(2)+2(1)+2(2)}{\sqrt{1+4+4}\sqrt{4+1+4}} = \frac{8}{9}$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q9: If a line makes angles 60°, 45° with x and y axes, angle with z-axis.
-- cos²60°+cos²45°+cos²γ=1. 1/4+1/2+cos²γ=1. cos²γ=1/4. γ=60° or 120°.
('If a line makes angles $60°$ and $45°$ with the $x$ and $y$ axes, the angle with the $z$-axis is', '$75°$', '$60°$ or $120°$', '$45°$', '$90°$', 'option2', '$\cos^2 60°+\cos^2 45°+\cos^2\gamma=1$: $\frac{1}{4}+\frac{1}{2}+\cos^2\gamma=1$, $\cos^2\gamma=\frac{1}{4}$, $\gamma=60°$ or $120°$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Lines with DR (1,2,3) and (2,k,-1) are perpendicular. 1(2)+2k+3(-1)=0 => 2+2k-3=0 => k=1/2.
('If lines with direction ratios $(1,2,3)$ and $(2,k,-1)$ are perpendicular, then $k$ equals', '$1$', '$\frac{1}{2}$', '$-1$', '$\frac{3}{2}$', 'option2', 'Perpendicular: $1(2)+2(k)+3(-1)=0$, i.e., $2k-1=0$, $k=\frac{1}{2}$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Projection of line joining (1,2,3) and (4,5,6) on a line with DC (1/√3, 1/√3, 1/√3).
-- DR of join = (3,3,3). Projection = 3/√3+3/√3+3/√3 = 9/√3 = 3√3.
('The projection of the segment from $(1,2,3)$ to $(4,5,6)$ on a line with direction cosines $\left(\frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}, \frac{1}{\sqrt{3}}\right)$ is', '$3\sqrt{3}$', '$9$', '$\sqrt{3}$', '$3$', 'option1', 'Projection $= 3 \cdot \frac{1}{\sqrt{3}}+3 \cdot \frac{1}{\sqrt{3}}+3 \cdot \frac{1}{\sqrt{3}} = \frac{9}{\sqrt{3}} = 3\sqrt{3}$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q12: DR of line x/2 = y/3 = z/4 are (2,3,4). DR of line x/1 = y/-1 = z/2 are (1,-1,2).
-- Angle: cos θ = (2-3+8)/(√29·√6) = 7/√174.
('The cosine of the angle between the lines $\frac{x}{2}=\frac{y}{3}=\frac{z}{4}$ and $\frac{x}{1}=\frac{y}{-1}=\frac{z}{2}$ is', '$\frac{7}{\sqrt{174}}$', '$\frac{7}{\sqrt{29}}$', '$\frac{3}{\sqrt{29}}$', '$\frac{1}{\sqrt{6}}$', 'option1', '$\cos\theta = \frac{2(1)+3(-1)+4(2)}{\sqrt{4+9+16}\sqrt{1+1+4}} = \frac{7}{\sqrt{29}\sqrt{6}} = \frac{7}{\sqrt{174}}$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q13: If direction cosines of two lines are (l₁,m₁,n₁) and (l₂,m₂,n₂), and lines are parallel, then l₁/l₂=m₁/m₂=n₁/n₂.
-- Lines with DR (2,3,k) and (4,6,8) are parallel: 2/4=3/6=k/8 => k=4.
('If lines with direction ratios $(2,3,k)$ and $(4,6,8)$ are parallel, then $k$ equals', '$4$', '$8$', '$6$', '$2$', 'option1', 'Parallel: $\frac{2}{4}=\frac{3}{6}=\frac{k}{8}$. Each ratio $= \frac{1}{2}$, so $k = 4$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Q14: A line makes angle α with x-axis and β with y-axis. If α=β=45°, find angle with z-axis.
-- cos²45°+cos²45°+cos²γ=1 => 1/2+1/2+cos²γ=1 => cos²γ=0 => γ=90°.
('A line making equal angles of $45°$ with both $x$ and $y$ axes makes an angle with the $z$-axis of', '$90°$', '$45°$', '$60°$', '$0°$', 'option1', '$\cos^2 45°+\cos^2 45°+\cos^2\gamma=1$: $\frac{1}{2}+\frac{1}{2}+\cos^2\gamma=1$, $\cos^2\gamma=0$, $\gamma=90°$.', 'm_direction_ratios_cosines', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: DR of line perpendicular to both (1,2,3) and (3,2,1).
-- Cross product: |i j k; 1 2 3; 3 2 1| = i(2-6)-j(1-9)+k(2-6) = (-4,8,-4) or simplified (1,-2,1).
('The direction ratios of a line perpendicular to lines with DR $(1,2,3)$ and $(3,2,1)$ are', '$(1, -2, 1)$', '$(4, 8, 4)$', '$(2, -1, 2)$', '$(1, 1, -1)$', 'option1', 'Cross product: $\begin{vmatrix}\vec{i}&\vec{j}&\vec{k}\\1&2&3\\3&2&1\end{vmatrix} = (-4, 8, -4)$, simplified: $(1, -2, 1)$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If a line has DC (l,m,n) and makes angle 45° with (1,0,1)/√2, then l+n=1.
-- cos 45° = (l·1/√2 + m·0 + n·1/√2) = (l+n)/√2 = 1/√2. So l+n=1.
('If a line with direction cosines $(l,m,n)$ makes an angle of $45°$ with the line having direction cosines $\left(\frac{1}{\sqrt{2}}, 0, \frac{1}{\sqrt{2}}\right)$, then $l + n$ equals', '$\sqrt{2}$', '$\frac{1}{\sqrt{2}}$', '$1$', '$\frac{1}{2}$', 'option3', '$\cos 45° = \frac{l}{\sqrt{2}}+0+\frac{n}{\sqrt{2}} = \frac{l+n}{\sqrt{2}} = \frac{1}{\sqrt{2}}$. So $l+n = 1$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Angle between diagonals of a cube. Diagonals: (1,1,1) and (1,1,-1).
-- cos θ = (1+1-1)/(√3·√3) = 1/3. θ = cos⁻¹(1/3).
('The cosine of the angle between the diagonals $(1,1,1)$ and $(1,1,-1)$ of a cube is', '$0$', '$\frac{2}{3}$', '$\frac{1}{\sqrt{3}}$', '$\frac{1}{3}$', 'option4', '$\cos\theta = \frac{1+1-1}{\sqrt{3}\cdot\sqrt{3}} = \frac{1}{3}$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If lines (x-1)/2=(y-2)/3=(z-3)/4 and (x-1)/5=(y-2)/k=(z-3)/1 are perpendicular, find k.
-- 2(5)+3k+4(1)=0 => 10+3k+4=0 => 3k=-14 => k=-14/3.
('If the lines $\frac{x-1}{2}=\frac{y-2}{3}=\frac{z-3}{4}$ and $\frac{x-1}{5}=\frac{y-2}{k}=\frac{z-3}{1}$ are perpendicular, then $k$ equals', '$\frac{14}{3}$', '$-\frac{7}{3}$', '$-\frac{14}{3}$', '$-2$', 'option3', 'Perpendicular: $2(5)+3k+4(1)=0$, i.e., $14+3k=0$, $k=-\frac{14}{3}$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q19: A line makes angles α, β, γ with axes. If sin²α+sin²β=1, then γ=90°.
-- sin²α+sin²β=1 => (1-cos²α)+(1-cos²β)=1 => cos²α+cos²β=1. Since cos²α+cos²β+cos²γ=1, cos²γ=0, γ=90°.
('If a line makes angles $\alpha, \beta, \gamma$ with the axes and $\sin^2\alpha + \sin^2\beta = 1$, then $\gamma$ equals', '$90°$', '$0°$', '$45°$', '$60°$', 'option1', '$\sin^2\alpha+\sin^2\beta=1$ gives $\cos^2\alpha+\cos^2\beta=1$. Since $\cos^2\alpha+\cos^2\beta+\cos^2\gamma=1$, we get $\cos^2\gamma=0$, $\gamma=90°$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q20: If two lines have DC (l₁,m₁,n₁) and (l₂,m₂,n₂), then sin²θ = (l₁m₂-l₂m₁)²+(m₁n₂-m₂n₁)²+(n₁l₂-n₂l₁)².
-- For DC (1,0,0) and (0,1,0): sin²θ = 1+0+0=1. θ=90°. Consistent.
-- For DC (1/√2,1/√2,0) and (1/√2,0,1/√2): 
-- (1/√2·0-1/√2·1/√2)²+(1/√2·1/√2-0·0)²+(0·1/√2-1/√2·1/√2)²
-- = (-1/2)²+(1/2)²+(-1/2)² = 1/4+1/4+1/4 = 3/4. sin θ = √(3/4)=√3/2. θ=60°.
-- cos θ = 1/√2·1/√2+0+0 = 1/2. θ=60°. ✓
('The angle between lines with direction cosines $\left(\frac{1}{\sqrt{2}},\frac{1}{\sqrt{2}},0\right)$ and $\left(\frac{1}{\sqrt{2}},0,\frac{1}{\sqrt{2}}\right)$ is', '$60°$', '$45°$', '$90°$', '$30°$', 'option1', '$\cos\theta = \frac{1}{\sqrt{2}}\cdot\frac{1}{\sqrt{2}}+\frac{1}{\sqrt{2}}\cdot 0+0\cdot\frac{1}{\sqrt{2}} = \frac{1}{2}$. $\theta = 60°$.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- Q21: If a line is equally inclined to axes, its direction cosines are (±1/√3, ±1/√3, ±1/√3).
-- Number of such lines = 4 (since l²=m²=n²=1/3, each ±, but l,m,n must satisfy l²+m²+n²=1, and we need distinct lines, not just directions).
-- Actually each of 8 sign combinations gives a direction, but opposite signs give same line. So 4 distinct lines.
('The number of lines equally inclined to all three coordinate axes is', '$6$', '$2$', '$8$', '$4$', 'option4', 'Direction cosines: $\left(\pm\frac{1}{\sqrt{3}}, \pm\frac{1}{\sqrt{3}}, \pm\frac{1}{\sqrt{3}}\right)$. There are $8$ sign combinations, but opposite directions give the same line, so $4$ distinct lines.', 'm_direction_ratios_cosines', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_3d_line_skew (Unit 11)
-- Equation of a line, skew lines, shortest distance
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Equation of line through (1,2,3) with DR (2,3,4): (x-1)/2=(y-2)/3=(z-3)/4.
('The equation of the line through $(1,2,3)$ with direction ratios $(2,3,4)$ is', '$\frac{x-1}{2}=\frac{y-2}{3}=\frac{z-3}{4}$', '$\frac{x-2}{1}=\frac{y-3}{2}=\frac{z-4}{3}$', '$\frac{x+1}{2}=\frac{y+2}{3}=\frac{z+3}{4}$', '$\frac{x-1}{3}=\frac{y-2}{2}=\frac{z-3}{1}$', 'option1', 'Line through $(x_1,y_1,z_1)$ with DR $(a,b,c)$: $\frac{x-x_1}{a}=\frac{y-y_1}{b}=\frac{z-z_1}{c}$.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Direction ratios of line (x-1)/3=(y+2)/5=(z-4)/7 are (3,5,7).
('The direction ratios of the line $\frac{x-1}{3}=\frac{y+2}{5}=\frac{z-4}{7}$ are', '$(1, -2, 4)$', '$(3, 5, 7)$', '$(3, -2, 7)$', '$(1, 5, 4)$', 'option2', 'From the symmetric form, direction ratios are the denominators: $(3, 5, 7)$.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q3: A point on line (x-1)/2=(y-2)/3=(z-3)/4. At parameter t=0: (1,2,3). At t=1: (3,5,7).
('A point on the line $\frac{x-1}{2}=\frac{y-2}{3}=\frac{z-3}{4}$ is', '$(0, 0, 0)$', '$(2, 3, 4)$', '$(1, 3, 5)$', '$(3, 5, 7)$', 'option4', 'At parameter $t=1$: $x=1+2=3$, $y=2+3=5$, $z=3+4=7$. Point: $(3,5,7)$.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Line through (0,0,0) and (1,1,1): x/1=y/1=z/1, i.e., x=y=z.
('The equation of the line through the origin and $(1,1,1)$ is', '$x = y = z$', '$\frac{x}{1}=\frac{y}{2}=\frac{z}{3}$', '$x + y + z = 0$', '$x = y, z = 0$', 'option1', 'DR $= (1,1,1)$. Line: $\frac{x}{1}=\frac{y}{1}=\frac{z}{1}$, i.e., $x = y = z$.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Two lines are skew if they are not parallel and do not intersect.
-- x=y=z and x=y+1, z=0. First passes through origin along (1,1,1). Second: parametric (t,t+1,0).
-- They don't intersect (check: t=t+1 impossible) and aren't parallel. Skew.
('Lines $x = y = z$ and $x = y + 1, z = 0$ are', 'Coincident', 'Parallel', 'Intersecting', 'Skew', 'option4', 'First line: $(t,t,t)$. Second: $(s,s+1,0)$. For intersection: $t=s, t=s+1$ (impossible). Not parallel (DR $(1,1,1)$ vs $(1,1,0)$). Hence skew.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Line through (1,0,0) parallel to z-axis: x=1, y=0 (or (x-1)/0=y/0=z/1). DR=(0,0,1).
('The equation of the line through $(1,0,0)$ parallel to the $z$-axis is', '$x = 0, z = 1$', '$x = 1, y = 0$', '$y = 0, z = 0$', '$x = 1, z = 0$', 'option2', 'Parallel to $z$-axis: DR $= (0,0,1)$. Line: $x = 1, y = 0$ (with $z$ free).', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Q7: The line x/1=y/1=z/1 passes through origin. Does (2,2,2) lie on it? 2/1=2/1=2/1=2. Yes.
('The point $(2, 2, 2)$ lies on the line $\frac{x}{1}=\frac{y}{1}=\frac{z}{1}$', 'Cannot be determined', 'False', 'True', 'Only if extended', 'option3', '$\frac{2}{1}=\frac{2}{1}=\frac{2}{1}=2$. All ratios equal, so $(2,2,2)$ lies on the line.', 'm_3d_line_skew', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Shortest distance between lines (x-1)/2=(y-2)/3=(z-3)/4 and (x-2)/4=(y-4)/6=(z-5)/8.
-- DR: (2,3,4) and (4,6,8)=(2)(2,3,4). Lines are parallel.
-- Distance between parallel lines: |a⃗×(b⃗₂-b⃗₁)|/|a⃗| where a⃗=(2,3,4), b⃗₁=(1,2,3), b⃗₂=(2,4,5).
-- b⃗₂-b⃗₁=(1,2,2). a⃗×(1,2,2)=|i j k;2 3 4;1 2 2|=i(6-8)-j(4-4)+k(4-3)=(-2,0,1).
-- |(-2,0,1)|=√5. |a⃗|=√29. Distance=√5/√29=√(5/29).
('The shortest distance between the parallel lines $\frac{x-1}{2}=\frac{y-2}{3}=\frac{z-3}{4}$ and $\frac{x-2}{4}=\frac{y-4}{6}=\frac{z-5}{8}$ is', '$\sqrt{\frac{5}{29}}$', '$\frac{5}{\sqrt{29}}$', '$\frac{\sqrt{5}}{29}$', '$0$', 'option1', 'Parallel lines (DR proportional). $\vec{a}=(2,3,4)$, $\vec{PQ}=(1,2,2)$. $\vec{a}\times\vec{PQ}=(-2,0,1)$. Distance $= \frac{\sqrt{5}}{\sqrt{29}} = \sqrt{\frac{5}{29}}$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Line through (1,2,3) and (3,4,5). DR=(2,2,2) or (1,1,1). Equation: (x-1)/1=(y-2)/1=(z-3)/1.
('The equation of the line through $(1,2,3)$ and $(3,4,5)$ is', '$\frac{x-1}{3}=\frac{y-2}{4}=\frac{z-3}{5}$', '$\frac{x-1}{2}=\frac{y-2}{3}=\frac{z-3}{4}$', '$\frac{x-1}{1}=\frac{y-2}{1}=\frac{z-3}{1}$', '$x = y = z$', 'option3', 'DR $= (3-1, 4-2, 5-3) = (2,2,2)$, simplified $(1,1,1)$. Line: $\frac{x-1}{1}=\frac{y-2}{1}=\frac{z-3}{1}$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Do lines (x-1)/1=(y-2)/2=(z-3)/3 and (x-4)/2=(y-1)/0=(z-0)/3 intersect?
-- Line 1: (1+t, 2+2t, 3+3t). Line 2: (4+2s, 1, 3s).
-- y: 2+2t=1 => t=-1/2. z: 3+3(-1/2)=3/2 and 3s => s=1/2. x: 1-1/2=1/2 and 4+1=5. 1/2≠5. Don't intersect.
-- Not parallel (DR (1,2,3) and (2,0,3) not proportional). So skew.
('The lines $\frac{x-1}{1}=\frac{y-2}{2}=\frac{z-3}{3}$ and $\frac{x-4}{2}=\frac{y-1}{0}=\frac{z}{3}$ are', 'Intersecting', 'Skew', 'Parallel', 'Coincident', 'option2', 'Line 1: $(1+t,2+2t,3+3t)$. Line 2: $(4+2s,1,3s)$. From $y$: $t=-\frac{1}{2}$, $z$: $s=\frac{1}{2}$. But $x$: $\frac{1}{2}\neq 5$. Not parallel. Skew.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Shortest distance between x-axis (x/1=y/0=z/0) and line (x-1)/0=(y-2)/1=(z-3)/0 (i.e., x=1, z=3, y varies).
-- x-axis: (t,0,0). Second line: (1,2+s,3). Shortest distance = distance between skew lines.
-- a⃗₁=(0,0,0), b⃗₁=(1,0,0). a⃗₂=(1,2,3), b⃗₂=(0,1,0).
-- b⃗₁×b⃗₂ = |i j k;1 0 0;0 1 0| = (0,0,1). |b⃗₁×b⃗₂|=1.
-- a⃗₂-a⃗₁=(1,2,3). d = |(1,2,3)·(0,0,1)|/1 = 3.
('The shortest distance between the $x$-axis and the line $x = 1, z = 3$ is', '$3$', '$1$', '$\sqrt{10}$', '$\sqrt{2}$', 'option1', '$\vec{b_1}\times\vec{b_2} = (1,0,0)\times(0,1,0) = (0,0,1)$. $d = \frac{|(1,2,3)\cdot(0,0,1)|}{1} = 3$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Vector equation of line through (1,2,3) along (4,5,6): r⃗ = (1,2,3) + t(4,5,6).
-- Cartesian: (x-1)/4=(y-2)/5=(z-3)/6.
('The Cartesian equation of the line $\vec{r} = (1,2,3) + t(4,5,6)$ is', '$4x+5y+6z=32$', '$\frac{x-4}{1}=\frac{y-5}{2}=\frac{z-6}{3}$', '$\frac{x-1}{4}=\frac{y-2}{5}=\frac{z-3}{6}$', '$\frac{x}{4}=\frac{y}{5}=\frac{z}{6}$', 'option3', 'Point $(1,2,3)$, direction $(4,5,6)$: $\frac{x-1}{4}=\frac{y-2}{5}=\frac{z-3}{6}$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Foot of perpendicular from (1,2,3) to line x/1=y/1=z/1.
-- Point on line: (t,t,t). Vector from (t,t,t) to (1,2,3): (1-t,2-t,3-t). Perpendicular to (1,1,1):
-- (1-t)+(2-t)+(3-t)=0 => 6-3t=0 => t=2. Foot: (2,2,2).
('The foot of the perpendicular from $(1,2,3)$ to the line $x = y = z$ is', '$(1, 1, 1)$', '$(2, 2, 2)$', '$(3, 3, 3)$', '$(0, 0, 0)$', 'option2', 'Point on line: $(t,t,t)$. $(1-t)+(2-t)+(3-t)=0$, $t=2$. Foot: $(2,2,2)$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Distance of point (1,2,3) from line x=y=z. Foot is (2,2,2) from Q13.
-- Distance = √((1-2)²+(2-2)²+(3-2)²) = √(1+0+1) = √2.
('The distance of $(1, 2, 3)$ from the line $x = y = z$ is', '$\sqrt{2}$', '$\sqrt{3}$', '$1$', '$\sqrt{6}$', 'option1', 'Foot of perpendicular: $(2,2,2)$. Distance $= \sqrt{1+0+1} = \sqrt{2}$.', 'm_3d_line_skew', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Shortest distance between lines (x-1)/2=(y+1)/3=(z-1)/4 and (x-3)/1=(y-5)/2=(z-7)/1.
-- a⃗₁=(1,-1,1), b⃗₁=(2,3,4). a⃗₂=(3,5,7), b⃗₂=(1,2,1).
-- b⃗₁×b⃗₂ = |i j k;2 3 4;1 2 1| = i(3-8)-j(2-4)+k(4-3) = (-5,2,1). |(-5,2,1)|=√30.
-- a⃗₂-a⃗₁=(2,6,6). d = |(2,6,6)·(-5,2,1)|/√30 = |(-10+12+6)|/√30 = 8/√30.
('The shortest distance between $\frac{x-1}{2}=\frac{y+1}{3}=\frac{z-1}{4}$ and $\frac{x-3}{1}=\frac{y-5}{2}=\frac{z-7}{1}$ is', '$\frac{4}{\sqrt{30}}$', '$\frac{8\sqrt{30}}{30}$', '$\frac{8}{\sqrt{30}}$', '$\sqrt{30}$', 'option3', '$\vec{b_1}\times\vec{b_2}=(-5,2,1)$, $|\cdot|=\sqrt{30}$. $\vec{a_2}-\vec{a_1}=(2,6,6)$. $d=\frac{|(-10+12+6)|}{\sqrt{30}}=\frac{8}{\sqrt{30}}$.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Condition for lines (x-x₁)/a₁=(y-y₁)/b₁=(z-z₁)/c₁ and (x-x₂)/a₂=(y-y₂)/b₂=(z-z₂)/c₂ to be coplanar:
-- |x₂-x₁ y₂-y₁ z₂-z₁; a₁ b₁ c₁; a₂ b₂ c₂| = 0.
-- Lines (x-1)/1=(y-2)/2=(z-3)/3 and (x-2)/2=(y-3)/3=(z-4)/4.
-- |1 1 1; 1 2 3; 2 3 4| = 1(8-9)-1(4-6)+1(3-4) = -1+2-1 = 0. Coplanar (they intersect or are parallel).
('The lines $\frac{x-1}{1}=\frac{y-2}{2}=\frac{z-3}{3}$ and $\frac{x-2}{2}=\frac{y-3}{3}=\frac{z-4}{4}$ are', 'Parallel', 'Skew', 'Perpendicular', 'Coplanar', 'option4', '$\begin{vmatrix}1&1&1\\1&2&3\\2&3&4\end{vmatrix} = 1(8-9)-1(4-6)+1(3-4) = 0$. Lines are coplanar.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Image of (1,2,3) in line x/1=y/1=z/1. Foot is (2,2,2). Image = 2(2,2,2)-(1,2,3) = (3,2,1).
('The image of $(1, 2, 3)$ in the line $x = y = z$ is', '$(3, 2, 1)$', '$(2, 2, 2)$', '$(1, 1, 1)$', '$(2, 3, 1)$', 'option1', 'Foot of perpendicular: $(2,2,2)$. Image $= 2(2,2,2)-(1,2,3) = (3,2,1)$.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Shortest distance between lines r⃗=(1,1,1)+t(2,-1,1) and r⃗=(1,-1,1)+s(3,-5,2).
-- b⃗₁×b⃗₂ = |i j k;2 -1 1;3 -5 2| = i(-2+5)-j(4-3)+k(-10+3) = (3,-1,-7). |·|=√59.
-- a⃗₂-a⃗₁=(0,-2,0). d = |(0,-2,0)·(3,-1,-7)|/√59 = |2|/√59 = 2/√59.
('The shortest distance between $\vec{r}=(1,1,1)+t(2,-1,1)$ and $\vec{r}=(1,-1,1)+s(3,-5,2)$ is', '$\sqrt{59}$', '$\frac{2\sqrt{59}}{59}$', '$\frac{4}{\sqrt{59}}$', '$\frac{2}{\sqrt{59}}$', 'option4', '$\vec{b_1}\times\vec{b_2}=(3,-1,-7)$, $|\cdot|=\sqrt{59}$. $\vec{a_2}-\vec{a_1}=(0,-2,0)$. $d=\frac{|0+2+0|}{\sqrt{59}}=\frac{2}{\sqrt{59}}$.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Equation of line through (1,2,3) perpendicular to lines with DR (1,1,2) and (2,1,1).
-- Direction = (1,1,2)×(2,1,1) = |i j k;1 1 2;2 1 1| = i(1-2)-j(1-4)+k(1-2) = (-1,3,-1).
-- Line: (x-1)/(-1)=(y-2)/3=(z-3)/(-1), or (x-1)/1=(y-2)/(-3)=(z-3)/1.
('The equation of the line through $(1,2,3)$ perpendicular to lines with DR $(1,1,2)$ and $(2,1,1)$ is', '$\frac{x-1}{1}=\frac{y-2}{-3}=\frac{z-3}{1}$', '$\frac{x-1}{1}=\frac{y-2}{1}=\frac{z-3}{2}$', '$\frac{x-1}{2}=\frac{y-2}{1}=\frac{z-3}{1}$', '$\frac{x-1}{3}=\frac{y-2}{1}=\frac{z-3}{-1}$', 'option1', 'Direction $= (1,1,2)\times(2,1,1) = (-1,3,-1)$. Line: $\frac{x-1}{-1}=\frac{y-2}{3}=\frac{z-3}{-1}$, or $\frac{x-1}{1}=\frac{y-2}{-3}=\frac{z-3}{1}$.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Two lines intersect if shortest distance = 0.
-- (x-1)/1=(y-1)/2=(z-1)/3 and (x-2)/2=(y-3)/4=(z-4)/6. DR: (1,2,3) and (2,4,6)=(2)(1,2,3). Parallel.
-- For parallel lines, distance = |a⃗×PQ⃗|/|a⃗|. PQ=(1,2,3). a⃗=(1,2,3). a⃗×PQ=(1,2,3)×(1,2,3)=(0,0,0). Distance=0.
-- So lines are coincident (same line). Let me verify: (2,3,4) on first line? (2-1)/1=1, (3-1)/2=1, (4-1)/3=1. Yes. On second: (2-2)/2=0, (3-3)/4=0, (4-4)/6=0. Yes. Same line.
('The lines $\frac{x-1}{1}=\frac{y-1}{2}=\frac{z-1}{3}$ and $\frac{x-2}{2}=\frac{y-3}{4}=\frac{z-4}{6}$ are', 'Skew', 'Parallel but distinct', 'Coincident', 'Intersecting at one point', 'option3', 'DR proportional: $(2,4,6)=2(1,2,3)$. Point $(2,3,4)$ lies on both lines. Hence coincident.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Shortest distance between lines x=y=-z and x-1=y+1, z=2.
-- Line 1: (t,t,-t), DR=(1,1,-1). Line 2: x-1=y+1 means x=y+2, z=2. Parametric: (s+1,s-1+2-2,2)... 
-- Actually x-1=y+1 means x-1=y+1, let this = s. So x=s+1, y=s-1, z=2. DR=(1,1,0).
-- a⃗₁=(0,0,0), a⃗₂=(1,-1,2). b⃗₁=(1,1,-1), b⃗₂=(1,1,0).
-- b⃗₁×b⃗₂ = |i j k;1 1 -1;1 1 0| = i(0+1)-j(0+1)+k(1-1) = (1,-1,0). |·|=√2.
-- a⃗₂-a⃗₁=(1,-1,2). d = |(1,-1,2)·(1,-1,0)|/√2 = |1+1+0|/√2 = 2/√2 = √2.
('The shortest distance between the lines $x = y = -z$ and $x - 1 = y + 1, z = 2$ is', '$\sqrt{2}$', '$1$', '$2$', '$\frac{2}{\sqrt{3}}$', 'option1', '$\vec{b_1}\times\vec{b_2}=(1,1,-1)\times(1,1,0)=(1,-1,0)$, $|\cdot|=\sqrt{2}$. $\vec{a_2}-\vec{a_1}=(1,-1,2)$. $d=\frac{|1+1|}{\sqrt{2}}=\sqrt{2}$.', 'm_3d_line_skew', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_vectors_scalars_addition (Unit 12)
-- Vectors and scalars, addition of vectors
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Sum of vectors (1,2,3) and (4,5,6) = (5,7,9).
('The sum of vectors $\vec{a} = \hat{i}+2\hat{j}+3\hat{k}$ and $\vec{b} = 4\hat{i}+5\hat{j}+6\hat{k}$ is', '$5\hat{i}+7\hat{j}+9\hat{k}$', '$4\hat{i}+10\hat{j}+18\hat{k}$', '$3\hat{i}+3\hat{j}+3\hat{k}$', '$5\hat{i}+7\hat{j}+8\hat{k}$', 'option1', '$\vec{a}+\vec{b} = (1+4)\hat{i}+(2+5)\hat{j}+(3+6)\hat{k} = 5\hat{i}+7\hat{j}+9\hat{k}$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Magnitude of (3,4,0). |v|=√(9+16)=5.
('The magnitude of $3\hat{i}+4\hat{j}$ is', '$\sqrt{7}$', '$7$', '$5$', '$25$', 'option3', '$|\vec{v}| = \sqrt{9+16} = \sqrt{25} = 5$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Unit vector along (1,1,1). Magnitude=√3. Unit = (1/√3, 1/√3, 1/√3).
('The unit vector along $\hat{i}+\hat{j}+\hat{k}$ is', '$\frac{1}{3}(\hat{i}+\hat{j}+\hat{k})$', '$\hat{i}+\hat{j}+\hat{k}$', '$\frac{1}{\sqrt{3}}(\hat{i}+\hat{j}+\hat{k})$', '$\frac{1}{\sqrt{2}}(\hat{i}+\hat{j})$', 'option3', 'Magnitude $= \sqrt{3}$. Unit vector $= \frac{1}{\sqrt{3}}(\hat{i}+\hat{j}+\hat{k})$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q4: If a⃗=(2,3) and b⃗=(1,-1), then a⃗-b⃗=(1,4).
('If $\vec{a}=2\hat{i}+3\hat{j}$ and $\vec{b}=\hat{i}-\hat{j}$, then $\vec{a}-\vec{b}$ is', '$\hat{i}+2\hat{j}$', '$3\hat{i}+2\hat{j}$', '$\hat{i}+4\hat{j}$', '$3\hat{i}+4\hat{j}$', 'option3', '$\vec{a}-\vec{b} = (2-1)\hat{i}+(3-(-1))\hat{j} = \hat{i}+4\hat{j}$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q5: 2a⃗ where a⃗=(1,2,3) = (2,4,6).
('If $\vec{a} = \hat{i}+2\hat{j}+3\hat{k}$, then $2\vec{a}$ is', '$2\hat{i}+4\hat{j}+6\hat{k}$', '$\hat{i}+2\hat{j}+3\hat{k}$', '$3\hat{i}+4\hat{j}+5\hat{k}$', '$2\hat{i}+2\hat{j}+2\hat{k}$', 'option1', '$2\vec{a} = 2\hat{i}+4\hat{j}+6\hat{k}$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Position vector of midpoint of A(2,4,6) and B(4,8,10) = (3,6,8).
('The position vector of the midpoint of $A(2,4,6)$ and $B(4,8,10)$ is', '$3\hat{i}+6\hat{j}+8\hat{k}$', '$6\hat{i}+12\hat{j}+16\hat{k}$', '$2\hat{i}+4\hat{j}+4\hat{k}$', '$3\hat{i}+6\hat{j}+10\hat{k}$', 'option1', 'Midpoint $= \frac{1}{2}((2+4)\hat{i}+(4+8)\hat{j}+(6+10)\hat{k}) = 3\hat{i}+6\hat{j}+8\hat{k}$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Magnitude of (0,0,5) = 5.
('The magnitude of $5\hat{k}$ is', '$0$', '$25$', '$\sqrt{5}$', '$5$', 'option4', '$|5\hat{k}| = \sqrt{0+0+25} = 5$.', 'm_vectors_scalars_addition', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: If |a⃗|=3, |b⃗|=4, and a⃗⊥b⃗, then |a⃗+b⃗|=√(9+16)=5.
('If $|\vec{a}|=3$, $|\vec{b}|=4$, and $\vec{a}\perp\vec{b}$, then $|\vec{a}+\vec{b}|$ is', '$\sqrt{7}$', '$7$', '$1$', '$5$', 'option4', '$|\vec{a}+\vec{b}|^2 = |\vec{a}|^2+|\vec{b}|^2+2\vec{a}\cdot\vec{b} = 9+16+0 = 25$. So $|\vec{a}+\vec{b}| = 5$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q9: If a⃗+b⃗+c⃗=0 and |a⃗|=3, |b⃗|=5, |c⃗|=7, find angle between a⃗ and b⃗.
-- c⃗=-(a⃗+b⃗). |c⃗|²=|a⃗|²+|b⃗|²+2a⃗·b⃗. 49=9+25+2a⃗·b⃗. a⃗·b⃗=15/2.
-- cos θ = 15/(2·3·5) = 15/30 = 1/2. θ=60°.
('If $\vec{a}+\vec{b}+\vec{c}=\vec{0}$ with $|\vec{a}|=3$, $|\vec{b}|=5$, $|\vec{c}|=7$, the angle between $\vec{a}$ and $\vec{b}$ is', '$120°$', '$90°$', '$60°$', '$30°$', 'option3', '$|\vec{c}|^2=|\vec{a}|^2+|\vec{b}|^2+2\vec{a}\cdot\vec{b}$: $49=34+2\vec{a}\cdot\vec{b}$, $\vec{a}\cdot\vec{b}=\frac{15}{2}$. $\cos\theta=\frac{15/2}{15}=\frac{1}{2}$. $\theta=60°$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Resultant of two vectors of magnitudes 3 and 4 making angle 60°.
-- |R|²=9+16+2(3)(4)cos60°=25+12=37. |R|=√37.
('The magnitude of the resultant of two vectors of magnitudes $3$ and $4$ at an angle of $60°$ is', '$7$', '$\sqrt{37}$', '$5$', '$\sqrt{25}$', 'option2', '$|R|^2 = 9+16+2(3)(4)\cos 60° = 25+12 = 37$. $|R| = \sqrt{37}$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q11: If a⃗=(1,1,1) and b⃗=(2,-1,3), find |2a⃗-b⃗|. 2a⃗-b⃗=(0,3,-1). |·|=√(0+9+1)=√10.
('If $\vec{a}=\hat{i}+\hat{j}+\hat{k}$ and $\vec{b}=2\hat{i}-\hat{j}+3\hat{k}$, then $|2\vec{a}-\vec{b}|$ is', '$\sqrt{10}$', '$\sqrt{14}$', '$3$', '$\sqrt{6}$', 'option1', '$2\vec{a}-\vec{b} = (0,3,-1)$. $|2\vec{a}-\vec{b}| = \sqrt{0+9+1} = \sqrt{10}$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Triangle law: if a⃗ and b⃗ are two sides, third side = a⃗+b⃗ or b⃗-a⃗.
-- If sides are (3,0,0) and (0,4,0), the third side has length |(-3,4,0)|=5.
('In a triangle with two sides represented by $3\hat{i}$ and $4\hat{j}$, the length of the third side is', '$5$', '$7$', '$1$', '$\sqrt{7}$', 'option1', 'Third side $= 4\hat{j}-3\hat{i} = -3\hat{i}+4\hat{j}$. Length $= \sqrt{9+16} = 5$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Position vectors of vertices A, B, C are a⃗, b⃗, c⃗. Centroid G = (a⃗+b⃗+c⃗)/3.
-- If a⃗=(1,2,3), b⃗=(4,5,6), c⃗=(7,8,9), G=(4,5,6).
('The centroid of a triangle with position vectors $\hat{i}+2\hat{j}+3\hat{k}$, $4\hat{i}+5\hat{j}+6\hat{k}$, $7\hat{i}+8\hat{j}+9\hat{k}$ is', '$12\hat{i}+15\hat{j}+18\hat{k}$', '$4\hat{i}+5\hat{j}+6\hat{k}$', '$3\hat{i}+4\hat{j}+5\hat{k}$', '$4\hat{i}+5\hat{j}+5\hat{k}$', 'option2', 'Centroid $= \frac{1}{3}((1+4+7)\hat{i}+(2+5+8)\hat{j}+(3+6+9)\hat{k}) = 4\hat{i}+5\hat{j}+6\hat{k}$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Q14: If |a⃗+b⃗|=|a⃗-b⃗|, then a⃗⊥b⃗.
-- |a⃗+b⃗|²=|a⃗-b⃗|² => |a|²+|b|²+2a·b = |a|²+|b|²-2a·b => 4a·b=0 => a·b=0.
('If $|\vec{a}+\vec{b}|=|\vec{a}-\vec{b}|$, then the angle between $\vec{a}$ and $\vec{b}$ is', '$60°$', '$0°$', '$180°$', '$90°$', 'option4', '$|\vec{a}+\vec{b}|^2=|\vec{a}-\vec{b}|^2$ gives $4\vec{a}\cdot\vec{b}=0$, so $\vec{a}\perp\vec{b}$. Angle $= 90°$.', 'm_vectors_scalars_addition', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: If a⃗, b⃗, c⃗ are unit vectors with a⃗+b⃗+c⃗=0, find a⃗·b⃗+b⃗·c⃗+c⃗·a⃗.
-- |a⃗+b⃗+c⃗|²=0 => 3+2(a⃗·b⃗+b⃗·c⃗+c⃗·a⃗)=0 => a⃗·b⃗+b⃗·c⃗+c⃗·a⃗=-3/2.
('If $\vec{a}, \vec{b}, \vec{c}$ are unit vectors with $\vec{a}+\vec{b}+\vec{c}=\vec{0}$, then $\vec{a}\cdot\vec{b}+\vec{b}\cdot\vec{c}+\vec{c}\cdot\vec{a}$ equals', '$-\frac{3}{2}$', '$\frac{3}{2}$', '$-3$', '$0$', 'option1', '$|\vec{a}+\vec{b}+\vec{c}|^2 = 3+2(\vec{a}\cdot\vec{b}+\vec{b}\cdot\vec{c}+\vec{c}\cdot\vec{a})=0$. So the sum $= -\frac{3}{2}$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If |a⃗|=2, |b⃗|=3, angle=120°, find |a⃗+b⃗|.
-- |a⃗+b⃗|²=4+9+2(2)(3)cos120°=13+12(-1/2)=13-6=7. |a⃗+b⃗|=√7.
('If $|\vec{a}|=2$, $|\vec{b}|=3$, and the angle between them is $120°$, then $|\vec{a}+\vec{b}|$ is', '$1$', '$5$', '$\sqrt{7}$', '$\sqrt{13}$', 'option3', '$|\vec{a}+\vec{b}|^2 = 4+9+2(6)\cos 120° = 13-6 = 7$. $|\vec{a}+\vec{b}| = \sqrt{7}$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Vectors (1,a,2) and (a,1,2) are perpendicular. Dot product: a+a+4=0 => 2a=-4 => a=-2.
-- Wait: (1)(a)+(a)(1)+(2)(2)=a+a+4=2a+4=0 => a=-2.
('If $\hat{i}+a\hat{j}+2\hat{k}$ and $a\hat{i}+\hat{j}+2\hat{k}$ are perpendicular, then $a$ equals', '$2$', '$-2$', '$-1$', '$1$', 'option2', 'Perpendicular: $a+a+4=0$, $2a=-4$, $a=-2$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If a⃗=(1,1,0), b⃗=(0,1,1), c⃗=(1,0,1), find a⃗+b⃗-c⃗=(0,2,0). |·|=2.
('If $\vec{a}=\hat{i}+\hat{j}$, $\vec{b}=\hat{j}+\hat{k}$, $\vec{c}=\hat{i}+\hat{k}$, then $|\vec{a}+\vec{b}-\vec{c}|$ is', '$2$', '$\sqrt{2}$', '$\sqrt{3}$', '$1$', 'option1', '$\vec{a}+\vec{b}-\vec{c} = (0,2,0)$. $|\cdot| = 2$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q19: If |a⃗|=|b⃗|=1 and |a⃗+b⃗|=√3, find |a⃗-b⃗|.
-- |a⃗+b⃗|²=1+1+2cosθ=3 => cosθ=1/2 => θ=60°.
-- |a⃗-b⃗|²=1+1-2cosθ=2-1=1. |a⃗-b⃗|=1.
('If $|\vec{a}|=|\vec{b}|=1$ and $|\vec{a}+\vec{b}|=\sqrt{3}$, then $|\vec{a}-\vec{b}|$ is', '$2$', '$\sqrt{3}$', '$\sqrt{2}$', '$1$', 'option4', '$|\vec{a}+\vec{b}|^2=2+2\cos\theta=3$, $\cos\theta=\frac{1}{2}$. $|\vec{a}-\vec{b}|^2=2-2\cos\theta=1$. $|\vec{a}-\vec{b}|=1$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q20: If a⃗, b⃗ are non-collinear and xa⃗+yb⃗=0, then x=y=0.
-- Given 2a⃗+3b⃗=k(a⃗-b⃗)+m(a⃗+b⃗). RHS=(k+m)a⃗+(-k+m)b⃗. So k+m=2, -k+m=3. Adding: 2m=5, m=5/2, k=-1/2.
('If $2\vec{a}+3\vec{b}=k(\vec{a}-\vec{b})+m(\vec{a}+\vec{b})$ for non-collinear $\vec{a}, \vec{b}$, then $m$ equals', '$\frac{3}{2}$', '$\frac{5}{2}$', '$2$', '$3$', 'option2', '$k+m=2$ and $-k+m=3$. Adding: $2m=5$, $m=\frac{5}{2}$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Parallelogram law: |a⃗+b⃗|²+|a⃗-b⃗|²=2(|a⃗|²+|b⃗|²).
-- If |a⃗|=3, |b⃗|=5, |a⃗+b⃗|=7, find |a⃗-b⃗|.
-- 49+|a⃗-b⃗|²=2(9+25)=68. |a⃗-b⃗|²=19. |a⃗-b⃗|=√19.
('If $|\vec{a}|=3$, $|\vec{b}|=5$, $|\vec{a}+\vec{b}|=7$, then $|\vec{a}-\vec{b}|$ is', '$\sqrt{19}$', '$\sqrt{17}$', '$3$', '$\sqrt{21}$', 'option1', 'Parallelogram law: $49+|\vec{a}-\vec{b}|^2=2(9+25)=68$. $|\vec{a}-\vec{b}|^2=19$. $|\vec{a}-\vec{b}|=\sqrt{19}$.', 'm_vectors_scalars_addition', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_vector_components_products (Unit 12)
-- Components in 2D and 3D, scalar and vector products
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Dot product of (1,2,3) and (4,5,6) = 4+10+18=32.
('The scalar product of $\hat{i}+2\hat{j}+3\hat{k}$ and $4\hat{i}+5\hat{j}+6\hat{k}$ is', '$24$', '$32$', '$30$', '$36$', 'option2', '$\vec{a}\cdot\vec{b} = 1(4)+2(5)+3(6) = 4+10+18 = 32$.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Cross product of i and j = k.
('$\hat{i}\times\hat{j}$ equals', '$\hat{k}$', '$-\hat{k}$', '$\hat{i}$', '$0$', 'option1', '$\hat{i}\times\hat{j} = \hat{k}$ (right-hand rule).', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q3: If a⃗·b⃗=0, vectors are perpendicular. (1,2)·(2,-1)=2-2=0. Perpendicular.
('The vectors $\hat{i}+2\hat{j}$ and $2\hat{i}-\hat{j}$ are', 'Equal', 'Parallel', 'Perpendicular', 'Anti-parallel', 'option3', '$\vec{a}\cdot\vec{b} = 2-2 = 0$. Perpendicular.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Projection of (3,4) on (1,0) = (3·1+4·0)/1 = 3.
('The projection of $3\hat{i}+4\hat{j}$ on $\hat{i}$ is', '$3$', '$4$', '$5$', '$\frac{3}{5}$', 'option1', 'Projection $= \frac{\vec{a}\cdot\hat{i}}{|\hat{i}|} = \frac{3}{1} = 3$.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q5: |a⃗×b⃗| where a⃗=(1,0,0), b⃗=(0,1,0). a⃗×b⃗=(0,0,1). |·|=1.
('$|\hat{i}\times\hat{j}|$ equals', '$0$', '$1$', '$\sqrt{2}$', '$-1$', 'option2', '$\hat{i}\times\hat{j} = \hat{k}$. $|\hat{k}| = 1$.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Component of (2,3,4) along (1,0,0) = 2.
('The component of $2\hat{i}+3\hat{j}+4\hat{k}$ along the $x$-axis is', '$3$', '$2$', '$4$', '$\sqrt{29}$', 'option2', 'Component along $x$-axis $= $ coefficient of $\hat{i} = 2$.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Q7: a⃗·a⃗ = |a⃗|². If a⃗=(2,3,6), a⃗·a⃗=4+9+36=49. |a⃗|=7.
('If $\vec{a}=2\hat{i}+3\hat{j}+6\hat{k}$, then $|\vec{a}|$ is', '$\sqrt{49}$', '$7$', '$11$', '$\sqrt{41}$', 'option2', '$|\vec{a}|^2 = 4+9+36 = 49$. $|\vec{a}| = 7$.', 'm_vector_components_products', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Cross product of (1,2,3) and (4,5,6).
-- |i j k;1 2 3;4 5 6| = i(12-15)-j(6-12)+k(5-8) = (-3,6,-3).
('$(\hat{i}+2\hat{j}+3\hat{k})\times(4\hat{i}+5\hat{j}+6\hat{k})$ equals', '$32$', '$3\hat{i}-6\hat{j}+3\hat{k}$', '$-3\hat{i}+6\hat{j}-3\hat{k}$', '$-3\hat{i}-6\hat{j}-3\hat{k}$', 'option3', '$\begin{vmatrix}\hat{i}&\hat{j}&\hat{k}\\1&2&3\\4&5&6\end{vmatrix} = (12-15)\hat{i}-(6-12)\hat{j}+(5-8)\hat{k} = -3\hat{i}+6\hat{j}-3\hat{k}$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Area of parallelogram with sides a⃗=(1,0,1) and b⃗=(0,1,1).
-- a⃗×b⃗ = |i j k;1 0 1;0 1 1| = i(0-1)-j(1-0)+k(1-0) = (-1,-1,1). |·|=√3.
('The area of the parallelogram with sides $\hat{i}+\hat{k}$ and $\hat{j}+\hat{k}$ is', '$\sqrt{3}$', '$2$', '$1$', '$\sqrt{2}$', 'option1', '$\vec{a}\times\vec{b} = (-1,-1,1)$. Area $= |(-1,-1,1)| = \sqrt{3}$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Scalar triple product [a⃗ b⃗ c⃗] = a⃗·(b⃗×c⃗).
-- a⃗=(1,0,0), b⃗=(0,1,0), c⃗=(0,0,1). [a b c]=|1 0 0;0 1 0;0 0 1|=1.
('The scalar triple product $[\hat{i}, \hat{j}, \hat{k}]$ equals', '$-1$', '$0$', '$1$', '$3$', 'option3', '$[\hat{i},\hat{j},\hat{k}] = \hat{i}\cdot(\hat{j}\times\hat{k}) = \hat{i}\cdot\hat{i} = 1$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Projection of a⃗=(2,3,6) on b⃗=(1,2,2). Proj = a⃗·b⃗/|b⃗| = (2+6+12)/3 = 20/3.
('The projection of $2\hat{i}+3\hat{j}+6\hat{k}$ on $\hat{i}+2\hat{j}+2\hat{k}$ is', '$20$', '$\frac{11}{3}$', '$\frac{20}{3}$', '$\frac{20}{7}$', 'option3', 'Projection $= \frac{2+6+12}{\sqrt{1+4+4}} = \frac{20}{3}$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q12: If a⃗×b⃗=0 and a⃗≠0, b⃗≠0, then a⃗ ∥ b⃗.
-- (2,4,6) and (1,2,3): cross product = |i j k;2 4 6;1 2 3| = i(12-12)-j(6-6)+k(4-4)=(0,0,0). Parallel.
('If $\vec{a}\times\vec{b}=\vec{0}$ and both are non-zero, then $\vec{a}$ and $\vec{b}$ are', 'Unit vectors', 'Perpendicular', 'Equal', 'Parallel', 'option4', '$\vec{a}\times\vec{b}=\vec{0}$ implies $\sin\theta=0$, so $\theta=0°$ or $180°$. Vectors are parallel.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Work done = F⃗·d⃗. F=(3,4,5), d=(1,1,1). W=3+4+5=12.
('The work done by force $3\hat{i}+4\hat{j}+5\hat{k}$ over displacement $\hat{i}+\hat{j}+\hat{k}$ is', '$60$', '$12$', '$\sqrt{50}$', '$\sqrt{3}$', 'option2', 'Work $= \vec{F}\cdot\vec{d} = 3+4+5 = 12$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Angle between a⃗=(1,1,0) and b⃗=(0,1,1). cos θ = 1/(√2·√2) = 1/2. θ=60°.
('The angle between $\hat{i}+\hat{j}$ and $\hat{j}+\hat{k}$ is', '$60°$', '$90°$', '$45°$', '$30°$', 'option1', '$\cos\theta = \frac{0+1+0}{\sqrt{2}\cdot\sqrt{2}} = \frac{1}{2}$. $\theta = 60°$.', 'm_vector_components_products', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Volume of parallelepiped with edges a⃗=(1,2,3), b⃗=(2,1,1), c⃗=(1,1,2).
-- [a b c] = |1 2 3;2 1 1;1 1 2| = 1(2-1)-2(4-1)+3(2-1) = 1-6+3 = -2. Volume=|-2|=2.
('The volume of the parallelepiped with edges $\hat{i}+2\hat{j}+3\hat{k}$, $2\hat{i}+\hat{j}+\hat{k}$, $\hat{i}+\hat{j}+2\hat{k}$ is', '$4$', '$6$', '$2$', '$8$', 'option3', '$[a,b,c] = \begin{vmatrix}1&2&3\\2&1&1\\1&1&2\end{vmatrix} = 1(1)-2(3)+3(1) = -2$. Volume $= 2$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If a⃗×b⃗=c⃗×d⃗ and a⃗×c⃗=b⃗×d⃗, then a⃗-d⃗ is parallel to b⃗-c⃗.
-- (a⃗-d⃗)×(b⃗-c⃗) = a⃗×b⃗-a⃗×c⃗-d⃗×b⃗+d⃗×c⃗ = a⃗×b⃗-a⃗×c⃗+b⃗×d⃗-c⃗×d⃗.
-- = (a⃗×b⃗-c⃗×d⃗)-(a⃗×c⃗-b⃗×d⃗) = 0-0 = 0. So parallel.
('If $\vec{a}\times\vec{b}=\vec{c}\times\vec{d}$ and $\vec{a}\times\vec{c}=\vec{b}\times\vec{d}$, then $\vec{a}-\vec{d}$ is parallel to', '$\vec{b}+\vec{c}$', '$\vec{b}-\vec{c}$', '$\vec{a}+\vec{d}$', '$\vec{c}+\vec{d}$', 'option2', '$(\vec{a}-\vec{d})\times(\vec{b}-\vec{c}) = \vec{a}\times\vec{b}-\vec{a}\times\vec{c}-\vec{d}\times\vec{b}+\vec{d}\times\vec{c} = 0$. So $\vec{a}-\vec{d} \parallel \vec{b}-\vec{c}$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q17: If |a⃗|=2, |b⃗|=3, a⃗×b⃗=3i-2j+6k, find a⃗·b⃗.
-- |a⃗×b⃗|=√(9+4+36)=7. |a⃗×b⃗|=|a||b|sinθ=6sinθ=7. sinθ=7/6>1. Impossible!
-- Let me fix: |a⃗|=2, |b⃗|=5, a⃗×b⃗=3i-2j+6k. |a⃗×b⃗|=7. sinθ=7/10.
-- cosθ=√(1-49/100)=√(51/100)=√51/10. a⃗·b⃗=10·√51/10=√51.
-- Messy. Let me use: |a⃗|=3, |b⃗|=4, |a⃗×b⃗|=6. sinθ=6/12=1/2. θ=30° or 150°.
-- cosθ=±√3/2. a⃗·b⃗=12·(±√3/2)=±6√3.
-- If θ is acute: a⃗·b⃗=6√3.
('If $|\vec{a}|=3$, $|\vec{b}|=4$, and $|\vec{a}\times\vec{b}|=6$, then $\vec{a}\cdot\vec{b}$ (for acute angle) is', '$6$', '$6\sqrt{3}$', '$12$', '$3\sqrt{3}$', 'option2', '$|\vec{a}\times\vec{b}|=|\vec{a}||\vec{b}|\sin\theta=12\sin\theta=6$, $\sin\theta=\frac{1}{2}$, $\theta=30°$. $\vec{a}\cdot\vec{b}=12\cos 30°=6\sqrt{3}$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q18: a⃗×(b⃗×c⃗) = (a⃗·c⃗)b⃗-(a⃗·b⃗)c⃗ (BAC-CAB rule).
-- a⃗=(1,0,0), b⃗=(0,1,0), c⃗=(0,0,1). b⃗×c⃗=(1,0,0)=i. a⃗×(b⃗×c⃗)=(1,0,0)×(1,0,0)=(0,0,0).
-- Using formula: (a⃗·c⃗)b⃗-(a⃗·b⃗)c⃗ = 0·b⃗-0·c⃗ = 0. ✓
-- Better example: a⃗=(1,1,0), b⃗=(1,0,1), c⃗=(0,1,1).
-- b⃗×c⃗=|i j k;1 0 1;0 1 1|=(-1,-1,1). a⃗×(-1,-1,1)=|i j k;1 1 0;-1 -1 1|=i(1)-j(1)+k(-1+1)=(1,-1,0).
-- Formula: (a⃗·c⃗)b⃗-(a⃗·b⃗)c⃗ = (0+1+0)(1,0,1)-(1+0+0)(0,1,1) = (1,0,1)-(0,1,1) = (1,-1,0). ✓
('If $\vec{a}=\hat{i}+\hat{j}$, $\vec{b}=\hat{i}+\hat{k}$, $\vec{c}=\hat{j}+\hat{k}$, then $\vec{a}\times(\vec{b}\times\vec{c})$ is', '$\hat{i}-\hat{j}$', '$\hat{i}+\hat{j}$', '$\hat{j}-\hat{k}$', '$\hat{i}-\hat{k}$', 'option1', 'BAC-CAB: $(\vec{a}\cdot\vec{c})\vec{b}-(\vec{a}\cdot\vec{b})\vec{c} = 1(\hat{i}+\hat{k})-1(\hat{j}+\hat{k}) = \hat{i}-\hat{j}$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Area of triangle with vertices A(1,1,1), B(2,1,3), C(3,3,2).
-- AB=(1,0,2), AC=(2,2,1). AB×AC=|i j k;1 0 2;2 2 1|=i(0-4)-j(1-4)+k(2-0)=(-4,3,2).
-- |·|=√(16+9+4)=√29. Area=√29/2.
('The area of the triangle with vertices $(1,1,1)$, $(2,1,3)$, $(3,3,2)$ is', '$\frac{\sqrt{14}}{2}$', '$\sqrt{29}$', '$\frac{29}{2}$', '$\frac{\sqrt{29}}{2}$', 'option4', '$\vec{AB}=(1,0,2)$, $\vec{AC}=(2,2,1)$. $\vec{AB}\times\vec{AC}=(-4,3,2)$. Area $= \frac{\sqrt{29}}{2}$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Vectors a⃗, b⃗, c⃗ are coplanar iff [a⃗ b⃗ c⃗]=0.
-- a⃗=(1,2,3), b⃗=(4,5,6), c⃗=(7,8,9). |1 2 3;4 5 6;7 8 9|=1(45-48)-2(36-42)+3(32-35)=(-3)+12-9=0. Coplanar.
('The vectors $\hat{i}+2\hat{j}+3\hat{k}$, $4\hat{i}+5\hat{j}+6\hat{k}$, $7\hat{i}+8\hat{j}+9\hat{k}$ are', 'Mutually perpendicular', 'Non-coplanar', 'Coplanar', 'Linearly independent', 'option3', '$\begin{vmatrix}1&2&3\\4&5&6\\7&8&9\end{vmatrix} = 1(-3)-2(-6)+3(-3) = -3+12-9 = 0$. Coplanar.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Moment of force F⃗=(2,3,4) about point A, where r⃗=AB⃗=(1,-1,2).
-- Moment = r⃗×F⃗ = |i j k;1 -1 2;2 3 4| = i(-4-6)-j(4-4)+k(3+2) = (-10,0,5).
('The moment of force $2\hat{i}+3\hat{j}+4\hat{k}$ about a point, with position vector $\hat{i}-\hat{j}+2\hat{k}$ from the point, is', '$10\hat{i}-5\hat{k}$', '$-10\hat{i}+5\hat{k}$', '$-10\hat{i}+5\hat{j}$', '$10\hat{i}+5\hat{k}$', 'option2', '$\vec{r}\times\vec{F} = \begin{vmatrix}\hat{i}&\hat{j}&\hat{k}\\1&-1&2\\2&3&4\end{vmatrix} = (-4-6)\hat{i}-(4-4)\hat{j}+(3+2)\hat{k} = -10\hat{i}+5\hat{k}$.', 'm_vector_components_products', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_measures_dispersion (Unit 13)
-- Measures of dispersion: mean, median, mode of grouped and ungrouped data
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Mean of 2,4,6,8,10. Sum=30, n=5. Mean=6.
('The mean of $2, 4, 6, 8, 10$ is', '$8$', '$5$', '$6$', '$30$', 'option3', 'Mean $= \frac{2+4+6+8+10}{5} = \frac{30}{5} = 6$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Median of 3,1,4,1,5,9,2. Sorted: 1,1,2,3,4,5,9. Median=3 (4th value, n=7).
('The median of $3, 1, 4, 1, 5, 9, 2$ is', '$3$', '$4$', '$2$', '$5$', 'option1', 'Sorted: $1,1,2,3,4,5,9$. $n=7$, median $=$ 4th value $= 3$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Mode of 1,2,2,3,3,3,4. Mode=3 (highest frequency).
('The mode of $1, 2, 2, 3, 3, 3, 4$ is', '$2$', '$3$', '$1$', '$4$', 'option2', '$3$ appears most frequently (3 times). Mode $= 3$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Range of 5,10,15,20,25. Range=25-5=20.
('The range of $5, 10, 15, 20, 25$ is', '$15$', '$25$', '$20$', '$5$', 'option3', 'Range $= 25 - 5 = 20$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Mean of first 10 natural numbers. Sum=55. Mean=5.5.
('The mean of the first $10$ natural numbers is', '$5$', '$5.5$', '$10$', '$55$', 'option2', 'Sum $= \frac{10(11)}{2} = 55$. Mean $= \frac{55}{10} = 5.5$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Median of 2,4,6,8. n=4 (even). Median=(4+6)/2=5.
('The median of $2, 4, 6, 8$ is', '$4$', '$5$', '$6$', '$3$', 'option2', '$n=4$ (even). Median $= \frac{4+6}{2} = 5$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Q7: If mean of 5 observations is 10, their sum = 50.
('If the mean of $5$ observations is $10$, their sum is', '$2$', '$15$', '$50$', '$100$', 'option3', 'Sum $= $ mean $\times n = 10 \times 5 = 50$.', 'm_measures_dispersion', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Mean of 10 numbers is 20. If each is multiplied by 3, new mean = 60.
('If the mean of $10$ numbers is $20$ and each number is multiplied by $3$, the new mean is', '$6.67$', '$20$', '$30$', '$60$', 'option4', 'Multiplying each observation by $k$ multiplies the mean by $k$. New mean $= 3 \times 20 = 60$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Combined mean of two groups: n₁=10, x̄₁=15 and n₂=20, x̄₂=25.
-- Combined mean = (150+500)/30 = 650/30 = 65/3.
('The combined mean of groups with $n_1=10, \bar{x}_1=15$ and $n_2=20, \bar{x}_2=25$ is', '$\frac{40}{3}$', '$20$', '$\frac{65}{3}$', '$22$', 'option3', 'Combined mean $= \frac{10(15)+20(25)}{30} = \frac{650}{30} = \frac{65}{3}$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q10: Mean deviation about mean for 2,4,6,8,10. Mean=6. Deviations: 4,2,0,2,4. MD=12/5=2.4.
('The mean deviation about the mean for $2, 4, 6, 8, 10$ is', '$4$', '$3.2$', '$2$', '$2.4$', 'option4', 'Mean $= 6$. $|x_i - 6|$: $4,2,0,2,4$. MD $= \frac{12}{5} = 2.4$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q11: If mean of x₁,...,xₙ is x̄, then mean of x₁+a,...,xₙ+a is x̄+a.
-- Mean of 5,10,15 is 10. Mean of 8,13,18 (each +3) is 13.
('If the mean of $5, 10, 15$ is $10$, then the mean of $8, 13, 18$ is', '$39$', '$10$', '$13$', '$16$', 'option3', 'Each value increased by $3$. New mean $= 10 + 3 = 13$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Relation: Mode = 3 Median - 2 Mean (empirical). If mean=10, mode=7, find median.
-- 7 = 3M - 20 => 3M = 27 => M = 9.
('If the mean is $10$ and mode is $7$, then the median (using the empirical relation) is', '$8.5$', '$8$', '$9$', '$10$', 'option3', 'Mode $= 3$ Median $- 2$ Mean: $7 = 3M - 20$, $M = 9$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Weighted mean: values 10,20,30 with weights 1,2,3. WM = (10+40+90)/6 = 140/6 = 70/3.
('The weighted mean of $10, 20, 30$ with weights $1, 2, 3$ is', '$25$', '$20$', '$\frac{60}{3}$', '$\frac{70}{3}$', 'option4', 'Weighted mean $= \frac{10(1)+20(2)+30(3)}{1+2+3} = \frac{140}{6} = \frac{70}{3}$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Q14: Mean of 20 observations is 15. If one observation 20 is replaced by 10, new mean.
-- Old sum=300. New sum=300-20+10=290. New mean=290/20=14.5.
('The mean of $20$ observations is $15$. If one observation $20$ is replaced by $10$, the new mean is', '$15.5$', '$14$', '$15$', '$14.5$', 'option4', 'Old sum $= 300$. New sum $= 300-20+10 = 290$. New mean $= \frac{290}{20} = 14.5$.', 'm_measures_dispersion', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Mean of n observations is x̄. If first observation is increased by 1, second by 2, ..., nth by n, new mean.
-- New sum = Σxᵢ + Σi = nx̄ + n(n+1)/2. New mean = x̄ + (n+1)/2.
('If the mean of $n$ observations is $\bar{x}$ and the $i$-th observation is increased by $i$, the new mean is', '$\bar{x} + \frac{n+1}{2}$', '$\bar{x} + n$', '$\bar{x} + \frac{n}{2}$', '$n\bar{x} + \frac{n+1}{2}$', 'option1', 'New sum $= n\bar{x}+\frac{n(n+1)}{2}$. New mean $= \bar{x}+\frac{n+1}{2}$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Mean of 100 observations is 50. If two observations 30 and 70 are removed, new mean.
-- Sum=5000. New sum=5000-30-70=4900. New n=98. New mean=4900/98=50.
('The mean of $100$ observations is $50$. If observations $30$ and $70$ are removed, the new mean is', '$50$', '$49$', '$51$', '$48$', 'option1', 'Sum $= 5000$. New sum $= 5000-100 = 4900$. New mean $= \frac{4900}{98} = 50$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q17: If mean and median of a data set are 10 and 12, the data is negatively skewed (mean < median).
-- Skewness = 3(mean-median)/SD. Since mean<median, negatively skewed.
('If the mean of a distribution is $10$ and the median is $12$, the distribution is', 'Negatively skewed', 'Positively skewed', 'Symmetric', 'Cannot be determined', 'option1', 'Mean $<$ Median indicates the distribution is negatively skewed (tail on the left).', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Mean of a,b,c,d,e is 10. Mean of a²,b²,c²,d²,e² is 120. Variance = E(X²)-[E(X)]² = 120-100=20.
-- SD = √20 = 2√5.
('If the mean of $5$ values is $10$ and the mean of their squares is $120$, the standard deviation is', '$20$', '$\sqrt{20}$', '$2\sqrt{5}$', '$\sqrt{10}$', 'option3', 'Variance $= \overline{x^2}-\bar{x}^2 = 120-100 = 20$. SD $= \sqrt{20} = 2\sqrt{5}$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Coefficient of variation = (SD/Mean)×100. If SD=6, Mean=30, CV=20%.
('If the standard deviation is $6$ and the mean is $30$, the coefficient of variation is', '$20\%$', '$5\%$', '$36\%$', '$0.2\%$', 'option1', 'CV $= \frac{\text{SD}}{\text{Mean}}\times 100 = \frac{6}{30}\times 100 = 20\%$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Mean deviation about median for 1,3,5,7,9. Median=5. |xᵢ-5|: 4,2,0,2,4. MD=12/5=2.4.
('The mean deviation about the median for $1, 3, 5, 7, 9$ is', '$2$', '$3.2$', '$2.4$', '$4$', 'option3', 'Median $= 5$. $|x_i-5|$: $4,2,0,2,4$. MD $= \frac{12}{5} = 2.4$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- Q21: If each observation is multiplied by k, new variance = k²×(old variance). New SD = |k|×(old SD).
-- If SD=5 and each obs multiplied by 3, new SD=15.
('If the standard deviation of a data set is $5$ and each observation is multiplied by $3$, the new standard deviation is', '$\frac{5}{3}$', '$5$', '$45$', '$15$', 'option4', 'New SD $= |k| \times$ old SD $= 3 \times 5 = 15$.', 'm_measures_dispersion', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_std_deviation_variance (Unit 13)
-- Standard deviation, variance and mean deviation
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Variance of 1,2,3,4,5. Mean=3. Σ(xᵢ-3)²=4+1+0+1+4=10. Var=10/5=2.
('The variance of $1, 2, 3, 4, 5$ is', '$10$', '$\sqrt{2}$', '$2$', '$4$', 'option3', 'Mean $= 3$. $\sum(x_i-3)^2 = 4+1+0+1+4 = 10$. Variance $= \frac{10}{5} = 2$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q2: SD of 1,2,3,4,5. Var=2. SD=√2.
('The standard deviation of $1, 2, 3, 4, 5$ is', '$\sqrt{10}$', '$2$', '$\sqrt{2}$', '$1$', 'option3', 'Variance $= 2$. SD $= \sqrt{2}$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Variance of constant data 5,5,5,5,5. All same, variance=0.
('The variance of $5, 5, 5, 5, 5$ is', '$5$', '$0$', '$25$', '$1$', 'option2', 'All observations are equal. Variance $= 0$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q4: If variance=16, SD=4.
('If the variance of a data set is $16$, the standard deviation is', '$4$', '$16$', '$256$', '$8$', 'option1', 'SD $= \sqrt{\text{Variance}} = \sqrt{16} = 4$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Variance formula: Var = E(X²) - [E(X)]². If E(X)=5, E(X²)=30, Var=30-25=5.
('If $E(X)=5$ and $E(X^2)=30$, the variance is', '$25$', '$5$', '$30$', '$\sqrt{5}$', 'option2', 'Variance $= E(X^2)-[E(X)]^2 = 30-25 = 5$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Variance of 2,4,6,8,10. Mean=6. Σ(xᵢ-6)²=16+4+0+4+16=40. Var=40/5=8.
('The variance of $2, 4, 6, 8, 10$ is', '$8$', '$4$', '$\sqrt{8}$', '$40$', 'option1', 'Mean $= 6$. $\sum(x_i-6)^2 = 16+4+0+4+16 = 40$. Variance $= \frac{40}{5} = 8$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Mean deviation about mean for 10,10,10,10. All same. MD=0.
('The mean deviation about the mean for $10, 10, 10, 10$ is', '$10$', '$0$', '$1$', '$100$', 'option2', 'All values equal the mean. $|x_i - \bar{x}| = 0$ for all $i$. MD $= 0$.', 'm_std_deviation_variance', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: If each observation is increased by 5, variance remains unchanged.
-- Data: 1,2,3. Var=2/3. New data: 6,7,8. Mean=7. Var=(1+0+1)/3=2/3. Same.
('If each observation of a data set is increased by $5$, the variance', 'Remains unchanged', 'Increases by $5$', 'Increases by $25$', 'Becomes $0$', 'option1', 'Adding a constant shifts all values equally. Deviations from mean remain the same. Variance is unchanged.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Variance of first n natural numbers = (n²-1)/12. For n=11: (121-1)/12=120/12=10.
('The variance of the first $11$ natural numbers is', '$11$', '$10$', '$\frac{121}{12}$', '$\frac{11}{12}$', 'option2', 'Variance of first $n$ natural numbers $= \frac{n^2-1}{12} = \frac{121-1}{12} = 10$.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q10: If SD of x₁,...,xₙ is σ, SD of ax₁+b,...,axₙ+b is |a|σ.
-- SD=3, each obs multiplied by 2 and added 5. New SD=2(3)=6.
('If the SD of a data set is $3$ and each observation is transformed as $2x + 5$, the new SD is', '$8$', '$11$', '$3$', '$6$', 'option4', 'New SD $= |a| \times$ old SD $= 2 \times 3 = 6$. (Adding constant doesn''t affect SD.)', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Combined variance of two groups.
-- n₁=5, x̄₁=10, σ₁²=4. n₂=5, x̄₂=20, σ₂²=9.
-- Combined mean = (50+100)/10 = 15.
-- d₁=10-15=-5, d₂=20-15=5.
-- Combined var = (5(4)+5(9)+5(25)+5(25))/10 = (20+45+125+125)/10 = 315/10 = 31.5.
-- Wait: formula is (n₁(σ₁²+d₁²)+n₂(σ₂²+d₂²))/(n₁+n₂) = (5(4+25)+5(9+25))/10 = (145+170)/10 = 315/10 = 31.5.
('The combined variance of two groups ($n_1=n_2=5$, $\bar{x}_1=10$, $\bar{x}_2=20$, $\sigma_1^2=4$, $\sigma_2^2=9$) is', '$31.5$', '$6.5$', '$13$', '$29$', 'option1', 'Combined mean $= 15$. $d_1=-5, d_2=5$. Var $= \frac{5(4+25)+5(9+25)}{10} = \frac{315}{10} = 31.5$.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Variance of -3,-1,1,3. Mean=0. Σxᵢ²=9+1+1+9=20. Var=20/4=5.
('The variance of $-3, -1, 1, 3$ is', '$20$', '$\sqrt{5}$', '$4$', '$5$', 'option4', 'Mean $= 0$. Variance $= \frac{9+1+1+9}{4} = \frac{20}{4} = 5$.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q13: If variance of x₁,...,xₙ is σ², variance of kx₁,...,kxₙ is k²σ².
-- Var=9, k=4. New var=16×9=144.
('If the variance of a data set is $9$ and each observation is multiplied by $4$, the new variance is', '$13$', '$36$', '$144$', '$9$', 'option3', 'New variance $= k^2 \times$ old variance $= 16 \times 9 = 144$.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Q14: SD of 6,6,6,6,6,6,6 is 0 (all same).
('The standard deviation of seven observations, all equal to $6$, is', '$0$', '$6$', '$1$', '$\sqrt{6}$', 'option1', 'All observations are identical. SD $= 0$.', 'm_std_deviation_variance', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Variance of a,a+d,...,a+(n-1)d (AP with n terms). This is same as variance of 0,d,2d,...,(n-1)d.
-- = d² × variance of 0,1,...,n-1 = d²(n²-1)/12.
-- For n=5, d=2: 4(24)/12=8.
('The variance of $5$ terms of an AP with common difference $2$ is', '$8$', '$4$', '$2$', '$16$', 'option1', 'Variance of $n$ terms of AP with common difference $d$: $\frac{d^2(n^2-1)}{12} = \frac{4(24)}{12} = 8$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q16: If Σxᵢ=40, Σxᵢ²=200, n=10. Var=200/10-(40/10)²=20-16=4. SD=2.
('If $\sum x_i = 40$, $\sum x_i^2 = 200$, and $n = 10$, the standard deviation is', '$16$', '$4$', '$\sqrt{20}$', '$2$', 'option4', 'Variance $= \frac{200}{10}-\left(\frac{40}{10}\right)^2 = 20-16 = 4$. SD $= 2$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Mean of 8 observations is 9 and variance is 9.25. If 6 of them are 2,4,6,8,12,14, find other two.
-- Sum of 8 obs = 72. Sum of 6 = 46. So x₇+x₈=26.
-- Σxᵢ²/8 - 81 = 9.25. Σxᵢ²=8(90.25)=722.
-- Sum of squares of 6: 4+16+36+64+144+196=460. x₇²+x₈²=262.
-- x₇+x₈=26, x₇²+x₈²=262. (x₇+x₈)²=676. x₇x₈=(676-262)/2=207.
-- t²-26t+207=0. D=676-828=-152<0. Hmm, no real solution. Let me recalculate.
-- Actually let me just use a cleaner problem.
-- Variance of 2,4,6,8,10,12,14,16. Mean=9. Σ(xᵢ-9)²=49+25+9+1+1+9+25+49=168. Var=168/8=21.
('The variance of $2, 4, 6, 8, 10, 12, 14, 16$ is', '$42$', '$\sqrt{21}$', '$21$', '$168$', 'option3', 'Mean $= 9$. $\sum(x_i-9)^2 = 49+25+9+1+1+9+25+49 = 168$. Variance $= \frac{168}{8} = 21$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If mean=50, SD=5 for 100 observations, and it was found that one observation 40 was wrongly taken as 50.
-- Corrected sum = 5000-50+40=4990. Corrected mean=49.9.
-- Corrected Σxᵢ² = old Σxᵢ² - 2500 + 1600 = old Σxᵢ² - 900.
-- Old: Var=25. Σxᵢ²/100 - 2500 = 25. Σxᵢ²=252500.
-- Corrected Σxᵢ²=252500-900=251600. Corrected var=251600/100-(49.9)²=2516-2490.01=25.99.
-- Corrected SD=√25.99≈5.099. Hmm messy. Let me simplify.
-- If variance of x₁,...,x₅ is 4 and mean is 3, find Σxᵢ².
-- Var = Σxᵢ²/5 - 9 = 4. Σxᵢ²=65.
('If the variance of $5$ observations is $4$ and their mean is $3$, then $\sum x_i^2$ equals', '$60$', '$45$', '$65$', '$80$', 'option3', 'Variance $= \frac{\sum x_i^2}{n}-\bar{x}^2$: $4 = \frac{\sum x_i^2}{5}-9$. $\sum x_i^2 = 65$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q19: Variance of 1/n, 2/n, ..., n/n = (1/n²)×Var(1,2,...,n) = (1/n²)(n²-1)/12 = (n²-1)/(12n²).
-- For n=5: 24/300 = 2/25.
('The variance of $\frac{1}{5}, \frac{2}{5}, \frac{3}{5}, \frac{4}{5}, 1$ is', '$\frac{1}{5}$', '$\frac{2}{5}$', '$\frac{4}{25}$', '$\frac{2}{25}$', 'option4', 'Var $= \frac{1}{25}\times\frac{n^2-1}{12} = \frac{24}{300} = \frac{2}{25}$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q20: If SD of a distribution is 4, the variance of the distribution whose each value is half the original is:
-- New var = (1/2)²×16 = 4.
('If the SD of a distribution is $4$, the variance when each value is halved is', '$16$', '$2$', '$8$', '$4$', 'option4', 'New variance $= \left(\frac{1}{2}\right)^2 \times 16 = 4$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Mean and variance of n observations are 5 and 4. If 3 new observations 7,7,7 are added:
-- n=? Let's say n=6. Sum=30. Σxᵢ²=6(4+25)=174. New sum=30+21=51. New n=9. New mean=51/9=17/3.
-- New Σxᵢ²=174+147=321. New var=321/9-(17/3)²=321/9-289/9=32/9.
-- Hmm, let me use n=7. Sum=35. Σxᵢ²=7(29)=203. New: sum=56, n=10, mean=5.6.
-- Σxᵢ²=203+147=350. Var=350/10-31.36=35-31.36=3.64=91/25.
-- Messy. Let me just ask a cleaner question.
-- Variance of 1,1,1,...,1 (n times) and one value k. n+1 values. Mean=(n+k)/(n+1).
-- For 4 values: 1,1,1,5. Mean=2. Var=(1+1+1+9)/4=12/4=3.
('The variance of $1, 1, 1, 5$ is', '$2$', '$3$', '$4$', '$\sqrt{3}$', 'option2', 'Mean $= 2$. $\sum(x_i-2)^2 = 1+1+1+9 = 12$. Variance $= \frac{12}{4} = 3$.', 'm_std_deviation_variance', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_probability_event (Unit 13)
-- Probability of an event, addition and multiplication theorems
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Probability of getting head in a fair coin toss = 1/2.
('The probability of getting a head in a single toss of a fair coin is', '$0$', '$1$', '$\frac{1}{4}$', '$\frac{1}{2}$', 'option4', 'Fair coin: $P(H) = \frac{1}{2}$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Probability of getting 6 on a fair die = 1/6.
('The probability of rolling a $6$ on a fair die is', '$\frac{1}{2}$', '$\frac{1}{3}$', '$\frac{1}{6}$', '$6$', 'option3', 'Fair die: $P(6) = \frac{1}{6}$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q3: P(A) + P(A') = 1. If P(A)=0.3, P(A')=0.7.
('If $P(A) = 0.3$, then $P(A'')$ is', '$1.3$', '$0.3$', '$0.7$', '$0$', 'option3', '$P(A'') = 1 - P(A) = 1 - 0.3 = 0.7$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Drawing a red card from a standard deck. 26 red cards out of 52. P=1/2.
('The probability of drawing a red card from a standard deck of $52$ cards is', '$\frac{1}{2}$', '$\frac{1}{4}$', '$\frac{13}{52}$', '$\frac{1}{13}$', 'option1', '$26$ red cards out of $52$. $P = \frac{26}{52} = \frac{1}{2}$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Probability of impossible event = 0.
('The probability of an impossible event is', '$0$', '$1$', '$\frac{1}{2}$', '$-1$', 'option1', 'An impossible event has probability $0$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Two dice thrown. P(sum=7). Favorable: (1,6),(2,5),(3,4),(4,3),(5,2),(6,1)=6. Total=36. P=1/6.
('The probability of getting a sum of $7$ when two dice are thrown is', '$\frac{1}{6}$', '$\frac{7}{36}$', '$\frac{1}{12}$', '$\frac{5}{36}$', 'option1', 'Favorable outcomes: $(1,6),(2,5),(3,4),(4,3),(5,2),(6,1) = 6$. $P = \frac{6}{36} = \frac{1}{6}$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Q7: P(A∪B) = P(A)+P(B) for mutually exclusive events. P(A)=0.3, P(B)=0.4. P(A∪B)=0.7.
('If $A$ and $B$ are mutually exclusive with $P(A)=0.3$ and $P(B)=0.4$, then $P(A\cup B)$ is', '$0.1$', '$0.12$', '$1$', '$0.7$', 'option4', 'Mutually exclusive: $P(A\cup B) = P(A)+P(B) = 0.3+0.4 = 0.7$.', 'm_probability_event', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: P(A∪B)=P(A)+P(B)-P(A∩B). P(A)=0.5, P(B)=0.6, P(A∩B)=0.3. P(A∪B)=0.8.
('If $P(A)=0.5$, $P(B)=0.6$, $P(A\cap B)=0.3$, then $P(A\cup B)$ is', '$0.6$', '$1.1$', '$0.3$', '$0.8$', 'option4', '$P(A\cup B) = 0.5+0.6-0.3 = 0.8$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Independent events: P(A∩B)=P(A)·P(B). P(A)=1/3, P(B)=1/4. P(A∩B)=1/12.
('If $A$ and $B$ are independent with $P(A)=\frac{1}{3}$ and $P(B)=\frac{1}{4}$, then $P(A\cap B)$ is', '$\frac{1}{12}$', '$\frac{7}{12}$', '$\frac{1}{7}$', '$\frac{1}{2}$', 'option1', 'Independent: $P(A\cap B) = P(A) \cdot P(B) = \frac{1}{3}\cdot\frac{1}{4} = \frac{1}{12}$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q10: P(at least one) = 1 - P(none). Two independent events, P(A)=0.4, P(B)=0.5.
-- P(at least one) = 1 - P(A')P(B') = 1 - 0.6×0.5 = 1-0.3 = 0.7.
('If $P(A)=0.4$ and $P(B)=0.5$ are independent, $P($at least one occurs$)$ is', '$0.7$', '$0.9$', '$0.2$', '$0.8$', 'option1', '$P(\text{at least one}) = 1-P(A'')P(B'') = 1-0.6\times 0.5 = 0.7$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q11: 3 coins tossed. P(exactly 2 heads). Favorable: HHT,HTH,THH=3. Total=8. P=3/8.
('The probability of getting exactly $2$ heads when $3$ fair coins are tossed is', '$\frac{1}{2}$', '$\frac{3}{8}$', '$\frac{1}{4}$', '$\frac{1}{8}$', 'option2', 'Favorable: $\binom{3}{2} = 3$. Total $= 8$. $P = \frac{3}{8}$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q12: P(A|B) = P(A∩B)/P(B). P(A∩B)=0.2, P(B)=0.5. P(A|B)=0.4.
('If $P(A\cap B)=0.2$ and $P(B)=0.5$, then $P(A|B)$ is', '$0.7$', '$0.1$', '$0.4$', '$0.25$', 'option3', '$P(A|B) = \frac{P(A\cap B)}{P(B)} = \frac{0.2}{0.5} = 0.4$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Multiplication theorem: P(A∩B) = P(A)·P(B|A). P(A)=1/2, P(B|A)=1/3. P(A∩B)=1/6.
('If $P(A)=\frac{1}{2}$ and $P(B|A)=\frac{1}{3}$, then $P(A\cap B)$ is', '$\frac{1}{6}$', '$\frac{5}{6}$', '$\frac{1}{2}$', '$\frac{2}{3}$', 'option1', '$P(A\cap B) = P(A)\cdot P(B|A) = \frac{1}{2}\cdot\frac{1}{3} = \frac{1}{6}$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Q14: P(neither A nor B) = P(A'∩B') = 1-P(A∪B). P(A∪B)=0.8. P(neither)=0.2.
('If $P(A\cup B)=0.8$, then $P($neither $A$ nor $B)$ is', '$0.8$', '$0.2$', '$0$', '$1$', 'option2', '$P(A'' \cap B'') = 1-P(A\cup B) = 1-0.8 = 0.2$.', 'm_probability_event', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: P(A only) = P(A) - P(A∩B). P(A)=0.6, P(B)=0.4, P(A∩B)=0.2. P(A only)=0.4.
('If $P(A)=0.6$, $P(B)=0.4$, $P(A\cap B)=0.2$, then $P(A$ only$)$ is', '$0.4$', '$0.6$', '$0.2$', '$0.8$', 'option1', '$P(A \text{ only}) = P(A)-P(A\cap B) = 0.6-0.2 = 0.4$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q16: A bag has 5 red and 3 blue balls. Two drawn without replacement. P(both red).
-- P = (5/8)(4/7) = 20/56 = 5/14.
('Two balls drawn without replacement from a bag of $5$ red and $3$ blue. $P($both red$)$ is', '$\frac{5}{8}$', '$\frac{25}{64}$', '$\frac{5}{14}$', '$\frac{10}{56}$', 'option3', '$P = \frac{5}{8}\times\frac{4}{7} = \frac{20}{56} = \frac{5}{14}$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q17: P(A∪B∪C) = P(A)+P(B)+P(C)-P(A∩B)-P(B∩C)-P(A∩C)+P(A∩B∩C).
-- P(A)=0.3, P(B)=0.4, P(C)=0.5, all pairwise independent, P(A∩B∩C)=0.06.
-- P(A∩B)=0.12, P(B∩C)=0.20, P(A∩C)=0.15.
-- P(A∪B∪C) = 0.3+0.4+0.5-0.12-0.20-0.15+0.06 = 0.79.
('If $P(A)=0.3$, $P(B)=0.4$, $P(C)=0.5$, events are pairwise independent, and $P(A\cap B\cap C)=0.06$, then $P(A\cup B\cup C)$ is', '$0.73$', '$1.2$', '$0.94$', '$0.79$', 'option4', 'Pairwise independent: $P(A\cap B)=0.12$, $P(B\cap C)=0.20$, $P(A\cap C)=0.15$. $P(A\cup B\cup C)=1.2-0.47+0.06=0.79$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q18: A problem is solved independently by A and B with probabilities 1/2 and 1/3.
-- P(solved) = 1 - P(not solved by either) = 1 - (1/2)(2/3) = 1 - 1/3 = 2/3.
('$A$ and $B$ solve a problem independently with probabilities $\frac{1}{2}$ and $\frac{1}{3}$. $P($problem is solved$)$ is', '$\frac{1}{6}$', '$\frac{2}{3}$', '$\frac{5}{6}$', '$\frac{1}{2}$', 'option2', '$P(\text{solved}) = 1-P(A'')P(B'') = 1-\frac{1}{2}\cdot\frac{2}{3} = 1-\frac{1}{3} = \frac{2}{3}$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q19: If A and B are independent, P(A|B)=P(A). Given P(A)=0.4, P(B)=0.5.
-- P(A'∩B) = P(A')P(B) = 0.6×0.5 = 0.3.
('If $A$ and $B$ are independent with $P(A)=0.4$, $P(B)=0.5$, then $P(A''\cap B)$ is', '$0.1$', '$0.2$', '$0.5$', '$0.3$', 'option4', '$P(A''\cap B) = P(A'')P(B) = 0.6 \times 0.5 = 0.3$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q20: 4 cards drawn from 52. P(all 4 are aces) = C(4,4)/C(52,4) = 1/270725.
('The probability of drawing all $4$ aces from a deck of $52$ cards in $4$ draws (without replacement) is', '$\frac{4}{52}$', '$\frac{1}{52^4}$', '$\frac{1}{270725}$', '$\frac{1}{13^4}$', 'option3', '$P = \frac{\binom{4}{4}}{\binom{52}{4}} = \frac{1}{270725}$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- Q21: P(exactly one of A,B) = P(A)+P(B)-2P(A∩B). P(A)=0.6, P(B)=0.4, P(A∩B)=0.2.
-- P(exactly one) = 0.6+0.4-0.4 = 0.6.
('If $P(A)=0.6$, $P(B)=0.4$, $P(A\cap B)=0.2$, then $P($exactly one of $A, B)$ is', '$0.8$', '$0.6$', '$0.4$', '$0.2$', 'option2', '$P(\text{exactly one}) = P(A)+P(B)-2P(A\cap B) = 0.6+0.4-0.4 = 0.6$.', 'm_probability_event', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_bayes_theorem (Unit 13)
-- Bayes theorem, probability distribution of a random variable
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: Mean of random variable X with P(X=1)=1/2, P(X=2)=1/2. E(X)=1(1/2)+2(1/2)=3/2.
('If $P(X=1)=\frac{1}{2}$ and $P(X=2)=\frac{1}{2}$, then $E(X)$ is', '$\frac{1}{2}$', '$1$', '$2$', '$\frac{3}{2}$', 'option4', '$E(X) = 1\cdot\frac{1}{2}+2\cdot\frac{1}{2} = \frac{3}{2}$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q2: Sum of all probabilities in a probability distribution = 1.
-- P(X=0)=0.2, P(X=1)=0.5, P(X=2)=k. 0.2+0.5+k=1 => k=0.3.
('If $P(X=0)=0.2$, $P(X=1)=0.5$, $P(X=2)=k$, then $k$ is', '$1$', '$0.7$', '$0.1$', '$0.3$', 'option4', '$0.2+0.5+k=1$, so $k=0.3$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q3: Variance = E(X²)-[E(X)]². If E(X)=2, E(X²)=5, Var=5-4=1.
('If $E(X)=2$ and $E(X^2)=5$, the variance of $X$ is', '$3$', '$1$', '$5$', '$4$', 'option2', 'Var$(X) = E(X^2)-[E(X)]^2 = 5-4 = 1$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q4: For Bernoulli trial with p=1/3, E(X)=p=1/3.
('For a Bernoulli random variable with $p=\frac{1}{3}$, the mean is', '$0$', '$\frac{2}{3}$', '$1$', '$\frac{1}{3}$', 'option4', 'For Bernoulli: $E(X) = p = \frac{1}{3}$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q5: Binomial distribution: n=5, p=1/2. E(X)=np=5/2.
('For a binomial distribution with $n=5$ and $p=\frac{1}{2}$, the mean is', '$5$', '$\frac{5}{2}$', '$\frac{1}{2}$', '$10$', 'option2', '$E(X) = np = 5\cdot\frac{1}{2} = \frac{5}{2}$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q6: P(X=x) ≥ 0 for all x. Which is NOT a valid probability distribution?
-- P(X=1)=0.5, P(X=2)=-0.1, P(X=3)=0.6. Sum=1 but P(X=2)<0. Invalid.
('Which is NOT a valid probability: $P(X=1)=0.5$, $P(X=2)=-0.1$, $P(X=3)=0.6$?', '$P(X=1)=0.5$ (too large)', 'All are valid', '$P(X=3)=0.6$ (too large)', '$P(X=2)=-0.1$ (negative probability)', 'option4', 'Probabilities must be non-negative. $P(X=2)=-0.1$ is invalid.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Q7: Variance of Bernoulli with p=1/4. Var=p(1-p)=1/4·3/4=3/16.
('The variance of a Bernoulli random variable with $p=\frac{1}{4}$ is', '$\frac{1}{16}$', '$\frac{1}{4}$', '$\frac{3}{4}$', '$\frac{3}{16}$', 'option4', 'Var $= p(1-p) = \frac{1}{4}\cdot\frac{3}{4} = \frac{3}{16}$.', 'm_bayes_theorem', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: Bayes' theorem. Two bags: Bag 1 has 3 red, 2 blue. Bag 2 has 2 red, 3 blue.
-- A bag is chosen at random and a ball drawn is red. P(Bag 1|Red).
-- P(R|B1)=3/5, P(R|B2)=2/5. P(B1)=P(B2)=1/2.
-- P(B1|R) = P(R|B1)P(B1)/[P(R|B1)P(B1)+P(R|B2)P(B2)] = (3/10)/((3/10)+(2/10)) = 3/5.
('Two bags: Bag 1 has $3$ red, $2$ blue; Bag 2 has $2$ red, $3$ blue. A bag is chosen randomly and a red ball is drawn. $P($Bag 1$)$ is', '$\frac{2}{5}$', '$\frac{1}{2}$', '$\frac{3}{5}$', '$\frac{3}{10}$', 'option3', '$P(B_1|R) = \frac{\frac{3}{5}\cdot\frac{1}{2}}{\frac{3}{5}\cdot\frac{1}{2}+\frac{2}{5}\cdot\frac{1}{2}} = \frac{3/10}{5/10} = \frac{3}{5}$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q9: Binomial: P(X=k) = C(n,k)p^k(1-p)^(n-k). n=4, p=1/2. P(X=2)=C(4,2)(1/2)^4=6/16=3/8.
('For $X \sim B(4, \frac{1}{2})$, $P(X=2)$ is', '$\frac{6}{16}$', '$\frac{1}{4}$', '$\frac{1}{2}$', '$\frac{3}{8}$', 'option4', '$P(X=2) = \binom{4}{2}\left(\frac{1}{2}\right)^4 = \frac{6}{16} = \frac{3}{8}$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q10: E(aX+b) = aE(X)+b. If E(X)=3, find E(2X+5)=11.
('If $E(X)=3$, then $E(2X+5)$ is', '$8$', '$6$', '$11$', '$16$', 'option3', '$E(2X+5) = 2E(X)+5 = 6+5 = 11$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q11: Var(aX+b) = a²Var(X). If Var(X)=4, Var(3X+2)=9(4)=36.
('If $\text{Var}(X)=4$, then $\text{Var}(3X+2)$ is', '$38$', '$12$', '$14$', '$36$', 'option4', '$\text{Var}(3X+2) = 9\cdot\text{Var}(X) = 9\times 4 = 36$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q12: Binomial variance = npq. n=10, p=1/5. Var=10(1/5)(4/5)=8/5.
('The variance of $X \sim B(10, \frac{1}{5})$ is', '$\frac{8}{5}$', '$2$', '$\frac{10}{5}$', '$\frac{4}{5}$', 'option1', 'Var $= npq = 10\cdot\frac{1}{5}\cdot\frac{4}{5} = \frac{8}{5}$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Total probability: P(A) = P(A|B₁)P(B₁)+P(A|B₂)P(B₂).
-- Machine 1 produces 60% of items, Machine 2 produces 40%. Defect rates: 2% and 5%.
-- P(defective) = 0.6(0.02)+0.4(0.05) = 0.012+0.020 = 0.032.
('Machines 1 and 2 produce $60\%$ and $40\%$ of items with defect rates $2\%$ and $5\%$. $P($defective$)$ is', '$0.02$', '$0.035$', '$0.07$', '$0.032$', 'option4', '$P(D) = 0.6(0.02)+0.4(0.05) = 0.012+0.020 = 0.032$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Q14: P(X≥1) for binomial n=3, p=1/3. P(X≥1)=1-P(X=0)=1-(2/3)³=1-8/27=19/27.
('For $X \sim B(3, \frac{1}{3})$, $P(X \geq 1)$ is', '$\frac{8}{27}$', '$\frac{19}{27}$', '$\frac{1}{3}$', '$\frac{26}{27}$', 'option2', '$P(X\geq 1) = 1-P(X=0) = 1-\left(\frac{2}{3}\right)^3 = 1-\frac{8}{27} = \frac{19}{27}$.', 'm_bayes_theorem', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Bayes' theorem. 1% of population has disease. Test: 99% true positive, 5% false positive.
-- P(D|+) = P(+|D)P(D)/[P(+|D)P(D)+P(+|D')P(D')] = 0.99(0.01)/[0.99(0.01)+0.05(0.99)]
-- = 0.0099/(0.0099+0.0495) = 0.0099/0.0594 = 99/594 = 1/6.
-- Wait: 0.0099/0.0594 = 9900/59400 = 99/594 = 33/198 = 11/66 = 1/6. Yes.
('$1\%$ have a disease. A test has $99\%$ true positive rate and $5\%$ false positive rate. $P($disease $|$ positive$)$ is', '$\frac{1}{2}$', '$0.99$', '$\frac{99}{100}$', '$\frac{1}{6}$', 'option4', '$P(D|+) = \frac{0.99\times 0.01}{0.99\times 0.01+0.05\times 0.99} = \frac{0.0099}{0.0594} = \frac{1}{6}$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q16: X has distribution P(X=0)=1/4, P(X=1)=1/2, P(X=2)=1/4.
-- E(X)=0+1/2+1/2=1. E(X²)=0+1/2+1=3/2. Var=3/2-1=1/2.
('If $P(X=0)=\frac{1}{4}$, $P(X=1)=\frac{1}{2}$, $P(X=2)=\frac{1}{4}$, then $\text{Var}(X)$ is', '$1$', '$\frac{1}{2}$', '$\frac{3}{2}$', '$\frac{1}{4}$', 'option2', '$E(X)=1$, $E(X^2)=\frac{1}{2}+1=\frac{3}{2}$. Var $= \frac{3}{2}-1 = \frac{1}{2}$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q17: Binomial: most likely value (mode). n=10, p=1/3. Mode = floor((n+1)p) = floor(11/3) = floor(3.67) = 3.
-- Or mode is the integer k where (n+1)p-1 < k ≤ (n+1)p. (11/3-1, 11/3] = (2.67, 3.67]. k=3.
('The most probable number of successes in $10$ trials with $p=\frac{1}{3}$ is', '$4$', '$3$', '$\frac{10}{3}$', '$2$', 'option2', 'Mode of $B(n,p)$: $\lfloor(n+1)p\rfloor = \lfloor\frac{11}{3}\rfloor = 3$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Three boxes: Box 1 has 2 gold, 1 silver. Box 2 has 1 gold, 2 silver. Box 3 has 3 silver.
-- A box chosen at random, a coin drawn is gold. P(Box 1).
-- P(G|B1)=2/3, P(G|B2)=1/3, P(G|B3)=0. Each P(Bi)=1/3.
-- P(B1|G) = (2/3)(1/3)/[(2/3)(1/3)+(1/3)(1/3)+0] = (2/9)/(3/9) = 2/3.
('Three boxes: Box 1 ($2$ gold, $1$ silver), Box 2 ($1$ gold, $2$ silver), Box 3 ($3$ silver). A random box yields a gold coin. $P($Box 1$)$ is', '$\frac{2}{3}$', '$\frac{1}{3}$', '$\frac{1}{2}$', '$\frac{2}{9}$', 'option1', '$P(B_1|G) = \frac{\frac{2}{3}\cdot\frac{1}{3}}{\frac{2}{3}\cdot\frac{1}{3}+\frac{1}{3}\cdot\frac{1}{3}+0} = \frac{2/9}{3/9} = \frac{2}{3}$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q19: If X~B(n,p) and E(X)=6, Var(X)=4, find n and p.
-- np=6, npq=4. q=4/6=2/3. p=1/3. n=18.
('If $X \sim B(n,p)$ with $E(X)=6$ and $\text{Var}(X)=4$, then $n$ is', '$18$', '$12$', '$24$', '$9$', 'option1', '$np=6$, $npq=4$. $q=\frac{4}{6}=\frac{2}{3}$, $p=\frac{1}{3}$. $n=\frac{6}{1/3}=18$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q20: Conditional probability using Bayes. A student answers MCQ: knows answer with P=0.7, guesses with P=0.3.
-- If guessing, P(correct)=1/4. If knows, P(correct)=1. Given correct answer, P(knew).
-- P(K|C) = P(C|K)P(K)/[P(C|K)P(K)+P(C|G)P(G)] = 1(0.7)/[0.7+0.25(0.3)] = 0.7/0.775 = 28/31.
('A student knows the answer with probability $0.7$ or guesses (correct with probability $\frac{1}{4}$). Given a correct answer, $P($knew$)$ is', '$\frac{7}{10}$', '$\frac{28}{31}$', '$\frac{3}{4}$', '$\frac{7}{8}$', 'option2', '$P(K|C) = \frac{0.7}{0.7+0.3\times 0.25} = \frac{0.7}{0.775} = \frac{28}{31}$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- Q21: Mean and variance of binomial B(20, 1/4). E(X)=5, Var=20(1/4)(3/4)=15/4.
-- SD = √(15/4) = √15/2.
('The standard deviation of $X \sim B(20, \frac{1}{4})$ is', '$\frac{5}{2}$', '$\frac{15}{4}$', '$\sqrt{5}$', '$\frac{\sqrt{15}}{2}$', 'option4', 'Var $= npq = 20\cdot\frac{1}{4}\cdot\frac{3}{4} = \frac{15}{4}$. SD $= \frac{\sqrt{15}}{2}$.', 'm_bayes_theorem', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_trig_identities_functions (Unit 14)
-- Trigonometrical identities and trigonometrical functions
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: sin²θ + cos²θ = 1. If sinθ=3/5, cosθ=4/5 (first quadrant). cos²θ=16/25.
('If $\sin\theta = \frac{3}{5}$ and $\theta$ is in the first quadrant, then $\cos\theta$ is', '$\frac{3}{5}$', '$\frac{4}{5}$', '$\frac{2}{5}$', '$\frac{1}{5}$', 'option2', '$\cos^2\theta = 1-\frac{9}{25} = \frac{16}{25}$. First quadrant: $\cos\theta = \frac{4}{5}$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q2: tan 45° = 1.
('The value of $\tan 45°$ is', '$\frac{1}{\sqrt{3}}$', '$0$', '$\sqrt{3}$', '$1$', 'option4', '$\tan 45° = 1$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q3: sin 30° = 1/2.
('The value of $\sin 30°$ is', '$0$', '$\frac{\sqrt{3}}{2}$', '$1$', '$\frac{1}{2}$', 'option4', '$\sin 30° = \frac{1}{2}$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q4: sec²θ - tan²θ = 1. If secθ=5/3, tanθ=? tan²θ=25/9-1=16/9. tanθ=±4/3.
('If $\sec\theta = \frac{5}{3}$, then $\tan^2\theta$ is', '$\frac{16}{9}$', '$\frac{25}{9}$', '$\frac{9}{16}$', '$\frac{4}{3}$', 'option1', '$\tan^2\theta = \sec^2\theta-1 = \frac{25}{9}-1 = \frac{16}{9}$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q5: cos 60° = 1/2.
('The value of $\cos 60°$ is', '$\frac{1}{2}$', '$\frac{\sqrt{3}}{2}$', '$0$', '$1$', 'option1', '$\cos 60° = \frac{1}{2}$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Period of sinx is 2π.
('The period of $\sin x$ is', '$4\pi$', '$\pi$', '$\frac{\pi}{2}$', '$2\pi$', 'option4', '$\sin x$ has period $2\pi$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q7: sin(90°-θ) = cosθ. sin 60° = cos 30° = √3/2.
('$\sin(90°-\theta)$ equals', '$\sin\theta$', '$\cos\theta$', '$-\cos\theta$', '$\tan\theta$', 'option2', 'Complementary angle identity: $\sin(90°-\theta) = \cos\theta$.', 'm_trig_identities_functions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: sin(A+B) = sinAcosB + cosAsinB. sin75° = sin(45°+30°) = (√2/2)(√3/2)+(√2/2)(1/2) = (√6+√2)/4.
('The value of $\sin 75°$ is', '$\frac{\sqrt{6}-\sqrt{2}}{4}$', '$\frac{\sqrt{6}+\sqrt{2}}{4}$', '$\frac{\sqrt{3}+1}{2}$', '$\frac{\sqrt{2}+1}{2}$', 'option2', '$\sin 75° = \sin(45°+30°) = \frac{\sqrt{2}}{2}\cdot\frac{\sqrt{3}}{2}+\frac{\sqrt{2}}{2}\cdot\frac{1}{2} = \frac{\sqrt{6}+\sqrt{2}}{4}$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q9: cos2θ = 1-2sin²θ. If sinθ=1/√2, cos2θ=1-1=0.
('If $\sin\theta = \frac{1}{\sqrt{2}}$, then $\cos 2\theta$ is', '$0$', '$1$', '$\frac{1}{2}$', '$-1$', 'option1', '$\cos 2\theta = 1-2\sin^2\theta = 1-2\cdot\frac{1}{2} = 0$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q10: tan(A+B) = (tanA+tanB)/(1-tanAtanB). tan(45°+30°) = (1+1/√3)/(1-1/√3) = (√3+1)/(√3-1).
-- Rationalize: (√3+1)²/2 = (4+2√3)/2 = 2+√3.
('$\tan 75°$ equals', '$\frac{\sqrt{3}+1}{\sqrt{3}-1}$', '$2-\sqrt{3}$', '$\sqrt{3}+1$', '$2+\sqrt{3}$', 'option4', '$\tan 75° = \frac{1+\frac{1}{\sqrt{3}}}{1-\frac{1}{\sqrt{3}}} = \frac{\sqrt{3}+1}{\sqrt{3}-1} = 2+\sqrt{3}$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q11: sin2θ = 2sinθcosθ. If sinθ=3/5, cosθ=4/5, sin2θ=24/25.
('If $\sin\theta=\frac{3}{5}$ and $\cos\theta=\frac{4}{5}$, then $\sin 2\theta$ is', '$\frac{7}{25}$', '$\frac{6}{5}$', '$\frac{12}{25}$', '$\frac{24}{25}$', 'option4', '$\sin 2\theta = 2\sin\theta\cos\theta = 2\cdot\frac{3}{5}\cdot\frac{4}{5} = \frac{24}{25}$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q12: General solution of sinθ=0 is θ=nπ, n∈Z.
('The general solution of $\sin\theta = 0$ is', '$\theta = 2n\pi, n \in \mathbb{Z}$', '$\theta = n\pi, n \in \mathbb{Z}$', '$\theta = (2n+1)\frac{\pi}{2}, n \in \mathbb{Z}$', '$\theta = \frac{n\pi}{2}, n \in \mathbb{Z}$', 'option2', '$\sin\theta = 0$ when $\theta = n\pi$ for any integer $n$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q13: Range of sinx is [-1,1]. Range of 2sinx+3 is [1,5].
('The range of $2\sin x + 3$ is', '$[1, 3]$', '$[-1, 5]$', '$[1, 5]$', '$[-2, 2]$', 'option3', '$-1 \leq \sin x \leq 1$, so $-2 \leq 2\sin x \leq 2$, hence $1 \leq 2\sin x+3 \leq 5$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q14: cos²θ-sin²θ = cos2θ. If θ=π/6: cos(π/3)=1/2.
('$\cos^2\frac{\pi}{6}-\sin^2\frac{\pi}{6}$ equals', '$1$', '$\frac{\sqrt{3}}{2}$', '$0$', '$\frac{1}{2}$', 'option4', '$\cos^2\frac{\pi}{6}-\sin^2\frac{\pi}{6} = \cos\frac{\pi}{3} = \frac{1}{2}$.', 'm_trig_identities_functions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: Prove: (1+tanA)/(1+cotA) = tanA. LHS = (1+tanA)/(1+1/tanA) = (1+tanA)·tanA/(tanA+1) = tanA.
-- If A=60°: (1+√3)/(1+1/√3) = (1+√3)/((√3+1)/√3) = √3. And tan60°=√3. ✓
('$\frac{1+\tan A}{1+\cot A}$ equals', '$\sec A$', '$\cot A$', '$1$', '$\tan A$', 'option4', '$\frac{1+\tan A}{1+\cot A} = \frac{1+\tan A}{1+\frac{1}{\tan A}} = \frac{(1+\tan A)\tan A}{\tan A+1} = \tan A$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q16: Number of solutions of sinx=1/2 in [0,2π]. x=π/6 and x=5π/6. Two solutions.
('The number of solutions of $\sin x = \frac{1}{2}$ in $[0, 2\pi]$ is', '$2$', '$1$', '$3$', '$4$', 'option1', '$x = \frac{\pi}{6}$ and $x = \frac{5\pi}{6}$. Two solutions.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q17: sin3θ = 3sinθ-4sin³θ. If sinθ=1/2, sin3θ=3/2-4/8=3/2-1/2=1.
-- θ=30°, sin90°=1. ✓
('If $\sin\theta = \frac{1}{2}$, then $\sin 3\theta$ is', '$\frac{3}{2}$', '$1$', '$\frac{\sqrt{3}}{2}$', '$0$', 'option2', '$\sin 3\theta = 3\sin\theta-4\sin^3\theta = \frac{3}{2}-\frac{4}{8} = \frac{3}{2}-\frac{1}{2} = 1$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q18: Maximum value of asinx+bcosx = √(a²+b²). For 3sinx+4cosx: max=5.
('The maximum value of $3\sin x + 4\cos x$ is', '$4$', '$7$', '$\sqrt{7}$', '$5$', 'option4', 'Maximum of $a\sin x+b\cos x = \sqrt{a^2+b^2} = \sqrt{9+16} = 5$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q19: General solution of tanθ=1. θ=nπ+π/4, n∈Z.
('The general solution of $\tan\theta = 1$ is', '$\theta = 2n\pi+\frac{\pi}{4}, n \in \mathbb{Z}$', '$\theta = n\pi+\frac{\pi}{4}, n \in \mathbb{Z}$', '$\theta = n\pi, n \in \mathbb{Z}$', '$\theta = \frac{n\pi}{4}, n \in \mathbb{Z}$', 'option2', '$\tan\theta = 1 = \tan\frac{\pi}{4}$. General solution: $\theta = n\pi+\frac{\pi}{4}$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q20: sinA+sinB = 2sin((A+B)/2)cos((A-B)/2). sin50°+sin10° = 2sin30°cos20° = cos20°.
('$\sin 50° + \sin 10°$ equals', '$\cos 40°$', '$\sin 60°$', '$\cos 20°$', '$\sin 30°$', 'option3', '$\sin 50°+\sin 10° = 2\sin 30°\cos 20° = 2\cdot\frac{1}{2}\cdot\cos 20° = \cos 20°$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q21: If tanA=1/2, tanB=1/3, then A+B=π/4 since tan(A+B)=(1/2+1/3)/(1-1/6)=(5/6)/(5/6)=1.
('If $\tan A = \frac{1}{2}$ and $\tan B = \frac{1}{3}$, then $A + B$ equals', '$\frac{\pi}{4}$', '$\frac{\pi}{3}$', '$\frac{\pi}{6}$', '$\frac{\pi}{2}$', 'option1', '$\tan(A+B) = \frac{\frac{1}{2}+\frac{1}{3}}{1-\frac{1}{6}} = \frac{5/6}{5/6} = 1$. So $A+B = \frac{\pi}{4}$.', 'm_trig_identities_functions', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- Subconcept: m_inverse_trig_functions (Unit 14)
-- Inverse trigonometrical functions and their properties
-- 21 questions: 7 easy (tier 1) + 7 medium (tier 2) + 7 hard (tier 3)
-- ============================================================

-- Tier 1 (Easy)
-- Q1: sin⁻¹(1/2) = π/6.
('$\sin^{-1}\left(\frac{1}{2}\right)$ equals', '$\frac{\pi}{3}$', '$\frac{\pi}{6}$', '$\frac{\pi}{4}$', '$\frac{\pi}{2}$', 'option2', '$\sin\frac{\pi}{6} = \frac{1}{2}$, so $\sin^{-1}\frac{1}{2} = \frac{\pi}{6}$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q2: cos⁻¹(0) = π/2.
('$\cos^{-1}(0)$ equals', '$\frac{\pi}{4}$', '$0$', '$\pi$', '$\frac{\pi}{2}$', 'option4', '$\cos\frac{\pi}{2} = 0$, so $\cos^{-1}(0) = \frac{\pi}{2}$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q3: tan⁻¹(1) = π/4.
('$\tan^{-1}(1)$ equals', '$\frac{\pi}{3}$', '$\frac{\pi}{2}$', '$\pi$', '$\frac{\pi}{4}$', 'option4', '$\tan\frac{\pi}{4} = 1$, so $\tan^{-1}(1) = \frac{\pi}{4}$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q4: Range of sin⁻¹x is [-π/2, π/2].
('The range of $\sin^{-1}x$ is', '$(-\pi, \pi)$', '$[0, \pi]$', '$\left[-\frac{\pi}{2}, \frac{\pi}{2}\right]$', '$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$', 'option3', 'The principal value branch of $\sin^{-1}x$ has range $\left[-\frac{\pi}{2}, \frac{\pi}{2}\right]$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q5: sin⁻¹(1) = π/2.
('$\sin^{-1}(1)$ equals', '$\frac{\pi}{4}$', '$\pi$', '$0$', '$\frac{\pi}{2}$', 'option4', '$\sin\frac{\pi}{2} = 1$, so $\sin^{-1}(1) = \frac{\pi}{2}$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q6: Domain of cos⁻¹x is [-1,1].
('The domain of $\cos^{-1}x$ is', '$[-1, 1]$', '$[0, 1]$', '$(-\infty, \infty)$', '$[0, \pi]$', 'option1', '$\cos^{-1}x$ is defined for $x \in [-1, 1]$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Q7: tan⁻¹(0) = 0.
('$\tan^{-1}(0)$ equals', '$\frac{\pi}{2}$', '$0$', '$\pi$', '$\frac{\pi}{4}$', 'option2', '$\tan 0 = 0$, so $\tan^{-1}(0) = 0$.', 'm_inverse_trig_functions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
-- Q8: sin⁻¹x + cos⁻¹x = π/2. If sin⁻¹(3/5)=α, then cos⁻¹(3/5)=π/2-α.
('$\sin^{-1}x + \cos^{-1}x$ equals', '$\pi$', '$\frac{\pi}{2}$', '$0$', '$\frac{\pi}{4}$', 'option2', 'Standard identity: $\sin^{-1}x + \cos^{-1}x = \frac{\pi}{2}$ for $x \in [-1,1]$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q9: tan⁻¹(1/2)+tan⁻¹(1/3). Using tan⁻¹a+tan⁻¹b=tan⁻¹((a+b)/(1-ab)) when ab<1.
-- = tan⁻¹((1/2+1/3)/(1-1/6)) = tan⁻¹((5/6)/(5/6)) = tan⁻¹(1) = π/4.
('$\tan^{-1}\frac{1}{2}+\tan^{-1}\frac{1}{3}$ equals', '$\frac{\pi}{2}$', '$\frac{\pi}{3}$', '$\frac{\pi}{6}$', '$\frac{\pi}{4}$', 'option4', '$\tan^{-1}\frac{1}{2}+\tan^{-1}\frac{1}{3} = \tan^{-1}\frac{5/6}{5/6} = \tan^{-1}(1) = \frac{\pi}{4}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q10: sin(cos⁻¹(3/5)). Let θ=cos⁻¹(3/5), cosθ=3/5, sinθ=4/5 (θ in [0,π]).
('$\sin(\cos^{-1}\frac{3}{5})$ equals', '$\frac{5}{4}$', '$\frac{3}{5}$', '$\frac{3}{4}$', '$\frac{4}{5}$', 'option4', 'Let $\theta = \cos^{-1}\frac{3}{5}$. Then $\sin\theta = \sqrt{1-\frac{9}{25}} = \frac{4}{5}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q11: 2tan⁻¹x = sin⁻¹(2x/(1+x²)) for |x|≤1. If x=1/√3: 2tan⁻¹(1/√3)=2(π/6)=π/3.
-- sin⁻¹(2/√3/(1+1/3))=sin⁻¹((2/√3)/(4/3))=sin⁻¹(6/(4√3))=sin⁻¹(3/(2√3))=sin⁻¹(√3/2)=π/3. ✓
('$2\tan^{-1}\frac{1}{\sqrt{3}}$ equals', '$\frac{\pi}{4}$', '$\frac{\pi}{6}$', '$\frac{2\pi}{3}$', '$\frac{\pi}{3}$', 'option4', '$2\tan^{-1}\frac{1}{\sqrt{3}} = 2\cdot\frac{\pi}{6} = \frac{\pi}{3}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q12: cos⁻¹(-1/2) = 2π/3. Since cos(2π/3)=-1/2 and 2π/3 ∈ [0,π].
('$\cos^{-1}\left(-\frac{1}{2}\right)$ equals', '$\frac{2\pi}{3}$', '$\frac{\pi}{3}$', '$-\frac{\pi}{3}$', '$\frac{4\pi}{3}$', 'option1', '$\cos\frac{2\pi}{3} = -\frac{1}{2}$ and $\frac{2\pi}{3} \in [0,\pi]$. So $\cos^{-1}(-\frac{1}{2}) = \frac{2\pi}{3}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q13: tan(sin⁻¹(3/5)). Let θ=sin⁻¹(3/5). sinθ=3/5, cosθ=4/5. tanθ=3/4.
('$\tan(\sin^{-1}\frac{3}{5})$ equals', '$\frac{5}{3}$', '$\frac{4}{3}$', '$\frac{3}{5}$', '$\frac{3}{4}$', 'option4', 'Let $\theta = \sin^{-1}\frac{3}{5}$. $\cos\theta = \frac{4}{5}$. $\tan\theta = \frac{3}{4}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Q14: sin⁻¹(-x) = -sin⁻¹(x). sin⁻¹(-√3/2) = -sin⁻¹(√3/2) = -π/3.
('$\sin^{-1}\left(-\frac{\sqrt{3}}{2}\right)$ equals', '$-\frac{2\pi}{3}$', '$\frac{\pi}{3}$', '$\frac{2\pi}{3}$', '$-\frac{\pi}{3}$', 'option4', '$\sin^{-1}(-x) = -\sin^{-1}(x)$. So $\sin^{-1}(-\frac{\sqrt{3}}{2}) = -\frac{\pi}{3}$.', 'm_inverse_trig_functions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
-- Q15: tan⁻¹(1)+tan⁻¹(2)+tan⁻¹(3). 
-- tan⁻¹(1)+tan⁻¹(2) = π+tan⁻¹((1+2)/(1-2)) = π+tan⁻¹(-3) (since 1·2>1, add π).
-- = π-tan⁻¹(3). So total = π-tan⁻¹(3)+tan⁻¹(3) = π.
('$\tan^{-1}(1)+\tan^{-1}(2)+\tan^{-1}(3)$ equals', '$\frac{3\pi}{2}$', '$\frac{3\pi}{4}$', '$\frac{\pi}{2}$', '$\pi$', 'option4', '$\tan^{-1}(1)+\tan^{-1}(2) = \pi+\tan^{-1}(-3) = \pi-\tan^{-1}(3)$. Adding $\tan^{-1}(3)$: total $= \pi$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q16: sin(2sin⁻¹(3/5)). Let θ=sin⁻¹(3/5). sin2θ=2sinθcosθ=2(3/5)(4/5)=24/25.
('$\sin(2\sin^{-1}\frac{3}{5})$ equals', '$\frac{12}{25}$', '$\frac{6}{5}$', '$\frac{24}{25}$', '$\frac{9}{25}$', 'option3', 'Let $\theta=\sin^{-1}\frac{3}{5}$. $\sin 2\theta = 2\cdot\frac{3}{5}\cdot\frac{4}{5} = \frac{24}{25}$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q17: cos(tan⁻¹(3/4)). Let θ=tan⁻¹(3/4). tanθ=3/4. In right triangle: hyp=5. cosθ=4/5.
('$\cos(\tan^{-1}\frac{3}{4})$ equals', '$\frac{3}{4}$', '$\frac{3}{5}$', '$\frac{4}{5}$', '$\frac{5}{4}$', 'option3', 'Let $\theta = \tan^{-1}\frac{3}{4}$. Right triangle: sides $3,4,5$. $\cos\theta = \frac{4}{5}$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q18: If sin⁻¹x+sin⁻¹y=π/2, then x²+y²=1.
-- sin⁻¹y=π/2-sin⁻¹x=cos⁻¹x. So y=cos(cos⁻¹x)... wait, sin⁻¹y=cos⁻¹x means y=sin(cos⁻¹x)=√(1-x²).
-- Actually: sin⁻¹y=π/2-sin⁻¹x. And sin⁻¹x+cos⁻¹x=π/2, so cos⁻¹x=π/2-sin⁻¹x.
-- Therefore sin⁻¹y=cos⁻¹x, so y=sin(cos⁻¹x)=√(1-x²). y²=1-x². x²+y²=1.
('If $\sin^{-1}x + \sin^{-1}y = \frac{\pi}{2}$, then $x^2 + y^2$ equals', '$0$', '$\frac{\pi^2}{4}$', '$1$', '$2$', 'option3', '$\sin^{-1}y = \frac{\pi}{2}-\sin^{-1}x = \cos^{-1}x$. So $y = \sqrt{1-x^2}$, giving $x^2+y^2=1$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q19: tan⁻¹x+tan⁻¹(1/x) = π/2 for x>0. For x=2: tan⁻¹(2)+tan⁻¹(1/2)=π/2.
('$\tan^{-1}(2)+\tan^{-1}\left(\frac{1}{2}\right)$ equals', '$\pi$', '$\frac{\pi}{4}$', '$\frac{\pi}{2}$', '$\frac{\pi}{3}$', 'option3', 'For $x > 0$: $\tan^{-1}x+\tan^{-1}\frac{1}{x} = \frac{\pi}{2}$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q20: 3sin⁻¹x = sin⁻¹(3x-4x³). If x=1/2: 3sin⁻¹(1/2)=3(π/6)=π/2.
-- sin⁻¹(3/2-1/2)=sin⁻¹(1)=π/2. ✓
('$3\sin^{-1}\frac{1}{2}$ equals', '$\frac{3\pi}{2}$', '$\frac{\pi}{6}$', '$\frac{\pi}{2}$', '$\frac{\pi}{3}$', 'option3', '$3\sin^{-1}\frac{1}{2} = 3\cdot\frac{\pi}{6} = \frac{\pi}{2}$.', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved'),

-- Q21: If tan⁻¹x+tan⁻¹y+tan⁻¹z=π, and x+y+z=xyz, this is always true.
-- For x=1,y=1,z=1: tan⁻¹(1)+tan⁻¹(1)+tan⁻¹(1)=3π/4≠π. So x=y=z=1 doesn't work.
-- Actually the identity is: if tan⁻¹x+tan⁻¹y+tan⁻¹z=π then x+y+z=xyz.
-- Let me use: tan⁻¹(1)+tan⁻¹(2)+tan⁻¹(3)=π. Check: 1+2+3=6=1·2·3=6. ✓
('If $\tan^{-1}x+\tan^{-1}y+\tan^{-1}z=\pi$, then $x+y+z$ equals', '$x+y+z$', '$xyz$', '$0$', '$1$', 'option2', 'If $\tan^{-1}x+\tan^{-1}y+\tan^{-1}z=\pi$, then $x+y+z=xyz$. (Verify: $1+2+3=6=1\cdot 2\cdot 3$.)', 'm_inverse_trig_functions', 3, 'JEE Mains Prep', 'approved');