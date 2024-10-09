/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user

	//To do: Refactor.
	var/list/datum/action/actions_levels = list(
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
		/datum/action/cooldown/shockwave = 2,
		/datum/action/cooldown/butcher = 2,
		/datum/action/cooldown/solarflare = 2,
		/datum/action/cooldown/confusion = 2,
		/datum/action/cooldown/lockpick = 2,
		/datum/action/cooldown/lifesteal = 2,
		/datum/action/innate/healthhud = 3,
		/datum/action/innate/bulletproof = 3,
		/datum/action/innate/battleready = 3,
		/datum/action/cooldown/timestop = 4,
		/datum/action/cooldown/reraise = 4,
		/datum/action/cooldown/dismember = 4,
		/datum/action/cooldown/warbanner = 4,
		/datum/action/cooldown/warcry = 4,
	)

/obj/item/book/granter/action/skill/on_reading_finished(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/user_level = get_civilian_level(human)
		if ((level != user_level && level != -1) )
			to_chat(user, span_notice("Your level is [user_level]. This book need level [level]!"))
			return FALSE
		if (!(user?.mind?.assigned_role in list("Civilian", "Rat")))
			to_chat(user, span_notice("Only Civilians and Rats can use this book!"))
			return FALSE
		for(var/datum/action/A in user.actions)
			if (actions_levels[A.type] == level)
				to_chat(user, span_notice("You already have a skill of this level!"))
				return FALSE

		to_chat(user,span_warning("[src] suddenly vanishes!"))
		qdel(src)
	..()

