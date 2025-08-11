// Dawn
/datum/ordeal/simplespawn/indigo_dawn
	name = "The Dawn of Indigo"
	flavor_name = "The Scouts"
	announce_text = "They come searching for what they so desperately need."
	end_announce_text = "And they search in the dark."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	reward_percent = 0.1
	level = 1
	spawn_places = 5
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/invis,
		/mob/living/simple_animal/hostile/ordeal/indigo_dawn/skirmisher,
		)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#3F00FF"

// Noon
/datum/ordeal/simplespawn/indigo_noon
	name = "The Noon of Indigo"
	flavor_name = "The Sweepers"
	announce_text = "When night falls in the Backstreets, they will come."
	end_announce_text = "When the sun rises anew, not a scrap will remain."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	reward_percent = 0.15
	level = 2
	spawn_places = 4
	spawn_amount = 2
	spawn_type = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0.3
	color = "#3F00FF"

// Dusk
/datum/ordeal/specificcommanders/indigo_dusk
	name = "The Dusk of Indigo"
	flavor_name = "Night in the Backstreets"
	announce_text = "We still have some more fuel. The power of family is not a bad thing."
	end_announce_text = "Dear neighbors, we could not finish the sweeping."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#3F00FF"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/pale,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/indigo_dusk/white
		)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/indigo_noon)

// Midnight
/*
/datum/ordeal/boss/indigo_midnight
	name = "The Midnight of Indigo"
	flavor_name = "Mother"
	announce_text = "Mother will give you all the assistance you need. We all could safely become a family thanks to her."
	end_announce_text = "For the sake of our families in our village, we cannot stop."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#3F00FF"
	bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_midnight
*/
