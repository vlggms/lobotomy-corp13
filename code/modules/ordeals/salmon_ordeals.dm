/datum/ordeal/simplespawn/salmon_dawn
	name = "The Dawn of Salmon"
	flavor_name = "The Interns"
	announce_text = "To impersonate a wing, it takes a lot of effort."
	end_announce_text = "And with the needed effort, Shrimpkind has done so."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	reward_percent = 0.1
	level = 1
	spawn_places = 5
	spawn_amount = 1
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp,
		/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman
	)
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0
	color = "#FA8072"

/datum/ordeal/simplespawn/salmon_dawn/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run

// Noon
/datum/ordeal/simplespawn/salmon_noon
	name = "The Noon of Salmon"
	flavor_name = "The Officers"
	announce_text = "A wing must have their own army in order to protect themselves."
	end_announce_text = "With the power of soda, Shrimps have grown their army well."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	reward_percent = 0.15
	level = 2
	spawn_places = 5
	spawn_amount = 3
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp,
		/mob/living/simple_animal/hostile/ordeal/shrimp_soldier
	)
	place_player_multiplicator = 0.1
	spawn_player_multiplicator = 0.05
	color = "#FA8072"

/datum/ordeal/simplespawn/salmon_noon/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run

// Dusk
/datum/ordeal/specificcommanders/salmon_dusk
	name = "The Dusk of Salmon"
	flavor_name = "Shrimp Corp's Finest"
	announce_text = "Being related to the well, Shrimpkind seemed to have unique weaponry that passed city gun laws."
	end_announce_text = "With these guns, they could pose a decent threat."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#FA8072"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/salmon_dusk/red,
		/mob/living/simple_animal/hostile/ordeal/salmon_dusk/white,
		/mob/living/simple_animal/hostile/ordeal/salmon_dusk/black,
		/mob/living/simple_animal/hostile/ordeal/salmon_dusk/pale
		)
	grunttype = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman,
		/mob/living/simple_animal/hostile/ordeal/shrimp,
		/mob/living/simple_animal/hostile/ordeal/shrimp_soldier,
		)

/datum/ordeal/specificcommanders/salmon_dusk/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run


// Midnight
/datum/ordeal/boss/salmon_midnight
	name = "The Midnight of Salmon"
	flavor_name = "The Fighter"
	announce_text = "With our S-Corp training regime, we had one soldier that excelled from the rest, so we made copies of him."
	end_announce_text = "Sadly, our copies of Rambo were not as strong as the original."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#FA8072"
	bosstype = /mob/living/simple_animal/hostile/ordeal/salmon_midnight

/datum/ordeal/boss/salmon_midnight/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run
