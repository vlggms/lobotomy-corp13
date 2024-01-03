// Dawn
/datum/ordeal/simplespawn/amber_dawn
	name = "The Dawn of Amber"
	flavor_name = "The Perfect Meal"
	announce_text = "A perfect meal, an excellent substitute."
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	spawn_places = 4
	spawn_amount = 3
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_bug

// Dusk
/datum/ordeal/simplespawn/amber_dusk
	name = "The Dusk of Amber"
	flavor_name = "Food Chain"
	announce_text = "To accustom oneself to the taste was an inevitable process."
	level = 3
	reward_percent = 0.2
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
	end_sound = 'sound/effects/ordeals/amber_end.ogg'
	color = "#FFBF00"
	spawn_places = 3
	spawn_amount = 1
	spawn_type = /mob/living/simple_animal/hostile/ordeal/amber_dusk
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0

// Midnight
/datum/ordeal/amber_midnight
	name = "The Midnight of Amber"
	flavor_name = "Eternal Meal"
	announce_text = "They fought amongst themselves to eat the others."
	level = 4
	reward_percent = 0.25
	announce_sound = 'sound/effects/ordeals/amber_start.ogg'
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
