/datum/job/manager
	title = "Manager"
	department_head = list("L Corp")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#bcbcef"
	display_order = JOB_DISPLAY_ORDER_CAPTAIN

	exp_requirements = 720
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/manager

	access = list(ACCESS_COMMAND, ACCESS_MANAGER) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND, ACCESS_MANAGER)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 0,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 0
								)

/datum/job/manager/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Manager [H.real_name] has arrived to the facility."))

/datum/job/manager/after_spawn(mob/living/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/manager
	name = "Manager"
	jobtype = /datum/job/manager

	glasses = /obj/item/clothing/glasses/debug
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/toggle/labcoat
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
