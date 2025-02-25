/datum/action/cooldown/hunkerdown_agent
	name = "Hunker Down"
	desc = "Decrease movespeed and increase defenses for 10 seconds. Costs 10 SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "hunkerdown"
	cooldown_time = 30 SECONDS


/datum/action/cooldown/hunkerdown_agent/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.adjustSanityLoss(10)
		human.add_movespeed_modifier(/datum/movespeed_modifier/hunkerdown)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/hunkerdown), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 0.6
		human.physiology.white_mod *= 0.6
		human.physiology.black_mod *= 0.6
		human.physiology.pale_mod *= 0.6
		addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/hunkerdown_agent/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.6
	human.physiology.white_mod /= 0.6
	human.physiology.black_mod /= 0.6
	human.physiology.pale_mod /= 0.6

