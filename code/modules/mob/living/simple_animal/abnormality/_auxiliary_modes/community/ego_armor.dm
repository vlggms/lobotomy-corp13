// Zayin

// Teth
/obj/item/clothing/suit/armor/ego_gear/teth/desert
	name = "desert wind"
	desc = "Dirty rag armor, better than nothing. It's light as a feather, and increases your movement speed by 10%."
	icon_state = "desert"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = NONE
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 10, BLACK_DAMAGE = -20, PALE_DAMAGE = 0) // -20
	slowdown = -0.1

// He
/obj/item/clothing/suit/armor/ego_gear/he/sunspit
	name = "sunspit"
	desc = "Praise the sun!"
	icon_state = "sunspit"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = NONE
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -30, BLACK_DAMAGE = -10, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

// Waw
/obj/item/clothing/suit/armor/ego_gear/waw/ochre
	name = "ochre sheet"
	desc = "You shall not pass!"
	icon_state = "ochre"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 10) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/waw/miasma
	name = "miasma skin"
	desc = "A heavy robe made of interlinked scales."
	icon_state = "miasma"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 20) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

// Aleph
/obj/item/clothing/suit/armor/ego_gear/aleph/waxen
	name = "Waxen Pinion"
	desc = "However, that alone won’t purge all evil from the world."
	icon_state = "combust"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = null
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 40, BLACK_DAMAGE = 60, PALE_DAMAGE = 60)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/aleph/limos
	name = "limos"
	desc = "Feed me! Feed me! Feed me more!"
	icon_state = "limos"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 50, BLACK_DAMAGE = 80, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
