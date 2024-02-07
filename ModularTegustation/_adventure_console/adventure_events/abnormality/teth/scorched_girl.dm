/datum/adventure_event/match
	name = "Final Match"
	desc = "A COLD WIND BLOWS FROM THIS PATH"
	require_abno = /mob/living/simple_animal/hostile/abnormality/scorched_girl
	adventure_cords = list(
		"You stand in the snow peering into a nicely lit home.<br>\
		Inside is the scene of a family having dinner.<br>\
		Next to you is a small girl holding a box of matches, she stands there watching blankly as the world ignores her.",

		"The window breaks as the inside of the house erupts into flames.<br>\
		The warmth of the fire is comforting in the bitter chill.<br>\
		The girl next to you smiles weakly before the fire dies down leaving nothing but cold ash and burnt matches",

		//You cannot change the outcome of the story.
		"You feel strangely out of place while you fish out a coin from your pocket and request a match.<br>\
		The girl turns to you, her form starts to sizzle and burn.<br>\
		After handing you a match she erupts into a fire that carries no warmth.",
		)

/datum/adventure_event/match/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "CONTINUE TO WATCH", M)
			if(gamer.virtual_coins > 0)
				BUTTON_FORMAT(3, "REQUEST A MATCH", M)
			else
				. += "You have no coins.<br>"
			return
		if(2)
			AdjustHitPoint(10)
			AdjustStatNum(ENVY_STAT, 1)
		if(3)
			AdjustCurrency(-1)
	. = ..()
