/// A useless* skill, made to be funny
/obj/item/book/granter/action/skill/detect
	name = "Level 1 Skill: Detect Fish"
	actionname = "Detect Fish"
	granted_action = /datum/action/cooldown/detect
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/detect
	name = "Detect Fish"
	button_icon_state = "detect"
	cooldown_time = 30 SECONDS
	devotion_cost = 1

/datum/action/cooldown/detect/FishEffect(mob/living/user)
	var/turf/orgin = get_turf(owner)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	for(var/turf/T in all_turfs)
		if(istype(T, /turf/open/water/deep))
			to_chat(user, span_notice("Yep, there's fish nearby."))
			return

	to_chat(user, span_notice("There's no fish nearby."))


/// Opens any fish-shaped lock
/obj/item/book/granter/action/skill/fishlockpick
	name = "Level 1 Skill: Fish Lockpick"
	actionname = "Fish Lockpick"
	granted_action = /datum/action/cooldown/fishlockpick
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishlockpick
	name = "Fish Lockpick"
	button_icon_state = "fishlockpick"
	cooldown_time = 30 SECONDS
	devotion_cost = 1

/datum/action/cooldown/fishlockpick/FishEffect(mob/living/user)
	to_chat(user, span_notice("All nearby fish-shaped locks have been opened."))

/// Commune with the fish. Basically fishing
/obj/item/book/granter/action/skill/fishtelepathy
	name = "Level 1 Skill: Fish Telepathy"
	actionname = "Fish Telepathy"
	granted_action = /datum/action/cooldown/fishtelepathy
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/fishtelepathy
	name = "Fish Telepathy"
	button_icon_state = "fishtelepathy"
	cooldown_time = 40 SECONDS
	devotion_cost = 1

/datum/action/cooldown/fishtelepathy/FishEffect(mob/living/user)
	var/turf/orgin = get_turf(owner)
	var/list/all_turfs = RANGE_TURFS(2, orgin)
	for(var/turf/T in all_turfs)
		if(istype(T, /turf/open/water/deep))
			to_chat(user, span_notice("You commune with the fish, stand by for a response."))
			addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
			return
	to_chat(user, span_notice("There's no fish nearby."))

/datum/action/cooldown/fishtelepathy/proc/Recall(mob/living/carbon/human/user)
	to_chat(user, span_notice("The fish have crucial news for you:"))
	to_chat(user, span_notice("Glub."))
	user.devotion += 2
