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
	to_chat(user, span_notice("You shift your deity's planet to align with earth."))
	switch(user.god_aligned)
		if(FISHGOD_MERCURY)
			if(SSfishing.Mercury>0)	//I never remembered that you could reform planets technically with alignment
				SSfishing.Mercury=2

		if(FISHGOD_VENUS)
			if(SSfishing.Venus>0)
				SSfishing.Venus=3

		if(FISHGOD_MARS)
			if(SSfishing.Mars>0)
				SSfishing.Mars=4

		if(FISHGOD_JUPITER)
			if(SSfishing.Jupiter>0)
				SSfishing.Jupiter=5

		if(FISHGOD_SATURN)
			if(SSfishing.Saturn>0)
				SSfishing.Saturn=6

		if(FISHGOD_URANUS)
			if(SSfishing.Uranus>0)
				SSfishing.Uranus=7

		if(FISHGOD_NEPTUNE)
			if(SSfishing.Neptune>0)
				SSfishing.Neptune=8


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

/datum/action/cooldown/fishing/alignment2/FishEffect(mob/living/user
	if(SSfishing.Mercury>0)	//I never remembered that you could reform planets technically with alignment
		SSfishing.Mercury=2

	if(SSfishing.Venus>0)
		SSfishing.Venus=3

	if(SSfishing.Mars>0)
		SSfishing.Mars=4

	if(SSfishing.Jupiter>0)
		SSfishing.Jupiter=5

	if(SSfishing.Saturn>0)
		SSfishing.Saturn=6

	if(SSfishing.Uranus>0)
		SSfishing.Uranus=7

	if(SSfishing.Neptune>0)
		SSfishing.Neptune=8

	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("You look up in awe. The planets, they're all aligned!"))

