/datum/adventure_event/giant
	name = "House Above the Clouds"
	desc = "YOU SMELL FRESHLY-BAKED BREAD"
	require_abno = /mob/living/simple_animal/hostile/abnormality/beanstalk
	adventure_cords = list(
		"Make yourself at home! I've made some fresh milk and bread! <br>\
		A kind and feminine voice booms across the room. <br>\
		You find yourself at a table before a hearty meal.",

		"Despite the simplicitly, the food is extraordinary. <br>\
		After you finish, you are quickly ushered out of the home. <br>\
		'My husband will be here soon. Please, come visit another time.'",

		"The house is massive - literally. Everything but the table you sat at is larger by an order of magnitude. <br>\
		Across the room, you can see a distant glittering.",

		"You sift through the giant's treasure, and take a sack of gold coins.  <br>\
		The ground quakes, and you quickly leave.",

		"'FEE-FI-FO-FUM, I SMELL THE BLOOD OF AN ENGLISHMAN! BE HE ALIVE, BE HE DEAD, <br>\
		I'LL GRIND HIS BONES TO MAKE MY BREAD!",
	)

/datum/adventure_event/giant/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "EAT YOUR MEAL", M)
			BUTTON_FORMAT(3, "EXPLORE THE AREA", M)
			return
		if(2)
			AdjustHitPoint(40)
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(PRIDE_STAT), "PRIDE", M)
			. += CoinFlipping(M)
			return
		if(4)
			AdjustCurrency(ADV_EVENT_COIN_HARD)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_HARD)
		if(5)
			CauseBattle(
				"The Giant Atop The Beanstalk: This hunchbacked abnormality is simply gigantic. It would be best to flee from such an opponent.",
				MON_DAMAGE_HARD,
				300,
			)
			gamer.travel_mode = ADVENTURE_MODE_BATTLE
	return ..()
