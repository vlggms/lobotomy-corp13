// Zayin
/obj/item/clothing/suit/armor/ego_gear/zayin/dragon_staff
	name = "dragon's staff"
	desc = "A dirty set of robes studded with knotty wooden trinkets. Wearing this fills you with the majesty and pride of a dragon."
	icon_state = "dragon_staff"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = NONE
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0) // 10

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

/obj/item/clothing/suit/armor/ego_gear/he/security_ego
	name = "security"
	desc = "An armored vest covered in metallic eyeballs. You occasionally feel them moving, as if searching for something."
	icon_state = "security"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = NONE
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 30, PALE_DAMAGE = 40) // 70
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
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

/obj/item/clothing/suit/armor/ego_gear/waw/furrows
	name = "furrows"
	desc = "The filthy overalls remind you of sharecroppers from the distant past. Someday, they'll return to that fallowed field."
	icon_state = "furrows"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 30, BLACK_DAMAGE = 0, PALE_DAMAGE = 40) // 140
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
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
	desc = "However, that alone won�t purge all evil from the world."
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

/obj/item/clothing/suit/armor/ego_gear/aleph/nightmares//stat total of 260, between regular ALEPH and PL
	name = "lucid nightmares"
	desc = "My father once told me of a mysterious cabin deep within the creek. I had found the fabled place within the recesses of my mind, wherein a horrible beast lurked..."
	icon_state = "nightmares"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/community/!icons/ego_worn.dmi'
	flags_inv = null
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 70, BLACK_DAMAGE = 80, PALE_DAMAGE = 50)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
