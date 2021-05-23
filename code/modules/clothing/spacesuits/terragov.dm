// Armor borrowed from TGMC.
/obj/item/clothing/head/helmet/space/tgmc
	name = "marine assault helmet"
	icon_state = "tgmc"
	inhand_icon_state = "swat"
	desc = "A standard helmet worn by the marines of the Terran Government."
	armor = list(MELEE = 60, BULLET = 50, LASER = 40,ENERGY = 40, BOMB = 70, BIO = 40, RAD = 40, FIRE = 60, ACID = 80, WOUND = 10)

/obj/item/clothing/suit/space/tgmc
	name = "marine assault suit"
	icon_state = "tgmc"
	inhand_icon_state = "swat_suit"
	desc = "A heavy armor worn by the marines of the Terran Government."
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/gun, /obj/item/ammo_box, /obj/item/ammo_casing, /obj/item/tank/internals)
	armor = list(MELEE = 60, BULLET = 80, LASER = 40,ENERGY = 40, BOMB = 70, BIO = 40, RAD = 40, FIRE = 60, ACID = 80, WOUND = 10)
	cell = /obj/item/stock_parts/cell/hyper
