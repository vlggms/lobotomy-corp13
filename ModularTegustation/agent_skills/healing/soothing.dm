//Curing
/datum/action/cooldown/agent_soothing
	name = "Soothing"
	desc = "Heal all humans in a 5 tile radius (except the user) by 15 SP. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "soothing"
	cooldown_time = 30 SECONDS
	var/healamount = 15

/datum/action/cooldown/agent_soothing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	for(var/mob/living/carbon/human/H in view(5, get_turf(src)))
		if(H.stat >= HARD_CRIT)
			continue
		if(H == owner)
			H.adjustSanityLoss(10)
			continue
		H.adjustSanityLoss(-healamount)	//Healing for those around.
		new /obj/effect/temp_visual/heal(get_turf(H), "#6E6EFF")
	StartCooldown()

