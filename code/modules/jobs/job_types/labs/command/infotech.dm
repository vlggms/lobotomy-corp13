/datum/job/ist
	title = "Information Systems Tech"
	faction = "Station"
	supervisors = "District Manager"
	total_positions = 0
	spawn_positions = 0
	selection_color = "#af57ba"

	outfit = /datum/outfit/job/ist

	access = list(ACCESS_RND, ACCESS_NETWORK)
	minimal_access = list(ACCESS_RND, ACCESS_NETWORK)
	departments = DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 6.1
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the Information Systems Tech. Your job is to build, operate and maintain computer systems in the lab."

/datum/job/ist/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)


/datum/outfit/job/ist
	name = "Information Systems Tech"
	jobtype = /datum/job/ist

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/agent_lieutenant
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/science
	l_pocket = /obj/item/radio

