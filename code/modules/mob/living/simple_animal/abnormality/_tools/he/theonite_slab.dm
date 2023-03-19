#define STATUS_EFFECT_SLAB /datum/status_effect/slab
/obj/structure/toolabnormality/theonite_slab
	name = "theonite slab"
	desc = "A slab, made out of a seamless mixture of stone and metal. It's covered in runes, and bloody spikes erupt from the centerpiece."
	icon_state = "slab"
	var/list/users = list()

/obj/structure/toolabnormality/theonite_slab/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, JUSTICE_ATTRIBUTE) >= 50)
		to_chat(user, "<span class='notice'>That's enough.</span>")
		return //You don't need any more.

	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)
	if(!(user in users))
		users += user
	else
		user.physiology.pale_mod *= 1.15

	user.apply_status_effect(STATUS_EFFECT_SLAB)
	to_chat(user, "<span class='userdanger'>You caress the spikes, and blood flows painlessly. The runes begin to glow.</span>")

// Status Effect
/datum/status_effect/slab
	id = "slab"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	var/punishment_cooldown
	var/punishment_cooldown_time = 5 SECONDS

/datum/status_effect/slab/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, .proc/Punishment)
	return ..()

/datum/status_effect/slab/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/datum/status_effect/slab/proc/Punishment(mob/living/carbon/human/owner, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(punishment_cooldown > world.time)
		return
	if(damage < 15 && damagetype != PALE_DAMAGE)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(H.health < 0)
		PunishDeath(H)
		return
	punishment_cooldown = world.time + punishment_cooldown_time
	playsound(H, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 35, TRUE, 3)
	var/turf/R = get_turf(H)
	addtimer(CALLBACK(src, .proc/PunishHit, R, damage, damagetype), 8)

/datum/status_effect/slab/proc/PunishHit(turf/R, damage, damagetype)
	for(var/turf/T in view(2, R))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/carbon/human/H in T)
			var/datum/status_effect/slab/S = H.has_status_effect(/datum/status_effect/slab)
			if(!S)
				continue
			H.apply_damage(damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if(H.health < 0)
				PunishDeath(H)
	playsound(R, 'sound/effects/ordeals/white/pale_teleport_in.ogg', 35, TRUE, 3)

/datum/status_effect/slab/proc/PunishDeath(mob/living/carbon/human/H)
	new /obj/effect/temp_visual/cult/blood/out(get_turf(H))
	playsound(H, 'sound/effects/ordeals/violet/midnight_black_attack2.ogg', 35, TRUE, 3)
	H.gib()

#undef STATUS_EFFECT_SLAB
