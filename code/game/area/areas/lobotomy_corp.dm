/area/surface_ruins
	name = "Ruins"
	icon_state = "mining"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	outdoors = TRUE
	flags_1 = NONE
	has_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_MINING
	sound_environment = SOUND_AREA_STANDARD_STATION
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NO_ALERTS

/area/surface_ruins/underground
	name = "Underground Ruins"

/area/containment_zone
	name = "Containment Zone"
	icon_state = "centcom"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/department_main
	name = "Department Main Room"
	icon_state = "centcom"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_AREA_STANDARD_STATION
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/department_main/manager
	name = "Manager's Office"
	icon_state = "mainroom_manager"

/area/department_main/control
	name = "Control Main Room"
	icon_state = "mainroom_control"

/area/department_main/command
	name = "Command Main Room"
	icon_state = "mainroom_command"

/area/department_main/training
	name = "Training Main Room"
	icon_state = "mainroom_training"

/area/department_main/information
	name = "Information Main Room"
	icon_state = "mainroom_info"

/area/department_main/safety
	name = "Safety Main Room"
	icon_state = "mainroom_safety"

/area/department_main/discipline
	name = "Disciplinary Main Room"
	icon_state = "mainroom_disciplinary"

/area/department_main/welfare
	name = "Welfare Main Room"
	icon_state = "mainroom_welfare"

/area/department_main/records
	name = "Records Main Room"
	icon_state = "mainroom_records"

/area/department_main/extraction
	name = "Extraction Main Room"
	icon_state = "mainroom_extraction"

/area/department_main/human
	name = "Human Resources Room"
	icon_state = "mainroom_hr"

/area/department_main/architecture
	name = "Architecture Main Room"
	icon_state = "mainroom_extraction"


/area/facility_hallway
	name = "Hallway"
	icon_state = "hallA"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_AREA_STANDARD_STATION
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/facility_hallway/central
	name = "Central Hallway"

/area/facility_hallway/east
	name = "East Hallway"

/area/facility_hallway/west
	name = "West Hallway"

/area/facility_hallway/north
	name = "North Hallway"

/area/facility_hallway/south
	name = "South Hallway"

//Departmental Hallways
/area/facility_hallway/manager
	name = "Manager's Hallway"
	icon_state = "hall_manager"

/area/facility_hallway/control
	name = "Control Hallway"
	icon_state = "hall_control"

/area/facility_hallway/command
	name = "Command Hallway"
	icon_state = "hall_command"

/area/facility_hallway/training
	name = "Training Hallway"
	icon_state = "hall_training"

/area/facility_hallway/information
	name = "Information Hallway"
	icon_state = "hall_info"

/area/facility_hallway/safety
	name = "Safety Hallway"
	icon_state = "hall_safety"

/area/facility_hallway/discipline
	name = "Disciplinary Hallway"
	icon_state = "hall_disciplinary"

/area/facility_hallway/welfare
	name = "Welfare Hallway"
	icon_state = "hall_welfare"

/area/facility_hallway/records
	name = "Records Hallway"
	icon_state = "hall_records"

/area/facility_hallway/extraction
	name = "Extraction Hallway"
	icon_state = "hall_extraction"

/area/facility_hallway/human
	name = "Human Resources Hallway"
	icon_state = "hall_hr"

/area/facility_hallway/architecture
	name = "Architecture Hallway"
	icon_state = "hall_hr"

/area/city
	name = "City Streets"
	icon_state = "hallA"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_AREA_STANDARD_STATION
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/city/house
	name = "Employee Housing"

/area/city/shop
	name = "Employee Services"

/area/city/outskirts
	name = "Outskirts"

/area/city/fixers
	name = "Fixer Office"


