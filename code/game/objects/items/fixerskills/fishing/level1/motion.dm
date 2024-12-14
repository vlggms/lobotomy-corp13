/obj/item/book/granter/action/skill/planet
	name = "Level 1 Skill: Planet"
	actionname = "Planet"
	granted_action = /datum/action/cooldown/fishing/planet
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/planet
	name = "Planet"
	button_icon_state = "planet"
	cooldown_time = 10 MINUTES
	devotion_cost = 2

/datum/action/cooldown/fishing/planet/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(user.god_aligned != planet.god)
			continue

		planet.phase++
		if(planet.phase == planet.orbit_time + 1)
			planet.phase = 1
		to_chat(user, span_notice("You shift the movement of your aligned planet by 1."))
		break

/obj/item/book/granter/action/skill/moonmove
	name = "Level 1 Skill: Lunar Motion"
	actionname = "Lunar Motion"
	granted_action = /datum/action/cooldown/fishing/moonmove
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/moonmove
	name = "Lunar Motion"
	button_icon_state = "moonmove"
	cooldown_time = 10 MINUTES
	devotion_cost = 3

/datum/action/cooldown/fishing/moonmove/FishEffect(mob/living/user)
	to_chat(user, span_notice("You shift the moon forwards by one phase."))
	SSfishing.moonphase++
	if(SSfishing.moonphase == 5) // there's only 4
		SSfishing.moonphase = 1

/obj/item/book/granter/action/skill/planet2
	name = "Level 1 Skill: Plane II"
	actionname = "Planet II"
	granted_action = /datum/action/cooldown/fishing/planet2
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/planet2
	name = "Planet II"
	button_icon_state = "planet2"
	cooldown_time = 10 MINUTES
	devotion_cost = 4

/datum/action/cooldown/fishing/planet2/FishEffect(mob/living/user)
	var/list/planet_names = list()
	for(var/datum/planet/planet as anything in SSfishing.planets)
		planet_names += planet.name

	var/choice = input(user,"Which planet would you like to move?","Planet II") as null|anything in planet_names
	if(!choice)
		to_chat(user, span_notice("You stay your hand."))
		return

	var/success = FALSE
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(planet.name != choice)
			continue

		planet.phase++
		if(planet.phase == planet.orbit_time + 1)
			planet.phase = 1
		success = TRUE
		break

	to_chat(user, success ? span_nicegreen("[choice] has been moved forwards.") : span_userdanger("You lost sight of the planet...?"))
