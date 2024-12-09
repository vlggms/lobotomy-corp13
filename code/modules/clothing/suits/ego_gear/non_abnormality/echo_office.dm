/obj/item/clothing/suit/armor/ego_gear/city/echo
	name = "Echo outfit"
	desc = "You should not be able to see this."
	icon_state = "maid_dress"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/maid_dress
	name = "Neon Maid Dress"
	desc = "I have no reason to deny the greatness and beauty of such an amazing outfit!"
	icon_state = "maid_dress"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 60, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/stars
	name = "Reverie Under the Stars"
	desc = "A change has happened."
	icon_state = "stars"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 60)
	slowdown = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/plated
	name = "Plated Outer Cover"
	desc = "An echo of a past Memory... A painful one at that."
	icon_state = "plated"
	hat = /obj/item/clothing/head/ego_hat/plated
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 60, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/head/ego_hat/plated
	name = "Plated Hood"
	desc = "An echo of a past Memory... A painful one at that."
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDEHAIR
	icon_state = "plated"

/obj/item/clothing/suit/armor/ego_gear/city/echo/faux
	name = "Frilled Maid Outfit/Faux Fur Coat"
	desc = "Seems that layering the two outfits stops the coat from taking any effect, but it at least still protects whatever semi-professional image he's got left."
	icon_state = "faux"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
