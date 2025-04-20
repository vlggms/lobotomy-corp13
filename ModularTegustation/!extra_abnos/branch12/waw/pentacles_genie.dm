/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie
	name = "Genie of Pentacles"
	desc = "A belly dancer wearing a purple and gold outfit."
	icon = 'ModularTegustation/Teguicons/branch12/32x48.dmi'
	icon_state = "pentacle_genie"
	icon_living = "pentacle_genie"
	del_on_death = TRUE

	maxHealth = 99999
	health = 99999
	rapid_melee = 2
	move_to_delay = 5
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)	//Supposed to be invincible

	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 1

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 25, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 50, 50, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
	)
	work_damage_amount = 12
	work_damage_type =  BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/ten_thousand_dolers,
		/datum/ego_datum/armor/branch12/ten_thousand_dolers,
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/coinsleft
	var/list/affected_players = list()

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/Life()
	..()
	for(var/obj/item/red_coin/I in range(1, src))
		qdel(I)
		coinsleft--
		say("Thanks for finding my coin!")
		for(var/mob/living/carbon/human/H in affected_players)
			H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 10)
			H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 10)
			H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 10)
			H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 10)

	if(coinsleft == 0)
		death()

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	for(var/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/L in GLOB.mob_list)
		if(L!=src && !L.IsContained())
			qdel(src)
			return

	for(var/i = 1 to 8)
		var/turf/W = pick(GLOB.xeno_spawn)
		new /obj/item/red_coin (get_turf(W))
		coinsleft++
	..()

	var/turf/T = pick(GLOB.department_centers)
	forceMove(T)
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		affected_players +=H
		H.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -80)
		H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -80)
		H.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -80)
		H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -80)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/pentacle_genie/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/obj/item/red_coin
	name = "red coin"
	desc = "A red coin. You feel like a genie might be able to use this."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "red_coin"

