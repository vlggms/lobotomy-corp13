
/datum/job/low_sec_medic
	title = "Low Security Medic"
	faction = "Station"
	supervisors = "Low Security Commander"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	selection_color = "#6571a6"
	access = list(ACCESS_SECURITY, ACCESS_MEDICAL)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_SECURITY, ACCESS_MEDICAL)	//See /datum/job/assistant/get_access()

	outfit = /datum/outfit/job/low_sec_medic
	display_order = 8.4

	job_important = "You are a Low Security Medic, hired by LCB. Your job to ensure the safety of the researchers and staff of the Low Security Zone. Deal with any hazards that occur with the zone, and attempt to coerce abnormalities to stay. If you are unable to keep the abnormalities to stay through coersion, suppress them. \
		You have an additional duty to heal officers. You have both Low-Security and Medical access"

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	loadalways = FALSE
	maptype = "limbus_labs"
	rank_title = "SZO"
	job_abbreviation = "LMD"


/datum/job/low_sec_medic/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(20)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/low_sec_medic
	name = "Low Security Medic"
	jobtype = /datum/job/low_sec_medic

	head = /obj/item/clothing/head/beret/tegu/med
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_control
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/lowsec
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	implants = /obj/item/organ/cyberimp/eyes/hud/medical
	l_pocket = /obj/item/radio
	l_hand = /obj/item/storage/firstaid/medical


