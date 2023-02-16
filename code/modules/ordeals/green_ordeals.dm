// Dawn
// Once again, amber dawn works for everything
/datum/ordeal/amber_dawn/green_dawn
	name = "Dawn of Green"
	annonce_text = "One day, a question crossed through my mind. Where do we come from? \
	We were given life and left in this world against our own volition."
	annonce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	spawn_places = 4
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_bot
	spawn_player_multiplicator = 0.05
	color = COLOR_DARK_LIME

// Noon
/datum/ordeal/amber_dawn/green_noon
	name = "Noon of Green"
	annonce_text = "In the end, they were bound to life. We existed only to express despair and ire."
	annonce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/green_bot_big
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = COLOR_DARK_LIME

// Dusk
/datum/ordeal/green_dusk
	name = "Dusk of Green"
	annonce_text = "We constructed a looming tower to return whence we came."
	level = 3
	reward_percent = 0.2
	annonce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME
	/// How many places are chosen for the spawn
	var/spawn_places = 3

/datum/ordeal/green_dusk/Run()
	..()
	var/list/availablespawns = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to spawn_places)
		var/X = pick(availablespawns)
		availablespawns -= X

		var/turf/T = get_turf(X)
		var/turf/NT = get_step(T, EAST) // It's a 2x1 object, after all
		if(NT.density) // Retry
			i -= 1
			continue
		var/mob/living/simple_animal/hostile/ordeal/green_dusk/GD = new(T)
		ordeal_mobs += GD
		GD.ordeal_reference = src

// Midnight
/datum/ordeal/green_midnight
	name = "Midnight of Green"
	annonce_text = "The tower is touched by the sky, and it will leave nothing on the earth."
	level = 4
	reward_percent = 0.25
	annonce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	color = COLOR_DARK_LIME

/datum/ordeal/green_midnight/Run()
	..()
	for(var/turf/T in GLOB.department_centers)
		if(!istype(get_area(T), /area/department_main/command))
			continue
		var/mob/living/simple_animal/hostile/ordeal/green_midnight/GM = new(T)
		ordeal_mobs += GM
		GM.ordeal_reference = src
