/mob/living/simple_animal/hostile/abnormality/oracle
	name = "Oracle of No Future"
	desc = "An ancient cryopod with the name 'Maria' etched into the side. \
		You look inside expecting to see the body of the person named, \
		but all you see is a gooey substance at the bottom."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "oracle"
	icon_living = "oracle"
	portrait = "oracle"
	maxHealth = 50
	health = 50
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 80,
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/tough,
		/datum/ego_datum/armor/tough,
	)
//	gift_type =  /datum/ego_gifts/oracle
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	chem_type = /datum/reagent/abnormality/bald
	var/currently_talking = FALSE

	var/list/sleeplines = list(
		"Hello...",
		"I am reaching you from beyond the veil...",
		"I cannot move, I cannot speak...",
		"But for you, I have some information to part...",
		"Please wait a moment while I retrieve it for you....",
		"Ah, I have information on the next ordeal.... as you call it...",
		"The next ordeal is...",
	)


/mob/living/simple_animal/hostile/abnormality/oracle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) //Sleep with her, so that you can get some information
		currently_talking = TRUE
		for(var/line in sleeplines)
			to_chat(user, span_notice(line))
			SLEEP_CHECK_DEATH(50)
			if(!PlayerAsleep(user))
				currently_talking = FALSE
				return
		currently_talking = FALSE
		if(!(SSlobotomy_corp.next_ordeal))
			to_chat(user, span_notice("Oh....? I have no information for you.... I apologize..."))
			return
		to_chat(user, span_notice("[SSlobotomy_corp.next_ordeal.name]"))


/mob/living/simple_animal/hostile/abnormality/oracle/proc/PlayerAsleep(mob/living/carbon/human/user)
	if(currently_talking && user.IsSleeping())
		return TRUE
	return FALSE
