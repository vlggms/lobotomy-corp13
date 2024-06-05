// Training Officer
/datum/job/agent/training_officer
	title = "Training Officer"
	selection_color = "#e09660"
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/agent/training_officer
	display_order = JOB_DISPLAY_ORDER_COMMAND

	access = list(ACCESS_COMMAND)
	exp_requirements = 0
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	job_important = "You are a Training Officer. Your primary goal is to assist interns and clerks in learning. You are not here to win, but to teach."
	job_notice = "Abandoning your duties, or abusing your tools will result in a report to the admin team."

	job_abbreviation = "TO"
	mentor_only = TRUE

/datum/job/agent/training_officer/announce(mob/living/carbon/human/outfit_owner)
	..()
	var/displayed_rank = title // Handle alt titles
	if(title in outfit_owner?.client?.prefs?.alt_titles_preferences)
		displayed_rank = outfit_owner.client.prefs.alt_titles_preferences[title]

	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "[displayed_rank] [outfit_owner.real_name] has arrived as the Training Officer. All interns are to report to them."))

/datum/outfit/job/agent/training_officer
	name = "Training Officer"
	jobtype = /datum/job/agent/training_officer
	head = /obj/item/clothing/head/beret/tegu/lobotomy/training
	ears = /obj/item/radio/headset/heads/manager/alt
	l_pocket = /obj/item/commandprojector
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	suit = /obj/item/clothing/suit/armor/training
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)

	backpack_contents = list(
		/obj/item/melee/classic_baton,
		/obj/item/info_printer,
		/obj/item/announcementmaker/lcorp,
		/obj/item/suppressionupdate/training_officer,
		/obj/item/sensor_device,
	)

	//Training Stat update
/obj/item/suppressionupdate/training_officer
	name = "training stat equalizer"
	desc = "A localized source of stats, only usable by the Training Officers to equalize the stats of them and any interns."
	icon_state = "records_stats"
	allowedroles = list("Records Agent")

/obj/item/suppressionupdate/training_officer/attack_self(mob/living/carbon/human/user)
	if(!LAZYLEN(allowedroles))
		if(!istype(user) || !(user?.mind?.assigned_role in allowedroles))
			to_chat(user, span_notice("The Gadget's light flashes red. You aren't a Training Officer. Check the label before use."))
			return
	update_stats(user)

/obj/item/suppressionupdate/training_officer/attack(mob/living/M, mob/user)
	if(!istype(user) || !(user?.mind?.assigned_role in allowedroles))
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't a Training Officer. Check the label before use."))
		return
	update_stats(M)
