//Mittlehammer
/datum/job/mittlehammer
	title = "N Corp Mittlehammer"
	outfit = /datum/outfit/job/mittlehammer
	department_head = list("the will of the grandinquisitor.")
	faction = "Station"
	supervisors = "the will of the grandinquisitor."
	selection_color = "#94833d"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 70
	maptype = list("city")
	job_important = "You are an NCorp Mittlehammer. Your main goal is to kill and maim all prosthetic users. \
			Follow the orders of the Grand Inquisitor, as they will lead you to battle."
	job_notice = "You may kill anyone with prosthetics, or anyone sympathetic to prosthetics."
	mind_traits = list(TRAIT_WORK_FORBIDDEN, TRAIT_COMBATFEAR_IMMUNE)
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)


/datum/outfit/job/mittlehammer
	name = "N Corp Mittlehammer"
	jobtype = /datum/job/mittlehammer

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
