-- Migration 006: Replace old 81 micro-concepts with NTA syllabus subconcepts
-- Source: NTA JEE Mains Detailed Syllabus (official document)
-- Each bullet point under each NTA unit becomes a micro-concept
-- Concepts are linked to their parent chapter via chapter_id

-- Step 1: Clear all dependent data (order matters for FK constraints)
DELETE FROM user_concept_mastery;
DELETE FROM user_question_attempts;
DELETE FROM questions;
DELETE FROM concept_prerequisites;
DELETE FROM concepts;

-- Step 2: Insert all NTA subconcepts as micro-concepts
-- ============================================================
-- MATHEMATICS
-- ============================================================

-- Unit 1: Sets, Relations and Functions (math_sets_relations_functions)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('m_sets_representation', 'Sets and their representation', 'Mathematics', 'math_sets_relations_functions'),
('m_sets_operations', 'Union, intersection and complement of sets and their algebraic properties', 'Mathematics', 'math_sets_relations_functions'),
('m_power_set', 'Power set', 'Mathematics', 'math_sets_relations_functions'),
('m_relations_types', 'Relations, type of relations, equivalence relations', 'Mathematics', 'math_sets_relations_functions'),
('m_functions_types', 'Functions: one-one, into and onto functions', 'Mathematics', 'math_sets_relations_functions'),
('m_composition_functions', 'The composition of functions', 'Mathematics', 'math_sets_relations_functions'),

-- Unit 2: Complex Numbers and Quadratic Equations (math_complex_numbers_quadratic)
('m_complex_ordered_pairs', 'Complex numbers as ordered pairs of reals', 'Mathematics', 'math_complex_numbers_quadratic'),
('m_complex_representation', 'Representation of complex numbers in a+ib form and Argand diagram', 'Mathematics', 'math_complex_numbers_quadratic'),
('m_complex_algebra_modulus', 'Algebra of complex numbers, modulus and argument', 'Mathematics', 'math_complex_numbers_quadratic'),
('m_quadratic_solutions', 'Quadratic equations in real and complex number systems', 'Mathematics', 'math_complex_numbers_quadratic'),
('m_roots_coefficients', 'Relations between roots and coefficients, nature of roots, formation of quadratic equations', 'Mathematics', 'math_complex_numbers_quadratic'),

-- Unit 3: Matrices and Determinants (math_matrices_determinants)
('m_matrices_algebra', 'Matrices, algebra of matrices, types of matrices', 'Mathematics', 'math_matrices_determinants'),
('m_determinants_evaluation', 'Determinants of order two and three, evaluation, area of triangles', 'Mathematics', 'math_matrices_determinants'),
('m_adjoint_inverse', 'Adjoint and inverse of a square matrix', 'Mathematics', 'math_matrices_determinants'),
('m_linear_equations_matrices', 'Test of consistency and solution of simultaneous linear equations using matrices', 'Mathematics', 'math_matrices_determinants'),

-- Unit 4: Permutations and Combinations (math_permutations_combinations)
('m_counting_principle', 'Fundamental principle of counting', 'Mathematics', 'math_permutations_combinations'),
('m_pnr_cnr', 'Permutations P(n,r) and Combinations C(n,r) and applications', 'Mathematics', 'math_permutations_combinations'),

-- Unit 5: Binomial Theorem (math_binomial_theorem)
('m_binomial_positive_index', 'Binomial theorem for a positive integral index', 'Mathematics', 'math_binomial_theorem'),
('m_binomial_general_middle', 'General term and middle term and simple applications', 'Mathematics', 'math_binomial_theorem'),

-- Unit 6: Sequence and Series (math_sequence_series)
('m_ap_gp', 'Arithmetic and Geometric progressions', 'Mathematics', 'math_sequence_series'),
('m_insertion_means', 'Insertion of arithmetic and geometric means between two numbers', 'Mathematics', 'math_sequence_series'),
('m_am_gm_relation', 'Relation between A.M and G.M', 'Mathematics', 'math_sequence_series'),

-- Unit 7: Limit, Continuity and Differentiability (math_limit_continuity_differentiability)
('m_real_valued_functions', 'Real-valued functions, algebra of functions, polynomial/rational/trig/log/exp functions, inverse functions', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_graphs_simple_functions', 'Graphs of simple functions', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_limits_continuity_diff', 'Limits, continuity and differentiability', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_differentiation_rules', 'Differentiation of sum, difference, product and quotient of two functions', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_differentiation_special', 'Differentiation of trig, inverse trig, log, exp, composite and implicit functions', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_higher_order_derivatives', 'Derivatives of order upto two', 'Mathematics', 'math_limit_continuity_differentiability'),
('m_applications_derivatives', 'Applications of derivatives: rate of change, monotonic functions, maxima and minima', 'Mathematics', 'math_limit_continuity_differentiability'),

-- Unit 8: Integral Calculus (math_integral_calculus)
('m_integral_antiderivative', 'Integral as an anti-derivative', 'Mathematics', 'math_integral_calculus'),
('m_fundamental_integrals', 'Fundamental integrals involving algebraic, trig, exp and log functions', 'Mathematics', 'math_integral_calculus'),
('m_integration_techniques', 'Integration by substitution, by parts, by partial fractions, using trig identities', 'Mathematics', 'math_integral_calculus'),
('m_standard_integrals', 'Evaluation of simple integrals of standard types', 'Mathematics', 'math_integral_calculus'),
('m_fundamental_theorem_calculus', 'Fundamental theorem of calculus, properties of definite integrals', 'Mathematics', 'math_integral_calculus'),
('m_definite_integrals_areas', 'Evaluation of definite integrals, areas bounded by simple curves', 'Mathematics', 'math_integral_calculus'),

-- Unit 9: Differential Equations (math_differential_equations)
('m_ode_order_degree', 'Ordinary differential equations, their order and degree', 'Mathematics', 'math_differential_equations'),
('m_separation_variables', 'Solution by method of separation of variables', 'Mathematics', 'math_differential_equations'),
('m_linear_de', 'Solution of homogeneous and linear differential equations dy/dx + p(x)y = q(x)', 'Mathematics', 'math_differential_equations'),

-- Unit 10: Co-ordinate Geometry (math_coordinate_geometry)
('m_cartesian_system', 'Cartesian coordinates, distance formula, section formula, locus', 'Mathematics', 'math_coordinate_geometry'),
('m_slope_lines', 'Slope of a line, parallel and perpendicular lines, intercepts', 'Mathematics', 'math_coordinate_geometry'),
('m_straight_line_equations', 'Various forms of equations of a line, intersection, angles between lines, concurrence', 'Mathematics', 'math_coordinate_geometry'),
('m_point_line_distance', 'Distance of a point from a line, centroid, orthocentre, circumcentre', 'Mathematics', 'math_coordinate_geometry'),
('m_circle_equations', 'Circle: standard and general form, radius, centre, diameter endpoints', 'Mathematics', 'math_coordinate_geometry'),
('m_line_circle_intersection', 'Points of intersection of a line and a circle', 'Mathematics', 'math_coordinate_geometry'),
('m_conic_sections', 'Conic sections: parabola, ellipse and hyperbola in standard forms', 'Mathematics', 'math_coordinate_geometry'),

-- Unit 11: Three Dimensional Geometry (math_three_dimensional_geometry)
('m_3d_coordinates_distance', 'Coordinates in space, distance between points, section formula', 'Mathematics', 'math_three_dimensional_geometry'),
('m_direction_ratios_cosines', 'Direction ratios and cosines, angle between two lines', 'Mathematics', 'math_three_dimensional_geometry'),
('m_3d_line_skew', 'Equation of a line, skew lines, shortest distance', 'Mathematics', 'math_three_dimensional_geometry'),

-- Unit 12: Vector Algebra (math_vector_algebra)
('m_vectors_scalars_addition', 'Vectors and scalars, addition of vectors', 'Mathematics', 'math_vector_algebra'),
('m_vector_components_products', 'Components in 2D and 3D, scalar and vector products', 'Mathematics', 'math_vector_algebra');


-- Unit 13: Statistics and Probability (math_statistics_probability)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('m_measures_dispersion', 'Measures of dispersion: mean, median, mode of grouped and ungrouped data', 'Mathematics', 'math_statistics_probability'),
('m_std_deviation_variance', 'Standard deviation, variance and mean deviation', 'Mathematics', 'math_statistics_probability'),
('m_probability_event', 'Probability of an event, addition and multiplication theorems', 'Mathematics', 'math_statistics_probability'),
('m_bayes_theorem', 'Bayes theorem, probability distribution of a random variable', 'Mathematics', 'math_statistics_probability'),

-- Unit 14: Trigonometry (math_trigonometry)
('m_trig_identities_functions', 'Trigonometrical identities and trigonometrical functions', 'Mathematics', 'math_trigonometry'),
('m_inverse_trig_functions', 'Inverse trigonometrical functions and their properties', 'Mathematics', 'math_trigonometry'),

-- ============================================================
-- PHYSICS
-- ============================================================

-- Unit 1: Units and Measurements (phys_units_measurements)
('p_units_si_system', 'Units of measurements, system of units, SI units, fundamental and derived units', 'Physics', 'phys_units_measurements'),
('p_least_count_errors', 'Least count, significant figures, errors in measurements', 'Physics', 'phys_units_measurements'),
('p_dimensional_analysis', 'Dimensions of physical quantities, dimensional analysis and applications', 'Physics', 'phys_units_measurements'),

-- Unit 2: Kinematics (phys_kinematics)
('p_frame_reference_1d', 'Frame of reference, motion in a straight line, speed and velocity, uniform and non-uniform motion', 'Physics', 'phys_kinematics'),
('p_uniformly_accelerated', 'Average speed, instantaneous velocity, uniformly accelerated motion, v-t and x-t graphs, relative velocity', 'Physics', 'phys_kinematics'),
('p_motion_plane_projectile', 'Motion in a plane, projectile motion, uniform circular motion', 'Physics', 'phys_kinematics'),

-- Unit 3: Laws of Motion (phys_laws_of_motion)
('p_newtons_laws_impulse', 'Force and inertia, Newton''s three laws, momentum, impulse', 'Physics', 'phys_laws_of_motion'),
('p_conservation_momentum', 'Conservation of linear momentum and applications, equilibrium of concurrent forces', 'Physics', 'phys_laws_of_motion'),
('p_friction', 'Static and kinetic friction, laws of friction, rolling friction', 'Physics', 'phys_laws_of_motion'),
('p_circular_motion_dynamics', 'Dynamics of uniform circular motion, centripetal force, vehicle on level/banked road', 'Physics', 'phys_laws_of_motion'),

-- Unit 4: Work, Energy and Power (phys_work_energy_power)
('p_work_ke_pe_theorem', 'Work by constant and variable force, kinetic and potential energies, work-energy theorem, power', 'Physics', 'phys_work_energy_power'),
('p_spring_pe_conservation', 'Spring potential energy, conservation of mechanical energy, conservative/non-conservative forces, vertical circle', 'Physics', 'phys_work_energy_power'),
('p_collisions', 'Elastic and inelastic collisions in one and two dimensions', 'Physics', 'phys_work_energy_power'),

-- Unit 5: Rotational Motion (phys_rotational_motion)
('p_centre_of_mass', 'Centre of mass of two-particle system and rigid body', 'Physics', 'phys_rotational_motion'),
('p_torque_angular_momentum', 'Rotational motion basics, torque, angular momentum, conservation of angular momentum', 'Physics', 'phys_rotational_motion'),
('p_moment_of_inertia', 'Moment of inertia, radius of gyration, values for simple geometrical objects', 'Physics', 'phys_rotational_motion'),
('p_axes_theorems', 'Parallel and perpendicular axes theorems and applications', 'Physics', 'phys_rotational_motion'),
('p_rigid_body_equilibrium', 'Equilibrium of rigid bodies, equations of rotational motion, comparison with linear motion', 'Physics', 'phys_rotational_motion'),

-- Unit 6: Gravitation (phys_gravitation)
('p_universal_gravitation', 'Universal law of gravitation, acceleration due to gravity, variation with altitude and depth', 'Physics', 'phys_gravitation'),
('p_kepler_potential', 'Kepler''s laws, gravitational potential energy and potential', 'Physics', 'phys_gravitation'),
('p_satellites_escape', 'Escape velocity, satellite motion, orbital velocity, time period and energy', 'Physics', 'phys_gravitation'),

-- Unit 7: Properties of Solids and Liquids (phys_properties_solids_liquids)
('p_elasticity', 'Elastic behaviour, stress-strain, Hooke''s law, Young''s/bulk/rigidity modulus', 'Physics', 'phys_properties_solids_liquids'),
('p_fluid_pressure', 'Pressure due to fluid column, Pascal''s law, effect of gravity on fluid pressure', 'Physics', 'phys_properties_solids_liquids'),
('p_viscosity_bernoulli', 'Viscosity, Stoke''s law, terminal velocity, streamline/turbulent flow, Bernoulli''s principle', 'Physics', 'phys_properties_solids_liquids'),
('p_surface_tension', 'Surface energy and tension, angle of contact, excess pressure, drops, bubbles, capillary rise', 'Physics', 'phys_properties_solids_liquids'),
('p_thermal_properties', 'Heat, temperature, thermal expansion, specific heat, calorimetry, change of state, latent heat', 'Physics', 'phys_properties_solids_liquids'),
('p_heat_transfer', 'Heat transfer: conduction, convection and radiation', 'Physics', 'phys_properties_solids_liquids'),

-- Unit 8: Thermodynamics (phys_thermodynamics)
('p_zeroth_law_temperature', 'Thermal equilibrium, zeroth law, heat, work and internal energy', 'Physics', 'phys_thermodynamics'),
('p_first_law_processes', 'First law of thermodynamics, isothermal and adiabatic processes', 'Physics', 'phys_thermodynamics'),
('p_second_law', 'Second law of thermodynamics, reversible and irreversible processes', 'Physics', 'phys_thermodynamics'),

-- Unit 9: Kinetic Theory of Gases (phys_kinetic_theory)
('p_equation_state', 'Equation of state of a perfect gas, work done on compressing a gas', 'Physics', 'phys_kinetic_theory'),
('p_kinetic_theory_assumptions', 'Kinetic theory assumptions, concept of pressure, kinetic interpretation of temperature, RMS speed', 'Physics', 'phys_kinetic_theory'),
('p_degrees_freedom_equipartition', 'Degrees of freedom, equipartition of energy, specific heat capacities, mean free path, Avogadro''s number', 'Physics', 'phys_kinetic_theory'),

-- Unit 10: Oscillations and Waves (phys_oscillations_waves)
('p_periodic_motion', 'Oscillations and periodic motion: time period, frequency, displacement as function of time', 'Physics', 'phys_oscillations_waves'),
('p_shm_equation', 'SHM and its equation, phase, spring oscillations, restoring force and force constant', 'Physics', 'phys_oscillations_waves'),
('p_shm_energy_pendulum', 'Energy in SHM, simple pendulum time period derivation', 'Physics', 'phys_oscillations_waves'),
('p_wave_motion', 'Wave motion, longitudinal and transverse waves, speed of travelling wave, progressive wave', 'Physics', 'phys_oscillations_waves'),
('p_superposition_standing', 'Superposition of waves, reflection, standing waves in strings and organ pipes, harmonics, beats', 'Physics', 'phys_oscillations_waves'),

-- Unit 11: Electrostatics (phys_electrostatics)
('p_electric_charges_coulomb', 'Electric charges, conservation, Coulomb''s law, superposition principle, continuous charge distribution', 'Physics', 'phys_electrostatics'),
('p_electric_field_dipole', 'Electric field due to point charge, field lines, electric dipole, torque on dipole', 'Physics', 'phys_electrostatics'),
('p_gauss_law', 'Electric flux, Gauss''s law and applications (wire, plane sheet, spherical shell)', 'Physics', 'phys_electrostatics'),
('p_electric_potential', 'Electric potential for point charge, dipole, system of charges, equipotential surfaces', 'Physics', 'phys_electrostatics'),
('p_potential_energy', 'Electrical potential energy of point charges and dipole in electrostatic field', 'Physics', 'phys_electrostatics'),
('p_capacitors_dielectrics', 'Conductors, insulators, dielectrics, capacitors, series/parallel combination, energy stored', 'Physics', 'phys_electrostatics'),

-- Unit 12: Current Electricity (phys_current_electricity)
('p_drift_velocity_current', 'Electric current, drift velocity, mobility', 'Physics', 'phys_current_electricity'),
('p_ohms_law_resistance', 'Ohm''s law, electrical resistance, I-V characteristics', 'Physics', 'phys_current_electricity'),
('p_power_resistivity', 'Electrical energy/power, resistivity, conductivity, series/parallel resistors, temperature dependence', 'Physics', 'phys_current_electricity'),
('p_emf_internal_resistance', 'Internal resistance, potential difference, emf of a cell, cells in series and parallel', 'Physics', 'phys_current_electricity'),
('p_kirchhoff_bridges', 'Kirchhoff''s laws, Wheatstone bridge, Metre bridge', 'Physics', 'phys_current_electricity');


-- Unit 13: Magnetic Effects of Current and Magnetism (phys_magnetic_effects_magnetism)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('p_biot_savart', 'Biot-Savart law and application to current carrying circular loop', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_ampere_law', 'Ampere''s law and applications to straight wire and solenoid', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_force_moving_charge', 'Force on moving charge in magnetic/electric fields, force on current-carrying conductor', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_parallel_conductors_torque', 'Force between parallel conductors, definition of ampere, torque on current loop', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_galvanometer', 'Moving coil galvanometer, sensitivity, conversion to ammeter and voltmeter', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_magnetic_dipole', 'Current loop as magnetic dipole, bar magnet as solenoid, magnetic field lines', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_magnetic_field_dipole', 'Magnetic field due to bar magnet along axis and perpendicular, torque on dipole', 'Physics', 'phys_magnetic_effects_magnetism'),
('p_magnetic_materials', 'Para-, dia- and ferromagnetic substances, effect of temperature', 'Physics', 'phys_magnetic_effects_magnetism'),

-- Unit 14: EM Induction and AC (phys_em_induction_ac)
('p_faraday_lenz', 'Faraday''s law, induced emf and current, Lenz''s law, eddy currents, self and mutual inductance', 'Physics', 'phys_em_induction_ac'),
('p_ac_values_impedance', 'AC peak and RMS values, reactance and impedance', 'Physics', 'phys_em_induction_ac'),
('p_lcr_resonance_power', 'LCR series circuit, resonance, power in AC circuits, wattless current, AC generator, transformer', 'Physics', 'phys_em_induction_ac'),

-- Unit 15: Electromagnetic Waves (phys_em_waves)
('p_displacement_current', 'Displacement current, EM wave characteristics, transverse nature', 'Physics', 'phys_em_waves'),
('p_em_spectrum', 'EM spectrum (radio, microwave, IR, visible, UV, X-ray, gamma), applications', 'Physics', 'phys_em_waves'),

-- Unit 16: Optics (phys_optics)
('p_reflection_mirrors', 'Reflection of light, spherical mirrors, mirror formula', 'Physics', 'phys_optics'),
('p_refraction_lenses', 'Refraction at plane/spherical surfaces, thin lens formula, lens maker formula, total internal reflection', 'Physics', 'phys_optics'),
('p_magnification_prism', 'Magnification, power of lens, combination of lenses, refraction through prism', 'Physics', 'phys_optics'),
('p_optical_instruments', 'Microscope and astronomical telescope (reflecting and refracting), magnifying powers', 'Physics', 'phys_optics'),
('p_wave_optics_huygens', 'Wave optics: wavefront, Huygens principle, laws of reflection and refraction', 'Physics', 'phys_optics'),
('p_interference_young', 'Interference: Young''s double-slit experiment, fringe width, coherent sources', 'Physics', 'phys_optics'),
('p_diffraction', 'Diffraction due to single slit, width of central maximum', 'Physics', 'phys_optics'),
('p_polarization', 'Polarization: plane-polarized light, Brewster''s law, Polaroid', 'Physics', 'phys_optics'),

-- Unit 17: Dual Nature of Matter and Radiation (phys_dual_nature)
('p_photoelectric_effect', 'Dual nature of radiation, photoelectric effect, Hertz and Lenard observations', 'Physics', 'phys_dual_nature'),
('p_einstein_equation', 'Einstein''s photoelectric equation, particle nature of light', 'Physics', 'phys_dual_nature'),
('p_matter_waves', 'Matter waves: wave nature of particle, de Broglie relation', 'Physics', 'phys_dual_nature'),

-- Unit 18: Atoms and Nuclei (phys_atoms_nuclei)
('p_atomic_models', 'Alpha-particle scattering, Rutherford model, Bohr model, energy levels, hydrogen spectrum', 'Physics', 'phys_atoms_nuclei'),
('p_nuclear_composition', 'Composition and size of nucleus, atomic masses, mass-energy relation, mass defect', 'Physics', 'phys_atoms_nuclei'),
('p_binding_energy_fission_fusion', 'Binding energy per nucleon, variation with mass number, nuclear fission and fusion', 'Physics', 'phys_atoms_nuclei'),

-- Unit 19: Electronic Devices (phys_electronic_devices)
('p_semiconductor_diode', 'Semiconductors, diode I-V characteristics in forward/reverse bias, rectifier', 'Physics', 'phys_electronic_devices'),
('p_led_photodiode_zener', 'LED, photodiode, solar cell, Zener diode as voltage regulator', 'Physics', 'phys_electronic_devices'),
('p_logic_gates', 'Logic gates: OR, AND, NOT, NAND and NOR', 'Physics', 'phys_electronic_devices'),

-- Unit 20: Experimental Skills (phys_experimental_skills)
('p_exp_mechanics', 'Vernier calipers, screw gauge, simple pendulum, metre scale, Young''s modulus', 'Physics', 'phys_experimental_skills'),
('p_exp_fluids_heat', 'Surface tension by capillary rise, viscosity, speed of sound, specific heat capacity', 'Physics', 'phys_experimental_skills'),
('p_exp_electricity', 'Resistivity (metre bridge), resistance (Ohm''s law), galvanometer figure of merit', 'Physics', 'phys_experimental_skills'),
('p_exp_optics', 'Focal length (parallax), angle of deviation vs incidence for prism, refractive index', 'Physics', 'phys_experimental_skills'),
('p_exp_electronics', 'Characteristic curves of p-n junction and Zener diodes, electronic components', 'Physics', 'phys_experimental_skills');


-- ============================================================
-- CHEMISTRY - PHYSICAL
-- ============================================================

-- Unit 1: Some Basic Concepts in Chemistry (chem_basic_concepts)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('c_matter_dalton', 'Matter and its nature, Dalton''s atomic theory, atom/molecule/element/compound, laws of chemical combination', 'Chemistry - Physical', 'chem_basic_concepts'),
('c_mole_concept', 'Atomic and molecular masses, mole concept, molar mass, percentage composition, empirical/molecular formulae, stoichiometry', 'Chemistry - Physical', 'chem_basic_concepts'),

-- Unit 2: Atomic Structure (chem_atomic_structure)
('c_em_radiation_photoelectric', 'Nature of EM radiation, photoelectric effect, hydrogen atom spectrum', 'Chemistry - Physical', 'chem_atomic_structure'),
('c_bohr_model', 'Bohr model of hydrogen atom, postulates, energy/radii relations, limitations', 'Chemistry - Physical', 'chem_atomic_structure'),
('c_dual_nature_uncertainty', 'Dual nature of matter, de Broglie relationship, Heisenberg uncertainty principle', 'Chemistry - Physical', 'chem_atomic_structure'),
('c_quantum_mechanics_orbitals', 'Quantum mechanical model, atomic orbitals, wave functions, quantum numbers', 'Chemistry - Physical', 'chem_atomic_structure'),
('c_orbital_shapes', 'Shapes of s, p and d orbitals, electron spin and spin quantum number', 'Chemistry - Physical', 'chem_atomic_structure'),
('c_electron_configuration', 'Aufbau principle, Pauli exclusion, Hund''s rule, electronic configuration, half-filled stability', 'Chemistry - Physical', 'chem_atomic_structure'),

-- Unit 3: Chemical Bonding and Molecular Structure (chem_chemical_bonding)
('c_kossel_lewis', 'Kossel-Lewis approach, concept of ionic and covalent bonds', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_ionic_bonding', 'Ionic bonding: formation, factors affecting, lattice enthalpy', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_covalent_vsepr', 'Covalent bonding: electronegativity, Fajan''s rule, dipole moment, VSEPR theory, molecular shapes', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_vbt_hybridization', 'Valence bond theory, hybridization involving s, p and d orbitals, resonance', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_mot', 'Molecular orbital theory: LCAOs, bonding/antibonding orbitals, sigma/pi bonds', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_mo_config_bond_order', 'MO electronic configurations of homonuclear diatomics, bond order, bond length, bond energy', 'Chemistry - Physical', 'chem_chemical_bonding'),
('c_metallic_hydrogen_bonding', 'Metallic bonding, hydrogen bonding and applications', 'Chemistry - Physical', 'chem_chemical_bonding'),

-- Unit 4: Chemical Thermodynamics (chem_thermodynamics)
('c_thermo_fundamentals', 'System/surroundings, extensive/intensive properties, state functions, entropy, types of processes', 'Chemistry - Physical', 'chem_thermodynamics'),
('c_first_law_hess', 'First law: work, heat, internal energy, enthalpy, heat capacities, Hess''s law', 'Chemistry - Physical', 'chem_thermodynamics'),
('c_enthalpies', 'Enthalpies of bond dissociation, combustion, formation, atomization, sublimation, phase transition, hydration, ionization, solution', 'Chemistry - Physical', 'chem_thermodynamics'),
('c_second_law_spontaneity', 'Second law: spontaneity, entropy of universe, Gibbs energy as criterion', 'Chemistry - Physical', 'chem_thermodynamics'),
('c_gibbs_equilibrium', 'Standard Gibbs energy change and equilibrium constant', 'Chemistry - Physical', 'chem_thermodynamics'),

-- Unit 5: Solutions (chem_solutions)
('c_concentration_methods', 'Concentration: molality, molarity, mole fraction, percentage', 'Chemistry - Physical', 'chem_solutions'),
('c_raoults_law', 'Vapour pressure, Raoult''s law, ideal and non-ideal solutions', 'Chemistry - Physical', 'chem_solutions'),
('c_colligative_properties', 'Colligative properties: vapour pressure lowering, freezing point depression, boiling point elevation, osmotic pressure', 'Chemistry - Physical', 'chem_solutions'),
('c_vant_hoff_factor', 'Molecular mass from colligative properties, abnormal molar mass, van''t Hoff factor', 'Chemistry - Physical', 'chem_solutions'),

-- Unit 6: Equilibrium (chem_equilibrium)
('c_dynamic_equilibrium', 'Meaning of equilibrium, concept of dynamic equilibrium', 'Chemistry - Physical', 'chem_equilibrium'),
('c_physical_equilibria', 'Physical equilibria: solid-liquid, liquid-gas, Henry''s law', 'Chemistry - Physical', 'chem_equilibrium'),
('c_chemical_equilibrium_law', 'Law of chemical equilibrium, equilibrium constants, Le Chatelier''s principle', 'Chemistry - Physical', 'chem_equilibrium'),
('c_ionic_equilibrium', 'Weak/strong electrolytes, acids and bases (Arrhenius, Bronsted-Lowry, Lewis)', 'Chemistry - Physical', 'chem_equilibrium'),
('c_ph_buffers_solubility', 'Ionization of water, pH scale, common ion effect, hydrolysis, solubility products, buffer solutions', 'Chemistry - Physical', 'chem_equilibrium'),

-- Unit 7: Redox Reactions and Electrochemistry (chem_redox_electrochemistry)
('c_redox_oxidation_number', 'Oxidation/reduction concepts, redox reactions, oxidation number, balancing', 'Chemistry - Physical', 'chem_redox_electrochemistry'),
('c_conductance', 'Electrolytic/metallic conduction, conductance, molar conductivity, Kohlrausch''s law', 'Chemistry - Physical', 'chem_redox_electrochemistry'),
('c_electrochemical_cells', 'Electrolytic and Galvanic cells, electrodes, electrode potentials, half-cell reactions, emf', 'Chemistry - Physical', 'chem_redox_electrochemistry'),
('c_nernst_gibbs', 'Nernst equation, cell potential and Gibbs energy, dry cell, lead accumulator, fuel cells', 'Chemistry - Physical', 'chem_redox_electrochemistry'),

-- Unit 8: Chemical Kinetics (chem_chemical_kinetics)
('c_rate_factors', 'Rate of reaction, factors affecting rate, elementary/complex reactions, order and molecularity', 'Chemistry - Physical', 'chem_chemical_kinetics'),
('c_rate_law_orders', 'Rate law, rate constant, zero and first-order reactions, characteristics, half-lives', 'Chemistry - Physical', 'chem_chemical_kinetics'),
('c_arrhenius_collision', 'Temperature effect on rate, Arrhenius theory, activation energy, collision theory', 'Chemistry - Physical', 'chem_chemical_kinetics');


-- ============================================================
-- CHEMISTRY - INORGANIC
-- ============================================================

-- Unit 9: Classification of Elements and Periodicity (chem_periodic_table)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('c_periodic_law_table', 'Modern periodic law, periodic table, s/p/d/f block elements', 'Chemistry - Inorganic', 'chem_periodic_table'),
('c_periodic_trends', 'Periodic trends: atomic/ionic radii, ionization enthalpy, electron gain enthalpy, valence, oxidation states, reactivity', 'Chemistry - Inorganic', 'chem_periodic_table'),

-- Unit 10: p-Block Elements (chem_p_block)
('c_p_block_general', 'Group 13-18 elements: electronic configuration, general trends in physical/chemical properties', 'Chemistry - Inorganic', 'chem_p_block'),
('c_p_block_first_element', 'Unique behaviour of first element in each group', 'Chemistry - Inorganic', 'chem_p_block'),

-- Unit 11: d and f-Block Elements (chem_d_f_block)
('c_transition_elements', 'Transition elements: electronic configuration, occurrence, general trends in first-row properties', 'Chemistry - Inorganic', 'chem_d_f_block'),
('c_transition_properties', 'Ionization enthalpy, oxidation states, colour, catalytic behaviour, magnetic properties, complex formation, alloys', 'Chemistry - Inorganic', 'chem_d_f_block'),
('c_dichromate_permanganate', 'Preparation, properties and uses of K2Cr2O7 and KMnO4', 'Chemistry - Inorganic', 'chem_d_f_block'),
('c_inner_transition', 'Lanthanoids (configuration, oxidation states, contraction) and Actinoids', 'Chemistry - Inorganic', 'chem_d_f_block'),

-- Unit 12: Coordination Compounds (chem_coordination_compounds)
('c_coord_intro_werner', 'Coordination compounds, Werner''s theory, ligands, coordination number, denticity, chelation', 'Chemistry - Inorganic', 'chem_coordination_compounds'),
('c_coord_nomenclature_isomerism', 'IUPAC nomenclature of mononuclear coordination compounds, isomerism', 'Chemistry - Inorganic', 'chem_coordination_compounds'),
('c_coord_bonding_cft', 'Bonding: valence bond approach, crystal field theory, colour and magnetic properties', 'Chemistry - Inorganic', 'chem_coordination_compounds'),
('c_coord_applications', 'Importance in qualitative analysis, extraction of metals, biological systems', 'Chemistry - Inorganic', 'chem_coordination_compounds'),

-- ============================================================
-- CHEMISTRY - ORGANIC
-- ============================================================

-- Unit 13: Purification and Characterisation (chem_purification_characterisation)
('c_purification_methods', 'Crystallization, sublimation, distillation, differential extraction, chromatography', 'Chemistry - Organic', 'chem_purification_characterisation'),
('c_qualitative_analysis_organic', 'Detection of nitrogen, sulphur, phosphorus and halogens', 'Chemistry - Organic', 'chem_purification_characterisation'),
('c_quantitative_analysis_organic', 'Estimation of C, H, N, halogens, S and P', 'Chemistry - Organic', 'chem_purification_characterisation'),
('c_empirical_molecular_formulae', 'Calculations of empirical and molecular formulae', 'Chemistry - Organic', 'chem_purification_characterisation'),

-- Unit 14: Basic Principles of Organic Chemistry (chem_basic_organic_principles)
('c_tetravalency_hybridization', 'Tetravalency of carbon, shapes of simple molecules, hybridization (s and p)', 'Chemistry - Organic', 'chem_basic_organic_principles'),
('c_classification_isomerism', 'Classification by functional groups and homologous series, structural and stereoisomerism', 'Chemistry - Organic', 'chem_basic_organic_principles'),
('c_nomenclature', 'Nomenclature: trivial and IUPAC', 'Chemistry - Organic', 'chem_basic_organic_principles'),
('c_bond_fission_intermediates', 'Homolytic/heterolytic fission, free radicals, carbocations, carbanions, electrophiles, nucleophiles', 'Chemistry - Organic', 'chem_basic_organic_principles'),
('c_electronic_effects', 'Inductive effect, electromeric effect, resonance and hyperconjugation', 'Chemistry - Organic', 'chem_basic_organic_principles'),
('c_organic_reaction_types', 'Substitution, addition, elimination and rearrangement reactions', 'Chemistry - Organic', 'chem_basic_organic_principles'),

-- Unit 15: Hydrocarbons (chem_hydrocarbons)
('c_hc_classification', 'Classification, isomerism, IUPAC nomenclature, general preparation, properties, reactions', 'Chemistry - Organic', 'chem_hydrocarbons'),
('c_alkanes', 'Alkanes: conformations (sawhorse, Newman), mechanism of halogenation', 'Chemistry - Organic', 'chem_hydrocarbons'),
('c_alkenes', 'Alkenes: geometrical isomerism, electrophilic addition, Markownikoff''s rule, peroxide effect, ozonolysis, polymerization', 'Chemistry - Organic', 'chem_hydrocarbons'),
('c_alkynes', 'Alkynes: acidic character, addition of H2/halogens/water/HX, polymerization', 'Chemistry - Organic', 'chem_hydrocarbons'),
('c_aromatic_hc', 'Aromatic hydrocarbons: benzene structure, aromaticity, electrophilic substitution, directive influence', 'Chemistry - Organic', 'chem_hydrocarbons'),

-- Unit 16: Organic Compounds Containing Halogens (chem_haloalkanes)
('c_haloalkane_prep_reactions', 'Preparation, properties, reactions, C-X bond nature, substitution mechanisms', 'Chemistry - Organic', 'chem_haloalkanes'),
('c_haloalkane_environmental', 'Uses and environmental effects of chloroform, iodoform, freons, DDT', 'Chemistry - Organic', 'chem_haloalkanes');


-- Unit 17: Organic Compounds Containing Oxygen (chem_oxygen_compounds)
INSERT INTO concepts (id, name, subject, chapter_id) VALUES
('c_alcohols', 'Alcohols: identification of primary/secondary/tertiary, mechanism of dehydration', 'Chemistry - Organic', 'chem_oxygen_compounds'),
('c_phenols', 'Phenols: acidic nature, electrophilic substitution, halogenation, nitration, sulphonation, Reimer-Tiemann', 'Chemistry - Organic', 'chem_oxygen_compounds'),
('c_ethers', 'Ethers: structure', 'Chemistry - Organic', 'chem_oxygen_compounds'),
('c_aldehydes_ketones', 'Aldehydes and ketones: carbonyl group, nucleophilic addition, Grignard, oxidation, reduction, aldol, Cannizzaro, haloform', 'Chemistry - Organic', 'chem_oxygen_compounds'),
('c_carboxylic_acids', 'Carboxylic acids: acidic strength and factors affecting it', 'Chemistry - Organic', 'chem_oxygen_compounds'),

-- Unit 18: Organic Compounds Containing Nitrogen (chem_nitrogen_compounds)
('c_amines', 'Amines: nomenclature, classification, structure, basic character, identification of primary/secondary/tertiary', 'Chemistry - Organic', 'chem_nitrogen_compounds'),
('c_diazonium_salts', 'Diazonium salts: importance in synthetic organic chemistry', 'Chemistry - Organic', 'chem_nitrogen_compounds'),

-- Unit 19: Biomolecules (chem_biomolecules)
('c_carbohydrates', 'Carbohydrates: classification, aldoses/ketoses, monosaccharides (glucose, fructose), oligosaccharides (sucrose, lactose, maltose)', 'Chemistry - Organic', 'chem_biomolecules'),
('c_proteins', 'Proteins: amino acids, peptide bond, polypeptides, protein structure (primary to quaternary), denaturation, enzymes', 'Chemistry - Organic', 'chem_biomolecules'),
('c_vitamins', 'Vitamins: classification and functions', 'Chemistry - Organic', 'chem_biomolecules'),
('c_nucleic_acids', 'Nucleic acids: DNA and RNA constitution, biological functions. Hormones', 'Chemistry - Organic', 'chem_biomolecules'),

-- Unit 20: Principles Related to Practical Chemistry (chem_practical_chemistry)
('c_prac_detection', 'Detection of extra elements (N, S, halogens) and functional groups (hydroxyl, carbonyl, carboxyl, amino)', 'Chemistry - Organic', 'chem_practical_chemistry'),
('c_prac_preparation', 'Preparation of inorganic compounds (Mohr''s salt, potash alum) and organic compounds (acetanilide, p-nitro acetanilide, aniline yellow, iodoform)', 'Chemistry - Organic', 'chem_practical_chemistry'),
('c_prac_titrations', 'Titrimetric exercises: acids, bases, indicators, oxalic acid vs KMnO4, Mohr''s salt vs KMnO4', 'Chemistry - Organic', 'chem_practical_chemistry'),
('c_prac_salt_analysis', 'Qualitative salt analysis for cations and anions', 'Chemistry - Organic', 'chem_practical_chemistry'),
('c_prac_experiments', 'Enthalpy of solution/neutralization, preparation of sols, kinetic study of iodide with H2O2', 'Chemistry - Organic', 'chem_practical_chemistry');


-- ============================================================
-- Step 3: Insert concept prerequisite relationships (within-chapter)
-- These define the learning order within each NTA unit
-- ============================================================

INSERT INTO concept_prerequisites (concept_id, prereq_id) VALUES

-- Math Unit 1: Sets → Relations → Functions → Composition
('m_sets_operations', 'm_sets_representation'),
('m_power_set', 'm_sets_representation'),
('m_relations_types', 'm_sets_operations'),
('m_functions_types', 'm_relations_types'),
('m_composition_functions', 'm_functions_types'),

-- Math Unit 2: Complex numbers → Quadratic equations
('m_complex_representation', 'm_complex_ordered_pairs'),
('m_complex_algebra_modulus', 'm_complex_representation'),
('m_quadratic_solutions', 'm_complex_algebra_modulus'),
('m_roots_coefficients', 'm_quadratic_solutions'),

-- Math Unit 3: Matrices → Determinants → Inverse → Linear equations
('m_determinants_evaluation', 'm_matrices_algebra'),
('m_adjoint_inverse', 'm_determinants_evaluation'),
('m_linear_equations_matrices', 'm_adjoint_inverse'),

-- Math Unit 4: Counting → P and C
('m_pnr_cnr', 'm_counting_principle'),

-- Math Unit 5: Binomial theorem → General/middle term
('m_binomial_general_middle', 'm_binomial_positive_index'),

-- Math Unit 6: AP/GP → Means → AM-GM
('m_insertion_means', 'm_ap_gp'),
('m_am_gm_relation', 'm_insertion_means'),

-- Math Unit 7: Functions → Graphs → Limits → Differentiation rules → Special → Higher order → Applications
('m_graphs_simple_functions', 'm_real_valued_functions'),
('m_limits_continuity_diff', 'm_graphs_simple_functions'),
('m_differentiation_rules', 'm_limits_continuity_diff'),
('m_differentiation_special', 'm_differentiation_rules'),
('m_higher_order_derivatives', 'm_differentiation_special'),
('m_applications_derivatives', 'm_higher_order_derivatives'),

-- Math Unit 8: Anti-derivative → Fundamental integrals → Techniques → Standard → FTC → Definite/Areas
('m_fundamental_integrals', 'm_integral_antiderivative'),
('m_integration_techniques', 'm_fundamental_integrals'),
('m_standard_integrals', 'm_integration_techniques'),
('m_fundamental_theorem_calculus', 'm_standard_integrals'),
('m_definite_integrals_areas', 'm_fundamental_theorem_calculus'),

-- Math Unit 9: ODE basics → Separation → Linear DE
('m_separation_variables', 'm_ode_order_degree'),
('m_linear_de', 'm_separation_variables'),

-- Math Unit 10: Cartesian → Slope → Line equations → Point-line distance → Circle → Line-circle → Conics
('m_slope_lines', 'm_cartesian_system'),
('m_straight_line_equations', 'm_slope_lines'),
('m_point_line_distance', 'm_straight_line_equations'),
('m_circle_equations', 'm_cartesian_system'),
('m_line_circle_intersection', 'm_circle_equations'),
('m_conic_sections', 'm_circle_equations'),

-- Math Unit 11: 3D coords → Direction ratios → Line/skew
('m_direction_ratios_cosines', 'm_3d_coordinates_distance'),
('m_3d_line_skew', 'm_direction_ratios_cosines'),

-- Math Unit 12: Vectors basics → Components/products
('m_vector_components_products', 'm_vectors_scalars_addition'),

-- Math Unit 13: Dispersion → Std dev → Probability → Bayes
('m_std_deviation_variance', 'm_measures_dispersion'),
('m_probability_event', 'm_std_deviation_variance'),
('m_bayes_theorem', 'm_probability_event'),

-- Math Unit 14: Trig identities → Inverse trig
('m_inverse_trig_functions', 'm_trig_identities_functions');


-- Physics within-chapter prerequisites
INSERT INTO concept_prerequisites (concept_id, prereq_id) VALUES

-- Physics Unit 1: Units → Errors → Dimensional analysis
('p_least_count_errors', 'p_units_si_system'),
('p_dimensional_analysis', 'p_least_count_errors'),

-- Physics Unit 2: 1D motion → Accelerated motion → 2D/projectile/circular
('p_uniformly_accelerated', 'p_frame_reference_1d'),
('p_motion_plane_projectile', 'p_uniformly_accelerated'),

-- Physics Unit 3: Newton's laws → Conservation → Friction → Circular dynamics
('p_conservation_momentum', 'p_newtons_laws_impulse'),
('p_friction', 'p_newtons_laws_impulse'),
('p_circular_motion_dynamics', 'p_friction'),

-- Physics Unit 4: Work/KE/PE → Spring/conservation → Collisions
('p_spring_pe_conservation', 'p_work_ke_pe_theorem'),
('p_collisions', 'p_spring_pe_conservation'),

-- Physics Unit 5: COM → Torque/angular momentum → MOI → Axes theorems → Equilibrium
('p_torque_angular_momentum', 'p_centre_of_mass'),
('p_moment_of_inertia', 'p_torque_angular_momentum'),
('p_axes_theorems', 'p_moment_of_inertia'),
('p_rigid_body_equilibrium', 'p_axes_theorems'),

-- Physics Unit 6: Universal gravitation → Kepler/potential → Satellites/escape
('p_kepler_potential', 'p_universal_gravitation'),
('p_satellites_escape', 'p_kepler_potential'),

-- Physics Unit 7: Elasticity → Fluid pressure → Viscosity/Bernoulli → Surface tension → Thermal → Heat transfer
('p_fluid_pressure', 'p_elasticity'),
('p_viscosity_bernoulli', 'p_fluid_pressure'),
('p_surface_tension', 'p_viscosity_bernoulli'),
('p_thermal_properties', 'p_surface_tension'),
('p_heat_transfer', 'p_thermal_properties'),

-- Physics Unit 8: Zeroth law → First law → Second law
('p_first_law_processes', 'p_zeroth_law_temperature'),
('p_second_law', 'p_first_law_processes'),

-- Physics Unit 9: Equation of state → Kinetic theory → Degrees of freedom
('p_kinetic_theory_assumptions', 'p_equation_state'),
('p_degrees_freedom_equipartition', 'p_kinetic_theory_assumptions'),

-- Physics Unit 10: Periodic motion → SHM → Energy/pendulum → Wave motion → Superposition/standing
('p_shm_equation', 'p_periodic_motion'),
('p_shm_energy_pendulum', 'p_shm_equation'),
('p_wave_motion', 'p_shm_energy_pendulum'),
('p_superposition_standing', 'p_wave_motion'),

-- Physics Unit 11: Charges/Coulomb → Field/dipole → Gauss → Potential → PE → Capacitors
('p_electric_field_dipole', 'p_electric_charges_coulomb'),
('p_gauss_law', 'p_electric_field_dipole'),
('p_electric_potential', 'p_gauss_law'),
('p_potential_energy', 'p_electric_potential'),
('p_capacitors_dielectrics', 'p_potential_energy'),

-- Physics Unit 12: Drift velocity → Ohm's law → Power/resistivity → EMF → Kirchhoff
('p_ohms_law_resistance', 'p_drift_velocity_current'),
('p_power_resistivity', 'p_ohms_law_resistance'),
('p_emf_internal_resistance', 'p_power_resistivity'),
('p_kirchhoff_bridges', 'p_emf_internal_resistance'),

-- Physics Unit 13: Biot-Savart → Ampere → Force on charge → Parallel conductors → Galvanometer → Dipole → Field → Materials
('p_ampere_law', 'p_biot_savart'),
('p_force_moving_charge', 'p_ampere_law'),
('p_parallel_conductors_torque', 'p_force_moving_charge'),
('p_galvanometer', 'p_parallel_conductors_torque'),
('p_magnetic_dipole', 'p_galvanometer'),
('p_magnetic_field_dipole', 'p_magnetic_dipole'),
('p_magnetic_materials', 'p_magnetic_field_dipole');


-- Physics Unit 14-20 and Chemistry within-chapter prerequisites
INSERT INTO concept_prerequisites (concept_id, prereq_id) VALUES

-- Physics Unit 14: Faraday/Lenz → AC values → LCR/resonance
('p_ac_values_impedance', 'p_faraday_lenz'),
('p_lcr_resonance_power', 'p_ac_values_impedance'),

-- Physics Unit 15: Displacement current → EM spectrum
('p_em_spectrum', 'p_displacement_current'),

-- Physics Unit 16: Reflection → Refraction → Magnification → Instruments → Wave optics → Interference → Diffraction → Polarization
('p_refraction_lenses', 'p_reflection_mirrors'),
('p_magnification_prism', 'p_refraction_lenses'),
('p_optical_instruments', 'p_magnification_prism'),
('p_wave_optics_huygens', 'p_optical_instruments'),
('p_interference_young', 'p_wave_optics_huygens'),
('p_diffraction', 'p_interference_young'),
('p_polarization', 'p_diffraction'),

-- Physics Unit 17: Photoelectric → Einstein → Matter waves
('p_einstein_equation', 'p_photoelectric_effect'),
('p_matter_waves', 'p_einstein_equation'),

-- Physics Unit 18: Atomic models → Nuclear composition → Binding energy/fission/fusion
('p_nuclear_composition', 'p_atomic_models'),
('p_binding_energy_fission_fusion', 'p_nuclear_composition'),

-- Physics Unit 19: Semiconductor diode → LED/Zener → Logic gates
('p_led_photodiode_zener', 'p_semiconductor_diode'),
('p_logic_gates', 'p_led_photodiode_zener'),

-- Physics Unit 20: Mechanics exp → Fluids/heat exp → Electricity exp → Optics exp → Electronics exp
('p_exp_fluids_heat', 'p_exp_mechanics'),
('p_exp_electricity', 'p_exp_fluids_heat'),
('p_exp_optics', 'p_exp_electricity'),
('p_exp_electronics', 'p_exp_optics'),

-- ============================================================
-- Chemistry within-chapter prerequisites
-- ============================================================

-- Chem Unit 1: Matter/Dalton → Mole concept
('c_mole_concept', 'c_matter_dalton'),

-- Chem Unit 2: EM radiation → Bohr → Dual nature → QM/orbitals → Orbital shapes → Electron config
('c_bohr_model', 'c_em_radiation_photoelectric'),
('c_dual_nature_uncertainty', 'c_bohr_model'),
('c_quantum_mechanics_orbitals', 'c_dual_nature_uncertainty'),
('c_orbital_shapes', 'c_quantum_mechanics_orbitals'),
('c_electron_configuration', 'c_orbital_shapes'),

-- Chem Unit 3: Kossel-Lewis → Ionic → Covalent/VSEPR → VBT → MOT → MO config → Metallic/H-bonding
('c_ionic_bonding', 'c_kossel_lewis'),
('c_covalent_vsepr', 'c_kossel_lewis'),
('c_vbt_hybridization', 'c_covalent_vsepr'),
('c_mot', 'c_vbt_hybridization'),
('c_mo_config_bond_order', 'c_mot'),
('c_metallic_hydrogen_bonding', 'c_mo_config_bond_order'),

-- Chem Unit 4: Fundamentals → First law → Enthalpies → Second law → Gibbs
('c_first_law_hess', 'c_thermo_fundamentals'),
('c_enthalpies', 'c_first_law_hess'),
('c_second_law_spontaneity', 'c_enthalpies'),
('c_gibbs_equilibrium', 'c_second_law_spontaneity'),

-- Chem Unit 5: Concentration → Raoult's → Colligative → van't Hoff
('c_raoults_law', 'c_concentration_methods'),
('c_colligative_properties', 'c_raoults_law'),
('c_vant_hoff_factor', 'c_colligative_properties'),

-- Chem Unit 6: Dynamic eq → Physical eq → Chemical eq → Ionic eq → pH/buffers
('c_physical_equilibria', 'c_dynamic_equilibrium'),
('c_chemical_equilibrium_law', 'c_physical_equilibria'),
('c_ionic_equilibrium', 'c_chemical_equilibrium_law'),
('c_ph_buffers_solubility', 'c_ionic_equilibrium'),

-- Chem Unit 7: Redox → Conductance → Cells → Nernst
('c_conductance', 'c_redox_oxidation_number'),
('c_electrochemical_cells', 'c_conductance'),
('c_nernst_gibbs', 'c_electrochemical_cells'),

-- Chem Unit 8: Rate/factors → Rate law → Arrhenius/collision
('c_rate_law_orders', 'c_rate_factors'),
('c_arrhenius_collision', 'c_rate_law_orders'),

-- Chem Unit 9: Periodic law → Trends
('c_periodic_trends', 'c_periodic_law_table'),

-- Chem Unit 10: General → First element
('c_p_block_first_element', 'c_p_block_general'),

-- Chem Unit 11: Transition intro → Properties → Dichromate/permanganate → Inner transition
('c_transition_properties', 'c_transition_elements'),
('c_dichromate_permanganate', 'c_transition_properties'),
('c_inner_transition', 'c_transition_elements'),

-- Chem Unit 12: Intro/Werner → Nomenclature → Bonding/CFT → Applications
('c_coord_nomenclature_isomerism', 'c_coord_intro_werner'),
('c_coord_bonding_cft', 'c_coord_nomenclature_isomerism'),
('c_coord_applications', 'c_coord_bonding_cft'),

-- Chem Unit 13: Purification → Qualitative → Quantitative → Formulae
('c_qualitative_analysis_organic', 'c_purification_methods'),
('c_quantitative_analysis_organic', 'c_qualitative_analysis_organic'),
('c_empirical_molecular_formulae', 'c_quantitative_analysis_organic'),

-- Chem Unit 14: Tetravalency → Classification → Nomenclature → Bond fission → Electronic effects → Reaction types
('c_classification_isomerism', 'c_tetravalency_hybridization'),
('c_nomenclature', 'c_classification_isomerism'),
('c_bond_fission_intermediates', 'c_nomenclature'),
('c_electronic_effects', 'c_bond_fission_intermediates'),
('c_organic_reaction_types', 'c_electronic_effects'),

-- Chem Unit 15: Classification → Alkanes → Alkenes → Alkynes → Aromatic
('c_alkanes', 'c_hc_classification'),
('c_alkenes', 'c_alkanes'),
('c_alkynes', 'c_alkenes'),
('c_aromatic_hc', 'c_alkynes'),

-- Chem Unit 16: Prep/reactions → Environmental
('c_haloalkane_environmental', 'c_haloalkane_prep_reactions'),

-- Chem Unit 17: Alcohols → Phenols → Ethers → Aldehydes/Ketones → Carboxylic acids
('c_phenols', 'c_alcohols'),
('c_ethers', 'c_phenols'),
('c_aldehydes_ketones', 'c_ethers'),
('c_carboxylic_acids', 'c_aldehydes_ketones'),

-- Chem Unit 18: Amines → Diazonium
('c_diazonium_salts', 'c_amines'),

-- Chem Unit 19: Carbohydrates → Proteins → Vitamins → Nucleic acids
('c_proteins', 'c_carbohydrates'),
('c_vitamins', 'c_proteins'),
('c_nucleic_acids', 'c_vitamins'),

-- Chem Unit 20: Detection → Preparation → Titrations → Salt analysis → Experiments
('c_prac_preparation', 'c_prac_detection'),
('c_prac_titrations', 'c_prac_preparation'),
('c_prac_salt_analysis', 'c_prac_titrations'),
('c_prac_experiments', 'c_prac_salt_analysis')

ON CONFLICT (concept_id, prereq_id) DO NOTHING;
