//This abnormality does more things now! It should be enjoyable enough to play as.
/mob/living/simple_animal/hostile/abnormality/greed_king
	name = "King of Greed"
	desc = "A girl trapped in a magical crystal."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "kog"
	icon_living = "kog"
	portrait = "greed_king"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 3200
	health = 3200
	ranged = TRUE
	attack_verb_continuous = "chomps"
	attack_verb_simple = "chomps"
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT
	melee_damage_lower = 60	//Shouldn't really attack unless a player in controlling it, I guess.
	melee_damage_upper = 80
	attack_sound = 'sound/abnormalities/kog/GreedHit1.ogg'
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 25, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	//Some Variables cannibalized from helper
	var/charge_check_time = 1 SECONDS
	var/teleport_cooldown
	var/dash_num = 50	//Mostly a safeguard
	var/list/been_hit = list()
	var/busy = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/goldrush,
		/datum/ego_datum/armor/goldrush,
	)
	gift_type =  /datum/ego_gifts/goldrush
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 2,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 2,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 2,
		/mob/living/simple_animal/hostile/abnormality/nihil = 1.5,
	)

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/innate/abnormality_attack/kog_dash,
		/datum/action/innate/abnormality_attack/kog_teleport,
	)

/datum/action/innate/abnormality_attack/kog_dash
	name = "Ravenous Charge"
	button_icon_state = "kog_charge"
	chosen_message = span_colossus("You will now dash in that direction.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/kog_teleport
	name = "Teleport"
	button_icon_state = "kog_teleport"
	chosen_message = span_warning("You will now teleport to a random area in the facility's halls.")
	chosen_attack_num = 2

/datum/action/innate/abnormality_attack/kog_teleport/Activate()
	addtimer(CALLBACK(A, TYPE_PROC_REF(/mob/living/simple_animal/hostile/abnormality/greed_king, startTeleport)), 1)
	to_chat(A, chosen_message)

/mob/living/simple_animal/hostile/abnormality/greed_king/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(!(status_flags & GODMODE))
		if(!(busy || client))
			charge_check()

/mob/living/simple_animal/hostile/abnormality/greed_king/AttackingTarget()
	if(busy)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/Move()
	if(busy || !client)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/greed_king/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	//Center it on a hallway
	pixel_y = -8
	base_pixel_y = -8

	startTeleport()	//Let's Spaghettioodle out of here

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/startTeleport()
	if(IsCombatMap())
		return
	if(busy || teleport_cooldown > world.time || (status_flags & GODMODE))
		return
	teleport_cooldown = world.time + 4.9 SECONDS
	//set busy, animate and call the proc that actually teleports.
	busy = TRUE
	animate(src, alpha = 0, time = 5)
	addtimer(CALLBACK(src, PROC_REF(endTeleport)), 5)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endTeleport()
	var/turf/T = pick(GLOB.xeno_spawn)
	animate(src, alpha = 255, time = 5)
	forceMove(T)
	busy = FALSE
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(startTeleport)), 5 SECONDS)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge_check()
	//targeting
	var/mob/living/carbon/human/target
	if(busy)
		return
	var/list/possible_targets = list()
	for(var/mob/living/carbon/human/H in view(20, src))
		possible_targets += H
	if(LAZYLEN(possible_targets))
		target = pick(possible_targets)
		//Start charge
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
		if(dir_to_target)
			busy = TRUE
			addtimer(CALLBACK(src, PROC_REF(charge), dir_to_target, 0, target), 2 SECONDS)
			return
	return


/mob/living/simple_animal/hostile/abnormality/greed_king/OpenFire() // This exists so players can manually charge during playable abnormalities.
	if(busy || !client)
		return
	switch(chosen_attack)
		if(1)
			var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
			busy = TRUE
			charge(dir_to_target, 0, target)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/charge(move_dir, times_ran, target)
	setDir(move_dir)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		been_hit = list()
		stop_charge = TRUE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction()
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			stop_charge = TRUE
	for(var/mob/living/simple_animal/hostile/abnormality/D in T.contents)	//This caused issues earlier
		if(D.density)
			stop_charge = TRUE

	//Stop charging
	if(stop_charge)
		busy = TRUE
		addtimer(CALLBACK(src, PROC_REF(endCharge)), 7 SECONDS)
		been_hit = list()
		return
	forceMove(T)

	//Hiteffect stuff

	for(var/turf/U in range(1, T))
		var/list/new_hits = HurtInTurf(U, been_hit, 0, RED_DAMAGE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			L.visible_message(span_boldwarning("[src] crunches [L]!"), span_userdanger("[src] rends you with its teeth!"))
			playsound(L, attack_sound, 75, 1)
			new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.apply_damage(800, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			else
				L.adjustRedLoss(80)
			if(L.stat >= HARD_CRIT)
				L.gib()
			playsound(L, 'sound/abnormalities/kog/GreedHit1.ogg', 20, 1)
			playsound(L, 'sound/abnormalities/kog/GreedHit2.ogg', 50, 1)
		for(var/obj/vehicle/V in new_hits)
			V.take_damage(80, RED_DAMAGE, attack_sound)
			V.visible_message(span_boldwarning("[src] crunches [V]!"))
			playsound(V, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1)
			playsound(V, 'sound/abnormalities/kog/GreedHit2.ogg', 30, 1)

	playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
	for(var/turf/open/R in range(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(R)
	addtimer(CALLBACK(src, PROC_REF(charge), move_dir, (times_ran + 1)), 2)

/mob/living/simple_animal/hostile/abnormality/greed_king/proc/endCharge()
	busy = FALSE
	if(!client)
		startTeleport()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/greed_king/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(15))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/greed_king/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return



