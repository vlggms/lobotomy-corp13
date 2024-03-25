/datum/job/ist
	title = "Information Systems Tech"
	faction = "Station"
	supervisors = "District Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aabbcc"

	outfit = /datum/outfit/job/ist

	access = list(ACCESS_RND, ACCESS_NETWORK)
	minimal_access = list(ACCESS_RND, ACCESS_NETWORK)

	job_attribute_limit = 0


	display_order = 2.5
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the Information Systems Tech. Your job is to build, operate and maintain computer systems in the lab."



/datum/outfit/job/ist
	name = "Information Systems Tech"
	jobtype = /datum/job/ist

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/agent_lieutenant
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/science
	suit = /obj/item/clothing/suit/toggle/labcoat
	l_pocket = /obj/item/radio
