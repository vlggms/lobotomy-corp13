// Christmas
/datum/ordeal/simplespawn/christmas_dawn
	name = "The Dawn of Christmas"
	flavor_name = "The Miracle in District 12"
	announce_text = "Cute teddy bears, wonderous toy trains! Christmas gifts just for you!"
	end_announce_text = "Have a merry Christmas and a happy new year!"
	level = 1
	reward_percent = 0.1
	announce_sound = 'sound/effects/ordeals/holiday/xmas_start.ogg'
	end_sound = 'sound/effects/ordeals/holiday/xmas_end.ogg'
	spawn_places = 4
	spawn_amount = 2
	spawn_type = /mob/living/simple_animal/hostile/ordeal/present
	place_player_multiplicator = 0.05
	spawn_player_multiplicator = 0.025
	color = "#FAA0A0"
	can_run = FALSE

/datum/ordeal/simplespawn/christmas_dawn/AbleToRun()
	if(SSevents.holidays && SSevents.holidays[FESTIVE_SEASON]) //runs dec 1-31st
		can_run = TRUE
	return can_run
