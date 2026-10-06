/datum/species/fake_pinocchio//Identical to the abnormality, but lacks the traits that make it impractical or overpowered
	name = "F-04-160"
	id = "pinocchio"
	limbs_id = "puppet"
	sexes = FALSE
	hair_color = "352014"
	say_mod = "creaks, snaps"
	attack_verb = "slash"
	attack_sound = 'sound/abnormalities/pinocchio/attack.ogg'
	miss_sound = 'sound/abnormalities/pinocchio/attack.ogg'
	meat = /obj/item/stack/sheet/mineral/wood
	knife_butcher_results = list(/obj/item/stack/sheet/mineral/wood = 5)
	species_traits = list(NOBLOOD,NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_GENELESS,)
	changesource_flags = MIRROR_BADMIN | WABBAJACK

/mob/living/carbon/human/species/fake_pinocchio //a real boy. Compatiable with being spawned by admins to boot! Can't panic outside of fear, though.
	race = /datum/species/fake_pinocchio

/datum/species/fake_pinocchio/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE
