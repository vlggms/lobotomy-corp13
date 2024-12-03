//Planetary Momentum
/obj/item/book/granter/action/skill/planet
	granted_action = /datum/action/cooldown/fishing/planet
	actionname = "Planet"
	name = "Level 1 Skill: Planet"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/planet
	button_icon_state = "planet"
	name = "Planet"
	cooldown_time = 6000
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

//Lunar Motion
/obj/item/book/granter/action/skill/moonmove
	granted_action = /datum/action/cooldown/fishing/moonmove
	actionname = "Lunar Motion"
	name = "Level 1 Skill: Lunar Motion"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/moonmove
	button_icon_state = "moonmove"
	name = "Lunar Motion"
	cooldown_time = 6000
	devotion_cost = 3

/datum/action/cooldown/fishing/moonmove/FishEffect(mob/living/user)
	to_chat(user, span_notice("You shift the moon forwards by one phase."))
	SSfishing.moonphase+=1		//Moon Phases will affect the power of Moon-based mods.
	if(SSfishing.moonphase == 5)	//there's only 4
		SSfishing.moonphase = 1


//Targeted Planet
/obj/item/book/granter/action/skill/planet2
	granted_action = /datum/action/cooldown/fishing/planet2
	actionname = "Planet II"
	name = "Level 1 Skill: Plane II"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/planet2
	button_icon_state = "planet2"
	name = "Planet II"
	cooldown_time = 6000
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
