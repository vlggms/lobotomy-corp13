/datum/adventure_event/golden_grip
	name = "Mirror Shard:Golden Grip"
	adventure_cords = list(
		"Could these five appendages protruding from the urn be a palm?<br>\
		Or is it a naked person who put their head into the golden urn?<br>\
		What did this person see in the urn to cause them to shove their face into it?<br>\
		As if that wasn't enough, the whole body turned into a hand that tries to grasp everything it can.<br>\
		If it finally takes hold of everything in the world, will its grip loosen at last?",

		"Ability Challenge",

		"Trying to lightly remove it is like brushing off dust.<br>\
		Is an affront to the greed that refused to dissipate even after shoving the head into it.<br>\
		There was no choice but to watch as the hand reached out.",

		"We thought we pulled it out, but couldn't move forward.<br>\
		Seeing it grasp at coattails until the end, you're sapped of strength, bound by the dreadful tenacity.",

		"Ability Challenge",

		"To hug is to embrace another.<br>\
		The fingers that were stretched to grasp things clasp with another's appendages for the first time.<br>\
		Between the quietly laced appendages, there was a warmth of blood beginning to circulate.<br>\
		Like that, the rigid greed loosens.",

		"It seems the basic manners of clearing sweat from the hand before extending it for a handshake were neglected.<br>\
		Your hand slipped, and the emptied palm wriggles as if to seek another left hand to grasp.<br>\
		However, it no longer tries to recklessly grab things, seemingly fulfilled by the attempt.",
	)

/datum/adventure_event/golden_grip/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "REMOVE THE HEAD FROM THE URN", M)
			BUTTON_FORMAT(5, "HUG AND SHAKE THE BODY", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT), "LUST", M)
			. += CoinFlipping(M)
			return
		if(3)
			CauseBattle(
				"Urn Body:A large grey human body with a gold urn for a head. You cant help but notice the giant fanged mouth that has taken up most of its abdominal region.",
				MON_DAMAGE_NORMAL,
				120,
			)
		if(4)
			AdjustHitPoint(-40)
		if(5)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			.+= CoinFlipping(M)
			return
		if(6)
			AdjustCurrency(3)
		if(7)
			AdjustCurrency(1)
			AdjustHitPoint(-15)
	. = ..()
