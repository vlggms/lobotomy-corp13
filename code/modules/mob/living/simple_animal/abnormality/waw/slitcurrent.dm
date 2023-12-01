/mob/living/simple_animal/hostile/abnormality/slitcurrent
	name = "\proper Dream-Devouring Slitcurrent"
	desc = "An abnormality resembling a giant black and teal shark. \
	There's teal poles ontop of its body,"
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "current"
	icon_living = "current"
	pixel_x = -16
	base_pixel_x = -16
	move_to_delay = 3
	melee_damage_lower = 50
	melee_damage_upper = 75
	melee_damage_type = RED_DAMAGE
	maxHealth = 2400
	health = 2400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.25, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	deathsound = 'sound/abnormalities/dreamingcurrent/dead.ogg'

	threat_level = WAW_LEVEL

	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = list(45, 45, 45, 50, 55),
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = -9001,//you thought it would work like current eh?
						ABNORMALITY_WORK_REPRESSION = list(50, 50, 60, 55, 55)
						)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE
	ranged = 1
	can_breach = TRUE
	start_qliphoth = 2
	can_patrol = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/ecstasy,
		/datum/ego_datum/armor/ecstasy
		)
	gift_type = /datum/ego_gifts/ecstasy
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/charging = FALSE
	var/dash_num = 10
	var/dash_cooldown
	var/dash_cooldown_time = 18 SECONDS
	var/charging_damage = 250
	var/datum/looping_sound/dreamingcurrent/soundloop

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)
	color = COLOR_TEAL

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Destroy()
	QDEL_NULL(soundloop)
	..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Move()
	if(charging)
		return FALSE // Can only forceMove
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/Goto(target, delay, minimum_distance)
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/CanAttack(atom/the_target)
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/slitcurrent/OpenFire()
	ChargeStart(target)
	return

/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/ChargeStart(target)
	if(charging || dash_cooldown > world.time)
		return
	update_icon()
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	face_atom(target)
	icon_state = "current_prepare"
	playsound(src, "sound/effects/bubbles.ogg", 50, TRUE, 7)
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	addtimer(CALLBACK(src, .proc/do_dash, dir_to_target, 0), 2 SECONDS)

/mob/living/simple_animal/hostile/abnormality/slitcurrent/proc/do_dash(move_dir, times_ran)
	icon_state = "current_attack"
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		icon_state = icon_living
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)
		stop_charge = TRUE
		continue
	for(var/obj/machinery/door/D in T.contents)
		if(istype(D, /obj/machinery/door/poddoor))	//Should fix.
			continue
		if(D.density)
			D.open(2)
	if(stop_charge)
		icon_state = icon_living
		charging = FALSE
		return
	forceMove(T)
	playsound(T, "sound/abnormalities/dreamingcurrent/move.ogg", 10, TRUE, 3)
	if(get_turf(src) == get_turf(target))
		stop_charge = TRUE
		icon_state = icon_living
		charging = FALSE
		for(var/turf/TF in range(3, T))//Smash AOE visual
			new /obj/effect/temp_visual/cleave(get_turf(TF))
		for(var/mob/living/L in range(3, T))//damage applied to targets in range
			if(L.z != z)
				continue
			if(!faction_check_mob(L))
				visible_message(span_boldwarning("[src] ravenges through [L]!"))
				to_chat(L, span_userdanger("[src] ravenges you!"))
				playsound(L, attack_sound, 75, 1)
				var/turf/LT = get_turf(L)
				L.apply_damage(charging_damage,RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				playsound(L, "sound/abnormalities/dreamingcurrent/bite.ogg", 50, TRUE)
				if(L.health < 0)
					L.gib()
	addtimer(CALLBACK(src, .proc/do_dash, move_dir, (times_ran + 1)), 1)

/mob/living/simple_animal/hostile/abnormality/slitcurrent/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/slitcurrent/BreachEffect(mob/living/carbon/human/user)
	..()
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT) // Floating
	icon_living = "current_breach"
	icon_state = icon_living
