/datum/adventure_event/singing_machine
  name = "Singing_Machine"
  desc = "YOU SEE A BOXY MACHINE"
  require_abno = /mob/living/simple_animal/hostile/abnormality/singing_machine
  adventure_cords = list(
    "A sharp smell of iron and violence fills the room as you enter.<br>\
	Inside, is a large boxy machine with a person slumped against it.<br>\
	Each of their limbs has been ripped to shreds, with small fleshy gibs hanging from the machine.<br>\
	\"You there!\" Turning towards you.<br>\
	\"Throw yourself into the Machine! I need to hear it one more time!\"",

	"Putting yourself into the machine seems a bit extreme.<br>\
	However, if the sound it makes is that good you might have to listen.<br>\
	Against your better judgement you open the machine slipping a finger inside trying to keep it above the gnashing teeth.<br>\
	Slowly you inch closer, until it grabs you, yanking you towards the machine.<br>\
	Before you can stop yourself your arm is dragged into the depths, a new tune bursting forth amidst your screams.<br>\
	It is the most beautiful thing you’ve heard.",

	"Ability Challenge",

	"In a single fluid motion you pick up the person and toss them into the machine.<br>\
	Their cry isn’t one of fear, but exaltation thanking you for feeding them into the machine.<br>\
	As their body falls into the mesh of teeth and gears music begins to play.<br>\
	It’s a sound so lovely you understand the mperson's cheers.",

	"Reaching down you try to pick the person up, but they smack you away cutting your arm with a shard of bone.<br>\
	\"Stay away! If you aren’t going to give me music, then leave!\<br>\
	Sighing, you try again to pick them up, this time succeeding.<br>\
	However when you try to throw them they thrash around, falling out of your grasp.<br>\
	And knocking your arm into the machine.<br>\
	You scream as the machine tears into your arm.<br>\
	But the music it makes transcends beauty.",

	"Deciding you want nothing to do with any of this you turn to leave.<br>\
	\"Wait! Where are you going?\" The person cries reaching out with it’s jagged stump. \"Don’t you want to listen to ecstasy?\"<br>\
	You simply leave them there to rot.",
   )

/datum/adventure_event/singing_machine/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "PUT YOUR FINGER IN THE MACHINE", M)
			BUTTON_FORMAT(3, "THROW THE PERSON IN THE MACHINE", M)
			BUTTON_FORMAT(4, "JUST LEAVE", M)
			return
		if(2)
			AdjustHitPoint(-30)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_EASY)
		if(3)
			CHANCE_BUTTON_FORMAT(ReturnStat(WRATH_STAT), "WRATH", M)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT), "LUST", M)
			. += CoinFlipping(M)
			return
		if(4)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_EASY)
		if(5)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_EASY)
			AdjustHitPoint(-30)
	return..()
