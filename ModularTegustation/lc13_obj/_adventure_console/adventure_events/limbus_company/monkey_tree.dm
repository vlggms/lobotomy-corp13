/datum/adventure_event/monkey_tree
	name = "Mirror Shard:Monkey Tree"
	desc = "THIS PATH IS ARID"
	adventure_cords = list(
		"A resentful tree stands among a desolate plain.<br>\
		The place has an air of umbrage.<br>\
		Something feels discordant about the sky.<br>\
		You note one twig growing out of the tree like an arm.<br>\
		Though the tree is unmoving, it seems to want something.",

		"You sprinkled water around the tree.<br>\
		It soon boiled away,<br>\
		as it would on a cast-iron skillet.<br>\
		You don’t see any change in the tree.<br>\
		Maybe the twig has become livelier?<br>\
		No matter how you look at it, it’s rather hard to tell.",

		"With another go and look around,<br>\
		the tree appeared more alive than you first thought.<br>\
		The foreboding aura disappeared at some point, too.<br>\
		Could you really have quenched its age-long thirst?<br>\
		The twig rustled and came to you.<br>\
		It gave you a handful of gifts<br>\
		as a token of its gratitude..",

		"You try pouring more water,<br>\
		but it still vaporizes in an instant.<br>\
		Maybe it’s started to absorb less?<br>\
		Another close look still shows no changes.",

		"You snapped the arm-like twig that had been bothering you.<br>\
		A cacophony of dreadful screams struck your ears.<br>\
		You noticed that the screams were coming from the twig.<br>\
		As much as it creeps you out, you get a strong feeling<br>\
		that you will suffer terrible consequences if you throw it away."

		)

/datum/adventure_event/monkey_tree/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "SPRINKLE WATER", M)
			BUTTON_FORMAT(5, "SNAP THE TWIG", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(10, "SPRINKLE MORE WATER", M)
			BUTTON_FORMAT(5, "SNAP THE TWIG", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(ADV_EVENT_STAT_EASY)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_NORMAL)
		if(4)
			CHANCE_BUTTON_FORMAT(10, "SPRINKLE MORE WATER", M)
			BUTTON_FORMAT(5, "SNAP THE TWIG", M)
			. += CoinFlipping(M)
			return
		if(5)
			AdjustHitPoint(-10)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_EASY)

	return ..()

//Due to the monkey tree's unique cycling event i need to override the chancecords proc -IP
/datum/adventure_event/monkey_tree/ChanceCords(input_num)
	var/remember_chance = input_num + (extra_chance * EXTRA_CHANCE_MULTIPLIER)
	temp_text += "CHANCE [remember_chance]:"
	extra_chance = 0
	temp_text += "YOU SPRINKLE WATER<br>"
	if(prob(remember_chance))
		cords = 3
	else
		cords = 4
