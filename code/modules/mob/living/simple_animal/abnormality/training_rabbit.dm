/mob/living/simple_animal/hostile/abnormality/bald
	name = "standard training-dummy rabbit"
	desc = "A rabbit-like training dummy. Should be completely harmless."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	icon_living = "training_rabbit"
	maxHealth = 150
	health = 150
	is_flying_animal = TRUE
	threat_level = TETH_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 65,
						ABNORMALITY_WORK_INSIGHT = 65,
						ABNORMALITY_WORK_ATTACHMENT = 85,
						ABNORMALITY_WORK_REPRESSION = 45
						)
	work_damage_amount = 1
	work_damage_type = RED_DAMAGE
	faction = list("neutral")
	can_breach = TRUE
	start_qliphoth = 1
	can_spawn = FALSE // Normally doesn't appear
