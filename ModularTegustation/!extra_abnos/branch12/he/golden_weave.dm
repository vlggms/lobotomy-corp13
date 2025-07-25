//Very simple, funny little guy.
/mob/living/simple_animal/hostile/abnormality/branch12/weave
	name = "Golden Weave"
	desc = "An abnormality seeming to make up a floating cat face."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "gold_weave"
	icon_living = "gold_weave"
	del_on_death = TRUE
	maxHealth = 800		//Similar to simple smile, he's a little shit
	health = 800
	rapid_melee = 2
	move_to_delay = 2
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 5
	melee_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/lust
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bumps"
	attack_verb_simple = "bumps"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2

	ranged = 1
	retreat_distance = 3
	minimum_distance = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 30,
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/needle,
		/datum/ego_datum/armor/branch12/needle,
	)
	//gift_type =  /datum/ego_gifts/trick
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/list/current_weaves = list()

/mob/living/simple_animal/hostile/abnormality/branch12/weave/Life()
	..()
	if(IsContained())
		return
	if(prob(40))
		var/obj/structure/golden_weave/V = new(get_turf(src))
		current_weaves+=V

/mob/living/simple_animal/hostile/abnormality/branch12/weave/death()
	for(var/V in current_weaves)
		qdel(V)
		current_weaves-=V
	..()

/mob/living/simple_animal/hostile/abnormality/branch12/weave/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/weave/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/weave/WorkChance(mob/living/carbon/human/user, chance)
	return chance



/obj/structure/golden_weave
	gender = PLURAL
	name = "golden weave"
	desc = "a very faint golden thread."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "weave_trap"
	anchored = TRUE
	density = FALSE
	layer = LOW_OBJ_LAYER
	plane = 4
	max_integrity = 10

/obj/structure/golden_weave/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(5, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		H.apply_lc_bleed(15)
		H.Knockdown(20)
		qdel(src)
