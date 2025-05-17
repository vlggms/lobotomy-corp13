#define STATUS_EFFECT_INNOCENCE /datum/status_effect/display/innocence
/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale
	name = "Old Man and The Pale"
	desc = "A ghost in a suit."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "oldman_pale"
	icon_living = "oldman_pale"
//	portrait = "oldman_pale"
	melee_damage_lower = 0		//Doesn't attack
	melee_damage_upper = 0
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	faction = list("hostile")
	can_breach = FALSE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 4
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 20, 30),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 5, 10),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 20, 25, 35),
		ABNORMALITY_WORK_REPRESSION = list(15, 25, 35, 45, 55),
		"Inspire" = 45,
	)
	work_damage_amount = 15
	work_damage_type = WHITE_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/branch12/purity,
		/datum/ego_datum/armor/branch12/purity,
	)
//	gift_type =  /datum/ego_gifts/purity
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/list/innocent = list()
	var/list/pale_list = list()


/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(datum_reference.qliphoth_meter ==0 && work_type == "Inspire")
		datum_reference.qliphoth_change(4)
		for(var/V in pale_list)
			qdel(V)
			pale_list-=V
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(40))
		datum_reference.qliphoth_change(-1)

	if(datum_reference.qliphoth_meter ==0 && work_type == "Inspire")
		innocent+=user
		user.apply_status_effect(STATUS_EFFECT_INNOCENCE)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

	if(datum_reference.qliphoth_meter ==0 && work_type == "Inspire")
		innocent+=user
		user.apply_status_effect(STATUS_EFFECT_INNOCENCE)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/AttemptWork(mob/living/carbon/human/user, work_type)
	if((!length(pale_list)) && work_type != "Inspire")
		return TRUE

	if(length(pale_list) && work_type == "Inspire")
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	if(user.sanity_lost)
		addtimer(CALLBACK(src, PROC_REF(apply_innocence), user), 60 SECONDS)


/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/ZeroQliphoth()
	..()
	new /obj/structure/spreading/pale (src)

/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/death()
	for(var/V in pale_list)
		qdel(V)
		pale_list-=V
	..()


/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/proc/apply_innocence(mob/living/carbon/human/user, work_type, pe)
	user.apply_status_effect(STATUS_EFFECT_INNOCENCE)

// Oldman Pale
/obj/structure/spreading/pale
	gender = PLURAL
	name = "The Pale"
	desc = "This is The Pale"
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "halon"
	anchored = TRUE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	plane = 4
	max_integrity = 100000
	base_icon_state = "halon"
	//expand_cooldown = 20 SECONDS
	can_expand = TRUE
	bypass_density = TRUE
	vis_flags = VIS_INHERIT_PLANE
	obj_flags = NONE
	var/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/connected_abno

/obj/structure/spreading/pale/Initialize()
	. = ..()

	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.pale_list += src
	expand()


/obj/structure/spreading/pale/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 20 SECONDS)
	..()

/obj/structure/spreading/pale/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(18, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		H.set_blurriness(4)


//innocence status effect
/datum/status_effect/display/innocence
	id = "innocence"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	display_name = "innocence"

	var/timer = 0	//How many seconds of buff do you get
	var/debuffed = TRUE		//Are you currently debuffed

/datum/status_effect/display/innocence/tick()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.apply_damage(2, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		if(H.sanity_lost)
			new /obj/structure/spreading/pale (get_turf(owner))
			var/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale/P = locate(/mob/living/simple_animal/hostile/abnormality/branch12/oldman_pale) in GLOB.abnormality_mob_list
			P.datum_reference.qliphoth_change(-99)
			H.dust()


#undef STATUS_EFFECT_INNOCENCE
