/datum/outfit/terragov
	name = "CityGov Official"
	var/jb_name = "CityGov Official"

	uniform = /obj/item/clothing/under/suit/black_really/citygov
	suit = /obj/item/clothing/suit/armor/bulletproof
	shoes = /obj/item/clothing/shoes/combat/merc
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	ears = /obj/item/radio/headset/headset_head/alt
	id = /obj/item/card/id/centcom

	accessory = /obj/item/clothing/accessory/armband/citygov
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1, \
		/obj/item/crowbar=1, \
		/obj/item/choice_beacon/terragov_sidearm)

/datum/outfit/terragov/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.access = get_all_centcom_access()
	W.access += ACCESS_WEAPONS
	W.assignment = jb_name
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/terragov/marine
	name = "CityGov Marine"
	jb_name = "CityGov Marine"
	uniform = /obj/item/clothing/under/mercenary/citygov
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses/thermal
	mask = /obj/item/clothing/mask/gas
	suit_store = /obj/item/gun/ballistic/automatic/t12
	back = /obj/item/storage/backpack/ert/security
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1, \
		/obj/item/crowbar/power, \
		/obj/item/ammo_box/magazine/t12, \
		/obj/item/ammo_box/magazine/t12, \
		/obj/item/ammo_box/magazine/t12, \
		/obj/item/choice_beacon/terragov_sidearm, \
		/obj/item/choice_beacon/terragov_specialist)

/datum/outfit/terragov/marine/armored
	name = "TerraGov Marine (Armored)"
	head = /obj/item/clothing/head/helmet/space/tgmc
	suit = /obj/item/clothing/suit/space/tgmc
	back = /obj/item/storage/backpack/ert/security
