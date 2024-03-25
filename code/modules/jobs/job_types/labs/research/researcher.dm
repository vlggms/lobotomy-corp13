/datum/job/researcher
	title = "Researcher"
	faction = "Station"
	supervisors = "Senior Researcher"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#aabbcc"

	outfit = /datum/outfit/job/researcher

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	job_attribute_limit = 0


	display_order = 6.5
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a Researcher. Your job is to interact with abnormalities, write down notes based on how they reacted, and report your findings to the Senior Researcher or the office workers."



/datum/outfit/job/researcher
	name = "Researcher"
	jobtype = /datum/job/researcher

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_pocket = /obj/item/radio
