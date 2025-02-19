
//EGO Armor
/obj/item/clothing/suit/armor/ego_gear/branch12
	name = "Branch 12 Armor base"
	desc = "Shit's fucked. Call a coder"
	icon = 'ModularTegustation/Teguicons/branch12/branch12_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/branch12/branch12_gearworn.dmi'

// --------ZAYIN---------
/obj/item/clothing/suit/armor/ego_gear/branch12/signal
	name = "signal"
	desc = "A simple black and white armor set."
	icon_state = "signal"
	armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 10, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)

// --------TETH---------
/obj/item/clothing/suit/armor/ego_gear/branch12/serenity
	name = "serenity"
	desc = "They shouldn't dwell into delusions like that, it will only lead them to their doom."
	icon_state = "serenity"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 30, BLACK_DAMAGE = -20, PALE_DAMAGE = 0)

/obj/item/clothing/suit/armor/ego_gear/branch12/departure
	name = "departure"
	desc = "It is sadly, time for us to part."
	icon_state = "departure"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 30, BLACK_DAMAGE = -20, PALE_DAMAGE = 0)

// --------HE---------
/obj/item/clothing/suit/armor/ego_gear/branch12/perfectionist
	name = "perfectionist"
	desc = "They shouldn't dwell into delusions like that, it will only lead them to their doom."
	icon_state = "perfectionist"
	armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 30, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 40
							)

/obj/item/clothing/suit/armor/ego_gear/branch12/medea
	name = "perfectionist"
	desc = "They shouldn't dwell into delusions like that, it will only lead them to their doom."
	icon_state = "perfectionist"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = -20, PALE_DAMAGE = 50)
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 40
							)


// --------WAW---------
/obj/item/clothing/suit/armor/ego_gear/branch12/joe
	name = "Average Joe"
	desc = "First impressions are always important when you are going on a job interview, so you better dress to impress!"
	icon_state = "average_joe"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/branch12/degraded_honor
	name = "Degraded Honor"
	desc = "First impressions are always important when you are going on a job interview, so you better dress to impress!"
	icon_state = "honor"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 50, BLACK_DAMAGE = 50, PALE_DAMAGE = -10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)

/obj/item/clothing/suit/armor/ego_gear/branch12/passion
	name = "Fluttering Passion"
	desc = "Is it better to die doing what you love, or to live without joy."
	icon_state = "passion"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 60, BLACK_DAMAGE = 40, PALE_DAMAGE = 0)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							)


/obj/item/clothing/suit/armor/ego_gear/branch12/plagiarism
	name = "plagiarism"
	desc = "The child asked 'How is it plagiarism if it was my work all along?'"
	icon_state = "plagiarism"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 50, PALE_DAMAGE = 30)
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/branch12/nightmares
	name = "childhood nightmares"
	desc = "They reached for the stars, only for them to be pulled beyond their reach."
	icon_state = "nightmares"
	armor = list(RED_DAMAGE = 70, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80,
							)


/obj/item/clothing/suit/armor/ego_gear/branch12/rumor
	name = "babbling rumor"
	desc = "They reached for the stars, only for them to be pulled beyond their reach."
	icon_state = "rumor"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 30)
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80,
							)


// --------ALEPH---------
/obj/item/clothing/suit/armor/ego_gear/branch12/purity
	name = "purity"
	desc = "This EGO holds the weight of the user's past mistakes, sins, shame and guilt. \
		The only way to use it properly is to have complete and total conviction in your goal."
	icon_state = "purity"
	armor = list(RED_DAMAGE = 50, WHITE_DAMAGE = 90, BLACK_DAMAGE = 50, PALE_DAMAGE = 50) // 240
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
