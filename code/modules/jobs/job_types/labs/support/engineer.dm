/datum/job/lc_engineer
	title = "Containment Engineer"
	faction = "Station"
	supervisors = "the District Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#bbbbbb"

	outfit = /datum/outfit/job/lc_engineer

	access = list(ACCESS_SECURITY, ACCESS_ARMORY, ACCESS_CONSTRUCTION)
	minimal_access = list(ACCESS_SECURITY, ACCESS_ARMORY, ACCESS_CONSTRUCTION)
	departments = DEPARTMENT_ENGINEERING

	job_attribute_limit = 0

	display_order = 11
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a limbus Containment Engineer. Assist in repairing the containment zones in low security and high security"
	rank_title = "MZO"
	job_abbreviation = "CE"

/datum/job/lc_engineer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/lc_engineer
	name = "Containment Engineer"
	jobtype = /datum/job/lc_engineer

	belt = /obj/item/pda/engineering
	ears = /obj/item/radio/headset/agent_lieutenant
	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	suit = /obj/item/clothing/suit/hazardvest
	head = /obj/item/clothing/head/beret/tegu/eng/hazard
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/radio

	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
