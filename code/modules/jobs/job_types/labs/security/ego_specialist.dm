/datum/job/ego_specialist
	title = "EGO Specialist"
	faction = "Station"
	supervisors = "High Security Commander"
	total_positions = 1
	spawn_positions = 1
	exp_requirements = 0
	selection_color = "#cf5979"
	access = list(ACCESS_ARMORY)			//See /datum/job/assistant/get_access()
	minimal_access = list(ACCESS_ARMORY)	//See /datum/job/assistant/get_access()

	outfit = /datum/outfit/job/ego_specialist
	display_order = 9.4

	job_important = "You are a High Security Officer, hired by LCB. Your job to ensure the safety of the researchers of the High Security Zone. Deal with any hazards that occur with the zone, and attempt to coerce abnormalities to stay. If you are unable to keep the abnormalities to stay through coersion, suppress them. \
		As the EGO specialist, you have a special job to assist in suppression. You should have knowledge of all damage types, and are equipped to learn these weaknesses."

	alt_titles = list()
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 40,
								PRUDENCE_ATTRIBUTE = 40,
								TEMPERANCE_ATTRIBUTE = 40,
								JUSTICE_ATTRIBUTE = 40
								)
	loadalways = FALSE
	maptype = "limbus_labs"
	rank_title = "MZO"
	job_abbreviation = "EGS"


/datum/job/ego_specialist/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = FALSE)
	..()
	H.set_attribute_limit(40)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

	var/ego_set = pick("No Cry", "Shy", "Noise", "Blossoms")
	var/ego_armor
	var/ego_weapon

	switch(ego_set)
		if("No Cry")
			ego_armor = /obj/item/clothing/suit/armor/ego_gear/teth/red_sheet
			ego_weapon = /obj/item/ego_weapon/red_sheet
		if("Shy")
			ego_armor = /obj/item/clothing/suit/armor/ego_gear/teth/shy
			ego_weapon = /obj/item/gun/ego_gun/pistol/shy
		if("Noise")
			ego_armor = /obj/item/clothing/suit/armor/ego_gear/teth/noise
			ego_weapon = /obj/item/gun/ego_gun/noise
		if("Blossoms")
			ego_armor = /obj/item/clothing/suit/armor/ego_gear/teth/blossoms
			ego_weapon = /obj/item/ego_weapon/mini/blossom


	H.equip_to_slot_or_del(new ego_armor(H),ITEM_SLOT_HANDS)
	H.equip_to_slot_or_del(new ego_weapon(H),ITEM_SLOT_HANDS)


/datum/outfit/job/ego_specialist
	name = "EGO Specialist"
	jobtype = /datum/job/ego_specialist

	head = /obj/item/clothing/head/beret/sec
	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/headset_discipline
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/limbus/highsec
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	l_pocket = /obj/item/radio

	backpack_contents = list(
		/obj/item/deepscanner,
		)
