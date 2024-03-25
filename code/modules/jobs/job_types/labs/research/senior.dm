/datum/job/senior_researcher
	title = "Senior Researcher"
	faction = "Station"
	supervisors = "Lead Researcher"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aabbcc"

	outfit = /datum/outfit/job/senior_researcher

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)

	job_attribute_limit = 0


	display_order = 6
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the Senior Researcher. Your job is to run research on the abnormalities, and report back to the lead researcher and command."



/datum/outfit/job/senior_researcher
	name = "Senior Researcher"
	jobtype = /datum/job/senior_researcher

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/science
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_pocket = /obj/item/radio

