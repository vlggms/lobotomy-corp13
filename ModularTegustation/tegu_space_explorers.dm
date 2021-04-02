/****** MINER KITS ******/
/obj/item/storage/backpack/duffelbag/space_exploration
	name = "space exploration kit"
	desc = "A kit containing everything a miner needs to qualify for space exploration."
	icon_state = "duffel-explorer"
	inhand_icon_state = "duffel-explorer"

/obj/item/storage/backpack/duffelbag/space_exploration/PopulateContents()
	new /obj/item/clothing/suit/space/hardsuit/mining/compact(src)
	new /obj/item/tank/jetpack/oxygen/harness(src)
	new /obj/item/tank/internals/oxygen(src)
	new /obj/item/binoculars(src)
	new /obj/item/gps/mining(src)

/obj/item/clothing/suit/space/hardsuit/mining/compact
	name = "compact mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Although similar to normal mining harsduit, this one seems to be a bit weaker."
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 25, BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 50, BIO = 100, RAD = 40, FIRE = 30, ACID = 75, WOUND = 5)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining/compact

/obj/item/clothing/head/helmet/space/hardsuit/mining/compact
	name = "compact mining hardsuit helmet"
	armor = list(MELEE = 25, BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 50, BIO = 100, RAD = 40, FIRE = 30, ACID = 75, WOUND = 5)

/****** SPACE LOOT ******/
/////// SPACE SUITS //////
// A variable for space loot, so these are less armored.
/obj/item/clothing/head/helmet/space
	var/frail = FALSE

/obj/item/clothing/head/helmet/space/Initialize()
	. = ..()
	if(frail)
		name = "frail [name]"
		desc += " This one is rather frail."
		armor = list(MELEE = 25, BULLET = 35, LASER = 20,ENERGY = 25, BOMB = 20, BIO = 20, RAD = 30, FIRE = 50, ACID = 50)

/obj/item/clothing/suit/space/syndicate
	var/frail = FALSE

/obj/item/clothing/suit/space/syndicate/Initialize()
	. = ..()
	if(frail)
		name = "frail [name]"
		desc += " This one is rather frail."
		armor = list(MELEE = 25, BULLET = 35, LASER = 20,ENERGY = 25, BOMB = 20, BIO = 20, RAD = 30, FIRE = 50, ACID = 50)
		slowdown += 0.1
