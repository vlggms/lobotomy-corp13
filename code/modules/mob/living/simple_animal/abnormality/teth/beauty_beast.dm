/mob/living/simple_animal/hostile/abnormality/beauty
	name = "Beauty and the Beast"
	desc = "A quadruped monster covered in brown fur. The amount of the eyes it has is impossible to count."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "beauty"
	icon_living = "beauty"
	icon_dead = "beauty_dead"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 650
	health = 650
	del_on_death = FALSE
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 20, -20, -20, -20),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, -50, -50, -50),
		ABNORMALITY_WORK_REPRESSION = 65
		)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/horn,
		/datum/ego_datum/armor/horn
		)
	gift_type =  /datum/ego_gifts/horn
	var/injured = FALSE

/mob/living/simple_animal/hostile/abnormality/beauty/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/beauty/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(!injured)
			injured = TRUE
			icon_state = "beauty_injured"

		else if (!(GODMODE in user.status_flags))//If you already did repression, die.
			user.gib()
			death()

	else
		injured = FALSE
		icon_state = icon_living
	return


