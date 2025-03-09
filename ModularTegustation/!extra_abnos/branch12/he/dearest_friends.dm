/mob/living/simple_animal/hostile/abnormality/branch12/friends
	name = "Dearest Friends"
	desc = "A noble soul, no matter the act."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "dearest_friend"
	icon_living = "dearest_friend"

	del_on_death = TRUE
	maxHealth = 500	//Starts off slow, gets stronger quickly
	health = 500
	rapid_melee = 1
	move_to_delay = 2.5
	damage_coeff = list(RED_DAMAGE = 1.6, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.4)
	melee_damage_lower = 8
	melee_damage_upper = 12
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bites"
	attack_verb_simple = "bites"
	faction = list("neutral")
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 50, 50, 60, 60),
		ABNORMALITY_WORK_INSIGHT = list(60, 60, 70, 80, 80),
		ABNORMALITY_WORK_ATTACHMENT = list(35, 40, 45, 50, 50),
		ABNORMALITY_WORK_REPRESSION = list(45, 40, 30, 25, 15),
	)
	max_boxes = 10
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/nightmares,
		/datum/ego_datum/armor/branch12/nightmares,
	)
	//gift_type =  /datum/ego_gifts/nightmares
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/strength = 0
	var/heal_amount = 10

/mob/living/simple_animal/hostile/abnormality/branch12/friends/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)

		//Increase damage and set to red
		work_damage_amount = 16
		work_damage_type = RED_DAMAGE

		//Now becomes a stronger hostile breach
		maxHealth = 1500
		health = 1500
		faction = list("hostile")
		melee_damage_type = RED_DAMAGE

		//Increase the amount of PE we can make from HE to Waw level
		max_boxes = 24
		datum_reference.max_boxes = 24
		icon_state = "plushie_snake"
		icon_living = "plushie_snake"

	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(2)

	return

/mob/living/simple_animal/hostile/abnormality/branch12/friends/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target) && melee_damage_type == WHITE_DAMAGE)
		for(var/mob/living/carbon/human/M in view(7, src))
			M.deal_damage(WHITE_DAMAGE, 10)
			M.adjustSanityLoss(-heal_amount) // It heals everyone by 50 or 100 points


	if(ishuman(attacked_target) && melee_damage_type == RED_DAMAGE)
		var/mob/living/carbon/human/L = attacked_target
		// Deal more damage to level 3 prudence or higher
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)

		if(get_attribute_level(L, PRUDENCE_ATTRIBUTE) >= 60)
			melee_damage_lower *= 3
			melee_damage_upper *= 3
			if(prob(50))
				strength++

		L.apply_lc_bleed(strength)

