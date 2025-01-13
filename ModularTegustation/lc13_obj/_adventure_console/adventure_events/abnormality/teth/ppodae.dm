/**
	*Ppodae is the cutist.
	*-ML
	*/
/datum/adventure_event/ppodae
	name = "Ppodae"
	desc = "YOU SEE THE CUTEST THING EVER"
	require_abno = /mob/living/simple_animal/hostile/abnormality/ppodae
	adventure_cords = list(
		"Entering the room, you notice it's near identical to a Lobotomy Corporation Contaiment Unit.<br>\
		Specifically one for a large sized Abnormality<br>\
		The only thing in it is a small fluffy boy with a petite mouth and large adorable eyes.<br>\
		It hops over to you, tail eagerly wagging as it looks up at you with pleading eyes.<br>\
		It is so adorable, so cute! Nothing could ever compare!<br>\
		There has to be SOMETHING you can do for him!",

		"Clearly no one has fed him recently! His bowl is nearly half empty!<br>\
		This can not go uncorrected! Thus, you being your quest to correc this neglect!<br>\
		The hallway outside the containment unit is devoid of anything.<br>\
		Returning to the chambers you strangely find the food in a closet inside the containment unit.<br>\
		Clearly someone had the good idea to alter the unit to make it more hospitable!<br>\
		There’s a few bones from a sekeleton for the good boy to chew on as well, you take some with as a treat.<br>\
		He looks so cute chowing down! It warms your soul to see him so happy.",

		"How could something this photogenic possibly exist?<br>\
		Taking out your phone you snap picture after picture, catching the good boy from every angle.<br>\
		Every single one of these pictures is too good to keep to yourself.<br>\
		As quickly as you take them you share them with others, deluging the net with Ppodae.<br>\
		Comments roll in, all of them in love with this most wonderous cutie.",

		"This little cutie can’t be left like this!<br>\
		He’s so lonely and needs attention.<br>\
		Thankfully you’re able to find a bone in a closet that shouldn’t be there for him to fetch!<br>\
		You toss it a couple of times, each time he takes it back showing off just how powerful his adorable body is!<br>\
		Wait, why’s he growing larger?",

		"Surely the managers didn’t make a mistake and put an actual dog in containment.<br>\
		After searching around you find the management notes in the workstation.<br>\
		Sure enough this is an abnormality, with a very long list of deaths it caused.<br>\
		Maybe playing with it isn’t the best idea...",
	)

/datum/adventure_event/ppodae/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "FEED THE GOODEST BOY!", M)
			BUTTON_FORMAT(3, "TAKE PICTURES! SO MANY PICTURES!", M)
			BUTTON_FORMAT(4, "PLAY WITH HIM!", M)
			BUTTON_FORMAT(5, "ISN'T THIS STILL AN ABNORMALITY?", M)
		if(2)
			AdjustHitPoint(5)
		if(3)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
		if(4)
			CauseBattle(
				"Ppodae: A mountiain of muscle with the facade of a puppy.",
				MON_DAMAGE_EASY,
				30
			)
	return ..()
