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
	species_language_holder = /datum/language_holder/cuckoospawn
	mutanteyes = /obj/item/organ/eyes/night_vision/cuckoo
	limbs_id = "cuckoo"
	say_mod = "chrips"
	no_equip = list(ITEM_SLOT_EYES, ITEM_SLOT_MASK, ITEM_SLOT_FEET, ITEM_SLOT_OCLOTHING)
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	liked_food = MEAT | RAW
	disliked_food = VEGETABLES | DAIRY
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	punchdamagelow = 24
	punchdamagehigh = 27
	stunmod = 0.5
	redmod = 0.4
	whitemod = 0.1
	blackmod = 0.2
	palemod = 0.5
	speedmod = -0.5
	payday_modifier = 0

/datum/species/cuckoospawn/random_name(gender,unique,lastname)
	return "Jiajiaren"

/mob/living/carbon/human/species/cuckoospawn
	race = /datum/species/cuckoospawn
	faction = list("hostile", "cuckoospawn", "city")
	var/datum/martial_art/cuckoopunch/cuckoopunch

/mob/living/carbon/human/species/cuckoospawn/Login()
	. = ..()
	if(mind) //Just a back up, if somehow this proc gets triggered without a mind.
		cuckoopunch = new(null)
		cuckoopunch.teach(src)

/mob/living/carbon/human/species/cuckoospawn/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 1, -6)
	adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 250)
	adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 200)

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

/obj/item/organ/eyes/night_vision/cuckoo
	name = "bird-eye"
	desc = "Bright open, always looking for their new prey in the dark..."
