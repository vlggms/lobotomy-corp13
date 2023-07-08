/*
Workshop employee
*/
/datum/job/workshop
	title = "Workshop Attendant"
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "no one but god."
	selection_color = "#dddddd"
	access = list(ACCESS_ENGINE)		//10
	minimal_access = list(ACCESS_ENGINE)
	outfit = /datum/outfit/job/workshop
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CIVILIAN
	exp_requirements = 60
	paycheck = 700

	allow_bureaucratic_error = FALSE
	maptype = "wonderlabs"


//My guy you work in a workshop
/datum/job/chef/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	to_chat(M, "<span class='userdanger'>Your workshop is northwest, of the city. </span>")
	to_chat(M, "<span class='userdanger'>Make weapons for the fixers who come asking in exchange for money. You cannot give away weapons for free </span>")


/datum/outfit/job/workshop
	name = "Workshop Attendant"
	jobtype = /datum/job/workshop
	uniform = /obj/item/clothing/under/rank/cargo/miner
	belt = /obj/item/melee/baton/loaded	//Really going to rob this guy?
	ears = null
