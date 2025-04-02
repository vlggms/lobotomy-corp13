/datum/action/cooldown/flare
	name = "Flare"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "quantum"
	cooldown_time = 70 SECONDS
	var/range = 5

/datum/action/cooldown/flare/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Burn everything around
	for(var/turf/open/T in view(range, get_turf(src)))
		if(locate(/obj/structure/turf_fireliu) in T)
			for(var/obj/structure/turf_fireliu/fire in T)
				qdel(fire)
		new /obj/structure/turf_fireliu(T)
	owner.visible_message(span_warning("[owner] unleashes a wave of flames!"))
	StartCooldown()

/datum/action/cooldown/bspear
	name = "Blast Spear"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault"
	cooldown_time = 20 SECONDS
	var/range = 5
	var/friendcount = 0

/datum/action/cooldown/bspear/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		for(var/mob/living/carbon/human/friend in view(range, get_turf(src)))
			if(friend.ckey && friend.stat != DEAD && friend != owner)
				friendcount++
				var/datum/movespeed_modifier/bspear/speed_mod = new()
				speed_mod.multiplicative_slowdown = -0.05 * friendcount
				owner.add_movespeed_modifier(speed_mod, update = TRUE)
				addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/bspear), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
				addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
				StartCooldown()

/datum/action/cooldown/bspear/proc/Recall()
	friendcount = 0

/datum/movespeed_modifier/bspear
	multiplicative_slowdown = -0.05
	variable = TRUE
