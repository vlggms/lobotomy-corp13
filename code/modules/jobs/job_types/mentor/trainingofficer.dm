// Training Officer
/datum/job/agent/training_officer
	title = "Training Officer"
	selection_color = "#e09660"
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/agent/training_officer
	display_order = JOB_DISPLAY_ORDER_COMMAND

	access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND
	exp_requirements = 0
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	job_important = "You are a Training Officer. Your primary goal is to assist interns and clerks in learning. You are not here to win, but to teach."
	job_notice = "Abandoning your duties, or abusing your tools will result in a report to the admin team."

	job_abbreviation = "TO"
	mentor_only = TRUE
	alt_titles = list()

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
		/obj/item/stat_equalizer,
		/obj/item/sensor_device,
	)

	//Training Stat update
/obj/item/stat_equalizer
	name = "training stat equalizer"
	desc = "A localized source of stats, only usable by the Training Officers to equalize the stats of them and any interns."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "records_stats"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS

/obj/item/stat_equalizer/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || user?.mind?.assigned_role != "Training Officer")
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't a Training Officer. Check the label before use."))
		return
	update_stats(user)

/obj/item/stat_equalizer/attack(mob/living/M, mob/user)
	if(!istype(user) || user?.mind?.assigned_role != "Training Officer")
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't a Training Officer. Check the label before use."))
		return
	update_stats(M)

/obj/item/stat_equalizer/proc/update_stats(mob/living/carbon/human/user)
	var/list/attribute_list = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)

	//I got lazy and this needs to be shipped out today
	var/set_attribute = 20
	var/facility_full_percentage = 0
	if(SSabnormality_queue.spawned_abnos) // dont divide by 0
		facility_full_percentage = 100 * (SSabnormality_queue.spawned_abnos / SSabnormality_queue.rooms_start)
	// how full the facility is, from 0 abnormalities out of 24 cells being 0% and 24/24 cells being 100%
	switch(facility_full_percentage)
		if(15 to 29) // Shouldn't be anything more than TETHs (4 Abnormalities)
			set_attribute *= 1.5

		if(29 to 44) // HEs (8 Abnormalities)
			set_attribute *= 2

		if(44 to 59) // A bit before WAWs (11 Abnormalities)
			set_attribute *= 2.5

		if(59 to 69) // WAWs around here (15 Abnormalities)
			set_attribute *= 3

		if(69 to 79) // ALEPHs starting to spawn (17 Abnormalities)
			set_attribute *= 3.5

		if(79 to 100) // ALEPHs around here (20 Abnormalities)
			set_attribute *= 4

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)

	//Set all stats to 0
	for(var/A in attribute_list)
		var/processing = get_attribute_level(user, A)
		user.adjust_attribute_level(A, -1*processing)

	//Now we have to bring it back up
	user.adjust_all_attribute_levels(set_attribute)
	to_chat(user, span_notice("You feel reset, and more ready for combat."))
