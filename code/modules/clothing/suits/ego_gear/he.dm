/obj/item/clothing/suit/armor/ego_gear/grinder
	name = "grinder MK4"
	desc = "A sleek coat covered with bloodstains of an unknown origin."
	icon_state = "grinder"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = -20, BLACK_DAMAGE = 20, PALE_DAMAGE = 25)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/harvest
	name = "harvest"
	desc = "The last legacy of the man who sought wisdom. The rake tilled the human brain instead of farmland."
	icon_state = "harvest"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 20, BLACK_DAMAGE = -20, PALE_DAMAGE = 25)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/fury
	name = "blind fury"
	desc = "And all she saw was red."
	icon_state = "fury"
	//all in on red, minor negatives on all else
	armor = list(RED_DAMAGE = 65, WHITE_DAMAGE = -20, BLACK_DAMAGE = -20, PALE_DAMAGE = -20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/lutemis
	name = "dear lutemis"
	desc = "Let's all dangle down."
	icon_state = "lutemis"
	//White armor, weak to red. Red is pretty valuable.
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 60, BLACK_DAMAGE = 20, PALE_DAMAGE = 25)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/paw
	name = "bear paw"
	desc = "Does it even make sense to develop any emotion toward those monsters in the first place?"
	icon_state = "bear_paw"
	//Better rounded than Grinder, not as good against red. Also weak to pale.
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = -20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/wings
	name = "torn off wings"
	desc = "If she hadn’t thrown her slipper at the right time, if she hadn’t outfitted me with the pensioned colonel’s sword,\
		I’d be lying in my grave."
	icon_state = "wings"
	//Just Kinda meh. A lot of WAWs do black at the time of writing so
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 40, BLACK_DAMAGE = -20, PALE_DAMAGE = 20)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/remorse
	name = "remorse"
	desc = "While the armor serves to protect the users mind from the influence of others, they can never seem to quiet their own thoughts."
	icon_state = "remorse"
	//Resistant to White and Pale but weaker to the physical aspects.
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 50, BLACK_DAMAGE = 0, PALE_DAMAGE = 30)
