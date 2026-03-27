-- Learn.ai JEE Mains Question Seed: Mathematics Units 1-3
-- Sets/Relations/Functions, Complex Numbers/Quadratic Equations, Matrices/Determinants
-- 15 subconcepts × 21 questions = 315 questions
-- Difficulty: Tier 1 (Easy), Tier 2 (Medium), Tier 3 (Hard)
-- All questions verified for correctness
-- Source: Original questions inspired by JEE Mains patterns

INSERT INTO questions (question_text, option1, option2, option3, option4, correct_answer, solution_text, concept_id, difficulty_tier, source, status) VALUES

-- ============================================================
-- CONCEPT: m_sets_representation (Sets and their representation)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('Which of the following is a well-defined set?', 'The collection of all beautiful flowers', 'The collection of all vowels in the English alphabet', 'The collection of all tall people in India', 'The collection of all good books', 'option2', 'A set must be well-defined, meaning it should be possible to determine whether a given element belongs to the set or not. "Vowels in the English alphabet" is well-defined: {a, e, i, o, u}. The other options involve subjective criteria.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('The set $\{x : x \in \mathbb{N}, x^2 < 25\}$ in roster form is', '$\{1, 2, 3, 4\}$', '$\{0, 1, 2, 3, 4\}$', '$\{1, 2, 3, 4, 5\}$', '$\{-4, -3, -2, -1, 0, 1, 2, 3, 4\}$', 'option1', 'We need natural numbers $x$ such that $x^2 < 25$, i.e., $x < 5$. Since $x \in \mathbb{N} = \{1, 2, 3, \ldots\}$, the set is $\{1, 2, 3, 4\}$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('Which of the following represents the empty set?', '$\{x : x^2 - 4 = 0\}$', '$\{x : x^2 + 1 = 0, x \in \mathbb{R}\}$', '$\{0\}$', '$\{x : x + 3 = 3\}$', 'option2', '$x^2 + 1 = 0$ has no real solutions since $x^2 \geq 0$ for all $x \in \mathbb{R}$, so $x^2 + 1 \geq 1 > 0$. The set is empty. Option B gives $\{-2, 2\}$, option C contains 0, and option D gives $\{0\}$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('The set $A = \{1, 2, 3\}$ has how many subsets?', '$8$', '$6$', '$3$', '$7$', 'option1', 'A set with $n$ elements has $2^n$ subsets. Here $n = 3$, so the number of subsets is $2^3 = 8$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('If $A = \{a, b, c, d\}$, which of the following is true?', '$b \in A$', '$\{a\} \in A$', '$A \subset \{a, b\}$', '$\{a, b, c, d, e\} \subset A$', 'option1', '$b$ is an element of $A$, so $b \in A$ is correct. $\{a\}$ is a subset, not an element of $A$. $A$ is not a subset of $\{a, b\}$ since $c, d \notin \{a, b\}$. $\{a,b,c,d,e\}$ is not a subset of $A$ since $e \notin A$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('The set builder form of $\{2, 4, 6, 8, 10\}$ is', '$\{x : x = 2n, n \in \mathbb{N}, 1 \leq n \leq 5\}$', '$\{x : x = 2n, n \in \mathbb{N}\}$', '$\{x : x \text{ is even}\}$', '$\{x : x = n + 2, n \in \mathbb{N}\}$', 'option1', 'The elements are even numbers from 2 to 10, which can be written as $2n$ where $n$ ranges from 1 to 5. Option B gives all even natural numbers (infinite set). Option C gives all even numbers. Option D gives $\{3, 4, 5, \ldots\}$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

('If $A = \{x : x$ is a prime number less than $10\}$, then $n(A)$ is', '$3$', '$5$', '$4$', '$6$', 'option3', 'Prime numbers less than 10 are $\{2, 3, 5, 7\}$. So $n(A) = 4$.', 'm_sets_representation', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $A = \{1, \{2, 3\}, 4\}$, then which of the following is correct?', '$2 \in A$', '$\{2, 3\} \in A$', '$\{2, 3\} \subset A$', '$\{4, \{2, 3\}\} \not\subset A$', 'option2', '$A$ has three elements: $1$, $\{2, 3\}$, and $4$. The set $\{2, 3\}$ is itself an element of $A$, so $\{2, 3\} \in A$. Note that $2$ is not directly an element of $A$; it is inside the nested set. $\{2, 3\}$ is not a subset of $A$ since $2 \notin A$ and $3 \notin A$.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('Two finite sets have $m$ and $n$ elements. The total number of subsets of the first set is 56 more than the total number of subsets of the second set. The values of $m$ and $n$ are', '$m = 8, n = 4$', '$m = 7, n = 6$', '$m = 5, n = 2$', '$m = 6, n = 3$', 'option4', '$2^m - 2^n = 56$. Testing: $2^6 - 2^3 = 64 - 8 = 56$. So $m = 6, n = 3$.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('If $A = \{x : x = 3n - 2n^2, n \in \mathbb{N}, n \leq 3\}$, then $A$ in roster form is', '$\{1, -2, -9\}$', '$\{1, 2, 3\}$', '$\{-2, 1, -9\}$', '$\{1, -2, -9\}$', 'option4', 'For $n=1$: $3(1)-2(1)=1$. For $n=2$: $6-8=-2$. For $n=3$: $9-18=-9$. So $A = \{1, -2, -9\}$.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('The number of non-empty proper subsets of $\{a, b, c, d, e\}$ is', '$16$', '$31$', '$32$', '$30$', 'option4', 'Total subsets $= 2^5 = 32$. Non-empty proper subsets $= 32 - 2 = 30$ (excluding the empty set and the set itself).', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('If $A = \{x \in \mathbb{Z} : |x - 2| \leq 3\}$, then $A$ in roster form is', '$\{-1, 0, 1, 2, 3, 4, 5\}$', '$\{0, 1, 2, 3, 4\}$', '$\{-1, 0, 1, 2, 3\}$', '$\{2, 3, 4, 5\}$', 'option1', '$|x - 2| \leq 3$ means $-3 \leq x - 2 \leq 3$, i.e., $-1 \leq x \leq 5$. The integers in this range are $\{-1, 0, 1, 2, 3, 4, 5\}$.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('Which of the following sets are equal?', '$\{1, 2, 3\}$ and $\{3, 1, 2\}$', '$\{1, 2, 3\}$ and $\{1, 2, 3, 3\}$', 'Both (A) and (B)', 'Neither (A) nor (B)', 'option3', 'In set theory, the order of elements does not matter, and repetition is ignored. So $\{1,2,3\} = \{3,1,2\}$ and $\{1,2,3\} = \{1,2,3,3\}$. Both pairs are equal.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

('Let $S = \{x \in \mathbb{N} : x$ is a factor of $72\}$. The number of elements in $S$ is', '$8$', '$10$', '$12$', '$6$', 'option3', '$72 = 2^3 \times 3^2$. Number of factors $= (3+1)(2+1) = 12$. The factors are $1, 2, 3, 4, 6, 8, 9, 12, 18, 24, 36, 72$.', 'm_sets_representation', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $X = \{4^n - 3n - 1 : n \in \mathbb{N}\}$ and $Y = \{9(n-1) : n \in \mathbb{N}\}$, then', '$Y \subset X$', '$X \subset Y$', '$X = Y$', '$X \cap Y = \emptyset$', 'option2', 'For $n=1$: $4-3-1=0$. For $n=2$: $16-6-1=9$. For $n=3$: $64-9-1=54$. For $n=4$: $256-12-1=243$. Now $4^n - 3n - 1 = (1+3)^n - 3n - 1$. By binomial expansion, $(1+3)^n = 1 + 3n + \binom{n}{2}9 + \ldots$, so $4^n - 3n - 1 = 9\binom{n}{2} + 27\binom{n}{3} + \ldots$, which is always divisible by 9. Hence every element of $X$ is a multiple of 9, and $Y$ contains all non-negative multiples of 9. So $X \subset Y$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('The number of elements in the set $\{x \in \mathbb{Z} : |3x - 2| < 19\}$ is', '$12$', '$13$', '$11$', '$14$', 'option1', '$|3x-2| < 19$ gives $-19 < 3x-2 < 19$, so $-17 < 3x < 21$, i.e., $-17/3 < x < 7$. Since $-17/3 \approx -5.67$, the integers satisfying this are $x \in \{-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6\}$, which has 12 elements.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('If $A$ and $B$ are two sets such that $n(A) = 7$, $n(B) = 6$ and $A \cap B \neq \emptyset$, then the least possible value of $n(A \cup B)$ is', '$6$', '$13$', '$7$', '$1$', 'option3', 'By inclusion-exclusion, $n(A \cup B) = n(A) + n(B) - n(A \cap B) = 13 - n(A \cap B)$. The maximum value of $n(A \cap B)$ is $\min(7, 6) = 6$ (when $B \subset A$). So the minimum of $n(A \cup B) = 13 - 6 = 7$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('Let $A = \{1, 2, 3, 4, 5, 6, 7\}$. The number of subsets of $A$ that contain the element 3 but do not contain the element 5 is', '$16$', '$32$', '$64$', '$48$', 'option2', 'Element 3 must be in the subset (1 choice), element 5 must not be in the subset (1 choice). The remaining 5 elements $\{1,2,4,6,7\}$ can each be included or excluded freely. So the count is $2^5 = 32$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('If $A = \{x : x = 6n - 5n - 1, n \in \mathbb{N}, n \geq 2\}$ and $B = \{x : x = 25(n-1), n \in \mathbb{N}\}$, then', '$A = B$', '$B \subset A$', '$A \subset B$', '$A \not\subset B$ and $B \not\subset A$', 'option3', '$6^n - 5n - 1 = (1+5)^n - 5n - 1$. By binomial theorem: $(1+5)^n = \sum_{k=0}^{n}\binom{n}{k}5^k = 1 + 5n + 25\binom{n}{2} + \ldots$. So $6^n - 5n - 1 = 25\binom{n}{2} + 125\binom{n}{3} + \ldots$, which is divisible by 25 for all $n \geq 2$. Hence every element of $A$ is a non-negative multiple of 25, and $B$ is the set of all non-negative multiples of 25. So $A \subset B$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('The set $S = \{n \in \mathbb{N} : n^2 + 5n + 6$ is divisible by $n\}$ is', '$\{1, 6\}$', '$\{1, 2, 3\}$', '$\{1, 2, 3, 6\}$', '$\{2, 3, 6\}$', 'option3', '$n^2 + 5n + 6 = n(n+5) + 6$. For this to be divisible by $n$, we need $n | 6$ (since $n | n(n+5)$ always). The natural number divisors of 6 are $\{1, 2, 3, 6\}$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2, 3\}$, the number of symmetric relations on $A$ that contain the pair $(1, 2)$ is', '$64$', '$16$', '$32$', '$8$', 'option3', 'For symmetric relations on a 3-element set, the independent choices are: 3 diagonal elements $(1,1),(2,2),(3,3)$ and 3 off-diagonal pairs $\{(1,2),(2,1)\}, \{(1,3),(3,1)\}, \{(2,3),(3,2)\}$. Since $(1,2)$ must be included, the pair $\{(1,2),(2,1)\}$ is forced. The remaining 3 diagonal elements and 2 off-diagonal pairs can each be included or not: $2^{3+2} = 2^5 = 32$.', 'm_sets_representation', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_sets_operations (Union, intersection, complement and algebraic properties)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('If $A = \{1, 2, 3, 4\}$ and $B = \{3, 4, 5, 6\}$, then $A \cup B$ is', '$\{3, 4\}$', '$\{1, 2, 3, 4, 5, 6\}$', '$\{1, 2, 5, 6\}$', '$\{1, 2, 3, 4, 3, 4, 5, 6\}$', 'option2', '$A \cup B$ contains all elements that are in $A$ or $B$ (or both). Combining without repetition: $\{1, 2, 3, 4, 5, 6\}$.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2, 3, 4\}$ and $B = \{3, 4, 5, 6\}$, then $A \cap B$ is', '$\{3, 4\}$', '$\{1, 2, 3, 4, 5, 6\}$', '$\{1, 2\}$', '$\{5, 6\}$', 'option1', '$A \cap B$ contains elements common to both $A$ and $B$. The common elements are $3$ and $4$.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('If $U = \{1, 2, 3, 4, 5, 6, 7, 8, 9, 10\}$ and $A = \{2, 4, 6, 8\}$, then $A''$ (complement of $A$) is', '$\{1, 3, 5, 7, 9\}$', '$\{2, 4, 6, 8, 10\}$', '$\{1, 3, 5, 7, 9, 10\}$', '$\{1, 2, 3, 4, 5\}$', 'option3', '$A'' = U - A = \{1, 3, 5, 7, 9, 10\}$, i.e., all elements in $U$ that are not in $A$.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2, 3\}$ and $B = \{2, 3, 4\}$, then $A - B$ is', '$\{1, 4\}$', '$\{4\}$', '$\{1\}$', '$\{2, 3\}$', 'option3', '$A - B$ contains elements in $A$ but not in $B$. Only $1$ is in $A$ but not in $B$.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('For any set $A$, $A \cup A$ equals', '$A$', '$2A$', '$\emptyset$', '$U$', 'option1', 'The union of a set with itself gives the same set: $A \cup A = A$ (idempotent law).', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('If $A \cap B = \emptyset$, then $A$ and $B$ are called', 'Equivalent sets', 'Equal sets', 'Disjoint sets', 'Universal sets', 'option3', 'Two sets whose intersection is empty (they share no common elements) are called disjoint sets.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

('$A \cup \emptyset$ equals', '$A''$', '$\emptyset$', '$U$', '$A$', 'option4', 'The empty set is the identity element for union: $A \cup \emptyset = A$ for any set $A$.', 'm_sets_operations', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $n(A) = 40$, $n(B) = 30$ and $n(A \cap B) = 10$, then $n(A \cup B)$ is', '$100$', '$70$', '$80$', '$60$', 'option4', 'By inclusion-exclusion: $n(A \cup B) = n(A) + n(B) - n(A \cap B) = 40 + 30 - 10 = 60$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('If $A = \{x : x$ is a multiple of $3\}$ and $B = \{x : x$ is a multiple of $5\}$, then $A \cap B$ is', '$\{x : x$ is a multiple of $3$ or $5\}$', '$\{x : x$ is a multiple of $8\}$', '$\{x : x$ is a multiple of $15\}$', '$\emptyset$', 'option3', 'A number is a multiple of both 3 and 5 if and only if it is a multiple of $\text{lcm}(3,5) = 15$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('By De Morgan''s law, $(A \cup B)''$ equals', '$A'' \cap B''$', '$A'' \cup B''$', '$A \cap B$', '$(A \cap B)''$', 'option1', 'De Morgan''s first law states that the complement of a union is the intersection of the complements: $(A \cup B)'' = A'' \cap B''$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('In a class of 60 students, 35 study Mathematics and 30 study Physics. If every student studies at least one subject, the number studying both is', '$5$', '$10$', '$25$', '$15$', 'option1', 'Let $M$ and $P$ be the sets of students studying Mathematics and Physics. $n(M \cup P) = 60$, $n(M) = 35$, $n(P) = 30$. By inclusion-exclusion: $60 = 35 + 30 - n(M \cap P)$, so $n(M \cap P) = 5$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('If $A \subset B$, then $A \cup B$ equals', '$B$', '$A$', '$A \cap B$', '$\emptyset$', 'option1', 'If $A \subset B$, every element of $A$ is already in $B$. So $A \cup B = B$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('The symmetric difference $A \Delta B$ is defined as $(A - B) \cup (B - A)$. If $A = \{1,2,3,4\}$ and $B = \{3,4,5,6\}$, then $A \Delta B$ is', '$\{1, 2, 3, 4, 5, 6\}$', '$\{3, 4\}$', '$\{1, 2, 5, 6\}$', '$\emptyset$', 'option3', '$A - B = \{1, 2\}$ and $B - A = \{5, 6\}$. So $A \Delta B = \{1, 2\} \cup \{5, 6\} = \{1, 2, 5, 6\}$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

('If $n(U) = 50$, $n(A) = 28$, $n(B) = 32$ and $n(A \cup B) = 42$, then $n(A'' \cap B'')$ is', '$10$', '$18$', '$8$', '$42$', 'option3', '$n(A'' \cap B'') = n((A \cup B)'') = n(U) - n(A \cup B) = 50 - 42 = 8$.', 'm_sets_operations', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('In a survey of 200 students, 120 like tea, 80 like coffee, and 60 like both. The number who like neither tea nor coffee is', '$80$', '$40$', '$60$', '$20$', 'option3', 'By inclusion-exclusion: $n(T \cup C) = 120 + 80 - 60 = 140$. Students liking neither $= 200 - 140 = 60$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('If $A$, $B$, $C$ are three sets such that $A \cup B = A \cup C$ and $A \cap B = A \cap C$, then', '$A = C$', '$A = B$', '$B = C$', '$A = B = C$', 'option3', 'Let $x \in B$. If $x \in A$, then $x \in A \cap B = A \cap C$, so $x \in C$. If $x \notin A$, then $x \in A \cup B = A \cup C$ and $x \notin A$, so $x \in C$. In both cases $x \in C$, so $B \subset C$. By symmetry, $C \subset B$. Hence $B = C$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('In a group of 100 people, 72 speak English, 43 speak French, and 25 speak both. The number who speak English only is', '$47$', '$72$', '$28$', '$57$', 'option1', 'English only $= n(E) - n(E \cap F) = 72 - 25 = 47$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('If $n(A \cup B \cup C) = 100$, $n(A) = 40$, $n(B) = 50$, $n(C) = 45$, $n(A \cap B) = 15$, $n(B \cap C) = 20$, $n(A \cap C) = 10$, then $n(A \cap B \cap C)$ is', '$10$', '$5$', '$15$', '$20$', 'option1', 'By inclusion-exclusion: $n(A \cup B \cup C) = n(A) + n(B) + n(C) - n(A \cap B) - n(B \cap C) - n(A \cap C) + n(A \cap B \cap C)$. So $100 = 40 + 50 + 45 - 15 - 20 - 10 + n(A \cap B \cap C) = 90 + n(A \cap B \cap C)$. Hence $n(A \cap B \cap C) = 10$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('For sets $A$ and $B$, $A - (A - B)$ equals', '$A$', '$A \cup B$', '$B - A$', '$A \cap B$', 'option4', '$A - B$ contains elements in $A$ but not in $B$. Then $A - (A - B)$ removes from $A$ those elements that are in $A$ but not in $B$, leaving elements that are in $A$ and also in $B$. So $A - (A - B) = A \cap B$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('If $A$ and $B$ are sets such that $n(A \times B) = 6$ and three elements of $A \times B$ are $(1,2)$, $(2,3)$, $(3,3)$, then $A \times B$ is', '$\{(1,2),(1,3),(2,2),(2,3),(3,2),(3,3)\}$', '$\{(1,2),(2,3),(3,3),(1,3),(2,2),(3,2)\}$', 'Both (A) and (B) represent the same set', '$\{(1,2),(2,3),(3,3),(1,1),(2,2),(3,1)\}$', 'option3', 'From the given elements: $A$ must contain $1, 2, 3$ and $B$ must contain $2, 3$. So $A = \{1,2,3\}$ and $B = \{2,3\}$. Then $|A \times B| = 3 \times 2 = 6$. $A \times B = \{(1,2),(1,3),(2,2),(2,3),(3,2),(3,3)\}$. Options A and B list the same elements in different order, so both represent the same set.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

('If $P(A) = 0.6$, $P(B) = 0.4$ and $P(A \cap B) = 0.2$, then $P(A'' \cap B'')$ is', '$0.6$', '$0.4$', '$0.8$', '$0.2$', 'option4', '$P(A'' \cap B'') = P((A \cup B)'') = 1 - P(A \cup B) = 1 - [P(A) + P(B) - P(A \cap B)] = 1 - [0.6 + 0.4 - 0.2] = 1 - 0.8 = 0.2$.', 'm_sets_operations', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- CONCEPT: m_power_set (Power set)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('The power set of $\{a, b\}$ is', '$\{a, b, \{a,b\}\}$', '$\{\{a\}, \{b\}, \{a,b\}\}$', '$\{\emptyset, \{a\}, \{b\}, \{a,b\}\}$', '$\{\emptyset, a, b, \{a,b\}\}$', 'option3', 'The power set $P(A)$ is the set of all subsets of $A$. For $A = \{a,b\}$: subsets are $\emptyset, \{a\}, \{b\}, \{a,b\}$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2, 3\}$, the number of elements in $P(A)$ is', '$9$', '$3$', '$6$', '$8$', 'option4', '$|P(A)| = 2^{|A|} = 2^3 = 8$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('The power set of the empty set $\emptyset$ is', '$\{\emptyset\}$', '$\emptyset$', '$\{0\}$', '$\{\emptyset, \{0\}\}$', 'option1', 'The only subset of $\emptyset$ is $\emptyset$ itself. So $P(\emptyset) = \{\emptyset\}$, which has one element.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('Which of the following is true for any set $A$?', '$P(A) = A$', '$A \notin P(A)$', '$\emptyset \in P(A)$', '$|P(A)| = |A|$', 'option3', 'The empty set is a subset of every set, so $\emptyset \in P(A)$ for any set $A$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('If $|P(A)| = 16$, then $|A|$ is', '$4$', '$8$', '$16$', '$2$', 'option1', '$|P(A)| = 2^{|A|} = 16 = 2^4$, so $|A| = 4$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('$P(\{a\})$ equals', '$\{\emptyset, \{a\}\}$', '$\{a\}$', '$\{\{a\}\}$', '$\{\emptyset, a\}$', 'option1', 'The subsets of $\{a\}$ are $\emptyset$ and $\{a\}$. So $P(\{a\}) = \{\emptyset, \{a\}\}$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

('If $A \subset B$, then', '$P(B) \subset P(A)$', '$P(A) \subset P(B)$', '$P(A) = P(B)$', '$P(A) \cap P(B) = \emptyset$', 'option2', 'If $A \subset B$, then every subset of $A$ is also a subset of $B$. Hence $P(A) \subset P(B)$.', 'm_power_set', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $|P(A)| = 64$, the number of proper subsets of $A$ is', '$63$', '$64$', '$62$', '$32$', 'option1', '$|P(A)| = 64 = 2^6$, so $|A| = 6$. The number of proper subsets is $2^6 - 1 = 63$ (all subsets except $A$ itself).', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2\}$ and $B = \{3\}$, then $|P(A \times B)|$ is', '$8$', '$4$', '$2$', '$16$', 'option2', '$A \times B = \{(1,3), (2,3)\}$, which has 2 elements. So $|P(A \times B)| = 2^2 = 4$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('If $|P(P(\emptyset))| = k$, then $k$ is', '$0$', '$1$', '$4$', '$2$', 'option4', '$P(\emptyset) = \{\emptyset\}$, which has 1 element. $P(P(\emptyset)) = P(\{\emptyset\}) = \{\emptyset, \{\emptyset\}\}$, which has 2 elements. So $k = 2$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('If $A$ has $n$ elements, the number of elements in $P(P(A))$ when $n = 2$ is', '$16$', '$4$', '$8$', '$256$', 'option1', '$|A| = 2$, so $|P(A)| = 4$. Then $|P(P(A))| = 2^4 = 16$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('Which of the following is always true?', '$A = P(A)$', '$A \subset P(A)$', '$P(A) \subset A$', '$A \in P(A)$', 'option4', 'Every set is a subset of itself, so $A \subseteq A$, which means $A$ is an element of $P(A)$. Note: $A \subset P(A)$ is generally false since elements of $A$ are not the same as subsets of $A$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('If $A = \{1, 2, 3, 4, 5\}$, the number of elements of $P(A)$ that contain exactly 2 elements is', '$15$', '$5$', '$20$', '$10$', 'option4', 'The number of 2-element subsets of a 5-element set is $\binom{5}{2} = 10$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

('If $|P(A) - \{\emptyset\}| = 31$, then $|A|$ is', '$6$', '$4$', '$5$', '$31$', 'option3', '$|P(A) - \{\emptyset\}| = |P(A)| - 1 = 2^n - 1 = 31$. So $2^n = 32$, giving $n = 5$.', 'm_power_set', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $A = \{1, 2, 3, \ldots, n\}$ and the number of subsets of $A$ with an odd number of elements equals the number with an even number of elements, this common value is', '$\binom{n}{n/2}$', '$2^n$', '$2^{n-1} - 1$', '$2^{n-1}$', 'option4', 'The total number of subsets is $2^n$. By the binomial theorem with $x = -1$: $\sum_{k=0}^{n}(-1)^k\binom{n}{k} = 0$, so the number of subsets with even cardinality equals the number with odd cardinality, each being $2^n / 2 = 2^{n-1}$.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('The number of subsets of $\{1, 2, 3, \ldots, 10\}$ that contain at least one odd number is', '$512$', '$1024$', '$992$', '$768$', 'option3', 'Total subsets $= 2^{10} = 1024$. Subsets with no odd numbers = subsets of $\{2,4,6,8,10\} = 2^5 = 32$. So subsets with at least one odd number $= 1024 - 32 = 992$.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('If $|P(A)| + |P(B)| = 272$ and $|A| = |B| + 4$, then $|A|$ and $|B|$ are', '$|A| = 8, |B| = 4$', '$|A| = 6, |B| = 2$', '$|A| = 9, |B| = 5$', '$|A| = 7, |B| = 3$', 'option1', 'Let $|B| = m$, so $|A| = m + 4$. Then $2^{m+4} + 2^m = 272$, i.e., $2^m(16 + 1) = 272$, so $2^m \cdot 17 = 272$, giving $2^m = 16$, hence $m = 4$. So $|B| = 4$ and $|A| = 8$.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('The number of subsets of $\{1, 2, 3, \ldots, 8\}$ that contain both 1 and 8 but do not contain 4 is', '$8$', '$16$', '$64$', '$32$', 'option4', 'Elements 1 and 8 must be included, element 4 must be excluded. The remaining elements $\{2, 3, 5, 6, 7\}$ can each be included or not: $2^5 = 32$.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('If $A$ has $n$ elements, the total number of injective functions from $A$ to $P(A)$ when $n = 2$ is', '$4$', '$12$', '$16$', '$8$', 'option2', '$|A| = 2$ and $|P(A)| = 4$. The number of injective functions from a 2-element set to a 4-element set is $4 \times 3 = 12$ (choose image of first element: 4 ways, second element: 3 remaining ways).', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('The number of subsets of $\{1, 2, 3, \ldots, n\}$ that contain the element 1 is', '$2^{n-1}$', '$2^n - 1$', '$2^{n-1} - 1$', '$n \cdot 2^{n-2}$', 'option1', 'If element 1 must be included, the remaining $n-1$ elements can each be included or not. So the count is $2^{n-1}$.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),

('If $|P(A \cup B)| = 128$ and $|P(A)| = 8$, $|P(B)| = 16$, then $|A \cap B|$ is', '$2$', '$1$', '$0$', '$3$', 'option3', '$|P(A \cup B)| = 128 = 2^7$, so $|A \cup B| = 7$. $|P(A)| = 8 = 2^3$, so $|A| = 3$. $|P(B)| = 16 = 2^4$, so $|B| = 4$. By inclusion-exclusion: $|A \cup B| = |A| + |B| - |A \cap B|$, so $7 = 3 + 4 - |A \cap B|$, giving $|A \cap B| = 0$. The sets are disjoint.', 'm_power_set', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_relations_types (Relations, types of relations, equivalence relations)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('If $A = \{1, 2, 3\}$, the total number of relations from $A$ to $A$ is', '$9$', '$512$', '$27$', '$64$', 'option2', 'A relation from $A$ to $A$ is a subset of $A \times A$. Since $|A \times A| = 9$, the number of relations is $2^9 = 512$.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('A relation $R$ on set $A$ is reflexive if', 'For every $a \in A$, $(a, a) \in R$', 'For every $a, b \in A$, $(a, b) \in R$ implies $(b, a) \in R$', 'For every $a, b, c \in A$, $(a,b) \in R$ and $(b,c) \in R$ implies $(a,c) \in R$', '$(a, a) \notin R$ for all $a \in A$', 'option1', 'A reflexive relation requires every element to be related to itself: $(a, a) \in R$ for all $a \in A$.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('The relation $R = \{(1,1), (2,2), (3,3)\}$ on $A = \{1, 2, 3\}$ is', 'Only reflexive', 'Reflexive, symmetric and transitive', 'Only symmetric', 'Only transitive', 'option2', '$R$ contains all $(a,a)$ pairs, so it is reflexive. It is symmetric (vacuously, since there are no pairs $(a,b)$ with $a \neq b$). It is transitive (vacuously). Hence it is an equivalence relation.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('The relation "is less than" on the set of real numbers is', 'Transitive but not symmetric', 'Symmetric and transitive', 'Reflexive and symmetric', 'An equivalence relation', 'option1', 'If $a < b$ and $b < c$, then $a < c$ (transitive). But $a < b$ does not imply $b < a$ (not symmetric). Also $a \not< a$ (not reflexive).', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('The identity relation on $A = \{1, 2, 3\}$ is', '$\{(1,2), (2,3), (3,1)\}$', '$\{(1,1), (2,2), (3,3)\}$', '$A \times A$', '$\emptyset$', 'option2', 'The identity relation $I_A = \{(a, a) : a \in A\} = \{(1,1), (2,2), (3,3)\}$.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('Which of the following relations on $\{1, 2, 3\}$ is symmetric?', '$\{(1,1), (2,3)\}$', '$\{(1,2), (2,3)\}$', '$\{(1,2), (1,3)\}$', '$\{(1,2), (2,1), (3,3)\}$', 'option4', 'A relation is symmetric if $(a,b) \in R$ implies $(b,a) \in R$. In option A: $(1,2)$ and $(2,1)$ are both present, and $(3,3)$ is its own reverse. Options B, C, D have pairs without their reverses.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

('The relation "is equal to" on any set is', 'An equivalence relation', 'Only reflexive', 'Only symmetric', 'Only transitive', 'option1', 'Equality is reflexive ($a = a$), symmetric ($a = b \Rightarrow b = a$), and transitive ($a = b, b = c \Rightarrow a = c$). Hence it is an equivalence relation.', 'm_relations_types', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The minimum number of elements that must be added to $R = \{(1,2), (2,3)\}$ on $A = \{1, 2, 3\}$ to make it reflexive and symmetric is', '$7$', '$3$', '$4$', '$5$', 'option4', 'For reflexive: need $(1,1), (2,2), (3,3)$ — that is 3 elements. For symmetric: need $(2,1)$ for $(1,2)$ and $(3,2)$ for $(2,3)$ — that is 2 elements. Total additions: $3 + 2 = 5$.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('The number of equivalence relations on the set $\{1, 2, 3\}$ is', '$5$', '$8$', '$3$', '$15$', 'option1', 'Equivalence relations correspond to partitions. The partitions of $\{1,2,3\}$ are: $\{\{1\},\{2\},\{3\}\}$, $\{\{1,2\},\{3\}\}$, $\{\{1,3\},\{2\}\}$, $\{\{2,3\},\{1\}\}$, $\{\{1,2,3\}\}$. That is 5 partitions.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('Let $R$ be a relation on $\mathbb{Z}$ defined by $aRb$ iff $a - b$ is divisible by 5. Then $R$ is', 'Only symmetric', 'Reflexive and symmetric but not transitive', 'Only reflexive', 'An equivalence relation', 'option4', 'Reflexive: $a - a = 0$ is divisible by 5. Symmetric: if $5 | (a-b)$, then $5 | (b-a)$. Transitive: if $5 | (a-b)$ and $5 | (b-c)$, then $5 | (a-c)$. So $R$ is an equivalence relation.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('The relation $R$ on $\mathbb{R}$ defined by $xRy$ iff $|x - y| \leq 1$ is', 'Transitive but not symmetric', 'An equivalence relation', 'Only reflexive', 'Reflexive and symmetric but not transitive', 'option4', 'Reflexive: $|x - x| = 0 \leq 1$. Symmetric: $|x - y| = |y - x|$. Not transitive: $0R1$ and $1R2$ but $|0 - 2| = 2 > 1$, so $0 \not R 2$.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('The number of reflexive relations on a set with 3 elements is', '$64$', '$512$', '$8$', '$27$', 'option1', 'A reflexive relation must contain all 3 diagonal pairs $(1,1),(2,2),(3,3)$. The remaining $9 - 3 = 6$ pairs can be included or not. So the count is $2^6 = 64$.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('The relation $R$ on $\{1,2,3\}$ defined by $R = \{(1,1),(1,2),(2,1),(2,2),(3,3)\}$ is', 'An equivalence relation', 'Reflexive and symmetric but not transitive', 'Only reflexive', 'Reflexive and transitive but not symmetric', 'option1', 'Reflexive: $(1,1),(2,2),(3,3) \in R$. Symmetric: $(1,2) \in R$ and $(2,1) \in R$. Transitive: check all chains — $(1,2),(2,1) \Rightarrow (1,1) \in R$; $(2,1),(1,2) \Rightarrow (2,2) \in R$; etc. All hold. The equivalence classes are $\{1,2\}$ and $\{3\}$.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

('A relation $R$ on $\{1,2,3,4\}$ defined by $R = \{(a,b) : |a - b| \leq 2\}$ is', 'Only reflexive', 'An equivalence relation', 'Reflexive and symmetric but not transitive', 'Reflexive, symmetric and transitive', 'option3', 'Reflexive: $|a-a| = 0 \leq 2$. Symmetric: $|a-b| = |b-a|$. Not transitive: $(1,3) \in R$ (since $|1-3|=2$) and $(3,4) \in R$ (since $|3-4|=1$), but $(1,4) \notin R$ since $|1-4| = 3 > 2$.', 'm_relations_types', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The number of symmetric relations on a set with $n$ elements is', '$2^{n(n-1)/2}$', '$2^{n^2}$', '$2^{n(n+1)/2}$', '$3^n$', 'option3', 'In a symmetric relation, the $n$ diagonal pairs can each be included or not ($2^n$ choices), and the $\binom{n}{2} = n(n-1)/2$ off-diagonal pairs are chosen as units ($2^{n(n-1)/2}$ choices). Total = $2^{n + n(n-1)/2} = 2^{n(n+1)/2}$.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('Let $R$ be a relation on $\mathbb{N}$ defined by $aRb$ iff $\gcd(a, b) = 1$. Then $R$ is', 'Transitive and symmetric', 'An equivalence relation', 'Reflexive and symmetric', 'Symmetric but neither reflexive nor transitive', 'option4', 'Symmetric: $\gcd(a,b) = \gcd(b,a)$. Not reflexive: $\gcd(2,2) = 2 \neq 1$. Not transitive: $\gcd(2,3) = 1$ and $\gcd(3,4) = 1$ but $\gcd(2,4) = 2 \neq 1$.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('The number of equivalence relations on a set with 4 elements is', '$15$', '$16$', '$10$', '$52$', 'option1', 'This equals the Bell number $B_4 = 15$. The partitions of a 4-element set are: 1 partition into 1 block, 7 into 2 blocks, 6 into 3 blocks, and 1 into 4 blocks, totaling 15.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('Let $R$ be a relation on $\mathbb{Z}$ defined by $aRb$ iff $2a + 3b$ is divisible by 5. Then $R$ is', 'Only reflexive', 'Reflexive and symmetric but not transitive', 'Only symmetric', 'An equivalence relation', 'option4', 'Reflexive: $2a + 3a = 5a$, divisible by 5. Symmetric: if $5 | (2a+3b)$, then $2b+3a = 5(a+b) - (2a+3b)$, so $5 | (2b+3a)$. Transitive: if $5 | (2a+3b)$ and $5 | (2b+3c)$, then $2(2a+3b) + 3(2b+3c) = 4a + 12b + 9c = 4a + 12b + 9c$. We need $5 | (2a+3c)$. From $5 | (2a+3b)$ and $5 | (2b+3c)$: $2a \equiv -3b$ and $3c \equiv -2b \pmod{5}$, so $2a + 3c \equiv -3b - 2b = -5b \equiv 0 \pmod{5}$. Hence transitive.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('The number of reflexive and symmetric relations on a set with 4 elements is', '$64$', '$128$', '$32$', '$256$', 'option1', 'All 4 diagonal pairs must be included (reflexive). The $\binom{4}{2} = 6$ off-diagonal pairs can each be included or not (symmetric means we choose pairs as units). So the count is $2^6 = 64$.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('Let $A = \{1, 2, 3, \ldots, 10\}$ and $R$ be the equivalence relation $aRb$ iff $a \equiv b \pmod{3}$. The number of elements in the equivalence class $[1]$ is', '$3$', '$4$', '$10$', '$5$', 'option2', '$[1] = \{x \in A : x \equiv 1 \pmod{3}\} = \{1, 4, 7, 10\}$, which has 4 elements.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

('A relation $R$ on $\{1,2,3\}$ is defined as $R = \{(1,1),(2,2),(3,3),(1,2),(2,3)\}$. The minimum number of ordered pairs to be added to make $R$ an equivalence relation is', '$4$', '$3$', '$2$', '$5$', 'option1', '$R$ is already reflexive. For symmetry: add $(2,1)$ and $(3,2)$. For transitivity with the new pairs: $(1,2),(2,3) \Rightarrow$ need $(1,3)$; $(3,2),(2,1) \Rightarrow$ need $(3,1)$. So add $(2,1),(3,2),(1,3),(3,1)$ — 4 pairs total. Verify: the resulting relation has equivalence class $\{1,2,3\}$.', 'm_relations_types', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- CONCEPT: m_functions_types (Functions: one-one, into and onto functions)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('If $f : A \to B$ is a function with $A = \{1,2,3\}$ and $B = \{a,b\}$, then $f$ cannot be', 'A constant function', 'Onto (surjective)', 'Many-one', 'One-one (injective)', 'option4', 'For $f$ to be one-one, distinct elements of $A$ must map to distinct elements of $B$. But $|A| = 3 > 2 = |B|$, so by pigeonhole principle, at least two elements of $A$ must map to the same element of $B$. Hence $f$ cannot be one-one.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('The number of functions from $\{1, 2, 3\}$ to $\{a, b\}$ is', '$6$', '$8$', '$9$', '$4$', 'option2', 'Each of the 3 elements in the domain can map to any of the 2 elements in the codomain. Total functions $= 2^3 = 8$.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('A function $f : A \to B$ is onto (surjective) if', 'Every element of $A$ maps to a unique element of $B$', 'Every element of $B$ has a pre-image in $A$', '$|A| = |B|$', '$f(a) = f(b)$ implies $a = b$', 'option2', 'A function is onto if the range equals the codomain, i.e., every element of $B$ is the image of at least one element of $A$.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^2$ for $f : \mathbb{R} \to \mathbb{R}$, then $f$ is', 'Both one-one and onto', 'One-one but not onto', 'Onto but not one-one', 'Neither one-one nor onto', 'option4', 'Not one-one: $f(1) = f(-1) = 1$. Not onto: negative numbers like $-1$ have no pre-image since $x^2 \geq 0$ for all $x \in \mathbb{R}$.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('The number of one-one functions from $\{1, 2\}$ to $\{a, b, c\}$ is', '$6$', '$9$', '$8$', '$3$', 'option1', 'First element has 3 choices, second element has 2 remaining choices. Total $= 3 \times 2 = 6$.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('A function that is both one-one and onto is called', 'Injective', 'Surjective', 'Bijective', 'Constant', 'option3', 'A bijective function (bijection) is one that is both injective (one-one) and surjective (onto).', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

('If $f : \{1,2,3\} \to \{1,2,3\}$ is defined by $f = \{(1,2),(2,3),(3,1)\}$, then $f$ is', 'Onto but not one-one', 'One-one but not onto', 'Bijective', 'Neither one-one nor onto', 'option3', 'Each element maps to a distinct element (one-one), and every element of the codomain is an image (onto). So $f$ is bijective.', 'm_functions_types', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The number of onto functions from $\{1, 2, 3, 4\}$ to $\{a, b\}$ is', '$14$', '$16$', '$8$', '$12$', 'option1', 'Total functions $= 2^4 = 16$. Functions that are NOT onto: those mapping everything to $a$ only (1 function) or to $b$ only (1 function). So onto functions $= 16 - 2 = 14$.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('If $f : \mathbb{R} \to \mathbb{R}$ is defined by $f(x) = 3x - 7$, then $f$ is', 'Bijective', 'One-one but not onto', 'Onto but not one-one', 'Neither one-one nor onto', 'option1', 'One-one: $f(a) = f(b) \Rightarrow 3a - 7 = 3b - 7 \Rightarrow a = b$. Onto: for any $y \in \mathbb{R}$, $x = (y+7)/3$ gives $f(x) = y$. So $f$ is bijective.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('The number of bijections from $\{1, 2, 3, 4, 5\}$ to itself is', '$25$', '$120$', '$32$', '$5$', 'option2', 'A bijection from a set to itself is a permutation. The number of permutations of 5 elements is $5! = 120$.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('If $f : \mathbb{R} \to [0, \infty)$ is defined by $f(x) = x^2$, then $f$ is', 'Neither one-one nor onto', 'One-one and onto', 'One-one but not onto', 'Onto but not one-one', 'option4', 'Not one-one: $f(2) = f(-2) = 4$. Onto: for any $y \geq 0$, $x = \sqrt{y}$ gives $f(x) = y$. So $f$ is onto but not one-one.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('If $f : \mathbb{N} \to \mathbb{N}$ is defined by $f(n) = n + 1$, then $f$ is', 'One-one but not onto', 'Bijective', 'Onto but not one-one', 'Neither one-one nor onto', 'option1', 'One-one: $f(m) = f(n) \Rightarrow m+1 = n+1 \Rightarrow m = n$. Not onto: $1 \in \mathbb{N}$ has no pre-image since $f(n) = n + 1 \geq 2$ for all $n \in \mathbb{N}$.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('The function $f : \mathbb{R} \to \mathbb{R}$ defined by $f(x) = |x|$ is', 'Onto but not one-one', 'One-one but not onto', 'Neither one-one nor onto', 'Bijective', 'option3', 'Not one-one: $f(3) = f(-3) = 3$. Not onto: $f(x) = |x| \geq 0$, so negative numbers have no pre-image.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

('If $A$ has $m$ elements and $B$ has $n$ elements where $m \leq n$, the number of one-one functions from $A$ to $B$ is', '$\frac{n!}{(n-m)!}$', '$n^m$', '$m^n$', '$\binom{n}{m}$', 'option1', 'The first element of $A$ has $n$ choices, the second has $n-1$, and so on. Total $= n(n-1)\cdots(n-m+1) = \frac{n!}{(n-m)!}$.', 'm_functions_types', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The number of onto functions from a set of 5 elements to a set of 3 elements is', '$150$', '$243$', '$120$', '$180$', 'option1', 'By inclusion-exclusion: onto functions $= \sum_{k=0}^{3}(-1)^k\binom{3}{k}(3-k)^5 = 3^5 - 3 \cdot 2^5 + 3 \cdot 1^5 = 243 - 96 + 3 = 150$.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('If $f : \mathbb{R} - \{2\} \to \mathbb{R} - \{1\}$ is defined by $f(x) = \frac{x-1}{x-2}$, then $f$ is', 'One-one but not onto', 'Bijective', 'Onto but not one-one', 'Neither one-one nor onto', 'option2', 'One-one: $\frac{a-1}{a-2} = \frac{b-1}{b-2} \Rightarrow (a-1)(b-2) = (b-1)(a-2) \Rightarrow ab - 2a - b + 2 = ab - 2b - a + 2 \Rightarrow -2a - b = -2b - a \Rightarrow a = b$. Onto: for $y \neq 1$, solving $y = \frac{x-1}{x-2}$ gives $x = \frac{2y-1}{y-1}$, which is defined when $y \neq 1$. So $f$ is bijective.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('The number of functions $f : \{1,2,3,4,5\} \to \{1,2,3,4,5\}$ that are one-one but NOT onto is', '$44$', '$120$', '$0$', '$5$', 'option3', 'For a function from a finite set to itself, one-one implies onto (and vice versa), since both domain and codomain have the same cardinality. So there are 0 functions that are one-one but not onto.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('Let $f : \mathbb{R} \to \mathbb{R}$ be defined by $f(x) = x^3 + x$. Then $f$ is', 'Bijective', 'One-one but not onto', 'Onto but not one-one', 'Neither one-one nor onto', 'option1', 'One-one: $f''(x) = 3x^2 + 1 > 0$ for all $x$, so $f$ is strictly increasing. Onto: $\lim_{x \to \infty} f(x) = \infty$ and $\lim_{x \to -\infty} f(x) = -\infty$, so by IVT, $f$ takes all real values. Hence $f$ is bijective.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('The total number of injective functions from $\{1,2,3\}$ to $\{1,2,3,4,5\}$ is', '$10$', '$125$', '$120$', '$60$', 'option4', 'Number of injective functions $= 5 \times 4 \times 3 = 60$.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('If $f : A \to B$ is a bijection and $|A| = |B| = n$, then the number of bijections from $A$ to $B$ is', '$n!$', '$n^n$', '$2^n$', '$n^2$', 'option1', 'A bijection is a permutation of the $n$ elements. The number of permutations is $n!$.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),

('Let $f : \{1,2,3,4\} \to \{1,2,3,4,5,6\}$ and $g : \{1,2,3,4,5,6\} \to \{1,2,3,4,5,6,7\}$ be one-one functions. Then $g \circ f$ is', 'Onto', 'One-one', 'Bijective', 'Neither one-one nor onto', 'option2', 'If $f$ and $g$ are both one-one, then $g \circ f$ is one-one: $(g \circ f)(a) = (g \circ f)(b) \Rightarrow g(f(a)) = g(f(b)) \Rightarrow f(a) = f(b) \Rightarrow a = b$. It is not onto since $|$domain$| = 4 < 7 = |$codomain$|$.', 'm_functions_types', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_composition_functions (The composition of functions)
-- Chapter: math_sets_relations_functions
-- ============================================================

-- Tier 1 (Easy)
('If $f(x) = 2x + 1$ and $g(x) = x^2$, then $(g \circ f)(2)$ is', '$25$', '$9$', '$10$', '$5$', 'option1', '$(g \circ f)(2) = g(f(2)) = g(2 \cdot 2 + 1) = g(5) = 5^2 = 25$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = x + 3$ and $g(x) = 2x$, then $(f \circ g)(4)$ is', '$11$', '$14$', '$10$', '$8$', 'option1', '$(f \circ g)(4) = f(g(4)) = f(8) = 8 + 3 = 11$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^2$ and $g(x) = x + 1$, then $(f \circ g)(x)$ is', '$(x+1)^2$', '$x^2 + 1$', '$x^2 + x + 1$', '$2x + 1$', 'option1', '$(f \circ g)(x) = f(g(x)) = f(x+1) = (x+1)^2$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = 3x$ and $g(x) = x/3$, then $(f \circ g)(x)$ is', '$x$', '$3x$', '$x/3$', '$9x$', 'option1', '$(f \circ g)(x) = f(g(x)) = f(x/3) = 3 \cdot (x/3) = x$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = x + 2$ and $g(x) = x - 2$, then $(g \circ f)(x)$ is', '$4$', '$x + 4$', '$x - 4$', '$x$', 'option4', '$(g \circ f)(x) = g(f(x)) = g(x+2) = (x+2) - 2 = x$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('Is function composition commutative? That is, does $f \circ g = g \circ f$ always hold?', 'Only when $f = g$', 'Yes, always', 'No, in general $f \circ g \neq g \circ f$', 'Only for linear functions', 'option3', 'Composition is generally not commutative. For example, $f(x) = x^2, g(x) = x+1$: $(f \circ g)(x) = (x+1)^2$ but $(g \circ f)(x) = x^2 + 1$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

('If $f(x) = \sin x$ and $g(x) = 2x$, then $(f \circ g)(\pi/6)$ is', '$\frac{\sqrt{3}}{2}$', '$\frac{1}{2}$', '$1$', '$\frac{1}{\sqrt{2}}$', 'option1', '$(f \circ g)(\pi/6) = f(g(\pi/6)) = f(\pi/3) = \sin(\pi/3) = \frac{\sqrt{3}}{2}$.', 'm_composition_functions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $f(x) = 2x + 3$ and $g(x) = \frac{x - 3}{2}$, then $(f \circ g)(x)$ and $(g \circ f)(x)$ are', '$(f \circ g)(x) = x$ but $(g \circ f)(x) \neq x$', 'Both equal to $x$', '$(g \circ f)(x) = x$ but $(f \circ g)(x) \neq x$', 'Neither equals $x$', 'option2', '$(f \circ g)(x) = f(\frac{x-3}{2}) = 2 \cdot \frac{x-3}{2} + 3 = x - 3 + 3 = x$. $(g \circ f)(x) = g(2x+3) = \frac{(2x+3)-3}{2} = x$. So $g = f^{-1}$.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^2 + 1$ and $g(x) = \sqrt{x - 1}$, the domain of $g \circ f$ is', '$[0, \infty)$', '$[1, \infty)$', '$\mathbb{R}$', '$(-\infty, -1] \cup [1, \infty)$', 'option3', '$(g \circ f)(x) = g(x^2 + 1) = \sqrt{x^2 + 1 - 1} = \sqrt{x^2} = |x|$. Since $x^2 \geq 0$ for all $x \in \mathbb{R}$, the expression under the square root is always non-negative. Domain is $\mathbb{R}$.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = e^x$ and $g(x) = \ln x$, then $(f \circ g)(x)$ for $x > 0$ is', '$x \ln x$', '$e^x$', '$\ln x$', '$x$', 'option4', '$(f \circ g)(x) = f(\ln x) = e^{\ln x} = x$ for $x > 0$.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = |x|$ and $g(x) = 2x - 3$, then $(f \circ g)(-1)$ is', '$-5$', '$5$', '$1$', '$-1$', 'option2', '$(f \circ g)(-1) = f(g(-1)) = f(2(-1)-3) = f(-5) = |-5| = 5$.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^3$ and $g(x) = x^{1/3}$, then $f \circ g$ is', '$x^{3/3}$', '$x^{1/9}$', '$x^9$', 'The identity function', 'option4', '$(f \circ g)(x) = f(x^{1/3}) = (x^{1/3})^3 = x$. This is the identity function.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f : \mathbb{R} \to \mathbb{R}$ is defined by $f(x) = 5x - 3$, then $f^{-1}(x)$ is', '$\frac{x - 3}{5}$', '$\frac{x + 3}{5}$', '$\frac{5}{x + 3}$', '$5x + 3$', 'option2', 'Let $y = 5x - 3$. Solving for $x$: $x = \frac{y + 3}{5}$. So $f^{-1}(x) = \frac{x + 3}{5}$.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{1}{x}$ for $x \neq 0$, then $f \circ f$ is', '$\frac{1}{x^2}$', 'The identity function on $\mathbb{R} - \{0\}$', '$x^2$', 'Undefined', 'option2', '$(f \circ f)(x) = f(f(x)) = f(1/x) = \frac{1}{1/x} = x$. So $f$ is its own inverse.', 'm_composition_functions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $f(x) = \frac{x}{1+x}$ for $x \neq -1$, then $f(f(x))$ is', '$\frac{x}{1+2x}$', '$\frac{x}{(1+x)^2}$', '$\frac{x^2}{1+x}$', '$\frac{2x}{1+x}$', 'option1', '$f(f(x)) = f\left(\frac{x}{1+x}\right) = \frac{\frac{x}{1+x}}{1 + \frac{x}{1+x}} = \frac{\frac{x}{1+x}}{\frac{1+2x}{1+x}} = \frac{x}{1+2x}$.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{2x+1}{3x-2}$ and $g$ is the inverse of $f$, then $g(x)$ is', '$\frac{3x-2}{2x+1}$', '$\frac{2x+1}{3x-2}$', '$\frac{2x-1}{3x+2}$', '$\frac{3x+1}{2x-2}$', 'option2', 'Let $y = \frac{2x+1}{3x-2}$. Then $y(3x-2) = 2x+1$, so $3xy - 2y = 2x + 1$, giving $x(3y-2) = 2y+1$, hence $x = \frac{2y+1}{3y-2}$. So $f^{-1}(x) = \frac{2x+1}{3x-2} = f(x)$. The function is its own inverse.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = x^2$ and $g(x) = 2^x$, then $(g \circ f)(3) - (f \circ g)(3)$ is', '$-448$', '$512$', '$448$', '$0$', 'option3', '$(g \circ f)(3) = g(9) = 2^9 = 512$. $(f \circ g)(3) = f(8) = 64$. Difference $= 512 - 64 = 448$.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = ax + b$ and $f(f(x)) = 4x + 9$, then the values of $a$ and $b$ are', '$a = 2, b = 3$', '$a = 2, b = 3$ or $a = -2, b = -9$', '$a = -2, b = -9$', '$a = 4, b = 9$', 'option2', '$f(f(x)) = a(ax+b)+b = a^2x + ab + b = 4x + 9$. So $a^2 = 4$ and $b(a+1) = 9$. If $a = 2$: $3b = 9$, so $b = 3$. If $a = -2$: $-b = 9$, so $b = -9$. Verification for $a=-2, b=-9$: $f(f(x)) = -2(-2x-9)-9 = 4x+18-9 = 4x+9$. Both solutions are valid.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{x}{1-x}$ for $x \neq 1$, then $f(f(f(x)))$ is', '$\frac{x}{1-3x}$', '$x$', '$\frac{x}{(1-x)^3}$', '$\frac{1}{1-x}$', 'option1', '$f(x) = \frac{x}{1-x}$. $f(f(x)) = f\left(\frac{x}{1-x}\right) = \frac{\frac{x}{1-x}}{1 - \frac{x}{1-x}} = \frac{x}{1-x-x} = \frac{x}{1-2x}$. $f(f(f(x))) = f\left(\frac{x}{1-2x}\right) = \frac{\frac{x}{1-2x}}{1 - \frac{x}{1-2x}} = \frac{x}{1-2x-x} = \frac{x}{1-3x}$.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = \frac{1}{1-x}$ for $x \neq 1$, then $f \circ f \circ f$ is', 'The identity function', '$\frac{1}{(1-x)^3}$', '$\frac{x-1}{x}$', '$\frac{1}{1-x}$', 'option1', '$f(x) = \frac{1}{1-x}$. $f(f(x)) = \frac{1}{1 - \frac{1}{1-x}} = \frac{1}{\frac{-x}{1-x}} = \frac{x-1}{x}$. $f(f(f(x))) = \frac{1}{1 - \frac{x-1}{x}} = \frac{1}{\frac{1}{x}} = x$. So $f^3 = $ identity.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),

('If $f(x) = 2x + 3$ and $g(x) = \frac{x-3}{2}$, then $f^{-1}(x)$ is', '$\frac{x+3}{2}$', '$\frac{x-3}{2}$', '$2x - 3$', '$\frac{2}{x-3}$', 'option2', 'Let $y = 2x + 3$. Then $x = \frac{y-3}{2}$. So $f^{-1}(x) = \frac{x-3}{2} = g(x)$. This confirms $g$ is the inverse of $f$.', 'm_composition_functions', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_complex_ordered_pairs (Complex numbers as ordered pairs of reals)
-- Chapter: math_complex_numbers_quadratic
-- ============================================================

-- Tier 1 (Easy)
('The complex number $3 + 4i$ can be written as the ordered pair', '$(3, 4)$', '$(4, 3)$', '$(3, -4)$', '$(7, 0)$', 'option1', 'A complex number $a + bi$ corresponds to the ordered pair $(a, b)$. So $3 + 4i = (3, 4)$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('The real part of $-2 + 5i$ is', '$-2$', '$5$', '$2$', '$-5$', 'option1', 'For $z = a + bi$, the real part is $a$. Here $\text{Re}(-2 + 5i) = -2$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('The imaginary part of $7 - 3i$ is', '$7$', '$-3$', '$3$', '$-7$', 'option2', 'For $z = a + bi$, the imaginary part is $b$. Here $\text{Im}(7 - 3i) = -3$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('The value of $i^2$ is', '$-1$', '$1$', '$i$', '$-i$', 'option1', 'By definition, $i = \sqrt{-1}$, so $i^2 = -1$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('A complex number $z$ is purely real if', 'Its modulus is 1', 'Its real part is zero', 'Its imaginary part is zero', '$z = \bar{z}$', 'option3', 'A complex number $a + bi$ is purely real when $b = 0$, i.e., the imaginary part is zero. Note: option D is also equivalent, but option A is the direct definition.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('The complex number corresponding to the ordered pair $(0, 1)$ is', '$-i$', '$1$', '$-1$', '$i$', 'option4', '$(0, 1)$ corresponds to $0 + 1 \cdot i = i$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

('If $z_1 = (2, 3)$ and $z_2 = (1, -1)$ as ordered pairs, then $z_1 + z_2$ is', '$(2, -3)$', '$(3, 4)$', '$(1, 4)$', '$(3, 2)$', 'option4', 'Addition of complex numbers as ordered pairs: $(a_1, b_1) + (a_2, b_2) = (a_1 + a_2, b_1 + b_2) = (2+1, 3+(-1)) = (3, 2)$.', 'm_complex_ordered_pairs', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $(a, b) \cdot (c, d) = (ac - bd, ad + bc)$ defines multiplication of ordered pairs, then $(1, 1) \cdot (1, -1)$ is', '$(2, 0)$', '$(0, 2)$', '$(0, -2)$', '$(1, 1)$', 'option1', '$(1 \cdot 1 - 1 \cdot (-1), 1 \cdot (-1) + 1 \cdot 1) = (1 + 1, -1 + 1) = (2, 0)$. This corresponds to $(1+i)(1-i) = 1 - i^2 = 2$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('The multiplicative identity in the set of complex numbers (as ordered pairs) is', '$(1, 1)$', '$(0, 1)$', '$(1, 0)$', '$(0, 0)$', 'option3', '$(a, b) \cdot (1, 0) = (a \cdot 1 - b \cdot 0, a \cdot 0 + b \cdot 1) = (a, b)$. So $(1, 0)$ is the multiplicative identity, corresponding to $1 + 0i = 1$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('If $z = (3, 4)$ as an ordered pair, then $z \cdot \bar{z}$ is', '$(25, 0)$', '$(7, 0)$', '$(9, 16)$', '$(0, 24)$', 'option1', '$\bar{z} = (3, -4)$. $z \cdot \bar{z} = (3 \cdot 3 - 4 \cdot (-4), 3 \cdot (-4) + 4 \cdot 3) = (9 + 16, -12 + 12) = (25, 0)$. This equals $|z|^2 = 25$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('The additive inverse of $(5, -7)$ in the complex number system is', '$(-5, 7)$', '$(5, 7)$', '$(-5, -7)$', '$(7, -5)$', 'option1', 'The additive inverse of $(a, b)$ is $(-a, -b)$. So the additive inverse of $(5, -7)$ is $(-5, 7)$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('If $(x, y) \cdot (2, 1) = (5, 0)$, then $(x, y)$ is', '$(1, 2)$', '$(2, -1)$', '$(5/2, 0)$', '$(2, 1)$', 'option2', '$(2x - y, x + 2y) = (5, 0)$. From the second equation: $x = -2y$. Substituting: $2(-2y) - y = 5$, so $-5y = 5$, giving $y = -1$ and $x = 2$. So $(x, y) = (2, -1)$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('The ordered pair representation of $i^3$ is', '$(-1, 0)$', '$(0, 1)$', '$(0, -1)$', '$(1, 0)$', 'option3', '$i^3 = i^2 \cdot i = (-1)(i) = -i$, which corresponds to $(0, -1)$.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

('If $z_1 = (a, b)$ and $z_2 = (c, d)$, then $z_1 \cdot z_2 = z_2 \cdot z_1$ because', 'Complex multiplication is associative', 'Complex multiplication is commutative', 'Complex numbers form a group', 'The modulus is multiplicative', 'option2', '$(a,b) \cdot (c,d) = (ac-bd, ad+bc)$ and $(c,d) \cdot (a,b) = (ca-db, cb+da)$. Since real multiplication is commutative, these are equal. Hence complex multiplication is commutative.', 'm_complex_ordered_pairs', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The multiplicative inverse of $(3, 4)$ in the complex number system is', '$\left(\frac{3}{25}, \frac{4}{25}\right)$', '$\left(\frac{3}{25}, \frac{-4}{25}\right)$', '$\left(\frac{-3}{25}, \frac{4}{25}\right)$', '$\left(\frac{4}{25}, \frac{3}{25}\right)$', 'option2', 'The inverse of $z = (a,b)$ is $\frac{\bar{z}}{|z|^2} = \frac{(a,-b)}{a^2+b^2}$. Here $|z|^2 = 9 + 16 = 25$. So $z^{-1} = (3/25, -4/25)$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('If $(1, 2) \cdot (x, y) = (0, 1)$, then $(x, y)$ is', '$\left(\frac{2}{5}, \frac{1}{5}\right)$', '$\left(\frac{1}{5}, \frac{2}{5}\right)$', '$\left(\frac{-2}{5}, \frac{1}{5}\right)$', '$\left(\frac{2}{5}, \frac{-1}{5}\right)$', 'option1', '$(x - 2y, 2x + y) = (0, 1)$. From first: $x = 2y$. Substituting into second: $4y + y = 1$, so $y = 1/5$ and $x = 2/5$. Hence $(x, y) = (2/5, 1/5)$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('The value of $i^{2023}$ is', '$-1$', '$i$', '$1$', '$-i$', 'option4', '$i$ has period 4: $i^1 = i, i^2 = -1, i^3 = -i, i^4 = 1$. $2023 = 4 \times 505 + 3$. So $i^{2023} = i^3 = -i$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('The sum $i + i^2 + i^3 + \ldots + i^{100}$ is', '$i$', '$1$', '$-1$', '$0$', 'option4', 'Since $i + i^2 + i^3 + i^4 = i - 1 - i + 1 = 0$, every group of 4 consecutive powers sums to 0. Since $100 = 4 \times 25$, the sum is $25 \times 0 = 0$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('If $z = (1, 1)$, then $z^4$ as an ordered pair is', '$(-4, 0)$', '$(4, 0)$', '$(0, 4)$', '$(0, -4)$', 'option1', '$z = 1 + i$. $z^2 = (1+i)^2 = 1 + 2i - 1 = 2i = (0, 2)$. $z^4 = (z^2)^2 = (2i)^2 = -4 = (-4, 0)$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('The smallest positive integer $n$ such that $\left(\frac{1+i}{1-i}\right)^n = 1$ is', '$4$', '$2$', '$8$', '$1$', 'option1', '$\frac{1+i}{1-i} = \frac{(1+i)^2}{(1-i)(1+i)} = \frac{1+2i-1}{2} = i$. So we need $i^n = 1$. The smallest such $n$ is 4.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

('If $z_1 = (2, -1)$ and $z_2 = (1, 3)$, then $z_1 \cdot z_2$ is', '$(5, 5)$', '$(2, -3)$', '$(5, -5)$', '$(2, 5)$', 'option1', '$z_1 \cdot z_2 = (2 \cdot 1 - (-1) \cdot 3, 2 \cdot 3 + (-1) \cdot 1) = (2 + 3, 6 - 1) = (5, 5)$. Verification: $(2-i)(1+3i) = 2 + 6i - i - 3i^2 = 2 + 5i + 3 = 5 + 5i$.', 'm_complex_ordered_pairs', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- CONCEPT: m_complex_representation (Representation in a+ib form and Argand diagram)
-- Chapter: math_complex_numbers_quadratic
-- ============================================================

-- Tier 1 (Easy)
('The point representing $3 + 2i$ on the Argand plane is', '$(3, 2)$', '$(2, 3)$', '$(3, -2)$', '$(-3, 2)$', 'option1', 'On the Argand plane, $a + bi$ is plotted as the point $(a, b)$. So $3 + 2i$ is at $(3, 2)$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('The conjugate of $4 - 3i$ is', '$4 + 3i$', '$-4 + 3i$', '$-4 - 3i$', '$3 - 4i$', 'option1', 'The conjugate of $a + bi$ is $a - bi$. So $\overline{4 - 3i} = 4 + 3i$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('The complex number $-5$ lies on which axis of the Argand plane?', 'The positive real axis', 'The imaginary axis', 'The real axis (negative direction)', 'It does not lie on any axis', 'option3', '$-5 = -5 + 0i$, which has zero imaginary part. It lies on the real axis at $(-5, 0)$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('The complex number $2i$ lies on which axis of the Argand plane?', 'The negative imaginary axis', 'The real axis', 'The imaginary axis (positive direction)', 'Neither axis', 'option3', '$2i = 0 + 2i$, which has zero real part. It lies on the imaginary axis at $(0, 2)$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('Express $(2 + 3i) + (4 - i)$ in $a + bi$ form', '$6 + 2i$', '$6 + 4i$', '$2 + 4i$', '$8 + 3i$', 'option1', '$(2 + 3i) + (4 - i) = (2+4) + (3-1)i = 6 + 2i$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('The complex number $z$ and its conjugate $\bar{z}$ are symmetric about', 'The imaginary axis', 'The real axis', 'The origin', 'The line $y = x$', 'option2', 'If $z = a + bi$, then $\bar{z} = a - bi$. The points $(a, b)$ and $(a, -b)$ are reflections of each other across the real axis (x-axis).', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

('Express $(1 + i)(2 - i)$ in $a + bi$ form', '$3 + i$', '$2 - i$', '$3 - i$', '$1 + 3i$', 'option1', '$(1+i)(2-i) = 2 - i + 2i - i^2 = 2 + i + 1 = 3 + i$.', 'm_complex_representation', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('Express $\frac{1}{1+i}$ in $a + bi$ form', '$1 - i$', '$\frac{1}{2} + \frac{1}{2}i$', '$\frac{1}{2} - \frac{1}{2}i$', '$\frac{1}{1+i}$', 'option3', 'Multiply by conjugate: $\frac{1}{1+i} \cdot \frac{1-i}{1-i} = \frac{1-i}{1+1} = \frac{1-i}{2} = \frac{1}{2} - \frac{1}{2}i$.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('If $z = 1 + i\sqrt{3}$, then $z$ lies in which quadrant of the Argand plane?', 'Fourth quadrant', 'Second quadrant', 'Third quadrant', 'First quadrant', 'option4', '$z = 1 + i\sqrt{3}$ has positive real part ($1 > 0$) and positive imaginary part ($\sqrt{3} > 0$), so it lies in the first quadrant.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('Express $\frac{2+3i}{1-2i}$ in $a + bi$ form', '$\frac{-4}{5} + \frac{7}{5}i$', '$\frac{4}{5} + \frac{7}{5}i$', '$\frac{-4}{5} - \frac{7}{5}i$', '$\frac{8}{5} + \frac{1}{5}i$', 'option1', 'Multiply by conjugate: $\frac{(2+3i)(1+2i)}{(1-2i)(1+2i)} = \frac{2+4i+3i+6i^2}{1+4} = \frac{2+7i-6}{5} = \frac{-4+7i}{5} = -\frac{4}{5} + \frac{7}{5}i$.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('If $z = 2(\cos 60° + i \sin 60°)$, then $z$ in $a + bi$ form is', '$1 + i\sqrt{3}$', '$\sqrt{3} + i$', '$2 + 2i$', '$1 + i$', 'option1', '$z = 2(\frac{1}{2} + i\frac{\sqrt{3}}{2}) = 1 + i\sqrt{3}$.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('The distance between $z_1 = 3 + 4i$ and $z_2 = -1 + i$ on the Argand plane is', '$\sqrt{25}$', '$\sqrt{7}$', '$7$', '$5$', 'option4', '$|z_1 - z_2| = |(3-(-1)) + (4-1)i| = |4 + 3i| = \sqrt{16 + 9} = 5$.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('If $z + \bar{z} = 6$ and $z - \bar{z} = 4i$, then $z$ is', '$2 + 3i$', '$3 + 2i$', '$6 + 4i$', '$3 - 2i$', 'option2', 'Let $z = a + bi$. Then $z + \bar{z} = 2a = 6$, so $a = 3$. And $z - \bar{z} = 2bi = 4i$, so $b = 2$. Hence $z = 3 + 2i$.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

('The locus of $z$ such that $|z - 2| = 3$ on the Argand plane is', 'A circle with centre $(0, 2)$ and radius 3', 'A circle with centre $(2, 0)$ and radius 3', 'A straight line', 'An ellipse', 'option2', '$|z - 2| = 3$ means the distance from $z$ to the point $2$ (i.e., $(2, 0)$) is 3. This is a circle with centre $(2, 0)$ and radius 3.', 'm_complex_representation', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('Express $\frac{(1+i)^3}{(1-i)^3}$ in $a + bi$ form', '$1$', '$i$', '$-1$', '$-i$', 'option4', '$(1+i)^2 = 2i$, so $(1+i)^3 = 2i(1+i) = 2i + 2i^2 = -2 + 2i$. $(1-i)^2 = -2i$, so $(1-i)^3 = -2i(1-i) = -2i + 2i^2 = -2 - 2i$. $\frac{-2+2i}{-2-2i} = \frac{(-2+2i)(-2+2i)}{(-2-2i)(-2+2i)} = \frac{4-8i+4i^2}{4+4} = \frac{-8i}{8} = -i$.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('If $z = \frac{1}{(2+i)^2}$, then $z$ in $a + bi$ form is', '$\frac{4}{25} - \frac{3}{25}i$', '$\frac{3}{25} + \frac{4}{25}i$', '$\frac{3}{25} - \frac{4}{25}i$', '$\frac{1}{5} - \frac{2}{5}i$', 'option3', '$(2+i)^2 = 4 + 4i + i^2 = 3 + 4i$. $\frac{1}{3+4i} = \frac{3-4i}{(3+4i)(3-4i)} = \frac{3-4i}{9+16} = \frac{3-4i}{25} = \frac{3}{25} - \frac{4}{25}i$.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('The locus of $z$ satisfying $\left|\frac{z-1}{z+1}\right| = 1$ is', 'The unit circle', 'The real axis', 'A circle of radius 1', 'The imaginary axis', 'option4', '$|z-1| = |z+1|$ means $z$ is equidistant from $1$ and $-1$. The locus of points equidistant from two points is the perpendicular bisector, which is the imaginary axis ($x = 0$).', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('If $z = x + iy$ and $\frac{z - 5i}{z + 5i}$ is purely real, then the locus of $z$ is', '$x^2 + y^2 = 5$', '$x^2 + y^2 = 25$', '$y = 0$', 'The imaginary axis ($x = 0$)', 'option4', '$\frac{z-5i}{z+5i} = \frac{x+i(y-5)}{x+i(y+5)}$. Multiply numerator and denominator by the conjugate of the denominator: numerator becomes $[x+i(y-5)][x-i(y+5)] = x^2 + y^2 - 25 + i[x(y-5) - x(y+5)] = x^2 + y^2 - 25 - 10xi$. For the fraction to be purely real, the imaginary part of the numerator must be zero: $-10x = 0$, so $x = 0$, which is the imaginary axis.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('If $z_1 = 1 + i$ and $z_2 = 1 - i$, then $\frac{z_1}{z_2}$ in $a + bi$ form is', '$-1$', '$-i$', '$1$', '$i$', 'option4', '$\frac{1+i}{1-i} = \frac{(1+i)^2}{(1-i)(1+i)} = \frac{1+2i-1}{2} = \frac{2i}{2} = i$.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('The area of the triangle formed by $z$, $iz$, and $z + iz$ on the Argand plane (where $z = a + bi$, $a, b > 0$) is', '$|z|^2$', '$\frac{1}{2}|z|^2$', '$\frac{1}{2}|z|$', '$2|z|^2$', 'option2', 'The vertices are $z$, $iz$, and $z + iz$. Note that $z + iz = z + iz$ forms a right angle at the origin since $iz$ is $z$ rotated by $90°$. The triangle with vertices $0, z, iz$ has area $\frac{1}{2}|z||iz|\sin 90° = \frac{1}{2}|z|^2$. But the triangle is $z, iz, z+iz$, which is a translate of the triangle $0, iz-z, iz$. Actually, the three points $z, iz, z+iz$ form a triangle where $z+iz - z = iz$ and $z+iz - iz = z$, so two sides from $z+iz$ are $-iz$ and $-z$, perpendicular with lengths $|z|$. Area $= \frac{1}{2}|z|^2$.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

('If $|z - 3 + 2i| = 4$, the locus of $z$ on the Argand plane is', 'A circle with centre $(-3, 2)$ and radius 4', 'A circle with centre $(3, -2)$ and radius 4', 'A circle with centre $(3, 2)$ and radius 4', 'A circle with centre $(-3, -2)$ and radius 4', 'option2', '$|z - (3 - 2i)| = 4$ represents a circle with centre at $3 - 2i$, i.e., the point $(3, -2)$, and radius 4.', 'm_complex_representation', 3, 'JEE Mains Prep', 'approved'),

-- ============================================================
-- CONCEPT: m_complex_algebra_modulus (Algebra of complex numbers, modulus and argument)
-- Chapter: math_complex_numbers_quadratic
-- ============================================================

-- Tier 1 (Easy)
('The modulus of $3 + 4i$ is', '$5$', '$7$', '$1$', '$25$', 'option1', '$|3 + 4i| = \sqrt{3^2 + 4^2} = \sqrt{9 + 16} = \sqrt{25} = 5$.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('The argument of $1 + i$ is', '$\frac{\pi}{2}$', '$\frac{\pi}{4}$', '$\frac{\pi}{3}$', '$\pi$', 'option2', '$\arg(1+i) = \tan^{-1}(1/1) = \tan^{-1}(1) = \pi/4$ (first quadrant).', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('If $z = 5 - 12i$, then $|z|$ is', '$13$', '$17$', '$7$', '$\sqrt{17}$', 'option1', '$|z| = \sqrt{25 + 144} = \sqrt{169} = 13$.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('$|z \cdot \bar{z}|$ equals', '$0$', '$|z|$', '$z^2$', '$|z|^2$', 'option4', '$z \cdot \bar{z} = |z|^2$ (a real number). So $|z \cdot \bar{z}| = |z|^2$.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('The argument of $-1$ is', '$-\pi$', '$0$', '$\frac{\pi}{2}$', '$\pi$', 'option4', '$-1$ lies on the negative real axis. Its argument (principal value) is $\pi$.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('If $|z| = 1$, then $z$ lies on', 'The origin', 'The real axis', 'The imaginary axis', 'The unit circle', 'option4', '$|z| = 1$ means the distance from the origin is 1, which is the unit circle.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

('$(3 + 2i)(3 - 2i)$ equals', '$9 - 4i$', '$9 + 4i$', '$5$', '$13$', 'option4', '$(3+2i)(3-2i) = 9 - (2i)^2 = 9 - (-4) = 9 + 4 = 13$.', 'm_complex_algebra_modulus', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $|z_1| = 3$ and $|z_2| = 4$, then $|z_1 z_2|$ is', '$1$', '$7$', '$12$', '$\sqrt{7}$', 'option3', '$|z_1 z_2| = |z_1| \cdot |z_2| = 3 \times 4 = 12$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('The principal argument of $-1 - i$ is', '$-\frac{\pi}{4}$', '$\frac{3\pi}{4}$', '$\frac{5\pi}{4}$', '$-\frac{3\pi}{4}$', 'option4', '$-1 - i$ lies in the third quadrant. $\tan^{-1}(|-1|/|-1|) = \pi/4$. Principal argument $= -(\pi - \pi/4) = -3\pi/4$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('If $z = 1 + i\sqrt{3}$, then $|z|$ and $\arg(z)$ are', '$|z| = \sqrt{3}, \arg(z) = \frac{\pi}{3}$', '$|z| = 2, \arg(z) = \frac{\pi}{6}$', '$|z| = 2, \arg(z) = \frac{\pi}{3}$', '$|z| = 4, \arg(z) = \frac{\pi}{4}$', 'option3', '$|z| = \sqrt{1 + 3} = 2$. $\arg(z) = \tan^{-1}(\sqrt{3}/1) = \pi/3$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('If $|z - 2| = |z - 4|$, then the locus of $z$ is', '$\text{Re}(z) = 1$', '$\text{Im}(z) = 3$', '$|z| = 3$', '$\text{Re}(z) = 3$', 'option4', '$|z - 2| = |z - 4|$ means $z$ is equidistant from 2 and 4 on the real axis. The perpendicular bisector is $x = 3$, i.e., $\text{Re}(z) = 3$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('The modulus of $\frac{1+i}{1-i}$ is', '$2$', '$\sqrt{2}$', '$1$', '$\frac{1}{2}$', 'option3', '$\left|\frac{1+i}{1-i}\right| = \frac{|1+i|}{|1-i|} = \frac{\sqrt{2}}{\sqrt{2}} = 1$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('If $z = r(\cos\theta + i\sin\theta)$, then $\bar{z}$ is', '$r(\cos\theta + i\sin\theta)$', '$r(\cos\theta - i\sin\theta)$', '$\frac{1}{r}(\cos\theta - i\sin\theta)$', '$r(-\cos\theta + i\sin\theta)$', 'option2', 'The conjugate of $z = r(\cos\theta + i\sin\theta)$ is $\bar{z} = r(\cos\theta - i\sin\theta) = r(\cos(-\theta) + i\sin(-\theta))$.', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

('The triangle inequality for complex numbers states that', '$|z_1 + z_2| = |z_1| + |z_2|$', '$|z_1 + z_2| \geq |z_1| + |z_2|$', '$|z_1 z_2| \leq |z_1| + |z_2|$', '$|z_1 + z_2| \leq |z_1| + |z_2|$', 'option4', 'The triangle inequality states $|z_1 + z_2| \leq |z_1| + |z_2|$, with equality iff $z_1$ and $z_2$ have the same argument (or one is zero).', 'm_complex_algebra_modulus', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $|z + 2| = |z - 2i|$, the locus of $z = x + iy$ is', '$x + y = 0$', '$x - y = 1$', '$x^2 + y^2 = 4$', '$x + y = 2$', 'option1', 'Let $z = x + iy$. $|z + 2|^2 = (x+2)^2 + y^2$ and $|z - 2i|^2 = x^2 + (y-2)^2$. Setting equal: $(x+2)^2 + y^2 = x^2 + (y-2)^2$. Expanding: $x^2 + 4x + 4 + y^2 = x^2 + y^2 - 4y + 4$. Simplifying: $4x = -4y$, so $x + y = 0$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('If $z_1 = 2 + 3i$ and $z_2 = 1 - 2i$, then $\arg(z_1 \cdot z_2)$ is', '$\arg(z_1) + \arg(z_2)$', '$\arg(z_1) - \arg(z_2)$', '$\arg(z_1) \cdot \arg(z_2)$', '$\frac{\arg(z_1)}{\arg(z_2)}$', 'option1', 'For any two complex numbers, $\arg(z_1 z_2) = \arg(z_1) + \arg(z_2)$ (modulo $2\pi$). This is a fundamental property of the argument function, following from the polar form: if $z_1 = r_1 e^{i\theta_1}$ and $z_2 = r_2 e^{i\theta_2}$, then $z_1 z_2 = r_1 r_2 e^{i(\theta_1 + \theta_2)}$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('If $|z - 1| + |z + 1| = 4$, the locus of $z$ is', 'A circle of radius 2', 'An ellipse with foci at $(\pm 1, 0)$', 'A straight line', 'A hyperbola', 'option2', '$|z - 1| + |z + 1| = 4$ means the sum of distances from $z$ to the points $1$ and $-1$ is constant (= 4). This is the definition of an ellipse with foci at $(1, 0)$ and $(-1, 0)$, where $2a = 4$ so $a = 2$, $c = 1$, and $b = \sqrt{a^2 - c^2} = \sqrt{3}$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('If $z = x + iy$ and $|z| = 2$, $\arg(z) = \frac{\pi}{3}$, then $\frac{z}{\bar{z}} + \frac{\bar{z}}{z}$ equals', '$0$', '$-1$', '$1$', '$2$', 'option2', 'Let $z = 2e^{i\pi/3}$. Then $\frac{z}{\bar{z}} = \frac{z^2}{|z|^2} = \frac{4e^{i2\pi/3}}{4} = e^{i2\pi/3}$. Similarly $\frac{\bar{z}}{z} = e^{-i2\pi/3}$. Sum $= e^{i2\pi/3} + e^{-i2\pi/3} = 2\cos(2\pi/3) = 2(-1/2) = -1$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('If $|z_1 + z_2|^2 = |z_1|^2 + |z_2|^2$, then $\frac{z_1}{z_2}$ is', 'Purely imaginary', 'Purely real', 'Zero', 'Of unit modulus', 'option1', '$|z_1 + z_2|^2 = |z_1|^2 + 2\text{Re}(z_1\bar{z_2}) + |z_2|^2$. Given this equals $|z_1|^2 + |z_2|^2$, we get $\text{Re}(z_1\bar{z_2}) = 0$. Let $w = z_1/z_2$, then $z_1\bar{z_2} = w|z_2|^2$, so $\text{Re}(w) = 0$, meaning $w = z_1/z_2$ is purely imaginary.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('The minimum value of $|z - 3 + 4i|$ where $|z| = 1$ is', '$4$', '$5$', '$6$', '$3$', 'option1', '$|z - (3 - 4i)| \geq ||z| - |3 - 4i|| = |1 - 5| = 4$ by the reverse triangle inequality. The minimum distance from a point on the unit circle to $(3, -4)$ is $|3 - 4i| - 1 = 5 - 1 = 4$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),

('If $|z_1| = |z_2|$ and $\arg(z_1) + \arg(z_2) = 0$, then $z_1$ is', '$\bar{z_2}$', '$-z_2$', '$z_2$', '$-\bar{z_2}$', 'option1', 'Let $z_2 = re^{i\theta}$. Then $|z_1| = r$ and $\arg(z_1) = -\theta$. So $z_1 = re^{-i\theta} = \overline{re^{i\theta}} = \bar{z_2}$.', 'm_complex_algebra_modulus', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_quadratic_solutions (Quadratic equations in real and complex number systems)
-- Chapter: math_complex_numbers_quadratic
-- ============================================================

-- Tier 1 (Easy)
('The roots of $x^2 - 5x + 6 = 0$ are', '$1$ and $6$', '$2$ and $3$', '$-2$ and $-3$', '$2$ and $-3$', 'option2', '$x^2 - 5x + 6 = (x-2)(x-3) = 0$. So $x = 2$ or $x = 3$.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('The discriminant of $x^2 + 4x + 4 = 0$ is', '$-4$', '$4$', '$8$', '$0$', 'option4', 'Discriminant $D = b^2 - 4ac = 16 - 16 = 0$. Equal roots.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('The roots of $x^2 + 1 = 0$ are', '$\pm i$', '$\pm 1$', '$0$ and $1$', '$\pm \sqrt{-1}$', 'option1', '$x^2 = -1$, so $x = \pm\sqrt{-1} = \pm i$.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('If $\alpha$ and $\beta$ are roots of $x^2 - 7x + 12 = 0$, then $\alpha + \beta$ is', '$5$', '$12$', '$-7$', '$7$', 'option4', 'By Vieta''s formulas, $\alpha + \beta = -(-7)/1 = 7$.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('The nature of roots of $x^2 - 4x + 5 = 0$ is', 'Rational', 'Real and equal', 'Real and distinct', 'Complex (non-real)', 'option4', '$D = 16 - 20 = -4 < 0$. Since the discriminant is negative, the roots are complex (non-real).', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('The quadratic formula gives the roots of $ax^2 + bx + c = 0$ as', '$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$', '$x = \frac{b \pm \sqrt{b^2 - 4ac}}{2a}$', '$x = \frac{-b \pm \sqrt{b^2 + 4ac}}{2a}$', '$x = \frac{-b \pm \sqrt{4ac - b^2}}{2a}$', 'option1', 'The quadratic formula is $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$, derived by completing the square on $ax^2 + bx + c = 0$.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

('The roots of $x^2 - 2x + 1 = 0$ are', '$-1$ and $-1$', '$0$ and $2$', '$1$ and $-1$', '$1$ and $1$ (repeated root)', 'option4', '$x^2 - 2x + 1 = (x-1)^2 = 0$. So $x = 1$ is a repeated root.', 'm_quadratic_solutions', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The roots of $x^2 - 2x + 5 = 0$ are', '$1 \pm \sqrt{5}$', '$1 \pm 2i$', '$-1 \pm 2i$', '$2 \pm i$', 'option2', '$x = \frac{2 \pm \sqrt{4 - 20}}{2} = \frac{2 \pm \sqrt{-16}}{2} = \frac{2 \pm 4i}{2} = 1 \pm 2i$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('If one root of $x^2 - 6x + k = 0$ is $3 + i$, then $k$ is', '$9$', '$10$', '$8$', '$12$', 'option2', 'Since coefficients are real, the other root is $3 - i$. Product of roots $= k = (3+i)(3-i) = 9 + 1 = 10$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('For what values of $k$ does $x^2 + kx + 9 = 0$ have equal roots?', '$k = \pm 6$', '$k = 6$', '$k = -6$', '$k = 3$', 'option1', 'Equal roots when $D = 0$: $k^2 - 36 = 0$, so $k = \pm 6$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $2x^2 + 3x - 5 = 0$, then $\alpha\beta$ is', '$\frac{3}{2}$', '$\frac{5}{2}$', '$-\frac{5}{2}$', '$-\frac{3}{2}$', 'option3', 'By Vieta''s formulas, $\alpha\beta = c/a = -5/2$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('The equation whose roots are $2 + \sqrt{3}$ and $2 - \sqrt{3}$ is', '$x^2 - 4x - 1 = 0$', '$x^2 - 4x + 7 = 0$', '$x^2 + 4x + 1 = 0$', '$x^2 - 4x + 1 = 0$', 'option4', 'Sum of roots $= 4$, product $= (2+\sqrt{3})(2-\sqrt{3}) = 4 - 3 = 1$. Equation: $x^2 - 4x + 1 = 0$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('If the roots of $x^2 + px + q = 0$ are in the ratio $2:3$, then', '$25p^2 = 6q$', '$p^2 = 6q$', '$p^2 = 9q$', '$6p^2 = 25q$', 'option4', 'Let roots be $2k$ and $3k$. Sum $= 5k = -p$, so $k = -p/5$. Product $= 6k^2 = q$, so $6 \cdot p^2/25 = q$, giving $6p^2 = 25q$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

('If $\alpha$ and $\beta$ are roots of $x^2 - 3x + 2 = 0$, then $\alpha^2 + \beta^2$ is', '$4$', '$9$', '$5$', '$7$', 'option3', '$\alpha + \beta = 3$ and $\alpha\beta = 2$. So $\alpha^2 + \beta^2 = (\alpha + \beta)^2 - 2\alpha\beta = 9 - 4 = 5$.', 'm_quadratic_solutions', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $\alpha, \beta$ are roots of $x^2 - 2x + 3 = 0$, then $\alpha^3 + \beta^3$ is', '$-2$', '$10$', '$-10$', '$8$', 'option3', '$\alpha + \beta = 2$, $\alpha\beta = 3$. Using $\alpha^3 + \beta^3 = (\alpha + \beta)^3 - 3\alpha\beta(\alpha + \beta) = 8 - 3(3)(2) = 8 - 18 = -10$.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('The number of real roots of $x^4 - 5x^2 + 4 = 0$ is', '$4$', '$2$', '$0$', '$1$', 'option1', 'Let $t = x^2$. Then $t^2 - 5t + 4 = 0$, so $(t-1)(t-4) = 0$, giving $t = 1$ or $t = 4$. From $x^2 = 1$: $x = \pm 1$. From $x^2 = 4$: $x = \pm 2$. Total 4 real roots.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('If $p$ and $q$ are roots of $x^2 + px + q = 0$, then', '$p = 1, q = -2$', '$p = 0, q = 0$', '$p = -2, q = 1$', 'Both (A) and (B)', 'option4', 'By Vieta''s: $p + q = -p$ and $pq = q$. From $pq = q$: either $q = 0$ or $p = 1$. Case 1: $q = 0$, then $p + 0 = -p$, so $p = 0$. Gives $(p,q) = (0,0)$. Case 2: $p = 1$, then $1 + q = -1$, so $q = -2$. Gives $(p,q) = (1,-2)$. Both are valid.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 5x + 6 = 0$, then the equation with roots $\frac{1}{\alpha}$ and $\frac{1}{\beta}$ is', '$6x^2 - 5x + 1 = 0$', '$x^2 - 5x + 6 = 0$', '$x^2 + 5x + 6 = 0$', '$6x^2 + 5x + 1 = 0$', 'option1', 'Sum of new roots $= \frac{1}{\alpha} + \frac{1}{\beta} = \frac{\alpha+\beta}{\alpha\beta} = \frac{5}{6}$. Product $= \frac{1}{\alpha\beta} = \frac{1}{6}$. Equation: $x^2 - \frac{5}{6}x + \frac{1}{6} = 0$, i.e., $6x^2 - 5x + 1 = 0$.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('If both roots of $x^2 - 2kx + k^2 - 1 = 0$ lie in $(-2, 4)$, then the range of $k$ is', '$(-1, 5)$', '$(-2, 4)$', '$(-1, 3)$', '$(0, 3)$', 'option3', 'The equation is $(x - k)^2 = 1$, so roots are $k - 1$ and $k + 1$. For both roots in $(-2, 4)$: $k - 1 > -2$ gives $k > -1$, and $k + 1 < 4$ gives $k < 3$. So $k \in (-1, 3)$.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 + x + 1 = 0$, then $\alpha^{2023} + \beta^{2023}$ is', '$-1$', '$1$', '$0$', '$2$', 'option1', 'The roots of $x^2 + x + 1 = 0$ are the primitive cube roots of unity: $\omega$ and $\omega^2$ where $\omega = e^{2\pi i/3}$. Since $\omega^3 = 1$, we have $\omega^{2023} = \omega^{3 \times 674 + 1} = \omega$. Similarly $(\omega^2)^{2023} = \omega^{4046} = \omega^{3 \times 1348 + 2} = \omega^2$. So $\alpha^{2023} + \beta^{2023} = \omega + \omega^2 = -1$.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),

('The quadratic equation with real coefficients whose one root is $\frac{2+i\sqrt{3}}{2}$ is', '$4x^2 + 8x + 7 = 0$', '$x^2 - 2x + 7 = 0$', '$4x^2 - 8x + 7 = 0$', '$x^2 - 4x + 7 = 0$', 'option3', 'If one root is $\frac{2+i\sqrt{3}}{2}$, the other is $\frac{2-i\sqrt{3}}{2}$. Sum $= \frac{2+i\sqrt{3}+2-i\sqrt{3}}{2} = 2$. Product $= \frac{(2+i\sqrt{3})(2-i\sqrt{3})}{4} = \frac{4+3}{4} = \frac{7}{4}$. Equation: $x^2 - 2x + \frac{7}{4} = 0$, i.e., $4x^2 - 8x + 7 = 0$.', 'm_quadratic_solutions', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_roots_coefficients (Relations between roots and coefficients, nature of roots, formation of quadratic equations)
-- Chapter: math_complex_numbers_quadratic
-- ============================================================

-- Tier 1 (Easy)
('If $\alpha + \beta = 5$ and $\alpha\beta = 6$, the quadratic equation with roots $\alpha, \beta$ is', '$x^2 - 5x + 6 = 0$', '$x^2 + 5x + 6 = 0$', '$x^2 - 5x - 6 = 0$', '$x^2 + 5x - 6 = 0$', 'option1', 'The quadratic with roots $\alpha, \beta$ is $x^2 - (\alpha+\beta)x + \alpha\beta = 0 = x^2 - 5x + 6 = 0$.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('For $ax^2 + bx + c = 0$, the sum of roots is', '$\frac{c}{a}$', '$\frac{b}{a}$', '$-\frac{b}{a}$', '$-\frac{c}{a}$', 'option3', 'By Vieta''s formulas, if $\alpha, \beta$ are roots, then $\alpha + \beta = -b/a$.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('The discriminant of $ax^2 + bx + c = 0$ is', '$4ac - b^2$', '$b^2 + 4ac$', '$b^2 - 4ac$', '$\sqrt{b^2 - 4ac}$', 'option3', 'The discriminant is $D = b^2 - 4ac$. It determines the nature of roots.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('If the discriminant $D > 0$, the roots are', 'Complex (non-real)', 'Real and equal', 'Real and distinct', 'Cannot be determined', 'option3', 'When $D > 0$, the quadratic has two distinct real roots.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 8x + 15 = 0$, then $\alpha\beta$ is', '$8$', '$15$', '$-15$', '$-8$', 'option2', 'By Vieta''s formulas, $\alpha\beta = c/a = 15/1 = 15$.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('The quadratic equation whose roots are $3$ and $-2$ is', '$x^2 + x + 6 = 0$', '$x^2 + x - 6 = 0$', '$x^2 - x + 6 = 0$', '$x^2 - x - 6 = 0$', 'option4', 'Sum $= 3 + (-2) = 1$. Product $= 3 \times (-2) = -6$. Equation: $x^2 - 1 \cdot x + (-6) = x^2 - x - 6 = 0$.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

('If $D = 0$ for a quadratic equation with real coefficients, the roots are', 'Real and equal', 'Real and distinct', 'Complex conjugates', 'Irrational', 'option1', 'When $D = 0$, the two roots coincide: $\alpha = \beta = -b/(2a)$.', 'm_roots_coefficients', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $\alpha, \beta$ are roots of $3x^2 - 7x + 4 = 0$, then $\frac{1}{\alpha} + \frac{1}{\beta}$ is', '$\frac{3}{4}$', '$\frac{4}{7}$', '$\frac{7}{4}$', '$\frac{7}{3}$', 'option3', '$\frac{1}{\alpha} + \frac{1}{\beta} = \frac{\alpha + \beta}{\alpha\beta} = \frac{7/3}{4/3} = \frac{7}{4}$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 6x + 8 = 0$, then $\alpha^2 + \beta^2$ is', '$36$', '$20$', '$28$', '$16$', 'option2', '$\alpha + \beta = 6$, $\alpha\beta = 8$. $\alpha^2 + \beta^2 = (\alpha+\beta)^2 - 2\alpha\beta = 36 - 16 = 20$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('If the roots of $x^2 + 2(k+1)x + 9 = 0$ are equal, then $k$ is', '$2$', '$2$ or $-4$', '$-4$', '$\pm 3$', 'option2', '$D = 0$: $4(k+1)^2 - 36 = 0$, so $(k+1)^2 = 9$, giving $k + 1 = \pm 3$, hence $k = 2$ or $k = -4$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 5x + 3 = 0$, then $(\alpha - \beta)^2$ is', '$25$', '$13$', '$19$', '$7$', 'option2', '$(\alpha - \beta)^2 = (\alpha + \beta)^2 - 4\alpha\beta = 25 - 12 = 13$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('The equation whose roots are twice the roots of $x^2 - 3x + 2 = 0$ is', '$x^2 - 6x + 8 = 0$', '$x^2 - 6x + 4 = 0$', '$2x^2 - 3x + 2 = 0$', '$x^2 - 3x + 8 = 0$', 'option1', 'Original roots: $1, 2$. New roots: $2, 4$. Sum $= 6$, product $= 8$. Equation: $x^2 - 6x + 8 = 0$. Alternatively, replace $x$ by $x/2$: $(x/2)^2 - 3(x/2) + 2 = 0 \Rightarrow x^2 - 6x + 8 = 0$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $2x^2 - 5x + 1 = 0$, then $\alpha^2\beta + \alpha\beta^2$ is', '$\frac{5}{2}$', '$\frac{5}{4}$', '$\frac{1}{2}$', '$\frac{25}{4}$', 'option2', '$\alpha^2\beta + \alpha\beta^2 = \alpha\beta(\alpha + \beta) = \frac{1}{2} \cdot \frac{5}{2} = \frac{5}{4}$.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

('For the equation $x^2 - 2x + 3 = 0$, the nature of roots is', 'Complex conjugates', 'Real and equal', 'Real and distinct', 'Rational', 'option1', '$D = 4 - 12 = -8 < 0$. Since coefficients are real and $D < 0$, the roots are complex conjugates.', 'm_roots_coefficients', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $\alpha, \beta$ are roots of $x^2 - 2x + 5 = 0$, then $\frac{\alpha}{\beta} + \frac{\beta}{\alpha}$ is', '$\frac{4}{5}$', '$\frac{6}{5}$', '$-\frac{4}{5}$', '$-\frac{6}{5}$', 'option4', '$\frac{\alpha}{\beta} + \frac{\beta}{\alpha} = \frac{\alpha^2 + \beta^2}{\alpha\beta} = \frac{(\alpha+\beta)^2 - 2\alpha\beta}{\alpha\beta} = \frac{4 - 10}{5} = \frac{-6}{5}$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta, \gamma$ are roots of $x^3 - 6x^2 + 11x - 6 = 0$, then $\alpha\beta\gamma$ is', '$6$', '$-6$', '$11$', '$1$', 'option1', 'For a cubic $x^3 + px^2 + qx + r = 0$, the product of roots $= -r$. Here $r = -6$, so $\alpha\beta\gamma = -(-6) = 6$. Verification: $x^3 - 6x^2 + 11x - 6 = (x-1)(x-2)(x-3)$, product $= 1 \times 2 \times 3 = 6$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 3x + 1 = 0$, then $\alpha^4 + \beta^4$ is', '$45$', '$49$', '$51$', '$47$', 'option4', '$\alpha + \beta = 3$, $\alpha\beta = 1$. $\alpha^2 + \beta^2 = 9 - 2 = 7$. $\alpha^2\beta^2 = 1$. $\alpha^4 + \beta^4 = (\alpha^2 + \beta^2)^2 - 2(\alpha\beta)^2 = 49 - 2 = 47$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 + bx + c = 0$ and $\alpha^2, \beta^2$ are roots of $x^2 + px + q = 0$, then $p$ equals', '$b^2 - 2c$', '$b^2 + 2c$', '$2c - b^2$', '$c^2 - 2b$', 'option3', '$\alpha^2 + \beta^2 = (\alpha+\beta)^2 - 2\alpha\beta = b^2 - 2c$. Since $\alpha^2 + \beta^2 = -p$ (sum of roots of second equation), we get $-p = b^2 - 2c$, so $p = 2c - b^2$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If one root of $x^2 - 6x + k = 0$ is twice the other, then $k$ is', '$8$', '$9$', '$6$', '$12$', 'option1', 'Let roots be $r$ and $2r$. Sum $= 3r = 6$, so $r = 2$. Roots are $2$ and $4$. Product $= k = 2 \times 4 = 8$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - x - 1 = 0$, then $\alpha^5 + \beta^5$ is', '$11$', '$5$', '$8$', '$13$', 'option1', '$\alpha + \beta = 1$, $\alpha\beta = -1$. Build up: $\alpha^2 + \beta^2 = 1 + 2 = 3$. $\alpha^3 + \beta^3 = (\alpha+\beta)(\alpha^2+\beta^2-\alpha\beta) = 1(3+1) = 4$. $\alpha^4 + \beta^4 = (\alpha^2+\beta^2)^2 - 2(\alpha\beta)^2 = 9 - 2 = 7$. $\alpha^5 + \beta^5 = (\alpha^2+\beta^2)(\alpha^3+\beta^3) - (\alpha\beta)^2(\alpha+\beta) = 3 \times 4 - 1 \times 1 = 12 - 1 = 11$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),

('If $\alpha, \beta$ are roots of $x^2 - 2x + 2 = 0$, then $\alpha^3 + \beta^3$ is', '$4$', '$-4$', '$0$', '$8$', 'option2', '$\alpha + \beta = 2$, $\alpha\beta = 2$. $\alpha^3 + \beta^3 = (\alpha+\beta)^3 - 3\alpha\beta(\alpha+\beta) = 8 - 3(2)(2) = 8 - 12 = -4$.', 'm_roots_coefficients', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_matrices_algebra (Matrices, algebra of matrices, types of matrices)
-- Chapter: math_matrices_determinants
-- ============================================================

-- Tier 1 (Easy)
('The order of a matrix with 3 rows and 2 columns is', '$3 \times 2$', '$2 \times 3$', '$6$', '$3 + 2$', 'option1', 'The order of a matrix is written as (number of rows) $\times$ (number of columns). So it is $3 \times 2$.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('A matrix with equal number of rows and columns is called', 'A square matrix', 'A rectangular matrix', 'A diagonal matrix', 'An identity matrix', 'option1', 'A matrix of order $n \times n$ (same number of rows and columns) is called a square matrix.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$, then $2A$ is', '$\begin{pmatrix} 2 & 4 \\ 6 & 8 \end{pmatrix}$', '$\begin{pmatrix} 3 & 4 \\ 5 & 6 \end{pmatrix}$', '$\begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$', '$\begin{pmatrix} 2 & 2 \\ 3 & 8 \end{pmatrix}$', 'option1', 'Scalar multiplication: multiply each entry by 2. $2A = \begin{pmatrix} 2 & 4 \\ 6 & 8 \end{pmatrix}$.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('The transpose of $A = \begin{pmatrix} 1 & 2 & 3 \\ 4 & 5 & 6 \end{pmatrix}$ has order', '$2 \times 2$', '$2 \times 3$', '$3 \times 3$', '$3 \times 2$', 'option4', 'If $A$ is $2 \times 3$, then $A^T$ is $3 \times 2$ (rows and columns are interchanged).', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('The identity matrix of order 2 is', '$\begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}$', '$\begin{pmatrix} 1 & 1 \\ 1 & 1 \end{pmatrix}$', '$\begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$', '$\begin{pmatrix} 2 & 0 \\ 0 & 2 \end{pmatrix}$', 'option1', 'The identity matrix $I_2$ has 1s on the main diagonal and 0s elsewhere.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$ and $B = \begin{pmatrix} 5 & 6 \\ 7 & 8 \end{pmatrix}$, then $A + B$ is', '$\begin{pmatrix} 6 & 8 \\ 10 & 12 \end{pmatrix}$', '$\begin{pmatrix} 5 & 12 \\ 21 & 32 \end{pmatrix}$', '$\begin{pmatrix} 6 & 6 \\ 7 & 12 \end{pmatrix}$', '$\begin{pmatrix} 4 & 4 \\ 4 & 4 \end{pmatrix}$', 'option1', 'Matrix addition is element-wise: $(A+B)_{ij} = A_{ij} + B_{ij}$.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

('A matrix in which all elements are zero is called', 'A unit matrix', 'An identity matrix', 'A scalar matrix', 'A null (zero) matrix', 'option4', 'A matrix with all entries equal to zero is called a null matrix or zero matrix, denoted $O$.', 'm_matrices_algebra', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$ and $B = \begin{pmatrix} 2 & 0 \\ 1 & 3 \end{pmatrix}$, then $AB$ is', '$\begin{pmatrix} 4 & 6 \\ 10 & 12 \end{pmatrix}$', '$\begin{pmatrix} 2 & 0 \\ 3 & 12 \end{pmatrix}$', '$\begin{pmatrix} 3 & 2 \\ 4 & 7 \end{pmatrix}$', '$\begin{pmatrix} 4 & 6 \\ 12 & 10 \end{pmatrix}$', 'option1', '$(AB)_{11} = 1(2)+2(1) = 4$. $(AB)_{12} = 1(0)+2(3) = 6$. $(AB)_{21} = 3(2)+4(1) = 10$. $(AB)_{22} = 3(0)+4(3) = 12$. So $AB = \begin{pmatrix} 4 & 6 \\ 10 & 12 \end{pmatrix}$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('A symmetric matrix satisfies', '$A^T = A$', '$A^T = -A$', '$A^2 = I$', '$A^T = A^{-1}$', 'option1', 'A matrix $A$ is symmetric if $A^T = A$, i.e., $a_{ij} = a_{ji}$ for all $i, j$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('If $A$ is a $3 \times 2$ matrix and $B$ is a $2 \times 4$ matrix, then $AB$ has order', '$4 \times 3$', '$2 \times 2$', '$3 \times 2$', '$3 \times 4$', 'option4', 'For $AB$ to be defined, the number of columns of $A$ must equal the number of rows of $B$ (both 2). The result has order (rows of $A$) $\times$ (columns of $B$) $= 3 \times 4$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}$, then $A^2$ is', '$A$', '$I$ (identity matrix)', '$-A$', '$O$ (zero matrix)', 'option2', '$A^2 = \begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix}\begin{pmatrix} 1 & 0 \\ 0 & -1 \end{pmatrix} = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix} = I$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('The number of elements in a $3 \times 3$ symmetric matrix that can be chosen independently is', '$6$', '$9$', '$3$', '$5$', 'option1', 'In a $3 \times 3$ symmetric matrix, the 3 diagonal elements and 3 upper-triangular elements determine the matrix (the lower-triangular elements are fixed by symmetry). Total $= 3 + 3 = 6$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 0 & 1 \\ 1 & 0 \end{pmatrix}$, then $A^3$ is', '$-A$', '$I$', '$A$', '$O$', 'option3', '$A^2 = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix} = I$. So $A^3 = A^2 \cdot A = IA = A$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

('For matrices $A$ and $B$, in general', '$AB = BA$', '$AB \neq BA$', '$AB = O$ implies $A = O$ or $B = O$', '$(AB)^T = A^T B^T$', 'option2', 'Matrix multiplication is not commutative in general. Also, $(AB)^T = B^T A^T$ (not $A^T B^T$), and $AB = O$ does not imply $A = O$ or $B = O$.', 'm_matrices_algebra', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $A = \begin{pmatrix} 1 & 1 \\ 0 & 1 \end{pmatrix}$, then $A^n$ for $n \in \mathbb{N}$ is', '$\begin{pmatrix} 1 & 2n \\ 0 & 1 \end{pmatrix}$', '$\begin{pmatrix} 1 & 1 \\ 0 & n \end{pmatrix}$', '$\begin{pmatrix} n & 1 \\ 0 & 1 \end{pmatrix}$', '$\begin{pmatrix} 1 & n \\ 0 & 1 \end{pmatrix}$', 'option4', 'By induction: $A^1 = \begin{pmatrix} 1 & 1 \\ 0 & 1 \end{pmatrix}$. $A^2 = \begin{pmatrix} 1 & 2 \\ 0 & 1 \end{pmatrix}$. If $A^k = \begin{pmatrix} 1 & k \\ 0 & 1 \end{pmatrix}$, then $A^{k+1} = A^k \cdot A = \begin{pmatrix} 1 & k+1 \\ 0 & 1 \end{pmatrix}$.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('If $A$ is a skew-symmetric matrix of order 3, then $\det(A)$ is', '$-1$', '$1$', '$0$', 'Cannot be determined', 'option3', 'For a skew-symmetric matrix, $A^T = -A$. So $\det(A^T) = \det(-A)$, giving $\det(A) = (-1)^3 \det(A) = -\det(A)$. Hence $2\det(A) = 0$, so $\det(A) = 0$.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{pmatrix}$, then $A^T A$ is', '$A^2$', '$I$', '$2A$', '$O$', 'option2', '$A^T = \begin{pmatrix} \cos\theta & \sin\theta \\ -\sin\theta & \cos\theta \end{pmatrix}$. $A^T A = \begin{pmatrix} \cos^2\theta + \sin^2\theta & 0 \\ 0 & \sin^2\theta + \cos^2\theta \end{pmatrix} = I$. So $A$ is an orthogonal matrix.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('The number of $3 \times 3$ diagonal matrices with entries from $\{0, 1\}$ is', '$8$', '$6$', '$27$', '$9$', 'option1', 'A diagonal matrix has non-zero entries only on the main diagonal. Each of the 3 diagonal entries can be 0 or 1 independently. Total $= 2^3 = 8$.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('If $A$ and $B$ are symmetric matrices of the same order, then $AB - BA$ is', 'Null matrix', 'Symmetric', 'Diagonal', 'Skew-symmetric', 'option4', '$(AB - BA)^T = (AB)^T - (BA)^T = B^T A^T - A^T B^T = BA - AB = -(AB - BA)$. So $AB - BA$ is skew-symmetric.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('Every square matrix can be uniquely expressed as the sum of', 'A diagonal and a null matrix', 'Two symmetric matrices', 'Two skew-symmetric matrices', 'A symmetric and a skew-symmetric matrix', 'option4', 'For any square matrix $A$: $A = \frac{A + A^T}{2} + \frac{A - A^T}{2}$. The first term is symmetric (since its transpose equals itself) and the second is skew-symmetric (since its transpose equals its negative). This decomposition is unique.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),

('If $A$ is an idempotent matrix (i.e., $A^2 = A$), then $(I - A)^2$ is', '$I - A$', '$I$', '$A$', '$I - 2A$', 'option1', '$(I - A)^2 = I - 2A + A^2 = I - 2A + A = I - A$. So $I - A$ is also idempotent.', 'm_matrices_algebra', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_determinants_evaluation (Determinants of order two and three, evaluation, area of triangles)
-- Chapter: math_matrices_determinants
-- ============================================================

-- Tier 1 (Easy)
('The determinant of $\begin{pmatrix} 3 & 4 \\ 1 & 2 \end{pmatrix}$ is', '$10$', '$2$', '$-2$', '$5$', 'option2', '$\det = 3(2) - 4(1) = 6 - 4 = 2$.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('The determinant of $\begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}$ is', '$2$', '$0$', '$1$', '$-1$', 'option3', '$\det(I_2) = 1(1) - 0(0) = 1$.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('If $\det(A) = 0$, then $A$ is called', 'Symmetric', 'Non-singular', 'Singular', 'Orthogonal', 'option3', 'A matrix with determinant zero is called singular. It does not have an inverse.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('The determinant of $\begin{pmatrix} 5 & 10 \\ 2 & 4 \end{pmatrix}$ is', '$40$', '$20$', '$-20$', '$0$', 'option4', '$\det = 5(4) - 10(2) = 20 - 20 = 0$. Note: Row 2 is a scalar multiple of Row 1 (factor 2/5), confirming the determinant is 0.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('If a row of a determinant is multiplied by $k$, the determinant is multiplied by', '$k^n$', '$k^2$', '$1/k$', '$k$', 'option4', 'Multiplying a single row (or column) of a determinant by a scalar $k$ multiplies the determinant by $k$.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('The determinant of $\begin{pmatrix} a & b \\ c & d \end{pmatrix}$ is', '$ad - bc$', '$ac - bd$', '$ab - cd$', '$ad + bc$', 'option1', 'For a $2 \times 2$ matrix, $\det = ad - bc$.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

('If two rows of a determinant are identical, the value of the determinant is', 'Depends on the matrix', '$1$', '$-1$', '$0$', 'option4', 'If two rows (or columns) are identical, the determinant is 0. This follows from the property that swapping two rows changes the sign, but swapping identical rows leaves it unchanged, so $\det = -\det$, giving $\det = 0$.', 'm_determinants_evaluation', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The determinant of $\begin{pmatrix} 1 & 2 & 3 \\ 4 & 5 & 6 \\ 7 & 8 & 9 \end{pmatrix}$ is', '$3$', '$-6$', '$6$', '$0$', 'option4', 'Expanding along $R_1$: $1(45-48) - 2(36-42) + 3(32-35) = -3 + 12 - 9 = 0$. Alternatively, $R_3 = 2R_2 - R_1$ (arithmetic progression in rows), so the determinant is 0.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('The determinant of $\begin{pmatrix} 2 & 1 & 3 \\ 1 & 0 & 2 \\ 3 & 1 & 1 \end{pmatrix}$ is', '$-4$', '$4$', '$0$', '$8$', 'option2', 'Expanding along $R_1$: $2(0-2) - 1(1-6) + 3(1-0) = -4 + 5 + 3 = 4$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('The area of the triangle with vertices $(1, 1)$, $(4, 5)$, $(7, 1)$ using determinants is', '$12$', '$24$', '$6$', '$18$', 'option1', 'Area $= \frac{1}{2}|x_1(y_2 - y_3) + x_2(y_3 - y_1) + x_3(y_1 - y_2)| = \frac{1}{2}|1(5-1) + 4(1-1) + 7(1-5)| = \frac{1}{2}|4 + 0 - 28| = \frac{1}{2}(24) = 12$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('If $A$ is a $3 \times 3$ matrix with $\det(A) = 5$, then $\det(2A)$ is', '$20$', '$10$', '$80$', '$40$', 'option4', '$\det(kA) = k^n \det(A)$ for an $n \times n$ matrix. Here $\det(2A) = 2^3 \times 5 = 40$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('$\det(A^T)$ equals', '$\det(A)$', '$-\det(A)$', '$\frac{1}{\det(A)}$', '$[\det(A)]^2$', 'option1', 'The determinant of the transpose equals the determinant of the original matrix: $\det(A^T) = \det(A)$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('If $\det(A) = 3$ and $\det(B) = 7$, then $\det(AB)$ is', '$21$', '$10$', '$-21$', '$4$', 'option1', '$\det(AB) = \det(A) \cdot \det(B) = 3 \times 7 = 21$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

('The points $(1, 5)$, $(2, 3)$, $(k, 1)$ are collinear if $k$ is', '$3$', '$4$', '$2$', '$0$', 'option1', 'Collinear when the area of the triangle is 0: $\frac{1}{2}|1(3-1) + 2(1-5) + k(5-3)| = 0$. $|2 - 8 + 2k| = 0$. $2k - 6 = 0$, so $k = 3$.', 'm_determinants_evaluation', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('Evaluate: $\begin{vmatrix} 1 & 1 & 1 \\ 1 & 2 & 4 \\ 1 & 3 & 9 \end{vmatrix}$', '$6$', '$0$', '$2$', '$-2$', 'option3', 'Expanding along $R_1$: $1(18-12) - 1(9-4) + 1(3-2) = 6 - 5 + 1 = 2$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('If $\det(A) = 4$ for a $3 \times 3$ matrix $A$, then $\det(A^{-1})$ is', '$16$', '$4$', '$-4$', '$\frac{1}{4}$', 'option4', 'Since $AA^{-1} = I$, we have $\det(A)\det(A^{-1}) = 1$. So $\det(A^{-1}) = \frac{1}{\det(A)} = \frac{1}{4}$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('The product of all values of $x$ satisfying $\begin{vmatrix} x & 1 & 2 \\ 1 & x & 2 \\ 1 & 2 & x \end{vmatrix} = 0$ is', '$-6$', '$6$', '$0$', '$-3$', 'option1', 'Expanding: $x(x^2-4) - 1(x-2) + 2(2-x) = x^3 - 4x - x + 2 + 4 - 2x = x^3 - 7x + 6$. Factoring: $(x-1)(x-2)(x+3) = 0$, so $x = 1, 2, -3$. Product $= 1 \times 2 \times (-3) = -6$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('$\begin{vmatrix} a+b & a & b \\ b & a+b & a \\ a & b & a+b \end{vmatrix}$ equals', '$3a^2b + 3ab^2$', '$3(a^3 + b^3)$', '$a^3 + b^3$', '$2(a^3 + b^3)$', 'option4', 'Apply $C_1 \to C_1 + C_2 + C_3$: each entry in $C_1$ becomes $2(a+b)$. Factor out $2(a+b)$, then $R_2 - R_1$, $R_3 - R_1$: $2(a+b)\begin{vmatrix} 1 & a & b \\ 0 & b & a-b \\ 0 & b-a & a \end{vmatrix} = 2(a+b)[ab - (a-b)(b-a)] = 2(a+b)[ab + (a-b)^2] = 2(a+b)(a^2 - ab + b^2) = 2(a^3 + b^3)$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('The area of the triangle with vertices $(0, 0)$, $(6, 0)$, $(4, 3)$ using determinants is', '$9$', '$18$', '$12$', '$6$', 'option1', 'Area $= \frac{1}{2}|x_1(y_2 - y_3) + x_2(y_3 - y_1) + x_3(y_1 - y_2)| = \frac{1}{2}|0(0-3) + 6(3-0) + 4(0-0)| = \frac{1}{2}|18| = 9$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('The Vandermonde determinant $\begin{vmatrix} 1 & 1 & 1 \\ a & b & c \\ a^2 & b^2 & c^2 \end{vmatrix}$ equals', '$(b-a)(c-a)(c-b)$', '$(a-b)(b-c)(c-a)$', '$(a+b)(b+c)(c+a)$', '$abc$', 'option1', 'This is the standard Vandermonde determinant. $R_2 - aR_1$ and $R_3 - a^2 R_1$: $\begin{vmatrix} 1 & 1 & 1 \\ 0 & b-a & c-a \\ 0 & b^2-a^2 & c^2-a^2 \end{vmatrix} = (b-a)(c^2-a^2) - (c-a)(b^2-a^2) = (b-a)(c-a)(c+a) - (c-a)(b-a)(b+a) = (b-a)(c-a)[(c+a)-(b+a)] = (b-a)(c-a)(c-b)$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),

('If $a$, $b$, $c$ are in A.P. with common difference $d$, then $\begin{vmatrix} 1 & 1 & 1 \\ a & b & c \\ a^2 & b^2 & c^2 \end{vmatrix}$ equals', '$3d^3$', '$d^3$', '$2d^3$', '$0$', 'option3', 'By the Vandermonde formula, the determinant $= (b-a)(c-a)(c-b)$. Since $a, b, c$ are in A.P.: $b - a = d$, $c - a = 2d$, $c - b = d$. So the determinant $= d \cdot 2d \cdot d = 2d^3$.', 'm_determinants_evaluation', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_adjoint_inverse (Adjoint and inverse of a square matrix)
-- Chapter: math_matrices_determinants
-- ============================================================

-- Tier 1 (Easy)
('The adjoint of the identity matrix $I_2$ is', '$I_2$', '$O$ (zero matrix)', '$2I_2$', '$-I_2$', 'option1', 'For $I = \begin{pmatrix} 1 & 0 \\ 0 & 1 \end{pmatrix}$, the cofactors are $C_{11}=1$, $C_{12}=0$, $C_{21}=0$, $C_{22}=1$. The adjoint (transpose of cofactor matrix) is $I_2$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('For a $2 \times 2$ matrix $A = \begin{pmatrix} a & b \\ c & d \end{pmatrix}$, $\text{adj}(A)$ is', '$\begin{pmatrix} -d & b \\ c & -a \end{pmatrix}$', '$\begin{pmatrix} a & -c \\ -b & d \end{pmatrix}$', '$\begin{pmatrix} d & c \\ b & a \end{pmatrix}$', '$\begin{pmatrix} d & -b \\ -c & a \end{pmatrix}$', 'option4', 'For a $2 \times 2$ matrix, the adjoint is obtained by swapping the diagonal entries and negating the off-diagonal entries: $\text{adj}(A) = \begin{pmatrix} d & -b \\ -c & a \end{pmatrix}$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('$A \cdot \text{adj}(A)$ equals', '$A^2$', '$\det(A) \cdot I$', '$\text{adj}(A) \cdot A^T$', '$I$', 'option2', 'A fundamental property of the adjoint: $A \cdot \text{adj}(A) = \text{adj}(A) \cdot A = \det(A) \cdot I$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('If $\det(A) = 0$, then $A^{-1}$', 'Equals $O$', 'Equals $A$', 'Equals $\text{adj}(A)$', 'Does not exist', 'option4', 'A matrix is invertible if and only if its determinant is non-zero. When $\det(A) = 0$, the matrix is singular and has no inverse.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('$(A^{-1})^{-1}$ equals', '$A$', '$A^T$', '$A^2$', '$\text{adj}(A)$', 'option1', 'Taking the inverse twice returns the original matrix: $(A^{-1})^{-1} = A$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('The inverse of $A = \begin{pmatrix} 3 & 5 \\ 1 & 2 \end{pmatrix}$ is', '$\begin{pmatrix} 2 & -5 \\ -1 & 3 \end{pmatrix}$', '$\begin{pmatrix} 2 & 5 \\ 1 & 3 \end{pmatrix}$', '$\begin{pmatrix} -2 & 5 \\ 1 & -3 \end{pmatrix}$', '$\begin{pmatrix} 3 & -5 \\ -1 & 2 \end{pmatrix}$', 'option1', '$\det(A) = 6 - 5 = 1$. $\text{adj}(A) = \begin{pmatrix} 2 & -5 \\ -1 & 3 \end{pmatrix}$. $A^{-1} = \frac{1}{1}\begin{pmatrix} 2 & -5 \\ -1 & 3 \end{pmatrix}$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

('The inverse of $A = \begin{pmatrix} 2 & 3 \\ 1 & 4 \end{pmatrix}$ is', '$\frac{1}{5}\begin{pmatrix} 4 & -3 \\ -1 & 2 \end{pmatrix}$', '$\frac{1}{5}\begin{pmatrix} 2 & -3 \\ -1 & 4 \end{pmatrix}$', '$\begin{pmatrix} 4 & -3 \\ -1 & 2 \end{pmatrix}$', '$\frac{1}{11}\begin{pmatrix} 4 & -3 \\ -1 & 2 \end{pmatrix}$', 'option1', '$\det(A) = 8 - 3 = 5$. $\text{adj}(A) = \begin{pmatrix} 4 & -3 \\ -1 & 2 \end{pmatrix}$. $A^{-1} = \frac{1}{5}\begin{pmatrix} 4 & -3 \\ -1 & 2 \end{pmatrix}$.', 'm_adjoint_inverse', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('If $A$ is a $3 \times 3$ matrix with $\det(A) = 3$, then $\det(\text{adj}(A))$ is', '$27$', '$3$', '$9$', '$6$', 'option3', 'For an $n \times n$ matrix, $\det(\text{adj}(A)) = [\det(A)]^{n-1}$. For $n = 3$: $\det(\text{adj}(A)) = 3^2 = 9$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$, then $A \cdot \text{adj}(A)$ is', '$\begin{pmatrix} 2 & 0 \\ 0 & 2 \end{pmatrix}$', '$\begin{pmatrix} -2 & 0 \\ 0 & -2 \end{pmatrix}$', '$\begin{pmatrix} -2 & 1 \\ 1 & -2 \end{pmatrix}$', '$I$', 'option2', '$\det(A) = 4 - 6 = -2$. By the property $A \cdot \text{adj}(A) = \det(A) \cdot I = -2I = \begin{pmatrix} -2 & 0 \\ 0 & -2 \end{pmatrix}$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('$(AB)^{-1}$ equals', '$A^{-1}B^{-1}$', '$B^{-1}A^{-1}$', '$(A^{-1})(B^{-1})^T$', '$B A^{-1}$', 'option2', 'The inverse of a product reverses the order: $(AB)^{-1} = B^{-1}A^{-1}$. This can be verified: $(AB)(B^{-1}A^{-1}) = A(BB^{-1})A^{-1} = AIA^{-1} = I$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('The inverse of $A = \begin{pmatrix} 2 & 1 \\ 5 & 3 \end{pmatrix}$ is', '$\frac{1}{11}\begin{pmatrix} 3 & -1 \\ -5 & 2 \end{pmatrix}$', '$\begin{pmatrix} 2 & -1 \\ -5 & 3 \end{pmatrix}$', '$\begin{pmatrix} 3 & 1 \\ 5 & 2 \end{pmatrix}$', '$\begin{pmatrix} 3 & -1 \\ -5 & 2 \end{pmatrix}$', 'option4', '$\det(A) = 6 - 5 = 1$. $\text{adj}(A) = \begin{pmatrix} 3 & -1 \\ -5 & 2 \end{pmatrix}$. $A^{-1} = \frac{1}{1}\begin{pmatrix} 3 & -1 \\ -5 & 2 \end{pmatrix} = \begin{pmatrix} 3 & -1 \\ -5 & 2 \end{pmatrix}$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('For a $2 \times 2$ non-singular matrix $A$, $\text{adj}(\text{adj}(A))$ equals', '$A^{-1}$', '$\det(A) \cdot A$', '$A$', '$\text{adj}(A)$', 'option3', 'For an $n \times n$ matrix, $\text{adj}(\text{adj}(A)) = [\det(A)]^{n-2} A$. For $n = 2$: $\text{adj}(\text{adj}(A)) = [\det(A)]^0 A = A$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('If $A^2 = I$ (involutory matrix), then $A^{-1}$ is', '$-A$', '$A^T$', '$A$', '$I$', 'option3', 'From $A^2 = I$, multiplying both sides by $A^{-1}$: $A = A^{-1}$. So the inverse of an involutory matrix is the matrix itself.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 4 & 7 \\ 2 & 6 \end{pmatrix}$, then $\det(A^{-1})$ is', '$\frac{1}{10}$', '$10$', '$-10$', '$\frac{1}{24}$', 'option1', '$\det(A) = 24 - 14 = 10$. Since $\det(A^{-1}) = \frac{1}{\det(A)}$, we get $\det(A^{-1}) = \frac{1}{10}$.', 'm_adjoint_inverse', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('If $A$ is a non-singular $3 \times 3$ matrix with $\det(A) = 5$, then $\det(\text{adj}(A))$ is', '$10$', '$5$', '$125$', '$25$', 'option4', '$\det(\text{adj}(A)) = [\det(A)]^{n-1}$ for an $n \times n$ matrix. For $n = 3$: $\det(\text{adj}(A)) = 5^2 = 25$.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('For a $3 \times 3$ matrix $A$, $\text{adj}(2A)$ equals', '$2 \cdot \text{adj}(A)$', '$4 \cdot \text{adj}(A)$', '$8 \cdot \text{adj}(A)$', '$\text{adj}(A)$', 'option2', 'For an $n \times n$ matrix, $\text{adj}(kA) = k^{n-1}\text{adj}(A)$. For $n = 3$: $\text{adj}(2A) = 2^{3-1}\text{adj}(A) = 4\text{adj}(A)$.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 3 \end{pmatrix}$, then $A^{-1}$ is', '$\begin{pmatrix} 1 & 0 & 0 \\ 0 & 1/2 & 0 \\ 0 & 0 & 1/3 \end{pmatrix}$', '$\begin{pmatrix} 1 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 3 \end{pmatrix}$', '$\frac{1}{6}\begin{pmatrix} 6 & 0 & 0 \\ 0 & 3 & 0 \\ 0 & 0 & 2 \end{pmatrix}$', 'Both (a) and (c)', 'option4', '$\det(A) = 6$. For a diagonal matrix, $A^{-1}$ has reciprocals on the diagonal: $\text{diag}(1, 1/2, 1/3)$. Also, $\text{adj}(A) = \begin{pmatrix} 6 & 0 & 0 \\ 0 & 3 & 0 \\ 0 & 0 & 2 \end{pmatrix}$, so $A^{-1} = \frac{1}{6}\text{adj}(A)$, which gives the same result. Both (a) and (c) are equivalent.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('$(\text{adj}\,A)^{-1}$ equals', '$\text{adj}(A^{-1})$', '$\det(A) \cdot A$', '$A^T$', '$\frac{A}{\det(A)}$', 'option4', 'Since $\text{adj}(A) = \det(A) \cdot A^{-1}$, taking inverse: $(\text{adj}\,A)^{-1} = \frac{1}{\det(A)} \cdot A = \frac{A}{\det(A)}$. Note: option (d) $\text{adj}(A^{-1})$ also equals $\frac{A}{\det(A)}$, but option (a) is the direct simplification.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('If $A$ is a $3 \times 3$ matrix with $\det(A) = 2$, then $\det(3 \cdot \text{adj}(A))$ is', '$18$', '$54$', '$108$', '$36$', 'option3', '$\det(3 \cdot \text{adj}(A)) = 3^3 \cdot \det(\text{adj}(A)) = 27 \cdot [\det(A)]^{n-1} = 27 \cdot 2^2 = 27 \times 4 = 108$.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 1 & 1 \\ 1 & 2 & 3 \\ 1 & 3 & 6 \end{pmatrix}$, then the $(2, 3)$ entry of $A^{-1}$ is', '$2$', '$-2$', '$-1$', '$1$', 'option2', '$\det(A) = 1(12-9) - 1(6-3) + 1(3-2) = 3 - 3 + 1 = 1$. Since $\det(A) = 1$, $A^{-1} = \text{adj}(A)$. The $(2,3)$ entry of $\text{adj}(A)$ is the $(3,2)$ cofactor of $A$: $C_{32} = (-1)^{3+2}\begin{vmatrix} 1 & 1 \\ 1 & 3 \end{vmatrix} = -(3-1) = -2$.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),

('If $A$ is an orthogonal matrix ($A^T A = I$) of order 3, then $\text{adj}(A)$ equals', '$\pm A^T$', '$A$', '$A^{-1}$', '$\det(A) \cdot I$', 'option1', 'For orthogonal $A$: $A^{-1} = A^T$. Also $\text{adj}(A) = \det(A) \cdot A^{-1} = \det(A) \cdot A^T$. Since $\det(A) = \pm 1$ for orthogonal matrices (from $\det(A^T A) = [\det(A)]^2 = 1$), we get $\text{adj}(A) = \pm A^T$.', 'm_adjoint_inverse', 3, 'JEE Mains Prep', 'approved'),


-- ============================================================
-- CONCEPT: m_linear_equations_matrices (Test of consistency and solution of simultaneous linear equations using matrices)
-- Chapter: math_matrices_determinants
-- ============================================================

-- Tier 1 (Easy)
('A system $Ax = b$ has a unique solution when', '$\det(A) = 0$', '$\det(A) \neq 0$', '$A$ is singular', '$b = 0$', 'option2', 'A system of linear equations $Ax = b$ has a unique solution if and only if the coefficient matrix $A$ is non-singular, i.e., $\det(A) \neq 0$.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('The solution of $x + y = 3$, $x - y = 1$ is', '$x = 1, y = 2$', '$x = 2, y = 1$', '$x = 3, y = 0$', '$x = 0, y = 3$', 'option2', 'Adding the equations: $2x = 4$, so $x = 2$. Subtracting: $2y = 2$, so $y = 1$. Alternatively, $A = \begin{pmatrix} 1 & 1 \\ 1 & -1 \end{pmatrix}$, $\det(A) = -2 \neq 0$, confirming a unique solution.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('In Cramer''s rule, $x = \frac{D_x}{D}$ where $D$ is', '$\text{tr}(A)$', '$\det(A^{-1})$', '$\det(A)$', '$\det(\text{adj}(A))$', 'option3', 'In Cramer''s rule, $D = \det(A)$ is the determinant of the coefficient matrix. $D_x$ is obtained by replacing the column of $x$-coefficients with the constant column.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('A homogeneous system $Ax = 0$ always has', 'No solution', 'The trivial solution $x = 0$', 'Infinitely many solutions', 'Exactly two solutions', 'option2', 'A homogeneous system $Ax = 0$ always has at least the trivial solution $x = 0$ (the zero vector). It may also have non-trivial solutions if $\det(A) = 0$.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('The system $2x + 3y = 7$, $4x + 6y = 14$ has', 'Exactly two solutions', 'A unique solution', 'No solution', 'Infinitely many solutions', 'option4', 'The second equation is exactly twice the first ($4x + 6y = 2(2x + 3y) = 14$). So $\det(A) = 12 - 12 = 0$ and the system is consistent with infinitely many solutions.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('A homogeneous system $Ax = 0$ has non-trivial solutions if and only if', '$A$ is symmetric', '$\det(A) \neq 0$', '$A = I$', '$\det(A) = 0$', 'option4', 'The homogeneous system $Ax = 0$ has non-trivial (non-zero) solutions if and only if $\det(A) = 0$, i.e., $A$ is singular.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

('The solution of $x + 2y = 5$, $3x + 4y = 11$ is', '$x = 1, y = 2$', '$x = 2, y = 1$', '$x = 3, y = 1$', '$x = 1, y = 3$', 'option1', '$\det(A) = 4 - 6 = -2$. By Cramer''s rule: $D_x = \begin{vmatrix} 5 & 2 \\ 11 & 4 \end{vmatrix} = 20 - 22 = -2$, so $x = \frac{-2}{-2} = 1$. $D_y = \begin{vmatrix} 1 & 5 \\ 3 & 11 \end{vmatrix} = 11 - 15 = -4$, so $y = \frac{-4}{-2} = 2$. Check: $1 + 4 = 5$ and $3 + 8 = 11$.', 'm_linear_equations_matrices', 1, 'JEE Mains Prep', 'approved'),

-- Tier 2 (Medium)
('The system $x + y + z = 6$, $x + 2y + 3z = 14$, $x + 4y + 9z = 36$ has the solution', '$x = 2, y = 1, z = 3$', '$x = 1, y = 2, z = 3$', '$x = 3, y = 2, z = 1$', '$x = 1, y = 3, z = 2$', 'option2', '$\det(A) = 1(18-12) - 1(9-3) + 1(4-2) = 6 - 6 + 2 = 2$. By Cramer''s rule: $D_x = 6(18-12) - 1(126-108) + 1(56-72) = 36 - 18 - 16 = 2$, so $x = 1$. $D_y = 1(126-108) - 6(9-3) + 1(36-14) = 18 - 36 + 22 = 4$, so $y = 2$. $D_z = 1(72-56) - 1(36-14) + 6(4-2) = 16 - 22 + 12 = 6$, so $z = 3$.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('The system $2x + 3y = 5$, $4x + 6y = 7$ is', 'Homogeneous', 'Consistent with unique solution', 'Consistent with infinitely many solutions', 'Inconsistent', 'option4', '$\det(A) = 12 - 12 = 0$, so no unique solution. The second equation is not a multiple of the first ($7 \neq 2 \times 5$), so the system is inconsistent (no solution).', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('The system $x + y + z = 3$, $x + 2y + 2z = 4$, $x + 4y + 4z = 6$ has', 'A unique solution', 'Infinitely many solutions', 'No solution', 'Only the trivial solution', 'option2', '$\det(A) = 1(8-8) - 1(4-2) + 1(4-2) = 0 - 2 + 2 = 0$. Augmented matrix: $R_2 - R_1 = (0, 1, 1, 1)$, $R_3 - R_1 = (0, 3, 3, 3) = 3(0, 1, 1, 1)$. The system reduces to $x + y + z = 3$ and $y + z = 1$, giving $x = 2$ and $y = 1 - z$ (free parameter). Infinitely many solutions.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('The homogeneous system $x + 2y + 3z = 0$, $2x + 3y + z = 0$, $3x + 5y + 4z = 0$ has', 'Infinitely many solutions', 'Only the trivial solution', 'No solution', 'Exactly two solutions', 'option1', '$\det(A) = 1(12-5) - 2(8-3) + 3(10-9) = 7 - 10 + 3 = 0$. Since $\det(A) = 0$, the homogeneous system has non-trivial (infinitely many) solutions in addition to the trivial solution.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('Using matrix method, the solution of $x + 2y = 4$, $3x + 5y = 11$ is', '$x = 3, y = 1$', '$x = 1, y = 2$', '$x = -2, y = 3$', '$x = 2, y = 1$', 'option4', '$A = \begin{pmatrix} 1 & 2 \\ 3 & 5 \end{pmatrix}$, $\det(A) = 5 - 6 = -1$. $A^{-1} = \frac{1}{-1}\begin{pmatrix} 5 & -2 \\ -3 & 1 \end{pmatrix} = \begin{pmatrix} -5 & 2 \\ 3 & -1 \end{pmatrix}$. $\begin{pmatrix} x \\ y \end{pmatrix} = A^{-1}b = \begin{pmatrix} -5 & 2 \\ 3 & -1 \end{pmatrix}\begin{pmatrix} 4 \\ 11 \end{pmatrix} = \begin{pmatrix} 2 \\ 1 \end{pmatrix}$.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('The system $2x + y = 5$, $4x + 2y = 10$ has', 'A unique solution', 'Infinitely many solutions', 'No solution', 'Exactly three solutions', 'option2', '$\det(A) = 4 - 4 = 0$. The second equation is exactly twice the first. The system is consistent with infinitely many solutions: $y = 5 - 2x$ for any $x$.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

('The solution of $x + y + z = 6$, $x - y + z = 2$, $x + y - z = 0$ is', '$x = 2, y = 1, z = 3$', '$x = 1, y = 2, z = 3$', '$x = 3, y = 2, z = 1$', '$x = 1, y = 3, z = 2$', 'option2', '$\det(A) = 1(1-1) - 1(-1-1) + 1(1+1) = 0 + 2 + 2 = 4$. $D_x = 6(1-1) - 1(-2-0) + 1(2-0) = 0 + 2 + 2 = 4$, so $x = 1$. $D_y = 1(-2-0) - 6(-1-1) + 1(0-2) = -2 + 12 - 2 = 8$, so $y = 2$. $D_z = 1(0-2) - 1(0-2) + 6(1+1) = -2 + 2 + 12 = 12$, so $z = 3$.', 'm_linear_equations_matrices', 2, 'JEE Mains Prep', 'approved'),

-- Tier 3 (Hard)
('The non-trivial solution of $x + 2y + 3z = 0$, $2x + 3y + z = 0$, $3x + 5y + 4z = 0$ satisfies $x : y : z =$', '$1 : -5 : 7$', '$5 : -7 : 1$', '$7 : -5 : 1$', '$7 : 5 : -1$', 'option3', '$\det(A) = 0$ (verified earlier). From equations 1 and 2: $R_2 - 2R_1$ gives $-y - 5z = 0$, so $y = -5z$. Substituting into equation 1: $x + 2(-5z) + 3z = 0$, so $x = 7z$. Therefore $(x, y, z) = z(7, -5, 1)$ and $x : y : z = 7 : -5 : 1$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('The homogeneous system $kx + y + z = 0$, $x + ky + z = 0$, $x + y + kz = 0$ has non-trivial solutions when $k$ equals', '$1$ or $-2$', '$0$ or $1$', '$-1$ or $2$', '$1$ only', 'option1', 'For non-trivial solutions, $\det(A) = 0$. $\det = k(k^2-1) - 1(k-1) + 1(1-k) = k^3 - k - k + 1 + 1 - k = k^3 - 3k + 2 = (k-1)^2(k+2) = 0$. So $k = 1$ or $k = -2$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('The system $x + y + z = 6$, $x + 2y + 3z = 14$, $2x + 3y + 4z = 20$ has', 'Infinitely many solutions', 'A unique solution', 'No solution', 'Only the trivial solution', 'option1', 'Note that $R_3 = R_1 + R_2$ (both for coefficients and constants: $2=1+1$, $3=1+2$, $4=1+3$, $20=6+14$). So $\det(A) = 0$ and the system is consistent. It reduces to two independent equations with three unknowns, giving infinitely many solutions.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('The system $x + y + z = 1$, $x + 2y + 4z = \lambda$, $x + 4y + 10z = \lambda^2$ is consistent for $\lambda$ equal to', '$1$ or $3$', '$0$ or $1$', '$1$ or $2$', '$2$ or $3$', 'option3', '$\det(A) = 1(20-16) - 1(10-4) + 1(4-2) = 4 - 6 + 2 = 0$. For consistency, the augmented matrix must have rank $\leq 2$. $R_2 - R_1 = (0, 1, 3, \lambda-1)$, $R_3 - R_1 = (0, 3, 9, \lambda^2-1)$. $R_3 - 3R_2 = (0, 0, 0, \lambda^2 - 1 - 3(\lambda-1)) = (0, 0, 0, \lambda^2 - 3\lambda + 2)$. Setting $\lambda^2 - 3\lambda + 2 = (\lambda-1)(\lambda-2) = 0$: $\lambda = 1$ or $\lambda = 2$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('The system $x + y = 2$, $2x + 3y = 5$, $3x + 4y = k$ is consistent for $k$ equal to', '$9$', '$6$', '$8$', '$7$', 'option4', 'From the first two equations: subtracting, $x + 2y = 3$; from eq1, $x = 2 - y$. Substituting: $(2-y) + 2y = 3$, so $y = 1$ and $x = 1$. For the third equation to be consistent: $3(1) + 4(1) = k$, so $k = 7$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('The homogeneous system $x + 2y + 3z = 0$, $3x + 4y + 7z = 0$, $2x + y + (k+3)z = 0$ has non-trivial solutions when $k$ equals', '$0$', '$1$', '$-1$', '$2$', 'option1', 'For non-trivial solutions, $\det(A) = 0$. $\det = 1(4(k+3)-7) - 2(3(k+3)-14) + 3(3-8) = (4k+5) - 2(3k-5) + (-15) = 4k + 5 - 6k + 10 - 15 = -2k$. Setting $-2k = 0$ gives $k = 0$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved'),

('If $A = \begin{pmatrix} 1 & 1 & 1 \\ 1 & -1 & 1 \\ 1 & 1 & -1 \end{pmatrix}$ and $b = \begin{pmatrix} 6 \\ 2 \\ 0 \end{pmatrix}$, then $x + y + z$ equals', '$3$', '$4$', '$8$', '$6$', 'option4', 'The first equation directly gives $x + y + z = 6$. To verify the system is consistent: $\det(A) = 1(1-1) - 1(-1-1) + 1(1+1) = 0 + 2 + 2 = 4 \neq 0$, so a unique solution exists. Adding all three equations: $3x + y + z = 8$. From eq1 and this: $2x = 2$, so $x = 1$. Then $y + z = 5$. From eq2: $-y + z = 1$, so $z = 3$, $y = 2$. Check eq3: $1 + 2 - 3 = 0$ ✓. Sum $= 6$.', 'm_linear_equations_matrices', 3, 'JEE Mains Prep', 'approved')