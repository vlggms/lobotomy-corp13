
/datum/job/staff
	title = "LC Staff"
	faction = "Station"
	supervisors = "Researchers"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#aabbcc"

	outfit = /datum/outfit/job/staff

	access = list()	//No Acess
	minimal_access = list()

	job_attribute_limit = 0


	display_order = 999
	alt_titles = list()
	maptype = list("lcb")
	job_important = "You are a LC Staff Member. You have little responsibilities, but are encouraged to assist research."



/datum/outfit/job/staff
	name = "LC Staff"
	jobtype = /datum/job/staff

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/sci
	suit = /obj/item/clothing/suit/toggle/labcoat
