/datum/job/suppression
	title = "Emergency Response Agent"
	department_head = list("Manager", "Disciplinary Officer")
	faction = "Station"
	// note: job slots by default are 0
	supervisors = "the Manager and the Disciplinary Officer"
	selection_color = "#ccaaaa"
	exp_requirements = 3000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/suppression
	display_order = JOB_DISPLAY_ORDER_SUPPRESSION

	access = list() // LC13:To-Do
	minimal_access = list()

	allow_bureaucratic_error = FALSE
	departments = DEPARTMENT_SECURITY

	job_important = "You are an L-Corp Emergency Response Agent. Your job is to suppress Abnormalities. You cannot work. Use :h to talk on your departmental radio."
	job_abbreviation = "ERA"

	roundstart_attributes = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	var/normal_attribute_level = 20 // Scales with round time, facility upgrades, and ordeals done

/datum/job/suppression/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	SSabnormality_queue.active_suppression_agents += M

	//Blatant Copypasta. pls fix
	var/set_attribute = normal_attribute_level
	var/facility_full_percentage = 0
	if(SSabnormality_queue.spawned_abnos) // dont divide by 0
		facility_full_percentage = 100 * (SSabnormality_queue.spawned_abnos / SSabnormality_queue.rooms_start)
	// how full the facility is, from 0 abnormalities out of 24 cells being 0% and 24/24 cells being 100%
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

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS) + SSlobotomy_corp.ordeal_stats //Used to have doubled respawn stats, but that might be a bit too broken with stats from ordeals.

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()


/datum/outfit/job/suppression
	name = "Emergency Response Agent"
	jobtype = /datum/job/suppression

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_discipline
	accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/powered_gadget/enkephalin_injector,
	)

// Suppression Officer
/datum/job/suppression/captain
	title = "Disciplinary Officer"
	selection_color = "#ccccff"
	total_positions = 0
	spawn_positions = 0
	outfit = /datum/outfit/job/suppression/captain
	display_order = JOB_DISPLAY_ORDER_COMMAND
	normal_attribute_level = 20

	access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SECURITY
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are the Disciplinary Officer. Lead the Emergency Response Agents and other Disciplinary staff into combat."

	job_abbreviation = "DO"

/datum/job/suppression/captain/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/suppression))
			processing.total_positions = 3

		if(istype(processing, /datum/job/suppression/captain))
			processing.total_positions = 1

/datum/outfit/job/suppression/captain
	name = "Disciplinary Officer"
	jobtype = /datum/job/suppression/captain
	ears = /obj/item/radio/headset/heads/headset_discipline
	l_pocket = /obj/item/commandprojector
	suit = /obj/item/clothing/suit/armor/ego_gear/disc_off

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/announcementmaker/lcorp,
		/obj/item/powered_gadget/enkephalin_injector,
	)
