/datum/job/surgeon
	title = "Surgeon"
	faction = "Station"
	supervisors = "the Chief Medical Officer"
	selection_color = "#ccddee"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 180
	department_head = list("Chief Medical Officer")
	supervisors = "the Chief Medical Officer"

	outfit = /datum/outfit/job/surgeon

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)
	departments = DEPARTMENT_MEDICAL

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)


	display_order = 5.1
	maptype = "limbus_labs"
	job_important = "You are a surgeon hired by LCB. Your job is to revive people and perform surgery on them."
	job_abbreviation = "SUR"

/datum/job/surgeon/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

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
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/doctor

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/survival/medical
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
