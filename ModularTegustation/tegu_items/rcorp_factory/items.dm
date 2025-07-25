/obj/item/storage/First_aid_l1
	name = "First Aid Kit L1"
	desc = "You wear this on your pocket and put medipens into it."
	icon_state = "medpack"
	inhand_icon_state = "medpack"
	slot_flags = ITEM_SLOT_POCKETS
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
	list_reagents = list(/datum/reagent/medicine/mental_stabilizator = 15, /datum/reagent/medicine/sal_acid = 15)


/obj/item/storage/First_aid_l2
	name = "First Aid Kit L2"
	desc = "You wear this on your pocket and put medipens into it."
	icon_state = "medpack2"
	inhand_icon_state = "medpack2"
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
