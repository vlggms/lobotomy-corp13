//Just don't fall in.
/mob/living/simple_animal/hostile/abnormality/branch12/black_hole
	name = "Schwarzschild Radius"
	desc = "It goes down endlessly."
	icon = 'ModularTegustation/Teguicons/branch12/96x96.dmi'
	icon_state = "black_hole"
	icon_living = "black_hole"
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_x = -32
	del_on_death = TRUE
	layer = ABOVE_OPEN_TURF_LAYER

	maxHealth = 1000	//Cannot be damaged, this is just for austerity
	health = 1000
	rapid_melee = 2
	move_to_delay = 3
	patrol_cooldown_time = 2 SECONDS
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile")
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 50, 45, 40),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 45, 45),
	)
	work_damage_amount = 15
	work_damage_type =  BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/darkness,
		/datum/ego_datum/armor/branch12/darkness,
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/Life()
	..()
	if(IsContained())
		return
	goonchem_vortex(get_turf(src), 0, 3)
	for(var/mob/living/H in range(1, src))
		if(H.status_flags & GODMODE)
			continue
		if(H==src)
			continue
		H.death()
		animate(H, transform = H.transform*0.01, time = 5)
		QDEL_IN(H, 5)

/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/Move()
	. = ..()
	for(var/mob/living/H in range(1, src))
		if(H.status_flags & GODMODE)
			continue
		if(H==src)
			continue
		H.death()
		animate(H, transform = H.transform*0.01, time = 5)
		QDEL_IN(H, 5)

/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	addtimer(CALLBACK(src, PROC_REF(death)), 10 MINUTES)
	..()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/black_hole/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return
