/datum/ordeal/simplespawn/steel_dawn
	name = "Dawn of Steel"
	annonce_text = "Was there any meaning to that war? "
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

/datum/ordeal/simplecommander/steel_noon
	name = "Noon of Steel"
	annonce_text = "It certainly would be nice if they were."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 2
	reward_percent = 0.15
	color = "#444444"
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/steel_noon)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/noon)
	bossnumber = 4
	gruntnumber = 4

/datum/ordeal/simplecommander/steel_dusk
	name = "Dusk of Steel"
	annonce_text = "Only the dead have seen the end of war."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 3
	reward_percent = 0.2
	color = "#444444"
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/steel_dusk, /mob/living/simple_animal/hostile/ordeal/steel_noon)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/noon)
	bossnumber = 2
	gruntnumber = 5

/datum/ordeal/simplecommander/steel_midnight
	name = "Midnight of Steel"
	annonce_text = "Thus, what is of supreme importance in war is to attack the enemy’s strategy."
	annonce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#444444"
	bosstype = list(/mob/living/simple_animal/hostile/ordeal/steel_dusk, /mob/living/simple_animal/hostile/ordeal/steel_noon)
	grunttype = list(/mob/living/simple_animal/hostile/ordeal/steel_dawn/strong)
	bossnumber = 4
	gruntnumber = 5
