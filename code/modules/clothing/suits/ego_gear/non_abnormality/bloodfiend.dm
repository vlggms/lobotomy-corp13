/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak
	name = "masquerade cloak"
	desc = "A cloak worn by the bloodfiends, worn in celebration of something..."
	icon_state = "masqcloak"
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 30)
	hat = /obj/item/clothing/head/ego_hat/blood_fiend/bird_mask
	neck = /obj/item/clothing/ego_neck/blood_fiend/coagulated_blood
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/masquerade_coat
	name = "masquerade coat"
	desc = "A cloat worn by the bloodbags, worn in celebration of something..."
	icon_state = "Driedcoat"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 10, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)
	hat = null
	neck = null
	attribute_requirements = list()

/obj/item/clothing/ego_neck/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/neck/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/head/ego_hat/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/neck/blood_fiend/masquerade_tie
	name = "masquerade tie"
	desc = "A tie which fits the masquerade cloak."
	icon_state = "masqtie"

/obj/item/clothing/head/ego_hat/blood_fiend/bird_mask
	name = "masquerade mask"
	desc = "A mask that the bloodfiends have worn during the masquerade..."
	icon_state = "bird_mask"

/obj/item/clothing/ego_neck/blood_fiend/coagulated_blood
	name = "coagulated blood"
	desc = "The coagulated blood of a bloodfiend..."
	icon_state = "coagulated_blood"
