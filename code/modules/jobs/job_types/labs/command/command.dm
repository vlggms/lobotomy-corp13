/datum/job/district_manager
	title = "District Manager"
	faction = "Station"
	supervisors = "LCB Executive Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#444444"

	outfit = /datum/outfit/job/district_manager

	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND

	job_attribute_limit = 0

	display_order = 1
	alt_titles = list()
	maptype = "limbus_labs"
	job_abbreviation = "ExMGR"
	job_important = "You are the District Manager. Your job is to ensure everybody is following proper procedure."


/datum/job/district_manager/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/outfit/job/district_manager
	name = "District Manager"
	jobtype = /datum/job/district_manager

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/radio


