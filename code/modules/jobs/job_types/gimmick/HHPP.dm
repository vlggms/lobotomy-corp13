/*
HHPP Employee
*/
/datum/job/chef
	title = "HHPP Chef"
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "no one but god."
	selection_color = "#dddddd"
	access = list(ACCESS_KITCHEN)
	minimal_access = list(ACCESS_KITCHEN)
	outfit = /datum/outfit/job/chef
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_HHPP


	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	display_order = 36
	allow_bureaucratic_error = FALSE
	maptype = "wonderlabs"


//Why would you work as a HHPP chef is beyond me.
/datum/job/chef/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/chef
	name = "HHPP Chef"
	jobtype = /datum/job/chef
	uniform = /obj/item/clothing/under/rank/civilian/chef
	belt = /obj/item/melee/baton/loaded	//hit the chefs and fucking die.
	suit = /obj/item/clothing/suit/apron/chef
	ears = null
