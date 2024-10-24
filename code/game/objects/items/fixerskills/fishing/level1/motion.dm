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
	to_chat(user, span_notice("You shift the movement of your aligned planet by 1."))
	switch(user.god_aligned)
		if(FISHGOD_MERCURY)
			SSfishing.Mercury+=1
			if(SSfishing.Mercury == 3)
				SSfishing.Mercury = 1

		if(FISHGOD_VENUS)
			SSfishing.Venus+=1
			if(SSfishing.Venus == 4)
				SSfishing.Venus = 1

		if(FISHGOD_MARS)
			SSfishing.Mars+=1
			if(SSfishing.Mars == 5)
				SSfishing.Mars = 1

		if(FISHGOD_JUPITER)
			SSfishing.Jupiter+=1
			if(SSfishing.Jupiter == 6)
				SSfishing.Jupiter = 1

		if(FISHGOD_SATURN)
			SSfishing.Saturn+=1
			if(SSfishing.Saturn == 7)
				SSfishing.Saturn = 1

		if(FISHGOD_URANUS)
			SSfishing.Uranus+=1
			if(SSfishing.Uranus == 8)
				SSfishing.Uranus = 1

		if(FISHGOD_NEPTUNE)
			SSfishing.Neptune+=1
			if(SSfishing.Neptune == 9)
				SSfishing.Neptune = 1

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
	var/list/display_names = list("Mercury", "Venus", "Mars", "Jupiter" , "Saturn", "Uranus", "Neptune")
	if(!display_names.len)
		return
	var/choice = input(user,"Which planet would you like to move?","Planet II") as null|anything in display_names
	if(!choice)
		to_chat(user, span_notice("You stay your hand."))
		return

	switch(choice)
		if("Mercury")
			SSfishing.Mercury+=1
			if(SSfishing.Mercury == 3)
				SSfishing.Mercury = 1

		if("Venus")
			SSfishing.Venus+=1
			if(SSfishing.Venus == 4)
				SSfishing.Venus = 1

		if("Mars")
			SSfishing.Mars+=1
			if(SSfishing.Mars == 5)
				SSfishing.Mars = 1

		if("Jupiter")
			SSfishing.Jupiter+=1
			if(SSfishing.Jupiter == 6)
				SSfishing.Jupiter = 1

		if("Saturn")
			SSfishing.Saturn+=1
			if(SSfishing.Saturn == 7)
				SSfishing.Saturn = 1

		if("Uranus")
			SSfishing.Uranus+=1
			if(SSfishing.Uranus == 8)
				SSfishing.Uranus = 1

		if("Neptune")
			SSfishing.Neptune+=1
			if(SSfishing.Neptune == 9)
				SSfishing.Neptune = 1

	to_chat(user, span_nicegreen("[choice] has been moved forwards."))


