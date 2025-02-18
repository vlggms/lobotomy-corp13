/datum/job/lc_janitor
	title = "LC Janitor"
	faction = "Station"
	supervisors = "the District Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#bbbbbb"

	outfit = /datum/outfit/job/lc_janitor

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_SERVICE

	job_attribute_limit = 0

	display_order = 11.1
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a limbus company janitor. Assist the facility in cleaning up as you can."
	job_abbreviation = "JAN"

/datum/job/lc_janitor/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/lc_janitor
	name = "LC Janitor"
	jobtype = /datum/job/lc_janitor

	belt = /obj/item/pda
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/rank/civilian/janitor
	head = /obj/item/clothing/head/soft/purple
	shoes = /obj/item/clothing/shoes/galoshes
	l_pocket = /obj/item/radio
