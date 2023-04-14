// Dawn
/datum/ordeal/simplespawn/indigo_dawn
	name = "Dawn of Indigo"
	annonce_text = "They come searching for what they so desperately need."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 1
	spawn_places = 5
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/indigo_dawn
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#3F00FF"

// Noon
/datum/ordeal/simplespawn/indigo_noon
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
/datum/ordeal/specificcommanders/indigo_dusk
	name = "Dusk of Indigo"
	annonce_text = "They will not melt. They do not appear to be people."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
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
	grunttype = /mob/living/simple_animal/hostile/ordeal/indigo_noon

// Midnight
/datum/ordeal/boss/indigo_midnight
	name = "Midnight of Indigo"
	annonce_text = "For the sake of our families in our village, we cannot stop."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#3F00FF"
	bosstype = /mob/living/simple_animal/hostile/ordeal/indigo_midnight
