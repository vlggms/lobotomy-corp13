/obj/item/radio/headset/terragov
	name = "\improper TerraGov Offical's headset"
	desc = "A TerraGov Official's headset."
	icon = 'ModularTegustation/Teguicons/radio.dmi'
	icon_state = "terragov_headset"
	keyslot = new /obj/item/encryptionkey/terragov

/obj/item/radio/headset/terragov/alt
	name = "\improper TerraGov Officer's bowman headset"
	desc = "A TerraGov Officer's headset. Protects ears from flashbangs."
	icon_state = "terragov_headset_alt"

/obj/item/radio/headset/terragov/alt/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
