//These are the captains for W-Corp. - Angela
/datum/job/wcorpl3
	title = "W-Corp L3 Squad Captain"
	faction = "Station"
	department_head = list("W-Corp Representative")
	total_positions = 3
	spawn_positions = 3
	supervisors = "The W-Corp Representative"
	selection_color = "#3434b3"
	exp_requirements = 240
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SECURITY
	maptype = "wcorp"

	outfit = /datum/outfit/job/wcorpl3
	display_order = 2


	access = list() //add accesses as necessary
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
	)
	rank_title = "L3 CPT"
	job_important = "You are a Captain of W-Corp's frontline infantry."
	job_notice = "You are an agent deigned to lead one of three squadrons during the clean-up opeartion. Serve W-Corp's best interests and carry your squadron to victory."

//no fear!!!
/datum/job/wcorpl3/after_spawn(mob/living/carbon/human/H, mob/M)
	.=..()
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/datum/outfit/job/wcorpl3
	name = "W-Corp L3 Cleanup Captain"
	jobtype = /datum/job/wcorpl3

	ears = /obj/item/radio/headset/heads/manager/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp //wonder how we differentiate these guys gonna figure it out later
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	l_pocket = /obj/item/commandprojector
	r_pocket = /obj/item/flashlight/seclite

/datum/outfit/job/wcorpl3/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	var/belt = pick(/obj/item/ego_weapon/city/wcorp/fist,
		/obj/item/ego_weapon/city/wcorp/axe,
		/obj/item/ego_weapon/city/wcorp/spear,
		/obj/item/ego_weapon/city/wcorp/dagger,
		/obj/item/ego_weapon/city/wcorp/hatchet,
		/obj/item/ego_weapon/city/wcorp/hammer)
	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)
