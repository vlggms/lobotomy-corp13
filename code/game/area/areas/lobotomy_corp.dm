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

/area/department_main/control
	name = "Control Main Room"

/area/department_main/command
	name = "Command Main Room"

/area/department_main/training
	name = "Training Main Room"

/area/department_main/information
	name = "Information Main Room"

/area/department_main/safety
	name = "Safety Main Room"

/area/department_main/discipline
	name = "Disciplinary Main Room"

/area/department_main/welfare
	name = "Welfare Main Room"

/area/department_main/records
	name = "Records Main Room"

/area/department_main/extraction
	name = "Extraction Main Room"

/area/department_main/human
	name = "Human Resources Room"


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
/area/facility_hallway/command
	name = "Command Hallway"

/area/facility_hallway/control
	name = "Control Hallway"

/area/facility_hallway/training
	name = "Training Hallway"

/area/facility_hallway/information
	name = "Information Hallway"

/area/facility_hallway/safety
	name = "Safety Hallway"

/area/facility_hallway/discipline
	name = "Disciplinary Hallway"

/area/facility_hallway/welfare
	name = "Welfare Hallway"

/area/facility_hallway/records
	name = "Records Hallway"

/area/facility_hallway/extraction
	name = "Extraction Hallway"

/area/facility_hallway/human
	name = "Human Resources Hallway"
