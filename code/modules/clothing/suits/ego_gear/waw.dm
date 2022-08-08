/obj/item/clothing/suit/armor/ego_gear/hornet
	name = "hornet armor"
	desc = "A dark coat with yellow details. You feel as if you can hear faint buzzing coming out of it."
	icon_state = "hornet"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 25)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/lamp
	name = "lamp armor"
	desc = "A dark coat with thousands of eyes on it. They are looking at you as you move."
	icon_state = "lamp"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 30, BLACK_DAMAGE = 60, PALE_DAMAGE = 25)
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/correctional
	name = "correctional armor"
	desc = "A white, lightly bloodstained coat. it goes all the way down to your ankles."
	icon_state = "correctional"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -20, BLACK_DAMAGE = 60, PALE_DAMAGE = 30)		//Like Lamp and Hornet put together but if you are hit by white you fucking die
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 60)

/obj/item/clothing/suit/armor/ego_gear/despair
	name = "armor sharpened with tears"
	desc = "Tears fall like ash, embroidered as if they were constellations."
	icon_state = "despair"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 60)
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/hatred
	name = "in the name of love and hate"
	desc = "A magical one-piece dress imbued with the love and justice of a magical girl. \
	Wearing it may ignite your spirit of justice and the desire to protect the world. \
	Then you'll hear the sound of hatred, sinking deeper than love."
	icon_state = "hatred"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 60, PALE_DAMAGE = 25)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/oppression
	name = "oppression"
	desc = "And I shall hold you here, forever."
	icon_state = "oppression"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)		//First and foremost: Good against red buddy. then itself.
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/totalitarianism
	name = "totalitarianism"
	desc = "Or are you trapped here by me?"
	icon_state = "totalitarianism"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 50, PALE_DAMAGE = 20)		//First and foremost: Good against red buddy. then itself.
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/goldrush
	name = "gold rush"
	desc = "Bare armor. lightweight and ready for combat."
	icon_state = "gold_rush"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 30, BLACK_DAMAGE = 20, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							)
