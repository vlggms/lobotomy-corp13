
/datum/job/high_sec_officer
	title = "High Security Officer"
	faction = "Station"
	supervisors = "High Security Commander"
	total_positions = 3
	spawn_positions = 3
	exp_requirements = 0
	selection_color = "#cf5979"
	access = list(ACCESS_ARMORY)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ARMORY)	//See /datum/job/assistant/get_access()
	departments = DEPARTMENT_SECURITY

	outfit = /datum/outfit/job/high_sec_officer
	display_order = 9.5

	job_important = "You are a High Security Officer, hired by LCB. Your job to ensure the safety of the researchers of the High Security Zone. Deal with any hazards that occur with the zone, and attempt to coerce abnormalities to stay. If you are unable to keep the abnormalities to stay through coersion, suppress them. During your free time, feel free to interact with the abnormalities in your zone."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	loadalways = FALSE
	maptype = "limbus_labs"
	rank_title = "SZO"
	job_abbreviation = "HSO"


/datum/job/high_sec_officer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(40)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)


/datum/outfit/job/high_sec_officer
	name = "High Security Officer"
	jobtype = /datum/job/high_sec_officer

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/highsec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio

/datum/job/high_sec_commander
	title = "High Security Commander"
	faction = "Station"
	supervisors = "LCB officials"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	selection_color = "#99314d"
	access = list(ACCESS_ARMORY, ACCESS_COMMAND)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ARMORY, ACCESS_COMMAND)	//See /datum/job/assistant/get_access()
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SECURITY

	outfit = /datum/outfit/job/high_sec_commander
	display_order = 9

	job_important = "You are a High Security Commander, hired by LCB. Your job to commnand the High Security Zone."

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
	job_abbreviation = "HSC"


/datum/job/high_sec_commander/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(60)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/high_sec_commander
	name = "High Security Commander"
	jobtype = /datum/job/high_sec_commander

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/headset_discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/officer
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus_labs/hsc
	head = /obj/item/clothing/head/beret/sec/lccb_commander
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio
