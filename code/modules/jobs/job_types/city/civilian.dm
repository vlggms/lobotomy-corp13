/*
Civilian
*/
/datum/job/civilian
	title = "Civilian"
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "yourself."
	selection_color = "#dddddd"
	access = list(ACCESS_LAWYER)
	minimal_access = list(ACCESS_LAWYER)
	outfit = /datum/outfit/job/civilian
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CIVILIAN

	allow_bureaucratic_error = FALSE
	maptype = "city"
	paycheck = 170


/datum/job/civilian/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	//Don't dupe money.
	if(H.ckey in SScityevents.generated)
		paycheck = 50
	else
		paycheck = initial(paycheck)
	..()


/datum/job/civilian/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	job_important = "You are an average civilian in The City. You have no goals! However, if you would like to join a fixer office, contact the Hana representative in town."

	//You get one shot at good stats.
	if(!(M.ckey in SScityevents.generated))
		//generate from the lowest of 3 generated numbers
		var/statgeneration1 = rand(110)
		var/statgeneration2 = rand(110)
		var/statgeneration3 = rand(110)

		var/stattotal = min(statgeneration1, statgeneration2)
		stattotal = 20+min(stattotal, statgeneration3)

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

/datum/outfit/job/civilian
	name = "Civilan"
	jobtype = /datum/job/civilian
	uniform = /obj/item/clothing/under/suit/charcoal
	belt = null
	ears = null
