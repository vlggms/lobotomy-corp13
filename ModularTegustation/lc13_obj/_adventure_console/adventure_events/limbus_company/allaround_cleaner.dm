/datum/adventure_event/allaround_cleaner
	name = "Mirror Shard:All Around Cleaner"
	desc = "YOU HEAR A ROBOTIC VOICE AND SMELL SANITIZER"
	adventure_cords = list(
		"<b>I wipe everything.<br>\
		Cleaning is enjoyable.<br>\
		I like to be the same as others.<br>\
		...<br>\
		I am frankly troubled.<br>\
		The model next to mine boasted that it has multiple parts that others dont.<br>\
		Is that what makes one special?<br>\
		Am I special the way I am?<b>",

		"<b>No. I am not special.</b><br>\
		Disregarding the answer, it gives a stern reply.<br>\
		<b>I will keep living an ordinary life, the same as now, just as assigned to me.</b><br>\
		Then it disappeared into the dark, spinning at a surprising speed.",

		"<b>Am I not special, not special, not special?</b><br>\
		After giving a lagged reply, it suddenly began tearing off all the cleaning gadgets from its body and crashing into walls.<br>\
		It rubbed its body on other objects while sparks flew off as if it was trying to attach things to it.<br>\
		It only stopped after a while.<br>\
		<b>Maybe I wanted to be special.</b><br>\
		It had already disappeared when the empty voice seemed to reach the ears.",

		)

/datum/adventure_event/allaround_cleaner/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "YOU ARE SPECIAL", M)
			BUTTON_FORMAT(3, "YOU ARE NOT SPECIAL", M)
			return
		if(3)
			AdjustStatNum(GLOOM_STAT, ADV_EVENT_STAT_EASY)

	return ..()
