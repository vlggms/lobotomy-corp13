GLOBAL_LIST_INIT(captain_departments, list(
	"Control",
	"Information",
	"Training",
	"Safety",
	"Welfare",
	"Discipline",
	))


/datum/job/departmentcaptain
	title = "Department Captain"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the manager"
	selection_color = "#ccaaaa"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/departmentcaptain
	display_order = JOB_DISPLAY_ORDER_CAPTAIN

	access = list()
	minimal_access = list()
	departments = DEPARTMENT_SECURITY

	allow_bureaucratic_error = FALSE

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	maptype = "wonderlabs"
	var/normal_attribute_level = 20 // Scales with round time

/datum/job/departmentcaptain/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	var/set_attribute = normal_attribute_level
	if(world.time >= 75 MINUTES) // Full facility expected
		set_attribute *= 4
	else if(world.time >= 60 MINUTES) // More than one ALEPH
		set_attribute *= 3
	else if(world.time >= 45 MINUTES) // Wowzer, an ALEPH?
		set_attribute *= 2.5
	else if(world.time >= 30 MINUTES) // Expecting WAW
		set_attribute *= 2
	else if(world.time >= 15 MINUTES) // Usual time for HEs
		set_attribute *= 1.5

	for(var/A in roundstart_attributes)
		roundstart_attributes[A] = round(set_attribute)

	if(!LAZYLEN(GLOB.captain_departments))
		return

	// Assign department security
	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_agent_department
	var/ears = null
	var/accessory = null
	if(!(department in GLOB.captain_departments))
		department = pick(GLOB.captain_departments)

	GLOB.captain_departments-=department

	switch(department)
		if("Control")
			ears = /obj/item/radio/headset/headset_control
			accessory = /obj/item/clothing/accessory/armband/lobotomy

		if("Information")
			ears = /obj/item/radio/headset/headset_information
			accessory = /obj/item/clothing/accessory/armband/lobotomy/info

		if("Safety")
			ears = /obj/item/radio/headset/headset_safety
			accessory = /obj/item/clothing/accessory/armband/lobotomy/safety

		if("Disciplinary")
			ears = /obj/item/radio/headset/headset_discipline
			accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline

		if("Welfare")
			ears = /obj/item/radio/headset/headset_welfare
			accessory = /obj/item/clothing/accessory/armband/lobotomy/welfare

		if("Training")
			ears = /obj/item/radio/headset/headset_training
			accessory = /obj/item/clothing/accessory/armband/lobotomy/training

		else	//Something went wrong.
			ears = /obj/item/radio/headset/heads


	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)

	if(H.mind.assigned_role == "Department Captain")
		if(ears)
			if(H.ears)
				qdel(H.ears)
			H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)

	if(department != "None" && department)
		to_chat(M, "<b>You are now the captain of [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department, and are a replacement department captain.</b>")
	return ..()


/datum/outfit/job/departmentcaptain
	name = "Department Captain"
	jobtype = /datum/job/departmentcaptain

	head = /obj/item/clothing/head/beret/sec/navyofficer
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
