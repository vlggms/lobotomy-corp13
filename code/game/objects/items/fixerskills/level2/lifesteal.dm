//Lifesteal
/obj/item/book/granter/action/skill/lifesteal
	granted_action = /datum/action/cooldown/lifesteal
	actionname = "Lifesteal"
	name = "Level 2 Skill: Lifesteal"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/lifesteal
	name = "Lifesteal"
	desc = "Steal health and sanity from everyone alive around you in a 5x5 tile radious."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "lifesteal"
	cooldown_time = 10 SECONDS
	var/damageamount = 10

/datum/action/cooldown/lifesteal/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if(owner.stat > SOFT_CRIT)
		to_chat(owner, span_userdanger("You are too weak to steal life from people around you..."))
		return FALSE

	var/mob/living/carbon/human/skilluser = owner

	for(var/mob/living/victim in oview(2, get_turf(src)))
		if(victim.stat == DEAD) // what are you going to take from them?
			continue

		new /obj/effect/temp_visual/cult/sparks(get_turf(victim))
		victim.adjustBruteLoss(20)
		skilluser.adjustBruteLoss(-15)
		if(ishuman(victim))
			var/mob/living/carbon/human/double_victim = victim
			double_victim.adjustSanityLoss(20)
			skilluser.adjustSanityLoss(-15)

	owner.visible_message(span_userdanger("tiny cuts form on everyone around [owner], their blood flowing to [owner]'s injuries!"), span_warning("You absorb life from everyone around you!"))
	new /obj/effect/temp_visual/heal(get_turf(skilluser), "#E2ED4A")
	StartCooldown()
