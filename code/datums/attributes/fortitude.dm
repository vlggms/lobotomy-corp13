/datum/attribute/fortitude
	name = FORTITUDE_ATTRIBUTE
	desc = "Attribute responsible for maximum health level."
	affected_stats = list("Max Health")
	initial_stat_value = DEFAULT_HUMAN_MAX_HEALTH

/datum/attribute/fortitude/get_printed_level_bonus()
	return max(initial_stat_value, round(get_level()) * FORTITUDE_MOD))

