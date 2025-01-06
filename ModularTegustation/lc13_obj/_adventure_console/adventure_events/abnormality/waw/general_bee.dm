/datum/adventure_event/general_bee
	name = "Arms Inspection"
	desc = "THE SOUND OF TRUMPETS"
	require_abno = /mob/living/simple_animal/hostile/abnormality/general_b
	adventure_cords = list(
		"Passing underneath a gate on the road, you are accosted by<br>\
		a woman wearing a bright yellow and black jacket.<br>\
		'HALT. Lay down your arms!'<br>\
		She demands you hand over your weapons.<br>\
		'You are entering the domain of the queen!",

		"You lay your weapons down.<br>\
		The guard picks them up for inspection before handing them back.<br>\
		'Nothing seems to be out of order.'<br>\
		She gives you a puzzled look. <br>\
		'But I've never seen anything like these before.'<br>\
		The guard hands you your weapons back, and waves you on.",

		"You don't think that's quite a good idea.<br>\
		Shaking your head, you turn and leave.<br>\
		You hope you never pass this way again.",

		"You grip your weapon tightly. You will not be stopped.<br>\
		The guard sighs and draws her weapon.<br>\
		You both know how this is going to end,<br>\
		and you decide that bloodshed is better than inconvenience.",

		)

/datum/adventure_event/general_bee/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "LAY DOWN YOUR WEAPONS", M)
			BUTTON_FORMAT(3, "REFUSE AND TURN AWAY", M)
			BUTTON_FORMAT(4, "ASSAULT THE GUARD", M)
			return
		if(2)
			AdjustStatNum(PRIDE_STAT, -1)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY *2)
			//No option for 3, because you just leave.
		if(4)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_NORMAL)
			CauseBattle(
				"Yellow-Clad Guard: A somewhat tall guard carrying a large spear. She's clad in yellow and black.",
				MON_DAMAGE_NORMAL,
				MON_HP_RAND_NORMAL,
			)
			gamer.travel_mode = ADVENTURE_MODE_BATTLE

	return ..()
