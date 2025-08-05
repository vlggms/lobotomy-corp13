/datum/job/production
	title = "R-Corp Production Specialist"
	faction = "Station"
	department_head = list("Production Team officer", "Commanders")
	total_positions = 3
	spawn_positions = 3
	exp_requirements = 0
	supervisors = "the production team officer and the commanders"
	selection_color = "#d9b555"

	outfit = /datum/outfit/job/production
	display_order = 13
	maptype = "rcorp_factory"

	access = list()
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	rank_title = "SPC"
	job_important = "You take the role of a production specialist."
	job_notice = "Assist the production officer in making a factory to send materials to the other roles!"

/datum/job/production/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/job/rcorp_captain/production
	title = "Production Officer"
	faction = "Station"
	department_head = list("Commanders")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commanders"
	selection_color = "#a18438"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp_factory"

	outfit = /datum/outfit/job/production/captain
	display_order = 12

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	rank_title = "LT"
	job_important = "You are the head of the production team."
	job_notice = "Make sure that the Acquisitions Specialists are sending materials to the base; and make sure that the production specialists are making the factory correctly."
	req_admin_notify = 1

/datum/job/production/acquisition
	title = "R-Corp Acquisitions Specialist"
	faction = "Station"
	department_head = list("Production Team Officer", "Commanders")
	total_positions = 3
	spawn_positions = 3
	exp_requirements = 0
	supervisors = "the production team officer and the commanders"
	selection_color = "#d9b555"

	outfit = /datum/outfit/job/production/acquisition
	display_order = 14
	maptype = "rcorp_factory"

	access = list()
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	rank_title = "SPC"
	job_important = "You take the role of an acquisition specialist."
	job_notice = "Head out into the field alongside the robins, set up the oil wells, and set up conveyors to send the materials back home!"

/datum/outfit/job/production
	name = "R-Corp Production"
	jobtype = /datum/job/production

	ears = null
	glasses = null
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = null
	suit = null
	l_pocket = /obj/item/flashlight/seclite
	box = null
	back = /obj/item/storage/backpack/rcorp
	ignore_pack = TRUE

/datum/outfit/job/production/captain
	name = "R-Corp Production Officer"
	jobtype = /datum/job/rcorp_captain/production

/datum/outfit/job/production/acquisition
	name = "R-Corp Acquisitions Specialist"
	jobtype = /datum/job/production/acquisition
