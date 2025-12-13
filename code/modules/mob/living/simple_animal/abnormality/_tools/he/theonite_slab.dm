#define STATUS_EFFECT_SLAB /datum/status_effect/stacking/slab
/obj/structure/toolabnormality/attribute_giver/theonite_slab
	name = "theonite slab"
	desc = "A slab, made out of a seamless mixture of stone and metal. It's covered in runes, and bloody spikes erupt from the centerpiece."
	icon_state = "slab"
	var/list/users = list()

	max_boost = 50
	given_attribute = JUSTICE_ATTRIBUTE
	given_status_effect = STATUS_EFFECT_SLAB
	feedback_message = "You caress the slab, and blood painlessly flows from your fingers. The runes begin to glow."
	full_boost_message = "That's enough."

	ego_list = list(
		/datum/ego_datum/weapon/divinity,
		/datum/ego_datum/armor/divinity,
	)

/obj/structure/toolabnormality/attribute_giver/theonite_slab/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return

	flick(icon_state, src)

	if(used_by[user] == 1) // Lets start effects AFTER their first use
		return

	user.physiology.pale_mod *= 1.06
	var/datum/status_effect/stacking/slab/status_effect = user.has_status_effect(/datum/status_effect/stacking/slab)
	status_effect.add_stacks(1)

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
	if(H.is_working)
		return
	if(H.health < 0)
		PunishDeath(H)
		return
	punishment_size = round(stacks / 3)
	punishment_cooldown = world.time + punishment_cooldown_time
	var/flipped_dir = turn(H.dir, 180)
	var/turf/T = get_step(H, flipped_dir)
	var/obj/effect/temp_visual/theonite_clone/attack = new(T, damage, H, punishment_size)
	attack.dir = H.dir
	playsound(attack, 'sound/effects/ordeals/white/pale_teleport_out.ogg', 50, TRUE, 3)

/datum/status_effect/stacking/slab/proc/PunishDeath(mob/living/M)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	new /obj/effect/temp_visual/cult/blood/out(get_turf(H))
	playsound(H, 'sound/effects/ordeals/violet/midnight_black_attack2.ogg', 35, TRUE, 3)
	H.gib()

//Clone object
/obj/effect/temp_visual/theonite_clone
	name = "???"
	desc = "A shadowy figure"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "alriune_unused"
	duration = 40
	layer = RIPPLE_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.
	var/damage = 10 //Pale Damage - decided later
	var/new_damage = 0
	var/target = null
	var/wide_slash_range = 2
	var/new_range
	var/wide_slash_angle = 300

/obj/effect/temp_visual/theonite_clone/Initialize(mapload, new_damage, target, new_range)
	. = ..()
	var/icon/I = icon(icon, icon_state, dir)
	I = getStaticIcon(I)
	icon = I
	color = COLOR_VERY_SOFT_YELLOW
	if(target)
		damage = new_damage
		wide_slash_range = max(new_range, 2)
		addtimer(CALLBACK(src, PROC_REF(WideSlash), target), 1)

/obj/effect/temp_visual/theonite_clone/proc/WideSlash(atom/target)
	if(!istype(target) || QDELETED(target))
		return
	var/turf/TT = get_turf(target)
	var/turf/T = get_turf(src)
	var/rotate_dir = pick(1, -1)
	var/angle_to_target = Get_Angle(T, TT)
	var/angle = angle_to_target + (wide_slash_angle * rotate_dir) * 0.5
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, T, wide_slash_range)
	var/list/line = getline(T, T2)
	for(var/i = 1 to 20)
		angle += ((wide_slash_angle / 20) * rotate_dir)
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, T, wide_slash_range)
		line = getline(T, T2)
		DoLineWarning(line, i)

/obj/effect/temp_visual/theonite_clone/proc/DoLineWarning(list/line, i)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/pale_eye_attack) in T)
			continue
		new /obj/effect/temp_visual/pale_eye_attack(T)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line), i * 0.04 + (clamp(wide_slash_range/2, 1, 2) SECONDS))

/obj/effect/temp_visual/theonite_clone/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/smash_effect) in T)
			continue
		playsound(T, 'sound/weapons/fixer/generic/blade3.ogg', 55, TRUE, 3)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/M in T)
			if(!ishuman(M))
				M.deal_damage(damage, PALE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
				continue
			var/mob/living/carbon/human/H = M //deals damage to non-humans, and humans - but only humans with the status effect.
			var/datum/status_effect/stacking/slab/S = H.has_status_effect(/datum/status_effect/stacking/slab)
			if(!S)
				continue
			M.deal_damage(damage, PALE_DAMAGE, attack_type = (ATTACK_TYPE_SPECIAL))
			if(M.health < 0)
				S.PunishDeath(M)

#undef STATUS_EFFECT_SLAB
