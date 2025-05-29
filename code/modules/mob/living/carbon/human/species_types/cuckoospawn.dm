/datum/species/cuckoospawn
	name = "Cuckoospawn"
	id = "cuckoo"
	mutant_bodyparts = list()
	say_mod = "chrips"
	sexes = 0 // cuckoo has no need for this

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_PERFECT_ATTACKER, TRAIT_BRUTEPALE, TRAIT_BRUTESANITY, TRAIT_SANITYIMMUNE, TRAIT_GENELESS, TRAIT_COMBATFEAR_IMMUNE)
	use_skintones = FALSE
	limbs_id = "cuckoo"
	no_equip = list(ITEM_SLOT_EYES, ITEM_SLOT_MASK)
	changesource_flags = MIRROR_BADMIN | WABBAJACK

// /datum/species/cuckoospawn/random_name(gender,unique,lastname)
// 	var/shrimp_name = pick(special_names)
// 	if(prob(human_name_chance))
// 		shrimp_name = pick(GLOB.last_names)
// 	return shrimp_name // 95% chance to pick a shrimp name, 5% to pick a human lastname. These guys only use one name

/mob/living/carbon/human/species/cuckoospawn
	race = /datum/species/cuckoospawn
	faction = list("hostile", "cuckoospawn", "city")

/datum/species/cuckoospawn/harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(ishuman(target))
		var/obj/item/bodypart/chest/LC = target.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(target)
			var/turf/T = get_turf(target)
			log_game("[key_name(target)] was impregnated by a cockoospawn at [loc_name(T)]")
	. = ..()

/mob/living/carbon/human/species/cuckoospawn/Initialize()
	. = ..()
	melee_damage_lower = 23
	melee_damage_upper = 30
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 1, -6)

/mob/living/carbon/human/species/cuckoospawn/attack_ghost(mob/dead/observer/ghost)
	if(key)
		to_chat(ghost, span_notice("Somebody is already controlling this bird."))
		return

	var/response = alert(ghost, "Do you want to take over this bird?", "Soul transfer", "Yes", "No")
	if(response == "No")
		return

	if(key)
		to_chat(ghost, span_notice("Somebody has taken this bird whilst you were busy selecting!"))
		return

	ckey = ghost.client.ckey
	to_chat(src, span_info("You are a Cuckoospawn, you only have one goal in mind. Expand and Multiply. Your melee attack have a chance of infecting your target with a Cuckoospawn Larva"))
