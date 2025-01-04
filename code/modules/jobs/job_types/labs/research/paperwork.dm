/datum/job/archivist
	title = "Research Archivist"
	faction = "Station"
	supervisors = "Lead Researcher"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#af57ba"

	outfit = /datum/outfit/job/archivist

	access = list(ACCESS_RND, ACCESS_COMMAND)
	minimal_access = list(ACCESS_RND, ACCESS_COMMAND)
	departments = DEPARTMENT_SCIENCE

	job_attribute_limit = 0


	display_order = 6.1
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the research archivist. Your goal is to assist Research in filing paperwork."
	job_notice = "Make 3 copies of each report, one for the manager, one for Asset protection, and one for the LR which will then be put into the vault."
	job_abbreviation = "ARCH"

/datum/job/archivist/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)


/datum/outfit/job/archivist
	name = "Research Archivist"
	jobtype = /datum/job/archivist

	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/beret/tegu/science
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/arch
	l_pocket = /obj/item/radio
