/mob/living/simple_animal/hostile/abnormality/branch12/coin_chance
	name = "Coin Chance"
	desc = "A table stands in front of you with a card and stacks of chips."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "deal"
	icon_living = "deal"

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
			if(prob(50))
				to_chat(owner, span_nicegreen("You flip a red chip. It lands on heads."))
				user.adjustBruteloss(-40)
				return
			to_chat(owner, span_warning("You flip a red chip. It lands on tails."))
			user.adjustBruteloss(40)

		if(ABNORMALITY_WORK_INSIGHT)
			if(prob(50))
				user.adjustSanityloss(-40)
				to_chat(owner, span_nicegreen("You flip a blue chip. It lands on heads."))
				return
			user.adjustSanityloss(40)
			to_chat(owner, span_warning("You flip a blue chip. It lands on tails."))

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(prob(50))
				user.adjustBruteloss(-40)
				user.adjustSanityloss(-40)
				to_chat(owner, span_nicegreen("You flip a purple chip. It lands on heads."))
				return
			user.adjustSanityloss(40)
			user.adjustBruteloss(40)
			to_chat(owner, span_warning("You flip a purple chip. It lands on tails."))

		if(ABNORMALITY_WORK_REPRESSION)
			if(prob(50))
				user.adjust_attribute_level(FORTITUDE_ATTRIBUTE, -5)
				user.adjust_attribute_level(PRUDENCE_ATTRIBUTE, -5)
				user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, -5)
				user.adjust_attribute_level(JUSTICE_ATTRIBUTE, -5)
				to_chat(owner, span_nicegreen("You flip a blue chip. It lands on heads."))
				return
			user.adjust_attribute_level(FORTITUDE_ATTRIBUTE, 5)
			user.adjust_attribute_level(PRUDENCE_ATTRIBUTE, 5)
			user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, 5)
			user.adjust_attribute_level(JUSTICE_ATTRIBUTE, 5)
			to_chat(owner, span_warning("You flip a blue chip. It lands on tails."))


