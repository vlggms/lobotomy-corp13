// HE Armor should be kept at ~75 total armor. Or about 80 in this case
/obj/item/clothing/suit/armor/ego_gear/limbus
	icon = 'icons/obj/clothing/ego_gear/limbus_suits.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/limbus_suit.dmi'
	equip_slowdown = 0

/obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat
	name = "LCB armored coat"
	desc = "It says Limbus Company on the tag."
	icon_state = "longcoat"
	flags_inv = NONE
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

/obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat_short
	name = "LCB armored shortcoat"
	desc = "It says Limbus Company on the tag."
	icon_state = "shortcoat"
	flags_inv = NONE
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

// WAW Armor should be kept at ~140 total armor. Or about 160 in this case
/obj/item/clothing/suit/armor/ego_gear/limbus/durante
	name = "Durante"
	desc = "Follow your star."
	icon_state = "durante"
	flags_inv = NONE
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 40)
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/limbus/durante/lcb
	attribute_requirements = list()

