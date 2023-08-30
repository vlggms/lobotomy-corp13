//Hana
/datum/job/hana
	title = "Hana Representative"
	outfit = /datum/outfit/job/hana
	department_head = list("your association")
	faction = "Station"
	supervisors = "your association"
	selection_color = "#ffffff"
	total_positions = 2
	spawn_positions = 2
	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	trusted_only = TRUE
	access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	minimal_access = list(ACCESS_NETWORK, ACCESS_COMMAND, ACCESS_MANAGER, ACCESS_CHANGE_IDS)
	paycheck = 2100
	maptype = "city"


	//Mostly for armor.
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/hana/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	job_important = "You are the city's administrator, and have a small sort of power over the local association. \
		You MUST assist new fixer offices in getting set up, as well as issuing fixer licenses. \
		All new fixer offices MUST be announced upon creation, including office name and director name."
	job_notice = "Along with this, you may announce new taboos (which must be announced), and issue the association to enforce them. \
		You may also grade fixers, administer quests, and perform office inspections at your leisure."
	. = ..()


/datum/outfit/job/hana
	name = "Hana Representative"
	jobtype = /datum/job/hana

	id = /obj/item/card/id/silver/plastic
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hana
	l_pocket = /obj/item/potential_tester

//Hana
/datum/job/hana/boss
	title = "Hana Administrator"
	outfit = /datum/outfit/job/hana/admin
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_MANAGER
	paycheck = 10000


	//Mostly for armor.
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)


/datum/outfit/job/hana/admin
	name = "Hana Administrator"
	jobtype = /datum/job/hana/boss

	ears = /obj/item/radio/headset/heads/headset_association
	l_hand = /obj/item/clothing/suit/armor/ego_gear/city/hanacombat/paperwork
