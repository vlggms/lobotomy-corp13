/mob/living/simple_animal/hostile/abnormality/fairy_swarm
	name = "Fairy Swarm"
	desc = "A swarm of chittering fairies"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fairies"
	icon_living = "fairies"
	maxHealth = 50
	health = 50
	is_flying_animal = TRUE
	threat_level = TETH_LEVEL
	fear_level = 0
	move_to_delay = 5
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 60,
						ABNORMALITY_WORK_ATTACHMENT = 80,
						ABNORMALITY_WORK_REPRESSION = 70,
						)
	melee_damage_lower = 3
	melee_damage_upper = 5
	melee_damage_type = PALE_DAMAGE

	work_damage_amount = 4
	work_damage_type = PALE_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
	pinkable = FALSE

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/breach_effect(mob/living/carbon/human/user)
	..()
	GiveTarget(user)
	addtimer(CALLBACK(src, .proc/die), 60 SECONDS)

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_swarm/proc/die()
	QDEL_NULL(src)

