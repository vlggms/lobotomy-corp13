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
	duration = -1
	alert_type = null
	display_name = "notes"
	var/damage_counter
	var/damage_max
	var/worked = FALSE
	var/stat_bonus = 0

/datum/status_effect/display/researcher/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	stat_bonus = (0.1 * get_attribute_level(owner, TEMPERANCE_ATTRIBUTE)) //20 + 10% of the user's temperance is added as a bonus
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20 + stat_bonus)
	RegisterSignal(status_holder, COMSIG_MOB_APPLY_DAMGE, PROC_REF(TakeDamage))
	RegisterSignal(status_holder, COMSIG_WORK_COMPLETED, PROC_REF(OnWorkComplete))
	damage_max = (status_holder.maxHealth + status_holder.maxSanity)

/datum/status_effect/display/researcher/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, (-20 - stat_bonus))
	UnregisterSignal(status_holder, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(status_holder, COMSIG_WORK_COMPLETED)
	to_chat(status_holder, span_nicegreen("The research notes vanish."))

/datum/status_effect/display/researcher/proc/OnWorkComplete(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	to_chat(user, span_nicegreen("The research notes have been filled out, it should be safe to return them now."))
	worked = TRUE

/datum/status_effect/display/researcher/proc/TakeDamage(mob/living/carbon/human/user, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage < 0)
		return
	damage_counter += damage //we store the raw damage taken by the player
	if(damage_counter >= damage_max) //if the stored damage exceeds the players maxhealth + maxsanity they explode
		addtimer(CALLBACK(src, PROC_REF(Explode), owner), 1) //Gives damage procs time to process
		return
	if(damage_counter >= (damage_max * 0.8))
		to_chat(owner, span_hypnophrase("You need to return the research notes immediately!"))
		return
	if(damage_counter >= (damage_max * 0.6))
		to_chat(owner, span_userdanger("You feel like you should avoid taking any more damage!"))

/datum/status_effect/display/researcher/proc/Explode(mob/living/carbon/human/owner)
	playsound(get_turf(owner), 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	new /obj/effect/temp_visual/explosion(get_turf(owner))
	var/damage_dealt = clamp(damage_max, 0, 1000) //damage dealt is the original maxhealth+maxsanity stored, it can run anywhere between 200 and >500 typically, capped at 1000
	var/human_damage = (damage_max / 2) //half damage on humans
	for(var/turf/affected_turf in view(3, owner))
		for(var/mob/living/affected_mob in affected_turf)
			if(affected_mob == owner)
				continue
			if(ishuman(affected_mob)) //deals less damage to humans
				var/mob/living/carbon/human/human_mob = affected_mob
				human_mob.deal_damage(human_damage, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
				continue
			affected_mob.deal_damage(damage_dealt, RED_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
	var/datum/effect_system/smoke_spread/smoke_effect = new
	smoke_effect.set_up(7, get_turf(owner))
	smoke_effect.start()
	owner.gib()

#undef STATUS_EFFECT_RESEARCHER
