#define STATUS_EFFECT_RESEARCHER /datum/status_effect/display/researcher
/obj/structure/toolabnormality/researcher
	name = "notes from a crazed researcher"
	desc = "A simple notepad with incomprehensible writing on its pages."
	icon_state = "notes"

/obj/structure/toolabnormality/researcher/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6))
		return
	var/datum/status_effect/display/researcher/R = user.has_status_effect(/datum/status_effect/display/researcher)
	if(R)
		if(R.worked == FALSE)
			to_chat(user, span_userdanger("Uh Oh."))
			R.Explode(user)
			return
		else
			user.remove_status_effect(STATUS_EFFECT_RESEARCHER)
	else
		user.apply_status_effect(STATUS_EFFECT_RESEARCHER)
		to_chat(user, span_nicegreen("It's time to work on the abnormalities."))

// Status Effect
/datum/status_effect/display/researcher
	id = "notes"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 MINUTES
	alert_type = null
	display_name = "notes"
	var/damage_counter
	var/damage_max
	var/worked = FALSE

/datum/status_effect/display/researcher/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20)
		RegisterSignal(H, COMSIG_MOB_APPLY_DAMGE, .proc/TakeDamage)
		RegisterSignal(H, COMSIG_WORK_COMPLETED, .proc/OnWorkComplete)
		damage_max = (H.maxHealth + H.maxSanity)

/datum/status_effect/display/researcher/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -20)
		UnregisterSignal(H, COMSIG_MOB_APPLY_DAMGE)
		UnregisterSignal(H, COMSIG_WORK_COMPLETED)
		to_chat(H, span_nicegreen("The research notes vanish."))

/datum/status_effect/display/researcher/proc/OnWorkComplete(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	to_chat(user, span_nicegreen("The research notes have been filled out, the yearn for knowledge has been satisfied."))
	worked = TRUE

/datum/status_effect/display/researcher/proc/TakeDamage(mob/living/carbon/human/user, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage < 0)
		return
	damage_counter += damage //we store the raw damage taken by the player
	if(damage_counter >= (damage_max * 0.6))
		to_chat(owner, span_userdanger("You feel like you should avoid taking any more damage!"))
	if(damage_counter >= damage_max) //if the stored damage exceeds the players maxhealth + maxsanity they explode
		addtimer(CALLBACK(src, .proc/Explode, owner), 1) //Gives damage procs time to process

/datum/status_effect/display/researcher/proc/Explode(mob/living/carbon/human/owner)
	playsound(get_turf(owner), 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	new /obj/effect/temp_visual/explosion(get_turf(owner))
	var/damage_dealt = clamp(damage_max, 0, 1000) //damage dealt is the original maxhealth+maxsanity stored, it can run anywhere between 200 and >500 typically, capped at 1000
	var/human_damage = (damage_max / 2) //half damage on humans
	for(var/turf/T in view(3, owner))
		for(var/mob/living/M in T)
			if(M == owner)
				continue
			if(ishuman(M)) //deals less damage to humans
				var/mob/living/carbon/human/L = M
				L.apply_damage(human_damage, RED_DAMAGE, null, M.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				continue
			M.apply_damage(damage_dealt, RED_DAMAGE, null, M.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(owner))
	S.start()
	owner.gib()

#undef STATUS_EFFECT_RESEARCHER
