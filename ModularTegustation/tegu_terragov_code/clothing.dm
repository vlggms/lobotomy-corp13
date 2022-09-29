// Officials
/obj/item/clothing/under/suit/black_really/terragov
	name = "armored executive suit"
	desc = "A formal black suit made out of protective material. Used by non-military personnel of terran government."
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 10)

// Marines
/obj/item/clothing/under/mercenary/terragov
	name = "marine camo uniform"
	desc = "A camouflage jumpsuit worn by marines of the city government."
	icon_state = "camo_tgmc"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 10)
	can_adjust = FALSE

// Other stuff
/obj/item/clothing/head/helmet/swat/un
	name = "peacekeeper helmet"
	desc = "A blue helmet that was once used by the old world government."
	icon_state = "antichristhelm"

/obj/item/clothing/glasses/hud/security/sunglasses/thermal
	name = "protective thermal glasses"
	desc = "Sunglasses with a security HUD and thermal view mode built in."
	icon_state = "sunhudsec"
	vision_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/red

// Armbands
/obj/item/clothing/accessory/armband/terragov
	name = "\improper CityGov armband"
	desc = "An armband usually worn by city government officials."
	icon_state = "terraband"

/obj/item/clothing/accessory/armband/terragov/un
	name = "\improper UN armband"
	desc = "A light-blue armband that was worn by the old world government. Some say humanity once lived beyond the city."
	icon_state = "tgunband"

/obj/item/clothing/accessory/armband/russian
	name = "russian armband"
	desc = "An armband that is worn by nostalgic district residents, who ramble about a long dead civilization."
	icon_state = "rusband"
