/datum/adventure_event/skin_woman
	name = "Art Gallery"
	desc = "YOU SMELL ACRYLIC"
	adventure_cords = list(
		"You wake up on a bench in an art gallery, completely alone. <br>\
		Your back hurts.<br>\
		In the distance you hear a melody, the soft strings echoing in the halls.<br>\
		You take time to look around the gallery.",w

		"A painting catches your eye. <br>\
		It is the portrait of a woman, her face completely skinned. <br>\
		She has long black hair, and her black, soulless eyes are staring at you. <br>\
		The music quiets to a stop as you shudder. <br>\
		You get the feeling of someone's gaze on your back. <br>\
		Turning around, you see shadows moving in the hallway.
		",
		//success in coinflip

		"You take some time to inspect",		//Fail in coinflip
		)

/datum/adventure_event/skin_woman/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			. += CoinFlipping(M)
			return
		if(2)
			AdjustCurrency(-1)
			AdjustHitPoint(50)
		if(3)
			AdjustStatNum(SLOTH_STAT,2)
	return ..()
