/datum/adventure_event/ncorp_events/scripture
	name = "N-Corporation: Scripture"
	desc = "YOUR MANDATORY SCRIPTURES"
	adventure_cords = list(
	"These scriptures are sadly mandatory. <br>\
	You sigh, and take a seat on your bunk, reading by torchlight",

	"Gloria patri qui te tenet.",	//Glory to the one who grips.

	"Caro mea munda est. <br>\
	Mens mea munda est. <br>\
	Anima mea munda est",	//My Flesh is clean. My mind is clean. My soul is clean.

	"Metallum massas interficere volo. <br>\
	Sic faciam cum malleo. <br>\
	Hoc faciam clavo.",		//I will cull the metal masses. I will do this with my hammer, I will do this with my nail

	"Exaudi orationem meam. <br>\
	Amen.",	//Hear my prayer. Amen.
	)

//This whole thing is super poorly translated.
/datum/adventure_event/ncorp_events/scripture/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "BEGIN YOUR PRAYER.", M)
			AdjustHitPoint(5)
			return
		if(2)
			BUTTON_FORMAT(3, "GLORIA PATRI QUI TE TENET.", M) //Glory to the one who grips.
			AdjustHitPoint(5)
			return
		if(3)
			BUTTON_FORMAT(4, "MUNDUS SUM.", M) //I am clean.
			AdjustHitPoint(5)
			return
		if(4)
			BUTTON_FORMAT(5, "EGO FACIAM MANIBUS MEIS.", M)	//I will do it with my hands.
			AdjustHitPoint(5)
			return
		if(5)
			AdjustStatNum(RAND_STAT,1)

	return ..()
