/datum/job/pharmacist
	title = "Pharmacist"
	faction = "Station"
	supervisors = "the Chief Medical Officer"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 180
	selection_color = "#ccddee"
	department_head = list("Chief Medical Officer")
	supervisors = "Chief Medical Officer"

	outfit = /datum/outfit/job/pharmacist

	access = list(ACCESS_MEDICAL, ACCESS_PHARMACY)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_PHARMACY)
	departments = DEPARTMENT_MEDICAL

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)


	display_order = 5.2
	maptype = "limbus_labs"
	job_important = "You are a pharmacist hired by LCB. Your job is to make the medicine used by the Medical Zone."
	job_abbreviation = "PHAR"

/datum/job/pharmacist/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/pharmacist

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/rank/medical/doctor/blue
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/chem
	l_pocket = /obj/item/radio
	glasses = /obj/item/clothing/glasses/sunglasses/chemical
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/chem
