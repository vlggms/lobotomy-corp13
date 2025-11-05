/datum/attribute/prudence
	name = PRUDENCE_ATTRIBUTE
	desc = "Attribute responsible for maximum sanity points."
	affected_stats = list("Max Sanity")
	initial_stat_value = DEFAULT_HUMAN_MAX_SANITY

/datum/attribute/prudence/get_printed_level_bonus()
	return max(initial_stat_value, round(get_level() * PRUDENCE_MOD))
