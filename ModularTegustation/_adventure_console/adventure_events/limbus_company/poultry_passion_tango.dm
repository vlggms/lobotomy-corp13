/datum/adventure_event/poultry_passion_tango
	name = "Mirror Shard:Tango of Poultry Passion"
	desc = "THE SMELL OF CHICKEN AND THE SOUND OF... DANCING?"
	adventure_cords = list(
		"A bright spotlight shines on a portion of the noisy area.<br>\
		It seems as though the chickens are attending a ball.<br>\
		Thats the tango.<br>\
		Looking at their movements which might be a dance or a tussle, you notice sauce leaking from one of them.<br>\
		It doesnt seem to be aware of this",

		"Ability Challenge<br>\
		Notified of its leakage, the chicken quickly ran its wings over its back, or what appeared to be its back, rather.<br>\
		Sadly, the knot had loosened on its stitching.<br>\
		<br><b>Kieegh, kiiierg</b><br><br>\
		Approaching with a trail of sauce dripping behind, it held some thread and a needle in its wings.<br>\
		The chicken holding some stitching supplies pleads with chicky eyes.<br>\
		Someone has to do this. Those eyes cannot be ignored.",

		"You hesitantly stepped forward.<br>\
		Taking the needle and thread, you sat behind the chicken.<br>\
		With awkward but careful hands, you began to stitch the seam with a standard method.<br>\
		<br><b>Kieph.</b><br>\
		Fortunately, it doesnt seem to feel the pain of the needle.<br>\
		Once the sewing was done, it hopped into your lap as if to thank you.<br>\
		<br><b>Kieeh!</b><br><br>\
		You were pleasantly perplexed.",

		"You confidently stepped forward.<br>\
		Taking the needle and thread, you sat behind the chicken.<br>\
		In spite of the initial confidence, however, their stitches became gradually wry.<br>\
		<br><b>Kieerh!</b><br><br>\
		Before you could finish, the chicken pushed you away.<br>\
		Why didnt they do it themselves in the first place?<br>\
		It snatched the supplies back to sew itself up, then walked out of sight.<br>\
		You were left perplexed.",

		"Ability Challenge",

		"<br><b>Mm-mmm~ Boy, I smell something tasty! I sure wonder where this smells coooming frooom~?!</b><br><br>\
		Your voice caused the chickens to stop their passionate dance at once.<br>\
		Examining each others backs, they soon found the source of the leakage.<br>\
		<br><b>Kieh, kierg.</b><br><br>\
		Giiegh.<br>\
		Without panicking, they brought some thread and a needle to sew up its back, or what appears to be its back.<br>\
		They were unsullied in their expertise.<br>\
		Once the stitching was done, they scuttled into the dark.<br>\
		All that remained was the thread and needle they used.",

		"Nothing happens and you leave the chicken to their fate.",

		"In time, the leakage ceased.<br>\
		<br><b>Kiehg!</b><br><br>\
		Perhaps it noticed that its become lighter? It suddenly performed a highly technical move.<br>\
		Astonishing.<br>\
		The chickens around it stopped their dances and watched its performance, mesmerized. Soon enough, they approached the performer, letting out screams that sounded like cheers.<br>\
		They walked out of the light, tossing the special one up and down as a celebration.<br>\
		All that remained was the spilled sauce.",
		)

/datum/adventure_event/poultry_passion_tango/EventChoiceFormat(obj/machinery/M, mob/living/carbon/human/H)
	switch(cords)
		if(1)
			BUTTON_FORMAT(2, "ALERT IT TRUTHFULLY", M)
			BUTTON_FORMAT(5, "GIVE SUBTLE HINTS TO THE CHICKEN", M)
			BUTTON_FORMAT(8, "FORGET WHAT YOU HAVE SEEN", M)
			return
		if(2)
			CHANCE_BUTTON_FORMAT(ReturnStat(LUST_STAT), "LUST", M)
			. += CoinFlipping(M)
			return
		if(3)
			AdjustCurrency(ADV_EVENT_COIN_EASY)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_EASY)
		if(5)
			CHANCE_BUTTON_FORMAT(50, "FLIP OF A COIN", M)
			. += CoinFlipping(M)
			return
		if(6)
			AdjustStatNum(LUST_STAT, ADV_EVENT_STAT_NORMAL)
		if(8)
			AdjustCurrency(ADV_EVENT_COIN_EASY)

	return ..()
