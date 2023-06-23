/datum/ordeal/simplespawn/steel_dawn
	name = "Dawn of Steel"
	annonce_text = "The augmentation... I don’t regret it. One downside, though, is that I won’t ever be able to return to civilian life."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg' // Give it proper sounds
	end_sound = 'sound/effects/ordeals/indigo_end.ogg' // There as well
	level = 1
	reward_percent = 0.1
	spawn_places = 3
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/steel/dawn
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0.1
	color = "#71797E"

/datum/ordeal/simplecommander/steel_dusk
	name = "Dusk of Steel"
	annonce_text = "If we lose this war we would would be cast to the streets, seen as less than human by even the rats."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg' // And there
	end_sound = 'sound/effects/ordeals/indigo_end.ogg' // Yep, there too
	level = 3
	reward_percent = 0.2
	color = "#71797E"
	boss_type = list(/mob/living/simple_animal/hostile/ordeal/steel/dusk, /mob/living/simple_animal/hostile/ordeal/steel/noon/flying)
	grunt_type = list(/mob/living/simple_animal/hostile/ordeal/steel/noon)
	boss_amount = 2
	grunt_amount = 2
	boss_player_multiplicator = 0.075
	grunt_player_multiplicator = 0.25
