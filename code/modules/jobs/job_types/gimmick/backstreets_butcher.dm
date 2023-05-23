/*
Backstreets Butcher
*/
/datum/job/butcher
	title = "Backstreets Butcher"
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your stomach."
	selection_color = "#555555"
	access = list(ACCESS_GENETICS)
	minimal_access = list(ACCESS_GENETICS)
	outfit = /datum/outfit/job/butcher
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "wonderlabs"
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)



/datum/job/butcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(0)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	to_chat(M, "<span class='userdanger'>Stay out of L-Corp's facility. Fixers are not inherently hostile to you, but they can and will find a reason to put you down. \
			Your primary goal is to cook people and make more money than HHPP. You own The Bistro in town.</span>")

/datum/outfit/job/butcher
	name = "Backstreets Butcher"
	jobtype = /datum/job/butcher
	uniform = /obj/item/clothing/under/rank/civilian/chef
	belt = /obj/item/melee/classic_baton	//So they can catch prey
	suit = /obj/item/clothing/suit/apron/chef
	l_pocket = /obj/item/restraints/handcuffs
	ears = null

	backpack_contents = list(
		/obj/item/clothing/mask/muzzle = 1,
		/obj/item/kitchen/knife/butcher/deadly = 1,
		/obj/item/restraints/legcuffs/bola/tactical = 1)
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
