-- Migration 005: Rebuild chapters to match official NTA JEE Mains syllabus exactly
-- Source: NTA JEE Mains Detailed Syllabus (official document)
-- Replaces the previous 73-chapter structure with 54 NTA units (Math: 14, Physics: 20, Chemistry: 20)

-- Step 1: Clear existing chapter prerequisite relationships
DELETE FROM chapter_prerequisites;

-- Step 2: Unlink concepts from old chapters (set chapter_id to NULL)
UPDATE concepts SET chapter_id = NULL;

-- Step 3: Delete all existing chapters
DELETE FROM chapters;

-- Step 4: Insert all 54 NTA units as chapters
-- ============================================================
-- MATHEMATICS (14 units)
-- ============================================================
INSERT INTO chapters (id, name, subject, display_order, description) VALUES

-- Math Units
('math_sets_relations_functions', 'Sets, Relations and Functions', 'Mathematics', 1,
 'Sets and their representation, union/intersection/complement, power set, relations, equivalence relations, functions (one-one, into, onto), composition of functions'),

('math_complex_numbers_quadratic', 'Complex Numbers and Quadratic Equations', 'Mathematics', 2,
 'Complex numbers as ordered pairs, Argand diagram, algebra of complex numbers, modulus and argument, quadratic equations, roots and coefficients'),

('math_matrices_determinants', 'Matrices and Determinants', 'Mathematics', 3,
 'Matrices algebra, types of matrices, determinants of order 2 and 3, adjoint and inverse, solution of simultaneous linear equations using matrices'),

('math_permutations_combinations', 'Permutations and Combinations', 'Mathematics', 4,
 'Fundamental principle of counting, P(n,r) and C(n,r), simple applications'),

('math_binomial_theorem', 'Binomial Theorem and its Simple Applications', 'Mathematics', 5,
 'Binomial theorem for positive integral index, general term and middle term'),

('math_sequence_series', 'Sequence and Series', 'Mathematics', 6,
 'Arithmetic and geometric progressions, insertion of means, relation between A.M and G.M'),

('math_limit_continuity_differentiability', 'Limit, Continuity and Differentiability', 'Mathematics', 7,
 'Real-valued functions, limits, continuity, differentiability, differentiation rules, derivatives of order upto two, applications of derivatives (rate of change, maxima/minima)'),

('math_integral_calculus', 'Integral Calculus', 'Mathematics', 8,
 'Integral as anti-derivative, fundamental integrals, integration techniques (substitution, parts, partial fractions), fundamental theorem of calculus, definite integrals, areas under curves'),

('math_differential_equations', 'Differential Equations', 'Mathematics', 9,
 'Ordinary differential equations, order and degree, separation of variables, homogeneous and linear differential equations'),

('math_coordinate_geometry', 'Co-ordinate Geometry', 'Mathematics', 10,
 'Cartesian coordinates, distance/section formula, straight lines, circles, conic sections (parabola, ellipse, hyperbola) in standard forms'),

('math_three_dimensional_geometry', 'Three Dimensional Geometry', 'Mathematics', 11,
 'Coordinates in space, distance between points, direction ratios/cosines, equation of a line, skew lines, shortest distance'),

('math_vector_algebra', 'Vector Algebra', 'Mathematics', 12,
 'Vectors and scalars, addition of vectors, components in 2D and 3D, scalar and vector products'),

('math_statistics_probability', 'Statistics and Probability', 'Mathematics', 13,
 'Measures of dispersion, mean/median/mode, standard deviation/variance, probability of events, addition/multiplication theorems, Bayes theorem, probability distribution'),

('math_trigonometry', 'Trigonometry', 'Mathematics', 14,
 'Trigonometrical identities and functions, inverse trigonometrical functions and their properties'),

-- ============================================================
-- PHYSICS (20 units)
-- ============================================================

('phys_units_measurements', 'Units and Measurements', 'Physics', 15,
 'System of units, SI units, fundamental and derived units, least count, significant figures, errors in measurements, dimensional analysis'),

('phys_kinematics', 'Kinematics', 'Physics', 16,
 'Frame of reference, motion in a straight line, speed/velocity, uniformly accelerated motion, v-t and x-t graphs, relative velocity, motion in a plane, projectile motion, uniform circular motion'),

('phys_laws_of_motion', 'Laws of Motion', 'Physics', 17,
 'Force and inertia, Newton''s three laws, impulse, conservation of linear momentum, equilibrium of concurrent forces, static/kinetic/rolling friction, dynamics of circular motion, centripetal force, banked roads'),

('phys_work_energy_power', 'Work, Energy and Power', 'Physics', 18,
 'Work by constant and variable force, kinetic/potential energy, work-energy theorem, power, spring potential energy, conservation of mechanical energy, collisions in 1D and 2D'),

('phys_rotational_motion', 'Rotational Motion', 'Physics', 19,
 'Centre of mass, torque, angular momentum, conservation of angular momentum, moment of inertia, radius of gyration, parallel/perpendicular axes theorems, equilibrium of rigid bodies, equations of rotational motion'),

('phys_gravitation', 'Gravitation', 'Physics', 20,
 'Universal law of gravitation, acceleration due to gravity (variation with altitude/depth), Kepler''s laws, gravitational potential energy/potential, escape velocity, satellites, orbital velocity'),

('phys_properties_solids_liquids', 'Properties of Solids and Liquids', 'Physics', 21,
 'Elastic behaviour, stress-strain, Hooke''s law, Young''s/bulk/rigidity modulus, fluid pressure, Pascal''s law, viscosity, Stoke''s law, Bernoulli''s principle, surface tension, capillary rise, thermal expansion, calorimetry, heat transfer'),

('phys_thermodynamics', 'Thermodynamics', 'Physics', 22,
 'Zeroth law, heat/work/internal energy, first law, isothermal/adiabatic processes, second law, reversible/irreversible processes'),

('phys_kinetic_theory', 'Kinetic Theory of Gases', 'Physics', 23,
 'Equation of state of perfect gas, kinetic theory assumptions, pressure, kinetic interpretation of temperature, RMS speed, degrees of freedom, equipartition of energy, mean free path'),

('phys_oscillations_waves', 'Oscillations and Waves', 'Physics', 24,
 'Periodic motion, SHM equation, phase, spring oscillations, energy in SHM, simple pendulum, wave motion, longitudinal/transverse waves, superposition, standing waves, harmonics, beats'),

('phys_electrostatics', 'Electrostatics', 'Physics', 25,
 'Electric charges, Coulomb''s law, superposition, electric field, dipole, Gauss''s law, electric potential, equipotential surfaces, potential energy, capacitors, dielectrics, energy stored in capacitor'),

('phys_current_electricity', 'Current Electricity', 'Physics', 26,
 'Drift velocity, mobility, Ohm''s law, resistance, I-V characteristics, electrical energy/power, resistivity, series/parallel resistors, internal resistance, emf, Kirchhoff''s laws, Wheatstone/Metre bridge'),

('phys_magnetic_effects_magnetism', 'Magnetic Effects of Current and Magnetism', 'Physics', 27,
 'Biot-Savart law, Ampere''s law, force on moving charge, force on current-carrying conductor, force between parallel conductors, torque on current loop, galvanometer, magnetic dipole, para/dia/ferromagnetism'),

('phys_em_induction_ac', 'Electromagnetic Induction and Alternating Currents', 'Physics', 28,
 'Faraday''s law, Lenz''s law, eddy currents, self/mutual inductance, AC peak/RMS values, reactance/impedance, LCR circuit, resonance, AC power, generator, transformer'),

('phys_em_waves', 'Electromagnetic Waves', 'Physics', 29,
 'Displacement current, EM wave characteristics, transverse nature, EM spectrum and applications'),

('phys_optics', 'Optics', 'Physics', 30,
 'Reflection, spherical mirrors, refraction, thin lens/lens maker formula, total internal reflection, magnification, power of lens, prism, microscope/telescope, wave optics, Huygens principle, Young''s double slit, diffraction, polarization, Brewster''s law'),

('phys_dual_nature', 'Dual Nature of Matter and Radiation', 'Physics', 31,
 'Photoelectric effect, Hertz/Lenard observations, Einstein''s equation, particle nature of light, matter waves, de Broglie relation'),

('phys_atoms_nuclei', 'Atoms and Nuclei', 'Physics', 32,
 'Rutherford model, Bohr model, energy levels, hydrogen spectrum, nuclear composition, mass-energy relation, mass defect, binding energy, nuclear fission and fusion'),

('phys_electronic_devices', 'Electronic Devices', 'Physics', 33,
 'Semiconductors, diode I-V characteristics, rectifier, LED, photodiode, solar cell, Zener diode as voltage regulator, logic gates (OR, AND, NOT, NAND, NOR)'),

('phys_experimental_skills', 'Experimental Skills', 'Physics', 34,
 'Vernier calipers, screw gauge, simple pendulum, Young''s modulus, surface tension, viscosity, speed of sound, specific heat, metre bridge, Ohm''s law, galvanometer, focal length, prism, p-n junction characteristics'),

-- ============================================================
-- CHEMISTRY - PHYSICAL (8 units)
-- ============================================================

('chem_basic_concepts', 'Some Basic Concepts in Chemistry', 'Chemistry - Physical', 35,
 'Matter, Dalton''s atomic theory, atom/molecule/element/compound, laws of chemical combination, mole concept, molar mass, percentage composition, empirical/molecular formulae, stoichiometry'),

('chem_atomic_structure', 'Atomic Structure', 'Chemistry - Physical', 36,
 'EM radiation, photoelectric effect, hydrogen spectrum, Bohr model, dual nature of matter, de Broglie, Heisenberg uncertainty, quantum mechanics, atomic orbitals, quantum numbers, s/p/d orbital shapes, electron configuration rules'),

('chem_chemical_bonding', 'Chemical Bonding and Molecular Structure', 'Chemistry - Physical', 37,
 'Kossel-Lewis approach, ionic/covalent bonds, lattice enthalpy, electronegativity, VSEPR theory, valence bond theory, hybridization, resonance, molecular orbital theory, bond order, metallic bonding, hydrogen bonding'),

('chem_thermodynamics', 'Chemical Thermodynamics', 'Chemistry - Physical', 38,
 'System/surroundings, state functions, entropy, first law, work/heat/enthalpy, Hess''s law, enthalpies of various processes, second law, spontaneity, Gibbs energy, equilibrium constant'),

('chem_solutions', 'Solutions', 'Chemistry - Physical', 39,
 'Concentration methods (molality, molarity, mole fraction), Raoult''s law, ideal/non-ideal solutions, colligative properties, molecular mass determination, van''t Hoff factor'),

('chem_equilibrium', 'Equilibrium', 'Chemistry - Physical', 40,
 'Dynamic equilibrium, physical/chemical equilibria, Henry''s law, law of chemical equilibrium, Le Chatelier''s principle, ionic equilibrium, acids/bases, pH scale, common ion effect, hydrolysis, solubility products, buffer solutions'),

('chem_redox_electrochemistry', 'Redox Reactions and Electrochemistry', 'Chemistry - Physical', 41,
 'Oxidation/reduction, oxidation number, balancing redox reactions, electrolytic/metallic conduction, molar conductivity, Kohlrausch''s law, electrochemical cells, electrode potentials, Nernst equation, Gibbs energy, dry cell, fuel cells'),

('chem_chemical_kinetics', 'Chemical Kinetics', 'Chemistry - Physical', 42,
 'Rate of reaction, factors affecting rate, order/molecularity, rate law, zero/first order reactions, half-lives, Arrhenius theory, activation energy, collision theory'),

-- ============================================================
-- CHEMISTRY - INORGANIC (4 units)
-- ============================================================

('chem_periodic_table', 'Classification of Elements and Periodicity', 'Chemistry - Inorganic', 43,
 'Modern periodic law, s/p/d/f block elements, periodic trends (atomic/ionic radii, ionization enthalpy, electron gain enthalpy, valence, oxidation states, chemical reactivity)'),

('chem_p_block', 'p-Block Elements', 'Chemistry - Inorganic', 44,
 'Group 13-18 elements, electronic configuration, general trends in physical/chemical properties, unique behaviour of first element in each group'),

('chem_d_f_block', 'd and f-Block Elements', 'Chemistry - Inorganic', 45,
 'Transition elements, electronic configuration, properties (ionization enthalpy, oxidation states, colour, catalytic behaviour, magnetic properties, complex formation), K2Cr2O7 and KMnO4, lanthanoids, actinoids'),

('chem_coordination_compounds', 'Coordination Compounds', 'Chemistry - Inorganic', 46,
 'Werner''s theory, ligands, coordination number, denticity, chelation, IUPAC nomenclature, isomerism, valence bond approach, crystal field theory, colour/magnetic properties, applications'),

-- ============================================================
-- CHEMISTRY - ORGANIC (8 units)
-- ============================================================

('chem_purification_characterisation', 'Purification and Characterisation of Organic Compounds', 'Chemistry - Organic', 47,
 'Crystallization, sublimation, distillation, differential extraction, chromatography, qualitative/quantitative analysis, empirical/molecular formulae'),

('chem_basic_organic_principles', 'Some Basic Principles of Organic Chemistry', 'Chemistry - Organic', 48,
 'Tetravalency of carbon, hybridization, functional groups, homologous series, isomerism, IUPAC nomenclature, bond fission, free radicals, carbocations, carbanions, inductive/electromeric effect, resonance, hyperconjugation, reaction types'),

('chem_hydrocarbons', 'Hydrocarbons', 'Chemistry - Organic', 49,
 'Alkanes (conformations, halogenation), alkenes (geometrical isomerism, electrophilic addition, Markownikoff''s rule, ozonolysis), alkynes (acidic character, addition reactions), aromatic hydrocarbons (benzene, aromaticity, electrophilic substitution)'),

('chem_haloalkanes', 'Organic Compounds Containing Halogens', 'Chemistry - Organic', 50,
 'Preparation, properties, C-X bond nature, substitution reaction mechanisms, environmental effects of chloroform, iodoform, freons, DDT'),

('chem_oxygen_compounds', 'Organic Compounds Containing Oxygen', 'Chemistry - Organic', 51,
 'Alcohols (primary/secondary/tertiary, dehydration), phenols (acidic nature, electrophilic substitution, Reimer-Tiemann), ethers, aldehydes/ketones (carbonyl group, nucleophilic addition, Grignard, Aldol, Cannizzaro, Haloform), carboxylic acids'),

('chem_nitrogen_compounds', 'Organic Compounds Containing Nitrogen', 'Chemistry - Organic', 52,
 'Amines (nomenclature, classification, basic character), diazonium salts (importance in synthesis)'),

('chem_biomolecules', 'Biomolecules', 'Chemistry - Organic', 53,
 'Carbohydrates (aldoses, ketoses, monosaccharides, oligosaccharides), proteins (amino acids, peptide bond, protein structure, denaturation, enzymes), vitamins, nucleic acids (DNA, RNA), hormones'),

('chem_practical_chemistry', 'Principles Related to Practical Chemistry', 'Chemistry - Organic', 54,
 'Detection of elements and functional groups, preparation of inorganic/organic compounds, titrimetric exercises, qualitative salt analysis, experimental chemistry principles')

ON CONFLICT (id) DO NOTHING;


-- Step 5: Insert chapter prerequisite relationships
-- Based on NTA JEE Mains syllabus logical progression
-- Format: (chapter_id, prereq_id) means prereq_id must be learned before chapter_id

INSERT INTO chapter_prerequisites (chapter_id, prereq_id) VALUES

-- ============================================================
-- MATHEMATICS INTERNAL PREREQUISITES
-- ============================================================

-- Complex Numbers & Quadratic Equations requires Sets, Relations and Functions (function concepts, number systems)
('math_complex_numbers_quadratic', 'math_sets_relations_functions'),

-- Matrices & Determinants requires Sets (for solution sets) 
('math_matrices_determinants', 'math_sets_relations_functions'),

-- Permutations & Combinations requires Sets (counting from sets)
('math_permutations_combinations', 'math_sets_relations_functions'),

-- Binomial Theorem requires Permutations & Combinations (C(n,r) used in binomial coefficients)
('math_binomial_theorem', 'math_permutations_combinations'),

-- Binomial Theorem requires Sequence & Series (series expansion concepts)
('math_binomial_theorem', 'math_sequence_series'),

-- Sequence & Series requires Sets (sequences as functions from N)
('math_sequence_series', 'math_sets_relations_functions'),

-- Limit, Continuity & Differentiability requires Sets/Relations/Functions (function concepts are foundational)
('math_limit_continuity_differentiability', 'math_sets_relations_functions'),

-- Limit, Continuity & Differentiability requires Trigonometry (trig function limits, derivatives of trig functions)
('math_limit_continuity_differentiability', 'math_trigonometry'),

-- Limit, Continuity & Differentiability requires Coordinate Geometry (graphs, geometric interpretation)
('math_limit_continuity_differentiability', 'math_coordinate_geometry'),

-- Integral Calculus requires Limit, Continuity & Differentiability (anti-derivatives, fundamental theorem)
('math_integral_calculus', 'math_limit_continuity_differentiability'),

-- Integral Calculus requires Trigonometry (integration of trig functions)
('math_integral_calculus', 'math_trigonometry'),

-- Differential Equations requires Integral Calculus (solving DEs requires integration)
('math_differential_equations', 'math_integral_calculus'),

-- Coordinate Geometry requires Sets/Relations/Functions (locus as set of points, equations)
('math_coordinate_geometry', 'math_sets_relations_functions'),

-- Coordinate Geometry requires Complex Numbers & Quadratic (quadratic equations for conics, discriminant)
('math_coordinate_geometry', 'math_complex_numbers_quadratic'),

-- Three Dimensional Geometry requires Vector Algebra (direction ratios, line equations use vectors)
('math_three_dimensional_geometry', 'math_vector_algebra'),

-- Three Dimensional Geometry requires Coordinate Geometry (extends 2D concepts to 3D)
('math_three_dimensional_geometry', 'math_coordinate_geometry'),

-- Vector Algebra requires Trigonometry (angle between vectors, projections)
('math_vector_algebra', 'math_trigonometry'),

-- Vector Algebra requires Coordinate Geometry (components in coordinate system)
('math_vector_algebra', 'math_coordinate_geometry'),

-- Statistics & Probability requires Permutations & Combinations (counting for probability)
('math_statistics_probability', 'math_permutations_combinations'),

-- Statistics & Probability requires Sets/Relations/Functions (sample space as set, events)
('math_statistics_probability', 'math_sets_relations_functions'),

-- Trigonometry requires Sets/Relations/Functions (trig as functions, domain/range)
('math_trigonometry', 'math_sets_relations_functions'),

-- ============================================================
-- PHYSICS INTERNAL PREREQUISITES
-- ============================================================

-- Kinematics requires Units & Measurements (dimensional analysis, units for velocity/acceleration)
('phys_kinematics', 'phys_units_measurements'),

-- Laws of Motion requires Kinematics (velocity, acceleration concepts needed for F=ma)
('phys_laws_of_motion', 'phys_kinematics'),

-- Work, Energy & Power requires Laws of Motion (force concept, Newton's laws)
('phys_work_energy_power', 'phys_laws_of_motion'),

-- Rotational Motion requires Laws of Motion (torque as rotational analog of force)
('phys_rotational_motion', 'phys_laws_of_motion'),

-- Rotational Motion requires Work, Energy & Power (rotational KE, conservation of energy in rotation)
('phys_rotational_motion', 'phys_work_energy_power'),

-- Gravitation requires Laws of Motion (gravitational force, circular orbits need centripetal force)
('phys_gravitation', 'phys_laws_of_motion'),

-- Gravitation requires Work, Energy & Power (gravitational PE, escape velocity uses energy conservation)
('phys_gravitation', 'phys_work_energy_power'),

-- Properties of Solids & Liquids requires Laws of Motion (forces, pressure, equilibrium)
('phys_properties_solids_liquids', 'phys_laws_of_motion'),

-- Properties of Solids & Liquids requires Work, Energy & Power (energy concepts for surface tension, Bernoulli)
('phys_properties_solids_liquids', 'phys_work_energy_power'),

-- Thermodynamics requires Properties of Solids & Liquids (thermal properties, heat transfer covered there)
('phys_thermodynamics', 'phys_properties_solids_liquids'),

-- Kinetic Theory requires Thermodynamics (temperature, heat, internal energy concepts)
('phys_kinetic_theory', 'phys_thermodynamics'),

-- Kinetic Theory requires Laws of Motion (molecular collisions, pressure from momentum transfer)
('phys_kinetic_theory', 'phys_laws_of_motion'),

-- Oscillations & Waves requires Laws of Motion (restoring force, SHM from F=-kx)
('phys_oscillations_waves', 'phys_laws_of_motion'),

-- Oscillations & Waves requires Work, Energy & Power (energy in SHM, spring PE)
('phys_oscillations_waves', 'phys_work_energy_power'),

-- Electrostatics requires Units & Measurements (Coulomb's law units, dimensional analysis)
('phys_electrostatics', 'phys_units_measurements'),

-- Electrostatics requires Laws of Motion (force concepts, equilibrium)
('phys_electrostatics', 'phys_laws_of_motion'),

-- Current Electricity requires Electrostatics (electric field, potential, charge concepts)
('phys_current_electricity', 'phys_electrostatics'),

-- Magnetic Effects & Magnetism requires Current Electricity (current needed for magnetic field)
('phys_magnetic_effects_magnetism', 'phys_current_electricity'),

-- Magnetic Effects & Magnetism requires Kinematics (force on moving charge, circular motion in B field)
('phys_magnetic_effects_magnetism', 'phys_kinematics'),

-- EM Induction & AC requires Magnetic Effects (Faraday's law needs magnetic flux concepts)
('phys_em_induction_ac', 'phys_magnetic_effects_magnetism'),

-- EM Induction & AC requires Oscillations & Waves (AC as oscillation, LCR resonance)
('phys_em_induction_ac', 'phys_oscillations_waves'),

-- EM Waves requires EM Induction & AC (displacement current, Maxwell's equations)
('phys_em_waves', 'phys_em_induction_ac'),

-- EM Waves requires Electrostatics (electric field concepts)
('phys_em_waves', 'phys_electrostatics'),

-- Optics requires Oscillations & Waves (wave nature of light, interference, diffraction)
('phys_optics', 'phys_oscillations_waves'),

-- Optics requires EM Waves (light as EM wave)
('phys_optics', 'phys_em_waves'),

-- Dual Nature requires Optics (photoelectric effect, wave-particle duality of light)
('phys_dual_nature', 'phys_optics'),

-- Dual Nature requires Electrostatics (work function, electron energy)
('phys_dual_nature', 'phys_electrostatics'),

-- Atoms & Nuclei requires Dual Nature (de Broglie, wave nature of electron for Bohr model)
('phys_atoms_nuclei', 'phys_dual_nature'),

-- Atoms & Nuclei requires Electrostatics (Coulomb force in atom, potential energy)
('phys_atoms_nuclei', 'phys_electrostatics'),

-- Electronic Devices requires Current Electricity (circuits, I-V characteristics)
('phys_electronic_devices', 'phys_current_electricity'),

-- Electronic Devices requires Atoms & Nuclei (semiconductor band theory, atomic structure)
('phys_electronic_devices', 'phys_atoms_nuclei'),

-- Experimental Skills requires Units & Measurements (measurement techniques, errors)
('phys_experimental_skills', 'phys_units_measurements'),

-- ============================================================
-- CHEMISTRY INTERNAL PREREQUISITES
-- ============================================================

-- PHYSICAL CHEMISTRY chain
-- Atomic Structure requires Basic Concepts (atom, molecule, element concepts)
('chem_atomic_structure', 'chem_basic_concepts'),

-- Chemical Bonding requires Atomic Structure (electron configuration, orbitals)
('chem_chemical_bonding', 'chem_atomic_structure'),

-- Chemical Thermodynamics requires Basic Concepts (stoichiometry, mole concept for enthalpy calculations)
('chem_thermodynamics', 'chem_basic_concepts'),

-- Solutions requires Basic Concepts (concentration, mole concept)
('chem_solutions', 'chem_basic_concepts'),

-- Solutions requires Chemical Thermodynamics (enthalpy of solution, Raoult's law thermodynamic basis)
('chem_solutions', 'chem_thermodynamics'),

-- Equilibrium requires Chemical Thermodynamics (Gibbs energy, spontaneity, equilibrium constant relation)
('chem_equilibrium', 'chem_thermodynamics'),

-- Equilibrium requires Solutions (ionic equilibrium in solutions, pH, buffer solutions)
('chem_equilibrium', 'chem_solutions'),

-- Redox & Electrochemistry requires Equilibrium (Nernst equation, cell potential and Gibbs energy)
('chem_redox_electrochemistry', 'chem_equilibrium'),

-- Redox & Electrochemistry requires Basic Concepts (oxidation number, balancing equations)
('chem_redox_electrochemistry', 'chem_basic_concepts'),

-- Chemical Kinetics requires Chemical Thermodynamics (activation energy, Arrhenius equation)
('chem_chemical_kinetics', 'chem_thermodynamics'),

-- Chemical Kinetics requires Equilibrium (rate vs equilibrium, dynamic equilibrium concept)
('chem_chemical_kinetics', 'chem_equilibrium'),

-- INORGANIC CHEMISTRY chain
-- Periodic Table requires Atomic Structure (electron configuration determines periodic position)
('chem_periodic_table', 'chem_atomic_structure'),

-- Periodic Table requires Chemical Bonding (bonding trends across periods/groups)
('chem_periodic_table', 'chem_chemical_bonding'),

-- p-Block Elements requires Periodic Table (periodic trends, group properties)
('chem_p_block', 'chem_periodic_table'),

-- d and f-Block requires Periodic Table (transition metal position, electron configuration)
('chem_d_f_block', 'chem_periodic_table'),

-- d and f-Block requires Redox & Electrochemistry (variable oxidation states, redox chemistry of transition metals)
('chem_d_f_block', 'chem_redox_electrochemistry'),

-- Coordination Compounds requires d and f-Block (transition metal chemistry)
('chem_coordination_compounds', 'chem_d_f_block'),

-- Coordination Compounds requires Chemical Bonding (VBT, CFT, hybridization in complexes)
('chem_coordination_compounds', 'chem_chemical_bonding'),

-- ORGANIC CHEMISTRY chain
-- Basic Principles of Organic Chemistry requires Chemical Bonding (covalent bonds, hybridization)
('chem_basic_organic_principles', 'chem_chemical_bonding'),

-- Basic Principles requires Purification & Characterisation (need to identify compounds before studying them)
('chem_basic_organic_principles', 'chem_purification_characterisation'),

-- Purification & Characterisation requires Basic Concepts (empirical/molecular formulae, stoichiometry)
('chem_purification_characterisation', 'chem_basic_concepts'),

-- Hydrocarbons requires Basic Principles of Organic Chemistry (nomenclature, isomerism, reaction mechanisms)
('chem_hydrocarbons', 'chem_basic_organic_principles'),

-- Haloalkanes requires Hydrocarbons (substitution on hydrocarbons)
('chem_haloalkanes', 'chem_hydrocarbons'),

-- Haloalkanes requires Basic Principles (SN1/SN2 mechanisms, nucleophilic substitution)
('chem_haloalkanes', 'chem_basic_organic_principles'),

-- Oxygen Compounds requires Hydrocarbons (derived from hydrocarbons by introducing O)
('chem_oxygen_compounds', 'chem_hydrocarbons'),

-- Oxygen Compounds requires Haloalkanes (preparation methods involve haloalkanes)
('chem_oxygen_compounds', 'chem_haloalkanes'),

-- Nitrogen Compounds requires Hydrocarbons (amines derived from hydrocarbons)
('chem_nitrogen_compounds', 'chem_hydrocarbons'),

-- Nitrogen Compounds requires Oxygen Compounds (some preparations involve oxygen-containing intermediates)
('chem_nitrogen_compounds', 'chem_oxygen_compounds'),

-- Biomolecules requires Oxygen Compounds (carbohydrates, amino acids have -OH, -COOH, -CHO groups)
('chem_biomolecules', 'chem_oxygen_compounds'),

-- Biomolecules requires Nitrogen Compounds (amino acids, nucleic acids contain nitrogen)
('chem_biomolecules', 'chem_nitrogen_compounds'),

-- Practical Chemistry requires Equilibrium (titrations, salt analysis, indicators)
('chem_practical_chemistry', 'chem_equilibrium'),

-- Practical Chemistry requires Redox & Electrochemistry (KMnO4 titrations, redox titrations)
('chem_practical_chemistry', 'chem_redox_electrochemistry'),

-- Practical Chemistry requires Basic Organic Principles (functional group detection)
('chem_practical_chemistry', 'chem_basic_organic_principles'),

-- ============================================================
-- CROSS-SUBJECT PREREQUISITES (Math → Physics)
-- ============================================================

-- Kinematics requires Trigonometry (projectile motion uses sin/cos, circular motion)
('phys_kinematics', 'math_trigonometry'),

-- Kinematics requires Limit, Continuity & Differentiability (instantaneous velocity = derivative)
('phys_kinematics', 'math_limit_continuity_differentiability'),

-- Laws of Motion requires Vector Algebra (force as vector, resolution of forces)
('phys_laws_of_motion', 'math_vector_algebra'),

-- Work, Energy & Power requires Integral Calculus (work by variable force = integral of F.dx)
('phys_work_energy_power', 'math_integral_calculus'),

-- Work, Energy & Power requires Limit, Continuity & Differentiability (instantaneous power = dW/dt)
('phys_work_energy_power', 'math_limit_continuity_differentiability'),

-- Rotational Motion requires Integral Calculus (moment of inertia = integral of r²dm)
('phys_rotational_motion', 'math_integral_calculus'),

-- Rotational Motion requires Vector Algebra (torque = r × F, angular momentum = r × p)
('phys_rotational_motion', 'math_vector_algebra'),

-- Gravitation requires Integral Calculus (gravitational PE from integration)
('phys_gravitation', 'math_integral_calculus'),

-- Oscillations & Waves requires Limit, Continuity & Differentiability (SHM equation involves d²x/dt²)
('phys_oscillations_waves', 'math_limit_continuity_differentiability'),

-- Oscillations & Waves requires Trigonometry (SHM displacement = A sin(ωt + φ))
('phys_oscillations_waves', 'math_trigonometry'),

-- Oscillations & Waves requires Differential Equations (SHM is solution of d²x/dt² + ω²x = 0)
('phys_oscillations_waves', 'math_differential_equations'),

-- Electrostatics requires Integral Calculus (Gauss's law, potential from integration)
('phys_electrostatics', 'math_integral_calculus'),

-- Electrostatics requires Vector Algebra (electric field as vector, flux = E·dA)
('phys_electrostatics', 'math_vector_algebra'),

-- Magnetic Effects requires Vector Algebra (B = μ₀/4π × Idl×r/r³, Lorentz force F = qv×B)
('phys_magnetic_effects_magnetism', 'math_vector_algebra'),

-- EM Induction & AC requires Differential Equations (AC circuit differential equations, LCR)
('phys_em_induction_ac', 'math_differential_equations'),

-- EM Induction & AC requires Trigonometry (AC as sinusoidal functions)
('phys_em_induction_ac', 'math_trigonometry'),

-- Optics requires Trigonometry (Snell's law, angle calculations)
('phys_optics', 'math_trigonometry'),

-- Optics requires Coordinate Geometry (mirror/lens formula, ray diagrams)
('phys_optics', 'math_coordinate_geometry'),

-- ============================================================
-- CROSS-SUBJECT PREREQUISITES (Math → Chemistry)
-- ============================================================

-- Atomic Structure requires Sets/Relations/Functions (quantum numbers as sets, electron configuration rules)
('chem_atomic_structure', 'math_sets_relations_functions'),

-- Chemical Thermodynamics requires Integral Calculus (work = ∫PdV, enthalpy calculations)
('chem_thermodynamics', 'math_integral_calculus'),

-- Chemical Kinetics requires Limit, Continuity & Differentiability (rate = d[A]/dt, differential rate law)
('chem_chemical_kinetics', 'math_limit_continuity_differentiability'),

-- Chemical Kinetics requires Integral Calculus (integrated rate laws)
('chem_chemical_kinetics', 'math_integral_calculus'),

-- Equilibrium requires Statistics & Probability (equilibrium constant, Le Chatelier's principle involves probabilistic arguments)
('chem_equilibrium', 'math_statistics_probability'),

-- ============================================================
-- CROSS-SUBJECT PREREQUISITES (Physics → Chemistry)
-- ============================================================

-- Atomic Structure requires Dual Nature of Matter (photoelectric effect, de Broglie, wave-particle duality)
('chem_atomic_structure', 'phys_dual_nature'),

-- Atomic Structure requires Optics (spectrum of hydrogen atom, electromagnetic radiation)
('chem_atomic_structure', 'phys_optics'),

-- Chemical Thermodynamics requires Thermodynamics (Physics) (laws of thermodynamics, heat/work concepts)
('chem_thermodynamics', 'phys_thermodynamics'),

-- Kinetic Theory (Physics) → States of matter concepts used in Solutions
('chem_solutions', 'phys_kinetic_theory'),

-- Redox & Electrochemistry requires Electrostatics (electric potential, charge concepts)
('chem_redox_electrochemistry', 'phys_electrostatics'),

-- Redox & Electrochemistry requires Current Electricity (conductance, cell circuits)
('chem_redox_electrochemistry', 'phys_current_electricity')

ON CONFLICT (chapter_id, prereq_id) DO NOTHING;