/datum/action/cooldown/parry
	name = "Parry"
	desc = "Parry 90% of damage for 1 second. Immobilize for 3 seconds. Costs 10 SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "parry"
	cooldown_time = 30 SECONDS


/datum/action/cooldown/parry/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.adjustSanityLoss(10)
		human.physiology.red_mod *= 0.1
		human.physiology.white_mod *= 0.1
		human.physiology.black_mod *= 0.1
		human.physiology.pale_mod *= 0.1
		addtimer(CALLBACK(src, PROC_REF(Recall),), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

		human.Immobilize(3 SECONDS)
		new /obj/effect/temp_visual/weapon_stun(get_turf(owner))
		StartCooldown()

/datum/action/cooldown/parry/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.1
	human.physiology.white_mod /= 0.1
	human.physiology.black_mod /= 0.1
	human.physiology.pale_mod /= 0.1
