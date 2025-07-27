//Healing
/obj/item/book/granter/action/skill/healing
	granted_action = /datum/action/cooldown/healing
	actionname = "Healing"
	name = "Level 1 Skill: Healing"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/healing
	name = "Healing"
	desc = "Heals the HP of all other humans around you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "healing"
	cooldown_time = 30 SECONDS
	var/healamount = 20

/datum/action/cooldown/healing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H == owner)
			continue
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustBruteLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#FF4444")
	StartCooldown()

//Soothing
/obj/item/book/granter/action/skill/soothing
	granted_action = /datum/action/cooldown/soothing
	actionname = "Soothing"
	name = "Level 1 Skill: Soothing"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/soothing
	name = "Soothing"
	desc = "Heals the SP all other humans around you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "soothing"
	cooldown_time = 30 SECONDS
	var/healamount = 20

/datum/action/cooldown/soothing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H == owner)
			continue
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#6E6EFF")
	StartCooldown()


//Curing
/obj/item/book/granter/action/skill/curing
	granted_action = /datum/action/cooldown/curing
	actionname = "Curing"
	name = "Level 1 Skill: Curing"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/curing
	name = "Curing"
	desc = "Heals both HP and SP all other humans around you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "curing"
	cooldown_time = 30 SECONDS
	var/healamount = 10

/datum/action/cooldown/curing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H == owner)
			continue
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		H.adjustBruteLoss(-healamount)
		new /obj/effect/temp_visual/heal(get_turf(H), "#E2ED4A")
	StartCooldown()

