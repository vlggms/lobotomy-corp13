/datum/adventure_event/old_lady
	name = "The Lonely Lady"
	desc = "YOU HEAR THE CREAKING OF A ROCKING CHAIR"
	require_abno = /mob/living/simple_animal/hostile/abnormality/old_lady
	adventure_cords = list(
		"The doorframe buckles and splinters as you enter the room. You follow the \
			sound of creaking and see her. Her eyes are glazed over, sunken, and grey. \
			Her head tilts up as she asks if your ready to hear her story.",
		"The unease grows as you sit down before the woman. She slowly begins \
			to tell you a story. The story begins with her recounting some incomprehensible \
			events. Halfway through the story you feel burning bleed throughout your brain. \
			As you writhe on the ground you catch a small incomprehensible \
			part of the story before bolting out of the room. As the doorway fades away \
			you see her smiling at the spot where you sat.",
		"Ability Challenge",
		"As you leave her expression changes to a blank sadness. You feel the room decay \
			and the floor buckles with each step. You manage to dive out of the doorway as \
			the room is completely consumed in some vile gas.",
		"You feel a foul gas enter your lungs. The gas slowly manifests with each step you \
			attempt. It tastes of peeling wallpaper and threatens you with a eternity in \
			this room. With one last attempt you weakly dive out of the doorway."
		)

/datum/adventure_event/old_lady/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2,"STAY AND LISTEN", M)
			BUTTON_FORMAT(3,"LEAVE", M)
			return
		if(2)
			AdjustHitPoint(-15)
			AdjustStatNum(RAND_STAT,3)
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT),"GLOOM", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLUTT_STAT),"GLUTT", M)
			. += CoinFlipping(M)
			return
		if(5)
			AdjustHitPoint(-5)
	. = ..()
