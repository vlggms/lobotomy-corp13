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
	faction = list("cuckoospawn")
	var/datum/martial_art/cuckoopunch/cuckoopunch
	var/attempted_crosses = 0

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
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(CheckSpace))

/mob/living/carbon/human/species/cuckoospawn/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE)
	if(ishostile(AM))
		var/mob/living/simple_animal/hostile/hostile_friend = AM
		if(!faction_check_mob(hostile_friend, TRUE))
			to_chat(src, span_notice("They are dealing with their own thing, don't bother them."))
			return FALSE
	. = ..()

/mob/living/carbon/human/species/cuckoospawn/proc/CheckSpace(mob/user, atom/new_location)
	var/turf/newloc_turf = get_turf(new_location)
	var/valid_tile = TRUE

	var/area/new_area = get_area(newloc_turf)
	if(istype(new_area, /area/city))
		var/area/city/city_area = new_area
		if(city_area.in_city)
			if(attempted_crosses > 10)
				executed_claw()
			attempted_crosses++
			to_chat(src, span_danger("You feel a shiver down your spine, the city will not allow you to enter..."))
			valid_tile = FALSE

	if(!valid_tile)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/mob/living/carbon/human/species/cuckoospawn/proc/executed_claw()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = origin.GetAtmosAdjacentTurfs(1)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		new /obj/effect/temp_visual/dir_setting/claw_appears (T)
		break
	new /obj/effect/temp_visual/justitia_effect(get_turf(src))
	qdel(src)

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
	to_chat(src, span_info("You are a Cuckoospawn, you only have one goal in mind. Expand and Multiply. Use your 'Implant' skill to infect people."))

/obj/item/organ/eyes/night_vision/cuckoo
	name = "bird-eye"
	desc = "Bright open, always looking for their new prey in the dark..."
