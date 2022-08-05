/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the manager"
	selection_color = "#ccaaaa"

	outfit = /datum/outfit/job/agent
	display_order = JOB_DISPLAY_ORDER_SECURITY_OFFICER

	access = list() // LC13:To-Do
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

	var/normal_attribute_level = 20 // Scales with round time

/datum/job/agent/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	var/set_attribute = normal_attribute_level
	if(world.time >= 75 MINUTES) // Full facility expected
		set_attribute *= 4
	else if(world.time >= 60 MINUTES) // More than one ALEPH
		set_attribute *= 3
	else if(world.time >= 45 MINUTES) // Wowzer, an ALEPH?
		set_attribute *= 2.5
	else if(world.time >= 30 MINUTES) // Expecting WAW
		set_attribute *= 2
	else if(world.time >= 15 MINUTES) // Usual time for HEs
		set_attribute *= 1.5

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()

/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1)
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
	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY
	normal_attribute_level = 21 // :)

	access = list(ACCESS_COMMAND) // LC13:To-Do
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

/datum/outfit/job/agent/captain
	name = "Agent Captain"
	jobtype = /datum/job/agent/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/agent_captain/alt
