// Simple Spawn
/datum/ordeal/simplespawn
	name = "Basic Ordeal"
	annonce_text = "A perfect meal, an excellent substitute."
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
	for(var/i = 1 to (spawn_places + place_player_mod))
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		for(var/y = 1 to (spawn_amount + spawn_player_mod))
			var/mob/living/simple_animal/hostile/ordeal/M = new spawn_type(T)
			ordeal_mobs += M
			M.ordeal_reference = src



//Specific Commanders
/datum/ordeal/specificcommanders
	name = "Commander Ordeal"
	level = 0
	reward_percent = 0
	var/list/potential_types = list()
	var/grunttype = /mob/living/simple_animal/hostile/ordeal/indigo_noon

/datum/ordeal/specificcommanders/Run()
	..()
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to potential_types.len)
		if(!potential_types.len)
			break
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		var/chosen_type = pick(potential_types)
		potential_types -= chosen_type
		var/mob/living/simple_animal/hostile/ordeal/C = new chosen_type(T)
		ordeal_mobs += C
		C.ordeal_reference = src
		spawngrunts(T)

/datum/ordeal/specificcommanders/proc/spawngrunts(T)
	for(var/i = 1 to 4)
		var/mob/living/simple_animal/hostile/ordeal/M = new grunttype (T)
		ordeal_mobs += M
		M.ordeal_reference = src


// One Boss
/datum/ordeal/boss
	name = "Boss Ordeal"
	level = 0
	reward_percent = 0
	var/bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_noon

/datum/ordeal/boss/Run()
	..()
	var/X = pick(GLOB.department_centers)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/C = new bosstype(T)
	ordeal_mobs += C
	C.ordeal_reference = src


//Simple Commanders
/datum/ordeal/simplecommander
	name = "Commander Ordeal"
	level = 0
	reward_percent = 0.20
	color = "#4f4f4f"
	//does ALL of these
	var/list/bosstype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	//Randomly picked from these.
	var/list/grunttype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	var/bossnumber = 4
	var/gruntnumber = 4

/datum/ordeal/simplecommander/Run()
	..()
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to bossnumber)
		var/turf/T = pick(available_locs)
		if(available_locs.len > 1)
			available_locs -= T
		for(var/Y in bosstype)
			var/mob/living/simple_animal/hostile/ordeal/C = new Y(T)
			ordeal_mobs += C
			C.ordeal_reference = src
		spawngrunts(T)

/datum/ordeal/simplecommander/proc/spawngrunts(T)
	for(var/i = 1 to gruntnumber)
		var/spawntype = pick(grunttype)
		var/mob/living/simple_animal/hostile/ordeal/M = new spawntype(T)
		ordeal_mobs += M
		M.ordeal_reference = src
