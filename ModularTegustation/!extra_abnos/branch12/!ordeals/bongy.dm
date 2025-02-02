// Has a dawn and a midnight
/datum/ordeal/boss/branch12/chicken_dawn
	name = "Memory of Fried Chicken I"
	flavor_name = "The Chicken Shop"
	announce_text = "He fought for so long, for something that he never even remembered."
	end_announce_text = "And he will keep fighting until he is dust."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 1
	reward_percent = 0.10
	color = "#ad7424"
	can_run = FALSE
	bosstype = /mob/living/simple_animal/hostile/distortion/papa_bongy

/datum/ordeal/boss/branch12/chicken_dawn/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run


// Has a dawn and a midnight
/datum/ordeal/boss/branch12/chicken_midnight
	name = "Memory of Fried Chicken II"
	flavor_name = "The Chicken Shop"
	announce_text = "He fought for so long, for something that he never even remembered."
	end_announce_text = "And he will keep fighting until he is dust."
	announce_sound = 'sound/effects/ordeals/indigo_start.ogg'
	end_sound = 'sound/effects/ordeals/indigo_end.ogg'
	level = 4
	reward_percent = 0.25
	color = "#ad7424"
	can_run = FALSE
	bosstype = /mob/living/simple_animal/hostile/distortion/papa_bongy/spicy


/datum/ordeal/boss/branch12/chicken_midnight/AbleToRun()
	if(SSmaptype.maptype == "branch12")
		can_run = TRUE
	return can_run
