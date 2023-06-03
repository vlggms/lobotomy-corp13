/datum/job/reindeer
	title = "R-Corp Reindeer"
	faction = "Station"
	department_head = list("Reindeer Team Captain", "Commander")
	total_positions = 4
	spawn_positions = 4
	supervisors = "the reindeer team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/reindeer
	display_order = 7

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/reindeer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rcorp_captain/reindeer
	title = "Reindeer Squad Captain"
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

	outfit = /datum/outfit/job/reindeer/captain
	display_order = 3

	access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/outfit/job/reindeer
	name = "R-Corp Reindeer"
	jobtype = /datum/job/reindeer

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/reindeer/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	l_pocket = /obj/item/flashlight/seclite



/datum/outfit/job/reindeer/captain
	name = "Reindeer Squad Captain"
	jobtype = /datum/job/rcorp_captain/reindeer
	glasses = /obj/item/clothing/glasses/hud/health/night
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/rabbit_helmet/reindeer
	ears = /obj/item/radio/headset/heads/headset_welfare
