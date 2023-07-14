// Dawn
/datum/ordeal/simplespawn/maroon_dawn
	name = "Dawn of Maroon"
	annonce_text = "One day, without any warning, we found out that our planet is dying."
	annonce_sound = 'sound/effects/ordeals/maroon_start.ogg'
	end_sound = 'sound/effects/ordeals/maroon_end.ogg'
	can_run = FALSE // Admin only for now
	level = 1
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/infestation/broodling
	spawn_player_multiplicator = 0.2
	color = COLOR_MAROON
	reward_percent = 0.1

// Noon
/datum/ordeal/simplecommander/maroon_noon
	name = "Noon of Maroon"
	annonce_text = "The news reports could not confirm the source or the cause of the infestation, but we all know the culprit."
	annonce_sound = 'sound/effects/ordeals/maroon_start.ogg'
	end_sound = 'sound/effects/ordeals/maroon_end.ogg'
	can_run = FALSE
	level = 2
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator)
	grunttype = list(
		/mob/living/simple_animal/hostile/ordeal/infestation/broodling,
		/mob/living/simple_animal/hostile/ordeal/infestation/floatfly,
		)
	bossnumber = 3
	gruntnumber = 5
	color = COLOR_MAROON
	reward_percent = 0.15

// Dusk
/datum/ordeal/simplecommander/maroon_dusk
	name = "Dusk of Maroon"
	annonce_text = "Upon a closer look, the creatures resembled humans a bit too much, just a bit... reassembled..."
	annonce_sound = 'sound/effects/ordeals/maroon_start.ogg'
	end_sound = 'sound/effects/ordeals/maroon_end.ogg'
	can_run = FALSE
	level = 3
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/infestation/assembler)
	grunttype = list(
		/mob/living/simple_animal/hostile/ordeal/infestation/broodling,
		/mob/living/simple_animal/hostile/ordeal/infestation/floatfly,
		/mob/living/simple_animal/hostile/ordeal/infestation/eviscerator
		)
	bossnumber = 5
	gruntnumber = 10 // It's a heckin' party!
	color = COLOR_MAROON
	reward_percent = 0.2
