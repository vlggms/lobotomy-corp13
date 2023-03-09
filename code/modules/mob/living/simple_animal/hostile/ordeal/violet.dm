// Violet dawn
/mob/living/simple_animal/hostile/ordeal/violet_fruit
	name = "fruit of understanding"
	desc = "A round purple creature. It is constantly leaking mind-damaging gas."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "violet_fruit"
	icon_living = "violet_fruit"
	icon_dead = "violet_fruit_dead"
	base_pixel_x = -8
	pixel_x = -8
	faction = list("violet_ordeal")
	maxHealth = 250
	health = 250
	speed = 4
	move_to_delay = 5
	butcher_results = list(/obj/item/food/meat/slab/fruit = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/fruit = 1)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	blood_volume = BLOOD_VOLUME_NORMAL

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/ReleaseDeathGas), rand(60 SECONDS, 80 SECONDS))

/mob/living/simple_animal/hostile/ordeal/violet_fruit/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	new /obj/effect/temp_visual/revenant/cracks(get_turf(src))
	for(var/mob/living/carbon/human/H in view(7, src))
		new /obj/effect/temp_visual/revenant(get_turf(H))
		H.apply_damage(6, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	return TRUE

/mob/living/simple_animal/hostile/ordeal/violet_fruit/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = spiral_range_turfs(24, target_c)
	visible_message("<span class='danger'>[src] releases a stream of nauseating gas!</span>")
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 16)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/carbon/human/H in livinginrange(24, target_c))
		H.apply_damage(33, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))
	for(var/obj/machinery/computer/abnormality/A in urange(24, target_c))
		if(prob(66) && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-1, -2))

// Violet noon
/mob/living/simple_animal/hostile/ordeal/violet_monolith
	name = "grant us love"
	desc = "A dark monolith structure with incomprehensible writing on it."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "violet_noon"
	icon_living = "violet_noon"
	icon_dead = "violet_noon_dead"
	base_pixel_x = -8
	pixel_x = -8
	faction = list("violet_ordeal")
	maxHealth = 1400
	health = 1400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)

	var/next_pulse = INFINITY

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Initialize()
	..()
	next_pulse = world.time + 30 SECONDS
	addtimer(CALLBACK(src, .proc/FallDown))

/mob/living/simple_animal/hostile/ordeal/violet_monolith/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Move()
	return FALSE

/mob/living/simple_animal/hostile/ordeal/violet_monolith/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(icon_state != "violet_noon_attack")
		return
	if(world.time > next_pulse)
		PulseAttack()
		return
	for(var/mob/living/L in view(2, src))
		if(!faction_check_mob(L))
			L.apply_damage(9, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))

/mob/living/simple_animal/hostile/ordeal/violet_monolith/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/ordeal/violet_monolith/proc/FallDown()
	pixel_z = 128
	alpha = 0
	density = FALSE
	animate(src, pixel_z = 0, alpha = 255, time = 10)
	SLEEP_CHECK_DEATH(10)
	density = TRUE
	visible_message("<span class='danger'>[src] falls down on the ground!</span>")
	playsound(get_turf(src), 'sound/effects/ordeals/violet/monolith_down.ogg', 65, 1)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
	animate(D, alpha = 0, transform = matrix()*2, time = 5)
	for(var/turf/open/T in view(4, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
	for(var/mob/living/L in view(4, src))
		if(!faction_check_mob(L))
			var/distance_decrease = get_dist(src, L) * 20
			L.apply_damage((150 - distance_decrease), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			if(L.health < 0)
				L.gib()
	SLEEP_CHECK_DEATH(5)
	icon_state = "violet_noon_attack"

/mob/living/simple_animal/hostile/ordeal/violet_monolith/proc/PulseAttack()
	next_pulse = world.time + 15 SECONDS
	icon_state = "violet_noon_ability"
	for(var/i = 1 to 3)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 7)
		SLEEP_CHECK_DEATH(8)
	var/obj/machinery/computer/abnormality/CA
	var/list/potential_computers = list()
	for(var/obj/machinery/computer/abnormality/A in urange(24, src))
		if(!A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			potential_computers += A
	if(LAZYLEN(potential_computers))
		CA = pick(potential_computers)
		CA.datum_reference.qliphoth_change(-1)
	icon_state = "violet_noon_attack"

// Violet midnight
/mob/living/simple_animal/hostile/ordeal/violet_midnight
	name = "god delusion"
	desc = "A shrine dedicated to unknown god from another dimension."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "violet_midnightr"
	icon_living = "violet_midnightr"
	icon_dead = "violet_midnightr_dead"
	base_pixel_x = -16
	pixel_x = -16
	faction = list("violet_ordeal")
	maxHealth = 15000
	health = 15000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	deathmessage = "falls apart."
	deathsound = 'sound/effects/ordeals/violet/midnight_dead.ogg'

	var/ability_cooldown
	var/ability_cooldown_time = 18 SECONDS
	var/retaliation_health = 10 // Initialized later
	/// List of datums and objects that will be deleted on death/destruction
	var/list/created_objects = list()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Initialize()
	. = ..()
	ability_cooldown = world.time + rand(4 SECONDS, 8 SECONDS)
	retaliation_health = maxHealth * 0.7

/mob/living/simple_animal/hostile/ordeal/violet_midnight/Destroy()
	for(var/T in created_objects)
		QDEL_NULL(T)
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
		INVOKE_ASYNC(src, .proc/StartAbility)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/CanAttack(atom/the_target)
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
	addtimer(CALLBACK(src, .proc/AnimatePortal), 2)

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
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = -1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)

	var/attack_damage = 300 // Dealt once if hit
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		if(!H.client)
			continue
		if(H.z != z)
			continue
		potential_targets += H
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

// Behold, the ugliest piece of code
/mob/living/simple_animal/hostile/ordeal/violet_midnight/red/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + 6 SECONDS
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
	INVOKE_ASYNC(src, .proc/DoLineAttack, first_line)
	INVOKE_ASYNC(src, .proc/DoLineAttack, second_line)
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
		for(var/turf/TT in range(3, T))
			new /obj/effect/temp_visual/sparkles/red(TT)
		for(var/mob/living/carbon/human/H in range(3, T))
			if(H in been_hit)
				continue
			if(H.stat == DEAD)
				continue
			if(H.status_flags & GODMODE)
				continue
			been_hit += H
			H.apply_damage(attack_damage, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE))
		SLEEP_CHECK_DEATH(0.1)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white
	icon_state = "violet_midnightw"
	icon_living = "violet_midnightw"
	icon_dead = "violet_midnightw_dead"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = -1, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.2)

	var/attack_damage = 200
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		if(!H.client)
			continue
		if(H.z != z)
			continue
		potential_targets += H
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + 6 SECONDS
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
	INVOKE_ASYNC(src, .proc/DoLineAttack, line)
	for(var/i = 1 to 6)
		angle2 += (10 * rotation_dir)
		if(angle2 > 360) // This might be pointless, but I just want to be extra sure
			angle2 -= 360
		else if(angle2 < 0)
			angle2 += 360
		T2 = get_turf_in_angle(angle2, T1, 24)
		line = getline(T1, T2)
		addtimer(CALLBACK(src, .proc/DoLineAttack, line), i)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, TRUE, 8)
	animate(P, alpha = 0, time = (1 SECONDS))
	QDEL_IN(P, (1 SECONDS))
	created_objects -= P

/mob/living/simple_animal/hostile/ordeal/violet_midnight/white/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		for(var/turf/TT in range(3, T))
			if(locate(/obj/effect/temp_visual/small_smoke/second) in TT)
				continue
			new /obj/effect/temp_visual/sparkles(TT)
			new /obj/effect/temp_visual/small_smoke/second(TT)
		for(var/mob/living/carbon/human/H in range(2, T))
			if(H in been_hit)
				continue
			if(H.stat == DEAD)
				continue
			if(H.status_flags & GODMODE)
				continue
			been_hit += H
			H.apply_damage(attack_damage, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE))

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black
	icon_state = "violet_midnightb"
	icon_living = "violet_midnightb"
	icon_dead = "violet_midnightb_dead"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = -1, PALE_DAMAGE = 0.7)

	var/attack_damage = 300
	var/list/been_hit = list()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/StartAbility()
	var/mob/living/carbon/human/attack_target = null
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		if(!H.client)
			continue
		if(H.z != z)
			continue
		potential_targets += H
	if(!LAZYLEN(potential_targets))
		return FALSE
	attack_target = pick(potential_targets)
	PerformAbility(attack_target)

// Behold, the ugliest piece of code
/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/proc/PerformAbility(atom/attack_target)
	been_hit = list()
	ability_cooldown = world.time + ability_cooldown_time + 6 SECONDS
	var/turf/T = get_turf(attack_target)
	var/angle1 = rand(180, 360)
	var/angle2 = angle1 - 180
	var/turf/T1 = get_turf_in_angle(angle1, T, 9)
	var/turf/T2 = get_turf_in_angle(angle2, T, 9)
	var/obj/effect/violet_portal/black/P1 = new(T1)
	var/obj/effect/violet_portal/black/P2 = new(T2)
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
	INVOKE_ASYNC(src, .proc/DoLineAttack, first_line)
	INVOKE_ASYNC(src, .proc/DoLineAttack, second_line)
	playsound(T, 'sound/effects/ordeals/violet/midnight_black_attack2.ogg', 50, FALSE, 24)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(T, 'sound/effects/ordeals/violet/midnight_portal_off.ogg', 50, TRUE, 8)
	animate(P1, alpha = 0, time = (1 SECONDS))
	animate(P2, alpha = 0, time = (1 SECONDS))
	QDEL_IN(P1, (1 SECONDS))
	QDEL_IN(P2, (1 SECONDS))

/mob/living/simple_animal/hostile/ordeal/violet_midnight/black/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		for(var/turf/TT in range(2, T))
			new /obj/effect/temp_visual/sparkles/purple(TT)
		for(var/mob/living/carbon/human/H in range(2, T))
			if(H in been_hit)
				continue
			if(H.stat == DEAD)
				continue
			if(H.status_flags & GODMODE)
				continue
			been_hit += H
			H.apply_damage(attack_damage, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE))
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
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = -1)

	var/obj/effect/pale_eye/eye = null
	var/pulsating = FALSE
	var/pulse_damage = 50 // Dealt each second

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/Initialize()
	. = ..()
	eye = new(src) // Gets moved out on attack

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/Destroy()
	QDEL_NULL(eye)
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/death()
	QDEL_NULL(eye)
	return ..()

/mob/living/simple_animal/hostile/ordeal/violet_midnight/pale/StartAbility()
	var/mob/living/carbon/human/eye_target = null
	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		if(!H.client)
			continue
		if(H.z != z)
			continue
		potential_targets += H
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
	animate(eye, alpha = 200, time = (0.5 SECONDS))
	SLEEP_CHECK_DEATH(1 SECONDS)
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
	for(var/turf/T in range(5, eye))
		new /obj/effect/temp_visual/pale_eye_attack(T)
	for(var/mob/living/carbon/human/H in range(5, eye))
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		H.apply_damage(pulse_damage, PALE_DAMAGE, null, H.run_armor_check(null, PALE_DAMAGE))
		has_targets = TRUE
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(eye), eye)
	animate(D, alpha = 0, transform = matrix()*1.25, time = 4)
	if(has_targets)
		playsound(get_turf(eye), 'sound/effects/ordeals/violet/midnight_pale_attack.ogg', 75, TRUE, 8)
	addtimer(CALLBACK(src, .proc/Pulsate), (1 SECONDS))

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
