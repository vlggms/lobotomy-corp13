//Healing
/obj/item/book/granter/action/skill/healing
	granted_action = /datum/action/cooldown/healing
	actionname = "Healing"
	name = "Level 1 Skill: Healing"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/healing
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "healing"
	name = "Healing"
	cooldown_time = 300
	var/healamount = 15

/datum/action/cooldown/healing/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "soothing"
	name = "Soothing"
	cooldown_time = 300
	var/healamount = 15

/datum/action/cooldown/soothing/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
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
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "curing"
	name = "Curing"
	cooldown_time = 300
	var/healamount = 5

/datum/action/cooldown/curing/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(2, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		H.adjustBruteLoss(-healamount)
		new /obj/effect/temp_visual/heal(get_turf(H), "#E2ED4A")
	StartCooldown()

