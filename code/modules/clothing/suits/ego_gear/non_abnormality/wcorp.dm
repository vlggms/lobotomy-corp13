//Wcorp
/obj/item/clothing/suit/armor/ego_gear/wcorp
	name = "\improper w corp armor vest"
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

/obj/item/clothing/head/wcorp //No armor since the ego-gears do it's job.
	name = "\improper w-corp cap"
	desc = "A ball cap worn by w-corp."
	icon_state = "what"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'


/obj/item/clothing/suit/armor/ego_gear/wcorp/noreq
	attribute_requirements = list()
	equip_slowdown = 0
