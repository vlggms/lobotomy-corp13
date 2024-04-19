/datum/job/suppression
	title = "Emergency Response Agent"
	department_head = list("Manager", "Disciplinary Officer")
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the Manager and the Disciplinary Officer"
	selection_color = "#ccaaaa"
	exp_requirements = 3000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/suppression
	display_order = JOB_DISPLAY_ORDER_SUPPRESSION

	access = list() // LC13:To-Do
	minimal_access = list()

	allow_bureaucratic_error = FALSE

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)

	job_important = "You are an L-Corp Emergency Response Agent. Your job is to suppress Abnormalities. You cannot work. Use :h to talk on your departmental radio."
	job_abbreviation = "ERA"

	var/normal_attribute_level = 20 // Scales with round time & facility upgrades

/datum/job/suppression/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)

	//Blatant Copypasta. pls fix
	var/set_attribute = normal_attribute_level

	// Variables from abno queue subsystem
	var/spawned_abnos = SSabnormality_queue.spawned_abnos
	var/rooms_start = SSabnormality_queue.rooms_start

	if(spawned_abnos > rooms_start * 0.95) // Full facility!
		set_attribute *= 4
	else if(spawned_abnos > rooms_start * 0.7) // ALEPHs around here
		set_attribute *= 3
	else if(spawned_abnos > rooms_start * 0.5) // WAWs and others
		set_attribute *= 2.5
	else if(spawned_abnos > rooms_start * 0.35) // HEs
		set_attribute *= 2
	else if(spawned_abnos > rooms_start * 0.2) // Shouldn't be anything more than TETHs
		set_attribute *= 1.5

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)*2 	//Get double stats because this is all they get.

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	return ..()


/datum/outfit/job/suppression
	name = "Emergency Response Agent"
	jobtype = /datum/job/suppression

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_discipline
	accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(
		/obj/item/melee/classic_baton=1,
		/obj/item/suppressionupdate = 1,
	)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)

// Suppression Officer
/datum/job/suppression/captain
	title = "Disciplinary Officer"
	selection_color = "#ccccff"
	total_positions = 0
	spawn_positions = 0
	outfit = /datum/outfit/job/suppression/captain
	display_order = JOB_DISPLAY_ORDER_COMMAND
	normal_attribute_level = 20

	access = list(ACCESS_COMMAND) // LC13:To-Do
	exp_requirements = 6000
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	mapexclude = list("wonderlabs", "mini")
	job_important = "You are the Disciplinary Officer. Lead the Emergency Response Agents and other Disciplinary staff into combat."

	job_abbreviation = "DO"

/datum/job/suppression/captain/after_spawn(mob/living/carbon/human/H, mob/M)
	. = ..()
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/suppression))
			processing.total_positions = 3
		if(istype(processing, /datum/job/suppression/captain))
			processing.total_positions = 1

/datum/outfit/job/suppression/captain
	name = "Disciplinary Officer"
	jobtype = /datum/job/suppression/captain
	head = /obj/item/clothing/head/hos/beret
	ears = /obj/item/radio/headset/heads/headset_discipline
	l_pocket = /obj/item/commandprojector
	suit = /obj/item/clothing/suit/armor/vest/alt
	backpack_contents = list(
		/obj/item/melee/classic_baton=1,
		/obj/item/announcementmaker/lcorp=1,
		/obj/item/suppressionupdate = 1,
		)


	//Stat update
/obj/item/suppressionupdate
	name = "stat equalizer"
	desc = "A localized source of stats, only usable by Emergency Response Agents and the Disciplinary Officer"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "canopic_jar"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	var/list/suppressionroles = list("Emergency Response Agent", "Disciplinary Officer")

/obj/item/suppressionupdate/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !(user?.mind?.assigned_role in suppressionroles))
		to_chat(user, span_notice("The Gadget's light flashes red. You aren't an ERA or Disciplinary Officer. Check the label before use."))
		return

	var/list/attribute_list = list(FORTITUDE_ATTRIBUTE, PRUDENCE_ATTRIBUTE, TEMPERANCE_ATTRIBUTE, JUSTICE_ATTRIBUTE)

	//I got lazy and this needs to be shipped out today
	var/set_attribute = 20

	// Variables from abno queue subsystem
	var/spawned_abnos = SSabnormality_queue.spawned_abnos
	var/rooms_start = SSabnormality_queue.rooms_start

	if(spawned_abnos > rooms_start * 0.95) // Full facility!
		set_attribute *= 4
	else if(spawned_abnos > rooms_start * 0.7) // ALEPHs around here
		set_attribute *= 3
	else if(spawned_abnos > rooms_start * 0.5) // WAWs and others
		set_attribute *= 2.5
	else if(spawned_abnos > rooms_start * 0.35) // HEs
		set_attribute *= 2
	else if(spawned_abnos > rooms_start * 0.2) // Shouldn't be anything more than TETHs
		set_attribute *= 1.5

	set_attribute += GetFacilityUpgradeValue(UPGRADE_AGENT_STATS)*2 	//Get double stats because this is all they get.

	//Set all stats to 0
	for(var/A in attribute_list)
		var/processing = get_attribute_level(user, A)
		user.adjust_attribute_level(A, -1*processing)

	//Now we have to bring it back up
	user.adjust_all_attribute_levels(set_attribute)
	to_chat(user, span_notice("You feel reset, and more ready for combat."))
