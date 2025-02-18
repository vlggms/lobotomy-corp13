/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the Manager"
	selection_color = "#ccaaaa"
	exp_requirements = 240
	exp_type = EXP_TYPE_SECURITY
	exp_type_department = EXP_TYPE_SECURITY
	minimal_player_age = 1

	outfit = /datum/outfit/job/agent
	display_order = JOB_DISPLAY_ORDER_AGENT

	access = list() // LC13:To-Do
	minimal_access = list()

	allow_bureaucratic_error = FALSE
	departments = DEPARTMENT_SECURITY

	job_important = "You are a L-Corp Agent. Your job is to work on and suppress Abnormalities. Use :h to talk on your departmental radio."

	job_abbreviation = "AGT"

	/// Values set in after_spawn() depending on var/normal_attribute_level and abnormality number per total abnormality cells
	roundstart_attributes = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	var/normal_attribute_level = 20 // Scales with round time & facility upgrades

/datum/job/agent/after_spawn(mob/living/carbon/human/outfit_owner, mob/M, latejoin = FALSE)
	// Assign department security
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_agent_department
	var/ears = null
	var/accessory = null
	switch(department)
		if("Control")
			ears = /obj/item/radio/headset/headset_control
			accessory = /obj/item/clothing/accessory/armband/lobotomy
		if("Command")
			ears = /obj/item/radio/headset/headset_command
			accessory = /obj/item/clothing/accessory/armband/lobotomy/command
		if("Information")
			ears = /obj/item/radio/headset/headset_information
			accessory = /obj/item/clothing/accessory/armband/lobotomy/info
		if("Safety")
			ears = /obj/item/radio/headset/headset_safety
			accessory = /obj/item/clothing/accessory/armband/lobotomy/safety
		if("Disciplinary")
			ears = /obj/item/radio/headset/headset_discipline
			accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
		if("Welfare")
			ears = /obj/item/radio/headset/headset_welfare
			accessory = /obj/item/clothing/accessory/armband/lobotomy/welfare
		if("Extraction")
			ears = /obj/item/radio/headset/headset_extraction
			accessory = /obj/item/clothing/accessory/armband/lobotomy/extraction
		if("Record")
			ears = /obj/item/radio/headset/headset_records
			accessory = /obj/item/clothing/accessory/armband/lobotomy/records

		else //Pick a department or get training.
			ears = /obj/item/radio/headset/headset_training
			accessory = /obj/item/clothing/accessory/armband/lobotomy/training

	if(accessory)
		var/obj/item/clothing/under/U = outfit_owner.w_uniform
		U.attach_accessory(new accessory)
	if(outfit_owner.mind.assigned_role == "Agent")
		if(ears)
			if(outfit_owner.ears)
				qdel(outfit_owner.ears)
			outfit_owner.equip_to_slot_or_del(new ears(outfit_owner),ITEM_SLOT_EARS)
	if(department != "None" && department)
		to_chat(M, "<b>You have been assigned to [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department.</b>")

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

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)

	for(var/attribute in roundstart_attributes)
		roundstart_attributes[attribute] = round(set_attribute)

	//Check the lcorp global upgrades
	for(var/upgradecheck in GLOB.lcorp_upgrades)
		if(upgradecheck == "Agent Workchance")
			ADD_TRAIT(outfit_owner, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)
		if(upgradecheck == "Health Hud")
			var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
			medsensor.add_hud_to(outfit_owner)

	//Enable suppression agents.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/suppression/captain))
			processing.total_positions = 1

	return ..()


/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	head = /obj/item/clothing/head/beret/tegu/lobotomy/agent
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/info_printer,
	)

// Trainee, for new players
/datum/job/agent/intern
	title = "Agent Intern"
	selection_color = "#ccaaaa"
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/agent/intern
	display_order = JOB_DISPLAY_ORDER_INTERN
	normal_attribute_level = 20
	minimal_player_age = 0
	exp_requirements = 0
	job_important = "\
		You are an Agent Intern. \
		Your main goal is to learn how to work on Abnormalities and assist in suppressions. \
		Other Agents will be more aware of your inexperience. \
		If there is a Records Officer, seek them out for assistance.\
	"

	job_abbreviation = "INRN"

/datum/outfit/job/agent/intern
	name = "Agent Intern"
	jobtype = /datum/job/agent/intern
	head = null

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/paper/fluff/tutorial/levels,
		/obj/item/paper/fluff/tutorial/risk,
		/obj/item/paper/fluff/tutorial/damage,
		/obj/item/paper/fluff/tutorial/tips,
		/obj/item/info_printer,
	)
