/**
 * This is the proc that handles the order of an item_attack.
 *
 * The order of procs called is:
 * * [/atom/proc/tool_act] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/pre_attack] on src. If this returns TRUE, the chain will be stopped.
 * * [/atom/proc/attackby] on the target. If it returns TRUE, the chain will be stopped.
 * * [/obj/item/proc/afterattack]. The return value does not matter.
 */
/obj/item/proc/melee_attack_chain(mob/user, atom/target, params)
	if(tool_behaviour && target.tool_act(user, src, tool_behaviour))
		return TRUE
	if(pre_attack(target, user, params))
		return TRUE
	if(Sweep(target, user, params))
		return TRUE
	if(QDELETED(src) || QDELETED(target))
		attack_qdeleted(target, user, TRUE, params)
		return TRUE
	return afterattack(target, user, TRUE, params)

/// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	interact(user)

/**
 * Called on the item before it hits something
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack(atom/A, mob/living/user, params) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

/**
 * Called on an object being hit by an item
 *
 * Arguments:
 * * obj/item/W - The item hitting this atom
 * * mob/user - The wielder of this item
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby(obj/item/W, mob/user, params)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, params) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	return FALSE

/obj/attackby(obj/item/I, mob/living/user, params)
	return ..() || ((obj_flags & CAN_BE_HIT) && I.attack_obj(src, user, params))

/mob/living/attackby(obj/item/I, mob/living/user, params)
	if(..())
		return TRUE
	user.changeNext_move(CLICK_CD_MELEE)
	return I.attack(src, user)

/obj/item/proc/Sweep(atom/target, mob/living/carbon/human/user, params)
	if(!istype(user) || user.a_intent != INTENT_HARM || swingstyle == WEAPONSWING_NONE || get_turf(target) == get_turf(user))
		return target.attackby(src, user, params)

	if(!isturf(target) && !ismob(target))
		return target.attackby(src, user, params)

	user.changeNext_move(CLICK_CD_MELEE * 0.75) // Room for those who miss

	var/list/hit_turfs = list()

	if(swingstyle >= WEAPONSWING_THRUST)
		hit_turfs = get_thrust_turfs(target, user)
	else
		hit_turfs = get_sweep_turfs(target, user)

	var/list/potential_targets = list()

	for(var/turf/T in hit_turfs)
		for(var/mob/M in T)
			if(istype(M, /mob/living/simple_animal/projectile_blocker_dummy))
				var/mob/living/simple_animal/projectile_blocker_dummy/pbd = M
				M = pbd.parent
			potential_targets |= M

	potential_targets -= user

	var/mob/to_smack = GetTarget(user, potential_targets, target)

	if(!to_smack)
		SweepMiss(target, user)
		return TRUE

	var/old_animation = run_item_attack_animation
	run_item_attack_animation = FALSE
	. = to_smack.attackby(src, user, params)
	run_item_attack_animation = old_animation

	log_combat(user, target, "swung at", src.name, " and hit [to_smack]")
	add_fingerprint(user)
	return

/obj/item/proc/SweepMiss(atom/target, mob/living/carbon/human/user)
	user.visible_message(span_danger("[user] [swingstyle > WEAPONSWING_LARGESWEEP ? "thrusts" : "swings"] at [target]!"),\
		span_danger("You [swingstyle > WEAPONSWING_LARGESWEEP ? "thrust" : "swing"] at [target]!"), null, COMBAT_MESSAGE_RANGE, user)
	playsound(src, 'sound/weapons/thudswoosh.ogg', 60, TRUE)
	user.do_attack_animation(target, used_item = src, no_effect = TRUE)

/obj/item/proc/GetTarget(mob/user, list/potential_targets = list(), atom/clicked)
	if(ismob(clicked))
		. = clicked

	for(var/mob/living/simple_animal/hostile/H in potential_targets) // Hostile List
		if(.)
			break
		if(H.status_flags & GODMODE)
			continue
		if(user.faction_check_mob(H))
			continue
		if(H.stat == DEAD)
			continue
		. = H
		break

	for(var/mob/living/L in potential_targets) // Standing List
		if(.)
			break
		if(L.resting)
			continue
		if(L.stat == DEAD)
			continue
		. = L
		break

	for(var/mob/living/L in potential_targets) // Laying Down List
		if(.)
			break
		. = L
		break

	return

/obj/item/proc/get_sweep_turfs(atom/target, mob/user)
	var/target_turf = get_step_towards(user, target)
	// Icon Setup
	var/swipe_icon = "swipe_"
	if(user.active_hand_index % 2 == 0)
		swipe_icon += "r"
	else
		swipe_icon += "l"

	if(swingstyle == WEAPONSWING_LARGESWEEP)
		swipe_icon += "_large"
		var/start = WEST
		var/end = EAST

		switch(get_dir(user, target))
			if(NORTH)
				start = EAST
				end = WEST
			if(SOUTH)
				start = WEST
				end = EAST
			if(EAST)
				start = SOUTH
				end = NORTH
			if(WEST)
				start = NORTH
				end = SOUTH
			if(NORTHEAST)
				start = SOUTH
				end = WEST
			if(NORTHWEST)
				start = EAST
				end = SOUTH
			if(SOUTHEAST)
				start = WEST
				end = NORTH
			if(SOUTHWEST)
				start = NORTH
				end = EAST

		if((user.get_held_index_of_item(src) % 2) - 1) // What hand we're in determines the check order of our swing
			var/temp = start
			start = end
			end = temp

		. = list(get_step(target_turf, start), target_turf, get_step(target_turf, end))
	else
		. = list(target_turf)

	new /obj/effect/temp_visual/swipe(get_step(user, SOUTHWEST), get_dir(user, target), swingcolor ? swingcolor : COLOR_GRAY, swipe_icon)

	return

/obj/item/proc/get_thrust_turfs(atom/target, mob/user)
	. = getline(get_step_towards(user, target), target)
	for(var/turf/T in .)
		var/obj/effect/temp_visual/thrust/TT = new(T, swingcolor ? swingcolor : COLOR_GRAY)
		var/matrix/M = matrix(TT.transform)
		M.Turn(Get_Angle(user, target)-90)
		TT.transform = M
	return

/**
 * Called from [/mob/living/proc/attackby]
 *
 * Arguments:
 * * mob/living/M - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 */
/obj/item/proc/attack(mob/living/M, mob/living/user)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user)
	if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(signal_return & COMPONENT_SKIP_ATTACK)
		return

	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user)

	if(item_flags & NOBLUDGEON)
		return

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
		return

	if(item_flags & EYE_STAB && user.zone_selected == BODY_ZONE_PRECISE_EYES)
		if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
			M = user
		if(eyestab(M,user))
			return
	if(!force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), TRUE, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey

	if(force && M == user && user.client)
		user.client.give_award(/datum/award/achievement/misc/selfouch, user)

	user.do_attack_animation(M, no_effect = !run_item_attack_animation)
	M.attacked_by(src, user)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	add_fingerprint(user)


/// The equivalent of the standard version of [/obj/item/proc/attack] but for object targets.
/obj/item/proc/attack_obj(obj/O, mob/living/user, params)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, O, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return
	if(item_flags & NOBLUDGEON)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(O)
	O.attacked_by(src, user)

/// Called from [/obj/item/proc/attack_obj] and [/obj/item/proc/attack] if the attack succeeds
/atom/movable/proc/attacked_by()
	return

/obj/attacked_by(obj/item/I, mob/living/user)
	if(I.force)
		user.visible_message("<span class='danger'>[user] hits [src] with [I]!</span>", \
					"<span class='danger'>You hit [src] with [I]!</span>", null, COMBAT_MESSAGE_RANGE)
		//only witnesses close by and the victim see a hit message.
		log_combat(user, src, "attacked", I)
	take_damage(I.force, I.damtype, 1)

/mob/living/attacked_by(obj/item/I, mob/living/user)
	send_item_attack_message(I, user)
	if(I.force)
		var/justice_mod = 1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
		var/damage = I.force * justice_mod
		damage *= I.force_multiplier
		apply_damage(damage, I.damtype, white_healable = TRUE)
		if(I.damtype in list(RED_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
			if(prob(33))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(src)
		return TRUE //successful attack

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user)
	if(!attack_threshold_check(I.force, I.damtype, FALSE))
		playsound(loc, 'sound/weapons/tap.ogg', I.get_clamped_volume(), TRUE, -1)
	else
		return ..()

/obj/vehicle/sealed/mecha/attacked_by(obj/item/I, mob/living/user)
	if(I.force)
		user.visible_message(span_danger("[user] hits [src] with [I]!"), span_danger("You hit [src] with [I]!"), null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "attacked", I)
		var/justice_mod = 1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
		var/damage = I.force * justice_mod
		damage *= I.force_multiplier
		take_damage(damage, I.damtype, attack_dir = get_dir(src, user))
		return TRUE

/**
 * Last proc in the [/obj/item/proc/melee_attack_chain]
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * proximity_flag - is 1 if this afterattack was called on something adjacent, in your square, or on your person.
 * * click_parameters - is the params string from byond [/atom/proc/Click] code, see that documentation.
 */
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)

/// Called if the target gets deleted by our attack
/obj/item/proc/attack_qdeleted(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area, obj/item/bodypart/hit_bodypart)
	if(!I.force && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
		return
	var/message_verb_continuous = length(I.attack_verb_continuous) ? "[pick(I.attack_verb_continuous)]" : "attacks"
	var/message_verb_simple = length(I.attack_verb_simple) ? "[pick(I.attack_verb_simple)]" : "attack"
	var/message_hit_area = ""
	if(hit_area)
		message_hit_area = " in the [hit_area]"
	var/attack_message_spectator = "[src] [message_verb_continuous][message_hit_area] with [I]!"
	var/attack_message_victim = "You're [message_verb_continuous][message_hit_area] with [I]!"
	var/attack_message_attacker = "You [message_verb_simple] [src][message_hit_area] with [I]!"
	if(user in viewers(src, null))
		attack_message_spectator = "[user] [message_verb_continuous] [src][message_hit_area] with [I]!"
		attack_message_victim = "[user] [message_verb_continuous] you[message_hit_area] with [I]!"
	if(user == src)
		attack_message_victim = "You [message_verb_simple] yourself[message_hit_area] with [I]"
	visible_message("<span class='danger'>[attack_message_spectator]</span>",\
		"<span class='userdanger'>[attack_message_victim]</span>", null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='danger'>[attack_message_attacker]</span>")
	return 1

/obj/effect/temp_visual/swipe
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	duration = 4
	randomdir = FALSE
	alpha = 200

/obj/effect/temp_visual/swipe/New(loc, ...)
	. = ..()
	setDir(args[2])
	if(args[3])
		color = args[3]
	flick(args[4], src) // if this isn't used, it synchronizes all swipe animations.

/obj/effect/temp_visual/thrust
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	duration = 4
	randomdir = FALSE
	pixel_x = -16
	alpha = 200

/obj/effect/temp_visual/thrust/New(loc, ...)
	. = ..()
	if(args[2])
		color = args[2]
	flick("thrust", src)
