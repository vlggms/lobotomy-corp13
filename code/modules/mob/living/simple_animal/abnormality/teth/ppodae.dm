/mob/living/simple_animal/hostile/abnormality/ppodae
	name = "Ppodae"
	desc = "The Goodest Boy in the World"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "ppodae"
	icon_living = "ppodae"
	portrait = "ppodae"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 550 //fast but low hp abno
	health = 550
	threat_level = TETH_LEVEL
	move_to_delay = 1
	faction = list("hostile")
	response_help_continuous = "pet"
	response_help_simple = "pet"
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 30, 30, 30),
	)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_breach = TRUE
	start_qliphoth = 2
	vision_range = 14
	aggro_vision_range = 20
	stat_attack = HARD_CRIT
	var/smash_damage_low = 16
	var/smash_damage_high = 28
	var/smash_length = 2
	var/smash_width = 1
	var/can_act = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/cute,
		/datum/ego_datum/armor/cute,
	)
	gift_type =  /datum/ego_gifts/cute
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

/mob/living/simple_animal/hostile/abnormality/ppodae/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/ppodae/AttackingTarget()
	if(!can_act)
		return FALSE
	var/mob/living/carbon/L = target
	if(iscarbon(target) && (L.health < 0 || L.stat == DEAD))
		if(HAS_TRAIT(L, TRAIT_NODISMEMBER))
			return
		var/list/parts = list()
		for(var/X in L.bodyparts)
			var/obj/item/bodypart/bp = X
			if(bp.body_part != HEAD && bp.body_part != CHEST)
				if(bp.dismemberable)
					parts += bp
		if(length(parts))
			var/obj/item/bodypart/bp = pick(parts)
			bp.dismember()
			bp.forceMove(get_turf(datum_reference.landmark)) // Teleports limb to containment
			QDEL_NULL(src)
			// Taken from eldritch_demons.dm
	return Smash(target)

//AoE attack taken from woodsman
/mob/living/simple_animal/hostile/abnormality/ppodae/proc/Smash(target)
	if (get_dist(src, target) > 1)
		return
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(source_turf, get_ranged_target_turf(source_turf, NORTH, smash_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, smash_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, smash_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		else
			for(var/turf/T in view(1, src))
				if (T.density)
					break
				if (T in area_of_effect)
					continue
				area_of_effect |= T
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	var/smash_damage = rand(smash_damage_low, smash_damage_high)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		HurtInTurf(T, list(), smash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/bark.wav', 100, 0, 5)
	playsound(get_turf(src), 'sound/abnormalities/ppodae/attack.wav', 50, 0, 5)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/ppodae/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type != ABNORMALITY_WORK_INSTINCT && prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "ppodae_active"
	GiveTarget(user)
