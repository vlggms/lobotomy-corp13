
/datum/job/low_sec_officer
	title = "Low Security Officer"
	faction = "Station"
	supervisors = "Low Security Commander"
	total_positions = 5
	spawn_positions = 5
	exp_requirements = 0
	selection_color = "#6571a6"
	access = list(ACCESS_SECURITY)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_SECURITY)	//See /datum/job/assistant/get_access()
	departments = DEPARTMENT_SECURITY

	outfit = /datum/outfit/job/low_sec_officer
	display_order = 8.5

	job_important = "You are a Low Security Officer, hired by LCB. Your job to ensure the safety of the researchers of the Low Security Zone. Deal with any hazards that occur with the zone, and attempt to coerce abnormalities to stay. If you are unable to keep the abnormalities to stay through coersion, suppress them. During your free time, feel free to interact with the abnormalities in your zone."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	loadalways = FALSE
	maptype = "limbus_labs"
	rank_title = "ZO"
	job_abbreviation = "LSO"


/datum/job/low_sec_officer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(20)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/low_sec_officer
	name = "Low Security Officer"
	jobtype = /datum/job/low_sec_officer

	head = /obj/item/clothing/head/beret/tegu/lobotomy/welfare
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/lowsec
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio


//Commander
/datum/job/low_sec_commander
	title = "Low Security Commander"
	faction = "Station"
	supervisors = "the District Manager"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	selection_color = "#444d75"
	access = list(ACCESS_SECURITY, ACCESS_COMMAND)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_SECURITY, ACCESS_COMMAND)	//See /datum/job/assistant/get_access()
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SECURITY

	outfit = /datum/outfit/job/low_sec_commander
	display_order = 8

	job_important = "You are a Low Security Commander, hired by LCB. Your job to commnand the Low Security Zone."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	loadalways = FALSE
	maptype = "limbus_labs"
	rank_title = "SiCPT"
	job_abbreviation = "LSC"


/datum/job/low_sec_commander/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(20)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/low_sec_commander
	name = "Low Security Commander"
	jobtype = /datum/job/low_sec_commander

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/officer
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/lsc
	head = /obj/item/clothing/head/beret/sec/lccb_commander
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio

