GLOBAL_LIST_INIT(association_jobs, list(
	/datum/job/associate,
	/datum/job/veteran,
	/datum/job/director,
))


//Director
/datum/job/director
	title = "Association Section Director"
	outfit = /datum/outfit/job/director
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_DIRECTOR
	trusted_only = TRUE
	access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE) // I want to use the number 69.
	minimal_access = list(ACCESS_PHARMACY, ACCESS_NETWORK, ACCESS_RC_ANNOUNCE)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_ASSOCIATION
	paycheck = 700
	maptype = list("wonderlabs", "city")

	//They actually need this for their weapons
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)

	var/list/antagroles = list(
		/datum/job/messenger,
		/datum/job/cutthroat,
		/datum/job/sottocapo,
		/datum/job/grandinquis,
		/datum/job/kurocaptain,
		/datum/job/east_capo,
	)
	var/antag_chosen

/datum/job/director/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, span_userdanger("This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. Please use the beacon in your office to choose your association. \
	Do not fight unless in self defense. You are not a combat role; you take an administrative role. \
	Do not assist L Corporation without significant payment."))
	to_chat(M, span_danger("Avoid killing other players without a reason."))
	var/antagspawn = pick(antagroles)
	outfit_owner.set_attribute_limit(120)

	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/associate))
			processing.total_positions = 3

		if(istype(processing, /datum/job/veteran))
			processing.total_positions = 1

		if(!antag_chosen)
			if(istype(processing, antagspawn))
				processing.total_positions = 1
				antag_chosen = TRUE

	return ..()

/datum/outfit/job/director
	name = "Associate Director"
	jobtype = /datum/job/director

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/headset_association
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association

	backpack_contents = list()

//Veteran
/datum/job/veteran
	title = "Association Veteran"
	outfit = /datum/outfit/job/veteran
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_VETERAN
	trusted_only = TRUE
	access = list(ACCESS_NETWORK)
	minimal_access = list(ACCESS_NETWORK)
	departments = DEPARTMENT_ASSOCIATION | DEPARTMENT_FIXERS
	paycheck = 400
	maptype = list("wonderlabs", "city")

	//They actually need this for their weapons
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)

/datum/job/veteran/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, span_userdanger("This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. You are the second in command of the local association, \
	and can offer frontline command."))
	to_chat(M, span_danger("Avoid killing other players without a reason."))
	outfit_owner.set_attribute_limit(100)
	return ..()

/datum/outfit/job/veteran
	name = "Associate Veteran"
	jobtype = /datum/job/veteran

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association

	backpack_contents = list()


//Associate fixer
/datum/job/associate
	title = "Association Fixer"
	outfit = /datum/outfit/job/associate
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#e09660"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_ASSOCIATION
	access = list(ACCESS_NETWORK)
	minimal_access = list(ACCESS_NETWORK)
	departments = DEPARTMENT_ASSOCIATION | DEPARTMENT_FIXERS
	paycheck = 700
	maptype = list("wonderlabs", "city")


	//They actually need this for their weapons
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

/datum/job/associate/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	//Not fear immune you're basically some goober
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	to_chat(M, span_userdanger("This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission."))
	to_chat(M, span_danger("Avoid killing other players without a reason."))
	outfit_owner.set_attribute_limit(80)
	return ..()

/datum/outfit/job/associate
	name = "Associate Fixer"
	jobtype = /datum/job/associate

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/association

	backpack_contents = list()
