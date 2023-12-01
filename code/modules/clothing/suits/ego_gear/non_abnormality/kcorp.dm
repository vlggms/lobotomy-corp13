//Sprites by Quack. Red Favored. Drip? Maybe??
/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1
	name = "K corp L1 armor"
	desc = "Armor worn by Kcorp security."
	icon_state = "kcorp_l1"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3
	name = "K corp L3 armor"
	desc = "Armor worn by Kcorp excision staff."
	icon_state = "kcorp_l3"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	hat = /obj/item/clothing/head/ego_hat/helmet/kcorp_l3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_sci
	name = "K corp scientist uniform"
	desc = "A white labcoat with Kcorp's signature green. Appears to be specifically designed to not protect the wearer."
	icon_state = "kcorp_sci"
	equip_slowdown = 0

/obj/item/clothing/head/ego_hat/helmet/kcorp
	name = "k-corp L1 helmet"
	desc = "A riot helmet worn by k-corp."
	icon_state = "kcorp_l1"
	perma = TRUE

/obj/item/clothing/head/ego_hat/helmet/kcorp/visor
	name = "k-corp L1 helmet"
	desc = "A riot helmet worn by k-corp. This one comes with a Visor."
	icon_state = "kcorp_l1_visor"

/obj/item/clothing/head/ego_hat/helmet/kcorp_l3
	name = "\improper k-corp l3 helmet"
	desc = "A helmet worn by k-corp."
	icon_state = "kcorp_l3"
