//All ZAYIN joke E.G.O

/obj/item/clothing/suit/armor/ego_gear/zayin/mcrib
	name = "mcrib"
	desc = "The McRib is what is known as a limited time item. They only make them two, three times a year tops.\
	We are obliged to eat as many as possible. "
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_worn.dmi'
	icon_state = "mcrib"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = -10, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)

// All TETH joke E.G.O

// All HE joke E.G.O

// All WAW joke E.G.O

// All ALEPH joke E.G.O
/obj/item/clothing/suit/armor/ego_gear/aleph/chaosdunk
	name = "chaos dunk"
	desc = "You either slam with the best or jam with the rest."
	icon_state = "chaosdunk"
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_worn.dmi'
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 80) // 260
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/clothing/suit/armor/ego_gear/aleph/ultimate_christmas
	name = "ultimate christmas"
	desc = "Christmas is the jolliest time of the year, and Rudolta is always ready for it."
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_worn.dmi'
	icon_state = "ultimate_christmas"
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/aleph/sukuna
	name = "heian era robes"
	desc = "Wearing these makes you want to dismember a white haired sorcerer."
	icon_state = "uniqueoffice4"
	icon = 'icons/obj/clothing/ego_gear/custom_fixer.dmi'
	worn_icon =  'icons/mob/clothing/ego_gear/custom_fixer.dmi'
	armor = list(RED_DAMAGE = 80, WHITE_DAMAGE = 70, BLACK_DAMAGE = 50, PALE_DAMAGE = 80) // 280, ALEPH+
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 120
							)

/obj/item/clothing/shoes/sandal/sukuna
	name = "sukuna's sandals"
	desc = "A pair of Ryomen Sukuna's sandals."
	icon_state = "wizard"

/obj/item/clothing/shoes/sandal/heian
	name = "sukuna's COOLER sandals"
	desc = "These are the sandals he wore in the Heian Era while stomping out some random kid."
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 10, BLACK_DAMAGE = 0, PALE_DAMAGE = 20) //they should only spawn from killing suguma, dw
	icon_state = "wizard"

/obj/item/clothing/suit/armor/ego_gear/aleph/wild_ride
	name = "wild ride"
	desc = "Looks like a T-shirt from a rock concert, with a flaming skeleton on it. In big, red text the shirt says \"I survived Mr. Bones' Wild ride\""
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_armor.dmi'
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_worn.dmi'
	icon_state = "wild_ride"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 70, BLACK_DAMAGE = 40, PALE_DAMAGE = 80) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 120
							)

//Lods of Emone (Netz)

//////////////////////////////////////////////////////
////POSSIBLE ERRORS HERE - PLEASE CHECK AND NOTIFY////
//////////////////////////////////////////////////////


/obj/item/clothing/suit/armor/ego_gear/zayin/pocketdosh
	name = "pocket full of dosh"
	desc = "Sing a song of six pense, a pocket full of dosh."
	special = "This armor grows stronger depending on how filthy rich you are."
	icon_state = "pocket_dosh"
	worn_icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_worn.dmi'
	icon = 'code/modules/mob/living/simple_animal/abnormality/_auxiliary_modes/joke/!icons/ego_armor.dmi'
	var/datum/bank_account
	armor = list(RED_DAMAGE = 0, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 40,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60
		)

/obj/item/clothing/suit/armor/ego_gear/zayin/pocketdosh/Initialize()
	INVOKE_ASYNC(src, PROC_REF(update_armor))
	return ..()

/obj/item/clothing/suit/armor/ego_gear/zayin/pocketdosh/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_CLOTHING && isliving(user))
		var/mob/living/living_user = user
		account = living_user.get_bank_account()

/obj/item/clothing/suit/armor/ego_gear/zayin/pocketdosh/proc/update_armor()
	sleep(5 MINUTES)

	if(!linked_account)
		update_armor()
		return

	if(account_balance >= 1000000) //if someone spends the time to become a millionaire I say they deserve it
		src.armor = new(RED_DAMAGE = 100, WHITE_DAMAGE = 100, BLACK_DAMAGE = 100, PALE_DAMAGE = 100)

	else if(account_balance >= 1000)
		src.armor = new(RED_DAMAGE = 60, WHITE_DAMAGE = 90, BLACK_DAMAGE = 90, PALE_DAMAGE = 60)

	else if(account_balance >= 500)
		src.armor = new(RED_DAMAGE = 40, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = 40)

	else if(account_balance >= 100)
		src.armor = new(RED_DAMAGE = 20, WHITE_DAMAGE = 30, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)

	else
		armor = initial(armor)

	update_armor()
