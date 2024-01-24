//Very simple, funny little guy.
/mob/living/simple_animal/hostile/abnormality/smile
	name = "Gone with a Simple Smile"
	desc = "An abnormality seeming to make up a floating cat face."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "smile"
	icon_living = "smile"
	del_on_death = TRUE
	maxHealth = 400		//He's a little shit.
	health = 400
	rapid_melee = 2
	move_to_delay = 2
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 5
	melee_damage_upper = 5
	is_flying_animal = TRUE
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_verb_continuous = "bumps"
	attack_verb_simple = "bumps"
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2

	ranged = 1
	retreat_distance = 3
	minimum_distance = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 80,
		ABNORMALITY_WORK_INSIGHT = 80,
		ABNORMALITY_WORK_ATTACHMENT = 80,
		ABNORMALITY_WORK_REPRESSION = 80,
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/trick,
		/datum/ego_datum/armor/trick,
	)
	gift_type =  /datum/ego_gifts/trick
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
		)

	var/lucky_counter



/mob/living/simple_animal/hostile/abnormality/smile/AttackingTarget()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.Knockdown(20)
		var/obj/item/held = L.get_active_held_item()
		L.dropItemToGround(held) //Drop weapon


	var/list/pullable = list()
	for (var/obj/item/ego_weapon/Y in range(1, src))
		pullable += Y

	for (var/obj/item/gun/ego_gun/Z in range(1, src))
		pullable += Z

	if(!LAZYLEN(pullable))
		return

	src.pulled(pick(pullable))

/mob/living/simple_animal/hostile/abnormality/smile/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(lucky_counter > 3)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/smile/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/smile/WorkChance(mob/living/carbon/human/user, chance)
	var/chance_modifier = 1
	lucky_counter = 0	//Counts how many stats are above 40

	for(var/attribute in stats)
		if(get_attribute_level(user, attribute)>= 40)
			chance_modifier *= 0.7
			lucky_counter += 1

	return chance * chance_modifier




