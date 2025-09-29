//General Command outfit
/datum/outfit/job/command
	name = "Command Outfit"
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/lawyer
	ears = /obj/item/radio/headset/heads
	uniform = /obj/item/clothing/under/suit/lobotomy
	head = /obj/item/clothing/head/hos/beret
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	accessory = /obj/item/clothing/accessory/armband/lobotomy/extraction

	backpack_contents = list(/obj/item/melee/classic_baton)

//Extraction, for less copypaste
/datum/job/command
	title = "Extraction Officer"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#ccccff"
	display_order = JOB_DISPLAY_ORDER_COMMAND

	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	minimal_player_age = 5

	outfit = /datum/outfit/job/command/extraction

	access = list(ACCESS_COMMAND) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND

	mapexclude = list("mini")
	job_important = "You are the Extraction Officer. Your job is to manage the EGO console, Extraction purchase console, and power generation system. Your main goal is to ensure Agents are well-equipped with EGO."

	job_abbreviation = "EO"

	job_attribute_limit = 130
	var/normal_attribute_level = 20
	var/extra_starting_stats = 10//Just so they dont eat shit and die way too early in a round

/datum/job/command/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_ATTRIBUTES_VISION, JOB_TRAIT)
	outfit_owner.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong but not speak it
	SSlobotomy_corp.active_officers += M

	//Blatant Copypasta. pls fix
	var/set_attribute = normal_attribute_level
	var/facility_full_percentage = 0
	if(SSabnormality_queue.spawned_abnos) // dont divide by 0
		facility_full_percentage = 100 * (SSabnormality_queue.spawned_abnos / SSabnormality_queue.rooms_start)
	// how full the facility is, from 0 abnormalities out of 24 cells being 0% and 24/24 cells being 100%


	else		//Only check percentage if it's NOT blitz mode
		switch(facility_full_percentage)
			if(15 to 29) // Shouldn't be anything more than TETHs (4 Abnormalities)
				set_attribute *= 1.5

			if(29 to 44) // HEs (8 Abnormalities)
				set_attribute *= 2

			if(44 to 59) // A bit before WAWs (11 Abnormalities)
				set_attribute *= 2.5

			if(59 to 69) // WAWs around here (15 Abnormalities)
				set_attribute *= 3

			if(69 to 79) // ALEPHs starting to spawn (17 Abnormalities)
				set_attribute *= 3.5

			if(79 to 100) // ALEPHs around here (20 Abnormalities)
				set_attribute *= 4

		set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS) + SSlobotomy_corp.ordeal_stats + extra_starting_stats
	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()

/datum/outfit/job/command/extraction
	name = "Extraction Officer"
	jobtype = /datum/job/command
	suit =  /obj/item/clothing/suit/armor/extraction

	backpack_contents = list(
		/obj/item/price_tagger,
		/obj/item/extraction/delivery,
		/obj/item/extraction/upgrade_tool,
		/obj/item/extraction/key,
		/obj/item/extraction/key/lock,
		/obj/item/extraction/tool_extractor,
	)

//Records
/datum/job/command/records
	title = "Records Officer"
	outfit = /datum/outfit/job/command/records
	exp_requirements = 600
	job_important = "\
		You are the Records Officer. Your job is to manage Records. \
		You have filing cabinets in the back of your office filled with information about Abnormalities; \
		ensure Agents are well-informed about any in the facility. \
		You also have access to powerful handheld watches with various beneficial effects.\
	"

	job_notice = "Being in charge of handling Abnormality documentation, you should also assist new Interns and Clerks in learning how to work at L-Corp."

	job_abbreviation = "RO"

/datum/job/command/records/after_spawn(mob/living/outfit_owner, mob/M)
	. = ..()
	ADD_TRAIT(outfit_owner, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)

/datum/outfit/job/command/records
	name = "Records Officer"
	jobtype = /datum/job/command/records
	suit =  /obj/item/clothing/suit/armor/records
	accessory = /obj/item/clothing/accessory/armband/lobotomy/records

	backpack_contents = list(
		/obj/item/portacopier,
		/obj/item/portablepredict,
	)


// Disciplinary Officer
/datum/job/command/disciplinary
	title = "Disciplinary Officer"
	selection_color = "#ccccff"
	outfit = /datum/outfit/job/command/disciplinary
	exp_requirements = 600
	mapexclude = list("wonderlabs", "mini", "lcorp_city", "enkephalin_rush")
	job_important = "You are the Disciplinary Officer. Your job is to help suppress Abnormalities and other threats. You cannot work."

	job_abbreviation = "DO"

/datum/outfit/job/command/disciplinary
	name = "Disciplinary Officer"
	jobtype = /datum/job/command/disciplinary
	l_pocket = /obj/item/commandprojector
	suit =  /obj/item/clothing/suit/armor/ego_gear/discipline
	accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/announcementmaker/lcorp,
		/obj/item/powered_gadget/enkephalin_injector,
		/obj/item/disc_researcher,
	)
