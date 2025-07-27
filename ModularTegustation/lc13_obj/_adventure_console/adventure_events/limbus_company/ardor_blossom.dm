/datum/adventure_event/ardor_blossom
	name = "Mirror Shard:Ardor Blossom Moth"
	desc = "ORANGE LIGHTS FLUTTER DOWN THIS PATH"
	adventure_cords = list(
		"Orange circles float in the air before your eyes.<br>\
		The lights flutter and dance in the air, creating a haze.<br>\
		Something is burning to death within.<br>\
		Would you be scorched as well if the flames touched you?.",

		"Enchanted by the haze, you extend a finger,<br>\
		waiting for one of the lights to land.<br>\
		A glimmering ball gently perches on your digit.<br>\
		Then, a fire engulfs it.<br>\
		Another glow attaches to your body, then four, then eight.<br>\
		They multiply until you have been entirely shrouded in light.",

		"Resisting the temptation to reach out,<br>\
		you decide it’s better to stay away from such dubious warmth.<br>\
		You feel a cold wave crawl up your spine in an instant, but it may be the right choice.<br>\
		Even children know not to play with fire.",

		)

/datum/adventure_event/ardor_blossom/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "REACH OUT", M)
			BUTTON_FORMAT(5, "TURN AROUND", M)
			return
		if(2)
			AdjustHitPoint(-10)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY)

	return ..()
