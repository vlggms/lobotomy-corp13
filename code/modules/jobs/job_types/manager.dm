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
	minimal_player_age = 7

	outfit = /datum/outfit/job/manager

	access = list(ACCESS_COMMAND, ACCESS_MANAGER) // LC13:To-Do
	minimal_access = list(ACCESS_COMMAND, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND

	job_attribute_limit = 60
	roundstart_attributes = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE = 60, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)
	job_important = "You are the Manager. Your goal is to provide overwatch to Agents and Clerks while guiding the facility's progress. You are able to choose arriving Abnormalities, buy facility upgrades, and apply buffs through your camera console."

	job_abbreviation = "MGR"

/datum/job/manager/announce(mob/living/carbon/human/outfit_owner)
	..()
	var/displayed_rank = title // Handle alt titles
	if(title in outfit_owner?.client?.prefs?.alt_titles_preferences)
		displayed_rank = outfit_owner.client.prefs.alt_titles_preferences[title]

	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[displayed_rank] [outfit_owner.real_name] has arrived to the facility."))

/datum/job/manager/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	outfit_owner.grant_language(/datum/language/bong, TRUE, FALSE, LANGUAGE_MIND) //So they can understand the bong-bong but not speak it

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]

	secsensor.add_hud_to(outfit_owner)
	medsensor.add_hud_to(outfit_owner)

/datum/outfit/job/manager
	name = "Manager"
	jobtype = /datum/job/manager

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit =  /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	r_pocket = /obj/item/modular_computer/tablet/preset/advanced/command

	backpack_contents = list(/obj/item/station_charter)
