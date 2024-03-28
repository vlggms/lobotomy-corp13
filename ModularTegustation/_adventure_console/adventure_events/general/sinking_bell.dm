/datum/adventure_event/sinking_bell
	name = "Sinking Bell"
	desc = "IT IS COLD AND MOIST"
	adventure_cords = list(
		"You find yourself inside some metal container chest deep in water.<br>\
		There is no floor to the contraption leaving you wading above a pitch black abyss.",

		"You let yourself get dragged below the water.<br>\
		It feels like a relief, a cure to your exhaustion.<br>\
		Then the pain starts.<br>\
		Your lungs burn as everything around you starts to squeeze.<br>\
		Wherever you are is trying to push you out but that sinking feeling pulls you ever deeper.<br>\
		Desperately trying to get back to the surface you claw at the formless walls that wrap your arms until they go numb.<br>\
		Your eyes are screaming,<br>\
		your lungs are screaming,<br>\
		your body is screaming,<br>\
		everything inside you is screaming.",

		"The next few minutes are a frenzied panic as the light grows dimmer.<br>\
		There is nowhere left to crawl.<br>\
		The light is gone and your chest sinks like lead into the darkness.",

		"You wash back onto shore wounded but alive.<br>\
		You know you will be back here again.<br>\
		You return to the path and continue your journey.",

		"You see a bell that is out of reach and an inscription below two eye holes that only peer out into more darkness.<br>\
		\"FOR THAT WHICH WILL PROTECT ME I THANK YOU\"<br>\
		\"RING THE BELL AND I WILL BE THERE SOON\".",

		"A feeling appears as you reach for the bell.<br>\
		It feels like a lead ball in your chest pulling you down to the darkness below.",

		"You keep reaching for the bell.<br>\
		It is a exhuasting effort and sometimes you find yourself slipping below the silver line of the water.<br>\
		The feeling in your chest grows in weight as you reach out.",

		"The water washes over your face as you use the last of your effort.<br>\
		You hear the bell and then go limp.<br>\
		You slowly sink into the darkness.",

		"The silence is comforting as you are adrift above the darkness.<br>\
		The dull whirring of machinery is your lulluby as you feel something push you back up from below.<br>\
		The pressure of the water slowly fades as your broken body is pushed up to the water.<br>\
		When you awaken your on the shore unharmed.<br>\
		As you look back you see a metal container with two eyes slowly sink below the waves.",
		)

/datum/adventure_event/sinking_bell/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(5, "CHECK FOR ANY EXITS", M)
			return
		if(2)
			BUTTON_FORMAT(3, "HELP ME", M)
			return
		if(3)
			BUTTON_FORMAT(4, "PLEASE COME BACK", M)
			return
		if(4)
			AdjustHitPoint(-20)
		if(5)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(6, "REACH FOR THE BELL", M)
			return
		if(6)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(7, "REACH FOR THE BELL", M)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			return
		if(7)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(8, "RING THE BELL", M)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			BUTTON_FORMAT(2, "SURRENDER TO THE PULL", M)
			return
		if(8)
			BUTTON_FORMAT(9, "REST", M)
			return
	. = ..()
