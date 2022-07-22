/mob/living/simple_animal/hostile/abnormality/training_rabbit
	name = "Standard training-dummy rabbit"
	desc = "A rabbit-like training dummy. Should be completely harmless."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	icon_living = "training_rabbit"
	maxHealth = 250
	health = 250
	threat_level = TETH_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 65,
						ABNORMALITY_WORK_INSIGHT = 65,
						ABNORMALITY_WORK_ATTACHMENT = 85,
						ABNORMALITY_WORK_REPRESSION = 45
						)
	work_damage_amount = 1
	work_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	faction = list("neutral")
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear

	ego_list = list(
		/datum/ego_datum/weapon/training,
		/datum/ego_datum/armor/training
		)
