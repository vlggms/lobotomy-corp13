/mob/living/simple_animal/hostile/abnormality/dimensional_refraction
	name = "Dimensional Refraction Variant"
	desc = "A barely visible haze"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "dmr_abnormality"
	icon_living = "dmr_abnormality"
	portrait = "dimension_refraction"
	del_on_death = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16

	maxHealth = 1200
	health = 1200
	density = FALSE
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	threat_level = WAW_LEVEL
	fear_level = 0
	start_qliphoth = 2
	move_to_delay = 6

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(35, 40, 45, 50, 55),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/diffraction,
		/datum/ego_datum/armor/diffraction,
	)
	gift_type =  /datum/ego_gifts/diffraction
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	var/cooldown_time = 3
	var/aoe_damage = 12

/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/proc/Melter()
	for(var/mob/living/L in livinginview(1, src))
		if(faction_check_mob(L))
			continue
		L.apply_damage(aoe_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
	addtimer(CALLBACK(src, PROC_REF(Melter)), cooldown_time)


/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/PickTarget(list/Targets)
	return

//Cannot be automatically followed by manager camera follow command.
/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/can_track(mob/living/user)
	return FALSE

/* Qliphoth/Breach effects */
/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	alpha = 30
	addtimer(CALLBACK(src, PROC_REF(Melter)), cooldown_time)


/mob/living/simple_animal/hostile/abnormality/dimensional_refraction/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
