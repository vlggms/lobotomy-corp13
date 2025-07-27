/obj/item/book/granter/action/skill/scry
	name = "Level 1 Skill: Scry"
	actionname = "Scry"
	granted_action = /datum/action/cooldown/fishing/scry
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/scry
	name = "Scry"
	button_icon_state = "scry"
	cooldown_time = 30 SECONDS
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

	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(planet.phase == 1)
			to_chat(user, span_notice("[planet.name] is in alignment with earth."))

/obj/item/book/granter/action/skill/sacredword
	name = "Level 1 Skill: Sacred Word"
	actionname = "Sacred Word"
	granted_action = /datum/action/cooldown/fishing/sacredword
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/sacredword
	name = "Sacred Word"
	button_icon_state = "sacredword"
	cooldown_time = 10 MINUTES
	devotion_cost = 0

/datum/action/cooldown/fishing/sacredword/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(user.god_aligned != planet.god)
			continue

		if(planet.phase != 1)
			to_chat(user, span_notice("Your planet is misaligned. Your prayer goes unanswered."))
			return

		user.devotion += (planet.orbit_time * 2)
		to_chat(user, span_notice("[user.god_aligned] hears your words."))
		return

	to_chat(user, span_danger("... but silence is the only listener.")) // Your planet is done broke

/obj/item/book/granter/action/skill/commune
	name = "Level 1 Skill: Commune"
	actionname = "Commune"
	granted_action = /datum/action/cooldown/fishing/commune
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/commune
	name = "Commune"
	button_icon_state = "commune"
	cooldown_time = 10 SECONDS
	devotion_cost = 1

/datum/action/cooldown/fishing/commune/FishEffect(mob/living/user)
	if(user.god_aligned == FISHGOD_NONE) // Athiests can't commune because they don't have a soul
		to_chat(user, span_userdanger("YOU HAVE NO GOD."))

	var/input = stripped_input(user, "What do you want to send to others that follow your god?", "Fish communion", "Commune")
	message_admins("A fisherman ([user.ckey]) has used commune with the following message: [input].")
	for(var/mob/living/M in GLOB.player_list)
		if(M.god_aligned == user.god_aligned)
			to_chat(M, span_userdanger("You have a message for you: [input]"))
