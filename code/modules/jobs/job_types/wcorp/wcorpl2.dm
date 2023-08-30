//These are proper agents for W-Corp, and not the chaff you're familiar with. - Angela
/datum/job/wcorpl2
    title = "W-Corp L2 Type C Weapon Specialist"
	faction = "Station"
	department_head = list("W-Corp L3 Cleanup Captain, W-Corp Representative")
	total_positions = 6
	spawn_positions = 6
	supervisors = "Your assigned W-Corp L3 Agent and the W-Corp Representative"
	selection_color = "#1b7ced"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "wcorp"

	outfit = /datum/outfit/job/wcorpl2
	display_order = 3


	access = list() //add accesses as necessary
	minimal_access = list()

	roundstart_attributes = list(
		                        FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
	                            )
	rank_title = "L2-C Specialist"
	job_important = "You take the role of frontline infantry."
	job_notice = "You are a agent armed with a specialized w-corp weapon, as well as heavier armor. Support your squadron with your equipment."

//we all know we're only adding these because kirie is a massive hong lu simp
/datum/job/wcorpl2/support
    title = "W-Corp L2 Type B Support Agent"
	faction = "Station"
	department_head = list("W-Corp L3 Cleanup Captain, W-Corp Representative")
	total_positions = 3
	spawn_positions = 3
	supervisors = "Your assigned W-Corp L3 Agent and the W-Corp Representative"
	selection_color = "#1b7ced"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "wcorp"

	outfit = /datum/outfit/job/wcorpl2/support
	display order = 4
	access = list()
	minimal_access = list()

	roundstart_attributes = list(
		                        FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
	                            )
	rank_title = "L2-B Specialist"
	job_important = "You take the role of backline support."
	job_notice = "You are a agent armed with a specialized w-corp weapon that mends the wounds of your allies when fully charged. Support your squadron with your equipment."


/datum/outfit/job/wcorpl2
    name = "W-Corp L2 Type C Weapon Specialist"
	jobtype = /datum/job/wcorpl2

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	belt = /obj/item/ego_weapon/city/wcorp
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp
	suit_store = /obj/item/ego_weapon/city/wcorp_axe //need to change this/make it randomize between the type C weapons
	l_pocket = /obj/item/flashlight/seclite


/datum/outfit/job/wcorpl2/support
    name = "W-Corp L2 Type B Support Agent"
	jobtype = /datum/job/wcorpl2/support

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	belt = /obj/item/ego_weapon/city/wcorp
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp
	suit_store = /obj/item/ego_weapon/city/wcorp_spear //same as before but with the type B weapons after they're added
	l_pocket = /obj/item/flashlight/seclite
