/datum/adventure_event/oceanic_waves
	name = "An old orange vending machine"
	desc = "YOU SEE A FAINT LIGHT"	//All of the vending machine ones will use this.
	require_abno = /mob/living/simple_animal/hostile/abnormality/oceanicwaves
	adventure_cords = list(
		"In front of you is a bright orange vending machine.<br>\
		There's dozens of buttons, and it's prompting you to pick one.<br>\
		You pass over the 'STALE BLOOD' and 'BABY FORMULA' flavors,<br>\
		and about 6 catch your eye.",

		"You press the button labelled INFINITE WEALTH.<br>\
		A wide-brimmed mason jar is dispensed with an orange liquid inside.<br>\
		It tastes strongly of orange.<br>\
		...<br>\
		Something falls onto your teeth from inside the can, and it hurts a little.<br>\
		reaching in, you pull out a few coins.",


		"You press the button labelled DOUBLE COCAINE.<br>\
		An unlabeled silver can is dispensed.<br>\
		It tastes like a mixture of bitterness and pennies.<br>\
		...<br>\
		You feel awful.",


		"You press the button labelled WELLCHEERS CHAOS MAX.<br>\
		A can with cobalt blue labeling is dispensed.<br>\
		It is rather tasty. It's quite sweet and has a light blueberry taste.<br>\
		...<br>\
		You feel pretty good.",

		"You press the button labelled DOCTOR PEPPER.<br>\
		A red can is dispensed with the brand name in silver wording on it.<br>\
		Taking a sip, it tastes somewhat similar to cola.<br>\
		You have a hard time describing the taste, but you do really enjoy it.<br>\
		Despite never hearing of this soda before, you decide to keep an eye out for it again.",

		"You press the button labelled SKIN.<br>\
		A beige can is dispensed.<br>\
		Picking up the can, it's textured similar to skin, but you manage to open it.<br>\
		...<br>\
		You recognize this metallic taste, and decide to not continue drinking.",

		"You press the button labelled SWEAT OF FREEDOM.<br>\
		A dark grey can with yellow accents is dispensed.<br>\
		Cracking it open, you take a cautious swig.<br>\
		It tastes like sweat. You don't know what you were expecting.<br>\
		...<br>\
		You were so thirsty, you managed to choke it all back.<br>\
		Despite that, you feel pretty good.",

		"You press the button labelled SUPER DEATH.<br>\
		A black can with a white skull is dispensed. There is no other labelling.<br>\
		You take a drink.<br>\
		It tastes like sparkling water.<br>\
		...<br>\
		You feel your mind drift into darkness.",

		)

//This machine doesn't favor any one stat, it's random which ones show up.
/datum/adventure_event/oceanic_waves/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "INFINITE WEALTH", M)
			BUTTON_FORMAT(3, "DOUBLE COCAINE", M)
			BUTTON_FORMAT(4, "WELLCHEERS CHAOS MAX ", M)
			BUTTON_FORMAT(5, "DOCTOR PEPPER", M)
			BUTTON_FORMAT(6, "SKIN", M)
			BUTTON_FORMAT(7, "SWEAT OF FREEDOM", M)
			BUTTON_FORMAT(8, "SUPER DEATH", M)
			return
		if(2)
			AdjustCurrency(3)
			AdjustHitPoint(-1)	//funny
		if(3)
			AdjustStatNum(RAND_STAT,-3)
			AdjustStatNum(RAND_STAT,3)
			AdjustStatNum(RAND_STAT,-3)
			AdjustStatNum(RAND_STAT,3)
		if(4)
			AdjustHitPoint(30)	//Heals you a bit
		if(5)
			AdjustStatNum(RAND_STAT,1)	//I like doctor pepper
		if(6)
			AdjustHitPoint(-10)
			AdjustStatNum(RAND_STAT,2)
		if(7)
			AdjustHitPoint(100)
			AdjustStatNum(RAND_STAT,-1)
		if(7)
			AdjustHitPoint(-100)
			AdjustStatNum(WRATH_STAT,1)
			AdjustStatNum(LUST_STAT,1)
			AdjustStatNum(SLOTH_STAT,1)
			AdjustStatNum(GLUTT_STAT,1)
			AdjustStatNum(GLOOM_STAT,1)
			AdjustStatNum(PRIDE_STAT,1)
			AdjustStatNum(ENVY_STAT,1)
	return ..()
