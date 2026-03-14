-- Migration: Hierarchical Knowledge Graph
-- Description: Creates chapters and chapter_prerequisites tables for two-tier knowledge graph
-- Date: 2024

-- Create chapters table
CREATE TABLE IF NOT EXISTS chapters (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    display_order INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create chapter_prerequisites table
CREATE TABLE IF NOT EXISTS chapter_prerequisites (
    chapter_id VARCHAR(100) NOT NULL,
    prereq_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (chapter_id, prereq_id),
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES chapters(id) ON DELETE CASCADE
);

-- Add chapter_id column to concepts table (nullable for backward compatibility)
ALTER TABLE concepts 
ADD COLUMN IF NOT EXISTS chapter_id VARCHAR(100) REFERENCES chapters(id);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_concepts_chapter ON concepts(chapter_id);
CREATE INDEX IF NOT EXISTS idx_chapters_subject ON chapters(subject);
CREATE INDEX IF NOT EXISTS idx_chapters_display_order ON chapters(display_order);
CREATE INDEX IF NOT EXISTS idx_chapter_prereqs_chapter ON chapter_prerequisites(chapter_id);
CREATE INDEX IF NOT EXISTS idx_chapter_prereqs_prereq ON chapter_prerequisites(prereq_id);

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
('mathematical_reasoning', 'Mathematical Reasoning', 'Mathematics - Logic', 73, 'Logic, statements, reasoning')
ON CONFLICT (id) DO NOTHING;

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
('atomic_structure', 'dual_nature')
ON CONFLICT (chapter_id, prereq_id) DO NOTHING;
