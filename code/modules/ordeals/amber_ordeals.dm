// Dawn
/datum/ordeal/amber_dawn
	name = "Dawn of Amber"
	annonce_text = "A perfect meal, an excellent substitute."
	level = 1
	reward_percent = 0.1
	annonce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
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

/datum/ordeal/amber_dawn/Run()
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

// Dusk
/datum/ordeal/amber_dawn/amber_dusk
	name = "Dusk of Amber"
	annonce_text = "To accustom oneself to the taste was an inevitable process."
	level = 3
	reward_percent = 0.2
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_dusk
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0

// Midnight
/datum/ordeal/amber_midnight
	name = "Midnight of Amber"
	annonce_text = "They fought amongst themselves to eat the others."
	level = 4
	reward_percent = 0.25
	annonce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	/// How many mobs to spawn
	var/spawn_amount = 1

/datum/ordeal/amber_midnight/Run()
	..()
	if(GLOB.clients.len >= 15)
		spawn_amount += round(GLOB.clients.len / 15)
	for(var/i = 1 to spawn_amount)
		var/turf/T = pick(GLOB.department_centers)
		var/mob/living/simple_animal/hostile/ordeal/amber_midnight/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
