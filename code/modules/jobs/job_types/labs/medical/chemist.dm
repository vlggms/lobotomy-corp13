/datum/job/pharmacist
	title = "Pharmacist"
	selection_color = "#ccddee"
	department_head = list("Chief Medical Officer")
	supervisors = "Chief Medical Officer"

	outfit = /datum/outfit/job/pharmacist

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	total_positions = 1
	spawn_positions = 1
	exp_requirements = 180

	display_order = 5.5
	maptype = list("lcb")
	job_important = "You are a pharmacist hired by LCB. Your job is to make the medicine used by the Medical Zone."


/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset_welfare
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/med
	implants = /obj/item/organ/cyberimp/eyes/hud/science
