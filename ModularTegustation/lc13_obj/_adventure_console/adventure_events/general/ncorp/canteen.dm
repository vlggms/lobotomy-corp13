/datum/adventure_event/ncorp_events/canteen
	name = "N-Corporation: Canteen"
	desc = "YOU SEE A FAINT LIGHT"
	adventure_cords = list(
	"You take the only empty seat in the canteen next to some kleinhammers.<br>\
	'You ever try the barley soup?' <br>\
	The young man to your left looks your way, offering you a bowl.<br>\
	It's not very often that you get to mess with the others.<br>\
	'Here, I got an extra serving for you!'",

	"You take a taste of the soup, and feel heartier.<br>\
	You smile at the young man. <br>\
	'What did I tell you, it's my favorite!'<br>\
	He grins at you.",

	"You decline.<br>\
	He looks a little sad, but shrugs. 'More for me.'<br>\
	You decide to take on the ground mystery meat. Taking it with your fork,<br>\
	It looks and smells very unappetizing. But you are hungry.<br>\
	you do feel better after chowing down.",
	)

/datum/adventure_event/ncorp_events/canteen/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "EAT THE SOUP", M)
			BUTTON_FORMAT(3, "EAT THE MYSTERY MEAT", M)
			return
		if(2)
			AdjustHitPoint(10)
			AdjustStatNum(ENVY_STAT,1) // Envy is charisma and camraderie
		if(3)
			AdjustHitPoint(50)
			AdjustStatNum(RAND_STAT,-1)
	return ..()
