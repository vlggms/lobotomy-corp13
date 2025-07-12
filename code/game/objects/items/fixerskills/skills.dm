/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user
	var/list/usable_roles = list("Civilian", "Office Director", "Office Fixer",
		"Subsidary Office Director", "Fixer")

	//To do: Refactor.
	var/static/list/datum/action/actions_levels = list(
		/datum/action/cooldown/dash = 1,
		/datum/action/cooldown/dash/back = 1,
		/datum/action/cooldown/smokedash = 1,
		/datum/action/cooldown/assault = 1,
		/datum/action/cooldown/retreat = 1,
		/datum/action/cooldown/healing = 1,
		/datum/action/cooldown/soothing = 1,
		/datum/action/cooldown/curing = 1,
		/datum/action/cooldown/firstaid = 1,
		/datum/action/cooldown/meditation = 1,
		/datum/action/cooldown/hunkerdown = 1,
		/datum/action/cooldown/mark = 1,
		/datum/action/cooldown/light = 1,

		/datum/action/cooldown/butcher = 2,
		/datum/action/cooldown/solarflare = 2,
		/datum/action/cooldown/confusion = 2,
		/datum/action/cooldown/lockpick = 2,
		/datum/action/cooldown/lifesteal = 2,
		/datum/action/cooldown/skulk = 2,
		/datum/action/cooldown/autoloader = 2,


		/datum/action/innate/healthhud = 3,
		/datum/action/innate/bulletproof = 3,
		/datum/action/innate/battleready = 3,
		/datum/action/innate/fleetfoot = 3,

		/datum/action/cooldown/timestop = 4,
		/datum/action/cooldown/dismember = 4,
		/datum/action/cooldown/shockwave = 4,
		/datum/action/cooldown/warbanner = 4,
		/datum/action/cooldown/warcry = 4,
		/datum/action/cooldown/nuke = 4,
		/datum/action/cooldown/reraise = 4,

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

		// Calculate actual grade (10 - grade value, with minimum of 1)
		var/actual_grade = max(10 - grade, 1)

		// Define allowed skills per grade
		var/list/allowed_skills = list(0, 0, 0, 0)
		switch(actual_grade)
			if(9)
				allowed_skills[1] = 5
			if(8)
				allowed_skills[1] = 3
			if(7)
				allowed_skills[1] = 1
				allowed_skills[2] = 1
			if(6)
				allowed_skills[2] = 2
			if(5)
				allowed_skills[3] = 1
			if(4)
				allowed_skills[4] = 1
			else
				to_chat(user, span_notice("Your grade is too low or too high to use skill books!"))
				return FALSE

		// Check if this skill level is allowed for the user's grade
		if(level == -1)
			to_chat(user, span_notice("This book is easy to read!")) //This is for debuging, letting you learn a skill at any level.
		else if(level < 1 || level > 4 || allowed_skills[level] == 0)
			wrong_grade_info(actual_grade, user)
			return FALSE

		if (!(user?.mind?.assigned_role in usable_roles))
			to_chat(user, span_notice("Only Civilians can use this book!"))
			return FALSE

		// Count existing skills by level
		var/list/current_skills = list(0, 0, 0, 0)
		for(var/datum/action/A in user.actions)
			var/skill_level = actions_levels[A.type]
			if(skill_level)
				if(!(skill_level in current_skills))
					current_skills[skill_level] = 0
				current_skills[skill_level]++

		// Check if user can learn this skill
		if(level != -1)
			var/current_count = current_skills[level]
			var/allowed_count = allowed_skills[level]

			if(current_count >= allowed_count)
				to_chat(user, span_notice("You already have the maximum number of level [level] skills for Grade [actual_grade]!"))
				return FALSE

			var/remaining = allowed_count - current_count
			to_chat(user, span_notice("You can learn [remaining] more level [level] skill\s."))

		to_chat(user,span_warning("[src] suddenly vanishes!"))
		qdel(src)
	..()

/obj/item/book/granter/action/skill/proc/wrong_grade_info(grade, mob/reader)
	if(level==1)
		to_chat(reader, span_notice("You are Grade [grade]. Only Grade 9, 8, and 7 Fixers are able to read this book!"))
	else if(level == 2)
		to_chat(reader, span_notice("You are Grade [grade]. Only Grade 7 and 6 Fixers are able to read this book!"))
	else if(level == 3)
		to_chat(reader, span_notice("You are Grade [grade]. Only Grade 5 Fixers are able to read this book!"))
	else if(level == 4)
		to_chat(reader, span_notice("You are Grade [grade]. Only Grade 4 Fixers are able to read this book!"))
