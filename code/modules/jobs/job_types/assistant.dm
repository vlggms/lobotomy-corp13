/*
Assistant
*/
GLOBAL_LIST_EMPTY(spawned_clerks)

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

	job_attribute_limit = 0

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
//	loadalways = TRUE
	job_important = "You are a Clerk. You're the jack of all trades in LCorp. You are to assist with cleanup, cooking, medical and other miscellaneous tasks. You are fragile, but important."


//Cannot Gain stats.
/datum/job/assistant/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	. = ..()
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	backpack_contents = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/gun/ego_gun/clerk = 1)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)

/datum/outfit/job/assistant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(H.ckey in GLOB.spawned_clerks)
		return
	var/item = pick(
	/obj/item/forcefield_projector,
	/obj/item/deepscanner,
	/obj/item/powered_gadget/slowingtrapmk1,
	/obj/item/safety_kit,
	/obj/item/powered_gadget/detector_gadget/abnormality,
	/obj/item/powered_gadget/detector_gadget/ordeal,
	/obj/item/powered_gadget/enkephalin_injector,
	/obj/item/clerkbot_gadget,
	/obj/item/powered_gadget/handheld_taser,
	/obj/item/powered_gadget/vitals_projector,
	/obj/item/reagent_containers/hypospray/emais,
	)
	GLOB.spawned_clerks += H.ckey
	H.equip_to_slot_or_del(new item(H),ITEM_SLOT_HANDS, TRUE)
