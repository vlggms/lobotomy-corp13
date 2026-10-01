/datum/species/sweeper
	name = "Sweeper"
	id = "sweeper"
	sexes = FALSE
	mutant_bodyparts = list("sweeper_tanks" = "Plain")

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_GENELESS)
	use_skintones = FALSE
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	no_equip = list(ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_NECK, ITEM_SLOT_EYES)
	hide_features = list("HIDE_SUIT" = TRUE, "HIDE_BELT" = TRUE, "HIDE_BACK" = TRUE)

/datum/species/sweeper/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE
