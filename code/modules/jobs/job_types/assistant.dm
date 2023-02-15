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
	antag_rep = 7 //persistant currency but currently unusable


	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PRISONER
	allow_bureaucratic_error = FALSE


//Cannot Gain stats.
/datum/job/assistant/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(0)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/medical
	backpack_contents = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/gun/ego_gun/clerk = 1)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
