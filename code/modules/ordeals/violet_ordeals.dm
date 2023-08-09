// Dawn
// So, it works practically the same as amber dawn, so here we go
/datum/ordeal/simplespawn/violet_dawn
	name = "Dawn of Violet"
	annonce_text = "To gain an understanding of what is incomprehensible, they dream, staring."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
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
	name = "Noon of Violet"
	annonce_text = "We could only hear the weakest and faintest of their acts. We sought for love and compassion from them."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
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

// Dusk
/datum/ordeal/violet_dusk
	name = "Dusk of Violet"
	annonce_text = "A god, an evil, them. They embraced us on the day of rest."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
	end_sound = 'sound/effects/ordeals/violet_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#B642F5"
	var/spawn_amount = 8

/datum/ordeal/violet_dusk/Run() //temporary AF
	..()
	var/spawned_in = 0
	for(var/turf/T in shuffle(GLOB.department_centers))
		if(spawned_in >= spawn_amount)
			return
		var/mob/living/simple_animal/hostile/ordeal/violet_monolith/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		spawned_in += 1

// Midnight
/datum/ordeal/violet_midnight
	name = "Midnight of Violet"
	annonce_text = "We incessantly tried to accept it. We wanted to understand them in our heads by any means, regardless of the consequences."
	annonce_sound = 'sound/effects/ordeals/violet_start.ogg'
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
