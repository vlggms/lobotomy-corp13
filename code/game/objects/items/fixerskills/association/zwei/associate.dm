/datum/action/cooldown/yourshield
	name = "Your Shield"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "hunkerdown"
	cooldown_time = 15 SECONDS

/datum/action/cooldown/yourshield/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.physiology.red_mod *= 0.7
		human.physiology.white_mod *= 0.7
		human.physiology.black_mod *= 0.7
		human.physiology.pale_mod *= 0.7
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/yourshield/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.7
	human.physiology.white_mod /= 0.7
	human.physiology.black_mod /= 0.7
	human.physiology.pale_mod /= 0.7

/datum/action/cooldown/standproud
	name = "Stand Proud"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "shield_off"
	cooldown_time = 10 SECONDS


/datum/action/cooldown/standproud/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.status_flags |= GODMODE
		addtimer(CALLBACK(src, PROC_REF(Recall),), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

		human.Immobilize(3 SECONDS)
		new /obj/effect/temp_visual/weapon_stun(get_turf(owner))
		StartCooldown()

/datum/action/cooldown/standproud/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.status_flags &= ~GODMODE
