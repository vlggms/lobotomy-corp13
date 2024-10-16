//Scry
/obj/item/book/granter/action/skill/scry
	granted_action = /datum/action/cooldown/fishing/scry
	actionname = "Scry"
	name = "Level 1 Skill: Scry"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/scry
	icon_icon = 'icons/hud/screen_skills.dmi'
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

	if(SSfishing.Mercury == 2)
		to_chat(user, span_notice("Mercury is in alignment with earth."))
	if(SSfishing.Venus == 3)
		to_chat(user, span_notice("Venus is in alignment with earth."))
	if(SSfishing.Mars == 4)
		to_chat(user, span_notice("Mars is in alignment with earth."))
	if(SSfishing.Jupiter == 5)
		to_chat(user, span_notice("Jupiter is in alignment with earth."))
	if(SSfishing.Saturn == 6)
		to_chat(user, span_notice("Saturn is in alignment with earth."))
	if(SSfishing.Uranus == 7)
		to_chat(user, span_notice("Uranus is in alignment with earth."))
	if(SSfishing.Neptune == 8)
		to_chat(user, span_notice("Neptune is in alignment with earth."))


//Detect Fish
//A useless skill, made to be funny
/obj/item/book/granter/action/skill/detect
	granted_action = /datum/action/cooldown/fishing/detect
	actionname = "Detect Fish"
	name = "Level 1 Skill: Detect Fish"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/detect
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "detect"
	name = "Detect Fish"
	cooldown_time = 300
	devotion_cost = 1

/datum/action/cooldown/fishing/detect/FishEffect(mob/living/user)
	var/turf/orgin = get_turf(owner)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	for(var/turf/T in all_turfs)
		if(istype(T, /turf/open/water/deep))
			to_chat(user, span_notice("Yep, there's fish nearby."))


//Planetary Momentum
/obj/item/book/granter/action/skill/planet
	granted_action = /datum/action/cooldown/fishing/planet
	actionname = "Planet"
	name = "Level 1 Skill: Planet"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/planet
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "planet"
	name = "planet"
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


//Prayer
/obj/item/book/granter/action/skill/prayer
	granted_action = /datum/action/cooldown/fishing/prayer
	actionname = "Lunar Prayer"
	name = "Level 1 Skill: Lunar Prayer"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/prayer
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "prayer"
	name = "prayer"
	cooldown_time = 300
	devotion_cost = 3
	var/healamount = 5

/datum/action/cooldown/fishing/prayer/FishEffect(mob/living/user)
	healamount*=SSfishing.moonphase
	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		H.adjustBruteLoss(-healamount)
		new /obj/effect/temp_visual/heal(get_turf(H), "#CCCCCC")




//Sacred Word
/obj/item/book/granter/action/skill/sacredword
	granted_action = /datum/action/cooldown/fishing/sacredword
	actionname = "Sacred Word"
	name = "Level 1 Skill: Sacred Word"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/sacredword
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "sacredword"
	name = "Sacred Word"
	cooldown_time = 6000
	devotion_cost = 0

/datum/action/cooldown/fishing/sacredword/FishEffect(mob/living/user)
	switch(user.god_aligned)
		if(FISHGOD_MERCURY)
			if(SSfishing.Mercury == 2)
				user.devotion+=4
				to_chat(user, span_notice("Lir hears your words."))

		if(FISHGOD_VENUS)
			if(SSfishing.Venus == 3)
				user.devotion+=6
				to_chat(user, span_notice("Tefnut hears your words."))

		if(FISHGOD_MARS)
			if(SSfishing.Mars == 4)
				user.devotion+=8
				to_chat(user, span_notice("Arnapkapfaaluk hears your words."))

		if(FISHGOD_JUPITER)
			if(SSfishing.Jupiter == 5)
				user.devotion+=10
				to_chat(user, span_notice("Susanoo hears your words."))

		if(FISHGOD_SATURN)
			if(SSfishing.Saturn == 6)
				user.devotion+=12
				to_chat(user, span_notice("Kukulkan hears your words."))

		if(FISHGOD_URANUS)
			if(SSfishing.Uranus == 7)
				user.devotion+=14
				to_chat(user, span_notice("Abena Mansa hears your words."))

		if(FISHGOD_NEPTUNE)
			if(SSfishing.Neptune == 8)
				user.devotion+=16
				to_chat(user, span_notice("Glaucus hears your words."))
		else
			to_chat(user, span_notice("Your planet is misaligned. Your prayer goes unanswered."))
