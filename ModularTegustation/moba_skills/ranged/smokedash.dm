//Smokedash
/datum/action/cooldown/agent_smokedash
	name = "Smoke bomb"
	desc = "Drop a smoke bomb at your feet, and increase speed for 2 seconds. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smokedash"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/agent_smokedash/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//increase speed
	var/mob/living/carbon/human/human = owner
	human.adjustSanityLoss(10)
	human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/assault), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

	//drop a bit of smoke
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(4, get_turf(human))	//Make the smoke bigger
	S.start()
	qdel(S)
	StartCooldown()
