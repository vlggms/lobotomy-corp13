/datum/job/reindeer
	title = "R-Corp Medical Reindeer"
	faction = "Station"
	department_head = list("Reindeer Team Captain", "Commander")
	total_positions = 3
	spawn_positions = 3
	supervisors = "the reindeer team captain and the commander"
	selection_color = "#d9b555"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	maptype = "rcorp"

	outfit = /datum/outfit/job/reindeer
	display_order = 7

	access = list(ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MEDICAL)
	departments = DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	rank_title = "SPC"
	job_important = "You take the role of defensive medical support. DO NOT CROSS THE BEAMS."
	job_notice = "You are a mostly support role. Gather your supplies in the medical tent to the SW of the base. Split up for maximum effectiveness."

/datum/job/reindeer/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

	//Adding huds, blame some guy from at least 3 years ago.
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	secsensor.add_hud_to(H)
	medsensor.add_hud_to(H)

/datum/job/reindeer/berserker
	title = "R-Corp Berserker Reindeer"
	total_positions = 2
	spawn_positions = 2
	outfit = /datum/outfit/job/reindeer/berserker
	display_order = 7.1

	rank_title = "SGT"
	job_important = "You take the role of offensive medical. DO NOT CROSS THE BEAMS."
	job_notice = "You are an offensive support role. Your staff heals the sanity of those around you while linked to an enemy. Split up for maximum effectiveness."


/datum/job/rcorp_captain/reindeer
	title = "Reindeer Squad Captain"
	faction = "Station"
	department_head = list("Commander")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the commander"
	selection_color = "#d1a83b"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "rcorp"

	outfit = /datum/outfit/job/reindeer/captain
	display_order = 3

	access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_R_CORP | DEPARTMENT_MEDICAL

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)
	rank_title = "CPT"
	job_important = "You are the captain of the welfare division."
	job_notice = "Visit your bunks in the command tent to gather your medical supplies, and split your units into small groups."


/datum/outfit/job/reindeer
	name = "R-Corp Medical Reindeer"
	jobtype = /datum/job/reindeer

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/reindeer/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeermed
	l_pocket = /obj/item/flashlight/seclite
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	l_hand = /obj/item/gun/medbeam
	belt = null


/datum/outfit/job/reindeer/berserker
	name = "R-Corp Berserker Reindeer"
	jobtype = /datum/job/reindeer/berserker

	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_hand = /obj/item/gun/mindwhip
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeerberserk


/datum/outfit/job/reindeer/captain
	name = "Reindeer Squad Captain"
	jobtype = /datum/job/rcorp_captain/reindeer
	glasses = /obj/item/clothing/glasses/hud/health/night/rabbit
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/reindeercap
	belt = /obj/item/ego_weapon/city/rabbit_blade
	head = /obj/item/clothing/head/rabbit_helmet/reindeer
	ears = /obj/item/radio/headset/heads/headset_welfare
