/**
	*Void Dream is fairly straight forward.
	*It’s about dreams and the desire to give up on the waking world
	*and instead live in a place where things are more pleasant
	*either generally or for things more specifically. -ML
	*/
/datum/adventure_event/void_dream
	name = "Void Dream"
	desc = "YOU SEE A WOOLY CREATURE SLEEPING IN THE VOID."
	require_abno = /mob/living/simple_animal/hostile/abnormality/voiddream
	adventure_cords = list("The cold darkness of the void embraces you and the creature before you.<br>\
	Its wool is white, illuminated by the light of countless stars.<br>\
	From the mass of wool two eyes peak at you, it's head tucked away elsewhere.<br>\
	Brushing your hand against it you feel at ease, like it’s inviting you to join it's slumber.<br>\
	You feel drowsy, and some other feeling.<br>\
	Like a part of your heart is fading into the past.<br>\
	Maybe, you could take a moment to rest your eyes?",

	"Ability Challenge",

	"The floating ball of fluff and wool is warm and oh so comfortable.<br>\
	It doesn't take long to drift off to sleep,and when you do you dream.<br>\
	You’re taken back to a time you’d almost forgotten.<br>\
	There’s someone else there, together you walk, you talk, and you laugh.<br>\
	It feels so deeply nostalgic, but you can’t remember why.<br>\
	\"Hey !@)(!@&)&*%(%@!@#*(#\"<br>\
	You stop. That isn’t right, they had a name.<br>\
	You wake with start, sleep blurring your thoughts as they mix together.<br>\
	Wondering why you're here you look around, and seeing nothing but a ball of void, leave.<br>\
	It feels like you left something important behind",

	"You lay down to rest, nestling up into its warm, inviting, wool.<br>\
	You toss and turn, trying to get some rest, trying to escape into a dream.<br>\
	Then everything begins to fade away, and you wake up with a start.<br>\
	Turning around you see its eyes watching you and a thin tongue reaching out from a beak to lick you.<br>\
	It slowly tastes you and you feel your memories of the dream slowly fade.<br>\
	No, you can’t let it take them. Those are your memories, and you have to keep it that way.<br>\
	Turning you flee, and it drifts back to sleep.",

	"No, now isn’t the time for rest.<br>\
	Sleep is inviting, but this is still an abnormality and you shouldn’t trust it.<br>\
	Turning away you leave it to sleep.",
	 )


/datum/adventure_event/void_dream/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "FALL ASLEEP", M)
			BUTTON_FORMAT(5, "STAY AWAKE", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(GLOOM_STAT), "Gloom", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(SLOTH_STAT), "Sloth", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustStatNum(GLOOM_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
	return ..()
