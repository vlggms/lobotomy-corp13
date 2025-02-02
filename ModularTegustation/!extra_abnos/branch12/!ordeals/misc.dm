//Crows
/datum/ordeal/simplespawn/branch12/runaway_crows
	name = "Memory of The Black Forest"
	flavor_name = "Lonely Crows"
	announce_text = "The birds ran from the forest to escape the monster."
	end_announce_text = "And they meet their end anyways."
	announce_sound = 'sound/effects/ordeals/crimson_start.ogg'
	end_sound = 'sound/effects/ordeals/crimson_end.ogg'
	level = 1
	reward_percent = 0.10
	spawn_places = 6
	spawn_amount = 2
	spawn_type = list(
		/mob/living/simple_animal/hostile/runawaybird
		)
	color = "#5c5c5c"
	can_run = FALSE
	place_player_multiplicator = 0.2
	place_player_multiplicator = 0.2


/datum/ordeal/simplespawn/branch12/runaway_crows/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run

