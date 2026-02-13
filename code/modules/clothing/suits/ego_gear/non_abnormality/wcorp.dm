//Wcorp
/obj/item/clothing/suit/armor/ego_gear/city/wcorp
	name = "w corp armor vest"
	desc = "A light armor vest worn by W corp. It's light as a feather."
	icon_state = "w_corp"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 30)
	slowdown = -0.1
	flags_inv = null
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)

/obj/item/clothing/head/ego_hat/wcorp
	name = "w-corp cap"
	desc = "A ball cap worn by w-corp."
	icon_state = "what"
	perma = TRUE

/obj/item/clothing/suit/armor/ego_gear/city/wcorp/noreq
	attribute_requirements = list()
	equip_slowdown = 0
