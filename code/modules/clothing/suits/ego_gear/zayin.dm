// ZAYIN Armor should be kept below 10 total armor.

/obj/item/clothing/suit/armor/ego_gear/penitence
	name = "penitence"
	desc = "A piece of EGO armor intended to protect its user from mental decay. This suit will be no better than rags to those who have no sense of guilt."
	icon_state = "penitence"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tough
	name = "tough jacket"
	desc = "A leather jacket with an unusually luxurious figure. Only those who maintain a clean “hairstyle” with no impurities on their head will be deemed worthy of equipping this suit."
	icon_state = "tough"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with dedication to clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/clothing/suit/armor/ego_gear/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have clean hairstyle.</span>"

/obj/item/clothing/suit/armor/ego_gear/soda
	name = "soda armor"
	desc = "A suit of armor that feels like you're wearing aluminum. \
	It’s quite light for armor, so it is rather comfortable to wear."
	icon_state = "soda"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/little_alice
	name = "little alice"	//Looks like alice from Shin Megami Tensei
	desc = "Oh, they are so very beautiful."
	icon_state = "little_alice"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/wingbeat
	name = "wingbeat"
	desc = "Most of the employees do not know the true meaning of The Fairies’ Care."
	icon_state = "wingbeat"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/change
	name = "change"
	desc = "Everything can be changed if you try hard enough!"
	icon_state = "change"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/doze
	name = "dozing"
	desc = "While this looks like a set of pajamas, it protects the user from mental damage."
	icon_state = "doze"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/nostalgia
	name = "nostalgia"
	desc = "An old brown jacket. What seems to be an L corp logo is stitched into the side. This logo, strangely, is not one for the company you work at"
	icon_state = "nostalgia"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/evening
	name = "evening twilight"
	desc = "If you accept it, your whole world will change."
	icon_state = "evening"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 10)

/obj/item/clothing/suit/armor/ego_gear/melty_eyeball
	name = "melty eyeball"
	desc = "Doesn't it make you more gloomy than anything?"
	icon_state = "melty_eyeball"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/nightshade
	name = "nightshade"
	desc = "It could hear all the meaningless words I have said and will say in the future and perfectly understand them."
	icon_state = "nightshade"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/hugs
	name = "hugs"
	desc = "Soft and squishy, you could hug it for days."
	icon_state = "hugs"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
