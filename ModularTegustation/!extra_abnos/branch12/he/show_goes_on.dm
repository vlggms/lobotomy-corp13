/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on
	name = "The Show Goes On"
	desc = "A simple stage featuring odd red curtains, and shapes swirling in front of it."
	icon = 'ModularTegustation/Teguicons/branch12/48x64.dmi'
	icon_state = "show_goes"
	pixel_x = -8
	base_pixel_x = -8
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 60, 65, 30, 25),
		ABNORMALITY_WORK_INSIGHT = list(30, 35, 55, 60, 65),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = list(55, 30, 35, 40, 50),
	)
	work_damage_amount = 7
	work_damage_type = RED_DAMAGE


	ego_list = list(
		/datum/ego_datum/weapon/branch12/perfectionist,
		/datum/ego_datum/armor/branch12/perfectionist,
	)
	//gift_type = /datum/ego_gifts/perfectionist
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/max_works = 5
	var/works = 0


/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	user.adjustBruteLoss(-user.maxHealth*0.2)
	user.adjustSanityLoss(-user.maxSanity*0.2)

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	REMOVE_TRAIT(user, TRAIT_NODEATH, "memento_mori")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "memento_mori")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "memento_mori")


	//Only start another work if you live the work
	if(user.health > 0)
		if(pe<=datum_reference.max_boxes-3 && works <= max_works)	//Have to get equal to or more than max boxes minus 2, max 5 works
			works ++
			ForceToWork(user, work_type, TRUE)
			return

	work_damage_amount = initial(work_damage_amount)
	works = 0

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/AttemptWork(mob/living/carbon/human/user, work_type)
	//This means that you don't die until the end of the work
	ADD_TRAIT(user, TRAIT_NODEATH, "memento_mori")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "memento_mori")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "memento_mori")
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/Worktick(mob/living/carbon/human/user)
	..()
	//If you're dying, continue the work until the end, but take consistent damage
	if(user.health < 0)
		work_damage_amount +=2

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/WorktickFailure(mob/living/carbon/human/user)
	..( )
	//Worktick failures increase damage gives
	work_damage_amount ++
	return

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/proc/ForceToWork(mob/living/carbon/human/user, work_type, forced)
	DropPlayerByConsole(user)
	SLEEP_CHECK_DEATH(5)
	if(AttemptWork(user, work_type, TRUE))
		datum_reference.console.start_work(user, work_type)
		to_chat(user, span_userdanger("You must continue!"))

/mob/living/simple_animal/hostile/abnormality/branch12/show_goes_on/proc/DropPlayerByConsole(mob/living/carbon/human/user)
	var/turf/dispense_turf = get_step(datum_reference.console, pick(2,8,10)) //south, west, southwest
	if(!isopenturf(dispense_turf))
		dispense_turf = get_turf(datum_reference.console)
	user.forceMove(dispense_turf)
	user.SetImmobilized(30, ignore_canstun = TRUE)

