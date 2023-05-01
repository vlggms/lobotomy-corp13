GLOBAL_LIST_INIT(sinner_weapons, list(
	/obj/item/ego_weapon/mini/hayong,
	/obj/item/ego_weapon/shield/walpurgisnacht,
	/obj/item/ego_weapon/lance/suenoimpossible,
	/obj/item/ego_weapon/shield/sangria,
	/obj/item/ego_weapon/mini/soleil,
	/obj/item/ego_weapon/taixuhuanjing,
	/obj/item/ego_weapon/revenge,
	/obj/item/ego_weapon/mini/hearse,
	/obj/item/ego_weapon/raskolot,
	/obj/item/ego_weapon/vogel,
	/obj/item/ego_weapon/nobody,
	/obj/item/ego_weapon/ungezifer,
	))

/datum/job/sinner
	title = "LCB Sinner"
	faction = "Station"
	total_positions = 10
	spawn_positions = 10
	selection_color = "#ccaaaa"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sinner
	display_order = JOB_DISPLAY_ORDER_CLERK
	maptype = "limbus"

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

	job_important = "You are apart of LCB. Follow the Executive Manager and Assistant Managers."

/datum/job/sinner/after_spawn(mob/living/carbon/human/H, mob/M)
	..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

	//Pick uniform, Suit and Weapon, and remove weapon from the global list.
//	var/uniform = pick(/obj/item/clothing/under/limbus/shirt, /obj/item/clothing/under/limbus/prison)
	var/suit = pick(/obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat, /obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat_short)
	var/weapon = pick(GLOB.sinner_weapons)
	GLOB.sinner_weapons -= weapon

//	H.equip_to_slot_or_del(new uniform(H),ITEM_SLOT_ICLOTHING)
	H.equip_to_slot_or_del(new suit(H),ITEM_SLOT_OCLOTHING)
	H.equip_to_slot_or_del(new weapon(H),ITEM_SLOT_SUITSTORE)

	//This weapon is special.
	if(weapon == /obj/item/ego_weapon/mini/hearse)
		H.equip_to_slot_or_del(new /obj/item/ego_weapon/shield/hearse(H),ITEM_SLOT_BELT)

	var/obj/item/clothing/under/U = H.w_uniform
	U.attach_accessory(new /obj/item/clothing/accessory/limbusvest)

/datum/outfit/job/sinner
	name = "LCB Sinner"
	jobtype = /datum/job/sinner
	uniform = /obj/item/clothing/under/limbus/shirt	//Chosen later
	belt = null
	neck = /obj/item/clothing/neck/limbus_tie
	l_pocket = /obj/item/flashlight/seclite


//Assistant manager
/datum/job/sinner/amanager
	title = "LCB Assistant Manager"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#BB9999"
	outfit = /datum/outfit/job/sinner/amanager
	display_order = JOB_DISPLAY_ORDER_AGENT

	job_important = "You are an LCB assistant manager. Follow the Executive Manager, and lead the Sinners into battle!"

/datum/outfit/job/sinner/amanager
	name = "LCB Assistant Manager"
	jobtype = /datum/job/sinner/amanager
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
	ears = /obj/item/radio/headset/heads


//Executive Manager
/datum/job/exec_manager
	title = "LCB Executive Manager"
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#BB9999"
	outfit = /datum/outfit/job/lcbmanager
	access = list(ACCESS_COMMAND, ACCESS_MANAGER)
	display_order = JOB_DISPLAY_ORDER_MANAGER
	trusted_only = TRUE
	maptype = "limbus"

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

	job_important = "You are the LCB Executive Manager. You are the medic of the LCB team, and follow from behind the LCB crew. Keep yourself safe!"

/datum/outfit/job/lcbmanager
	name = "LCB Executive Manager"
	jobtype = /datum/job/exec_manager
	uniform = /obj/item/clothing/under/limbus/shirt
	belt = null
	neck = /obj/item/clothing/neck/limbus_tie
	suit = /obj/item/clothing/suit/armor/ego_gear/limbus/durante/lcb
	ears = /obj/item/radio/headset/heads
	implants = list(/obj/item/organ/cyberimp/eyes/hud/medical)
	l_pocket = /obj/item/gun/magic/wand/resurrection
