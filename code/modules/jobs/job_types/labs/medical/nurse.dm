/datum/job/lcb_nurse
	title = "Nurse"
	selection_color = "#ccddee"
	department_head = list("Chief Medical Officer", "Surgeon")
	supervisors = "the Chief Medical Officer and the Surgeon"

	outfit = /datum/outfit/job/lcb_nurse

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	total_positions = 3
	spawn_positions = 3
	exp_requirements = 180

	display_order = 5.2
	maptype = "limbus_labs"
	job_important = "You are a nurse hired by LCB. You help the other members of the Medical Zone tend to the patients."


/datum/outfit/job/lcb_nurse
	name = "Nurse (LCB)"
	jobtype = /datum/job/lcb_nurse

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/med
	l_pocket = /obj/item/radio

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
