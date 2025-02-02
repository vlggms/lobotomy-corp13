/mob/living/simple_animal/hostile/abnormality/branch12/need_you
	name = "Your Friends Need You"
	desc = "A human-sized container with a skull shaped head"
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "needyou"
	icon_living = "needyou"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 25,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = 70,
		"Enter Device" = -500,
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE
	threat_level = ZAYIN_LEVEL
	max_boxes = 10

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	ego_list = list(
		/datum/ego_datum/weapon/branch12/needing,
		/datum/ego_datum/armor/branch12/needing,
	)
	var/list/nerds = list()

/mob/living/simple_animal/hostile/abnormality/branch12/need_you/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type == "Enter Device") && !(user.ckey in nerds))
		nerds += user.ckey
		user.gib()
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.stat == DEAD)
				continue
			if(!(H.mind.assigned_role in GLOB.security_positions))
				continue

			to_chat(H, span_notice("You feel the strength of comrades lost."))
			H.adjust_all_attribute_levels(get_user_level(user)*get_user_level(user))
		return FALSE

	else if(user.ckey in nerds)
		to_chat(user, span_notice("you are punished for your disingenuity."))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "SHAME [user.name]", 25))
		user.dust()
		return FALSE

	return TRUE

