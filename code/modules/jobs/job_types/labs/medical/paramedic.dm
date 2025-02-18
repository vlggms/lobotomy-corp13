/datum/job/lcb_medic
	title = "Emergency Medical Technician"
	faction = "Station"
	supervisors = "the Chief Medical Officer"
	selection_color = "#ccddee"
	total_positions = 0
	spawn_positions = 0
	exp_requirements = 180
	department_head = list("Chief Medical Officer")
	supervisors = "Chief Medical Officer"

	outfit = /datum/outfit/job/lcb_medic

	access = list(ACCESS_MEDICAL, ACCESS_ARMORY, ACCESS_SECURITY)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_ARMORY, ACCESS_SECURITY)
	departments = DEPARTMENT_MEDICAL

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)


	display_order = 5.4
	maptype = "limbus_labs"
	job_important = "You are a paramedic hired by LCB. You retrieve the bodies of badly damaged or killed LCB members to be treated in the Medical Zone."
	job_abbreviation = "EMT"

/datum/job/lcb_medic/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/lcb_medic
	name = "Paramedic (LCB)"
	jobtype = /datum/job/lcb_medic

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_welfare
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/soft/paramedic
	suit = /obj/item/clothing/suit/toggle/labcoat/paramedic
	backpack_contents = list(/obj/item/pinpointer/crew=1)
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
	l_pocket = /obj/item/radio
