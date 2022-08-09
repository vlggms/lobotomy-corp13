/*
Assistant
*/
/datum/job/assistant
	title = "Clerk"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_PRISONER



/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/medical
	backpack_contents = list(
		/obj/item/storage/firstaid/revival=1,
		/obj/item/flashlight/seclite = 1,
		/obj/item/storage/box/barrier= 1,
		/obj/item/healthanalyzer = 1,
		/obj/item/gun/ego_gun/clerk = 1,
		/obj/item/kitchen/knife/hunting = 1)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
