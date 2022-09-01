// Noon
/datum/ordeal/amber_dawn/indigo_noon
	name = "Noon of Indigo"
	annonce_text = "When night falls in the Backstreets, they will come."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 2
	reward_percent = 0.15
	spawn_places = 4
	spawn_amount = 3
	spawn_type = /mob/living/simple_animal/hostile/ordeal/indigo_noon
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#3F00FF"

// Dusk
/datum/ordeal/indigo_dusk
	name = "Dusk of Indigo"
	annonce_text = "They will not melt. They do not appear to be people."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#3F00FF"
	var/list/potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
		)

/datum/ordeal/indigo_dusk/Run()
	..()
	var/list/available_locs = GLOB.xeno_spawn.Copy()
	for(var/i = 1 to 4)
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

/datum/ordeal/indigo_dusk/proc/spawngrunts(T)
	for(var/i = 1 to 4)
		var/mob/living/simple_animal/hostile/ordeal/indigo_noon/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src

// Midnight
/datum/ordeal/indigo_midnight
	name = "Midnight of Indigo"
	annonce_text = "For the sake of our families in our village, we cannot stop."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#3F00FF"

/datum/ordeal/indigo_midnight/Run()
	..()
	var/X = pick(GLOB.department_centers)
	var/turf/T = get_turf(X)
	var/mob/living/simple_animal/hostile/ordeal/indigo_midnight/C = new(T)
	ordeal_mobs += C
	C.ordeal_reference = src
