// All these ordeal subtypes except for Boss spawn at xeno spawns

/datum/ordeal/proc/DeploymentZone(turf/T, no_center = FALSE)
	var/list/deploymentzone = list()
	var/list/turf/nearby_turfs = RANGE_TURFS(1,T)
	if(no_center)
		nearby_turfs -= get_turf(T)
	for(var/turf/freearea in nearby_turfs)
		if(!freearea.is_blocked_turf(exclude_mobs = TRUE) && !(islava(freearea) || ischasm(freearea)))
			deploymentzone += freearea
	return deploymentzone

// Simple Spawn
/datum/ordeal/simplespawn
	name = "Basic Ordeal"
	announce_text = "You should not be reading this."
	level = 0
	reward_percent = 0
	/// How many places are chosen for the spawn
	var/spawn_places = 4
	/// How many mobs to spawn per spot
	var/spawn_amount = 3
	/// What mob to spawn
	var/spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_bug
	/// Multiplier for player count, used to increase amount of spawn places. Set to 0 if you want it to not matter.
	var/place_player_multiplicator = 0.1
	/// Same as above, but for amount of mobs spawned
	var/spawn_player_multiplicator = 0.1

/datum/ordeal/simplespawn/Run()
	..()
	var/place_player_mod = round(GLOB.clients.len * place_player_multiplicator) // Ten players add a new spot
	var/spawn_player_mod = round(GLOB.clients.len * spawn_player_multiplicator)
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/list/spawn_turfs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to (spawn_places + place_player_mod))
		if(!LAZYLEN(spawn_turfs)) //if list empty, recopy xeno spawns
			spawn_turfs = GLOB.xeno_spawn.Copy()
		var/X = pick_n_take(spawn_turfs)
		var/turf/T = get_turf(X)
		var/list/deployment_area = list()
		if((spawn_amount + spawn_player_mod) > 1)
			deployment_area = DeploymentZone(T) //deployable areas for groups
		for(var/y = 1 to (spawn_amount + spawn_player_mod))
			var/turf/deploy_spot = T //spot you are being deployed
			if(LAZYLEN(deployment_area)) //if deployment zone is empty just spawn at xeno spawn
				deploy_spot = pick_n_take(deployment_area)
			var/mob/living/simple_animal/hostile/ordeal/M = new spawn_type(deploy_spot)
			ordeal_mobs += M
			M.ordeal_reference = src

//Simple Commanders
/datum/ordeal/simplecommander
	name = "Commander Ordeal"
	level = 0
	reward_percent = 0.20
	color = "#4f4f4f"
	//Types of bosses to spawn per location. Spawns ALL of them at once
	var/list/boss_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	// Potential types of grunts that spawn around the boss mob. Grunt types are RANDOMLY picked from this, not all at once
	var/list/grunt_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	//Minimum amount of bosstype groups spawned.
	var/boss_amount = 4
	//Minimum amount of troops spawned around the bosses. If each boss would spawn 4 dudes there would be 4 groups of 5 including the boss.
	var/grunt_amount = 4
	//Multiplier for player count, used to increase amount of bosses spawned.
	//How this works currently is gruntnumber + grunt_player_multiplicator, 10 players would equal one additional grunt in a squad if each player equals 0.1.
	var/boss_player_multiplicator = 0.05
	var/grunt_player_multiplicator = 0.1

/datum/ordeal/simplecommander/Run()
	. = ..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/boss_player_mod = round(GLOB.clients.len * boss_player_multiplicator)
	var/grunt_player_mod = round(GLOB.clients.len * grunt_player_multiplicator)
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to round(boss_amount + boss_player_mod))
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in boss_type)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src
		spawngrunts(T, grunt_type, (grunt_amount + grunt_player_mod))

//Specific Commanders
/datum/ordeal/specificcommanders //Functions similarly to simplecommanders but deploys one of each potential_types as unique bosses.
	name = "Commander Ordeal"
	level = 0
	reward_percent = 0
	var/list/potential_types = list()
	var/list/grunttype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)

/datum/ordeal/specificcommanders/Run()
	..()
	if(!LAZYLEN(GLOB.xeno_spawn))
		message_admins("No xeno spawns found when spawning in ordeal!")
		return
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	var/list/spawntypes = potential_types.Copy()
	for(var/i = 1 to spawntypes.len)
		if(!LAZYLEN(spawntypes))
			break
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/chosen_type = pick_n_take(spawntypes)
		var/mob/living/simple_animal/hostile/ordeal/C = new chosen_type(T)
		ordeal_mobs += C
		C.ordeal_reference = src
		spawngrunts(T, grunttype)

//Shared Ordeal Procs
/datum/ordeal/proc/spawngrunts(turf/T, list/grunttype, spawn_amount = 4)
	var/list/deployment_area = DeploymentZone(T, TRUE) //deployable areas.
	var/spawntype = pick(grunttype) //default to grunttype if there is no list.
	for(var/i = 1 to spawn_amount) //spawn boys on one of each turf.
		var/turf/deploy_spot = T //spot grunt will be deployed
		if(LAZYLEN(deployment_area)) //if list is empty just deploy them ontop of boss. Sorry boss.
			deploy_spot = pick_n_take(deployment_area)
		if(grunttype.len > 1) //if list is more than 1 pick a type of grunt. Dont know if this helps with processing power to bypass picking every time.
			spawntype = pick(grunttype)
		var/mob/living/simple_animal/hostile/ordeal/M = new spawntype (deploy_spot)
		ordeal_mobs += M
		M.ordeal_reference = src

// One Boss
/datum/ordeal/boss
	name = "Boss Ordeal"
	level = 0
	reward_percent = 0
	var/bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_noon
	var/bossspawnloc = null

/datum/ordeal/boss/Run()
	..()
	var/turf/T
	if(bossspawnloc)
		for(var/turf/D in GLOB.department_centers)
			if(istype(get_area(D), bossspawnloc))
				T = D
				break
		if(!T)
			var/X = pick(GLOB.department_centers)
			T = get_turf(X)
			log_game("Failed to spawn [src] in [bossspawnloc]")
	else
		var/X = pick(GLOB.department_centers)
		T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/C = new bosstype(T)
	ordeal_mobs += C
	C.ordeal_reference = src
