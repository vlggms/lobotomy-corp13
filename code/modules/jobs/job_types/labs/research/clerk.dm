
/datum/job/staff
	title = "LC Staff"
	faction = "Station"
	supervisors = "Researchers"
	total_positions = 0
	spawn_positions = 0
	selection_color = "#bbbbbb"

	outfit = /datum/outfit/job/staff

	access = list()	//No Acess
	minimal_access = list()
	departments = DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 999
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a LC Staff Member. You have little responsibilities, but are encouraged to assist research."
	job_abbreviation = "STF"



/datum/outfit/job/staff
	name = "LC Staff"
	jobtype = /datum/job/staff

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_pocket = /obj/item/radio
