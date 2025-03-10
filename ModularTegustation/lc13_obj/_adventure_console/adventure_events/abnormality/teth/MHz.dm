/**
	*Thought Process: 1.76 MHV being something that tries to get people to remember also appears to attempt to reenact whatever it is that it wants people to remember.
	*However what exactly it is remains unclear, some of the pictures from its original version show other abnormalities leading to some interpretations of what it could have been,
	*however for the event I think it’s better to not lean into those and leave the very open ended nature of what might have happened as is.
	*-ML
	*/

/datum/adventure_event/MHz
	name = "1.76 MHz"
	desc = "YOU HEAR STATIC"
	require_abno = /mob/living/simple_animal/hostile/abnormality/mhz
	adventure_cords = list(
		"There is noise.<br>\
		Static<br>\
		Crackling of something trying to reach you.<br>\
		Cawing of seagulls<br>\
		A voice, calling for help.<br>\
		The creaking of wood and rope.<br>\
		Silence",

		"The silence continues, then slowly the air fills with smoke.<br>\
		It chokes you, fills your head with a searing heat.<br>\
		Until you see nothing but red<br>\
		<br>\
		You come to with new scars and blood on your fists.<br>\
		What the hell happened?",

		"Despite the radio’s distortions, you know these sounds.<br>\
		Long ago you heard them,<br>\
		It’s only a distant memory now<br>\
		But<br>\
		You can never forget that day.<br>\
		It must never be forgotten",

		"You turn around and leave.<br>\
		Letting the nonsense fill the air.",
	)

/datum/adventure_event/MHz/EventChoiceFormat (obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "Continue Listening", M)
			BUTTON_FORMAT(3, "You can't forget these sounds", M)
			BUTTON_FORMAT(4, "Show's over, leave", M)
			return
		if(2)
			AdjustHitPoint(-5)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY)
		if(3)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
	return..()
