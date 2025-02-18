GLOBAL_LIST_INIT(head_departments, list(
	"Control",
	"Information",
	"Training",
	"Safety",
	"Welfare",
	"Discipline",
	))


/datum/job/departmenthead
	title = "Department Head"
	department_head = list("Manager")
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the manager"
	selection_color = "#ccccff"
	exp_requirements = 360
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/departmenthead
	display_order = JOB_DISPLAY_ORDER_DEPARTMENTHEAD

	access = list(ACCESS_COMMAND)
	minimal_access = list(ACCESS_COMMAND)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_SECURITY

	allow_bureaucratic_error = FALSE

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 20,
								PRUDENCE_ATTRIBUTE = 20,
								TEMPERANCE_ATTRIBUTE = 20,
								JUSTICE_ATTRIBUTE = 20
								)
	maptype = "wonderlabs"
	var/normal_attribute_level = 20 // Scales with round time

/datum/job/departmenthead/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
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


	//Department stuff
	if(!LAZYLEN(GLOB.head_departments))
		return

	var/department
	if(M && M.client && M.client.prefs)
		department = M.client.prefs.prefered_agent_department
	var/ears = null
	var/accessory = null
	var/head = null

	if(!(department in GLOB.head_departments))
		department = pick(GLOB.head_departments)

	GLOB.head_departments-=department

	switch(department)
		if("Control")
			ears = /obj/item/radio/headset/heads/headset_control
			accessory = /obj/item/clothing/accessory/armband/lobotomy
			head = /obj/item/clothing/head/beret/tegu/lobotomy/control

		if("Information")
			ears = /obj/item/radio/headset/heads/headset_information
			accessory = /obj/item/clothing/accessory/armband/lobotomy/info
			head = /obj/item/clothing/head/beret/tegu/lobotomy/information

		if("Safety")
			ears = /obj/item/radio/headset/heads/headset_safety
			accessory = /obj/item/clothing/accessory/armband/lobotomy/safety
			head = /obj/item/clothing/head/beret/tegu/lobotomy/safety

		if("Disciplinary")
			ears = /obj/item/radio/headset/heads/headset_discipline
			accessory = /obj/item/clothing/accessory/armband/lobotomy/discipline
			head = /obj/item/clothing/head/beret/tegu/lobotomy/discipline

		if("Welfare")
			ears = /obj/item/radio/headset/heads/headset_welfare
			accessory = /obj/item/clothing/accessory/armband/lobotomy/welfare
			head = /obj/item/clothing/head/beret/tegu/lobotomy/welfare

		if("Training")
			ears = /obj/item/radio/headset/heads/headset_training
			accessory = /obj/item/clothing/accessory/armband/lobotomy/training
			head = /obj/item/clothing/head/beret/tegu/lobotomy/training

		else	//You latejoined.
			ears = /obj/item/radio/headset/heads


	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		U.attach_accessory(new accessory)

	if(H.mind.assigned_role == "Department Head")
		if(head)
			if(H.head)
				qdel(H.head)
			H.equip_to_slot_or_del(new head(H),ITEM_SLOT_HEAD)

		if(ears)
			if(H.ears)
				qdel(H.ears)
			H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)

	if(department != "None" && department)
		to_chat(M, "<b>You are now the head of [department]!</b>")
	else
		to_chat(M, "<b>You have not been assigned to any department, and are a replacement department head.</b>")

	return ..()


/datum/outfit/job/departmenthead
	name = "Department Head"
	jobtype = /datum/job/departmenthead

	head = /obj/item/clothing/head/hos/beret
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy
	backpack_contents = list(/obj/item/melee/classic_baton=1)
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
