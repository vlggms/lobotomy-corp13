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
	var/big_bird = FALSE

/area/department_main/Entered(atom/movable/M)
	. = ..()
	if(!isabnormalitymob(M)) // only do updates on Abnormality entering/leaving
		return
	if(istype(M, /mob/living/simple_animal/hostile/abnormality/big_bird))
		big_bird = TRUE
		for(var/area/facility_hallway/F in adjacent_areas)
			F.big_bird = TRUE
			F.RefreshLights()
		for(var/area/department_main/D in adjacent_areas)
			D.big_bird = TRUE
			D.RefreshLights()
	RefreshLights()

/area/department_main/Exited(atom/movable/M)
	. = ..()
	if(!isabnormalitymob(M))
		return
	if(istype(M, /mob/living/simple_animal/hostile/abnormality/big_bird))
		for(var/area/facility_hallway/F in adjacent_areas)
			if(M in F.contents)
				continue
			F.big_bird = FALSE
			F.RefreshLights()
		for(var/area/department_main/D in adjacent_areas)
			if(M in D.contents)
				continue
			D.big_bird = FALSE
			D.RefreshLights()
		if(isdead(M) || QDELETED(M))
			big_bird = FALSE
	RefreshLights()

/area/department_main/RefreshLights()
	lightswitch = !big_bird
	if(!big_bird)
		var/list/search_through = src.contents.Copy()
		var/mob/living/simple_animal/hostile/abnormality/training_rabbit/TR = locate() in search_through
		if(TR)
			search_through -= TR
		fire = FALSE
		if((GLOB.security_level >= SEC_LEVEL_BLUE))
			for(var/mob/living/simple_animal/hostile/abnormality/A in search_through)
				if(QDELETED(A) || (A.stat == DEAD))
					continue
				if(A)
					fire = TRUE
					break
	for(var/obj/machinery/light/L in src)
		L.on = !big_bird
		L.update()
	return

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
	var/big_bird = FALSE

/area/facility_hallway/Entered(atom/movable/M)
	. = ..()
	if(!isabnormalitymob(M)) // only do updates on Abnormality entering/leaving
		return
	if(istype(M, /mob/living/simple_animal/hostile/abnormality/big_bird))
		big_bird = TRUE
		for(var/area/facility_hallway/F in adjacent_areas)
			F.big_bird = TRUE
			F.RefreshLights()
		for(var/area/department_main/D in adjacent_areas)
			D.big_bird = TRUE
			D.RefreshLights()
	RefreshLights()

/area/facility_hallway/Exited(atom/movable/M)
	. = ..()
	if(!isabnormalitymob(M)) // only do updates on Abnormality entering/leaving
		return
	if(istype(M, /mob/living/simple_animal/hostile/abnormality/big_bird))
		for(var/area/facility_hallway/F in adjacent_areas)
			if(M in F.contents)
				continue
			F.big_bird = FALSE
			F.RefreshLights()
		for(var/area/department_main/D in adjacent_areas)
			if(M in D.contents)
				continue
			D.big_bird = FALSE
			D.RefreshLights()
		if(isdead(M) || QDELETED(M))
			big_bird = FALSE
	RefreshLights()

/area/facility_hallway/RefreshLights()
	lightswitch = !big_bird
	if(!big_bird)
		var/list/search_through = src.contents.Copy()
		var/mob/living/simple_animal/hostile/abnormality/training_rabbit/TR = locate() in search_through
		if(TR)
			search_through -= TR
		fire = FALSE
		if((GLOB.security_level >= SEC_LEVEL_BLUE))
			for(var/mob/living/simple_animal/hostile/abnormality/A in search_through)
				if(QDELETED(A) || (A.stat == DEAD))
					continue
				if(A)
					fire = TRUE
					break
	for(var/obj/machinery/light/L in src)
		L.on = !big_bird
		L.update()
	return

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


//Areas for backstreets

/area/city/backstreets_checkpoint
	name = "Backstreets Checkpoint"

/area/city/backstreets_alley
	name = "Backstreets Alley"
	icon_state = "hallA"

/area/city/backstreets_room
	name = "Backstreets Room"
	icon_state = "hallA"

//Miscellaneous Areas
/area/shelter
	name = "Shelter"
	icon_state = "shelter"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/shelter/Entered(atom/movable/M)
	. = ..()
	if(!ishostile(M)) // kick out any hostile mobs
		return
	var/list/potential_locs = shuffle(GLOB.department_centers)
	var/turf/T = pick(potential_locs)
	M.forceMove(T)
