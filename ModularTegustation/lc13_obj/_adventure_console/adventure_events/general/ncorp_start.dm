/datum/adventure_event/n_corp_start
	name = "N-Corporation Encounter"
	desc = "THE SOUND OF METAL CLANKING"
	adventure_cords = list(
		"You find yourself approaching a small town.<br>\
		Someone in armor stops you along the road.<br>\
		'Halt. Go no further.' The woman inside says to you.",

		"'This town is currently being purged by Nagel und Hammer. Official N-Corporation Business.' <br>\
		She looks serious.",

		"You have no idea what they were doing there, but none of it is your business.",

		"'Please leave.'<br>\
		She insists that you leave. But people could get hurt. They need you!",

		"She sighs. 'If it must be done.'",

		"She sighs. 'Please, come with me.' <br>\
		'And here, eat this.' She passes you a little can of bread. <br>\
		You pull the tab to open and eat it. <br>\ <br>\
		SOMETHING HAS CHANGED INSIDE YOU.",
		)

/datum/adventure_event/n_corp_start/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "INQUIRE FURTHER", M)
			BUTTON_FORMAT(3, "LEAVE POSTHASTE", M)
			return
		if(2)
			BUTTON_FORMAT(4, "AN EXPLOSION IN THE DISTANCE", M)
			return
		if(4)
			BUTTON_FORMAT(5, "TAKE ACTION AND ASSAULT N-CORP", M)
			BUTTON_FORMAT(6, "ASK IF SHE NEEDS ASSISTANCE", M)
			return
		if(5)
			CauseBattle(
				"N-Corporation Klienhammer: An armored goon wielding a nail and a hammer.",
				MON_DAMAGE_NORMAL,
				MON_HP_RAND_NORMAL,
			)
			gamer.travel_mode = ADVENTURE_MODE_BATTLE

		if(6)
			RewardKey("NAGEL INITIATION")
			//Event cannot be encountered again if you get the invitation.
			spend_event = TRUE
	return ..()
