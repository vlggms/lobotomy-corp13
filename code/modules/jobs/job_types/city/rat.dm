/*
Scavenger
*/
/datum/job/scavenger
	title = "Rat"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "your stomach, riches and gold."
	selection_color = "#555555"
	access = list(ACCESS_LAWYER)
	minimal_access = list(ACCESS_LAWYER)
	departments = DEPARTMENT_FIXERS // Close enough
	outfit = /datum/outfit/job/scavenger
	antag_rep = 7
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "city"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	paycheck = 0
	job_important = "Your sole purpose is to cause chaos in the city. You have no rules."


/datum/job/scavenger/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	..()

/datum/outfit/job/scavenger
	name = "Rat"
	jobtype = /datum/job/scavenger
	uniform = null
	belt = null
	suit = null
	ears = null
	id = null			//All determined later

/datum/outfit/job/scavenger/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	id = /obj/item/card/id
	uniform = pick(/obj/item/clothing/under/shorts/black,
		/obj/item/clothing/under/rank/prisoner,
		/obj/item/clothing/under/color/random,
		/obj/item/clothing/under/pants/classicjeans)

	if(prob(50))
		uniform = /obj/item/clothing/under/mercenary/camo

	suit = pick(/obj/item/clothing/suit/armor/vest/alt,
		/obj/item/clothing/suit/jacket/puffer,
		/obj/item/clothing/suit/jacket/miljacket)

	belt = pick(/obj/item/ego_weapon/city/rats,
		/obj/item/ego_weapon/city/rats/knife,
		/obj/item/ego_weapon/city/rats/scalpel,
		/obj/item/ego_weapon/city/rats/brick,
		/obj/item/ego_weapon/ranged/pistol/rats,
		/obj/item/ego_weapon/city/rats/pipe)
	..()
