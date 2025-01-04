/datum/job/researcher
	title = "Researcher"
	faction = "Station"
	supervisors = "Senior Researcher"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#cd6fd9"

	outfit = /datum/outfit/job/researcher

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)
	departments = DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 6.5
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a Researcher. Your job is to interact with abnormalities, write down notes based on how they reacted, and report your findings to the Senior Researcher or the office workers."
	job_abbreviation = "RES"

/datum/job/researcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)


/datum/outfit/job/researcher
	name = "Researcher"
	jobtype = /datum/job/researcher

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/research
	l_pocket = /obj/item/radio
