/datum/adventure_event/ncorp_events/dance
	name = "N-Corporation: The Ball"
	desc = "YOU SEE A BRIGHT LIGHT"
	adventure_cords = list(
	"You have a rare occasion; a letter arrives to you from a fixer. <br>\
	'You are invited to the wedding of JOHN and JANE!'. <br>\
	Oh, some old friends of yours.  <br>\
	Some time off would be nice. <br>\
	You submit your request to Nagel und Hammer, and due to your high loyalty, they agree to give you the night off. <br>\
	Arriving a little later in the night, you arrive for the opening ceremony and for the first dance. <br>\
	'Hi there, handsome.' A woman in a long black dress and thick black gloves approaches you. <br>\
	'Care to dance?' ",

	"'Apologies. I have two left feet.' You say, looking down. <br>\
	She smirks and pulls you to your feet. <br>\
	'Nonsense.' she says, taking you by the waist. Her hand is very bony and cold. <br>\
	Some old-timey music is coming from a device in the corner of the room. <br>\
	'Here, take my hand, hand on my shoulder.' And you follow her lead, blushing.",

	"'Of course.' You say, rising to your feet.<br>\
	Grabbing your hand and turning away, she gives you a side eye. <br>\
	'You know how to waltz?' She asks, face in concentration, listening to the music <br>\
	'Here, take my hand, one hand on my waist.' She says, grabbing your shoulder.",

	"The music ends it's tune, and exhausted, the both of you collapse into chairs around a table, laughing/<br>\
	She looks you in the eye and smiles. 'Let's have some dinner' <br>\
	As you dine on the variety of dishes at the table; the groom gets up to speak. <br>\
	During his speech, your new partner turns to you.  <br>\
	'It's so hot in here.' She smiles, and begins to remove her gloves and roll up her sleeves  <br>\
	And you see it; her metalic arm shining in the light of the event",

	"The music ends it's tune, and exhausted, the both of you collapse into chairs around a table, laughing.<br>\
	She looks you in the eye and smiles. 'Let's have some dinner' <br>\
	As you dine on the variety of dishes at the table; the groom gets up to speak. <br>\
	During his speech, your new partner turns to you.  <br>\
	'It's so hot in here.' She smiles, and begins to remove her gloves and roll up her sleeves.<br>\
	And you see it; her metallic arm shining in the light of the dining hall.",

	"Standing up, you grab her by her arm, pulling her to her feet.<br>\
	You plunge a dinner knife into her chest, and she screams in horror. <br>\
	Lacking a nail or hammer, you retrieve your knife, and plunge it into her again. <br>\
	'Heretic.' You mutter, as she stares you in the face, struggling to push you away. <br>\
	All eyes are on you, staring in shock.<br>\
	You shove her to the ground, and press your foot against her chest. Pulling with all your might, you rip her cheap prosthetic arm off, as her ribs audibly crack. <br>\
	In one final cry of agony, she rolls over in her own blood. <br>\
	Spitting on her unmoving body and dropping a seal over her corpse, you rush out of the event and escape the crowd chasing you into the night. <br>\
	What you did tonight was heretical.",

	"You can't just purge this woman who gave you kindness, not with all these people watching.<br>\
	You swallow your spit and avoid her gaze all night as the event comes to a close. <br>\
	As you leave, she tries to stop you. 'Hey, I had a great night' she says. <br>\
	'Thanks.' she smiles. Building up courage you mutter a quick 'Yeah, me too.' <br>\
	As you turn to leave, she grabs your hand for the final time. <br>\
	'Can we meet again some time?' Her voice is shaking. <br>\
	'How can I contact you?' She continues, desperately.<br>\
	You shake her off. 'Don't.' She cannot be seen by Nagel und Hammer.",)

/datum/adventure_event/ncorp_events/dance/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "YOU HAVE TWO LEFT FEET.", M)
			BUTTON_FORMAT(3, "A PLEASURE.", M)
			return
		if(2)
			AdjustStatNum(PRIDE_STAT,-2)	//Not enough pride in your dancing ability.
			AdjustStatNum(LUST_STAT,1)		//Tiny lust bonus for your troubles. She turns your face red
			BUTTON_FORMAT(4, "ENJOY A DANCE.", M)
			return
		if(3)
			BUTTON_FORMAT(4, "ENJOY A DANCE.", M)
			return
		if(4)
			BUTTON_FORMAT(5, "PURGE THE HERETIC", M)
			BUTTON_FORMAT(6, "LET IT SLIDE.", M)
			AdjustHitPoint(20)	//You eat food
			return
		if(5)
			AdjustStatNum(PRIDE_STAT,-7)	//You shouldn't have done that.
			AdjustStatNum(WRATH_STAT,3)		//Get a small kickback. pride is much easier than Wrath to get
		if(6)
			AdjustStatNum(PRIDE_STAT,-5)	//You feel like a failure
			AdjustStatNum(WRATH_STAT,-5)	//And uh this.
			AdjustStatNum(LUST_STAT,3)		//I guess you get some lust back though? Is falling in love gaining lust?
	return ..()
