/obj/item/storage/First_aid_l1
	name = "First Aid Kit L1"
	desc = "You wear this on your pocket and put medipens into it."
	icon_state = "medpack"
	inhand_icon_state = "medpack"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/First_aid_l1/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 4
	STR.set_holdable(list(/obj/item/reagent_containers/hypospray/medipen))

/obj/item/storage/First_aid_l1/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)

/obj/item/reagent_containers/hypospray/medipen/dual
	name = "Double Healing Pen"
	icon_state = "atropen"
	list_reagents = list(/datum/reagent/medicine/mental_stabilizator = 5, /datum/reagent/medicine/sal_acid = 5)


/obj/item/storage/First_aid_l2
	name = "First Aid Kit L2"
	desc = "You wear this on your pocket and put medipens into it."
	icon_state = "medpack2"
	inhand_icon_state = "medpack2"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/First_aid_l2/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 7
	STR.set_holdable(list(/obj/item/reagent_containers/hypospray/medipen))

/obj/item/storage/First_aid_l2/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)

/obj/item/storage/engi_pouch
	name = "Engineering Pouch"
	desc = "You wear this on your pocket and put sandbags and rcorp pistols into it."
	icon_state = "engi_pouch"
	inhand_icon_state = "engi_pouch"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/engi_pouch/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 2
	STR.set_holdable(list(/obj/item/stack/sheet/mineral/sandbags,
		/obj/item/gun/energy/e_gun/rabbitdash/small,
		))

/obj/item/storage/engi_pouch/PopulateContents()
	new /obj/item/gun/energy/e_gun/rabbitdash/small/tiny(src)
	new /obj/item/stack/sheet/mineral/sandbags/ten(src)


/obj/item/storage/pcorp_pocket/rcorp
	name = "R-Corp tactical pocket"
	desc = "Put onto your pocket to hold any 3 small items."
	icon_state = "tacpouch"
	inhand_icon_state = "tacpouch"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/pcorp_pocket/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 3

/obj/item/storage/pcorp_weapon/rcorp
	name = "R-Corp Small Weapon Holster"
	desc = "Put onto your pocket to hold any small EGO weapon."
	icon_state = "rweapon"
	inhand_icon_state = "rweapon"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/rcorp_command
	name = "R-Corp Command holster"
	desc = "Put onto your pocket to hold any small EGO weapon, and up to 2 other items."
	icon_state = "command_pouch"
	inhand_icon_state = "command_pouch"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/rcorp_command/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 8
	STR.set_holdable(GLOB.small_ego)

/obj/item/storage/rcorp_grenade
	name = "R-Corp Grenade pouch"
	desc = "Put onto your pocket to hold up to 5 grenades."
	icon_state = "grenade_pouch"
	inhand_icon_state = "grenade_pouch"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/rcorp_grenade/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_combined_w_class = 32
	STR.set_holdable(/obj/item/grenade/r_corp)
