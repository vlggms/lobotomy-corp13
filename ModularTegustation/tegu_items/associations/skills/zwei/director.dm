/datum/action/cooldown/flexsuppress
	name = "Flexible Suppression"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "reflexslash"
	cooldown_time = 5 MINUTES
	var/range = 2
	var/list/affected = list()

/datum/action/cooldown/flexsuppress/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if(owner.stat > SOFT_CRIT)
		to_chat(owner, span_userdanger("You are too weak to protect those around you..."))
		return FALSE

	var/mob/living/carbon/human/skilluser = owner

	for(var/mob/living/target in view(range, get_turf(src)))
		if(target.stat == DEAD) // theyre already dead whats wrong with you
			continue
		if (target == owner)
			continue
		if(target.maxHealth >= skilluser.maxHealth)
			new /obj/effect/temp_visual/slice(get_turf(target))
			target.adjustBruteLoss(target.maxHealth*0.3, TRUE, TRUE)
		target.add_movespeed_modifier(/datum/movespeed_modifier/retreat)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/flexsuppress), 3 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

	owner.visible_message(span_userdanger("[owner] in a instant applies a precision strike pinning down their opponent!"), span_warning("You pin down your opponent masterfully!"))
	StartCooldown()

/datum/movespeed_modifier/flexsuppress
	variable = TRUE
	multiplicative_slowdown = 0.4
