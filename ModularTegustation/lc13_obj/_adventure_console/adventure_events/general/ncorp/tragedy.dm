/datum/adventure_event/ncorp_events/tragedy
	name = "N-Corporation: Tragedy"
	desc = "YOU SEE A FAINT LIGHT"		//I hope this one will be common.
	adventure_cords = list(
	"The living have fled.<br>\
	You lay dying amongst your own allies.<br>\
	Your assault on this town has failed.<br>\
	All that remains is the dying and the dead.",

	"Your eyes lay heavy, as the blood flows from you.<br>\
	There's no better way to die than dying for a cause among your comrades.<br>\
	When you wake up, you'll tell them about what happened here.",

	"You reach out for a friend. <br>\
	Gasping for air, a nearby kleinhammer grasps it. <br>\
	You look behind their visor, but can see nothing but the void.<br>\
	And as their grip loosens, with more blood flowing from their smashed helmet, you begin to drift off.<br>\
	Just a small nap. You'll wake up soon.",

	"Feeling the end coming soon, you begin to pray. <br>\
	You pray.<br>\
	You recite all the scriptures you remember.<br>\
	Feeling inspired, you pull your battered, bleeding corpse out of the town.<br>\
	And you pass out, in the dark of night, in a town you never knew.",

	"'Hey, Wake up.' <br>\
	Your eyes slowly open.<br>\
	A woman in mittlehammer armor, lacking the helmet, is sitting up next to you.<br>\
	The sun is shining down on the meadow, and her face is shining with a smile.<br>\
	And she begins to speak. <br>\
	'I'm glad I found you when I did.'<br>\
	'There was so much blood, 10 more minutes and you would have been a gonner,'<br>\
	'I'm so happy that I was able to help you.'<br>\
	She stands up. 'I'm a few hours late to get back. They're going to tan my hide.'<br>\
	She leaves you a can of bread and a bottle of water. 'Here. Have some food. And don't move.'<br>\
	She turns to leave.<br>\
	'I will come back here for you. I promise. Don't die on me.'<br>\
	The bread still tastes fine. But you can't help but feel empty.",
	)

/datum/adventure_event/ncorp_events/tragedy/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "FALL ASLEEP.", M)
			BUTTON_FORMAT(3, "REACH OUT TO A FRIEND", M)
			BUTTON_FORMAT(4, "PRAY", M)
			return
		if(2)
			AdjustHitPoint(-100)		//You die.
			AdjustStatNum(PRIDE_STAT,-10)	//And you lose all your pride.
		if(3)
			AdjustHitPoint(-100)		//You die.
			AdjustStatNum(RAND_STAT,-1)	//And lose 5 random stats.
			AdjustStatNum(RAND_STAT,-1)
			AdjustStatNum(RAND_STAT,-1)
			AdjustStatNum(RAND_STAT,-1)
			AdjustStatNum(RAND_STAT,-1)
		if(4)
			BUTTON_FORMAT(5, "...", M)
			//You DON'T die, but you take a lot of damage.
			AdjustHitPoint(-70)
			AdjustStatNum(PRIDE_STAT,3) //Gain a bit of pride
			AdjustStatNum(WRATH_STAT,-2) //And lose 2 to all other stats.
			AdjustStatNum(LUST_STAT,-2)
			AdjustStatNum(SLOTH_STAT,-2)
			AdjustStatNum(GLUTT_STAT,-2)
			AdjustStatNum(GLOOM_STAT,-2)
			AdjustStatNum(ENVY_STAT,-2)
			return
		if(5)
			AdjustHitPoint(20)
			AdjustStatNum(RAND_STAT,-1)
	return ..()
