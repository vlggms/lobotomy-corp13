/mob/living/simple_animal/hostile/abnormality/branch12/coin_chance
	name = "You Can Become Better"
	desc = "A human-sized container with a blinding light coming from inside"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "becomebetter"
	icon_living = "becomebetter"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 80,
		ABNORMALITY_WORK_INSIGHT = 80,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_amount = 5
	work_damage_type = PALE_DAMAGE
	threat_level = TETH_LEVEL

	ego_list = list(
		//datum/ego_datum/weapon/serenity,
		//datum/ego_datum/armor/serenity,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/coin_chance/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
		if(ABNORMALITY_WORK_INSIGHT)

		if(ABNORMALITY_WORK_ATTACHMENT)
		if(ABNORMALITY_WORK_REPRESSION)

