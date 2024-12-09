/datum/adventure_event/thunderbird
	name = "Strangers in a Clearing"
	desc = "YOU SMELL SMOKE"
	require_abno = /mob/living/simple_animal/hostile/abnormality/thunder_bird
	adventure_cords = list(
		"You find yourself in a smoldering clearing, surrounded by the charred skeletons of tree trunks.<br>\
		Ahead, you see a crowd of people, surrounding a tall structure, \
		obfuscated by the smoke and dark clouds.",

		"You approach the structure. At a closer glance, it appears to be a massive altar.<br>\
		The humanoids in the crowd are all hideously deformed, skin boiled and charred as if burnt alive.<br>\
		And the smell. The smell of rot, charcoal, and viscera.<br>\
		Is this a place of worship, or a place of mourning?",

		"The people are here to worship their god, and pay you no heed.",

		"You sit among them, and the people eventually leave. \
		As you depart, you are filled with an unnatural vigor.",

		"The Altar, however, somehow turns to face you.<br>\
		It loudly threatens you with one word: 'Leave.' <br>\
		Before you can heed the warning, you are struck by lightning.",

		"This is a memorial of a great plague long ago. The humanoids surrounding you, who are no longer people, \
		only want to be remembered. How will you honor them?",

		"The memorial depics a massive, painted wooden bird atop a charred mess. Its eyes visibly move, but you manage to leave \
		unharmed.",

		"They stare. The great plague, the wars that followed. You were a part of them.",

		"You recognize these people. Their attire, their outward appearances, the smell.<br>\
		This forest is dangerous, and so are they.<br>\
		You flee without looking back.",
	)

/datum/adventure_event/thunderbird/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "APPROACH THE STRUCTURE", M)
			BUTTON_FORMAT(9, "WALK AWAY", M)
			return
		if(2)
			BUTTON_FORMAT(3, "WORSHIP", M)
			BUTTON_FORMAT(6, "MOURNING", M)
			return
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(ENVY_STAT), "ENVY", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			. += CoinFlipping(M)
			return
		if(4)
			AdjustCurrency(ADV_EVENT_COIN_NORMAL)
			AdjustStatNum(ENVY_STAT, ADV_EVENT_STAT_NORMAL)
		if(5)
			AdjustHitPoint(-40)
		if(6)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "GLOOM", M)
			. += CoinFlipping(M)
			return
		if(7)
			AdjustCurrency(ADV_EVENT_COIN_NORMAL)
			AdjustStatNum(GLOOM_STAT, ADV_EVENT_STAT_NORMAL)
		if(8)
			CauseBattle(
				"Thunder Warriors: A crowd of charred humanoids wearing buffalo robes and hair roaches. The proud warriors fight you one at a time.",
				MON_DAMAGE_NORMAL,
				100,
				5,//Currently there's no way to normally raise your stats to beat this, so it's a bit generous
			)
		if(9)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
			AdjustStatNum(ENVY_STAT, ADV_EVENT_STAT_EASY)
	return ..()
