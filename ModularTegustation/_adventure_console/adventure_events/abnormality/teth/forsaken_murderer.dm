/**
 * This event is mostly based on what i THINK the creators of forsaken murderer are trying to say.
 * Experimentation on murderers that leave them lobotomized shadows is just inherently selfish
 * and provides only a oppertunity to do the unspeakable to others without a hint of guilt?
 * Or that its messed up to see profit from the existence of murderers?
 * Who knows? -IP
 */
/datum/adventure_event/murderer
	name = "The Forsaken Killer"
	desc = "YOU SEE SOMEONE STRAPPED TO A TABLE"
	require_abno = /mob/living/simple_animal/hostile/abnormality/forsaken_murderer
	adventure_cords = list(
		"Before you is a emaciated man strapped to a surgical bed.<br>\
		Next to him on a metal table are documents of his crimes \
		and a medical diagram indicating the location of something of value within his brain.",

		"Ability Challenge",

		"Within his brain you find what you wanted.<br>\
		You walk away leaving a wound that will never heal.<br>\
		Its only fitting his wretched life was of some use to you.",

		"You glance at the mans eyes.<br>\
		You dont see fear or sadness but... contempt?<br>\
		While your distracted looking into the mans eyes, he then headbutts you hard enough to knock you off your feet.<br>\
		You find youself somewhere else as you regain your footing.",

		"As you turn to leave the monsterous man strapped to his table you hear the muffled screams and tearing of flesh.<br>\
		You look back at the fading scene of a shadowy woman tearing out something from the mans brain.",
	)

/datum/adventure_event/murderer/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "BUTCHER THE MANS BRAIN", M)
			BUTTON_FORMAT(3, "LEAVE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "SLOTH", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(3)
			AdjustStatNum(WRATH_STAT, 3)
		if(4)
			AdjustHitPoint(-5)
	. = ..()
