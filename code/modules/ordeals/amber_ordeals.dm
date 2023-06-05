// Dawn
/datum/ordeal/simplespawn/amber_dawn
	name = "Dawn of Amber"
	annonce_text = "A perfect meal, an excellent substitute."
	level = 1
	reward_percent = 0.1
	annonce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	spawn_places = 4
	spawn_amount = 3
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_bug

// Dusk
/datum/ordeal/simplespawn/amber_dusk
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
	var/list/potential_locs = GLOB.department_centers.Copy()
	if(GLOB.player_list.len >= 15)
		spawn_amount += round(GLOB.player_list.len / 15)
	for(var/i = 1 to spawn_amount)
		var/turf/T = pick(potential_locs)
		var/mob/living/simple_animal/hostile/ordeal/amber_midnight/M = new(T)
		ordeal_mobs += M
		M.ordeal_reference = src
		potential_locs -= T
