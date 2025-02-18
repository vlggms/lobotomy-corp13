/datum/adventure_event/vending_machine
	name = "Vending Machine"
	desc = "YOU SEE A FAINT LIGHT"
	adventure_cords = list(
		"As you are walking down the alley, you see a faint light.<br>\
		After first checking to see if you are being followed, you <br>\
		investigate to find a vending machine in the darkness.<br>\
		It's simply asking you for a coin.",

		"A coin is inserted into the machine, and a drink is dispensed.<br>\
		It tastes like the faint memory of cherry cola.<br>\
		...<br>\
		You don't think it tastes very good, but it's likely not poison.<br>\
		Walking off into the night, you quickly forget what transpired.",

		"You leave the vending machine be. Who knows what it could dispense?<br>\
		Forgetting where you were going, you continue back the way you came.",
		)

/datum/adventure_event/vending_machine/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "INSERT A COIN", M)
			BUTTON_FORMAT(3, "LEAVE IT BE", M)
			return
		if(2)
			AdjustCurrency(-1)
			AdjustHitPoint(100)
		if(3)
			AdjustStatNum(SLOTH_STAT,1)
	return ..()
