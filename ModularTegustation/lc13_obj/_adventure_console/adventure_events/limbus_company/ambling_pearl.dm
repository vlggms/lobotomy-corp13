/datum/adventure_event/ambling_pearl
	name = "Mirror Shard:Ambling Pearl"
	desc = "THE SMELL OF ROT"
	adventure_cords = list(
		"The barren mudflat reeks of salt and rot.<br>\
		What little jade-colored seawater is left there<br>\
		doesn’t seem to have anything inside.<br>\
		A giant clam walks before you.<br>\
		With each step it takes, it sprays a fetid green muck.<br>\
		Is the clam the source of the contamination,<br>\
		or is it working to contain the filth?.",

		"Ability Challenge",

		"You contain some of the slime in a glass jar.<br>\
		This isn’t simply a mass of filth.<br>\
		Numerous hatchlings swim inside.<br>\
		These tiny creatures are feeding on each other<br>\
		could they be the clam’s offspring?",

		"You approach with a glass jar in hand.<br>\
		However, hesitation takes hold, and you eventually turn around.<br>\
		You couldn’t stand the thought<br>\
		of reaching out to contain that filth.<br>\
		In fact, you get the feeling that it’s something you mustn’t hold.",

		"You wade through the virescence.<br>\
		With each step, the foul mud<br>\
		brings terrible pain to one’s feet.<br>\
		You can no longer move forward.<br>\
		Besides struggling to wade through,<br>\
		you worry that your legs might slough off if you go farther.<br>\
		While you were hesitating,<br>\
		the clam walked off into the distance.",
		)

/datum/adventure_event/ambling_pearl/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "SAMPLE THE GREEN SUBSTANCE", M)
			BUTTON_FORMAT(5, "APPROACH THE CLAM", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "GLOOM", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustHitPoint(-10)
		if(5)
			AdjustHitPoint(-4)

	return ..()
