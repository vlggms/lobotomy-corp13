/mob/living/simple_animal/hostile/abnormality/despair_knight
	name = "Knight of Despair"
	desc = "A tall humanoid abnormality in a blue dress. \
	Half of her head is black with sharp horn segments protruding out of it."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair"
	icon_living = "despair"

	pixel_x = -8
	base_pixel_x = -8

	ranged = TRUE
	minimum_distance = 4

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.4)
	stat_attack = HARD_CRIT

	speed = 3
	move_to_delay = 4
	threat_level = WAW_LEVEL

	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 0,
						ABNORMALITY_WORK_INSIGHT = 45,
						ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
						ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 35, 30)
						)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/despair,
		/datum/ego_datum/armor/despair
		)

	can_spawn = FALSE

	var/mob/living/carbon/human/blessed_human = null

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/BlessedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	//breach_effect() // REMIND ME TO DO SOMETHING COOL HERE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/success_effect(mob/living/carbon/human/user, work_type, pe)
	if(!blessed_human)
		blessed_human = user
		RegisterSignal(blessed_human, COMSIG_LIVING_DEATH, .proc/BlessedDeath)
		to_chat(blessed_human, "<span class='nicegreen'>You feel protected.</span>")
		var/datum/physiology/P = blessed_human.physiology
		if(!istype(P))
			return
		P.red_mod = 0.5
		P.white_mod = 0.5
		P.black_mod = 0.5
		P.pale_mod = 2
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/breach_effect(mob/living/carbon/human/user)
	..()
	icon_living = "despair_breach"
	icon_state = icon_living
	return
