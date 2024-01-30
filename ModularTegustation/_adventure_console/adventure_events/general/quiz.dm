/datum/adventure_event/quiz
	name = "Quiz Time"
	desc = "YOU HEAR AN ANNOYING VOICE"
	adventure_cords = list(
		"As you step through the threshold a figure starts to take form as they run towards you yelling \"QUIZ TIME!\".<br>\
		They have no face but you can infer from their outfit that they are some kind of fixer.<br>\
		The quiz fixer stops and stares at you with their eyeless face.",

		"A simple push is all it takes to send them falling silently back into the void.<br>\
		You watch their body as the darkness consumes them.",

		"\"LET US SEE HOW MUCH YOU KNOW YOUR CITY!\"<br>\
		The figure then pulls a piece of paper out of their pocket and unfolds it<br>\
		\"SWEEPER FLUID IS PATENTED BY ONE PERSON AND ONE PERSON ONLY. WHO IS IT?\"",

		"\"YES THAT DOES SEEM TO BE WRITTEN HERE!\"<br>\
		The figure says as they hand you some strange object.<br>\
		\"THANK YOU FOR ANSWERING RUN ALONG NOW.\"",

		"They look down at their card and then back up at you.<br>\
		\"IM SORRY BUT THAT IS NOT WRITTEN HERE, GOODBYE\"<br>\
		They then start violently growing blue metal out of their face.",
		)

/datum/adventure_event/quiz/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "PUSH HER INTO THE VOID", M)
			BUTTON_FORMAT(3, "AGREE TO THE QUIZ", M)
			return
		if(3)
			BUTTON_FORMAT(4, "THE HEAD OF A CORP", M)
			BUTTON_FORMAT(5, "Z CORPORATION", M)
			BUTTON_FORMAT(5, "THE SWEEPER QUEEN", M)
			BUTTON_FORMAT(5, "K CORPORATION", M)
			BUTTON_FORMAT(5, "NONE CAN PATENT GOO", M)
			return
		if(4)
			AdjustStatNum(PRIDE_STAT, 1)
		if(5)
			CauseBattle(
				"Speculative Amalagam Error:Some imperfect mix of a fixer and a sweeper. The differing physiology of a sweeper and a human causes them to violently ooze red fluid from where the sweeper parts end and the human parts begin.",
				"1d10",
				MON_HP_RAND_EASY,
			)
	. = ..()
