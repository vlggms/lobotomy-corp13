/datum/job/agent
	title = "Agent"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 12
	spawn_positions = 12
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

/datum/outfit/job/agent
	name = "Agent"
	jobtype = /datum/job/agent

	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/suit/black
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
