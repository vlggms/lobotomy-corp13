/datum/adventure_event/skinevent/bedroom
	name = "Bedroom Blues"
	desc = "YOU SEE A FAINT LIGHT"
	adventure_cords = list(
		"You lay on your bed, but you are unable to go to bed.<br>\
		The faint light and soft noises coming from your window are keeping you up.<br>\
		You feel like it would take some courage to get up.",

		"You groggily get up and open your curtains. <br>\
		You see a figure in the streets, a trenchcoat, and a wide brimmed hat . <br>\
		Squinting down at the figure, you notice something about it. <br>\
		It looks somewhat familiar. <br>\
		... <br>\
		The figure turns around and you see the red of it's face obscured with long black hair.<br>\
		And she notices you looking at her.<br>\
		Stumbling back from the window, you shut the curtains, but it's too late.<br>\
		You hear the crashing of glass and the flapping of cloth as the figure lands inside your bedroom.<br>\
		You don't think you can kill her, not here. You have to drive her away.",
		//success in coinflip, High Pride

		"You don't have the heart. <br>\
		You freeze in bed, and listen to the noises outside. <br>\
		You hear scraping. <br>\
		You hear some strange noises. <br>\
		You hear screaming. <br>\
		You hear a body being dragged away. <br>\
		You feel like you've witnessed something horrible.",		//Fail in coinflip, low pride
		)

/datum/adventure_event/skinevent/bedroom/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			return
		if(2)
			AdjustStatNum(PRIDE_STAT,-5)
			CauseBattle(
				"The Skinned Lady: A woman with long black hair and skinned face.",
				MON_DAMAGE_HARD,
				300,
			)

		if(3)
			AdjustStatNum(PRIDE_STAT,2)		//Bit of pride
	return ..()

