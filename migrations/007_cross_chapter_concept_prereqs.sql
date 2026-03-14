-- ============================================================
-- Migration 007: Cross-Chapter Concept Prerequisites
-- "Golden Edges" — high-impact cross-subject concept dependencies
-- Based on JEE Mains pedagogical analysis
-- ============================================================

-- These are the ~18 most impactful cross-chapter concept-level
-- prerequisites. Ghost nodes will only render when the student's
-- BKT mastery for the prerequisite is < 60%.

-- ============================================================
-- MATH → PHYSICS (Calculus → Mechanics & EM)
-- ============================================================
INSERT INTO concept_prerequisites (concept_id, prereq_id) VALUES

-- Differentiation → Kinematics (finding v from x(t), a from v(t))
('p_uniformly_accelerated', 'm_differentiation_rules'),

-- Integration → Work by variable force (W = ∫F·dx)
('p_work_ke_pe_theorem', 'm_integration_techniques'),

-- Integration → Centre of mass of continuous bodies (∫dm)
('p_centre_of_mass', 'm_integration_techniques'),

-- Differential equations → SHM equation (a = -ω²x)
('p_shm_equation', 'm_ode_order_degree'),

-- Differential equations → AC transient circuits (RC/LR charging)
('p_lcr_resonance_power', 'm_linear_de'),

-- ============================================================
-- MATH → PHYSICS (Vectors → Mechanics & EM)
-- ============================================================

-- Vector dot/cross products → Work by constant force (W = F⃗·d⃗)
('p_work_ke_pe_theorem', 'm_vector_components_products'),

-- Vector products → Electric flux (Φ = E⃗·A⃗)
('p_gauss_law', 'm_vector_components_products'),

-- Vector products → Torque (τ⃗ = r⃗ × F⃗)
('p_torque_angular_momentum', 'm_vector_components_products'),

-- Vector products → Magnetic force on charge (F⃗ = q(v⃗ × B⃗))
('p_force_moving_charge', 'm_vector_components_products'),

-- ============================================================
-- MATH → PHYSICS (Trig & Geometry)
-- ============================================================

-- Trig ratios → Resolution of vectors / projectile motion
('p_motion_plane_projectile', 'm_real_valued_functions'),

-- Trig identities → Wave superposition (sin A + sin B for beats)
('p_superposition_standing', 'm_real_valued_functions'),

-- Conic sections (ellipse) → Kepler's laws
('p_kepler_potential', 'm_conic_sections'),

-- ============================================================
-- MATH → CHEMISTRY (The "Hidden" Bottlenecks)
-- ============================================================

-- Logarithms (via real-valued functions) → pH calculations
('c_ph_buffers_solubility', 'm_real_valued_functions'),

-- Logarithms → Nernst equation
('c_nernst_gibbs', 'm_real_valued_functions'),

-- Logarithms → First-order kinetics (ln[A] = -kt + ln[A₀])
('c_rate_law_orders', 'm_real_valued_functions'),

-- Straight line graphs → Arrhenius plot analysis (y = mx + c)
('c_arrhenius_collision', 'm_straight_line_equations'),

-- ============================================================
-- PHYSICS → CHEMISTRY (Overlap Concepts)
-- ============================================================

-- Bohr model (Physics) → Atomic spectra (Chemistry)
('c_bohr_model', 'p_atomic_models'),

-- Nuclear decay (Physics) → First-order kinetics (same math)
('c_rate_law_orders', 'p_nuclear_composition');
