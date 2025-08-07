/datum/adventure_event/skin_woman
	name = "Art Gallery"
	desc = "YOU SMELL ACRYLIC"
	adventure_cords = list(
		"You wake up on a bench in an art gallery, completely alone. <br>\
		Your back hurts.<br>\
		In the distance you hear a melody, the soft strings echoing in the halls.<br>\
		You take time to look around the gallery.",

		"A painting catches your eye. <br>\
		It is the portrait of a woman, her face completely skinned. <br>\
		She has long black hair, and her black, soulless eyes are staring at you. <br>\
		The music quiets to a stop as you shudder. <br>\
		You get the feeling of someone's gaze on your back. <br>\
		Turning around, you see shadows moving in the hallway.",
		//success in coinflip, High Sloth

		"You take some time to inspect a beautiful watercolor of the sea.  <br>\
		Some time to enjoy an excellent sculpture of the human form, <br>\
		And some time to enjoy a nap on the bench again.",		//Fail in coinflip, Low Sloth
		)

/datum/adventure_event/skin_woman/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT), "GLUTTONY", M)
			return
		if(2)
			RewardKey("SHE KNOWS")
			spend_event = TRUE
		if(3)
			AdjustStatNum(GLUTT_STAT,2)
	return ..()
