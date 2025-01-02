/datum/job/carnival
	title = "Carnival"
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your self."
	selection_color = "#555555"
	access = list(ACCESS_CARGO)
	minimal_access = list(ACCESS_CARGO)
	departments = DEPARTMENT_SERVICE
	outfit = /datum/outfit/job/carnival
	display_order = JOB_DISPLAY_ORDER_ANTAG
	exp_requirements = 300

	allow_bureaucratic_error = FALSE
	maptype = "city"
	paycheck = 100

	allow_bureaucratic_error = FALSE
	maptype = list("wonderlabs", "city")
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)



/datum/job/carnival/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	H.set_species(/datum/species/synth)
	job_important = "You are allowed to enter the backstreets to hunt for silk. However, DO NOT LOOT THE WEAPONS, CASH OR ARMOR FROM THE BACKSTREETS! \
			Your primary goal is to kill monsters in the backstreets and/or humans to weave silk so you can then sell it to the humans. \
			You have a base on the left side of the nest. \
			Once more just to make sure you don't forget, DO NOT LOOT THE WEAPONS, CASH OR ARMOR FROM THE BACKSTREETS!"
	..()

/datum/outfit/job/carnival
	name = "Carnival"
	jobtype = /datum/job/carnival
	uniform = /obj/item/clothing/under/suit/black
	belt = /obj/item/ego_weapon/city/carnival_spear	//So they can catch prey
	suit = null
	l_pocket = null
	ears = /obj/item/radio/headset/wcorp/safety
	glasses = /obj/item/clothing/glasses/hud/health/night
	mask = /obj/item/clothing/mask/carnival_mask
	gloves = /obj/item/clothing/gloves/color/black

	backpack_contents = list(
		/obj/item/silkknife = 1,
		/obj/item/pda/roboticist = 1,
		/obj/item/book/granter/crafting_recipe/carnival/weaving_armor = 1,
		/obj/item/stack/sheet/silk/indigo_simple = 4,
		/obj/item/stack/sheet/silk/green_simple = 4,
		/obj/item/stack/sheet/silk/amber_simple = 4,
		/obj/item/stack/sheet/silk/steel_simple = 4,
		/obj/item/stack/sheet/silk/human_simple = 1)
