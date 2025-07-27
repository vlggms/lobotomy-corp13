//These are the people who send W-Corp agents to die. - Angela
/datum/job/wcorprep
	title = "W-Corp Representative"
	faction = "Station"
	department_head = list()
	total_positions = 1
	spawn_positions = 1
	supervisors = "The interests of W-Corp"
	selection_color = "#1b7ced"
	exp_requirements = 600
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "wcorp"
	trusted_only = TRUE

	outfit = /datum/outfit/job/wcorprep
	display_order = 1
	faction = "Station"
	//You're a glorified clerk. What do you think?
	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 20,
		PRUDENCE_ATTRIBUTE = 20,
		TEMPERANCE_ATTRIBUTE = 20,
		JUSTICE_ATTRIBUTE = 60
	)
	access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_RND, ACCESS_COMMAND, ACCESS_MEDICAL, ACCESS_MANAGER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_W_CORP
	rank_title = "W-Corp Representative"
	job_important = "You are W-Corp's main representative, overseeing the cleanup operation. Assure that all things go smoothy for the company."
	job_notice = "Manage the agents at your disposal."

	var/commander = TRUE

/datum/job/wcorprep/announce(mob/living/carbon/human/outfit_owner)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "W-Corp Representative [outfit_owner.real_name] has arrived for oversight."))
	if(commander)
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "W-Corp Representative [outfit_owner.real_name] has arrived for oversight."))
	else
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "Notice: [outfit_owner.real_name] has arrived as W-Corp's Representative."))

/datum/job/wcorprep/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	. = ..()
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(outfit_owner, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	outfit_owner.set_attribute_limit(80)
	to_chat(M, span_userdanger("This is a roleplay role. You are not affiliated with L Corporation. \
	Do not enter the lower levels of the facility without the manager's permission. Please use the beacon in your office to choose your association. \
	Do not assist L Corporation without significant payment."))
	to_chat(M, span_danger("Avoid killing other players without a reason."))

/datum/outfit/job/wcorprep
	name = "W-Corp Representative"
	jobtype = /datum/job/wcorprep

	belt = /obj/item/pda/security
	uniform = /obj/item/clothing/under/suit/lobotomy/plain //placeholder suit
	glasses = /obj/item/clothing/glasses/sunglasses
	shoes = /obj/item/clothing/shoes/sneakers/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	ears = /obj/item/radio/headset/heads/manager/alt
	l_pocket = /obj/item/commandprojector
