// can't find sprites for ego weapon/suit/gift, for the love of god please change my sprites

/mob/living/simple_animal/hostile/abnormality/ppodae
	name = "Ppodae"
	desc = "The Goodest Boy in the World"
	icon = 'icons/mob/ppodae.dmi'
	icon_state = "ppodae"
	icon_living = "ppodae"
	maxHealth = 400 //fast but low hp abno
	health = 400
	threat_level = TETH_LEVEL
	move_to_delay = 1
	faction = list("hostile")
	response_help_continuous = "pet"
	response_help_simple = "pet"
	response_disarm_continuous = "stroke"
	response_disarm_simple = "stroke"
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 60,
						ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
						ABNORMALITY_WORK_ATTACHMENT = 40,
						ABNORMALITY_WORK_REPRESSION = list(40, 40, 30, 30, 30),
						)
	work_damage_amount = 4
	work_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_breach = TRUE
	start_qliphoth = 2
	vision_range = 14
	aggro_vision_range = 20
	melee_damage_lower = 7
	melee_damage_upper = 10
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/effects/tableslam.ogg'
	stat_attack = HARD_CRIT
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	
	ego_list = list(
		/datum/ego_datum/weapon/cute,
		/datum/ego_datum/armor/cute
		)
	gift_type =  /datum/ego_gifts/cute

/mob/living/simple_animal/hostile/abnormality/ppodae/AttackingTarget()
	. = ..()
	if(.)
		var/mob/living/carbon/L = target
		if(L.health < 0 || L.stat == DEAD)
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
				L.adjustBruteLoss(200)
				bp.loc = T // Teleports limb to containment
				QDEL_NULL(src)
				// Taken from eldritch_demons.dm

/mob/living/simple_animal/hostile/abnormality/ppodae/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type != ABNORMALITY_WORK_INSTINCT && prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/ppodae/breach_effect(mob/living/carbon/human/user)
	..()
	icon_state = "ppodae_active"
	GiveTarget(user)
	T = get_turf(src)
