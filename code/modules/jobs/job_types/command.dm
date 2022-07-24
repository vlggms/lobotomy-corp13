/datum/job/extraction
	title = "Extraction Officer"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#ccccff"

	outfit = /datum/outfit/job/extraction
	display_order = JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL

	access = list() // LC13:To-Do
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
						//Beefy boy so they can use a couple gear


/datum/outfit/job/extraction
	name = "Extraction Officer"
	jobtype = /datum/job/extraction

	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/captain
	ears = /obj/item/radio/headset/heads
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/armor/extraction
	head = /obj/item/clothing/head/hos/beret
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
