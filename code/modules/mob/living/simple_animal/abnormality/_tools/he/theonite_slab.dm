#define STATUS_EFFECT_SLAB /datum/status_effect/stacking/slab
/obj/structure/toolabnormality/theonite_slab
	name = "theonite slab"
	desc = "A slab, made out of a seamless mixture of stone and metal. It's covered in runes, and bloody spikes erupt from the centerpiece."
	icon_state = "slab"
	var/list/users = list()

	ego_list = list(
		/datum/ego_datum/weapon/divinity,
		/datum/ego_datum/armor/divinity,
	)

/obj/structure/toolabnormality/theonite_slab/attack_hand(mob/living/carbon/human/user)
	..()
	if(!do_after(user, 6, user))
		return
	if(get_level_buff(user, JUSTICE_ATTRIBUTE) >= 50)
		to_chat(user, span_notice("That's enough."))
		return //You don't need any more.

	flick(icon_state, src)
	user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)
	var/datum/status_effect/stacking/slab/S = user.has_status_effect(/datum/status_effect/stacking/slab)
	if(!(user in users))
		users += user
	else
		user.physiology.pale_mod *= 1.07
		if(S)
			S.add_stacks(1)

	user.apply_status_effect(STATUS_EFFECT_SLAB)
	to_chat(user, span_userdanger("You caress the slab, and blood painlessly flows from your fingers. The runes begin to glow."))

// Status Effect
/datum/status_effect/stacking/slab
	id = "stacking_slab"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 10
	consumed_on_threshold = FALSE
	var/punishment_cooldown
	var/punishment_cooldown_time = 5 SECONDS
	var/punishment_size

/datum/status_effect/stacking/slab/on_apply()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(Punishment))
	return ..()

/datum/status_effect/stacking/slab/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/datum/status_effect/stacking/slab/proc/Punishment(mob/living/carbon/human/owner, damage, damagetype, def_zone)
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
	punishment_size = round(stacks / 3)
	punishment_cooldown = world.time + punishment_cooldown_time
	playsound(H, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 35, TRUE, 3)
	var/turf/R = get_turf(H)
	for(var/turf/T in view(punishment_size, R))
		new /obj/effect/temp_visual/pale_eye_attack(T)
	addtimer(CALLBACK(src, PROC_REF(PunishHit), R, damage, damagetype), clamp(punishment_size, 1, 2) SECONDS)

/datum/status_effect/stacking/slab/proc/PunishHit(turf/R, damage, damagetype)
	for(var/turf/T in view(punishment_size, R))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/M in T)
			if(ishuman(M)) //deals damage to non-humans, and humans - but only humans with the status effect.
				var/mob/living/carbon/human/H = M
				var/datum/status_effect/stacking/slab/S = H.has_status_effect(/datum/status_effect/stacking/slab)
				if(!S)
					continue
			M.apply_damage(damage, PALE_DAMAGE, null, M.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			if(M.health < 0)
				PunishDeath(M)
	playsound(R, 'sound/weapons/fixer/generic/blade3.ogg', 55, TRUE, 3)

/datum/status_effect/stacking/slab/proc/PunishDeath(mob/living/M)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	new /obj/effect/temp_visual/cult/blood/out(get_turf(H))
	playsound(H, 'sound/effects/ordeals/violet/midnight_black_attack2.ogg', 35, TRUE, 3)
	H.gib()

#undef STATUS_EFFECT_SLAB
