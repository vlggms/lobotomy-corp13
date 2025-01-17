/*
Backstreets Butcher
*/
/datum/job/butcher
	title = "Backstreets Butcher"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "your stomach."
	selection_color = "#555555"
	access = list(ACCESS_GENETICS)
	minimal_access = list(ACCESS_GENETICS)
	departments = DEPARTMENT_SERVICE // They can provide you a service, before you're eaten
	outfit = /datum/outfit/job/butcher
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = list("wonderlabs", "city")
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)



/datum/job/butcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	job_important = "If there is an L-Corp facility nearby, do not enter it. Fixers are not inherently hostile to you, but they can and will find a reason to put you down. \
			Your primary goal is to kill and cook people and make more money than HHPP. You own The Bistro in the northeast of town."
	..()

/datum/outfit/job/butcher
	name = "Backstreets Butcher"
	jobtype = /datum/job/butcher
	uniform = /obj/item/clothing/under/rank/civilian/chef
	belt = /obj/item/gun/magic/hook
	suit = /obj/item/clothing/suit/apron/chef
	l_pocket = /obj/item/restraints/handcuffs
	ears = null

	backpack_contents = list(
		/obj/item/clothing/mask/muzzle = 1,
		/obj/item/melee/classic_baton = 1,	//So they can catch prey
		/obj/item/kitchen/knife/butcher/deadly = 1)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
