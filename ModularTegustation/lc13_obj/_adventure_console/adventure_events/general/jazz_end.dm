/datum/adventure_event/jazz_end
	name = "Jazz at the End"
	desc = "IN THE DISTANCE YOU HEAR JAZZ"
	adventure_cords = list(
		"You find youself in a location that resembles the moon.<br>\
		Grey sand crunches beneath your feet<br>\
		and a cold chill lingers in the air.<br>\
		Since entering this place the only sound you have heard<br>\
		is the sound of jazz playing in the distance.",

		"A short distance away from where you entered is a<br>\
		record player calmly spinning a phonograph record<br>\
		under a sky with no stars. Around the record is<br>\
		a leather chair and a wooden table with a empty glass.<br>\
		It feels like someone used to live here... but not anymore.",

		"You leave this world with its last tune.<br>\
		For a moment you close your eyes and enjoy the music.<br>\
		When you open your eyes your back on the path back home.",

		"Your hand calmly pulls the needle up from the record.<br>\
		Your met with a silence that drowns out your own breathing.<br>\
		A world without a heartbeat. A silent world.<br>\
		You regain your composure and walk away from the area.<br>\
		As the world dims around you,<br>\
		you find youself back on the path back home.",

		)

/datum/adventure_event/jazz_end/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "FOLLOW THE MUSIC", M)
			return
		if(2)
			BUTTON_FORMAT(3, "LEAVE THE LAST TUNE", M)
			BUTTON_FORMAT(4, "STOP THE RECORD", M)
			return
		if(3)
			AdjustStatNum(SLOTH_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustStatNum(GLOOM_STAT, ADV_EVENT_STAT_EASY)

	return ..()
