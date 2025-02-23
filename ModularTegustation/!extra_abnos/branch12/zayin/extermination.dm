/mob/living/simple_animal/hostile/abnormality/branch12/extermination
	name = "Extermination Order"
	desc = "A signed and stamped order for 'pest control'"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "extermination"
	icon_living = "extermination"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 80, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 80,
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE
	threat_level = ZAYIN_LEVEL

	ego_list = list(
		/datum/ego_datum/weapon/branch12/exterminator,
		/datum/ego_datum/armor/branch12/exterminator,
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/extermination/SuccessEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	var/list/damage_these = list()
	var/list/possible_breachers = list()
	for(var/mob/living/simple_animal/hostile/abnormality/V in GLOB.abnormality_mob_list)
		if(V.can_breach && V.IsContained() && V.z == z)
			possible_breachers+=V
		if(!V.IsContained())
			damage_these+=V

	if(length(damage_these))
		for(var/mob/living/simple_animal/hostile/abnormality/D in damage_these)
			if(D.damage_coeff == list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
				return
			D.adjustBruteLoss(D.maxHealth*0.3)


	if(!length(possible_breachers))
		to_chat(user, span_notice("No one took your contract."))
		return
	var/mob/living/simple_animal/hostile/abnormality/breaching = pick(possible_breachers)
	breaching.datum_reference.qliphoth_change(-99)
	breaching.faction = list("Extermination")
	return
