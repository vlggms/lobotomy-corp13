/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the manager"
	selection_color = "#ccaaaa"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/agent
	display_order = JOB_DISPLAY_ORDER_AGENT

	access = list() // LC13:To-Do
	minimal_access = list()

	allow_bureaucratic_error = FALSE

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

	job_important = "You are an L-Corp agent. Your job is to work on, and suppress abnormalities. Use :h to talk on your departmental radio."

	var/normal_attribute_level = 20 // Scales with round time & facility upgrades

/datum/job/agent/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
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
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)
	if(H.mind.assigned_role == "Agent")
		if(ears)
			if(H.ears)
				qdel(H.ears)
			H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)
	if(department != "None" && department)
		to_chat(M, "<b>You have been assigned to [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department.</b>")

	var/set_attribute = normal_attribute_level

	// Variables from abno queue subsystem
	var/spawned_abnos = SSabnormality_queue.spawned_abnos
	var/rooms_start = SSabnormality_queue.rooms_start

	if(spawned_abnos > rooms_start * 0.95) // Full facility!
		set_attribute *= 4
	else if(spawned_abnos > rooms_start * 0.7) // ALEPHs around here
		set_attribute *= 3
	else if(spawned_abnos > rooms_start * 0.5) // WAWs and others
		set_attribute *= 2.5
	else if(spawned_abnos > rooms_start * 0.35) // HEs
		set_attribute *= 2
	else if(spawned_abnos > rooms_start * 0.2) // Shouldn't be anything more than TETHs
		set_attribute *= 1.5

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()


/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1,
		/obj/item/info_printer=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

// Captain
/datum/job/agent/captain
	title = "Agent Captain"
	selection_color = "#BB9999"
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/agent/captain
	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	normal_attribute_level = 20 // Used to have 21, but it was just picked for the roundstart +1 stat to instantly mirror. - Kirie/Kitsunemitsu

	access = list(ACCESS_COMMAND) // LC13:To-Do
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are an Agent Captain. You're an experienced agent, that is expected to disseminate your information and experience as well as help lead the agents."

/datum/outfit/job/agent/captain
	name = "Agent Captain"
	jobtype = /datum/job/agent/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/agent_captain/alt
	l_pocket = /obj/item/commandprojector
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1,
		/obj/item/info_printer=1,
		/obj/item/announcementmaker/lcorp)

// Trainee, for new players
/datum/job/agent/intern
	title = "Agent Intern"
	selection_color = "#ccaaaa"
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/agent/intern
	display_order = JOB_DISPLAY_ORDER_INTERN
	normal_attribute_level = 20
	exp_requirements = 0
	job_important = "You are an Agent Intern. Your main goal is to learn how to work on abnormalities, and assist in suppression. Other agents should be more understanding to your mistakes. \
	If there is a Records Officer, seek them for assistance."

/datum/outfit/job/agent/intern
	name = "Agent Intern"
	jobtype = /datum/job/agent/intern
	head = null
	backpack_contents = list(/obj/item/melee/classic_baton=1,
		/obj/item/paper/fluff/tutorial/levels=1 ,
		/obj/item/paper/fluff/tutorial/risk=1,
		/obj/item/paper/fluff/tutorial/damage=1,
		/obj/item/paper/fluff/tutorial/tips=1,
		/obj/item/info_printer=1)
