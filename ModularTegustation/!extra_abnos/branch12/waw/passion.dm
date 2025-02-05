/mob/living/simple_animal/hostile/abnormality/branch12/passion
	name = "Passion of Love in Death"
	desc = "A tall figure with a butterfly for a head. wings sprout behind it"
	icon = 'ModularTegustation/Teguicons/branch12/64x96.dmi'
	icon_state = "passion"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 50, 50, 55, 55),
		ABNORMALITY_WORK_INSIGHT = list(35, 35, 40, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(65, 65, 65, 80, 80),
		ABNORMALITY_WORK_REPRESSION = list(30, 30, 0, 0, 0),
	)
	start_qliphoth = 2
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	ego_list = list(
		//datum/ego_datum/weapon/passion
		//datum/ego_datum/armor/passion,
	)
	//gift_type =  /datum/ego_gifts/passion
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/passion/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 80)
		datum_reference.qliphoth_change(-1)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) > 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/passion/ZeroQliphoth()
	..()

	var/list/makecrazy = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		makecrazy+=H

	for(var/i = 1 to 1+length(makecrazy/3))
		for(var/mob/living/carbon/human/H in makecrazy)
		//Replaces AI with murder one
			if(!H.sanity_lost)
				H.adjustSanityLoss(500)
			QDEL_NULL(H.ai_controller)
			H.ai_controller = /datum/ai_controller/insane/murder/passion
			H.InitializeAIController()


/datum/ai_controller/insane/murder/passion
	lines_type = /datum/ai_behavior/say_line/insanity_passion

/datum/ai_behavior/say_line/insanity_passion
	lines = list(
		"The thrill of the fight!",
		"I'll kill you!",
	)
