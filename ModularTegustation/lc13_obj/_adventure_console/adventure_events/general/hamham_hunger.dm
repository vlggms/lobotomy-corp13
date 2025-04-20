/**
	*Shillin' Hamhampangpang, as you should.
	*/
/datum/adventure_event/hamham_hunger
	name = "A delightful Cafe"
	desc = "THE MOST MOUTH-WATERING SMELL"
	adventure_cords = list(
		"Hungry, you follow your nose through the streets to a little cafe near a quaint fountain. <br>\
		It isn't long before you're seated at a table, a menu in hand, and your mouth watering. <br>\
		A cheerful server comes to take your order.",

		"\"Great, I'll have that right out for you!\" the server says with a smile. <br>\
		Minutes pass before they return with your sandwich. <br>\
		The fluffy bread constrasts with the crispy hashbowns and bacon, complemented by the richness of the egg yolk and the saltiness of the ham. <br>\
		What an amazing snack! You should tell everyone about this place!",

		"\"Great, I'll have that right out for you!\" the server says with a smile. <br>\
		Minutes pass before they return with your latte. <br>\
		The bitterness of the cacao and the coffee contrasts with the sweetness of the caramel and the creaminess of the milk. <br>\
		What an amazing drink! You should tell everyone about this place!",

		"\"Great, I'll have that right out for you!\" the server says with a smile. <br>\
		Minutes pass before they return with your salad. <br>\
		The rich, creamy, cheese practically melts on your tongue as it mingles with the bright tangerines and the sweet figs. <br>\
		What an amazing snack! You should tell everyone about this place!",

		"\"Great, I'll have that right out for you!\" the server says with a smile. <br>\
		Minutes pass before they return with your wine. <br>\
		The notes of dark fruit and coffee complement the velvety mouthfeel of the wine as it dances across your pallet. <br>\
		What an amazing drink! You should tell everyone about this place!",

		"Your stomach rumbles as you force yourself to stand, The cheerful server's smile faltering for just a moment. <br>\
		You step out into the streets, looking over your shoulder towards the cafe. <br>\
		Everything looked so tasty, you're regretting not getting any of the delicous and affordable menu items. <br>\
		It was definitely a mistake, but oh well...",
	)

/datum/adventure_event/hamham_hunger/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			/*These are all actual menu items from Hampang Kitchen. */
			BUTTON_FORMAT(2, "ORDER HAM AND BACON SANDWICH", M)
			BUTTON_FORMAT(3, "ORDER CARAMEL COCO LATTE", M)
			BUTTON_FORMAT(4, "ORDER HONEY CHEESE SALAD", M)
			BUTTON_FORMAT(5, "ORDER HAMPANG BLACK WINE", M)
			BUTTON_FORMAT(6, "ORDER NOTHING AND LEAVE", M)
			return
		if(2)
			AdjustCurrency(-1)
			AdjustHitPoint(30)
			AdjustStatNum(GLUTT_STAT,1)
		if(3)
			AdjustCurrency(-1)
			AdjustHitPoint(30)
			AdjustStatNum(ENVY_STAT,1)
		if(4)
			AdjustCurrency(-1)
			AdjustHitPoint(30)
			AdjustStatNum(WRATH_STAT,1)
		if(5)
			AdjustCurrency(-1)
			AdjustHitPoint(30)
			AdjustStatNum(PRIDE_STAT,1)
		if(6)
			AdjustStatNum(GLUTT_STAT,-1)
	return ..()
