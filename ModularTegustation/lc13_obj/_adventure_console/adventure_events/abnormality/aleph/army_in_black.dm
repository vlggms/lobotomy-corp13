/**Army ends up being a combination between an abnormality focused on trying to share the burden of being human,
	*and the corruption of trying to do good turning into doing evil.
	*Both ideas are present in how it operates, and I want to make the options try and capture that.
	*-ML
	*/
/datum/adventure_event/army_in_black
	name = "Army in Black"
	description = "YOU SEE A BUNCH OF SOLDIERS IN GELATINOUS HEARTS"
	required_abno = /mob/living/simple_animal/abnormality/aleph/army_in_black
	adventure_cords = (
		"Inside the facility rows and rows of gelatinous hearts sit,<br>\
		Each of them containing a person in bright pink military gear.<br>\
		You approach one, it’s impossible to see any expression on their face.<br>\
		One of them turns towards you and gives a quick salute before asking:<br>\
		\"What color are human’s hearts?\"",

		"\"Of course, that is the color in every human’s heart.\" They say warmly.<br>\
		You don’t see them move, but you feel them with you as you leave.<br>\
		Protecting you from what comes next.",

		"\"Can’t the human heart exist without Darkness?\"<br>\
		You once again refute what it’s saying.<br>\
		The gelatinous substance it’s in starts to darken,<br>\
		Along with the thing’s armor.<br>\
		\"We’re able to protect humanity from it.\"<br>\
		\"So why won’t you let us bear the burden for you?\"<br>\
		It begins to spark, strands of black lighting leaping out at you.<br>\
		You turn to run as the bubbles begin to spark as they turn black.<br>\
		\"Why won’t you let us take your darkness?\"",

		"\"Why can’t the human heart be more than just an organ?\"<br>\
		With that they go silent, allowing you to leave.",
	)
/datum/adventure_event/army_in_black/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "PINK", M)
			BUTTON_FORMAT(3, "BLACK", M)
			BUTTON_FORMAT(4, "FLESH", M)
			return
		if(2)
			AdjustHealth(+35)
		if(3)
			AdjustHealth(-50)
		if(4)
	return..()
