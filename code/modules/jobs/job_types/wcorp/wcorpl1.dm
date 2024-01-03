//These are the chaff of W-Corp. Like Rabbits, but cooler looking. - Angela
/datum/job/wcorpl1
	title = "W-Corp L1 Cleanup Agent"
	faction = "Station"
	department_head = list("W-Corp L3 Cleanup Captain, W-Corp Representative")
	total_positions = -1 //18
	spawn_positions = -1 //10
	supervisors = "Your assigned W-Corp L3 Agent and the W-Corp Representative"
	selection_color = "#1b7ced"

	outfit = /datum/outfit/job/wcorpl1
	display_order = 5
	maptype = "wcorp"

	//yes i have been so distant consistently indifferent
	access = list() //add accesses as necessary
	minimal_access = list()

	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
	)
	rank_title = "L1"
	job_important = "You take the role of frontline infantry."
	job_notice = "You are a agent armed with a w-corp baton with charge capabilities. You form the first line of offense during cleanup operations."

/datum/job/wcorpl1/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	//Squad assignmnet
	var/chosensquad = pick("Axe", "Buckler", "Cleaver")
	.=..()
	var/ears = null
	to_chat(M, "<span class='userdanger'>You have been assigned to the [chosensquad] squad. </span>")
	switch(chosensquad)
		if("Axe")
			ears = /obj/item/radio/headset/wcorp/safety
		if("Buckler")
			ears = /obj/item/radio/headset/wcorp/discipline
		if("Cleaver")
			ears = /obj/item/radio/headset/wcorp/welfare
	if(ears)
		if(H.ears)
			qdel(H.ears)
		H.equip_to_slot_or_del(new ears(H),ITEM_SLOT_EARS)


/datum/outfit/job/wcorpl1
	name = "W-Corp L1 Agent"
	jobtype = /datum/job/wcorpl1

	ears = null
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	belt = /obj/item/ego_weapon/city/charge/wcorp
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/ego_hat/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	l_pocket = /obj/item/flashlight/seclite
	backpack_contents = list(/obj/item/storage/box/pcorp)
