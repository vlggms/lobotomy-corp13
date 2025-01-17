/*
Assistant
*/
GLOBAL_LIST_EMPTY(spawned_clerks)

/datum/job/assistant
	title = "Clerk"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/assistant
	antag_rep = 7 // Persistant currency but currently unusable
	display_order = JOB_DISPLAY_ORDER_CLERK

	access = list(ACCESS_ROBOTICS) // Let their be bot maintenance!
	minimal_access = list(ACCESS_ROBOTICS)
	departments = DEPARTMENT_SERVICE

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
	job_important = "\
		You are a Clerk. \
		Since you are unable to work with Abnormalities, you are expected to do cleanup, cooking, medical and other miscellaneous tasks. \
		You are fragile but have access to a variety of support tools. \
	"

	job_abbreviation = "CLK"

	job_attribute_limit = 0
	alt_titles = list("Control Department Clerk", "Information Department Clerk",
			"Training Department Clerk", "Safety Department Clerk",
			"Welfare Department Clerk", "Disciplinary Department Clerk",
			"Command Department Clerk", "Extraction Department Clerk", "Record Department Clerk")
	senior_title = "Architecture Department Clerk"
	var/list/clerk_belts = list(/obj/item/storage/belt/clerk/facility, /obj/item/storage/belt/clerk/agent)


//Cannot Gain stats.
/datum/job/assistant/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	. = ..()
	outfit_owner.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
	outfit_owner.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

	for(var/upgradecheck in GLOB.lcorp_upgrades)
		if(upgradecheck == "Clerk Buff")
			outfit_owner.set_attribute_limit(40)
			outfit_owner.adjust_all_attribute_levels(40)

	if(outfit_owner.ckey in GLOB.spawned_clerks)
		return
	var/item = pick(clerk_belts)
	GLOB.spawned_clerks += outfit_owner.ckey
	outfit_owner.equip_to_slot_or_del(new item(outfit_owner),ITEM_SLOT_HANDS, TRUE)

/datum/outfit/job/assistant
	name = "Clerk"
	jobtype = /datum/job/assistant
	uniform = /obj/item/clothing/under/suit/black
	l_pocket = /obj/item/sensor_device
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)

	backpack_contents = list(
		/obj/item/healthanalyzer,
		/obj/item/ego_weapon/ranged/clerk,
	)


/datum/job/assistant/agent_support
	title = "Agent Support Clerk"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list(ACCESS_ROBOTICS)
	minimal_access = list(ACCESS_ROBOTICS)
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CLERK

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
	job_important = "\
		You are an Agent Support Clerk. \n\
		You are unable to do work, but are expected to assist agents in any way that you can. In your belt are various tools to assist them."

	job_abbreviation = "A-CLK"

	alt_titles = list("Control Department Clerk", "Command Department Clerk",
			"Welfare Department Clerk", "Disciplinary Department Clerk",
			)
	senior_title = "Record Department Clerk"
	ultra_senior_title = "Architecture Department Clerk"
	clerk_belts = /obj/item/storage/belt/clerk/agent


/datum/job/assistant/facility_support
	title = "Facility Support Clerk"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list(ACCESS_ROBOTICS)
	minimal_access = list(ACCESS_ROBOTICS)
	outfit = /datum/outfit/job/assistant
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CLERK

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	allow_bureaucratic_error = FALSE
//	loadalways = TRUE
	job_important = "\
		You are a Facility Support Clerk. \n\
		You are unable to do work, but are expected to assist the facility in any way that you can. In your belt are various tools to assist them."

	job_abbreviation = "F-CLK"

	alt_titles = list("Safety Department Clerk", "Information Department Clerk",
			"Training Department Clerk",)
	senior_title = "Extraction Department Clerk"
	ultra_senior_title = "Architecture Department Clerk"
	clerk_belts = /obj/item/storage/belt/clerk/facility
