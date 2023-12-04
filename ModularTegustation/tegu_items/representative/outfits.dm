// THE WCORP STUFF
/obj/item/clothing/suit/armor/ego_gear/wcorp/ert
	equip_slowdown = 0
	attribute_requirements = list()

/datum/outfit/wcorp
	name = "W Corp L1"
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/wcorp
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/ego_hat/wcorp
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/ert
	belt = /obj/item/ego_weapon/city/charge/wcorp

/datum/outfit/wcorp/level2
	name = "W Corp L2"
	belt = null

/datum/outfit/wcorp/level2/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/belt = pick(/obj/item/ego_weapon/city/charge/wcorp/fist,
		/obj/item/ego_weapon/city/charge/wcorp/axe,
		/obj/item/ego_weapon/city/charge/wcorp/spear,
		/obj/item/ego_weapon/city/charge/wcorp/dagger)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

