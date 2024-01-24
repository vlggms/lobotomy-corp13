// THE WCORP STUFF
/obj/item/clothing/suit/armor/ego_gear/wcorp/ert
	equip_slowdown = 0
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/wcorp/ert/kill
	desc = "A light armor vest worn by W corp L3 Cleanup Staff. It's light as a feather."
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 50)

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
	var/belt = pick(
		/obj/item/ego_weapon/city/charge/wcorp/fist,
		/obj/item/ego_weapon/city/charge/wcorp/axe,
		/obj/item/ego_weapon/city/charge/wcorp/spear,
		/obj/item/ego_weapon/city/charge/wcorp/dagger,
	)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

/datum/outfit/wcorp/level3
	name = "W Corp L3"
	belt = null
	suit = /obj/item/clothing/suit/armor/ego_gear/wcorp/ert/kill
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/hud/health/night
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/salacid
	r_pocket = /obj/item/reagent_containers/hypospray/medipen/mental

/datum/outfit/wcorp/level3/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/belt = pick(/obj/item/ego_weapon/city/charge/wcorp/fist,
		/obj/item/ego_weapon/city/charge/wcorp/axe,
		/obj/item/ego_weapon/city/charge/wcorp/spear,
		/obj/item/ego_weapon/city/charge/wcorp/dagger,
		/obj/item/ego_weapon/city/charge/wcorp/hatchet,
		/obj/item/ego_weapon/city/charge/wcorp/hammer,
		/obj/item/ego_weapon/city/charge/wcorp/shield,
		/obj/item/ego_weapon/city/charge/wcorp/shield/spear,
		/obj/item/ego_weapon/city/charge/wcorp/shield/club,
		/obj/item/ego_weapon/city/charge/wcorp/shield/axe)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

// KCORP BABEYYYY

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1/ert
	equip_slowdown = 0
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3/ert
	equip_slowdown = 0
	attribute_requirements = list()

/datum/outfit/kcorp
	name = "K Corp Class 1"
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/rank/k_corporation/officer/duty
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	suit = /obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1/ert
	suit_store = /obj/item/ego_weapon/shield/kcorp
	id = /obj/item/card/id

/datum/outfit/kcorp/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/head = pick(
		/obj/item/clothing/head/ego_hat/helmet/kcorp,
		/obj/item/clothing/head/ego_hat/helmet/kcorp/visor,
	)
	var/belt = pick(
		/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/city/kcorp/axe,
	)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)
	H.equip_to_slot_or_del(new head(H),ITEM_SLOT_HEAD, TRUE)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Class 1"
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/kcorp/level3
	name = "K Corp Class 3"
	suit = /obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3/ert

/datum/outfit/kcorp/level3/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/belt = pick(
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
	)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Class 3"
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/kcorp/level3/kill
	name = "K Corp Asset Protection Staff"
	r_hand = /obj/item/grenade/spawnergrenade/kcorpdrone
	l_pocket = /obj/item/ksyringe
	r_pocket = /obj/item/krevive

/datum/outfit/kcorp/level3/kill/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/belt = pick(
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
	)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Asset Protection Staff"
	W.registered_name = H.real_name
	W.update_label()
