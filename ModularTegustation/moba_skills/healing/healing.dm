//Curing
/datum/action/cooldown/agent_healing
	name = "Healing"
	desc = "Heal all humans in a 5 tile radius (except the user) by 10% of their max HP."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "healing"
	cooldown_time = 30 SECONDS
	var/healamount = 0.1 //This is a %

/datum/action/cooldown/agent_healing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(5, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		if(H == owner)
			continue
		H.adjustBruteLoss(-H.maxHealth*healamount)
		new /obj/effect/temp_visual/heal(get_turf(H), "#FF4444")
	StartCooldown()

