/datum/job/roadrunner
	title = "R-Corp Roadrunner"
	faction = "Station"
	department_head = list("Roadrunner Squad Leader", "Commander")
	total_positions = 4
	spawn_positions = 3
	exp_requirements = 120
	supervisors = "the roadrunner squad leader and the commander"
	selection_color = "#d13711"

	outfit = /datum/outfit/job/roadrunner
	display_order = 13
	maptype = "rcorp_fifth"

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 50,
								PRUDENCE_ATTRIBUTE = 50,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "SGT"
	job_important = "You take the role of skirmishers."
	job_notice = "You are a Roadrunner armed with a multiphase gun and shield. You harass the enemy and give them no time to recover between assaults."

/datum/job/roadrunner/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/job/rcorp_captain/roadrunner
	title = "Roadrunner Squad Leader"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d13711"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp_fifth"

	outfit = /datum/outfit/job/roadrunner/leader
	display_order = 4

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 70,
								PRUDENCE_ATTRIBUTE = 70,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 130
								)
	rank_title = "LT"
	job_important = "You are the squad leader of the skirmishing division."
	//job_notice = "Visit your bunks in the command tent to gather your one-handed rabbit gun and multiphase blade."


// Mostly uneditted outfit datums for gear that doesn't exist yet.
/datum/outfit/job/roadrunner
	name = "R-Corp Roadrunner"
	jobtype = /datum/job/roadrunner

	ears = /obj/item/radio/headset/headset_information
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/roadrunner
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunner
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp

/datum/outfit/job/roadrunner/leader
	name = "Roadrunner Squad Leader"
	jobtype = /datum/job/rcorp_captain/roadrunner

	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	suit_store = null
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/roadrunnercap
	ears = /obj/item/radio/headset/heads/headset_control
