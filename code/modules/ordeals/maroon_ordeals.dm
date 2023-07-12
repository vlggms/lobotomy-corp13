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
