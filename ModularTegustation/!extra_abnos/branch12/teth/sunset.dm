/mob/living/simple_animal/hostile/abnormality/branch12/sunset
	name = "Sunset at the Pyramids"
	desc = "A large sandstone monolith covered in lotuses"
	icon = 'ModularTegustation/Teguicons/branch12/32x48.dmi'
	icon_state = "sunset_none"
	icon_living = "sunset_none"
	threat_level = TETH_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 5
	work_damage_type = PALE_DAMAGE //placeholder for the first work

	ego_list = list(
		/datum/ego_datum/weapon/branch12/white_lotus,
		/datum/ego_datum/weapon/branch12/black_lotus,
		/datum/ego_datum/armor/branch12/white_lotus,
	)

	var/list/lotus = list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)
	var/wanted_work
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/sunset/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	wanted_work = pick(lotus)
	switch(wanted_work)
		if(ABNORMALITY_WORK_INSTINCT)
			work_damage_type = RED_DAMAGE
			work_damage_amount = 10
			icon_state = "sunset_red"
		if(ABNORMALITY_WORK_INSIGHT)
			work_damage_type = WHITE_DAMAGE
			work_damage_amount = 10
			icon_state = "sunset_white"
		if(ABNORMALITY_WORK_ATTACHMENT)
			work_damage_type = BLACK_DAMAGE
			work_damage_amount = 10
			icon_state = "sunset_black"
		if(ABNORMALITY_WORK_REPRESSION)
			work_damage_type = PALE_DAMAGE
			work_damage_amount = 7
			icon_state = "sunset_pale"
	if(work_type != wanted_work)
		switch(wanted_work)
			if(ABNORMALITY_WORK_INSTINCT)
				user.adjust_attribute_level(FORTITUDE_ATTRIBUTE, -3)
			if(ABNORMALITY_WORK_INSIGHT)
				user.adjust_attribute_level(PRUDENCE_ATTRIBUTE, -3)
			if(ABNORMALITY_WORK_ATTACHMENT)
				user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, -3)
			if(ABNORMALITY_WORK_REPRESSION)
				user.adjust_attribute_level(JUSTICE_ATTRIBUTE, -3)

/mob/living/simple_animal/hostile/abnormality/branch12/sunset/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if (!wanted_work)
		return
	if(work_type == wanted_work)
		return chance + 40
	return chance - 20
