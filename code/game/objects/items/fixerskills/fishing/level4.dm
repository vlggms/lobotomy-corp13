//Align
/obj/item/book/granter/action/skill/alignment
	granted_action = /datum/action/cooldown/fishing/alignment
	actionname = "Alignment"
	name = "Level 4 Skill: Alignment"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/alignment
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "alignment"
	name = "alignment"
	cooldown_time = 6000
	devotion_cost = 15

/datum/action/cooldown/fishing/alignment/FishEffect(mob/living/user)
	to_chat(user, span_notice("You shift your deity's planet to align with earth."))
	switch(user.god_aligned)
		if(FISHGOD_MERCURY)
			SSfishing.Mercury=2

		if(FISHGOD_VENUS)
			SSfishing.Venus=3

		if(FISHGOD_MARS)
			SSfishing.Mars=4

		if(FISHGOD_JUPITER)
			SSfishing.Jupiter=5

		if(FISHGOD_SATURN)
			SSfishing.Saturn=6

		if(FISHGOD_URANUS)
			SSfishing.Uranus=7

		if(FISHGOD_NEPTUNE)
			SSfishing.Neptune=8


//A Moment in Time
/obj/item/book/granter/action/skill/planetstop
	granted_action = /datum/action/cooldown/fishing/planetstop
	actionname = "A Moment in Time"
	name = "Level 4 Skill: A Moment in Time"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/fishing/planetstop
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "planetstop"
	name = "planetstop"
	cooldown_time = 18000
	devotion_cost = 12

/datum/action/cooldown/fishing/planetstop/FishEffect(mob/living/user)
	to_chat(user, span_notice("You half the planets in their place, letting you bask in their glow a moment more."))
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "supernova"
	name = "supernova"
	cooldown_time = 12000
	devotion_cost = 25

/datum/action/cooldown/fishing/supernova/FishEffect(mob/living/user)
	var/list/display_names = list("Mercury", "Venus", "Mars", "Jupiter" , "Saturn", "Uranus", "Neptune")
	if(!display_names.len)
		return
	var/choice = input(user,"Which planet would you like to destroy?","Supernova") as null|anything in display_names
	if(!choice)
		to_chat(user, span_notice("You stay your hand."))
		return

	switch(choice)
		if("Mercury")
			SSfishing.Mercury = -100
		if("Venus")
			SSfishing.Venus = -100
		if("Mars")
			SSfishing.Mars = -100
		if("Jupiter")
			SSfishing.Jupiter = -100
		if("Saturn")
			SSfishing.Saturn = -100
		if("Uranus")
			SSfishing.Uranus = -100
		if("Neptune")
			SSfishing.Neptune = -100

	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("You look up in awe. [choice] has been blown from the sky."))

