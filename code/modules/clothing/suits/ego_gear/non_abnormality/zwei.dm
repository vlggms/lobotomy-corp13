/obj/item/clothing/suit/armor/ego_gear/city/zweijunior
	name = "Zwei Association casual jacket"
	desc = "Armor worn by initiate zwei association fixers when not on duty."
	icon_state = "zweicasual"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)


/obj/item/clothing/suit/armor/ego_gear/city/zwei
	name = "Zwei Association armor"
	desc = "Armor worn by zwei association fixers."
	icon_state = "zwei"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/zweiriot
	name = "Zwei Association riot armor"
	desc = "Armor worn by zwei association fixers when they are suppressing riots or unrest. It slows you down slightly, but offers excellent defenses"
	icon_state = "zweiriot"
	slowdown = 0.7
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/zweivet
	name = "Zwei Association veteran armor"
	desc = "Armor worn by zwei association veteran fixers."
	icon_state = "zweivet"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/zweivet/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "zweishort"
		worn_icon_state = icon_state


/obj/item/clothing/suit/armor/ego_gear/city/zweileader
	name = "Zwei Association director armor"
	desc = "Armor worn by zwei association directors."
	icon_state = "zweileader"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

//for the ERT.
/obj/item/clothing/suit/armor/ego_gear/city/zwei/noreq
	equip_slowdown = 0
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/city/zweivet/noreq
	equip_slowdown = 0
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/city/zweileader/noreq
	equip_slowdown = 0
	attribute_requirements = list()


//Zwei West
/obj/item/clothing/suit/armor/ego_gear/city/zweiwest
	name = "Zwei knight armor"
	desc = "Armor worn by zwei west association fixers. It slows you down slightly, but offers excellent defenses"
	icon_state = "zweiwest"
	slowdown = 0.4
	neck = /obj/item/clothing/neck/ego_neck/zweiwest
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/zweiwestvet
	name = "Zwei veteran knight armor "
	desc = "Armor worn by zwei west association fixers. It slows you down slightly, but offers excellent defenses"
	icon_state = "zweiwest_veteran"
	slowdown = 0.4
	neck = /obj/item/clothing/neck/ego_neck/zweiwest
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 30)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/zweiwestleader
	name = "Zwei knight director armor"
	desc = "Armor worn by zwei association fixers when they are suppressing riots or unrest. It slows you down slightly, but offers excellent defenses"
	icon_state = "zweiwest_director"
	slowdown = 0.4
	neck = /obj/item/clothing/neck/ego_neck/zweiwest
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 40)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)


/obj/item/clothing/neck/ego_neck/zweiwest
	name = "zwei knight cape"
	desc = "A cape worn by Zwei west."
	icon_state = "zweiwest"
