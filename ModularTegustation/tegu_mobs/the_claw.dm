/mob/living/simple_animal/hostile/megafauna/claw
	name = "Claw"
	desc = "A strange humanoid creature with several gadgets attached to it."
	health = 8000
	maxHealth = 8000
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 0.4, PALE_DAMAGE = 0.4)
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'ModularTegustation/Tegusounds/claw/attack.ogg'
	icon_state = "claw"
	icon_living = "claw"
	icon_dead = "claw_dead"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	faction = list("hostile", "Head")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	light_color = COLOR_LIGHT_GRAYISH_RED
	light_range = 3
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 75 // Assuming everyone has at least 0.5 red armor
	melee_damage_upper = 85
	stat_attack = HARD_CRIT
	rapid_melee = 2
	ranged = TRUE
	ranged_cooldown_time = 5
	speed = 2
	move_to_delay = 2
	pixel_x = -8
	base_pixel_x = -8
	blood_volume = BLOOD_VOLUME_NORMAL
	gps_name = "NTAF-V"
	del_on_death = FALSE
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'ModularTegustation/Tegusounds/claw/death.ogg'
	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_action_types = list(/datum/action/innate/megafauna_attack/swift_dash,
							   /datum/action/innate/megafauna_attack/swift_dash_long,
							   /datum/action/innate/megafauna_attack/serum_a,
							   /datum/action/innate/megafauna_attack/wide_slash,
							   /datum/action/innate/megafauna_attack/serum_w,
							   /datum/action/innate/megafauna_attack/tri_serum,
							   )
	var/charging = FALSE
	var/dash_damage = 100
	var/dash_num_short = 5
	var/dash_num_long = 18
	var/serumA_damage = 60
	var/wide_slash_damage = 150
	var/wide_slash_range = 5
	var/wide_slash_angle = 120

	var/dash_cooldown = 0
	var/dash_cooldown_time = 5 // cooldown_time * distance:
	// 5 * 5 = 25 (2.5 seconds)
	// 5 * 18 = 90 (9 seconds)
	var/serumA_cooldown = 0
	var/serumA_cooldown_time = 10 SECONDS
	var/wide_slash_cooldown = 0
	var/wide_slash_cooldown_time = 7 SECONDS
	var/serumW_cooldown = 0
	var/serumW_cooldown_time = 30 SECONDS
	var/triserum_cooldown = 0
	var/triserum_cooldown_time = 60 SECONDS

	var/datum/ordeal/ordeal_reference

/datum/action/innate/megafauna_attack/serum_w
	name = "Serum 'W'"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "static"
	chosen_message = span_colossus("You will now jump to random targets in the facility.")
	chosen_attack_num = 1

/datum/action/innate/megafauna_attack/swift_dash
	name = "Swift Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "rift"
	chosen_message = span_colossus("You will now dash forward for a short distance.")
	chosen_attack_num = 2

/datum/action/innate/megafauna_attack/swift_dash_long
	name = "Long Dash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "plasmasoul"
	chosen_message = span_colossus("You will now dash forward for a long distance.")
	chosen_attack_num = 3

/datum/action/innate/megafauna_attack/serum_a
	name = "Serum 'A'"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "impact_laser"
	chosen_message = span_colossus("You will now continously dash towards your target.")
	chosen_attack_num = 4

/datum/action/innate/megafauna_attack/wide_slash
	name = "Wide Slash"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "bluestream"
	chosen_message = span_colossus("You will now slash in a wide area with white damage.")
	chosen_attack_num = 5

/datum/action/innate/megafauna_attack/tri_serum
	name = "Tri-Serum Attack"
	icon_icon = 'icons/effects/effects.dmi'
	button_icon_state = "static"
	chosen_message = span_colossus("You will now jump to random targets in the facility, dealing pale damage to anyone on your way.")
	chosen_attack_num = 6

/obj/effect/temp_visual/target_field
	name = "target field"
	desc = "You have a bad feeling about this..."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "target_field"
	duration = 30 SECONDS // In case claw dies in the processs
	randomdir = FALSE

/obj/effect/temp_visual/target_field/blue
	name = "tri-serum target field"
	desc = "Well shit."
	icon_state = "target_field_blue"

/mob/living/simple_animal/hostile/megafauna/claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT) // Imagine floating.
	serumW_cooldown = world.time + 10 SECONDS

/mob/living/simple_animal/hostile/megafauna/claw/death(gibbed)
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/megafauna/claw/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/megafauna/claw/OpenFire()
	if(charging)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				INVOKE_ASYNC(src, PROC_REF(SerumW), target)
			if(2)
				INVOKE_ASYNC(src, PROC_REF(SwiftDash), target, dash_num_short, 5)
			if(3)
				INVOKE_ASYNC(src, PROC_REF(SwiftDash), target, dash_num_long, 20)
			if(4)
				INVOKE_ASYNC(src, PROC_REF(SerumA), target)
			if(5)
				INVOKE_ASYNC(src, PROC_REF(WideSlash), target)
			if(6)
				INVOKE_ASYNC(src, PROC_REF(TriSerum))
		return

	Goto(target, move_to_delay, minimum_distance)
	if(serumA_cooldown <= world.time && !charging)
		INVOKE_ASYNC(src, PROC_REF(SerumA), target)
	else if(dash_cooldown <= world.time && !charging)
		if(prob(15) && (health < maxHealth*0.5))
			INVOKE_ASYNC(src, PROC_REF(ContinuousDash), target, 5)
			return
		INVOKE_ASYNC(src, PROC_REF(SwiftDash), target, dash_num_short, 5)
	else if(wide_slash_cooldown <= world.time && !charging)
		INVOKE_ASYNC(src, PROC_REF(WideSlash), target)

/mob/living/simple_animal/hostile/megafauna/claw/Move()
	if(charging)
		return FALSE
	if(stat == DEAD)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/claw/Life()
	. = ..()
	if(.) // Alive and well
		if(!client && !charging)
			if(serumW_cooldown <= world.time)
				var/list/targets_in_view = list()
				for(var/mob/living/L in view(9, src))
					if(L.stat)
						continue
					if(faction_check_mob(L))
						continue
					targets_in_view += L
				if(length(targets_in_view) > 3)
					var/mob/living/L = pick(targets_in_view)
					INVOKE_ASYNC(src, PROC_REF(SerumW), L) // Will do targeted serum W
					return
				INVOKE_ASYNC(src, PROC_REF(SerumW)) // So we don't get stuck
			if(triserum_cooldown <= world.time && (health < maxHealth*0.2))
				INVOKE_ASYNC(src, PROC_REF(TriSerum))

/mob/living/simple_animal/hostile/megafauna/claw/proc/SerumW(target)
	if(serumW_cooldown > world.time)
		return
	serumW_cooldown = world.time + serumW_cooldown_time
	if(isliving(target))
		var/mob/living/L = target
		if(!L.stat)
			return TargetSerumW(L)
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if(faction_check_mob(maybe_victim))
			continue
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	if(!LAZYLEN(death_candidates)) // If there is 0 candidates - stop the spell.
		to_chat(src, span_notice("There is no more human survivors in the facility."))
		return
	if(length(death_candidates) == 1) // Exactly one? Do targeted thing for lulz
		return TargetSerumW(death_candidates[1])
	for(var/i in 1 to 5)
		if(!LAZYLEN(death_candidates)) // No more candidates left? Let's stop picking through the list.
			break
		var/mob/living/carbon/human/H = pick(death_candidates)
		death_candidates.Remove(H)
		if(!istype(H) || QDELETED(H)) // Shouldn't be possible, but here we are
			continue
		addtimer(CALLBACK(src, PROC_REF(eviscerate), H), i*4)

/mob/living/simple_animal/hostile/megafauna/claw/proc/eviscerate(mob/living/carbon/human/target)
	if(!istype(target) || QDELETED(target))
		return
	var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(target.loc)
	uhoh.orbit(target, 0)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 1, 1)
	to_chat(target, span_danger("The [src] is going to hunt you down!"))
	addtimer(CALLBACK(src, PROC_REF(eviscerate2), target, uhoh), 30)

/mob/living/simple_animal/hostile/megafauna/claw/proc/eviscerate2(mob/living/carbon/human/target, obj/effect/eff)
	if(!istype(target) || QDELETED(target) || !target.loc)
		qdel(eff)
		return
	if(prob(2) || target.z != z || !target.loc.AllowClick()) // Be happy, mortal. Did you just hide in a locker?
		to_chat(src, span_notice("Your teleportation device malfunctions!"))
		to_chat(target, span_notice("It seems you are safe. For now..."))
		playsound(src.loc, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, 1)
		qdel(eff)
		return
	new /obj/effect/temp_visual/emp/pulse(loc)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
	D.color = COLOR_BRIGHT_BLUE
	animate(D, alpha = 0, time = 5)
	visible_message(span_warning("[src] blinks away!"))
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	qdel(eff)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
	GiveTarget(target)
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(faction_check_mob(L))
			continue
		to_chat(target, span_userdanger("\The [src] eviscerates you!"))
		L.apply_damage(75, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		new /obj/effect/temp_visual/cleave(get_turf(L))

/mob/living/simple_animal/hostile/megafauna/claw/proc/TargetSerumW(mob/living/L)
	if(!istype(L) || QDELETED(L))
		return FALSE
	charging = TRUE
	var/obj/effect/temp_visual/target_field/uhoh = new /obj/effect/temp_visual/target_field(L.loc)
	uhoh.orbit(L, 0)
	playsound(L, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 1, 1)
	icon_state = "claw_prepare"
	to_chat(L, span_danger("The [src] is going to hunt you down!"))
	addtimer(CALLBACK(src, PROC_REF(TargetEviscerate), L, uhoh), 15)

/mob/living/simple_animal/hostile/megafauna/claw/proc/TargetEviscerate(mob/living/L, obj/effect/eff)
	if(!istype(L) || QDELETED(L))
		charging = FALSE
		return FALSE
	new /obj/effect/temp_visual/emp/pulse(src.loc)
	icon_state = icon_living
	visible_message(span_warning("[src] blinks away!"))
	var/turf/tp_loc = get_step(L, pick(GLOB.alldirs))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	face_atom(L)
	playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	L.Stun(12, TRUE, TRUE)
	SLEEP_CHECK_DEATH(6)
	qdel(eff)
	if(!istype(L) || QDELETED(L))
		charging = FALSE
		return FALSE
	L.visible_message(
		span_warning("[src] disappears, taking [L] with them!"),
		span_userdanger("[src] teleports with you through the entire facility!")
		)
	var/list/teleport_turfs = list()
	for(var/turf/T in shuffle(GLOB.department_centers))
		if(T in range(12, src))
			continue
		teleport_turfs += T
	for(var/i = 1 to 5)
		if(!LAZYLEN(teleport_turfs))
			break
		if(!istype(L) || QDELETED(L))
			charging = FALSE
			break
		var/turf/target_turf = pick(teleport_turfs)
		playsound(tp_loc, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		tp_loc.Beam(target_turf, "nzcrentrs_power", time=15)
		playsound(target_turf, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc, src)
		D.color = COLOR_BRIGHT_BLUE
		animate(D, alpha = 0, time = 5)
		forceMove(target_turf)
		for(var/mob/living/LL in range(1, target_turf)) // Attacks everyone around.
			if(faction_check_mob(LL))
				continue
			if(LL == L)
				continue
			to_chat(LL, span_userdanger("\The [src] slashes you!"))
			LL.apply_damage(15, BLACK_DAMAGE, null, LL.run_armor_check(null, BLACK_DAMAGE))
			new /obj/effect/temp_visual/cleave(get_turf(LL))
		tp_loc = get_step(src, pick(1,2,4,5,6,8,9,10))
		for(var/obj/item/I in get_turf(L)) // We take all dropped items with us, just to be fair, you know
			if(I.anchored)
				continue
			I.forceMove(tp_loc)
		var/obj/effect/temp_visual/decoy/DL = new /obj/effect/temp_visual/decoy(L.loc, L)
		DL.color = COLOR_BRIGHT_BLUE
		animate(DL, alpha = 0, time = 5)
		L.forceMove(tp_loc)
		if(i < 5)
			SLEEP_CHECK_DEATH(4)
	if(istype(L) && !QDELETED(L))
		to_chat(L, span_userdanger("\The [src] slashes you, finally releasing you from his grasp!"))
		L.apply_damage(50, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		GiveTarget(L)
	charging = FALSE

// I hate how it's just a copy-paste of serum W, but oh well
/mob/living/simple_animal/hostile/megafauna/claw/proc/TriSerum()
	if(triserum_cooldown > world.time)
		return
	triserum_cooldown = world.time + triserum_cooldown_time
	var/list/mob/living/carbon/human/death_candidates = list()
	for(var/mob/living/carbon/human/maybe_victim in GLOB.player_list)
		if(faction_check_mob(maybe_victim))
			continue
		if((maybe_victim.stat != DEAD) && maybe_victim.z == z)
			death_candidates += maybe_victim
	if(!death_candidates.len) // If there is 0 candidates - stop the spell.
		to_chat(src, span_notice("There is no more human survivors in the facility."))
		return
	for(var/i in 1 to 5)
		if(!death_candidates.len) // No more candidates left? Let's stop picking through the list.
			break
		var/mob/living/carbon/human/H = pick(death_candidates)
		death_candidates.Remove(H)
		if(!istype(H) || QDELETED(H)) // Shouldn't be possible, but here we are
			continue
		addtimer(CALLBACK(src, PROC_REF(triserum_eviscerate), H), i*5)

/mob/living/simple_animal/hostile/megafauna/claw/proc/triserum_eviscerate(mob/living/carbon/human/target)
	if(!istype(target) || QDELETED(target))
		return
	var/obj/effect/temp_visual/target_field/blue/uhoh = new /obj/effect/temp_visual/target_field/blue(target.loc)
	uhoh.orbit(target, 0)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 100, 1)
	playsound(src, 'ModularTegustation/Tegusounds/claw/eviscerate1.ogg', 1, 1)
	to_chat(target, span_danger("The [src] is going to hunt you down!"))
	addtimer(CALLBACK(src, PROC_REF(triserum_eviscerate2), target, uhoh), 40)

/mob/living/simple_animal/hostile/megafauna/claw/proc/triserum_eviscerate2(mob/living/carbon/human/target, obj/effect/eff)
	if(!istype(target) || QDELETED(target))
		return
	if(target.z != z || !target.loc.AllowClick()) // Be happy, mortal. Did you just hide in a locker?
		to_chat(src, span_notice("Your teleportation device malfunctions!"))
		to_chat(target, span_notice("It seems you are safe. For now..."))
		playsound(src.loc, 'ModularTegustation/Tegusounds/claw/error.ogg', 50, 1)
		qdel(eff)
		return
	visible_message(span_warning("[src] blinks away!"))
	var/list/been_hit = list()
	var/turf/prev_loc = get_turf(src)
	new /obj/effect/temp_visual/emp/pulse(prev_loc)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(prev_loc, src)
	D.color = COLOR_BRIGHT_BLUE
	animate(D, alpha = 0, time = 5)
	var/turf/tp_loc = get_step(target.loc, pick(0,1,2,4,5,6,8,9,10))
	new /obj/effect/temp_visual/emp/pulse(tp_loc)
	forceMove(tp_loc)
	qdel(eff)
	prev_loc.Beam(tp_loc, "bsa_beam", time=25)
	playsound(target, 'ModularTegustation/Tegusounds/claw/eviscerate2.ogg', 100, 1, 7)
	GiveTarget(target)
	for(var/mob/living/L in range(1, get_turf(src))) // Attacks everyone around.
		if(L in been_hit)
			continue
		if(faction_check_mob(L))
			continue
		been_hit |= L
		to_chat(target, span_userdanger("\The [src] eviscerates you!"))
		L.apply_damage(70, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		new /obj/effect/temp_visual/cleave(get_turf(L))
	for(var/turf/B in getline(prev_loc, tp_loc))
		for(var/mob/living/L in range(1, B)) // Attacks everyone in line
			if(L in been_hit)
				continue
			if(faction_check_mob(L))
				continue
			been_hit |= L
			to_chat(L, span_userdanger("\The [src] slashes you!"))
			L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
			playsound(L, 'ModularTegustation/Tegusounds/claw/attack.ogg', 35, 1)
			new /obj/effect/temp_visual/cleave(get_turf(L))

/mob/living/simple_animal/hostile/megafauna/claw/proc/SwiftDash(atom/target, distance, wait_time)
	if(dash_cooldown > world.time)
		return
	if(!istype(target) || QDELETED(target))
		return
	dash_cooldown = world.time + (dash_cooldown_time * distance)
	charging = TRUE
	var/turf/end_turf = get_ranged_target_turf_direct(src, target, distance, 0)
	var/list/turf_list = getline(src, end_turf)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	icon_state = "claw_prepare"
	face_atom(target)
	SLEEP_CHECK_DEATH(wait_time)
	icon_state = "claw_dash"
	for(var/turf/T in turf_list)
		if(!istype(T))
			charging = FALSE
			icon_state = icon_living
			break
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		forceMove(T)
		playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
		for(var/mob/living/L in HurtInTurf(T, list(), dash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			new /obj/effect/temp_visual/cleave(L.loc)
		if(T != turf_list[turf_list.len]) // Not the last turf
			SLEEP_CHECK_DEATH(0.5)
	charging = FALSE
	icon_state = icon_living

/mob/living/simple_animal/hostile/megafauna/claw/proc/ContinuousDash(target, times_to_dash = 2)
	// All it does is call dash multiple times in a row
	for(var/i = 1 to times_to_dash)
		dash_cooldown = 0
		SwiftDash(target, 5, 5)

// The idea behind this attack is that it entirely misses the "target", instead turning large area around it into
// uninhabitable zone of death
/mob/living/simple_animal/hostile/megafauna/claw/proc/SerumA(mob/living/target)
	if(serumA_cooldown > world.time)
		return
	if(!isliving(target) || QDELETED(target))
		return
	var/mob/living/LT = target
	serumA_cooldown = world.time + serumA_cooldown_time
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	icon_state = "claw_prepare"
	charging = TRUE
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(LT))
	face_atom(LT)
	SLEEP_CHECK_DEATH(5)
	icon_state = "claw_dash"
	for(var/i = 1 to 8)
		if(!isliving(LT) || QDELETED(LT))
			break
		INVOKE_ASYNC(src, PROC_REF(blink), LT)
		SLEEP_CHECK_DEATH(2)
	icon_state = icon_living
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/claw/proc/blink(mob/living/LT)
	if(!istype(LT) || QDELETED(LT))
		var/list/potential_people = list()
		for(var/mob/living/L in view(9, src))
			if(faction_check_mob(L))
				continue
			if(L == src)
				continue
			if(L.stat == DEAD)
				continue
			potential_people += L
		if(!LAZYLEN(potential_people))
			return FALSE
		LT = pick(potential_people)
	var/turf/start_turf = get_turf(src)
	var/turf/target_turf = get_step(get_turf(LT), pick(1,2,4,5,6,8,9,10))
	for(var/i = 1 to 2) // For fancy effect
		target_turf = get_step(target_turf, get_dir(get_turf(start_turf), get_turf(target_turf)))
	for(var/turf/T in getline(start_turf, target_turf))
		new /obj/effect/temp_visual/cult/sparks(T) // Telegraph the attack
	face_atom(target_turf)
	SLEEP_CHECK_DEATH(1)
	if(!istype(LT) || QDELETED(LT))
		return
	forceMove(target_turf)
	playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	for(var/turf/B in getline(start_turf, target_turf))
		for(var/turf/TT in range(B, 1))
			new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
			for(var/mob/living/victim in TT)
				if(faction_check_mob(victim))
					continue
				if(victim == LT)
					continue
				to_chat(victim, span_userdanger("\The [src] slashes you!"))
				victim.apply_damage(serumA_damage, RED_DAMAGE, null, victim.run_armor_check(null, RED_DAMAGE))
				new /obj/effect/temp_visual/cleave(victim.loc)
				playsound(victim, 'ModularTegustation/Tegusounds/claw/attack.ogg', 35, 1)

/mob/living/simple_animal/hostile/megafauna/claw/proc/WideSlash(atom/target)
	if(!istype(target) || QDELETED(target))
		return
	if(wide_slash_cooldown > world.time)
		return
	wide_slash_cooldown = world.time + wide_slash_cooldown_time
	charging = TRUE
	var/turf/TT = get_turf(target)
	face_atom(TT)
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	icon_state = "claw_dash"
	SLEEP_CHECK_DEATH(0.7 SECONDS)
	playsound(src, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	icon_state = "claw_prepare"
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
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), line)
	for(var/i = 1 to 20)
		angle += ((wide_slash_angle / 20) * rotate_dir)
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, T, wide_slash_range)
		line = getline(T, T2)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line), i * 0.04)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	icon_state = icon_living
	charging = FALSE

/mob/living/simple_animal/hostile/megafauna/claw/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/small_smoke/second) in T)
			continue
		new /obj/effect/temp_visual/sparkles(T)
		new /obj/effect/temp_visual/small_smoke/second(T)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(wide_slash_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
