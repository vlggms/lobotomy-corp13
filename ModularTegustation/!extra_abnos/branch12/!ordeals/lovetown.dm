// Dawn
/datum/ordeal/simplespawn/branch12/lovetown_dawn
	name = "Memory of a Warp Train I"
	flavor_name = "Flesh Amalgams"
	announce_text = "Their bodies are no longer human, and they come to slaughter."
	end_announce_text = "Putting them down is a mercy."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 1
	reward_percent = 0.10
	spawn_places = 6
	spawn_amount = 3
	spawn_type = list(
		/mob/living/simple_animal/hostile/lovetown/suicidal,
		/mob/living/simple_animal/hostile/lovetown/stabber,
		/mob/living/simple_animal/hostile/lovetown/slasher,
		)
	color = "#c26e57"
	can_run = FALSE
	place_player_multiplicator = 0.08
	spawn_player_multiplicator = 0


/datum/ordeal/simplespawn/branch12/lovetown_dawn/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

//Noon
/datum/ordeal/simplecommander/branch12/lovetown_noon
	name = "Memory of a Warp Train II"
	flavor_name = "Flesh Amalgams"
	announce_text = "Their bodies are no longer human, and they come to slaughter."
	end_announce_text = "Putting them down is a mercy."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 2
	reward_percent = 0.15
	boss_amount = 1
	grunt_amount = 6
	boss_type = list(
		/mob/living/simple_animal/hostile/lovetown/slumberer,
		/mob/living/simple_animal/hostile/lovetown/shambler,
		/mob/living/simple_animal/hostile/lovetown/slammer)
	grunt_type = list(
		/mob/living/simple_animal/hostile/lovetown/suicidal,
		/mob/living/simple_animal/hostile/lovetown/stabber,
		/mob/living/simple_animal/hostile/lovetown/slasher,)
	color = "#c26e57"
	can_run = FALSE
	boss_player_multiplicator = 0.045
	grunt_player_multiplicator = 0


/datum/ordeal/simplecommander/branch12/lovetown_noon/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

//Dusk
/datum/ordeal/simplecommander/branch12/lovetown_dusk
	name = "Memory of a Warp Train III"
	flavor_name = "Flesh Amalgams"
	announce_text = "Their bodies are no longer human, and they come to slaughter."
	end_announce_text = "Putting them down is a mercy."
	announce_sound = 'sound/effects/ordeals/steel_start.ogg'
	end_sound = 'sound/effects/ordeals/steel_end.ogg'
	level = 3
	reward_percent = 0.20
	boss_amount = 1
	grunt_amount = 4
	boss_type = list(/mob/living/simple_animal/hostile/lovetown/abomination, /mob/living/simple_animal/hostile/lovetown/slumberer)
	grunt_type = list(
		/mob/living/simple_animal/hostile/lovetown/slammer,
		/mob/living/simple_animal/hostile/lovetown/shambler,
		/mob/living/simple_animal/hostile/lovetown/slumberer,)
	color = "#c26e57"
	can_run = FALSE
	boss_player_multiplicator = 0.045
	grunt_player_multiplicator = 0


/datum/ordeal/simplecommander/branch12/lovetown_dusk/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run
