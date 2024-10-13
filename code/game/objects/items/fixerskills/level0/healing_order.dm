//Heal Order
/obj/item/book/granter/action/skill/heal_order
	granted_action = /datum/action/cooldown/heal_order
	actionname = "Heal Order"
	name = "Level 0 Skill: Heal Order"
	level = 0
	custom_premium_price = 300

/datum/action/cooldown/heal_order
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "healorder"
	name = "Heal Order"
	cooldown_time = 300
	var/healamount = 25

/datum/action/cooldown/heal_order/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(3, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		H.adjustBruteLoss(-healamount)
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#e81ade")
	user.Immobilize(5 SECONDS)
	StartCooldown()
