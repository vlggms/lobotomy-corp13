/mob/living/simple_animal/hostile/abnormality/branch12/coin_chance
	name = "Chance Coin"
	desc = "A table stands in front of you with a card and stacks of chips."
	icon = 'ModularTegustation/Teguicons/branch12/32x64.dmi'
	icon_state = "coin_chance"
	icon_living = "coin_chance"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_amount = 5
	work_damage_type = PALE_DAMAGE
	threat_level = TETH_LEVEL

	ego_list = list(
		/datum/ego_datum/weapon/branch12/slot_machine,
		/datum/ego_datum/armor/branch12/slot_machine,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/coin_chance/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			if(prob(50))
				to_chat(user, span_nicegreen("You flip a red chip. It lands on heads."))
				user.adjustBruteLoss(-40)
				return
			to_chat(user, span_warning("You flip a red chip. It lands on tails."))
			user.adjustBruteLoss(40)

		if(ABNORMALITY_WORK_INSIGHT)
			if(prob(50))
				user.adjustSanityLoss(-40)
				to_chat(user, span_nicegreen("You flip a white chip. It lands on heads."))
				return
			user.adjustSanityLoss(40)
			to_chat(user, span_warning("You flip a white chip. It lands on tails."))

		if(ABNORMALITY_WORK_ATTACHMENT)
			if(prob(50))
				user.adjustBruteLoss(-40)
				user.adjustSanityLoss(-40)
				to_chat(user, span_nicegreen("You flip a purple chip. It lands on heads."))
				return
			user.adjustSanityLoss(40)
			user.adjustBruteLoss(40)
			to_chat(user, span_warning("You flip a purple chip. It lands on tails."))

		if(ABNORMALITY_WORK_REPRESSION)
			if(prob(50))
				user.adjust_all_attribute_levels(5)
				to_chat(user, span_nicegreen("You flip a blue chip. It lands on heads."))
				return
			user.adjust_all_attribute_levels(-5)
			to_chat(user, span_warning("You flip a blue chip. It lands on tails."))


