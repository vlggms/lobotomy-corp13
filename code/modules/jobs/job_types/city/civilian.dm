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
	departments = DEPARTMENT_SERVICE
	outfit = /datum/outfit/job/civilian
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_CIVILIAN
	allow_bureaucratic_error = FALSE
	maptype = list("city", "fixers")
	paycheck = 170
	var/static/list/possible_books = null

/datum/job/civilian/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	//Don't dupe money.
	if(H.ckey in SScityevents.generated)
		paycheck = 50
	else
		paycheck = initial(paycheck)
	return ..()

/proc/get_civilian_level(mob/living/carbon/human/user)
	var/collective_levels = 0
	for(var/a in user.attributes)
		var/datum/attribute/attribute = user.attributes[a]
		collective_levels += attribute.level

	var/level = collective_levels / length(user.attributes)
	if (level < 40)
		return 0
	else if (level >= 40 && level < 60 )
		return 1
	else if (level >= 60 && level < 100 )
		return 2
	else if (level >= 100 && level < 120 )
		return 3
	else
		return 4

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
		stattotal = 20 + min(stattotal, statgeneration3)

		roundstart_attributes = list(
									FORTITUDE_ATTRIBUTE = stattotal,
									PRUDENCE_ATTRIBUTE = stattotal,
									TEMPERANCE_ATTRIBUTE = stattotal,
									JUSTICE_ATTRIBUTE = stattotal
									)
		SScityevents.generated += M.ckey
	else
		roundstart_attributes = list(
									FORTITUDE_ATTRIBUTE = 20,
									PRUDENCE_ATTRIBUTE = 20,
									TEMPERANCE_ATTRIBUTE = 20,
									JUSTICE_ATTRIBUTE = 20
									)
	. = ..()
	if(prob(50))
		if(!possible_books) // Since possible_books is a static var, we dont know if its generated or not. If its not then generate it
			possible_books = list(list(), list(), list(), list(), list())
			for(var/obj/item/book/granter/action/skill/book as anything in subtypesof(/obj/item/book/granter/action/skill))
				possible_books[book.level + 1] += book // we add 1 here to account for level 0 fixers, they get the first index

		var/player_level = get_civilian_level(H) + 1
		if(!length(possible_books[player_level]))
			return

		var/book_path = pick(possible_books[player_level])
		var/obj/item/book/granter/action/skill/random_book = new book_path()
		H.equip_to_slot_or_del(random_book, ITEM_SLOT_BACKPACK, TRUE)

/datum/outfit/job/civilian
	name = "Civilan"
	jobtype = /datum/job/civilian
	uniform = /obj/item/clothing/under/suit/charcoal
	belt = null
	ears = null
