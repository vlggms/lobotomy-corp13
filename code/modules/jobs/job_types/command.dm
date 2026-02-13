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

	box = /obj/item/storage/box/survival/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton)
	var/weapon = /obj/item/ego_weapon/officer/blade

/datum/outfit/job/command/post_equip(mob/living/carbon/human/outfit_owner, visualsOnly = FALSE)
	..()
	outfit_owner.equip_to_slot_or_del(new weapon(outfit_owner),ITEM_SLOT_SUITSTORE, TRUE)

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
	var/extra_starting_stats = 0//used for RO

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
	if(GLOB.lobotomy_damages)//Enkephalin Rush baby!
		facility_full_percentage = 100 * (GLOB.lobotomy_repairs / GLOB.lobotomy_damages)

	else
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
	set_attribute = max(30, set_attribute)//Just so they dont eat shit and die way too early in a round
	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS) + SSlobotomy_corp.ordeal_stats + extra_starting_stats
	for(var/attribute in roundstart_attributes)
		roundstart_attributes[attribute] = round(set_attribute)

	return ..()

/datum/outfit/job/command/extraction
	name = "Extraction Officer"
	jobtype = /datum/job/command
	suit =  /obj/item/clothing/suit/armor/ego_gear/officer
	weapon = /obj/item/ego_weapon/officer/extraction

	backpack_contents = list(
		/obj/item/announcementmaker/lcorp,
		/obj/item/price_tagger,
		/obj/item/extraction/delivery,
		/obj/item/extraction/upgrade_tool,
		/obj/item/extraction/key,
		/obj/item/extraction/lock,
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
	suit =  /obj/item/clothing/suit/armor/ego_gear/officer/records
	accessory = /obj/item/clothing/accessory/armband/lobotomy/records
	weapon = /obj/item/ego_weapon/shield/officer/records
	backpack_contents = list(
		/obj/item/announcementmaker/lcorp,
		/obj/item/portacopier,
		/obj/item/portablepredict,
	)


// Disciplinary Officer
/datum/job/command/disciplinary
	title = "Disciplinary Officer"
	selection_color = "#ccccff"
	outfit = /datum/outfit/job/command/disciplinary
	exp_requirements = 600//used to be 100 fucking hours for some reason
	job_important = "You are the Disciplinary Officer. Your job is to help suppress Abnormalities and other threats. You cannot work but can breach Abnormalities for some PE or LOB points."

	job_abbreviation = "DO"

/datum/outfit/job/command/disciplinary
	name = "Disciplinary Officer"
	jobtype = /datum/job/command/disciplinary
	l_pocket = /obj/item/commandprojector
	suit =  /obj/item/clothing/suit/armor/ego_gear/officer/discipline
	accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
	weapon = /obj/item/ego_weapon/officer/discipline
	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/announcementmaker/lcorp,
		/obj/item/powered_gadget/enkephalin_injector,
		///obj/item/disc_researcher, // Turns out making a role that can only kill shit gets boring fast
		/obj/item/reagent_containers/hypospray/emais/combat,
		/obj/item/restraints/handcuffs,
		/obj/item/restraints/legcuffs/bola,
	)
