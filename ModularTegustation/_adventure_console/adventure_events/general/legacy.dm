//Refrence to a shot from the early access trailer to lobotomy corp where a cowering agent is surrounded by a void of monsters.
/datum/adventure_event/legacy
	name = "The Falling World"
	desc = "THIS PATH IS STREWN WITH DEBRIS"
	adventure_cords = list(
		"A twisting green hue pours out from a door.<br>\
		Silhouetted against that light is a humanoid figure.<br>\
		<br>The figure grabs their head and cowers as the edges of the room crumble away.<br>\
		<br>Encircling the doorway at the edge of your visions are the writhing outline of monsters.",

		//Not great story choices i know -IP
		"You remain silent as the shadows obscure your view of the figure",

		"The figure looks towards you, and so do the shadows.<br>\
		You are not alone.",
	)

/datum/adventure_event/legacy/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "HIDE", M)
			BUTTON_FORMAT(3, "REACH OUT", M)
			return
		if(2)
			AdjustStatNum(SLOTH_STAT,1)
		if(3)
			//I just love how ominous this sound effect is.
			playsound(get_turf(H), 'sound/effects/creak1.ogg', 20, FALSE)
			AdjustStatNum(GLOOM_STAT,1)
	. = ..()
