/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas
	name = "Consilium Fracas"
	desc = "A mummy trapped in an hourglass, sand eternally falling onto him."
	icon = 'ModularTegustation/Teguicons/branch12/64x64.dmi'
	icon_state = "fracas"
	icon_living = "fracas"
	health = 1000
	maxHealth = 1000
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	pixel_x = -16
	base_pixel_x = -16
//	portrait = "oldman_pale"
	melee_damage_lower = 0		//Doesn't attack
	melee_damage_upper = 0
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	faction = list("hostile")
	can_breach = TRUE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 20, 30, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 30, 45),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 0, 30, 30),
	)
	work_damage_amount = 15
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/branch12/time_sands,
		//datum/ego_datum/armor/branch12/time_sands,
	)
//	gift_type =  /datum/ego_gifts/time_sands
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/list/fire_list = list()


/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/Move()
	..()
	for(var/obj/structure/spreading/fracas_fire/Y in get_turf(src))
		return TRUE
	new /obj/structure/spreading/fracas_fire (get_turf(src))
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/CanAttack(atom/the_target)
	return FALSE


/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	//Dust, idiot
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 100)
		user.dust()
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/BreachEffect()
	..()
	icon = 'ModularTegustation/Teguicons/branch12/32x48.dmi'
	pixel_x = 0
	base_pixel_x = 0

/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/death()
	for(var/V in fire_list)
		fire_list-=V
		qdel(V)
	..()

// Sandstorm effect
/obj/structure/spreading/fracas_fire
	gender = PLURAL
	name = "The Eternal Sands"
	desc = "A raging sandstorm"
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "ash_storm"
	alpha = 200
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	plane = 4
	max_integrity = 100000
	base_icon_state = "ash_storm"
	//expand_cooldown = 20 SECONDS
	can_expand = TRUE
	bypass_density = TRUE
	obj_flags = NONE
	vis_flags = VIS_INHERIT_PLANE
	var/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas/connected_abno

/obj/structure/spreading/fracas_fire/Initialize()
	. = ..()
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/consilium_fracas) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.fire_list += src
	expand()


/obj/structure/spreading/fracas_fire/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 10 SECONDS)
	..()

/obj/structure/spreading/fracas_fire/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(3, FIRE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

