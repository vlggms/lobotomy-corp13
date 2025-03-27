/**
	*This one is based on a legend about how cherry blossoms grow more beautiful when they are planted on top of corpses,
	*but has some more stuff about how people are willing to enjoy bounty especially when they are ignorant to the actual costs.
	*-ML
	*/
/datum/adventure_event/cherry_blossoms
	name = "Grave of Cherry Blossoms"
	desc = "YOU SEE A BLOOMING TREE"
	require_abno = /mob/living/simple_animal/hostile/abnormality/cherry_blossoms
	adventure_cords = list(
		"You come across a beautiful scene of a tree on a hill.<br>\
		The sky is clear, letting the sun illuminate everything.<br>\
		Especially the vibrant pink cherry blossoms.<br>\
		Every petal is stained with colors too pristine for this world.<br>\
		Its branches spread out casting a cool shadow for anyone to enjoy.<br>\
		Even it’s tan trunk, aside from a small yawning crack, is perfect.<br>\
		Just enough of a curve to be pleasing, but straight enough to be stable.<br>\
		All framed by the snow of pink petals slowly floating to earth.<br>\
		Who blessed the world with this?",

		"Accepting it’s invitation you rest against it’s trunk, basking in the shade.<br>\
		The cool shadows, pillowy grass, and firm trunk form the perfect spot to relax.<br>\
		You wake up as the sun begins to set, feeling rejuvenated.<br>\
		Your next stop isn’t far, so with a stretch you return to the road.",

		"The tree is so perfect you could only sully it.<br>\
		So you gaze upon it, absorbing it’s beauty where you couldn’t deface it.<br>\
		And you are content with that.",

		"Approaching the tree, its trunk's  maw seems to draw you in.<br>\
		It's pitch black.<br>\
		But the darkness isn't empty.<br>\
		You’re sure you can see something in it.<br>\
		So you reach in.<br>\
		Something latches onto your hand.<br<\
		Biting into your flesh as you rip away.<br>\
		Deep gashes cover your hand, as something slithers from the trunk.<br>\
		So you run, leaving it behind.",

		"Surely this tree didn’t become so beautiful by happenstance.<br>\
		There must be some sort of root cause.<br>\
		And that gives you a place to start looking.<br>\
		Earnestly you begin to dig,<br>\
		Slowly the tree's roots are exposed.<br>\
		Every one of them clinging to a different skeleton.<br>\
		Some are the remains of small animals,<br>\
		Most are unmistakably human.<br>\
		Filled with morbid curiosity you continue digging,<br>\
		unearthing a fresh and very human corpse.<br>\
		As you watch the tree feed another branch blooms.<br>\
		With blood red flowers that fade into the beautiful pink you had admired.",
	)
/datum/adventure_event/cherry_blossoms/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "Rest under it's branches", M)
			BUTTON_FORMAT(3, "Admire it from afar", M)
			BUTTON_FORMAT(4, "Investiage the opening", M)
			BUTTON_FORMAT(5, "Dig it up", M)
			return
		if(2)
			AdjustHitPoint(10)
		if(4)
			AdjustHitPoint(-5)
		if(5)
			AdjustStatNum(PRIDE_STAT, ADV_EVENT_STAT_EASY)
	return..()
