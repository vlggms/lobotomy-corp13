/**
	* This event was just based on the way some rich people flaunt their wealth as a way of escaping the lonliness that comes from their position.
	* -ML
	*/
/datum/adventure_event/Man_Sand
	name = "All the Sand in the World"
	desc = "SAND IS EVERYWHERE"
	adventure_cords = list(
		"As you enter the room it opens up, its ceiling so high that it disappears into a single point.<br>\
		The only thing in it is a pile of glistening grains of sand, piled so high that it disappears into the ceiling.<br>\
		\"Welcome!\" a voice shouts. At first you see nothing, and then a figure begins to form itself from the sand.<br>\
		It slowly rises. \"Isn’t it wondrous? My collection?\" It grins, waving around at the empty room.<br>\
		\"Feel free to indulge yourself in its splendor!\"<br>\
		When you don’t immediately begin applauding it backs away, confused.<br>\
		In a flash it builds a few effigies of itself, each of them clapping until they collapse.",

		"You decide to humor the thing, telling it how impresive all the sand is.",

		"\"See?\" The figure says, turning towards the smaller versions of itself.<br>\
		\"Even this intruder recognizes how spectacular I am!\"<br>\
		They continue boasting to their constructed audience, ignoring you taking your leave.",

		"\"Why do you mock me?\" The figure cries, thrashing around kicking up clouds of sand.<br>\
		Throwing fistfuls of sand that carry their own degrading hands with them they shout: \"Begone, begone!\"<br>\
		As you leave you notice the sand solidifying into nuggets of gold in your hand.",

		"\"Wait,\" The figure cries rushing to try and grab you. \"Where are you going?\"<br>\
		As soon as its foot leaves the pile it’s body crumbles into sand.<br>\
		You simply leave. Behind you it continues to whine, demanding you come back.",
	)

/datum/adventure_event/Man_Sand/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "HUMOR IT", M)
			BUTTON_FORMAT(5, "LEAVE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustStatNum(SLOTH_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
	return ..()
