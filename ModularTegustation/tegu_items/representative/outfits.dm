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

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1/ert
	equip_slowdown = 0
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3/ert
	equip_slowdown = 0
	attribute_requirements = list()

// KCORP BABEYYYY
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
	var/head = pick(/obj/item/clothing/head/ego_hat/helmet/kcorp,
		/obj/item/clothing/head/ego_hat/helmet/kcorp/visor)
	var/belt = pick(/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/city/kcorp/axe)

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
	var/belt = pick(/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear)

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
	var/belt = pick(/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Asset Protection Staff"
	W.registered_name = H.real_name
	W.update_label()

//S Corp Stuff
/obj/item/clothing/suit/armor/ego_gear/zayin/soda/ert
	equip_slowdown = 0
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)

/datum/outfit/scorp
	name = "Liquidation Team Intern"
	ears = /obj/item/radio/headset/headset_cent
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	suit = /obj/item/clothing/suit/armor/ego_gear/zayin/soda
	l_pocket = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red
	r_pocket = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white
	id = /obj/item/card/id

/datum/outfit/scorp/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return
	H.set_species(/datum/species/shrimp)
	var/belt = pick(/obj/item/gun/ego_gun/sodashotty,
		/obj/item/gun/ego_gun/sodarifle,
		/obj/item/gun/ego_gun/sodasmg,
		/obj/item/gun/ego_gun/shrimp/assault)

	H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Liquidation Intern"
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/scorp/heavyweapons
	name = "Liquidation Team Gunner"
	suit = /obj/item/clothing/suit/armor/ego_gear/zayin/soda/ert
	l_pocket = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	r_pocket = /obj/item/grenade/spawnergrenade/shrimp
	belt = /obj/item/gun/ego_gun/shrimp/minigun

/datum/outfit/scorp/heavyweapons/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return
	H.set_species(/datum/species/shrimp)

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Liquidation Gunner"
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/scorp/heavyweapons/termination
	name = "Liquidation Team Exterminator"
	suit = /obj/item/clothing/suit/armor/ego_gear/realization/wellcheers
	r_pocket = /obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple
	back = /obj/item/storage/backpack/ert/security
	backpack_contents = list(/obj/item/melee/classic_baton/telescopic=1,
		/obj/item/grenade/spawnergrenade/shrimp/hostile=2,
		/obj/item/storage/box/survival/engineer=1)

/datum/outfit/scorp/heavyweapons/termination/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return
	H.set_species(/datum/species/shrimp)