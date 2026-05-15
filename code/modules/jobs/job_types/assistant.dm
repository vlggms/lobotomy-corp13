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

	outfit = /datum/outfit/job/assistant
	antag_rep = 7 // Persistant currency but currently unusable
	display_order = JOB_DISPLAY_ORDER_CLERK

	access = list(ACCESS_ROBOTICS) // Let their be bot maintenance!
	minimal_access = list(ACCESS_ROBOTICS)
	departments = DEPARTMENT_SERVICE

	mind_traits = list(TRAIT_WORK_FORBIDDEN)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
	job_important = "\
		You are a Clerk. \
		Since you are unable to work with Abnormalities, you are expected to do cleanup, cooking, medical and other miscellaneous tasks. \
		You are fragile but have access to a variety of support tools. \
	"

	job_abbreviation = "CLK"

	job_attribute_limit = 0


//Cannot Gain stats.
/datum/job/assistant/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	. = ..()
	outfit_owner.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	outfit_owner.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)

	if(outfit_owner.ckey in GLOB.spawned_clerks)
		return
	GLOB.spawned_clerks += outfit_owner.ckey
	outfit_owner.equip_to_slot_or_del(new /obj/item/storage/belt/clerk(outfit_owner),ITEM_SLOT_HANDS, TRUE)

/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
	box = /obj/item/storage/box/survival/lobotomy
