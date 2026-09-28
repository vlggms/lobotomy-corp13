/datum/species/pumpkinhead
	name = "Jack"
	id = "jack"
	sexes = FALSE

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_GENELESS)
	use_skintones = FALSE
	changesource_flags = MIRROR_BADMIN | WABBAJACK

/datum/species/pumpkinhead/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE

