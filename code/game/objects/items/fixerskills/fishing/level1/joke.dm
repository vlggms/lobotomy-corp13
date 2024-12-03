//Detect Fish
//A useless skill, made to be funny
/obj/item/book/granter/action/skill/detect
	granted_action = /datum/action/cooldown/fishing/detect
	actionname = "Detect Fish"
	name = "Level 1 Skill: Detect Fish"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/detect
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
			return

	to_chat(user, span_notice("There's no fish nearby."))


//Fish Lockpick
//Opens any fish-shaped lock
/obj/item/book/granter/action/skill/fishlockpick
	granted_action = /datum/action/cooldown/fishing/fishlockpick
	actionname = "Fish Lockpick"
	name = "Level 1 Skill: Fish Lockpick"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/fishlockpick
	button_icon_state = "fishlockpick"
	name = "Fish Lockpick"
	cooldown_time = 300
	devotion_cost = 1

/datum/action/cooldown/fishing/fishlockpick/FishEffect(mob/living/user)
	to_chat(user, span_notice("All nearby fish-shaped locks have been opened."))


//Fish Telepathy
//Commune with the fish. Basically fishing
/obj/item/book/granter/action/skill/fishtelepathy
	granted_action = /datum/action/cooldown/fishing/fishtelepathy
	actionname = "Fish Telepathy"
	name = "Level 1 Skill: Fish Telepathy"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishing/fishtelepathy
	button_icon_state = "fishtelepathy"
	name = "Fish Telepathy"
	cooldown_time = 400
	devotion_cost = 1

/datum/action/cooldown/fishing/fishtelepathy/FishEffect(mob/living/user)
	var/turf/orgin = get_turf(owner)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	for(var/turf/T in all_turfs)
		if(istype(T, /turf/open/water/deep))
			to_chat(user, span_notice("You commune with the fish, stand by for a response."))
			addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
			return
	to_chat(user, span_notice("There's no fish nearby."))


/datum/action/cooldown/fishing/fishtelepathy/proc/Recall(mob/living/carbon/human/user)
	to_chat(user, span_notice("The fish have crucial news for you:"))
	to_chat(user, span_notice("Glub."))
	user.devotion+=2

