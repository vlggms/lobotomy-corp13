/datum/species/sephirah
	name = "Sephirah"
	id = "sephirah"
	mutant_bodyparts = list()
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

	inherent_biotypes = MOB_ROBOTIC
	sexes = 0
	meat = null
	nojumpsuit = TRUE

	limbs_id = "sephirah"
	say_mod = "boops" //You're a bobot
	species_traits = list(MUTCOLORS, NOEYESPRITES, NO_UNDERWEAR, AGENDER, NOBLOOD)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_VIRUSIMMUNE,TRAIT_NODISMEMBER,TRAIT_NOLIMBDISABLE,TRAIT_NOHUNGER,TRAIT_NOBREATH)
	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_HEAD, ITEM_SLOT_BACK, ITEM_SLOT_NECK, ITEM_SLOT_EYES)

	use_skintones = FALSE
