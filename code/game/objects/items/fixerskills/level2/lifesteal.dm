//Lifesteal
/obj/item/book/granter/action/skill/lifesteal
	granted_action = /datum/action/cooldown/lifesteal
	actionname = "Lifesteal"
	name = "Level 2 Skill: Lifesteal"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/lifesteal
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "lifesteal"
	name = "Lifesteal"
	cooldown_time = 100
	var/damageamount = 10

/datum/action/cooldown/lifesteal/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	var/mob/living/carbon/human/skilluser = owner

	//Compile people around you
	for(var/mob/living/M in view(2, get_turf(src)))
		new /obj/effect/temp_visual/cult/sparks (get_turf(M))
		M.adjustBruteLoss(10)	//Healing for those around.
		skilluser.adjustBruteLoss(-4)	//Healing for those around.

	for(var/mob/living/carbon/human/M in view(2, get_turf(src)))
		M.adjustSanityLoss(10)	//Healing for those around.
		skilluser.adjustSanityLoss(-4)	//Healing for those around.

	new /obj/effect/temp_visual/heal(get_turf(skilluser), "#E2ED4A")
	StartCooldown()

