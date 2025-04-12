/datum/adventure_event/skin_woman
	name = "Art Gallery"
	desc = "YOU SMELL ACRYLIC"
	adventure_cords = list(
		"You wake up on a bench in an art gallery. <br>\
		Your back hurts.<br>\
		In the distance you hear a melody, the soft strings echoing in the halls.<br>\
		You take time to look around the gallery.",

		"A coin is inserted into the machine, and a drink is dispensed.<br>\
		It tastes like the faint memory of cherry cola.<br>\
		...<br>\
		You don't think it tastes very good, but it's likely not poison.<br>\
		Walking off into the night, you quickly forget what transpired.",

		"You leave the vending machine be. Who knows what it could dispense?<br>\
		Forgetting where you were going, you continue back the way you came.",
		)

/datum/adventure_event/skin_woman/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT), "LUST", M)
			. += CoinFlipping(M)
			return
		if(2)
			AdjustCurrency(-1)
			AdjustHitPoint(50)
		if(3)
			AdjustStatNum(SLOTH_STAT,1)
	return ..()
