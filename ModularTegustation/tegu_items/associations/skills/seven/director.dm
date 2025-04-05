/datum/action/cooldown/exploitgap
	name = "Exploit the Gap"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "quickslash"
	cooldown_time = 90 SECONDS
	var/list/affected = list()
	var/range = 1
	var/affect_self = FALSE

/datum/action/cooldown/exploitgap/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//increase speed
	if (ishuman(owner))
		owner.add_movespeed_modifier(/datum/movespeed_modifier/exploitgap)
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/exploitgap), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		addtimer(CALLBACK(src, PROC_REF(GapSpotted)), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/action/cooldown/exploitgap/proc/GapSpotted()
	owner.say("You're full of gaps.")
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human.stat == DEAD)
			continue
		if (human == owner && !affect_self)
			continue
		human.physiology.red_mod *= 1.2
		human.physiology.white_mod *= 1.2
		human.physiology.black_mod *= 1.2
		human.physiology.pale_mod *= 1.2
		affected+= human

	addtimer(CALLBACK(src, PROC_REF(Recall)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/action/cooldown/exploitgap/proc/Recall()
	for(var/mob/living/carbon/human/human in affected)
		human.physiology.red_mod /= 1.2
		human.physiology.white_mod /= 1.2
		human.physiology.black_mod /= 1.2
		human.physiology.pale_mod /= 1.2
		affected-= human

/datum/movespeed_modifier/exploitgap
	variable = TRUE
	multiplicative_slowdown = -0.6
