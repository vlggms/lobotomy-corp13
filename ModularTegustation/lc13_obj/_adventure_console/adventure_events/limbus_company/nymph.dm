/datum/adventure_event/nymph
	name = "Mirror Shard:Nymph"
	desc = "THE SMELL OF RANCID IRON AND METAL TAPPING"
	adventure_cords = list(
		"It gives blood to those who need it.<br>\
		The only blood it has to give is its own.<br>\
		Even those who don’t need a transfusion<br>\
		are bled dry with scissors, forced to accept.<br>\
		Thus, its road is filled with receivers that need blood.",

		"It plucked a blood bag and handed it to us.<br>\
		Seeing us accept it,<br>\
		it quickly hung an empty one in its place.<br>\
		The bag fills with blood at an uncanny pace.<br>\
		Having fulfilled its duty, it strolled past us.",

		"Its endless donation of blood<br>\
		was a pitiful sight.<br>\
		We decided to share some of our own.<br>\
		<b>GIGIGIH.</b><br>\
		When you expressed your willingness to donate,<br>\
		it cried as if to signal its displeasure.<br>\
		Then, it raised a pair of scissors,<br>\
		chopping off the arm of the one who volunteered their blood.<br>\
		<b>GIGIGIH.</b><br>\
		Then, it pulled out one of the tubes connected to its body,<br>\
		plugging it into the cut wound.<br>\
		An arm soon grew back.<br>\
		The spilled blood stayed on the floor.",

		)

/datum/adventure_event/nymph/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "ACCEPT BLOOD", M)
			BUTTON_FORMAT(3, "DONATE BLOOD", M)
			return
		if(2)
			AdjustHitPoint(15)
		if(3)
			AdjustHitPoint(-10)

	return ..()
