/obj/item/clothing/suit/armor/ego_gear/city/devyat_suit
	name = "devyat coat"
	desc = "A warm coat worn by fixers from the devyat association. Increases your running speed by 15%, allowing for quick movement."
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	worn_icon = 'icons/obj/clothing/ego_gear/devyat_armor.dmi'
	icon_state = "devyat"
	slowdown = -0.15
	hat = /obj/item/clothing/head/ego_hat/devyat_goggles
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 10, BLACK_DAMAGE = 50, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80,
							)

/obj/item/clothing/suit/armor/ego_gear/city/devyat_suit/weak
	name = "devyat intern coat"
	desc = "A warm coat worn by intern fixers from the devyat association. Increases your running speed by 10%, allowing for quick movement."
	slowdown = -0.10
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 0, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60,
							)

/obj/item/clothing/head/ego_hat/devyat_goggles
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	worn_icon = 'icons/obj/clothing/ego_gear/devyat_armor.dmi'
	name = "devyat goggles"
	desc = "Simple goggles that the devyat wear during their jobs."
	icon_state = "9goggles"
