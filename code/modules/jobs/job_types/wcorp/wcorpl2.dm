GLOBAL_LIST_INIT(l2csquads, list("Axe", "Buckler", "Cleaver", "Axe", "Buckler", "Cleaver"))	//There's two per squad

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
	display_order = 4.5

	access = list() //add accesses as necessary
	minimal_access = list()
	departments = DEPARTMENT_W_CORP

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)
	rank_title = "L2-C"
	job_important = "You take the role of frontline infantry."
	job_notice = "You are a agent armed with a specialized w-corp weapon, as well as heavier armor. Support your squadron with your equipment."

/datum/job/wcorpl2/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	var/squad = pick_n_take(GLOB.l2csquads)
	.=..()
	var/ears = null
	to_chat(M, span_userdanger("You have been assigned to the [squad] squad."))
	switch(squad)
		if("Axe")
			ears = /obj/item/radio/headset/wcorp/safety
		if("Buckler")
			ears = /obj/item/radio/headset/wcorp/discipline
		if("Cleaver")
			ears = /obj/item/radio/headset/wcorp/welfare
	if(ears)
		if(outfit_owner.ears)
			qdel(outfit_owner.ears)
		outfit_owner.equip_to_slot_or_del(new ears(outfit_owner),ITEM_SLOT_EARS)


//Outfits
/datum/outfit/job/wcorpl2
	name = "W-Corp L2 Type C Weapon Specialist"
	jobtype = /datum/job/wcorpl2

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	belt = null
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/ego_hat/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	l_pocket = /obj/item/flashlight/seclite

	backpack_contents = list(/obj/item/storage/box/pcorp)

/datum/outfit/job/wcorpl2/post_equip(mob/living/carbon/human/outfit_owner, visualsOnly = FALSE)
	..()
	var/belt = pick(
		/obj/item/ego_weapon/city/wcorp/fist,
		/obj/item/ego_weapon/city/wcorp/axe,
		/obj/item/ego_weapon/city/wcorp/dagger,
		/obj/item/ego_weapon/city/wcorp/hatchet,
		/obj/item/ego_weapon/city/wcorp/hammer,
	)
	outfit_owner.equip_to_slot_or_del(new belt(outfit_owner),ITEM_SLOT_BELT, TRUE)
