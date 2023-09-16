/datum/job/carnival
	title = "Carnival"
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "your self."
	selection_color = "#555555"
	access = list(ACCESS_CARGO)
	minimal_access = list(ACCESS_CARGO)
	outfit = /datum/outfit/job/carnival
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "city"
	paycheck = 200

	allow_bureaucratic_error = FALSE
	maptype = list("wonderlabs", "city")
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)



/datum/job/butcher/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	job_important = "If there is an L-Corp facility nearby, do not enter it. Fixers are not inherently hostile to you, but they can find a reason to put you down. \
			Your primary goal is to kill monsters in the backstreets and/or humans to weave silk so you can then sell it to the humans."
	..()

/datum/outfit/job/carnival
	name = "Carnival"
	jobtype = /datum/job/carnival
	uniform = /obj/item/clothing/under/suit/black
	belt = /obj/item/ego_weapon/city/carnival_spear	//So they can catch prey
	suit = null
	l_pocket = null
	ears = /obj/item/radio/headset/syndicatecity
	glasses = /obj/item/clothing/glasses/hud/health/night
	mask = /obj/item/clothing/mask/carnival_mask
	gloves = /obj/item/clothing/gloves/color/black

	backpack_contents = list(
		/obj/item/silkknife = 1,
		/obj/item/pda/roboticist = 1,
		/obj/item/clothing/suit/armor/ego_gear/city/carnival_robes = 1,
		/obj/item/book/granter/crafting_recipe/weaving_armor = 1)
