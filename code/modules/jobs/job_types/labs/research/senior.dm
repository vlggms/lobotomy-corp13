/datum/job/senior_researcher
	title = "Senior Researcher"
	faction = "Station"
	supervisors = "Lead Researcher"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#cd6fd9"

	outfit = /datum/outfit/job/senior_researcher

	access = list(ACCESS_RND)
	minimal_access = list(ACCESS_RND)
	departments = DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 6.4
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the Senior Researcher. Your job is to run research on the abnormalities, and report back to the lead researcher and command."
	job_abbreviation = "SR"

/datum/job/senior_researcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)


/datum/outfit/job/senior_researcher
	name = "Senior Researcher"
	jobtype = /datum/job/senior_researcher

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/science
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/sresearch
	l_pocket = /obj/item/radio

