/obj/item/clothing/suit/armor/ego_gear/city/kcorp //bit outdated, left here if someone wants to use it.
	name = "K corp armor"
	desc = "Armor worn by Kcorp employees."
	icon_state = "kcorp"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1 //Sprites by Quack. Current Values reflect Assoc Armor Values
	name = "K corp L1 armor"
	desc = "Armor worn by Kcorp security."
	icon_state = "kcorp_l1"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 0) //Red was favored, so Red is K-corps Focus
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

/obj/item/clothing/head/kcorp //tbh we probably just need a ego armor helmet
	name = "\improper k-corp l1 helmet"
	desc = "A riot helmet worn by k-corp."
	icon_state = "kcorp_l1"
	icon = 'icons/obj/clothing/ego_gear/head.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/head.dmi'
	flags_inv = HIDEHAIR|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/kcorp/visor
	name = "\improper k-corp l1 helmet"
	desc = "A riot helmet worn by k-corp. This one comes with a Visor."
	icon_state = "kcorp_l1_visor"

/obj/item/clothing/head/kcorp/l3
	name = "\improper k-corp l3 helmet"
	desc = "A helmet worn by k-corp."
	icon_state = "kcorp_l3"
