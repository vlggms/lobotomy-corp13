/**
	*The first Skinwoman Event.
	*These events are all generally negative, and have a theme of reverse statchecks.
	*This event set has one negative stat check of each kind. Sloth is from the base event.

	*/

//Glutt - Start Event
//Sloth -
//Gloom - A Tram Ride
//Pride - Bedroom Blues
//Envy  -
//Lust  -
//Wrath -

/datum/adventure_event/skinevent
	name = "A Tram Ride"
	desc = "THE LULL OF A TRAIN"
	adventure_cords = list(
		"Sitting on the bench, and listening to the tram roll over the tracks,<br>\
		you feel absolutely exhausted from your travels.<br>\
		Sighing, you hold your head in your hands, about to cry.",

		"You choke back tears, and something feels off. <br>\
		You snap your head up, and scan the crowd of people. <br>\
		You look through the crowd looking for... something.<br>\
		A shiver runs down your spine. <br>\
		You spot a woman with long black hair. <br>\
		She turns around and gives you a half-hearted smile.",
		//success in coinflip, High Gloom
		//This one is a fake out.

		"You can't stop the tears. <br>\
		You cry. <br>\
		You cry from the stress. <br>\
		You cry from the pain. <br>\
		You cry from the fear. <br>\
		You cry and cry, until there is nothing left.",		//Fail in coinflip, low gloom


		"You give her a small smile. <br>\
		That's when you freeze. <br>\
		The woman behind her.... has long black hair... <br>\
		This second woman turns around to stare you dead in the eyes, with her skinless face. <br>\
		No one else seems to notice her. <br>\
		She knows who you are. She knows what you are. <br>\
		You rush out of the tram at the next stop, and spend all night sprinting home.",		//You see her
		)
	event_locks = "SHE KNOWS"
	force_encounter = TRUE

/datum/adventure_event/skinevent/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "GLOOM", M)
			return
		if(2)
			BUTTON_FORMAT(4, "SMILE BACK", M)
			return
		if(3)
			AdjustStatNum(GLOOM_STAT,2)		//Bit of gloom
		if(4)
			AdjustStatNum(GLOOM_STAT,-5)
	return ..()

