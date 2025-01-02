/*
Workshop employee
*/
/datum/job/workshop
	title = "Workshop Attendant"
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "no one but god."
	selection_color = "#dddddd"
	access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP)
	minimal_access = list(ACCESS_ENGINE, ACCESS_ENGINE_EQUIP)
	departments = DEPARTMENT_SERVICE
	outfit = /datum/outfit/job/workshop
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CIVILIAN
	exp_requirements = 60
	paycheck = 700

	job_attribute_limit = 0

	allow_bureaucratic_error = FALSE
	maptype = list("wonderlabs", "fixers")


//My guy you work in a workshop
/datum/job/workshop/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	. = ..()
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	job_important = "Make weapons for the fixers who come asking in exchange for money. You cannot give away weapons for free."
	job_notice = "Your workshop is northwest, of the city."
	..()


/datum/outfit/job/workshop
	name = "Workshop Attendant"
	jobtype = /datum/job/workshop
	uniform = /obj/item/clothing/under/rank/cargo/miner
	belt = /obj/item/melee/baton/loaded	//Really going to rob this guy?
	ears = null
