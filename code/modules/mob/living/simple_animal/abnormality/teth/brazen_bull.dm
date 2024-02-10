/mob/living/simple_animal/hostile/abnormality/brazen_bull
	name = "Brazen Bull"
	desc = "A bull made of an copper and zinc alloy with someone trapped inside it"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "Bull"
	pixel_x = -15
	base_pixel_x = -15
	icon_living = "Bull"
	maxHealth = 850
	health = 850
	vision_range = 11
	aggro_vision_range = 17
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 12
	melee_damage_type = RED_DAMAGE
	rapid_melee = 2
	stat_attack = HARD_CRIT
	attack_sound = 'sound/weapons/slam.ogg'
	attack_verb_continuous = "smacks"
	attack_verb_simple = "smack"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(20, 20, 20, 30, 30),
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 50, 50, 50),
						ABNORMALITY_WORK_ATTACHMENT = list(20, 25, 30, 30, 35),
						ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40)
						)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	var/charge_check_time = 1 SECONDS
	var/dash_num = 50
	var/list/been_hit = list()
	var/busy = FALSE
	var/can_move = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/capote,
		/datum/ego_datum/armor/capote
		)
	gift_type = /datum/ego_gifts/capote

	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/mob/living/simple_animal/hostile/abnormality/brazen_bull/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/brazen_bull/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(60))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/brazen_bull/Move()
	if(!can_move)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/brazen_bull/Life()
	. = ..()
	if(!.)
		return FALSE
	if(!(status_flags & GODMODE))
		return
	if(!busy)
		return
	charge_check()

/mob/living/simple_animal/hostile/abnormality/brazen_bull/proc/charge_check()
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/H in view(20, src))
		possible_targets += H
	if(LAZYLEN(possible_targets))
		target = pick(possible_targets)
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
		if(dir_to_target)
			can_move = FALSE
			busy = TRUE
			addtimer(CALLBACK(src, .proc/charge, dir_to_target, 0, target), 2 SECONDS)
			return
	return


/mob/living/simple_animal/hostile/abnormality/brazen_bull/proc/charge(move_dir, times_ran, target)
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		stop_charge = TRUE
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction()
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)
		if(D.density)
			stop_charge = TRUE

	if(stop_charge)
		can_move = TRUE
		busy = TRUE
		addtimer(CALLBACK(src, .proc/endCharge), 7 SECONDS)
		been_hit = list()
		return
	forceMove(T)

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, been_hit, 0, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			L.visible_message(span_boldwarning("[src] rams [L]!"), span_userdanger("[src] impales you with its horns!"))
			playsound(L, attack_sound, 75, 1)
			new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
			if(ishuman(L))
				L.apply_damage(30, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			else
				L.adjustRedLoss(30)
			if(L.stat >= HARD_CRIT)
				L.gib()
		for(var/obj/vehicle/V in new_hits)
			V.take_damage(10, RED_DAMAGE, attack_sound)
			V.visible_message(span_boldwarning("[src] rams [V]!"))

	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	addtimer(CALLBACK(src, .proc/charge, move_dir, (times_ran + 1)), 2)

/mob/living/simple_animal/hostile/abnormality/brazen_bull/proc/endCharge()
	busy = FALSE

/mob/living/simple_animal/hostile/abnormality/brazen_bull/BreachEffect(mob/living/carbon/human/user)
		.=..()
		GiveTarget(user)