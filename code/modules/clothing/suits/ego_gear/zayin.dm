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
	if(H.hairstyle in list("Bald", "Shaved"))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/clothing/suit/armor/ego_gear/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have bald or shaved hair.</span>"

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
