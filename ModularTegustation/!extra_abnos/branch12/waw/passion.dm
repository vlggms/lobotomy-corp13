/mob/living/simple_animal/hostile/abnormality/branch12/passion
	name = "Passion of Love in Death"
	desc = "A tall figure with a butterfly for a head. wings sprout behind it"
	icon = 'ModularTegustation/Teguicons/branch12/64x96.dmi'
	icon_state = "passion"
	maxHealth = 400
	health = 400
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 50, 50, 55, 55),
		ABNORMALITY_WORK_INSIGHT = list(35, 35, 40, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(65, 65, 65, 80, 80),
		ABNORMALITY_WORK_REPRESSION = list(30, 30, 0, 0, 0),
	)
	start_qliphoth = 2
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/branch12/passion,
		/datum/ego_datum/armor/branch12/passion,
	)
	//gift_type =  /datum/ego_gifts/passion
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12


/mob/living/simple_animal/hostile/abnormality/branch12/passion/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 80)
		datum_reference.qliphoth_change(-1)
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) > 60)
		datum_reference.qliphoth_change(-1)

	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(prob(80))
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/passion/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(80))
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/branch12/passion/ZeroQliphoth()
	..()
	datum_reference.qliphoth_change(2)
	//Okay we're gonna make everyone go murder insane for like 5 seconds
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.sanity_lost)
			H.adjustSanityLoss(500)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/murder/passion
		H.InitializeAIController()

	addtimer(CALLBACK(src, PROC_REF(resane_everyone)), 5 SECONDS)


/mob/living/simple_animal/hostile/abnormality/branch12/passion/proc/resane_everyone()
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.sanity_lost)
			H.adjustSanityLoss(-500)


/datum/ai_controller/insane/murder/passion
	lines_type = /datum/ai_behavior/say_line/insanity_passion

/datum/ai_behavior/say_line/insanity_passion
	lines = list(
		"The thrill of the fight!",
		"I'll kill you!",
	)
