/obj/item/clothing/suit/armor/ego_gear/city/ncorp
	name = "nagel und hammer armor"
	desc = "Armor worn by Nagel Und Hammer."
	icon_state = "ncorp"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 50)
	hat = /obj/item/clothing/head/ego_hat/helmet/ncorp
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet
	name = "decorated nagel und hammer armor"
	desc = "Armor worn by the Nagel Und Hammer."
	icon_state = "ncorp_vet"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 60)
	hat = /obj/item/clothing/head/ego_hat/helmet/ncorp/vet
	neck = /obj/item/clothing/neck/ego_neck/ncorp
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/grosshammmer
	name = "nagel und hammer grosshammer armor"
	desc = "Armor worn by leaders of Nagel Und Hammer. offers excellent protection at the cost of a significant speed drop."
	slowdown = 1
	icon_state = "ncorp_captain"
	armor = list(RED_DAMAGE = 90, WHITE_DAMAGE = 70, BLACK_DAMAGE = 70, PALE_DAMAGE = 80)
	hat = /obj/item/clothing/head/ego_hat/helmet/ncorp/grosshammer
	neck = /obj/item/clothing/neck/ego_neck/ncorp/grosshammer
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	clothing_flags = BLOCKS_SHOVE_KNOCKDOWN | NOSLIP

/obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander
	name = "Rüstung der auserwählten Frau Gottes"
	desc = "Armor worn by leaders of Nagel Und Hammer."
	icon_state = "ncorp_lead"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 60, PALE_DAMAGE = 70)
	neck = /obj/item/clothing/neck/ego_neck/ncorp/commander
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/head/ego_hat/helmet/ncorp
	name = "nagel und hammer helmet"
	desc = "A helmet worn by Nagel Und Hammer."
	icon_state = "ncorp"

/obj/item/clothing/head/ego_hat/helmet/ncorp/vet
	name = "decorated nagel und hammer helmet"
	desc = "A helmet worn by Nagel Und Hammer."
	icon_state = "ncorp_vet"

/obj/item/clothing/head/ego_hat/helmet/ncorp/grosshammer
	name = "nagel und hammer grosshammer helmet"
	desc = "A helmet worn by the leaders Nagel Und Hammer."
	icon_state = "ncorp_captain"

/obj/item/clothing/neck/ego_neck/ncorp
	name = "nagel und hammer cape"
	desc = "A cape worn by Nagel Und Hammer."
	icon_state = "mittle"

/obj/item/clothing/neck/ego_neck/ncorp/grosshammer
	name = "nagel und hammer grosshammer cape"
	desc = "A cape worn by the leaders of Nagel Und Hammer."
	icon_state = "grosshammer"

/obj/item/clothing/neck/ego_neck/ncorp/commander
	name = "Umhang der auserwählten Frau Gottes"
	desc = "A cape worn by the commander of Nagel Und Hammer."
	icon_state = "kromer"
