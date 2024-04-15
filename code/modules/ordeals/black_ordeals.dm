// Dawn
/datum/ordeal/fixers/echoes
	name = "Echoes"
	flavor_name = "A Mirror"
	announce_text = "This isn't supposed to happen, but they have come for you. Might want to report this to central command."
	can_run = FALSE
	reward_percent = 0.1
	color = "#444444"
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/star,
		/mob/living/simple_animal/hostile/ordeal/echo/smile,
		/mob/living/simple_animal/hostile/ordeal/echo/justitia,
		/mob/living/simple_animal/hostile/ordeal/echo/capo,
		/mob/living/simple_animal/hostile/ordeal/echo/flowering,
		/mob/living/simple_animal/hostile/ordeal/echo/mimicry,
		/mob/living/simple_animal/hostile/ordeal/echo/pink,
		/mob/living/simple_animal/hostile/ordeal/echo/adoration,
//		/mob/living/simple_animal/hostile/ordeal/echo/gold,			Can't get it up
		/mob/living/simple_animal/hostile/ordeal/echo/spooner,
		/mob/living/simple_animal/hostile/ordeal/echo/soulmate,

		)

/datum/ordeal/fixers/echoes/black_dawn
	name = "The Dawn of Black"
	flavor_name = "A Mirror"
	announce_text = "The unexamined life is not worth living."
	end_announce_text = "After it's all said and done, it's still you."
	can_run = TRUE
	level = 6
	reward_percent = 0.1
	mobs_amount = 2

/datum/ordeal/fixers/echoes/black_noon
	name = "The Noon of Black"
	flavor_name = "A Mirror"
	announce_text = "To thine own self be true..."
	end_announce_text = "And to thine own self be patient."
	can_run = TRUE
	level = 7
	reward_percent = 0.15
	mobs_amount = 5

/datum/ordeal/fixers/echoes/black_dusk
	name = "The Dusk of Black"
	flavor_name = "A Mirror"
	announce_text = "To thine own self be true..."
	end_announce_text = "And to thine own self be patient."
	can_run = TRUE
	level = 8
	reward_percent = 0.2
	mobs_amount = 7

/datum/ordeal/fixers/echoes/black_midnight
	name = "The Midnight of Black"
	flavor_name = "A Mirror"
	announce_text = "To thine own self be true..."
	end_announce_text = "And to thine own self be patient."
	can_run = TRUE
	level = 9
	reward_percent = 0.25
	mobs_amount = 2
	potential_types = list(
		/mob/living/simple_animal/hostile/ordeal/echo/paradise,
		/mob/living/simple_animal/hostile/ordeal/echo/twilight,
		//mob/living/simple_animal/hostile/ordeal/echo/distorted,
		)
