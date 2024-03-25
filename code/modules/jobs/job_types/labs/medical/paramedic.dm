/datum/job/lcb_medic
	title = "Paramedic"
	selection_color = "#ccddee"
	department_head = list("Chief Medical Officer")
	supervisors = "Chief Medical Officer"

	outfit = /datum/outfit/job/lcb_medic

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)

	job_attribute_limit = 0

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	total_positions = 1
	spawn_positions = 1
	exp_requirements = 180

	display_order = 5.3
	maptype = "limbus_labs"
	job_important = "You are a paramedic hired by LCB. You retrieve the bodies of badly damaged or killed LCB members to be treated in the Medical Zone."


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
