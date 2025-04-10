/**
	*I wanted you to feel a little evil in this one.
	*/
/datum/adventure_event/ncorp_events/execution
	name = "N-Corporation: Execution"
	desc = "A LONE HERETIC"
	adventure_cords = list(
	"You feel your heart pumping as you chase the heretic through the alleyways of this accursed town. <br>\
	Its eyes glow green as you rush after it, and you can't help but smile. <br>\
	It's totally exhausted, tripping over its own legs, allowing you to advance upon it",

	"You grab it by the collar of its neck, lifting this once-human off the ground. <br>\
	It's head entirely transformed from flesh to steel. <br>\
	'Please.' It pleads with you. 'Don't kill me, I beg of you'<br>\
	While it struggles in your grip, you cast your helmet aside and stare into it's eyes.",

	"Raising your nail, the heretic starts to struggle harder. <br>\
	Plunging your nail through the heretic's chest, you feel righteous justice. <br>\
	This is what they deserve.",

	"Raising your hammer, they begin to claw at your armor in vain. <br>\
	You cast them onto their back and bring your hammer down onto the heretic's body, again and again. <br>\
	Smashing the body until it is scrap. <br>\
	You notice a leather wallet in the scrap pile. Its owner no longer needs it.",

	"You decide not to draw a weapon, and instead decide to take matters into your own hands. <br>\
	Pushing it to the ground and mounting its body, you apply force to its juggular with all of your might. <br>\
	You apply force. <br>\
	Its body struggles to push you off. <br>\
	You apply force. <br>\
	It gasps for air. <br>\
	You apply force. <br>\
	It makes a noise. <br>\
	You apply force. <br>\
	You apply force. <br>\
	You apply force.",

	//I spent a LOT of work in this event dehumanizing the heretic, only referring to them as "it" and "The heretic" this entire event.
	"You drop her, and she falls onto her bottom. <br>\
	Her soulless glowing green eyes stare up at you silently for a moment, as time stands still.<br>\
	She scrambles to her feet and runs away as fast as she can.<br>\
	You simply watch her go.",
	)

/datum/adventure_event/ncorp_events/execution/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "PICK THEM UP.", M)
			return
		if(2)
			BUTTON_FORMAT(3, "RAISE YOUR NAIL.", M)
			BUTTON_FORMAT(4, "RAISE YOUR HAMMER.", M)
			BUTTON_FORMAT(5, "SQUEEZE THEIR NECK.", M)
			BUTTON_FORMAT(6, "DROP THEM.", M)	//Coward.
			return
		if(3)
			AdjustStatNum(PRIDE_STAT,2)
		if(4)
			AdjustCurrency(5)
		if(5)
			AdjustStatNum(WRATH_STAT,2)
		if(6)		//Doing good is the worst thing to do.
			AdjustStatNum(WRATH_STAT,-2)
			AdjustStatNum(PRIDE_STAT,-2)

	return ..()
