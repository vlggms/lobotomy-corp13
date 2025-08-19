// April Fools
/datum/ordeal/simplespawn/salmon_dawn
	name = "The Dawn of Salmon"
	flavor_name = "The Interns"
	announce_text = "It takes a lot of effort to impersonate a wing. Shrimpcorp has done just that."
	end_announce_text = "Maybe sending just our unpaid interns was a bad idea."
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
	can_run = FALSE

/datum/ordeal/simplespawn/salmon_dawn/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run

// Noon
/datum/ordeal/simplespawn/salmon_dawn/salmon_noon
	name = "The Noon of Salmon"
	flavor_name = "March of the Shrimp Soldiers"
	announce_text = "A wing must have its own army in order to protect itself. We used our Shrimpularity to create super soldiers with cola-powered weaponry."
	end_announce_text = "As it turns out, cola isn't all that great of a power source."
	reward_percent = 0.15
	level = 2
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/ordeal/shrimp,
		/mob/living/simple_animal/hostile/ordeal/shrimp_soldier,
		/mob/living/simple_animal/hostile/ordeal/shrimp_rifleman,
	)
	place_player_multiplicator = 0.1
	spawn_player_multiplicator = 0.05

// Dusk
/datum/ordeal/specificcommanders/salmon_dusk
	name = "The Dusk of Salmon"
	flavor_name = "Shrimp Corp's Finest"
	announce_text = "Having crawled out from the rivers, Shrimpkind has managed to bypass city laws regarding its unique ammunition."
	end_announce_text = "Perhaps Shrimpcorp soldiers need more than a 3 minute firearm safety lesson..."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	level = 3
	reward_percent = 0.20
	color = "#FA8072"
	can_run = FALSE
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
	announce_text = "We had one soldier that stood out from the rest, so we made copies of him."
	end_announce_text = "Sadly, our copies of Rambo could never compare to the original."
	announce_sound = 'sound/effects/ordeals/salmon_start.ogg'
	end_sound = 'sound/effects/ordeals/salmon_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#FA8072"
	can_run = FALSE
	bosstype = /mob/living/simple_animal/hostile/ordeal/salmon_midnight

/datum/ordeal/boss/salmon_midnight/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[APRIL_FOOLS]) //runs april 1-5
		can_run = TRUE
	return can_run
