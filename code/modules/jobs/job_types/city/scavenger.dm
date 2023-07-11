/*
Scavenger
*/
/datum/job/scavenger
	title = "Rat"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your stomach, riches and gold."
	selection_color = "#555555"
	access = list(ACCESS_LAWYER)
	minimal_access = list(ACCESS_LAWYER)
	outfit = /datum/outfit/job/scavenger
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "city"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	paycheck = 0


/datum/job/scavenger/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	job_important = "You may be hostile to anyone else, unless you join a fixer office. \
	Your goal is to sell items you find in the backstreets and make money. \
	Instead of being a rat in the backstreets, you may also start or join a fixer office."

	//You get one shot at good stats.
	if(!(M.ckey in SScityevents.generated))
		//generate from the lowest of 2 generated numbers
		var/statgeneration1 = rand(110)
		var/statgeneration2 = rand(110)

		var/stattotal = 20 + min(statgeneration1, statgeneration2)

		roundstart_attributes = list(
									FORTITUDE_ATTRIBUTE = stattotal,
									PRUDENCE_ATTRIBUTE = stattotal,
									TEMPERANCE_ATTRIBUTE = stattotal,
									JUSTICE_ATTRIBUTE = stattotal
									)
		SScityevents.generated+=M.ckey
	else
		roundstart_attributes = list(
									FORTITUDE_ATTRIBUTE = 20,
									PRUDENCE_ATTRIBUTE = 20,
									TEMPERANCE_ATTRIBUTE = 20,
									JUSTICE_ATTRIBUTE = 20
									)
	..()

/datum/outfit/job/scavenger
	name = "Scavenger"
	jobtype = /datum/job/scavenger
	uniform = /obj/item/clothing/under/mercenary/camo
	belt = /obj/item/melee/classic_baton	//hit the chefs and fucking die.
	suit = /obj/item/clothing/suit/armor/vest/alt
	ears = null
