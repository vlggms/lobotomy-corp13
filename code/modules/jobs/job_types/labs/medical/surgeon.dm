/datum/job/surgeon
	title = "Surgeon"
	selection_color = "#ccddee"
	department_head = list("Chief Medical Officer")
	supervisors = "the Chief Medical Officer"

	outfit = /datum/outfit/job/surgeon

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	total_positions = 1
	spawn_positions = 1
	exp_requirements = 180

	display_order = 5
	maptype = "limbus_labs"
	job_important = "You are a surgeon hired by LCB. Your job is to revive people and perform surgery on them."

/datum/outfit/job/surgeon
	name = "Surgeon"
	jobtype = /datum/job/surgeon

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/med
	l_hand = /obj/item/storage/firstaid/medical
	l_pocket = /obj/item/radio

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
