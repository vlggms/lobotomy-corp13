
/obj/item/clothing/suit/armor/ego_gear/tools
	icon = 'icons/obj/clothing/ego_gear/abnormality/tools.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/tools.dmi'

/obj/item/clothing/suit/armor/ego_gear/tools/bucket
	name = "bucket"
	desc = "The man lost his balance after seeing what the well's bucket had drawn."
	icon_state = "bucket"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tools/swindle
	name = "swindle"
	desc = "All-natural snake oil! Cleans the skin, removes pimples, impetigo, and other defects!"
	icon_state = "swindle"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = 0) // 20
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40)

/obj/item/clothing/suit/armor/ego_gear/tools/ringing
	name = "ringing"
	desc = "An army coat with buttons reminiscent of a keypad. The echoing voices in your head drown out the threats that stand before you."
	icon_state = "ringing"
	armor = list(RED_DAMAGE = -30, WHITE_DAMAGE = -20, BLACK_DAMAGE = 60, PALE_DAMAGE = 0) // 10
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/divinity
	name = "divinity"
	desc = "The burden of sacrifice is yours alone..."
	icon_state = "divinity"
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = 70) // 10
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/hyde
	name = "hyde"
	desc = "Late one accursed night, I compounded the elements, watched them boil and smoke together in the glass, and when the ebullition had subsided, \
	with a strong glow of courage, drank off the potion."
	icon_state = "hyde"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = -30, BLACK_DAMAGE = 20, PALE_DAMAGE = 40) // 70
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/destiny
	name = "destiny"
	desc = "The role of the Moirai was to ensure that every being, mortal and divine, lived out their destiny as it was assigned to them by the laws of the universe."
	icon_state = "destiny"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 30, BLACK_DAMAGE = -20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/aspiration
	name = "aspiration"
	desc = "Excessive aspiration would bring about unwarranted frenzy."
	icon_state = "aspiration"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0) // 20
