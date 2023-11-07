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

/obj/item/storage/belt/egopcorp/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 2
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/gun/ego_gun,
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

/obj/item/storage/belt/egoarmor/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 100
	STR.set_holdable(list(
		/obj/item/clothing/suit/armor/ego_gear
		))

//Heavy backpacks
/obj/item/storage/backpack/pcorp
	name = "pcorp large backpack"
	desc = "You wear this on your back and put items into it. Holds 3 of any bulky item. Slows you down slightly."
	icon_state = "duffel-drone"
	inhand_icon_state = "duffel-drone"
	slowdown = 0.5

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
	slowdown = 1

/obj/item/storage/backpack/pcorpheavy/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 50
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 5
