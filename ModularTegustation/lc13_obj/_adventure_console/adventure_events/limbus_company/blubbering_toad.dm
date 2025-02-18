/datum/adventure_event/blubbering_toad
	name = "Mirror Shard:Blubbering Toad"
	desc = "YOU HEAR A SAD CROOHOO"
	adventure_cords = list(
		"<b>Croohoo, croohoo, croohoo.</b><br>\
		A giant toad cries inside a cave.<br>\
		Patches of dark blue resin cover the cave.<br>\
		This resin is like gloom.<br>\
		A sap of gloom, not quite like tears or sadness.<br>\
		The toad holds this resin.",

		"Ability Challenge",

		"<b>Croohic, croohoo.</b><br>\
		The toad’s cry is dull and heavy.<br>\
		It doesn’t seem to have understood what it heard.<br>\
		After crying like that a few more times,<br>\
		it hopped away from its spot.<br>\
		All that’s left is the sticky blue resin.",

		"<b>Cruh-huh, croohoo.</b><br>\
		The toad makes a different noise as if to answer.<br>\
		It sounds like an affirmative reply.<br>\
		It extracts its long blue tongue,<br>\
		snatching a person from our group.<br>\
		Sometime later, they walked back out of its mouth.<br>\
		They seemed drenched<br>\
		in moisture, or gloom.",

		"An indeterminate amount of time passes.<br>\
		As you waited for the toad to finish its cries,<br>\
		it gazed into us, closing and opening its eyelids slowly.<br>\
		With a quick, slick sound,<br>\
		a long blue tongue<br>\
		popped out towards us.<br>\
		An eyeball belonging to the toad<br>\
		was on its tongue.<br>\
		When we picked it up,<br>\
		it blinked its other eye at us<br>\
		before going on its way.<br>\
		Was that its thanks for lending an ear?"
		)

/datum/adventure_event/blubbering_toad/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "MIMIC THE CRY", M)
			BUTTON_FORMAT(5, "SIT AND WAIT", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "GLOOM", M)
			. += CoinFlipping(M)
			return
		if(4)
			AdjustHitPoint(5)
		if(5)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_NORMAL)

	return ..()
