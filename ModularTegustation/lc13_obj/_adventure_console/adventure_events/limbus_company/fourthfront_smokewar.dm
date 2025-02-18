/datum/adventure_event/fourthfront_smokewar
	name = "Mirror Shard:Fourth Front of the Smoke War"
	desc = "THIS PATH LEADS BACK TO ONE OF MANY WARS"
	adventure_cords = list(
		"That must be snakes, bugs, or the symbolization of fulfilled peace.<br>\
		Looking closely, the fence of wire and the countless corpses caught<br>\
		 up in it can be seen moving. Those sacks of flesh entangled in painful ways<br>\
		Now, it moves like a living thing, wandering where the Smoke War may have taken place. <br>\
		must be the remains of those who perished in a war fought in the past. <br>\
		The concertina wire was a line crossed between you and me, and a separator. <br>\
		However, this rusted, bloodstained wire now binds us together <br>\
		and squeezes us so our flesh and eyes meet.",

		"Ability Challenge <br>\
		While it stood still, we carefully approached it. <br>\
		If we remove a part of it, those bound to it might find momentary peace.",

		"Taking off a piece of the wire was surprisingly easy. <br>\
		However, the flesh lumps show no change at all. <br>\
		Its as though they are telling us that this wont be remotely sufficient <br>\
		to free them from what they suffered that day.",

		"We weren't familiar enough with the wire's structure. <br>\
		The hand twists and gets dragged into the wire in an instant.<br>\
		Your arm was pulled out but was left severely mangled.",

		"Ability Challenge <br>\
		Was it by pity or some kind of sympathy?<br>\
		Or was it the idea that sharing the pain might reduce their burden?<br>\
		Drops of blood fall from the tip of the hand and seep into the flesh, little by little.",

		"The thing finally responds, approaching as if to look down on you.<br>\
		Maybe it saw you as the same as those who perished in the thick fog.<br>\
		When it opened its mouth with a pitiful look, a glowing object was inside.<br>\
		It might be a small token of consolation it's offering. You took the object.",

		"All corpses and bodies bound to the wire scream at once.<br>\
		The thing begins to rampage in unison.<br>\
		As I was not part of the war nor I was there to witness it, <br>\
		I cannot associate with or understand them in any way.<br>\
		It was merely a fit of hasty arrogance.<br>\
		There was no choice but to flee from the place, leaving the raging thing behind.",
		)

/datum/adventure_event/fourthfront_smokewar/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "REMOVE PART OF THE WIRE", M)
			BUTTON_FORMAT(5, "OFFER BLOOD", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
			AdjustStatNum(RAND_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustHitPoint(-10)
		if(5)
			AdjustHitPoint(-1)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT), "LUST", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			.+= CoinFlipping(M)
			return
		if(6)
			AdjustHitPoint(-10)
			AdjustCurrency(ADV_EVENT_COIN_EASY)

	return ..()
