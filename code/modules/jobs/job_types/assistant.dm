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
	access = list(ACCESS_ROBOTICS)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ROBOTICS)	//See /datum/job/assistant/get_access()
	// Let their be bot maintenance!
	outfit = /datum/outfit/job/assistant
	antag_rep = 7 //persistant currency but currently unusable
	display_order = JOB_DISPLAY_ORDER_CLERK


	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
//	loadalways = TRUE
	job_important = "You are a Clerk. You're the jack of all trades in LCorp. You are to assist with cleanup, cooking, medical and other miscellaneous tasks. You are fragile, but important."


//Cannot Gain stats.
/datum/job/assistant/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(0)

/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/medical
	backpack_contents = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/gun/ego_gun/clerk = 1,
		/obj/item/gun/ballistic/automatic/pistol/deagle = 1,
		/obj/item/ammo_box/magazine/m50 = 2)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
