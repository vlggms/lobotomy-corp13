//Scry
/obj/item/book/granter/action/skill/scry
	granted_action = /datum/action/cooldown/fishing/scry
	actionname = "Scry"
	name = "Level 1 Skill: Scry"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/scry
	button_icon_state = "scry"
	name = "Scry"
	cooldown_time = 300
	devotion_cost = 1

/datum/action/cooldown/fishing/scry/FishEffect(mob/living/user)
	to_chat(user, span_notice("Your devotion to the gods is [user.devotion]"))
	switch(SSfishing.moonphase)
		if(1)
			to_chat(user, span_notice("The moon is Waning."))
		if(2)
			to_chat(user, span_notice("The moon is New."))
		if(3)
			to_chat(user, span_notice("The moon is Waxxing."))
		if(4)
			to_chat(user, span_notice("The moon is Full."))

	if(CheckPlanetAligned(FISHGOD_MERCURY))
		to_chat(user, span_notice("Mercury is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_VENUS))
		to_chat(user, span_notice("Venus is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_MARS))
		to_chat(user, span_notice("Mars is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_JUPITER))
		to_chat(user, span_notice("Jupiter is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_SATURN))
		to_chat(user, span_notice("Saturn is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_URANUS))
		to_chat(user, span_notice("Uranus is in alignment with earth."))
	if(CheckPlanetAligned(FISHGOD_NEPTUNE))
		to_chat(user, span_notice("Neptune is in alignment with earth."))



//Sacred Word
/obj/item/book/granter/action/skill/sacredword
	granted_action = /datum/action/cooldown/fishing/sacredword
	actionname = "Sacred Word"
	name = "Level 1 Skill: Sacred Word"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/sacredword
	button_icon_state = "sacredword"
	name = "Sacred Word"
	cooldown_time = 6000
	devotion_cost = 0

/datum/action/cooldown/fishing/sacredword/FishEffect(mob/living/user)
	switch(user.god_aligned)
		if(FISHGOD_MERCURY)
			if(CheckPlanetAligned(FISHGOD_MERCURY))
				user.devotion+=4
				to_chat(user, span_notice("Lir hears your words."))

		if(FISHGOD_VENUS)
			if(CheckPlanetAligned(FISHGOD_VENUS))
				user.devotion+=6
				to_chat(user, span_notice("Tefnut hears your words."))

		if(FISHGOD_MARS)
			if(CheckPlanetAligned(FISHGOD_MARS))
				user.devotion+=8
				to_chat(user, span_notice("Arnapkapfaaluk hears your words."))

		if(FISHGOD_JUPITER)
			if(CheckPlanetAligned(FISHGOD_JUPITER))
				user.devotion+=10
				to_chat(user, span_notice("Susanoo hears your words."))

		if(FISHGOD_SATURN)
			if(CheckPlanetAligned(FISHGOD_SATURN))
				user.devotion+=12
				to_chat(user, span_notice("Kukulkan hears your words."))

		if(FISHGOD_URANUS)
			if(CheckPlanetAligned(FISHGOD_URANUS))
				user.devotion+=14
				to_chat(user, span_notice("Abena Mansa hears your words."))

		if(FISHGOD_NEPTUNE)
			if(CheckPlanetAligned(FISHGOD_NEPTUNE))
				user.devotion+=16
				to_chat(user, span_notice("Glaucus hears your words."))
		else
			to_chat(user, span_notice("Your planet is misaligned. Your prayer goes unanswered."))


//Commune
/obj/item/book/granter/action/skill/commune
	granted_action = /datum/action/cooldown/fishing/commune
	actionname = "Commune"
	name = "Level 1 Skill: Commune"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/commune
	button_icon_state = "commune"
	name = "Commune"
	cooldown_time = 100
	devotion_cost = 1

/datum/action/cooldown/fishing/commune/FishEffect(mob/living/user)
	if(user.god_aligned == FISHGOD_NONE)	//Athiests can't commune because they don't have a soul
		to_chat(user, span_userdanger("YOU HAVE NO GOD."))

	var/input = stripped_input(user,"What do you want to send to others that follow your god?", ,"Commune")
	message_admins("<span class='notice'>A fisherman ([user.ckey]) has used commune with the following message: [input].</span>")
	for(var/mob/living/M in GLOB.player_list)
		if(M.god_aligned == user.god_aligned)
			to_chat(M, span_userdanger("You have a message for you: [input]"))
