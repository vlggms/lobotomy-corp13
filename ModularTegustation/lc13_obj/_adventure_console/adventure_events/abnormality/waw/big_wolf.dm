/**The wolf is something that becomes the villain because it was always expected to be one.
	*While it still acts as on it’s instincts,
	*What ultimately makes it a monster is other’s expectations.
	*-ML
	*/
/datum/adventure_event/big_wolf
	name = "Big and Will Be Bad Wolf"
	description = "YOUS SEE A WOLF IN THE MOONLIGHT"
	require_abno = /mob/living/simple_animal/hostile/abnormality/big_wolf
	adventure_cords = list(
		"A pale silver moon illuminates the field.<br>\
		The only sounds are the wind whistling through the grass,<br>\
		and the whimpering of the beast in front of you.<br>\
		It isn’t quite a wolf, it’s too round and plump, closer to a toy then an an animal.<br>\
		But its stomach is too full, occasionally wiggling like something is fighting to escape.<br>\
		As if it’s asking you for something it looks at you with large soulful eyes.<br>\
		Something you could provide.<br>\
		It may appear innocent now,<br>\
		but you might end up helping a monster.",

		"This monster is clearly asking for what it deserves.<br>\
		It knows the sins it has and will commit.<br>\
		And those must be punished at all costs.",

		"It accepts its fate, it will become the monster.<br>\
		And you the hunter.<br>\
		The Wolf’s body dissapears into the shadows,<br>\
		Elongating and sharpening as it stalks around you waiting for an opening.<br>\
		Then it pounces.<br>\
		But you are swift and brutal.<br>\
		In a moment the threat is gone, and its victim freed.",

		"You have to kill it before it becomes a monster.<br>\
		It’s a simple matter of preventing it from ever reaching that point.<br>\
		So you approach it, picking up your weapon ready to drive it into the beast.<br>\
		It doesn’t give you the chance.<br>\
		It’s body seems to melt into darkness as it lunges onto you,<br>\
		Pinning you under its weight as its teeth rip and tear into you.<br>\
		Then as fast as it attacked, it’s gone.<br>\
		Disappearing into the dark grass.",

		"You can see the sins that it will commit.<br>\
		Along with the ones it’s already committed.<br>\
		But that doesn’t matter, you forgive it.<br>\
		You offer some food as an offering of peace, and it takes it.<br>\
		Laying down, it eats, treasuring each and every bite.<br>\
		Eventually it starts to hack, releasing a person from it’s stomach.<br>\
		Damaged, but still in good enough shape to run away screaming.<br>\
		Surely they can see the wolf doesn't have to be bad.<br>\
		Right?",
	)

/datum/adventure_event/big_wolf/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "PUNISH IT", M)
			BUTTON_FORMAT(3, "FORGIVE IT", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(ENVY_STAT), "ENVY", M)
			.+= CoinFlipping(M)
			return
		if(3)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustHealth(-40)
		if(5)
			AdjustStatNum(WRATH_STAT, -2)
			AdjustStatNum(PRIDE_STAT, 4)
	return..()
