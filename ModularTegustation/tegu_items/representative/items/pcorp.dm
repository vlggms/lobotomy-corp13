//Crates
/obj/structure/closet/crate/pcorp
	name = "P-Corp quik tm crate"
	drag_slowdown = -0.2
	desc = "A rectangular crate stamped with Pcorp's logo. This one surprisingly speeds you up as you drag it. Holds less items than you'd like however."
	icon_state = "pcorp_crate"
	allow_dense = FALSE
	storage_capacity = 3

//Belts
/obj/item/storage/belt/egopcorp
	name = "ego heavy arms belt"
	desc = "Holds a pair of large ego weapons."
	icon_state = "assaultbelt"
	inhand_icon_state = "assaultbelt"
	worn_icon_state = "assaultbelt"
	content_overlays = FALSE
	custom_premium_price = PAYCHECK_MEDIUM * 2
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/storage/belt/egopcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/ego_weapon/ranged,
		/obj/item/ego_weapon,
	))

/obj/item/storage/belt/egoarmor
	name = "ego armor belt"
	desc = "Holds up to 3 EGO gear."
	icon_state = "grenadebeltold"
	inhand_icon_state = "grenadebeltold"
	worn_icon_state = "grenadebeltold"
	content_overlays = FALSE
	custom_premium_price = PAYCHECK_MEDIUM * 2
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/storage/belt/egoarmor/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/clothing/suit/armor/ego_gear,
	))

//Heavy backpacks
/obj/item/storage/backpack/pcorp
	name = "pcorp large backpack"
	desc = "You wear this on your back and put items into it. Holds 3 of any bulky item. Slows you down slightly."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	slowdown = 0.1
	drag_slowdown = 1

/obj/item/storage/backpack/pcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 3

/obj/item/storage/backpack/pcorpheavy
	name = "pcorp massive backpack"
	desc = "You wear this on your back and put items into it. Holds 5 of any bulky item. Slows you down."
	icon_state = "holdingpack"
	inhand_icon_state = "holdingpack"
	slowdown = 0.25
	drag_slowdown = 1

/obj/item/storage/backpack/pcorpheavy/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 50
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 5

//Pouches
/obj/item/storage/pcorp_pocket
	name = "P-Corp Deep Pocket"
	desc = "Put onto your pocket to hold any 4 small items."
	icon_state = "ppouch"
	inhand_icon_state = "ppouch"
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/pcorp_pocket/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 4


//Pouches
/obj/item/storage/pcorp_weapon
	name = "P-Corp Small Weapon Holster"
	desc = "Put onto your pocket to hold any small EGO weapon."
	icon_state = "pweapon"
	inhand_icon_state = "pweapon"
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/pcorp_weapon/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 32
	STR.set_holdable(GLOB.small_ego)


//Gloves
/obj/item/clothing/gloves/pcorp
	name = "P-Corp Dimensional Containment Gloves"
	desc = "Holds 3 small ego weapons."
	icon_state = "tackledolphin"
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/clothing/gloves/pcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(GLOB.small_ego)

//better gloves
/obj/item/clothing/gloves/pcorpbig
	name = "P-Corp Dimensional Containment Gloves MK2"
	desc = "Holds a single large EGO weapon."
	icon_state = "pcorp"
	w_class = WEIGHT_CLASS_BULKY
	drag_slowdown = 1

/obj/item/clothing/gloves/pcorpbig/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(GLOB.small_ego)




// Food
/obj/item/food/canned/pcorp_icecream
	name = "p-corp canned ice cream"
	desc = "P corp's specialty canned ice cream."
	icon_state = "pcorp_icecream"
	trash_type = /obj/item/trash/can/food/pcorp_icecream
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/medicine/sal_acid = 5)
	tastes = list("strawberry" = 1, "mint" = 1, "chocolate" = 1,"butterscotch" = 1)
	foodtypes = DAIRY | SUGAR

/obj/item/food/canned/pcorp_burger
	name = "p-corp canned burger"
	desc = "P corp's specialty canned burger."
	icon_state = "burgercan"
	trash_type = /obj/item/trash/can/food/pcorp_burger
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("bun" = 2, "beef patty" = 4)
	foodtypes = GRAIN | MEAT

// Food Trash
/obj/item/trash/can/food/pcorp_icecream
	name = "canned ice cream"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "pcorp_icecream_empty"

/obj/item/trash/can/food/pcorp_burger
	name = "canned burger"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "burgercan_empty"
