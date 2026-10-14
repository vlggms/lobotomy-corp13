/datum/species/naked_victim
	name = "O-02-74"
	id = "nest"
	sexes = FALSE
	species_traits = list(NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_GENELESS,)
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	no_equip = list(ITEM_SLOT_GLOVES,)

/mob/living/carbon/human/species/naked_victim
	race = /datum/species/naked_victim

/datum/species/naked_victim/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE
