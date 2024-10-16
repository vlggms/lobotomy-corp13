//A future abnormality I plan to add into a vault/ruin via the abnocore system.
//I saw it in a dream - Mr.Heavenly/vampirebat74
/datum/adventure_event/tsa
	name = "Oddity in a Forest"
	desc = "YOU FIND A BUILDING"
//	require_abno = /mob/living/simple_animal/hostile/abnormality/tsa_woods
	adventure_cords = list(
		"Get in line.<br>\
		Don't cut!<br>\
		A massive line has formed in an outdoor wooden corridor before you.<br>\
		It would take an incredibly long time to reach the end, and you've yet to join it.<br>\
		However, a forest completely surrounds the area. What are they getting in line for?",

		"You enter the line. <br>\
		The path snakes around a central building, and it takes roughly \
		an hour to reach the end of the line. <br> \
		At the end, you see people tearing their own skins and placing them into bins.",

		"The now-skinless people pack their organs as if they were luggage.<br> \
		You must conform to the rules, as everyone else has.<br> \
		No matter how painful or uncomfortable it may be.<br> \
		Following the excruciating ordeal, you wear your eyes as if they were glasses.<br> \
		Your lungs, as if they were a bra.<br> \
		Your intestines, a tie below the waist.<br> \
		The final accoutrement, your button heart.<br> \
		At last, you are ushered out, horrified and indignant.",

		"The building is so crowded, you can't escape by conventional means. \
		You need to think of a way to get out of here.",

		"If this place operates the way you think it does, then... <br> \
		You scream 'BOMB!' as loud as you can. <br> \
		The people, panicked by the word, scatter immediately. \
		You take a few of their belongings on the way out.",

		"If this place operates the way you think it does, then... <br> \
		You scream 'BOMB!' as loud as you can. <br> \
		The people, panicked by the word, scatter immediately. \
		However, the guards seem ready for a fight.",


		"Nothing Happened. <br>\
		You walk around the building and find yourself in a parkling lot, beyond the wineberry creek.",
	)

/datum/adventure_event/tsa/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "ENTER THE LINE", M)
			BUTTON_FORMAT(7, "WALK AWAY", M)
			return
		if(2)
			BUTTON_FORMAT(3, "CONTINUE", M)
			BUTTON_FORMAT(4, "ATTEMPT ESCAPE", M)
			return
		if(3)
			AdjustHitPoint(-35)
		if(4)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			. += CoinFlipping(M)
			return
		if(5)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_NORMAL)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
		if(6)
			CauseBattle(
				"TSA Agent: A walking amalgam of firearms, blades, and other deadly weapons.",
				MON_DAMAGE_EASY,
				50,
			)
	return ..()
