/**
	*The first N-Corp Event. Simple, you eat the bread and you get some health and lose a stat.
	*/
/datum/adventure_event/ncorp_events
	name = "N-Corporation: Bread"
	desc = "A CAN OF BREAD"
	adventure_cords = list(
	"'Breakfast time.' A can of bread is tossed your way, and you catch it.<br>\
	You actually rather like the bread.<br>\
	Despite being sent in a can, you like it's rather sweet taste.<br>\
	When you mess with the others in the canteen, you enjoy it with a bit of jam.<br>\
	'Eat up, we gotta hurry.'",

	"You open up the can and eat. However, you can't help but feel empty.",
	)
	event_locks = "NAGEL INITIATION"

/datum/adventure_event/ncorp_events/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "EAT THE BREAD", M)
			return
		if(2)
			AdjustHitPoint(30)
			AdjustStatNum(RAND_STAT,-1)
	return ..()
