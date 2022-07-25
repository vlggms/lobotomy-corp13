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
	switch(world.time)
		if(30 MINUTES to 55 MINUTES) // Usual time for WAWs
			set_attribute *= 1.5
		if(55 MINUTES to INFINITY) // Already have an ALEPH or two
			set_attribute *= 2
	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = set_attribute
	return ..()

/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

/datum/job/agent/senior
	title = "Senior Agent"
	total_positions = 8
	spawn_positions = 8
	outfit = /datum/outfit/job/agent/senior
	display_order = JOB_DISPLAY_ORDER_WARDEN
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	normal_attribute_level = 40

/datum/outfit/job/agent/senior
	name = "Senior Agent"
	jobtype = /datum/job/agent/senior


/datum/job/agent/captain
	title = "Agent Captain"
	selection_color = "#BB9999"
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/agent/captain
	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	normal_attribute_level = 40


/datum/outfit/job/agent/captain
	name = "Agent Captain"
	jobtype = /datum/job/agent/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/hos/alt
