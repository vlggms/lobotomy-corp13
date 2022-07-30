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

// Dusk
/datum/ordeal/green_dusk
	name = "Dusk of Green"
	annonce_text = "We constructed a looming tower to return whence we came."
	level = 3
	reward_percent = 0.2
	annonce_sound = 'sound/effects/ordeals/green_start.ogg'
	end_sound = 'sound/effects/ordeals/green_end.ogg'
	/// How many places are chosen for the spawn
	var/spawn_places = 3

/datum/ordeal/green_dusk/Run()
	..()
	for(var/i = 1 to spawn_places)
		var/X = pick(GLOB.xeno_spawn)
		var/turf/T = get_turf(X)
		var/turf/NT = get_step(T, EAST) // It's a 2x1 object, after all
		if(NT.density) // Retry
			i -= 1
			continue
		var/mob/living/simple_animal/hostile/ordeal/green_dusk/GD = new(T)
		ordeal_mobs += GD
		GD.ordeal_reference = src
