//Assault
/datum/action/cooldown/assault_agent
	cooldown_time = 20 SECONDS
	name = "Assault"
	desc = "Increase movespeed for 5 seconds. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault"


/datum/action/cooldown/assault_agent/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.adjustSanityLoss(10)
		human.add_movespeed_modifier(/datum/movespeed_modifier/assault_agent)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/assault_agent), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/movespeed_modifier/assault_agent
	variable = TRUE
	multiplicative_slowdown = -0.2
