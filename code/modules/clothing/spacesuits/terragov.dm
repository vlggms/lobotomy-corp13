// Armor borrowed from TGMC.
/obj/item/clothing/head/helmet/space/tgmc
	name = "marine assault helmet"
	desc = "A standard helmet worn by the marines of the Terran Government."
	icon_state = "tgmc"
	inhand_icon_state = "swat"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)

/obj/item/clothing/suit/space/tgmc
	name = "marine assault suit"
	desc = "A heavy armor worn by the marines of the Terran Government."
	icon_state = "tgmc"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/tank/internals)
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)
	cell = /obj/item/stock_parts/cell/hyper
