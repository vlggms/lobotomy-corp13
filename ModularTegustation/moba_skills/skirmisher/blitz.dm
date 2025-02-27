
//Retreat

/datum/action/cooldown/blitz
	name = "Blitz"
	desc = "Increase movespeed greatly and decrease defenses for 5 seconds. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "retreat"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/blitz/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.adjustSanityLoss(10)
		human.add_movespeed_modifier(/datum/movespeed_modifier/blitz)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/blitz), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 1.3
		human.physiology.white_mod *= 1.3
		human.physiology.black_mod *= 1.3
		human.physiology.pale_mod *= 1.3
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/blitz/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 1.3
	human.physiology.white_mod /= 1.3
	human.physiology.black_mod /= 1.3
	human.physiology.pale_mod /= 1.3

/datum/movespeed_modifier/blitz
	variable = TRUE
	multiplicative_slowdown = -0.5
