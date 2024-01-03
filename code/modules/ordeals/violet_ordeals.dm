// Dawn
// So, it works practically the same as amber dawn, so here we go
/datum/ordeal/simplespawn/violet_dawn
	name = "The Dawn of Violet"
	flavor_name = "Fruit of Understanding"
	announce_text = "To gain an understanding of what is incomprehensible, they dream, staring."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/violet_fruit
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	level = 1
	reward_percent = 0.1
	color = "#B642F5"

// Noon
/datum/ordeal/violet_noon
	name = "The Noon of Violet"
	flavor_name = "Grant Us Love"
	announce_text = "We could only hear the weakest and faintest of their acts. We sought for love and compassion from them."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 2
	reward_percent = 0.15
	color = "#B642F5"
	var/spawn_amount = 4

/datum/ordeal/violet_noon/Run()
	..()
	var/spawned_in = 0
	for(var/turf/T in shuffle(GLOB.department_centers))
		if(spawned_in >= spawn_amount)
			return
		var/mob/living/simple_animal/hostile/ordeal/violet_monolith/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		spawned_in += 1

// Noon
/datum/ordeal/violet_midnight
	name = "The Midnight of Violet"
	flavor_name = "The God Delusion"
	announce_text = "We incessantly tried to accept it. We wanted to understand them in our heads by any means, regardless of the consequences."
	announce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#B642F5"

/datum/ordeal/violet_midnight/Run()
	..()
	var/list/available_spots = GLOB.xeno_spawn.Copy()
	for(var/spawn_type in subtypesof(/mob/living/simple_animal/hostile/ordeal/violet_midnight))
		var/turf/T = pick(available_spots)
		available_spots -= T
		var/mob/living/simple_animal/hostile/ordeal/M = new spawn_type(T)
		ordeal_mobs += M
		M.ordeal_reference = src
