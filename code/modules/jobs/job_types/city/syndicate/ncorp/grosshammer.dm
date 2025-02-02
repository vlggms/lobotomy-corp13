//grosshammer
/datum/job/grosshammer
	title = "N Corp Grosshammer"
	outfit = /datum/outfit/job/grosshammer
	department_head = list("the will of the grandinquisitor.")
	faction = "Station"
	supervisors = "the will of the grandinquisitor."
	selection_color = "#94833d"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEVET
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 70
	maptype = list("city")
	job_important = "You are an NCorp grosshammer. Your main goal is to kill and maim all prosthetic users. \
			Follow the orders of the Grand Inquisitor, and lead the mittlehammers and kleinhammers into combat."
	job_notice = "You may kill anyone with prosthetics, or anyone sympathetic to prosthetics."

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/grosshammer/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/grosshammer
	name = "N Corp Grosshammer"
	jobtype = /datum/job/grosshammer

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
