// ZAYIN Armor should be kept below 10 total armor.

/* Lead Developer's note:
Think before you code!
Any attempt to code risk class armor will result in a 10 day Github ban.*/

/obj/item/clothing/suit/armor/ego_gear/zayin
	icon = 'icons/obj/clothing/ego_gear/abnormality/zayin.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/zayin.dmi'

/obj/item/clothing/suit/armor/ego_gear/zayin/penitence
	name = "penitence"
	desc = "A piece of EGO armor intended to protect its user from mental decay. This suit will be no better than rags to those who have no sense of guilt."
	icon_state = "penitence"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/tough
	name = "tough jacket"
	desc = "A leather jacket with an unusually luxurious figure. Only those who maintain a clean “hairstyle” with no impurities on their head will be deemed worthy of equipping this suit."
	icon_state = "tough"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with dedication to clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/clothing/suit/armor/ego_gear/zayin/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have clean hairstyle.</span>"

/obj/item/clothing/suit/armor/ego_gear/zayin/soda
	name = "soda armor"
	desc = "A suit of armor that feels like you're wearing aluminum. \
	It’s quite light for armor, so it is rather comfortable to wear."
	icon_state = "soda"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/little_alice
	name = "little alice"	//Looks like alice from Shin Megami Tensei
	desc = "Oh, they are so very beautiful."
	icon_state = "little_alice"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/wingbeat
	name = "wingbeat"
	desc = "Most of the employees do not know the true meaning of The Fairies’ Care."
	icon_state = "wingbeat"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/change
	name = "change"
	desc = "Everything can be changed if you try hard enough!"
	icon_state = "change"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/doze
	name = "dozing"
	desc = "While this looks like a set of pajamas, it protects the user from mental damage."
	icon_state = "doze"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/nostalgia
	name = "nostalgia"
	desc = "An old brown jacket. What seems to be an L corp logo is stitched into the side. This logo, strangely, is not one for the company you work at"
	icon_state = "nostalgia"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/evening
	name = "evening twilight"
	desc = "If you accept it, your whole world will change."
	icon_state = "evening"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 10)

/obj/item/clothing/suit/armor/ego_gear/zayin/cavernous_wailing
	name = "cavernous wailing"
	desc = "Doesn't it make you more gloomy than anything?"
	icon_state = "cavernous_wailing"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/nightshade
	name = "nightshade"
	desc = "It could hear all the meaningless words I have said and will say in the future and perfectly understand them."
	icon_state = "nightshade"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/hugs
	name = "hugs"
	desc = "Soft and squishy, you could hug it for days."
	icon_state = "hugs"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/letter_opener
	name = "letter opener"
	desc = "Liberty. Reason. Justice. Civility. Edification. Perfection. MAIL!"
	icon_state = "letter_opener"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/eclipse
	name = "eclipse of scarlet moths"
	desc = "A bright suit that brings you warmth."
	icon_state = "eclipse"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/oceanic
	name = "taste of the sea"
	desc = "A suit that's old and dyed crimson, and made of thin plastic."
	icon_state = "oceanic"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/zayin/cord
	name = "cord"
	desc = "A suit that resembles a sweater.."
	icon_state = "cord"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)


//Netz Joke Abno

////////////////////////////////////////
////REMEMBER TO ADD THE MONEY CHECK!////
////////////////////////////////////////

/obj/item/clothing/suit/armor/ego_gear/zayin/pocketdosh
	name = "pocket full of dosh"
	desc = "Sing a song of six pense, a pocket full of dosh."
	special = "This armor grows stronger depending on how filthy rich you are."
	icon_state = "penitence" //needs to be done eventually - translation for self: the sprite of the armor
	//penitence is a placeholder
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 40
		PRUDENCE_ATTRIBUTE = 60
		TEMPERANCE_ATTRIBUTE = 80
		JUSTICE_ATTRIBUTE = 60
		)

	if (account.has_money >= 100 && < 500)
	{
		armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)
	}

	if else (account.has_money >= 500 && < 1000)
	{
		armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 40)
	}

	if else (account.has_money >= 1000 && < 1000000)
	{
		armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE _DAMAGE = 60)
	}

	if else (account.has_money >= 1000000) //if someone spends the time to become a millionaire I say they deserve it
	{
		armor = list(RED_DAMAGE = 100, WHITE_DAMAGE = 100, BLACK_DAMAGE = 100, PALE_DAMAGE = 100)
	}
