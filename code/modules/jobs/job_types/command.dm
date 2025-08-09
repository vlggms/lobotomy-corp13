//General Command outfit
/datum/outfit/job/command
	name = "Command Outfit"
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads
	uniform = /obj/item/clothing/under/suit/lobotomy
	head = /obj/item/clothing/head/hos/beret
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

	backpack_contents = list(/obj/item/melee/classic_baton)

//Extraction, for less copypaste
/datum/job/command
	title = "Extraction Officer"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#ccccff"
	display_order = JOB_DISPLAY_ORDER_COMMAND

	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	minimal_player_age = 5

	outfit = /datum/outfit/job/command/extraction

	access = list(ACCESS_COMMAND) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND

	mapexclude = list("mini")
	job_important = "You are the Extraction Officer. Your job is to manage the EGO console, Extraction purchase console, and power generation system. Your main goal is to ensure Agents are well-equipped with EGO."

	job_abbreviation = "EO"

	job_attribute_limit = 60
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 20,
		PRUDENCE_ATTRIBUTE = 20,
		TEMPERANCE_ATTRIBUTE = 20,
		JUSTICE_ATTRIBUTE = 20,
	)

/datum/job/command/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_ATTRIBUTES_VISION, JOB_TRAIT)
	outfit_owner.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong but not speak it

/datum/outfit/job/command/extraction
	name = "Extraction Officer"
	jobtype = /datum/job/command
	suit =  /obj/item/clothing/suit/armor/extraction

	backpack_contents = list(
		/obj/item/price_tagger,
		/obj/item/extraction/delivery,
		/obj/item/extraction/upgrade_tool,
		/obj/item/extraction/key,
		/obj/item/extraction/key/lock,
		/obj/item/extraction/tool_extractor,
	)

//Records
/datum/job/command/records
	title = "Records Officer"
	outfit = /datum/outfit/job/command/records
	exp_requirements = 600
	job_important = "\
		You are the Records Officer. Your job is to manage Records. \
		You have filing cabinets in the back of your office filled with information about Abnormalities; \
		ensure Agents are well-informed about any in the facility. \
		You also have access to powerful handheld watches with various beneficial effects.\
	"

	job_notice = "Being in charge of handling Abnormality documentation, you should also assist new Interns and Clerks in learning how to work at L-Corp."

	job_abbreviation = "RO"

/datum/job/command/records/after_spawn(mob/living/outfit_owner, mob/M)
	. = ..()
	ADD_TRAIT(outfit_owner, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)

/datum/outfit/job/command/records
	name = "Records Officer"
	jobtype = /datum/job/command/records
	suit =  /obj/item/clothing/suit/armor/records

	backpack_contents = list(
		/obj/item/portacopier,
		/obj/item/portablepredict,
	)
