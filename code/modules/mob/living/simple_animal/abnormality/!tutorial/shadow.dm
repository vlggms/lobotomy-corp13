/mob/living/simple_animal/hostile/abnormality/shadow
	name = "Shadow Man"
	desc = "A humanoid that reflects no "
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "shadow"
	icon_living = "shadow"
	maxHealth = 75
	health = 75
	threat_level = TETH_LEVEL
	fear_level = 0
	move_to_delay = 5
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 70,
						ABNORMALITY_WORK_INSIGHT = 0,
						ABNORMALITY_WORK_ATTACHMENT = 80,
						ABNORMALITY_WORK_REPRESSION = 70,
						)
	melee_damage_lower = 4
	melee_damage_upper = 6
	melee_damage_type = BLACK_DAMAGE

	work_damage_amount = 4
	work_damage_type = BLACK_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear

/mob/living/simple_animal/hostile/abnormality/shadow/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	addtimer(CALLBACK(src, .proc/die), 60 SECONDS)

/mob/living/simple_animal/hostile/abnormality/shadow/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/shadow/proc/die()
	QDEL_NULL(src)

