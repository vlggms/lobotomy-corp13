/datum/job/lc_chef
	title = "LC Chef"
	faction = "Station"
	supervisors = "the District Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#bbbbbb"

	outfit = /datum/outfit/job/lc_chef

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_SERVICE

	job_attribute_limit = 0

	display_order = 11.2
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are a limbus company chef. Make food for the staff; and grow plants in the back."
	job_abbreviation = "CHF"

/datum/job/lc_chef/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/lc_chef
	name = "LC Chef"
	jobtype = /datum/job/lc_chef

	belt = /obj/item/pda
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/rank/civilian/chef
	suit = /obj/item/clothing/suit/toggle/chef
	head = /obj/item/clothing/head/chefhat
	shoes = /obj/item/clothing/shoes/sneakers/white
	l_pocket = /obj/item/radio

