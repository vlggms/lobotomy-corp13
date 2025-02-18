/datum/job/lead_researcher
	title = "Lead Researcher"
	faction = "Station"
	supervisors = "District Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#854a8c"

	outfit = /datum/outfit/job/lead_researcher

	access = list(ACCESS_RND, ACCESS_COMMAND, ACCESS_ARMORY, ACCESS_SECURITY)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND, ACCESS_ARMORY, ACCESS_SECURITY)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 6
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the Lead Researcher. Your job is to run research on the abnormalities, make sure paperwork is in order and sent into command, and that the proper procedure is followed by the other researchers."

	job_abbreviation = "LR"


/datum/job/lead_researcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/lead_researcher
	name = "Lead Researcher"
	jobtype = /datum/job/lead_researcher

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/heads/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/rd
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/lr
	l_pocket = /obj/item/radio
