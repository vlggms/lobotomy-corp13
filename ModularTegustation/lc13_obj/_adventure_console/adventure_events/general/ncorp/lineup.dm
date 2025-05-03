/datum/adventure_event/ncorp_events/rollcall
	name = "N-Corporation: Rollcall"
	desc = "THE SOUND OF FIRST CALL"
	adventure_cords = list(
	"The horns are sounding, the One Who Grips must need you. <br>\
	Rushing to the sound of the horn, and messily putting your helmet on, you get in line.",

	"You make sure your prayers are properly written and your seals are properly affixed to your armor.  <br>\
	It's taken a long time working your way up in Nagel und Hammer. You have been graced with the rank of a senior.  <br>\
	You won't blow all of your hard work. <br>\
	'MITTLEHAMMERS ATTENTION!' a voice booms far ahead of you. <br>\
	...and you clank to attention.",

	"You are but a humble kleinhammer, new to the order and full of potential.  <br>\
	You spend so long reading your scriptures, eating the right food, and sparring with your mates.<br>\
	Your efforts are beginning to pay off. <br>\
	'KLEINHAMMERS ATTENTION!' a voice booms far ahead of you. <br>\
	...and you clank to attention.",
	)

/datum/adventure_event/ncorp_events/rollcall/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "YOU ARE A MITTLEHAMMER.", M)
			BUTTON_FORMAT(3, "YOU ARE A KLEINHAMMER.", M)
			return
		if(2)
			AdjustStatNum(PRIDE_STAT,1)
			AdjustStatNum(WRATH_STAT,1)
		if(3)
			AdjustStatNum(RAND_STAT,1)
			AdjustStatNum(RAND_STAT,1)
	return ..()
