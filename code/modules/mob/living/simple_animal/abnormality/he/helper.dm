/mob/living/simple_animal/hostile/abnormality/helper
	name = "All-Around Helper"
	desc = "A tiny robot with helpful intentions."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "helper"
	icon_living = "helper"
	portrait = "helper"
	maxHealth = 1000
	health = 1000
	rapid_melee = 4
	ranged = TRUE
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 25
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 55, 55, 50, 45),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, -30, -60, -90),
		ABNORMALITY_WORK_ATTACHMENT = list(35, 40, 40, 35, 35),
		ABNORMALITY_WORK_REPRESSION = list(50, 55, 55, 50, 45),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/grinder,
		/datum/ego_datum/armor/grinder,
	)
	gift_type =  /datum/ego_gifts/grinder
	gift_message = "Contamination scan complete. Initiating cleaning protocol."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/we_can_change_anything = 1.5,
		/mob/living/simple_animal/hostile/abnormality/cleaner = 1.5,
	)

	var/charging = FALSE
	var/dash_num = 50
	var/dash_cooldown = 0
	var/dash_cooldown_time = 8 SECONDS
	var/list/been_hit = list() // Don't get hit twice.

	//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/helper_dash_toggle)

/datum/action/innate/abnormality_attack/toggle/helper_dash_toggle
	name = "Toggle Dash"
	button_icon_state = "helper_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't dash anymore.")
	button_icon_toggle_activated = "helper_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now dash in that direction.")
	button_icon_toggle_deactivated = "helper_toggle0"


/mob/living/simple_animal/hostile/abnormality/helper/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		helper_dash(target)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/helper/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/helper/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				helper_dash(target)
		return

	if(dash_cooldown <= world.time)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			helper_dash(target)

/mob/living/simple_animal/hostile/abnormality/helper/update_icon_state()
	if(status_flags & GODMODE)
		icon = initial(icon)
		pixel_x = initial(pixel_x)
		base_pixel_x = initial(base_pixel_x)
		pixel_y = initial(pixel_y)
		base_pixel_y = initial(base_pixel_y)
	else
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
		pixel_x = -16
		base_pixel_x = -16
		pixel_y = -16
		base_pixel_y = -16

/mob/living/simple_animal/hostile/abnormality/helper/proc/helper_dash(target)
	if(charging || dash_cooldown > world.time)
		return
	update_icon()
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/para = TRUE
	if(dir_to_target in list(WEST, NORTHWEST, SOUTHWEST))
		para = FALSE
	been_hit = list()
	SpinAnimation(1.8 SECONDS, 1, para)
	addtimer(CALLBACK(src, PROC_REF(do_dash), dir_to_target, 0), 1.5 SECONDS)
	playsound(src, 'sound/abnormalities/helper/rise.ogg', 100, 1)

/mob/living/simple_animal/hostile/abnormality/helper/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		W.obj_destruction("spinning blades")
	for(var/obj/machinery/door/D in T.contents)
		if(!D.CanAStarPass(null))
			stop_charge = TRUE
			break
		if(D.density)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open), 2)
	if(stop_charge)
		playsound(src, 'sound/abnormalities/helper/disable.ogg', 75, 1)
		SLEEP_CHECK_DEATH(5 SECONDS)
		charging = FALSE
		return
	forceMove(T)
	var/para = TRUE
	if(move_dir in list(WEST, NORTHWEST, SOUTHWEST))
		para = FALSE
	SpinAnimation(3, 1, para)
	playsound(src, "sound/abnormalities/helper/move0[pick(1,2,3)].ogg", rand(50, 70), 1)
	for(var/mob/living/L in range(1, T))
		if(!faction_check_mob(L))
			if(L in been_hit)
				continue
			visible_message(span_boldwarning("[src] runs through [L]!"))
			to_chat(L, span_userdanger("[src] pierces you with their spinning blades!"))
			playsound(L, attack_sound, 75, 1)
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				// Ugly code
				var/affecting = get_bodypart(ran_zone(pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
				var/armor = H.run_armor_check(affecting, melee_damage_type, armour_penetration = src.armour_penetration)
				H.apply_damage(60, src.melee_damage_type, affecting, armor, wound_bonus = src.wound_bonus, bare_wound_bonus = src.bare_wound_bonus, sharpness = src.sharpness)
			else
				L.adjustRedLoss(120)
			if(L.stat >= HARD_CRIT)
				L.gib()
				continue
			if(!(L in been_hit))
				been_hit += L
	addtimer(CALLBACK(src, PROC_REF(do_dash), move_dir, (times_ran + 1)), 1)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/helper/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/helper/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/helper/BreachEffect(mob/living/carbon/human/user, breach_type)
	..()
	update_icon()
	GiveTarget(user)


