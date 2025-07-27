/datum/adventure_event/chicken_strife
	name = "Mirror Shard:Chicken Strife"
	desc = "THE SMELL OF CHICKEN AND HEAR A HEATED ARGUMENT"
	adventure_cords = list(
		"Some folks are blocking the way.<br>\
		Theyre sitting on a deck, yelling at each other.<br>\
		<br><b>Look at this succulent piece! The rich juice running down the fibers of luscious meat This is what chicken is about!</b><br><br>\
		<br><b>Wrong. This piece has a clean taste, with not an ounce of grease tainting the tongue. This is the real deal.</b><br><br>\
		The two turn around at the same time to face you.<br>\
		<br><b>You there! Tell us which is better.</b><br>",

		"<br><b>Thats true.</b><br><br>\
		<br><b>An irrefutable point.</b><br><br>\
		They lowered their hands and settled down.<br>\
		<br><b>What a strange thing we were fighting over.</b><br><br>\
		<br><b>Theyre right The one truth is that the chicken is always right.</b><br><br>\
		After a passionate handshake, the two gave you their bucket of chicken.<br>\
		<br><b>A wise gourmet such as yourself deserves both pieces. Please, take this, we insist.</b><br>",

		"<br><b>You see! The drumsticks are better!</b><br><br>\
		<br><b>You dont know what good taste is.</b><br><br>\
		The person holding a chicken breast let out a baffled sigh.<br>\
		<br><b>Ey! Heres your reward. You deserve a drumstick of your own.</b><br><br>\
		Satisfied, the one with a drumstick handed you another from the bucket.<br>\
		<br><b>Im counting on you to keep that leg up!</b><br><br>\
		Unsure of what youre being trusted with, you left the table with the drumstick.",

		"<br>There aint no way! Youd give up this banquet of juiciness?</b><br><br>\
		<br><b>Its fat, not just juice. The breast is healthy, light, comes in hefty servings, and is easy to eat! its obviously the reasonable choice.</b><br><br>\
		The person holding a piece of chicken breast pleasantly remarked.<br>\
		<br><b>Here, a reward for you. Take this breast.</b><br><br>\
		A sizable piece was brought out of the bucket.<br>\
		<br><b>Best of luck with your gains. I hope you stay healthy.</b><br><br>\
		Unsure of what youre supposed to gain, you left the table with the chicken breast.",

		)

/datum/adventure_event/chicken_strife/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "CHICKEN IS CHICKEN, DUH", M)
			BUTTON_FORMAT(3, "GOTTA BE THE DRUMSTICKS, ALL RICH AND JUICY", M)
			BUTTON_FORMAT(4, "THE BREAST OF COURSE, UNSULLIED AND SPOTLESS", M)
			return
		if(2)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY)
			AdjustStatNum(GLUTT_STAT, ADV_EVENT_STAT_EASY)
		if(3)
			AdjustStatNum(WRATH_STAT, ADV_EVENT_STAT_EASY)
		if(4)
			AdjustStatNum(GLUTT_STAT, ADV_EVENT_STAT_EASY)

	return ..()
