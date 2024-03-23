/datum/job/suppression
	title = "Emergency Response Agent"
	department_head = list("Manager", "Disciplinary Officer")
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
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

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

	job_important = "You are an L-Corp Emergency Response Agent. Your job is to suppress Abnormalities. You cannot work. Use :h to talk on your departmental radio."
	job_abbreviation = "ERA"

	var/normal_attribute_level = 20 // Scales with round time & facility upgrades

/datum/job/suppression/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

	//Blatant Copypasta. pls fix
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


/datum/outfit/job/suppression
	name = "Emergency Response Agent"
	jobtype = /datum/job/suppression

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_discipline
	accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

// Suppression Officer
/datum/job/suppression/captain
	title = "Disciplinary Officer"
	selection_color = "#ccccff"
	total_positions = 0
	spawn_positions = 0
	outfit = /datum/outfit/job/suppression/captain
	display_order = JOB_DISPLAY_ORDER_COMMAND
	normal_attribute_level = 20

	access = list(ACCESS_COMMAND) // LC13:To-Do
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are the Disciplinary Officer. Lead the Emergency Response Agents and other Disciplinary staff into combat."

	job_abbreviation = "DO"

/datum/job/suppression/captain/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/suppression))
			processing.total_positions = 3


/datum/outfit/job/suppression/captain
	name = "Disciplinary Officer"
	jobtype = /datum/job/suppression/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/headset_discipline
	l_pocket = /obj/item/commandprojector
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1,
		/obj/item/announcementmaker/lcorp)
