/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user

	//To do: Refactor.
	var/static/list/datum/action/actions_levels = list(
		/datum/action/cooldown/dash = 1,
		/datum/action/cooldown/dash/back = 1,
		/datum/action/cooldown/smokedash = 1,
		/datum/action/cooldown/skulk = 1,
		/datum/action/cooldown/assault = 1,
		/datum/action/cooldown/retreat = 1,
		/datum/action/cooldown/healing = 1,
		/datum/action/cooldown/soothing = 1,
		/datum/action/cooldown/curing = 1,
		/datum/action/cooldown/firstaid = 1,
		/datum/action/cooldown/meditation = 1,
		/datum/action/cooldown/hunkerdown = 1,

		/datum/action/cooldown/shockwave = 2,
		/datum/action/cooldown/butcher = 2,
		/datum/action/cooldown/solarflare = 2,
		/datum/action/cooldown/confusion = 2,
		/datum/action/cooldown/lockpick = 2,
		/datum/action/cooldown/lifesteal = 2,

		/datum/action/innate/healthhud = 3,
		/datum/action/innate/bulletproof = 3,
		/datum/action/innate/battleready = 3,
		/datum/action/innate/fleetfoot = 3,

		/datum/action/cooldown/timestop = 4,
		/datum/action/cooldown/reraise = 4,
		/datum/action/cooldown/dismember = 4,
		/datum/action/cooldown/warbanner = 4,
		/datum/action/cooldown/warcry = 4,
		/datum/action/cooldown/nuke = 4,

		//These are all fishing skills
		/datum/action/cooldown/fishing/detect = 1,
		/datum/action/cooldown/fishing/scry = 1,
		/datum/action/cooldown/fishing/planet = 1,
		/datum/action/cooldown/fishing/planet2 = 1,
		/datum/action/cooldown/fishing/prayer = 1,
		/datum/action/cooldown/fishing/sacredword = 1,
		/datum/action/cooldown/fishing/love = 1,
		/datum/action/cooldown/fishing/moonmove = 1,
		/datum/action/cooldown/fishing/commune = 1,
		/datum/action/cooldown/fishing/fishlockpick = 1,
		/datum/action/cooldown/fishing/fishtelepathy = 1,

		/datum/action/cooldown/fishing/smite = 2,
		/datum/action/cooldown/fishing/might = 2,
		/datum/action/cooldown/fishing/awe = 2,
		/datum/action/cooldown/fishing/chakra = 2,

		/datum/action/cooldown/fishing/supernova = 4,
		/datum/action/cooldown/fishing/alignment = 4,
		/datum/action/cooldown/fishing/planetstop = 4,
	)

/obj/item/book/granter/action/skill/on_reading_finished(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/user_level = get_civilian_level(human)
		var/allowed_level1_skills = 3
		var/list/stats = list(
			FORTITUDE_ATTRIBUTE,
			PRUDENCE_ATTRIBUTE,
			TEMPERANCE_ATTRIBUTE,
			JUSTICE_ATTRIBUTE,
		)
		var/stattotal
		var/grade
		for(var/attribute in stats)
			stattotal += get_attribute_level(human, attribute)
		stattotal /= 4	// Potential is an average of stats
		grade = round((stattotal) / 20)	// Get the average level-20, divide by 20

		if ((level != user_level && level != -1) )
			if(user_level == 0 && level==1)	//Specific check for Grade 9s, throw these bastards a bone
				to_chat(user, span_notice("Your are able to get 5 skills of this level."))
				allowed_level1_skills = 5

			else
				wrong_grade_info(grade)
				return FALSE
		if (!(user?.mind?.assigned_role in list("Civilian")))
			to_chat(user, span_notice("Only Civilians can use this book!"))
			return FALSE

		for(var/datum/action/A in user.actions)
			if (actions_levels[A.type] == level && level == 1)
				allowed_level1_skills -= 1
				if(allowed_level1_skills == 0)
					to_chat(user, span_notice("You are out of skills for this level!"))
					return FALSE

			if (actions_levels[A.type] == level && level != 1)
				to_chat(user, span_notice("You already have a skill of this level!"))
				return FALSE


		to_chat(user,span_warning("[src] suddenly vanishes!"))
		qdel(src)
	..()

/obj/item/book/granter/action/skill/proc/wrong_grade_info(grade)
	if(level==1)
		to_chat(user, span_notice("You are Grade [max(10-grade, 1)]. Only Grade 9 and 8 Fixers are able to read this book!"))
	else if(level == 2)
		to_chat(user, span_notice("You are Grade [max(10-grade, 1)]. Only Grade 7 and 6 Fixers are able to read this book!"))
	else if(level == 3)
		to_chat(user, span_notice("You are Grade [max(10-grade, 1)]. Only Grade 5 Fixers are able to read this book!"))
	else if(level == 4)
		to_chat(user, span_notice("You are Grade [max(10-grade, 1)]. Only Grade 4 Fixers are able to read this book!"))
