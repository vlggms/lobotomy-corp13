/**Red is the counterpart to Wolf (obviously), about the cycle of violence.
	*While the wolf is about how something can be turned into a monster by treating it as it will,
	*Red is the obsession that ensures that someone will be turned into that monster.
	*This characterization is a bit different then that in LC13 currently, so let me know if I should rewrite it.
	*-ML
	*/
/datum/adventure_event/red_riding_hood_mercenary
	name = "Little Red Riding Hooded Mercenary"
	description = "YOU SEE A PERSON IN RED RAGS"
	required_abno = /mob/living/simple_animal/abnormality/waw/red_riding_hood_mercenary
	adventure_cords = list(
		"You enter a home filled with pictures of the same beast<br>\
		plastered across the walls, each one ripped or torn or shot or covered.<br>\
		The only other things in the room are a set of weapons,<br>\
		and a person dressed in crimson rags.<br>\
		She looks at you, her face shadowed by her hood.<br>\
		\"Can you show me where that Bastard is?\"",

		"\"Where!\" The girl exclaims.<br>\
		As they hurry you along you explain where to go.<br>\
		They don’t bother to thank you, grabbing their weapons and charging off.<br>\
		There is no way anything deserves the horrors she will commit.",

		"The girl sighs, taking out her gun.<br>\
		She points it at you, and fires.<br>\
		\"No one is killing that mutt but me!\"<br>\
		Pain shoots through your leg as she approaches.<br>\
		\"Now tell me where the fuck that bastard is.\"<br>\
		Silently you point somewhere and they charge off.<br>\
		Taking the opportunity you escape before they come back.",

		"\"Then why are you here?\"",
	)

/datum/adventure_event/red_riding_hood_mercenary/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "I CAN SHOW YOU", M)
			BUTTON_FORMAT(3, "I CAN BRING YOU THE WOLF", M)
			BUTTON_FORMAT(4, "I CAN'T", M)
			return
		if(2)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_EASY)
		if(3)
			AdjustHealth(-40)
		if(4)
	return..()
