//Align
/obj/item/book/granter/action/skill/alignment
	granted_action = /datum/action/cooldown/fishing/alignment
	actionname = "Alignment"
	name = "Level 4 Skill: Alignment"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/alignment
	button_icon_state = "alignment"
	name = "alignment"
	cooldown_time = 6000
	devotion_cost = 15

/datum/action/cooldown/fishing/alignment/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		if(user.god_aligned != planet.god)
			continue

		planet.phase = 1
		to_chat(user, span_notice("You shift your deity's planet to align with earth."))
		break

//A Moment in Time
/obj/item/book/granter/action/skill/planetstop
	granted_action = /datum/action/cooldown/fishing/planetstop
	actionname = "A Moment in Time"
	name = "Level 4 Skill: A Moment in Time"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/planetstop
	button_icon_state = "planetstop"
	name = "planetstop"
	cooldown_time = 18000
	devotion_cost = 12

/datum/action/cooldown/fishing/planetstop/FishEffect(mob/living/user)
	to_chat(user, span_notice("You halt the planets in their place, letting you bask in their glow a moment more."))
	SSfishing.stopnext = TRUE
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("The planets have stopped moving."))


//Supernova
/obj/item/book/granter/action/skill/supernova
	granted_action = /datum/action/cooldown/fishing/supernova
	actionname = "Supernova"
	name = "Level 4 Skill: Supernova"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/supernova
	button_icon_state = "supernova"
	name = "supernova"
	cooldown_time = 12000
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
	granted_action = /datum/action/cooldown/fishing/alignment2
	actionname = "Alignment II"
	name = "Level 4 Skill: Alignment II"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/alignment2
	button_icon_state = "alignment2"
	name = "Alignment II"
	cooldown_time = 18000
	devotion_cost = 35

/datum/action/cooldown/fishing/alignment2/FishEffect(mob/living/user)
	for(var/datum/planet/planet as anything in SSfishing.planets)
		planet.phase = 1

	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("You look up in awe. The planets, they're all aligned!"))
