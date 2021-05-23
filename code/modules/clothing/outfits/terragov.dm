/datum/outfit/terragov
	name = "TerraGov Official"

	uniform = /obj/item/clothing/under/suit/black_really
	suit = /obj/item/clothing/suit/armor/bulletproof
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/combat/swat
	gloves = /obj/item/clothing/gloves/combat
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	ears = /obj/item/radio/headset/terragov/alt
	id = /obj/item/card/id/centcom

/datum/outfit/terragov/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.access = get_all_centcom_access()
	W.access += ACCESS_WEAPONS
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/terragov/marine
	name = "TerraGov Marine"
	uniform = /obj/item/clothing/under/syndicate/tgmc
	suit = /obj/item/clothing/suit/space/tgmc
	back = /obj/item/storage/backpack/ert/security
	head = /obj/item/clothing/head/helmet/space/tgmc
	mask = /obj/item/clothing/mask/gas
