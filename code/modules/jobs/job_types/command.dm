//General Command outfit
/datum/outfit/job/command
	name = "Command Outfit"
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads
	uniform = /obj/item/clothing/under/suit/lobotomy
	head = /obj/item/clothing/head/hos/beret
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

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

	outfit = /datum/outfit/job/command/extraction

	access = list(ACCESS_COMMAND) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND)
	mapexclude = list("mini")

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

/datum/job/command/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	H.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong better but not speak it
	H.set_attribute_limit(60)		//Level limit set to 60, they'll be able to get defend themselves but not use Aleph or a lot of WAW gear

/datum/outfit/job/command/extraction
	name = "Extraction Officer"
	jobtype = /datum/job/command
	suit =  /obj/item/clothing/suit/armor/extraction
	backpack_contents = list(/obj/item/price_tagger = 1)

//Records
/datum/job/command/records
	title = "Records Officer"
	outfit = /datum/outfit/job/command/records

/datum/job/command/records/after_spawn(mob/living/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)

/datum/outfit/job/command/records
	name = "Records Officer"
	jobtype = /datum/job/command/records
	suit =  /obj/item/clothing/suit/armor/records
