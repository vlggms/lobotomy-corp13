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
	departments = DEPARTMENT_SERVICE
	outfit = /datum/outfit/job/chef
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_HHPP
	exp_requirements = 60

	job_attribute_limit = 0

	allow_bureaucratic_error = FALSE
	maptype = list("wonderlabs", "city", "fixers")


//Why would you work as a HHPP chef is beyond me.
/datum/job/chef/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	. = ..()
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	to_chat(M, "<span class='userdanger'>HamHamPangPang requires that you take payment in exchange for food. </span>")
	to_chat(M, "<span class='userdanger'>HamHamPangPang does not approve the use of human meat in their food, it \
		may cause the regional director to launch an investigation. </span>")


/datum/outfit/job/chef
	name = "HHPP Chef"
	jobtype = /datum/job/chef
	uniform = /obj/item/clothing/under/rank/civilian/chef
	belt = /obj/item/melee/baton/loaded	//hit the chefs and fucking die.
	suit = /obj/item/clothing/suit/apron/chef
	ears = null
