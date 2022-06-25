/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the manager"
	selection_color = "#ccaaaa"

	outfit = /datum/outfit/job/agent

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

	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup

/datum/job/agent/senior
	title = "Senior Agent"
	total_positions = 4
	spawn_positions = 4
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	normal_attribute_level = 40
