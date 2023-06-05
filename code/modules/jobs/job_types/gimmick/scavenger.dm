/*
Scavenger
*/
/datum/job/scavenger
	title = "Scavenger"
	faction = "Station"
	total_positions = 6
	spawn_positions = 2
	supervisors = "your stomach, riches and gold."
	selection_color = "#555555"
	access = list(ACCESS_LAWYER)
	minimal_access = list(ACCESS_LAWYER)
	outfit = /datum/outfit/job/scavenger
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "wonderlabs"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)


/datum/job/scavenger/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(40)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	to_chat(M, "<span class='userdanger'>You may be hostile to anyone else, including other scavengers in the backstreets, but may not be hostile in the nest. </span>")
	to_chat(M, "<span class='userdanger'>Your goal is to sell items you find in the backstreets and make money. </span>")

/datum/outfit/job/scavenger
	name = "Scavenger"
	jobtype = /datum/job/scavenger
	uniform = /obj/item/clothing/under/mercenary/camo
	belt = /obj/item/melee/classic_baton	//hit the chefs and fucking die.
	suit = /obj/item/clothing/suit/armor/vest/alt
	ears = null
