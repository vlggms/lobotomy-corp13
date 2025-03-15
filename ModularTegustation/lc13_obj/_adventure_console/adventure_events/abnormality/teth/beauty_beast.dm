/**
	*Currently the main idea is the actual action itself.
	*There’s some more symbolism with that, but it’s kind of ignored unless this get’s rewritten later.
	*-ML
	*/
/datum/adventure_event/beauty_beast
	name = "Beauty and the Beast"
	desc = "YOU SEE AN ABOMINATION"
	require_abno = /mob/living/simple_animal/hostile/abnormality/beauty
	adventure_cords = list(
		"You enter a room with stained glass, stone walls, arching ceilings, and a small knife next to the door.<br>\
		Light streams in through the windows forming ornate patterns across the floor<br>\
		all of it serving to frame an abomination.<br>\
		It has countless eyes, each rolling in agony, its body twisted so its<br>\
		Insectoid limbs bend out at angles not fitting it’s beastly form<br>\
		and a human like leg sticks out next to one far more animile like.<br>\
		Open wounds pulse on it’s side, pus and blood leaking out across wiry fur.<br>\
		It turns towards you, mandibles clicking in something somehow resembling human speech.<br>\
		\"Free me from my curse, kill me.\"",

		"\"Thank you!\" It groans as your plunge the knife into oozing flesh.<br>\
		It convulses, once, twice, and then collapses.<br>\
		You turn to leave, and trip.<br>\
		Your leg twists, snapping your foot as it elongates and thin gristly hair springs forth<br>\
		as your skin thickens into a shell of chitin.<br>\
		Your body bloats up, your bones ripping out of flesh until it grows like a tumor to meet your new body shape,<br>\
		your hand fuses together into a grotesque foot, while the other mutates into a paw.<br>\
		Trying to scream from the multitude of eyes blooming from your face makes your mandibles click.<br>\
		You are cursed, and want the relese of death.",

		"You look at the knife sitting at the entry way.<br>\
		The monster looks at it longingly.<br>\
		You do not pick it up, instead turning to leave.<br>\
		\"Please!\" It cries after you, \"Save me!\"<br>\
		But that isn’t your job, someone else can do that.",
	)

/datum/adventure_event/beauty_beast/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "Kill it", M)
			BUTTON_FORMAT(3, "Let it suffer", M)
			return
		if(2)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
		if(3)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_EASY)
	return..()
