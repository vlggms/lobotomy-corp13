/mob/living/simple_animal/hostile/abnormality/beauty
	name = "Beauty and the Beast"
	desc = "However, the curse continues eternally, never broken."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "beauty"
	maxHealth = 650
	health = 650
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 20, -20, -20, -20),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, -50, -50, -50),
		ABNORMALITY_WORK_REPRESSION = list(65, 65, 65, 65, 65)
		)
	work_damage_amount = 3
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/horn,
		/datum/ego_datum/armor/horn
		)

	var/injured = FALSE
	var/dead = FALSE


/mob/living/simple_animal/hostile/abnormality/beauty/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(!injured)
			injured = TRUE
			icon_state = "beauty_injured"

		else
			//If you already did repression, die. Fuck you.
			user.gib()
			injured = FALSE

			icon_state = "beauty_dead"
			animate(src, alpha = 0, time = 10 SECONDS)
			QDEL_IN(src, 10 SECONDS)


	else
		injured = FALSE
		icon_state = "beauty"
	return


