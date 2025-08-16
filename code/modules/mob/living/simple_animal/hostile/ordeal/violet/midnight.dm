/mob/living/simple_animal/hostile/ordeal/violet_midnight
	name = "god delusion"
	desc = "A shrine dedicated to unknown god from another dimension."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "violet_midnightr"
	icon_living = "violet_midnightr"
	icon_dead = "violet_midnightr_dead"
	base_pixel_x = -16
	pixel_x = -16
	faction = list("violet_ordeal", "hostile")
	maxHealth = 15000
	health = 15000
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	death_message = "falls apart."
	death_sound = 'sound/effects/ordeals/violet/midnight_dead.ogg'
	stat_attack = HARD_CRIT

	var/ability_cooldown
	var/ability_cooldown_time = 14 SECONDS
	var/retaliation_health = 10 // Initialized later
	/// List of datums and objects that will be deleted on death/destruction
	var/list/created_objects = list()

	var/datum/reusable_visual_pool/RVP

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Initialize()
	. = ..()
	ability_cooldown = world.time + rand(5 SECONDS, ability_cooldown_time)
	retaliation_health = maxHealth * 0.7

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Destroy()
	for(var/T in created_objects)
		QDEL_NULL(T)
	QDEL_NULL(RVP)
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/death()
	for(var/T in created_objects)
		QDEL_NULL(T)
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Life()
	. = ..()
	if(!.)
		return
	if(world.time > ability_cooldown)
		INVOKE_ASYNC(src, PROC_REF(StartAbility))

/mob/living/simple_animal/hostile/ordeal/violet_midnight/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_midnight/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(health < retaliation_health)
		retaliation_health -= maxHealth * 0.3
		Retaliation()

/// Called in Life() when off cooldown
/mob/living/simple_animal/hostile/ordeal/violet_midnight/proc/StartAbility()
	return

/// Called when health falls below certain point
/mob/living/simple_animal/hostile/ordeal/violet_midnight/proc/Retaliation()
	return

/obj/effect/violet_portal
	name = "violet midnight portal"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi' // TEMPORARY
	layer = BYOND_LIGHTING_LAYER
	plane = BYOND_LIGHTING_PLANE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/violet_portal/Initialize()
	. = ..()
	AnimatePortal()

/obj/effect/violet_portal/proc/AnimatePortal()
	if(QDELETED(src))
		return
	if(alpha <= 125)
		return
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	D.layer = layer - 0.1
	D.plane = plane
	D.alpha = alpha
	animate(D, alpha = 0, transform = matrix()*1.5, time = 4)
	addtimer(CALLBACK(src, PROC_REF(AnimatePortal)), 2)

/obj/effect/violet_portal/red
	name = "red portal"
	icon_state = "red_shield" // TEMPORARY

/obj/effect/violet_portal/white
	name = "white portal"
	icon_state = "white_shield" // TEMPORARY

/obj/effect/violet_portal/black
	name = "black portal"
	icon_state = "black_shield" // TEMPORARY

/mob/living/simple_animal/hostile/ordeal/violet_midnight/red
	damage_coeff = list(RED_DAMAGE = -1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)

	var/attack_damage = 220 // Dealt once if hit
	var/list/been_hit = list()
	RVP = new(1865)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/Retaliation()
	PerformAbility(src)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(!CanAttack(L))
			continue
		if(L.z != z)
			continue
		potential_targets += L
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

// Behold, the ugliest piece of code
/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + rand(3 SECONDS, 9 SECONDS)
	var/turf/T = get_turf(attack_target)
	var/angle1 = rand(180, 360)
	var/angle2 = angle1 - 180
	var/turf/T1 = get_turf_in_angle(angle1, T, 9)
	var/turf/T2 = get_turf_in_angle(angle2, T, 9)
	var/obj/effect/violet_portal/red/P1 = new(T1)
	var/obj/effect/violet_portal/red/P2 = new(T2)
	created_objects += P1
	created_objects += P2
	P1.transform = turn(matrix(), angle1)
	P2.transform = turn(matrix(), angle2)
	var/datum/beam/B = T1.Beam(T2, "r_beam", time = (3.5 SECONDS))
	B.visuals.alpha = 0
	var/matrix/M = matrix()
	M.Scale(9, 1)
	animate(B.visuals, transform = M, alpha = 200, time = (1 SECONDS))
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_on.ogg', 75, TRUE, 16)
	SLEEP_CHECK_DEATH(3.5 SECONDS)
	animate(B.visuals, alpha = 0, time = (0.5 SECONDS))
	var/list/first_line = getline(T1, get_ranged_target_turf_direct(T1, T2, 18))
	var/list/second_line = getline(T2, get_ranged_target_turf_direct(T2, T1, 18))
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), first_line)
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), second_line)
	playsound(T, 'sound/effects/ordeals/violet/midnight_red_attack.ogg', 50, FALSE, 24)
	SLEEP_CHECK_DEATH(3 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, TRUE, 8)
	created_objects -= P1
	created_objects -= P2
	animate(P1, alpha = 0, time = (1 SECONDS))
	animate(P2, alpha = 0, time = (1 SECONDS))
	QDEL_IN(P1, (1 SECONDS))
	QDEL_IN(P2, (1 SECONDS))

/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		for(var/turf/TT in RANGE_TURFS(3, T))
			RVP.NewSparkles(TT, color = COLOR_RED)
			for(var/mob/living/L in TT)
				if(L in been_hit)
					continue
				if(!CanAttack(L))
					continue
				been_hit += L
				L.apply_damage(attack_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		SLEEP_CHECK_DEATH(0.1)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white
	icon_state = "violet_midnightw"
	icon_living = "violet_midnightw"
	icon_dead = "violet_midnightw_dead"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = -1, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.2)

	var/attack_damage = 150
	var/list/been_hit = list()
	RVP = new(1400)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/Retaliation()
	PerformAbility(src)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(!CanAttack(L))
			continue
		if(L.z != z)
			continue
		potential_targets += L
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + rand(3 SECONDS, 9 SECONDS)
	var/turf/T = get_turf(attack_target)
	var/angle1 = rand(180, 360)
	var/angle2 = angle1 - rand(140, 220)
	var/turf/T1 = get_turf_in_angle(angle1, T, 6)
	var/turf/T2 = get_turf_in_angle(angle2, T1, 24)
	var/obj/effect/violet_portal/white/P = new(T1)
	created_objects += P
	P.transform = turn(matrix(), angle1)
	var/datum/beam/B = T1.Beam(T2, "beam", time = (4.5 SECONDS))
	B.visuals.alpha = 0
	var/matrix/M = matrix()
	M.Scale(9, 1)
	animate(B.visuals, transform = M, alpha = 200, time = (1 SECONDS))
	var/rotation_dir = pick(-1, 1)
	// Where the attack will end
	var/turf/T2A = get_turf_in_angle(angle2 + (60 * rotation_dir), T1, 24)
	var/datum/beam/B2 = T1.Beam(T2A, "beam", time = (4.5 SECONDS))
	B2.visuals.alpha = 0
	animate(B2.visuals, transform = M, alpha = 200, time = (1 SECONDS))
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_on.ogg', 75, TRUE, 16)
	SLEEP_CHECK_DEATH(4 SECONDS)
	animate(B.visuals, alpha = 0, time = (0.5 SECONDS))
	playsound(T, 'sound/effects/ordeals/violet/midnight_white_attack.ogg', 50, FALSE, 32)
	var/list/line = getline(T1, T2)
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), line)
	for(var/i = 1 to 6)
		angle2 += (10 * rotation_dir)
		if(angle2 > 360) // This might be pointless, but I just want to be extra sure
			angle2 -= 360
		else if(angle2 < 0)
			angle2 += 360
		T2 = get_turf_in_angle(angle2, T1, 24)
		line = getline(T1, T2)
		addtimer(CALLBACK(src, PROC_REF(DoLineAttack), line), i)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, TRUE, 8)
	animate(P, alpha = 0, time = (1 SECONDS))
	QDEL_IN(P, (1 SECONDS))
	created_objects -= P

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		for(var/turf/TT in RANGE_TURFS(3, T))
			var/skip = FALSE
			for(var/obj/effect/reusable_visual/RV in TT)
				if(RV.name == "smoke")
					skip = TRUE
					break
			if(skip)
				continue
			RVP.NewSparkles(TT)
			RVP.NewSmoke(TT)
			for(var/mob/living/L in TT)
				if(L in been_hit)
					continue
				if(!CanAttack(L))
					continue
				been_hit += L
				L.apply_damage(attack_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black
	icon_state = "violet_midnightb"
	icon_living = "violet_midnightb"
	icon_dead = "violet_midnightb_dead"
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = -1, PALE_DAMAGE = 0.7)

	var/attack_damage = 220
	var/list/been_hit = list()
	RVP = new(1000)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/Retaliation()
	PerformAbility(src)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(!CanAttack(L))
			continue
		if(L.z != z)
			continue
		potential_targets += L
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

// Behold, the ugliest piece of code
/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + rand(3 SECONDS, 9 SECONDS)
	var/turf/T = get_turf(attack_target)
	var/angle1 = rand(180, 360)
	var/angle2 = angle1 - 180
	var/turf/T1 = get_turf_in_angle(angle1, T, 9)
	var/turf/T2 = get_turf_in_angle(angle2, T, 9)
	var/obj/effect/violet_portal/black/P1 = new(T1)
	var/obj/effect/violet_portal/black/P2 = new(T2)
	created_objects += P1
	created_objects += P2
	P1.transform = turn(matrix(), angle1)
	P2.transform = turn(matrix(), angle2)
	var/datum/beam/B = T1.Beam(T2, "beam", time = (3.5 SECONDS))
	B.visuals.color = COLOR_PURPLE
	B.visuals.alpha = 0
	var/matrix/M = matrix()
	M.Scale(6, 1)
	animate(B.visuals, transform = M, alpha = 200, time = (1 SECONDS))
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_on.ogg', 75, TRUE, 16)
	SLEEP_CHECK_DEATH(2 SECONDS)
	animate(B.visuals, alpha = 0, time = (0.5 SECONDS))
	playsound(T, 'sound/effects/ordeals/violet/midnight_black_attack1.ogg', 35, FALSE, 20)
	SLEEP_CHECK_DEATH(0.4 SECONDS)
	var/list/first_line = getline(T1, get_ranged_target_turf_direct(T1, T2, 18))
	var/list/second_line = getline(T2, get_ranged_target_turf_direct(T2, T1, 18))
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), first_line)
	INVOKE_ASYNC(src, PROC_REF(DoLineAttack), second_line)
	playsound(T, 'sound/effects/ordeals/violet/midnight_black_attack2.ogg', 50, FALSE, 24)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, TRUE, 8)
	animate(P1, alpha = 0, time = (1 SECONDS))
	animate(P2, alpha = 0, time = (1 SECONDS))
	QDEL_IN(P1, (1 SECONDS))
	QDEL_IN(P2, (1 SECONDS))
	created_objects -= P1
	created_objects -= P2

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		for(var/turf/TT in RANGE_TURFS(2, T))
			RVP.NewSparkles(TT, color = COLOR_PURPLE)
			for(var/mob/living/L in TT)
				if(L in been_hit)
					continue
				if(!CanAttack(L))
					continue
				been_hit += L
				L.apply_damage(attack_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		SLEEP_CHECK_DEATH(0.05)

/obj/effect/black_portal
	name = "black portal"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi' // TEMPORARY
	icon_state = "black_shield" // TEMPORARY
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale
	icon_state = "violet_midnightp"
	icon_living = "violet_midnightp"
	icon_dead = "violet_midnightp_dead"
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = -1)

	var/obj/effect/pale_eye/eye = null
	var/pulsating = FALSE
	/// Amount of PALE damage dealt across a range on cooldown defined in variables below
	var/pulse_damage = 40
	/// The range of eye's attack
	var/pulse_range = 5
	/// How often it deals damage at the eye's location
	var/pulse_delay = 1 SECONDS
	RVP = new(121)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/Initialize()
	. = ..()
	eye = new(src) // Gets moved out on attack

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/Destroy()
	QDEL_NULL(eye)
	eye = null
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/death()
	QDEL_NULL(eye)
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/StartAbility()
	var/mob/living/carbon/human/eye_target = null
	var/list/potential_targets = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(!CanAttack(L))
			continue
		if(L.z != z)
			continue
		potential_targets += L
	if(!LAZYLEN(potential_targets))
		return FALSE
	eye_target = pick(potential_targets)
	MoveEye(eye_target)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/Retaliation()
	MoveEye(src)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/proc/MoveEye(atom/eye_target)
	ability_cooldown = world.time + ability_cooldown_time
	var/turf/T = get_turf(eye_target)
	pulsating = FALSE
	animate(eye, alpha = 0, time = (1 SECONDS))
	playsound(get_turf(eye), 'sound/effects/ordeals/violet/midnight_pale_move.ogg', 50, TRUE, 8)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_pale_move.ogg', 75, TRUE, 8)
	eye.forceMove(T)
	animate(eye, alpha = 200, time = (1 SECONDS))
	SLEEP_CHECK_DEATH(2 SECONDS)
	if(pulsating) // Uh oh! It already started doing the thing, abort it!
		return
	pulsating = TRUE
	Pulsate()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/proc/Pulsate()
	if(!pulsating)
		return
	if(!istype(eye))
		pulsating = FALSE
		return
	if(stat == DEAD)
		pulsating = FALSE
		return
	if(!isturf(eye.loc))
		pulsating = FALSE
		return
	var/has_targets = FALSE
	for(var/turf/T in RANGE_TURFS(pulse_range, eye))
		RVP.NewPaleEyeAttack(T)
		for(var/mob/living/L in T)
			if(!CanAttack(L))
				continue
			L.apply_damage(pulse_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
			has_targets = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(eye), eye)
	animate(D, alpha = 0, transform = matrix()*1.25, time = 4)
	if(has_targets)
		playsound(get_turf(eye), 'sound/effects/ordeals/violet/midnight_pale_attack.ogg', 75, TRUE, 8)
	addtimer(CALLBACK(src, PROC_REF(Pulsate)), pulse_delay)

/datum/reusable_visual_pool/proc/NewPaleEyeAttack(turf/location, duration = 5)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	RV.name = "pale particles"
	RV.icon = 'icons/effects/effects.dmi'
	RV.icon_state = "ion_fade_flight"
	RV.dir = pick(GLOB.cardinals)
	RV.loc = location
	animate(RV, alpha = 0, time = duration)
	DelayedReturn(RV, duration)
	return RV

/obj/effect/pale_eye
	name = "pale eye"
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "pale_eye"
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -48
	base_pixel_y = -48
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
