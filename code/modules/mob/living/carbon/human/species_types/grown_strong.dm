/datum/species/grown_strong
	name = "T-09-140-1"
	id = "strong"
	limbs_id = "human"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,HAS_FLESH,HAS_BONE)
	mutant_bodyparts = list("strong_back" = "Plain")
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_GENELESS)
	use_skintones = TRUE
	changesource_flags = MIRROR_BADMIN | WABBAJACK

/datum/species/grown_strong/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[HALLOWEEN])
		return TRUE
	return FALSE

/mob/living/carbon/human/species/grown_strong/Initialize(mapload, cubespawned=FALSE, mob/spawner)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(replace_body))

/mob/living/carbon/human/species/grown_strong/proc/replace_body()//Fix this shit - needs to be selected in prefs & randomized like mutant body parts
	var/obj/item/bodypart/r_arm = get_bodypart(BODY_ZONE_R_ARM)
	if(prob(90))
		r_arm.change_bodypart(/obj/item/bodypart/r_arm/grown_strong)
	else if(prob(20))
		r_arm.change_bodypart(/obj/item/bodypart/r_arm/grown_stronger)

	var/obj/item/bodypart/l_arm = get_bodypart(BODY_ZONE_L_ARM)
	if(prob(90))
		l_arm.change_bodypart(/obj/item/bodypart/l_arm/grown_strong)
	else if(prob(20))
		l_arm.change_bodypart(/obj/item/bodypart/l_arm/grown_stronger)

	if(prob(25))
		var/obj/item/bodypart/my_head = get_bodypart(BODY_ZONE_HEAD)
		my_head.change_bodypart(/obj/item/bodypart/head/grown_strong)
		dna.species.species_traits += NOEYESPRITES

	if(prob(75))
		var/obj/item/bodypart/my_chest = get_bodypart(BODY_ZONE_CHEST)
		my_chest.change_bodypart(/obj/item/bodypart/chest/grown_strong)

	//non-RNG part swaps
	var/obj/item/bodypart/leg1 = get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/leg2 = get_bodypart(BODY_ZONE_L_LEG)
	leg1.change_bodypart(/obj/item/bodypart/l_leg/grown_strong)
	leg2.change_bodypart(/obj/item/bodypart/r_leg/grown_strong)

	update_body_parts()

/mob/living/carbon/human/species/grown_strong/attack_ghost(mob/dead/observer/ghost)
	if(key)
		to_chat(ghost, span_notice("Somebody is already controlling this creature."))
		return

	var/response = alert(ghost, "Do you want to take it over?", "Soul transfer", "Yes", "No")
	if(response == "No")
		return

	if(key)
		to_chat(ghost, span_notice("Somebody has taken this while you were busy selecting!"))
		return

	ckey = ghost.client.ckey
	mind?.assigned_role = "Clerk"
	to_chat(src, span_info("You are strong, your possibilities are endless. You can both choose a path of an agent or a path of a clerk, but you'll always answer to T-09-140."))

/obj/item/bodypart/head/grown_strong
	name = "grown strong head"
	desc = "a cylindrical, metallic head."
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "strong_head"
	species_id = "strong"
	original_owner = "Timmy"//Setting this to a non-null value allows it to retain its original icon

/obj/item/bodypart/chest/grown_strong
	name = "grown strong torso"
	desc = "a fleshy limb encased in plastic"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "strong_chest"
	species_id = "strong"
	original_owner = "Timmy"

/obj/item/bodypart/r_arm/grown_stronger
	name = "grown strong arm"
	desc = "a massive, muscular arm encased in plastic."
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "strong_r_arm"
	species_id = "strong"
	original_owner = "Timmy"

/obj/item/bodypart/l_arm/grown_stronger
	name = "grown strong arm"
	desc = "a massive, muscular arm encased in plastic."
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "strong_l_arm"
	species_id = "strong"
	original_owner = "Timmy"
