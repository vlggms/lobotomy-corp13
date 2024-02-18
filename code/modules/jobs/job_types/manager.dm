/datum/job/manager
	title = "Manager"
	department_head = list("L Corp")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the manager"
	selection_color = "#bcbcef"
	display_order = JOB_DISPLAY_ORDER_MANAGER

	exp_requirements = 720
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/manager

	access = list(ACCESS_COMMAND, ACCESS_MANAGER) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND, ACCESS_MANAGER)

	job_attribute_limit = 60
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 0,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 0,
								JUSTICE_ATTRIBUTE = 0
								)
	job_important = "You are the Manager. Your goal is to provide overwatch to all agents and clerks and direct works. You can also choose abnormalities and apply buffs to agents."

/datum/job/manager/announce(mob/living/carbon/human/H)
	..()
	var/displayed_rank = title // Handle alt titles
	if(title in H?.client?.prefs?.alt_titles_preferences)
		displayed_rank = H.client.prefs.alt_titles_preferences[title]
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[displayed_rank] [H.real_name] has arrived to the facility."))

/datum/job/manager/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	H.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong better but not speak it

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/outfit/job/manager
	name = "Manager"
	jobtype = /datum/job/manager

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/toggle/labcoat
	backpack_contents = list(/obj/item/station_charter)
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command
