/datum/adventure_event/coffin_return
	name = "Mirror Shard:Coffin Return"
	desc = "YOU HEAR THE WAILING"
	//I thought this event was cool for being just a lil red beetle until i read the rest of the text,-IP
	adventure_cords = list(
		"A wail fills the forest...<br>\
		You cant help but wonder what it's so sorrowful for.<br>\
		Theres a coffin in the middle of the woods.<br>\
		It has been tied with multiple cords and ropes, in \
		what appears to be a desperate attempt to keep its contents from escaping.<br>\
		However, the coffin continues to rumble and creak.",

		"Ability Challenge",

		"With each rope that's untied, the wail grows louder.<br>\
		You feel sympathy for the trapped being.<br>\
		Undoing the ropes, you begin to weep along with their wailing.<br>\
		One undone knot accompanies sorrow.<br>\
		One undone knot accompanies lamentation.<br>\
		When the last is released, you discover that there is no one inside.<br>\
		Perplexed, you examine the interior, and find a single, red-jeweled beetle.",

		"With each rope that's untied, the wail grows louder.<br>\
		There's more than one individual occupying the coffin.<br>\
		Several people are clinging to each other, all crying.<br>\
		The coffin bursts open, letting them out.",

		"Ability Challenge",

		"The red arms wave in the air, as if pleading not to be left behind.<br>\
		But, after another look, it also seems as if they're thankful for being left as they are.<br>\
		Though the wailing hasn't ceased, the weeping seems to have softened, just a little...",

		"You disregard the chilling sensation and move on.<br>\
		However, that feeling would linger, even after a while of walking.<br>\
		At one point, you stopped and turned around to find a hand.<br>\
		It was attached to an unnaturally scrawny red arm.<br>\
		It grabbed its speechless victim.<br>\
		A familiar note was added to the coffins wailing.",
		)

/datum/adventure_event/coffin_return/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "OPEN THE COFFIN", M)
			BUTTON_FORMAT(5, "LEAVE IT BE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(1)
			AdjustStatNum(RAND_STAT, 1)
		if(4)
			CauseBattle(
				pick(
					"Wound Clerids:Small red insects that cause excessive bleeding.",
					"Coffin Hand:A slender red hand emerging from a coffin.",
				),
				"3d3",
				MON_HP_RAND_EASY,
			)
		if(5)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			.+= CoinFlipping(M)
			return
		if(7)
			AdjustHitPoint(-27)
	. = ..()
