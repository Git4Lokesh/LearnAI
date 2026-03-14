-- Migration: Map existing 81 micro-concepts to their parent chapters
-- This populates the chapter_id column so drill-down from macro → micro graph works

-- Mathematics - Algebra concepts
UPDATE concepts SET chapter_id = 'sets_relations' WHERE id = 'algebra_basic';
UPDATE concepts SET chapter_id = 'sets_relations' WHERE id = 'linear_equations_one_variable';
UPDATE concepts SET chapter_id = 'quadratic_equations' WHERE id = 'quadratic_equations';
UPDATE concepts SET chapter_id = 'straight_lines' WHERE id = 'coordinate_geometry_2d';

-- Mathematics - Trigonometry concepts
UPDATE concepts SET chapter_id = 'trigonometric_functions' WHERE id = 'trigonometry_basic_ratios';
UPDATE concepts SET chapter_id = 'trigonometric_functions' WHERE id = 'trigonometry_identities';

-- Mathematics - Vectors concepts
UPDATE concepts SET chapter_id = 'vectors_3d' WHERE id = 'vectors_basics_scalars_vectors';
UPDATE concepts SET chapter_id = 'vectors_3d' WHERE id = 'vectors_addition_resolution';
UPDATE concepts SET chapter_id = 'vectors_3d' WHERE id = 'vectors_dot_product';
UPDATE concepts SET chapter_id = 'vectors_3d' WHERE id = 'vectors_cross_product';

-- Mathematics - Calculus concepts
UPDATE concepts SET chapter_id = 'limits_continuity' WHERE id = 'calculus_limits';
UPDATE concepts SET chapter_id = 'differentiation' WHERE id = 'calculus_differentiation_basic';
UPDATE concepts SET chapter_id = 'integration' WHERE id = 'calculus_integration_basic';
UPDATE concepts SET chapter_id = 'applications_integrals' WHERE id = 'area_under_curve';

-- Physics - Units & Measurements
UPDATE concepts SET chapter_id = 'units_measurements' WHERE id = 'units_dimensions';

-- Physics - Kinematics (1D)
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'scalars_vectors_physics';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'motion_basic_terminology';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'kinematics_1d_velocity';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'kinematics_1d_acceleration';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'kinematics_1d_equations_uniform';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'kinematics_graphs_1d';
UPDATE concepts SET chapter_id = 'kinematics_1d' WHERE id = 'relative_velocity_1d';

-- Physics - Kinematics (2D)
UPDATE concepts SET chapter_id = 'kinematics_2d' WHERE id = 'kinematics_2d_vectors';
UPDATE concepts SET chapter_id = 'kinematics_2d' WHERE id = 'projectile_motion';
UPDATE concepts SET chapter_id = 'kinematics_2d' WHERE id = 'relative_velocity_2d';
UPDATE concepts SET chapter_id = 'kinematics_2d' WHERE id = 'uniform_circular_motion_kinematics';
UPDATE concepts SET chapter_id = 'kinematics_2d' WHERE id = 'ucm_radial_tangential_acc';

-- Physics - Laws of Motion
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'concept_of_force_inertia';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'newtons_first_law';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'newtons_second_law';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'newtons_third_law';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'free_body_diagrams';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'normal_reaction_tension';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'friction_static_kinetic';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'motion_on_inclined_plane';
UPDATE concepts SET chapter_id = 'laws_of_motion' WHERE id = 'pulley_block_systems';

-- Physics - Circular Motion
UPDATE concepts SET chapter_id = 'circular_motion' WHERE id = 'circular_motion_dynamics';
UPDATE concepts SET chapter_id = 'circular_motion' WHERE id = 'vehicle_on_level_curve';
UPDATE concepts SET chapter_id = 'circular_motion' WHERE id = 'vehicle_on_banked_road';
UPDATE concepts SET chapter_id = 'circular_motion' WHERE id = 'pseudo_force_non_inertial';

-- Physics - Work Energy & Power
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'work_constant_force';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'work_variable_force';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'kinetic_energy';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'potential_energy_near_earth';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'potential_energy_spring';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'work_energy_theorem';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'power_instantaneous';
UPDATE concepts SET chapter_id = 'work_energy_power' WHERE id = 'conservation_energy';

-- Physics - Centre of Mass, Momentum & Collisions
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'linear_momentum_impulse';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'conservation_linear_momentum';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'collision_1d';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'coefficient_of_restitution';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'collision_2d_oblique';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'centre_of_mass_discrete';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'centre_of_mass_continuous';
UPDATE concepts SET chapter_id = 'com_momentum_collisions' WHERE id = 'motion_of_centre_of_mass';

-- Physics - Simple Harmonic Motion
UPDATE concepts SET chapter_id = 'simple_harmonic_motion' WHERE id = 'shm_basics';
UPDATE concepts SET chapter_id = 'simple_harmonic_motion' WHERE id = 'shm_energy';
UPDATE concepts SET chapter_id = 'simple_harmonic_motion' WHERE id = 'spring_mass_system';

-- Physics - Rotational Mechanics
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'angular_kinematics_rigid_body';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'torque_basic';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'rotational_equilibrium';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'moment_of_inertia_definition';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'moment_of_inertia_standard_bodies';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'parallel_axis_theorem';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'perpendicular_axis_theorem';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'rotational_kinetic_energy';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'angular_momentum_rigid_body';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'conservation_angular_momentum';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'rolling_without_slipping';
UPDATE concepts SET chapter_id = 'rotational_mechanics' WHERE id = 'rolling_energy_distribution';

-- Physics - Gravitation
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'universal_law_gravitation';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'gravitational_field_intensity';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'gravitational_potential_energy';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'acceleration_due_to_gravity_surface';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'variation_g_height_depth';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'keplers_laws';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'orbital_velocity_satellite';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'energy_of_orbiting_satellite';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'escape_velocity';
UPDATE concepts SET chapter_id = 'gravitation' WHERE id = 'geostationary_satellites';
