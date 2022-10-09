/mob/living/simple_animal/hostile/abnormality/bill
	name = "Bill"
	desc = "That's Bill from accounting. He agreed to do this job for us. He gets paid extra for it."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bill"
	icon_living = "bill"
	maxHealth = 40
	health = 40
	threat_level = TETH_LEVEL
	move_to_delay = 5
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 80,
						ABNORMALITY_WORK_ATTACHMENT = 80,
						ABNORMALITY_WORK_REPRESSION = 80,
						)
	melee_damage_lower = 4
	melee_damage_upper = 6
	melee_damage_type = RED_DAMAGE

	work_damage_amount = 4
	work_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear

/mob/living/simple_animal/hostile/abnormality/bill/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/bill/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	addtimer(CALLBACK(src, .proc/die), 60 SECONDS)


/mob/living/simple_animal/hostile/abnormality/bill/proc/die()
	QDEL_NULL(src)

