/obj/item/book/granter/action/skill/alignment
	name = "Level 4 Skill: Alignment"
	actionname = "Alignment"
	granted_action = /datum/action/cooldown/fishing/alignment
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/alignment
	name = "Alignment"
	button_icon_state = "alignment"
	cooldown_time = 10 MINUTES
	devotion_cost = 15

/datum/action/cooldown/fishing/alignment/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(user.god_aligned != planet.god)
			continue

		planet.phase = 1
		to_chat(user, span_notice("You shift your deity's planet to align with earth."))
		break

/obj/item/book/granter/action/skill/planetstop
	name = "Level 4 Skill: A Moment in Time"
	actionname = "A Moment in Time"
	granted_action = /datum/action/cooldown/fishing/planetstop
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/planetstop
	name = "A Moment in Time"
	button_icon_state = "planetstop"
	cooldown_time = 30 MINUTES
	devotion_cost = 12

/datum/action/cooldown/fishing/planetstop/FishEffect(mob/living/user)
	to_chat(user, span_notice("You halt the planets in their place, letting you bask in their glow a moment more."))
	SSfishing.stopnext = TRUE
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("The planets have stopped moving."))

/obj/item/book/granter/action/skill/supernova
	name = "Level 4 Skill: Supernova"
	actionname = "Supernova"
	granted_action = /datum/action/cooldown/fishing/supernova
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/supernova
	name = "Supernova"
	button_icon_state = "supernova"
	cooldown_time = 20 MINUTES
	devotion_cost = 25

/datum/action/cooldown/fishing/supernova/FishEffect(mob/living/user)
	var/list/planet_names = list()
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(user.god_aligned != planet.god)
			planet_names += planet.name

	if(!length(planet_names))
		to_chat(user, span_warning("... There is nothing in the sky to detonate... your work is done."))
		return

	var/choice = input(user, "Which planet would you like to destroy?", "Supernova") as null|anything in planet_names
	if(!choice)
		to_chat(user, span_notice("You stay your hand."))
		return

	var/success = FALSE
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(planet.name != choice)
			continue

		qdel(planet) // oh dear
		success = TRUE
		break

	if(success)
		to_chat(user, span_narsiesmall("Death to the false gods."))
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("You look up in awe. [choice] has been blown from the sky."))
	else
		to_chat(user, span_userdanger("You lost sight of the planet...?"))

//Alignment 2
/obj/item/book/granter/action/skill/alignment2
	name = "Level 4 Skill: Alignment II"
	actionname = "Alignment II"
	granted_action = /datum/action/cooldown/fishing/alignment2
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/alignment2
	name = "Alignment II"
	button_icon_state = "alignment2"
	cooldown_time = 30 MINUTES
	devotion_cost = 35

/datum/action/cooldown/fishing/alignment2/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		planet.phase = 1

	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("You look up in awe. The planets, they're all aligned!"))
