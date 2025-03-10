/**
	*As far as I’m aware Meat Lantern is mainly based on the anglerfish and related concepts as a
	*‘beware of how things look at first glance’ though it does it in a way that is more focused on how it endangers everyone then just how it affects the individual.
	*-ML
	*/
/datum/adventure_event/meat_lantern
	name = "Meat Lantern"
	desc = "YOU SEE A FLOWER ON A PATH"
	require_abno = /mob/living/simple_animal/hostile/abnormality/meat_lantern
	adventure_cords = list(
		"A thin path snakes through a forest full oflowering trees.<br>\
		White flowers bloom on every branch, breaking away in small bunches to float down and settle on the trail.<br>\
		No animals can be heard, leaving you surrounded by an eerie silence<br>\
		broken only by the whispers of wind through the petals and leaves.<br>\
		All of it centered around a single flower in the center of the path,<br>\
		a glistening fruit poking out from between it's bunches.<br>\
		It’s radiant, a beautiful citrusy green, inviting you to come and eat it.",

		"At the moment nothing would hit the spot better then some fruity goodness.<br>\
		So you step forward, next to the flower, and pick the fruit.<br>\
		It doesn’t come off.<br>\
		In fact, it doesn't feel like fruit.<br>\
		Instead it’s warm and fleshy<br>\
		and the the ground is rumbling beneath you.<br>\
		SNAP",

		"The fruit does look tempting.<br>\
		But do you really want to be eating something that you found in the woods?<br>\
		For all you know it could be poisonous.<br>\
		As you think to yourself, the twittering a bird fills the air.<br>\
		It had the same thoughts as you, but it doesn’t wait, flying down to peck at the fruiting body.<br>\
		SNAP<br>\
		In a moment a giant mouth erupts from the ground swallowing the bird whole.<br>\
		It’s a good thing you waited.",

		"Something isn’t right here.<br>\
		Aren’t fruits usually formed from flowers?<br>\
		Not that it’s impossible for a plant to have fruits and flowers at the same time.<br>\
		But this plant is the only one to have developed a fruit.<br>\
		Trying to eat this might not be the best idea.<br>\
		With that understanding you turn away<br>\
		leaving the fruit to continue trying to draw others in.",
	)
/datum/adventure_event/meat_lantern/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "Eat the fruit", M)
			BUTTON_FORMAT(3, "Wait a bit", M)
			BUTTON_FORMAT(4, "Something's off", M)
			return
		if(2)
			AdjustStatNum(GLUTT_STAT, ADV_EVENT_STAT_EASY)
			AdjustHitPoint(-40)
		if(3)
			AdjustStatNum(SLOTH_STAT, ADV_EVENT_STAT_EASY)
	return..()
