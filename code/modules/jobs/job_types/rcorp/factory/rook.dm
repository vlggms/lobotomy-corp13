/datum/job/rook
	title = "R-Corp Rook"
	faction = "Station"
	department_head = list("Rook Team Captain", "Commanders")
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Rook team captain and the commanders"
	selection_color = "#d9b555"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/rook
	display_order = 11

	access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_CENT_GENERAL)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SPC"
	job_important = "You take the role of an engineering unit."
	job_notice = ""

/datum/job/rcorp_captain/rook
	title = "Rook Squad Captain"
	faction = "Station"
	department_head = list("Commanders")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commanders"
	selection_color = "#a18438"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/rook/captain
	display_order = 10

	access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)
	minimal_access = list(ACCESS_ARMORY, ACCESS_COMMAND, ACCESS_CENT_GENERAL)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 120,
								PRUDENCE_ATTRIBUTE = 120,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "You take the role of the captain of an engineering unit."
	job_notice = ""
	req_admin_notify = 1

/datum/job/rook/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)



/datum/outfit/job/rook
	name = "R-Corp Rook"
	jobtype = /datum/job/rook

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	belt = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE

/datum/outfit/job/rook/captain
	name = "Rook Squad Captain"
	jobtype = /datum/job/rcorp_captain/rook
