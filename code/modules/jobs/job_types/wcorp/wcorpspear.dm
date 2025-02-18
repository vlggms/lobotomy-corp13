GLOBAL_LIST_INIT(l2dsquads, list("Axe", "Buckler", "Cleaver"))

//we all know we're only adding these because kirie is a massive hong lu simp
/datum/job/wcorpl2spear
	title = "W-Corp L2 Type D Spear Agent"
	faction = "Station"
	department_head = list("W-Corp L3 Cleanup Captain, W-Corp Representative")
	total_positions = 3
	spawn_positions = 3
	supervisors = "Your assigned W-Corp L3 Agent and the W-Corp Representative"
	selection_color = "#1b7ced"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	maptype = "wcorp"

	outfit = /datum/outfit/job/wcorpl2spear
	display_order = 4.9

	access = list() //add accesses as necessary
	minimal_access = list()
	departments = DEPARTMENT_W_CORP

	roundstart_attributes = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80
	)
	rank_title = "L2-D"
	job_important = "You take the role of backline support."
	job_notice = "You are a agent armed with a w-corp spear. Support your squadron with your equipment."

/datum/job/wcorpl2spear/after_spawn(mob/living/carbon/human/outfit_owner, mob/M)
	ADD_TRAIT(outfit_owner, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	var/squad = pick_n_take(GLOB.l2dsquads)
	. = ..()
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



/datum/outfit/job/wcorpl2spear
	name = "W-Corp L2 Type D Spear Agent"
	jobtype = /datum/job/wcorpl2spear

	ears = /obj/item/radio/headset/headset_welfare
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	belt = /obj/item/ego_weapon/city/wcorp/spear
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/ego_hat/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	l_pocket = /obj/item/flashlight/seclite

	backpack_contents = list(/obj/item/storage/box/pcorp)
