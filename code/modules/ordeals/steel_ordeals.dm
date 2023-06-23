/datum/ordeal/simplespawn/steel_dawn
	name = "Dawn of Steel"
	annonce_text = "The augmentation... I don’t regret it. One downside, though, is that I won’t ever be able to return to civilian life."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 1
	reward_percent = 0.1
	spawn_places = 4
	spawn_amount = 3
	spawn_type = /mob/living/simple_animal/hostile/ordeal/steel_dawn
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0
	color = "#444444"

/datum/ordeal/simplecommander/steel_dusk
	name = "Dusk of Steel"
	annonce_text = "If we lose this war we would would be cast to the streets, seen as less than human by even the rats."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#444444"
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/steel_dusk, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon, /mob/living/simple_animal/hostile/ordeal/steel_dawn/steel_noon/flying)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn)
	bossnumber = 3
	gruntnumber = 4
