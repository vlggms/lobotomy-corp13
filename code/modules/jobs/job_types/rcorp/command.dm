/datum/job/rcorp_captain/commander
	title = "Ground Commander"
	faction = "Station"
	department_head = list()
	total_positions = 1
	spawn_positions = 1
	supervisors = "the interests of R Corp"
	selection_color = "#a18438"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"
	trusted_only = TRUE

	outfit = /datum/outfit/job/commander
	display_order = 1

	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/rcorp_captain/commander/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "All rise for commander [H.real_name]."))

/datum/outfit/job/commander
	name = "Ground Commander"
	jobtype = /datum/job/rcorp_captain/commander

	belt = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rcorp_command
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset/heads/manager/alt
	head = /obj/item/clothing/head/beret/tegu/rcorp

/obj/item/clothing/head/beret/tegu/rcorp
	name = "commander beret"
	desc = "A jet-black beret with the Ground Commander's rank pins on it."
	icon_state = "beret_rcorp"

/obj/item/clothing/neck/cloak/rcorp
	name = "ground commander's cloak"
	desc = "Worn by the rcorp commander of the 4th pack."
	icon_state = "rcorp"

/obj/item/clothing/under/suit/lobotomy/rcorp_command
	name = "ground commander's suit"
	desc = "Worn by the rcorp commander of the 4th pack."
	icon_state = "rcorp_command"

/datum/job/rhino/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rcorp_captain/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
