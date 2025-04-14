/**
	*Yup. You know what this is. This is my first swing at making an event. -Detah
	*/
/datum/adventure_event/todd_damn_it
	name = "A cart somewhere cold"
	desc = "A BUMPY ROAD, A DEAD END"
	adventure_cords = list(
	"You jolt awake, you're taken down the bumpy streets on a cart.<br>\
	\"Hey, you.\" a defiant man with bound hands addresses you \"You're finally awake.\"<br>\
	The cart is pulled into a small village, where soldiers glare at you.<br>\
	You aren't quite sure where you are, or who these people are. You only know one thing.<br>\
	<br>\
	You are being lead to your death.",

	"You refuse to just sit and wait for your death, at the first opportunity you headbutt a guard and bolt away from the cart!<br>\
	Just as you're about to round the nearest corner you feel a sharp pain through your back. You cough up blood before collapsing to the ground.<br>\
	<br>\
	You awaken with a start curled up in a ball in an alley. What was that about?",

	"If you're going to face your death, it'll be with dignity.<br>\
	A guard brings you to the headsman's block and a hard faced woman forces you to kneel.<br>\
	A wave of calm overcomes you as you close your eyes and accept fate.<br>\
	The last thing you feel is the headsman's axe on your neck.<br>\
	<br>\
	You awaken with a start curled up in a ball in an alley. What was that about?",
	)

/datum/adventure_event/todd_damn_it/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "FLEE FOR YOUR LIFE", M)
			BUTTON_FORMAT(3, "ACCEPT FATE", M)
			return
		if(2)
			AdjustStatNum(WRATH_STAT,1)
			AdjustStatNum(SLOTH_STAT,-1)
		if(3)
			AdjustStatNum(PRIDE_STAT,1)
			AdjustStatNum(GLUTT_STAT,-1)
	return ..()

