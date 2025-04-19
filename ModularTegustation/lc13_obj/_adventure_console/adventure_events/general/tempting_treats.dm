/**
	*Based off those Backstreets Butchers.
	*/
/datum/adventure_event/tempting_treats
	name = "Free Samples!"
	desc = "THE STREETS OF FLAVOR"
	adventure_cords = list(
		"\"Would you care for a free sample?\" a tall man asks you, offering you a meat pasty.<br>\
		\"Best in the city!\" he insists.",

		"The crust flakes away in your mouth and the meat melts away on your tongue.<br>\
		\"Good, right? Here, have another!\" he says, beaming.",

		"The second pasty is even better than the first! You savor each mouthful of savory warmth.<br>\
		The tall man smiles even wider than before. \"Here, try the sausage roll! I love it when people appreciate my cooking!\"",

		"The sausage roll warms your insides, like an indulgent embrace from within. A rivulet of grease dribbles down your chin.<br>\
		 His smile widens to a cheshire grin \"Such gusto! Have much as you want, it's on the house!\"",

		 "As you finish one meat pasty, the man hands you another, and then another.",

		 "You hungrily devour one after another. Something inside you straining. You keep eating.",

		 "There's a burning pain inside. Nausea keeps bubbling up. You keep eating.",

		 "Acrid bile and vomit bubbles out of your mouth, tinged with blood. You keep eating",

		 "You keep eating. <br>\
		 A blade flashes in the man's hand. <br>\
		 You keep eating. <br>\
		 Pain shoots down your side. <br>\
		 You keep eating. <br>\
		 The world goes black.",

		 "You politely decline an walk on your way. <br>\
		 <br>\
		 You don't like how that guy was looking at you.",

		 "Thanking the man, you promise to pay another visit to the man's restaurant. <br>\
		 What a nice guy!"


	)

/datum/adventure_event/tempting_treats/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "TRY A SAMPLE", M)
			BUTTON_FORMAT(10, "KEEP WALKING", M)
			return
		if(2)
			BUTTON_FORMAT(3, "HAVE ANOTHER", M)
			BUTTON_FORMAT(11, "PASS ON THE OFFER", M)
			AdjustHitPoint(10)
			return
		if(3)
			BUTTON_FORMAT(4, "ANOTHER", M)
			BUTTON_FORMAT(11, "LEAVE SATISFIED", M)
			AdjustStatNum(GLUTT,1)
			return
		if(4)
			BUTTON_FORMAT(5, "MORE", M)
			BUTTON_FORMAT(11, "LEAVE STUFFED", M)
			AdjustStatNum(GLUTT,1)
			return
		if(5)
			BUTTON_FORMAT(6, "MORE", M)
			AdjustStatNum(GLUTT,1)
			return
		if(6)
			BUTTON_FORMAT(7, "MORE", M)
			AdjustStatNum(GLUTT,1)
			AdjustHitPoint(-20)
			return
		if(7)
			BUTTON_FORMAT(8, "MORE", M)
			AdjustStatNum(GLUTT,1)
			AdjustHitPoint(-40)
			return
		if(8)
			BUTTON_FORMAT(9, "MORE", M)
			AdjustStatNum(GLUTT,1)
			AdjustHitPoint(-80)
		if(9)
			AdjustStatNum(GLUTT,1)
			AdjustHitPoint(-gamer.virtual_integrity)
		if(10)
			AdjustStatNum(SLOTH,1)
			AdjustStatNum(GLUTT,-1)

	return ..()
