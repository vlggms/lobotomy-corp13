// Dawn
/datum/ordeal/fixers/echoes
	name = "Echoes"
	flavor_name = "A Mirror"
	announce_text = "This isn't supposed to happen, but they have come for you. Might want to report this to central command."
	can_run = FALSE
	level = 6
	reward_percent = 0.1
	color = "#444444"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/star,
		/mob/living/simple_animal/hostile/ordeal/echo/smile,
		/mob/living/simple_animal/hostile/ordeal/echo/justitia,
		/mob/living/simple_animal/hostile/ordeal/echo/capo,
		/mob/living/simple_animal/hostile/ordeal/echo/flowering,
		/mob/living/simple_animal/hostile/ordeal/echo/mimicry,
		)

/datum/ordeal/fixers/echoes/black_dawn
	name = "The Dawn of Black"
	flavor_name = "A Mirror"
	announce_text = "The unexamined life is not worth living."
	end_announce_text = "After it's all said and done, it's still you."
	can_run = TRUE
	level = 6
	reward_percent = 0.1
	mobs_amount = 3

/datum/ordeal/fixers/echoes/black_noon
	name = "The Noon of Black"
	flavor_name = "A Mirror"
	announce_text = "To thine own self be true..."
	end_announce_text = "And to thine own self be patient."
	can_run = TRUE
	level = 7
	reward_percent = 0.15
	mobs_amount = 6
