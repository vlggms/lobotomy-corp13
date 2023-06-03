/datum/job/raven
	title = "R-Corp Raven"
	faction = "Station"
	department_head = list("Raven Team Captain", "Commander")
	total_positions = 4
	spawn_positions = 4
	supervisors = "the raven team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/raven
	display_order = 8

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/raven/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rcorp_captain/raven
	title = "Raven Squad Captain"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/raven/captain
	display_order = 4

	access = list(ACCESS_RND, ACCESS_COMMAND)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)


/datum/outfit/job/raven
	name = "R-Corp Raven"
	jobtype = /datum/job/raven

	ears = /obj/item/radio/headset/headset_information
	glasses = /obj/item/clothing/glasses/night
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	belt = null



/datum/outfit/job/raven/captain
	name = "Raven Squad Captain"
	jobtype = /datum/job/rcorp_captain/raven
	glasses = /obj/item/clothing/glasses/hud/health/night
	head = /obj/item/clothing/head/rabbit_helmet/raven
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	suit_store = null
	ears = /obj/item/radio/headset/heads/headset_information
