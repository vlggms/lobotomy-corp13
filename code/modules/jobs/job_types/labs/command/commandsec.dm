//The protection gooners
/datum/job/damage_mitigation_officer
	title = "Damage Mitigation Officer"
	faction = "Station"
	supervisors = "District Manager"
	total_positions = 2
	spawn_positions = 2
	exp_requirements = 0
	selection_color = "#ccaaaa"
	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND)		//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND)	//See /datum/job/assistant/get_access()

	outfit = /datum/outfit/job/damage_mitigation_officer
	display_order = 4

	job_important = "You are a Damage Mitigation Officer, hired by LCB. Your job to protect the Command Team and department heads."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	loadalways = FALSE
	maptype = "limbus_labs"


/datum/job/damage_mitigation_officer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(60)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/damage_mitigation_officer
	name = "Damage Mitigation Officer"
	jobtype = /datum/job/damage_mitigation_officer

	head = /obj/item/clothing/head/hos/beret
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/agent_lieutenant
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio


//The Kill gooners
/datum/job/damage_exasperation_officer
	title = "Damage Exasperation Officer"
	faction = "Station"
	supervisors = "District Manager"
	total_positions = 2
	spawn_positions = 2
	exp_requirements = 0
	selection_color = "#ccaaaa"
	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND)		//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND)	//See /datum/job/assistant/get_access()

	outfit = /datum/outfit/job/damage_exasperation_officer
	display_order = 4.5

	job_important = "You are a Damage Exasperation Officer, hired by LCB. Your job to protect ensure the safety of LC employees when the security officers are unable or fail to handle the threat."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)
	loadalways = FALSE
	maptype = "limbus_labs"


/datum/job/damage_exasperation_officer/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	H.set_attribute_limit(60)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

/datum/outfit/job/damage_exasperation_officer
	name = "Damage Exasperation Officer"
	jobtype = /datum/job/damage_exasperation_officer

	head = /obj/item/clothing/head/hos/beret
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/agent_lieutenant
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio
