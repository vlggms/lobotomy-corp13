/datum/attribute/fortitude
	name = FORTITUDE_ATTRIBUTE
	desc = "Attribute responsible for maximum health level."
	affected_stats = list("Max Health")
	initial_stat_value = DEFAULT_HUMAN_MAX_HEALTH

/datum/attribute/fortitude/get_printed_level_bonus()
	return round(level * FORTITUDE_MOD) + initial_stat_value

/datum/attribute/fortitude/on_update(mob/living/carbon/user)
	if(!istype(user))
		return FALSE
	user.death_threshold = HEALTH_THRESHOLD_DEAD - round((level + level_buff) * 0.5)
	user.hardcrit_threshold = HEALTH_THRESHOLD_FULLCRIT - round((level + level_buff) * 0.25)
	return TRUE
