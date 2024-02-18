// Silly christmass/new year
/mob/living/simple_animal/hostile/abnormality/rudolta_buff
	name = "Rudolta of the Sleigh"
	desc = "Rudolta has had enough, and now all bad kids are getting coal, directly from the sleigh."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "rudolta_buff"
	icon_living = "rudolta_buff"
	icon_dead = "rudolta_buff_dead"
	maxHealth = 4000
	health = 4000
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.8)
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 75
	melee_damage_upper = 85
	rapid_melee = 2
	ranged = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/abnormalities/rudolta_buff/melee.ogg'
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 2
	move_to_delay = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(100, 90, 80, 75, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 45, 40, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 40, 30),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 10, 20, 30),
	)
	work_damage_amount = 25
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/buff_christmas,
		/datum/ego_datum/armor/buff_christmas,
	)
	gift_type = /datum/ego_gifts/christmas/buff
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/rudolta_buff_onrush,
		/datum/action/innate/abnormality_attack/rudolta_buff_slam,
	)

	can_spawn = FALSE

	var/can_act = TRUE
	// Onrush vars
	var/onrush_cooldown
	var/onrush_cooldown_time = 10 SECONDS
	var/onrush_damage = 150
	var/onrush_max_iterations = 6
	var/onrush_min_delay = 3
	var/onrush_max_delay = 6
	var/onrush_double_hit = FALSE
	var/list/onrush_hit = list()
	var/list/onrush_sounds = list(
		'sound/abnormalities/rudolta_buff/onrush1.ogg',
		'sound/abnormalities/rudolta_buff/onrush2.ogg',
		'sound/abnormalities/rudolta_buff/onrush3.ogg',
	)
	// Sleigh slam vars
	var/slam_cooldown
	var/slam_cooldown_time = 20 SECONDS
	var/slam_damage = 250

/datum/action/innate/abnormality_attack/rudolta_buff_onrush
	name = "Onrush"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 1
	chosen_message = span_colossus("You will now perform onrush attack on living enemies.")

/datum/action/innate/abnormality_attack/rudolta_buff_slam
	name = "Sleigh Slam"
	button_icon_state = "generic_slam"
	chosen_attack_num = 2
	chosen_message = span_colossus("You will now slam the sleigh against the target area.")

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE

	if(onrush_cooldown <= world.time)
		OnRush(target)
		return

	return ..()

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/OpenFire()
	if(!can_act)
		return FALSE

	if(client)
		switch(chosen_attack)
			if(1)
				OnRush(target)
			if(2)
				SleighSlam(target)
		return

	if(onrush_cooldown <= world.time)
		OnRush(target)
		return

	if((slam_cooldown <= world.time))
		SleighSlam(target)
		return

	return

/mob/living/simple_animal/hostile/abnormality/rudolta_buff/death()
	animate(src, alpha = 0, time = (10 SECONDS))
	QDEL_IN(src, (10 SECONDS))
	return ..()

// Turns Rudolta into red mist by punching everyone one-by-one until he runs out of targets in range
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/proc/OnRush(mob/living/target, iteration = 0)
	if(!can_act && !iteration)
		return

	if(!iteration && onrush_cooldown > world.time)
		return

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		return

	can_act = FALSE
	onrush_cooldown = world.time + onrush_cooldown_time
	face_atom(target)
	if(!iteration)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(src), src)
		animate(D, alpha = 0, transform = matrix()*1.5, time = 3)
		visible_message(span_danger("[src] prepares to punish everyone!"))
		onrush_hit = list()
		SLEEP_CHECK_DEATH(5)

	if(!istype(target))
		can_act = TRUE
		return

	var/turf/target_turf = get_step(target, get_dir(target, src))
	var/list/line_list = getline(src, target_turf)
	for(var/i = 1 to length(line_list))
		var/turf/TT = line_list[i]
		var/obj/effect/temp_visual/decoy/D = new (TT, src)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 4 + i*2)

	forceMove(target_turf)
	// PUNCH!!!!
	playsound(src, pick(onrush_sounds), rand(50, 100), TRUE, 7)
	to_chat(target, span_userdanger("[src] punches you hard!"))
	if(!onrush_double_hit)
		onrush_hit |= target
	var/turf/thrownat = get_ranged_target_turf_direct(src, target, 15, rand(-30, 30))
	target.throw_at(thrownat, 8, 2, src, TRUE, force = MOVE_FORCE_OVERPOWERING, gentle = FALSE)
	target.apply_damage(onrush_damage, RED_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	new /obj/effect/temp_visual/smash_effect(get_turf(target))
	shake_camera(target, 2, 5)

	if(iteration >= onrush_max_iterations)
		can_act = TRUE
		onrush_hit = list()
		return

	// Pick new target
	var/list/valid_targets = list()
	for(var/mob/living/L in view(9, src))
		if(L.stat == DEAD)
			continue
		if(faction_check_mob(L))
			continue
		if((L in onrush_hit) && !onrush_double_hit)
			continue
		if(L == target)
			continue
		valid_targets += L

	if(!LAZYLEN(valid_targets))
		can_act = TRUE
		onrush_hit = list()
		return

	var/mob/living/L = pick(valid_targets)
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(get_turf(L), L)
	animate(D, alpha = 0, transform = matrix()*1.2, time = 3)
	face_atom(L)
	addtimer(CALLBACK(src, PROC_REF(OnRush), L, iteration + 1), rand(onrush_min_delay, onrush_max_delay))

// Slams the area with the sleigh, doing heavy damage
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/proc/SleighSlam(atom/target)
	if(!can_act || slam_cooldown > world.time)
		return

	can_act = FALSE
	slam_cooldown = world.time + slam_cooldown_time

	var/turf/T = get_turf(target)
	playsound(src, 'sound/abnormalities/apocalypse/swing.ogg', 75, TRUE)
	var/obj/effect/sled/S = new (T)
	S.alpha = 0
	S.pixel_y = 128
	animate(S, alpha = 255, pixel_y = 0, time = 3)
	var/datum/beam/B = src.Beam(S, "sled", time = 10)
	animate(B.visuals, alpha = 0, time = 10)

	SLEEP_CHECK_DEATH(5)

	var/list/been_hit = list()
	playsound(get_turf(src), 'sound/abnormalities/mountain/slam.ogg', 75, TRUE, 7)
	for(var/turf/TF in range(3, T))
		if(TF.density)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
		been_hit = HurtInTurf(TF, been_hit, slam_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()

	SLEEP_CHECK_DEATH(3)

	can_act = TRUE

/* Work stuff */
/mob/living/simple_animal/hostile/abnormality/rudolta_buff/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return
