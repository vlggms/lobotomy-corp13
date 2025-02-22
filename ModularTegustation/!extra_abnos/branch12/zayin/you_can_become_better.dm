/mob/living/simple_animal/hostile/abnormality/branch12/become_better
	name = "You Can Become Better"
	desc = "A human-sized container with a blinding light coming from inside"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "becomebetter"
	icon_living = "becomebetter"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 25,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	threat_level = ZAYIN_LEVEL
	max_boxes = 10

	light_color = COLOR_VERY_SOFT_YELLOW
	light_range = 2
	light_power = 1

	ego_list = list(
		/datum/ego_datum/weapon/branch12/becoming,
		/datum/ego_datum/armor/branch12/becoming,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/become_better/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			user.adjust_attribute_level(FORTITUDE_ATTRIBUTE, -5)
			user.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 3)

		if(ABNORMALITY_WORK_INSIGHT)
			user.adjust_attribute_level(PRUDENCE_ATTRIBUTE, -5)
			user.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 3)

		if(ABNORMALITY_WORK_ATTACHMENT)
			user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, -5)
			user.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 3)

		if(ABNORMALITY_WORK_REPRESSION)
			user.adjust_attribute_level(JUSTICE_ATTRIBUTE, -5)
			user.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 3)


