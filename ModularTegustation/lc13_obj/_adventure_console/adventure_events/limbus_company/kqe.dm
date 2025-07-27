/datum/adventure_event/kqe
	name = "Mirror Shard:kqe-1j-23"
	desc = "YOU HEAR THE HUM OF MACHINES"
	adventure_cords = list(
		"This dark place might be a factory.<br>\
		A sharp mechanical noise zips through the air.<br>\
		Illuminating eyes are fixed on you.<br>\
		A robot slowly approaches.<br>\
		It appears to be incomplete, as suggested by the bare wires protruding with each movement.<br>\
		Is that leakage antifreeze, or blood?<br>\
		While you were wondering, the terminal on its chest flashed to life.<br>\
		Looks like you can write something.",

		"The robot lifts both arms with some struggle.<br>\
		The terminal prints out its words:<br>\
		<b>Welcome, Dear Guest. Have you enjoyed the town tour?<br>\
		We’d like you to have a souvenir.&#160;:-)</b><br>\
		A smile is displayed on the terminal,<br>\
		but in the robot’s gestures, you feel a plea for help.",

		"<b>Failed to parse question.</b><br>\
		The robot tilted its head.<br>\
		While unable to lift and tilt its head in the other direction,<br>\
		it displays a question on the screen.<br>\
		<b>Did you not take a tour of the town, Dear Guest?</b><br>\
		It seems to want an answer..",

		"<b>Then you may not have a souvenir!</b><br>\
		The terminal suddenly opened upward,<br>\
		and a mechanical arm popped out, trying to snatch something from you.<br>\
		<b>Please cooperate with confiscation! Lying is bad behavior.</b><br>\
		As you duck and twist out of the arm’s way,<br>\
		it gradually grew faster.<br>\
		<b>Please cooperate,<br>\
		or you may be punished according to Rule #A62GBFE1!</b><br>\
		You hurriedly made your escape,<br>\
		fleeing the robot’s unending rampage.",

		"<b>There must have been an issue with the tour program.</b><br>\
		After printing those words,<br>\
		the robot stood still for a while.<br>\
		Just when you started to wonder if it was broken,<br>\the terminal flashed.<br>\
		<b>No response after multiple requests to the Administrator.</b><br>\
		<b>System Error. System Error.</b><br>\
		<b>Rebooting…</b><br>\
		After that, it kept throwing up complicated words on a blue screen.",

		"The terminal’s light goes red, and warnings start to blare.<br>\
		The robot shakes intensely as if in pain.<br>\
		<b>Farewell. Farewell, FarewellFarewellFarewellFarewellFarewellFarewellFarewellFarewellFarewell</b><br>\
		A single word filled the whole screen moments before the robot exploded into bits of metal and gore before your eyes.",

		)

/datum/adventure_event/kqe/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "WRITE HELLO", M)
			BUTTON_FORMAT(6, "WRITE GOODBYE", M)
			return
		if(2)
			AdjustStatNum(ENVY_STAT, ADV_EVENT_STAT_EASY)
			BUTTON_FORMAT(3, "ASK FOR AN EXPLANATION OF THE TOWN", M)
			BUTTON_FORMAT(7, "TAKE SOUVENIR AND LEAVE", M)
			return
		if(3)
			BUTTON_FORMAT(4, "CONFESS THE TRUTH", M)
			BUTTON_FORMAT(5, "TELL IT THAT YOU TOOK A TOUR", M)
			BUTTON_FORMAT(7, "LEAVE WITHOUT ANSWERING", M)
			return
		if(5)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
		if(6)
			AdjustHitPoint(-15)

	return ..()
