//Armor from tool abnormalities
/obj/item/clothing/suit/armor/ego_gear/tools
	icon = 'icons/obj/clothing/ego_gear/abnormality/tools.dmi'
	worn_icon = 'icons/mob/clothing/ego_gear/abnormality/tools.dmi'

//ZAYIN
/obj/item/clothing/suit/armor/ego_gear/tools/bucket
	name = "bucket"
	desc = "The man lost his balance after seeing what the well's bucket had drawn."
	icon_state = "bucket"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tools/prohibited
	name = "PROHIBITED!!!"
	desc = "Why would you even want to touch it?"
	icon_state = "touch"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 10)

/obj/item/clothing/suit/armor/ego_gear/tools/plastic
	name = "plastic smile"
	desc = "Do you love your city?"
	icon_state = "plastic"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tools/mirror
	name = "mirror"
	desc = "The only thing reflected on this mirror is people."
	icon_state = "mirror"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/tools/promise
	name = "belief and promise"
	desc = "However, all that those promises yielded was only hollowness and betrayal."
	icon_state = "promise"
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

//TETH
/obj/item/clothing/suit/armor/ego_gear/tools/aspiration
	name = "aspiration"
	desc = "Excessive aspiration would bring about unwarranted frenzy."
	icon_state = "aspiration"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0) // 20

/obj/item/clothing/suit/armor/ego_gear/tools/adjustment
	name = "adjustment"
	desc = "Armor that protects the psyche by dulling intellect. Just beware of the side effects."
	icon_state = "adjustment"
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 40, BLACK_DAMAGE = -10, PALE_DAMAGE = -20) // 20

/obj/item/clothing/suit/armor/ego_gear/tools/philia
	name = "philia"
	desc = "A suit that wouldn't be out of place if worn on a stage."
	icon_state = "philia"
	armor = list(RED_DAMAGE = -30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 20, PALE_DAMAGE = 0) // 20

/obj/item/clothing/suit/armor/ego_gear/tools/luminosity
	name = "luminosity"
	desc = "Armor that truly shines when born by those in need."
	icon_state = "luminosity"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = 0) // 20

//HE
/obj/item/clothing/suit/armor/ego_gear/tools/swindle
	name = "swindle"
	desc = "All-natural snake oil! Cleans the skin, removes pimples, impetigo, and other defects!"
	icon_state = "swindle"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = 0) // 20
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

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

/obj/item/clothing/suit/armor/ego_gear/tools/destiny
	name = "destiny"
	desc = "The role of the Moirai was to ensure that every being, mortal and divine, lived out their destiny as it was assigned to them by the laws of the universe."
	icon_state = "destiny"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 30, BLACK_DAMAGE = -20, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/giant_tree_branch
	name = "giant tree branch"
	desc = "The tree simply reaped from what it sowed."
	icon_state = "sap"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -20, BLACK_DAMAGE = 30, PALE_DAMAGE = 10) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/tools/isolation
	name = "isolation"
	desc = "Company P wished to construct the safest place on Earth. However, this shelter, while perfectly safe on the inside, \
	alters the reality of the outside to be even more hopeless. It literally makes itself into \"the safest place on Earth.\""
	icon_state = "shelter"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 0, PALE_DAMAGE = 20) // 70
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

//WAW
/obj/item/clothing/suit/armor/ego_gear/tools/windup
	name = "wind-up"
	desc = "Humanity has conquered disease and nature. Now we have come far enough to harness time itself."
	icon_state = "windup"
	//This used to be 1/5/1/7 but it invalidated literally every other waw EGO for pale armor.
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 40, BLACK_DAMAGE = 30, PALE_DAMAGE = 40) // 140
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/tools/hyde
	name = "hyde"
	desc = "Late one accursed night, I compounded the elements, watched them boil and smoke together in the glass, and when the ebullition had subsided, \
	with a strong glow of courage, drank off the potion."
	icon_state = "hyde"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 30) // 140
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
