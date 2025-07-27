/datum/adventure_event/lost_mind
	name = "Mirror Shard:Lost Mind"
	desc = "YOU SOMETIMES DRIFT TOWARDS THIS PATH"
	adventure_cords = list(
		"Sometimes, the mind wanders.<br>\
		Where does such a mind end up?<br>\
		If it had a physical destination,<br>\
		then it must look like this.<br>\
		An empty, humanlike statue<br>\
		is where that mind would decide to settle.<br>\
		Now, it extends its arms, trying to grab at anything..",

		"You tried to hold its hand,<br>\
		but you couldn’t touch it.<br>\
		It was an illusion, something that shouldn’t be made visible.<br>\
		It retracted its arm,<br>\
		as if it understood as well…<br>\
		Then, it broke itself,<br>\
		turning into a small statue.",

		"Ability Challenge<br>\
		It reaches for you with its tarlike arms.",

		"You quickly ducked out of its path.<br>\
		Its arms obsessively grope around for you.<br>\
		Fortunately, it could only reach so far,<br>\
		and you safely made your escape.",

		"You quickly ducked out of its path.<br>\
		However, it was no easy task<br>\
		to avoid its obsessive hands.<br>\
		A few of them managed to grab and scratch at us.<br>\
		Though you managed to escape, you suffered a lot.",

		)

/datum/adventure_event/lost_mind/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "REACH OUT TO ITS HAND", M)
			BUTTON_FORMAT(3, "REFUSE IT", M)
			return
		if(2)
			AdjustHitPoint(-13)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_EASY)
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "GLOOM", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			. += CoinFlipping(M)
			return
		if(5)
			AdjustHitPoint(-13)

	return ..()
