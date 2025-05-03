/datum/adventure_event/ncorp_events/lady
	name = "N-Corporation: A Proposition"
	desc = "YOU SEE A FAINT LIGHT"
	adventure_cords = list(
	"Your stomach growls as you stalk the street at night. <br>\
	Your armor clanking along, searching for any heretics to purge. <br>\
	You hear a sound, and turn to hear a door open.  <br>\
	Light floods the alleyway from the threshold, and a middle-aged woman stands in the doorframe. <br>\
	'Ohoho, what do we have here?' She says, not expecting a reply. <br>\
	'You're one of those N-Corporation Knights, no?' <br>\
	You narrow your eyes through your armor.  <br>\
	'Why don't you come inside for some dinner?' She proposes. 'I appreciate your work.' ",

	"You shake your head.  <br>\
	'Apologies. I am on patrol, I have already eaten.' Your voice echos hollow through your armor. <br>\
	With a shakey voice, not even you believe yourself. <br>\
	She smiles and waves you away. 'That's fine by me. Good luck, young Knight!' <br>\
	You've done well to keep the honor of Nagel Und Hammer.  <br>\
	...but you are so hungry.",

	"Stepping inside, you dine with the lady, and enjoy a fanciful meal and delicious wine. <br>\
	You've not had such luxuries in some time. <br>\
	Wrapped up in conversation and inebriation, you decide to spend the night. <br>\
	At sunrise, you awake to a start. Scrambling to don your armor with your face flushed red, you thank her. <br>\
	'Come again anytime.' She says, pressing a few coins in your hand and waving you out of the house. <br>\
	You feel no pride in what you've done.",
	)

/datum/adventure_event/ncorp_events/lady/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "A KNIGHT WOULD NEVER.", M)
			BUTTON_FORMAT(3, "BUT YOU ARE SO HUNGRY.", M)
			return
		if(2)
			AdjustHitPoint(-30)
		if(3)
			AdjustStatNum(PRIDE_STAT,-10)
			AdjustStatNum(LUST_STAT,1)
			AdjustCurrency(15)
	return ..()
