/obj/item/storage/First_aid_l1
	name = "First Aid Kit L1"
	desc = "You wear this on your pocket and put items into it."
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
	STR.max_items = 3
	STR.set_holdable(list(/obj/item/reagent_containers/hypospray/medipen))

/obj/item/storage/First_aid_l1/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)
	new /obj/item/reagent_containers/hypospray/medipen/dual(src)

/obj/item/reagent_containers/hypospray/medipen/dual
	name = "Double Healing Pen"
	list_reagents = list(/datum/reagent/medicine/mental_stabilizator = 15, /datum/reagent/medicine/sal_acid = 15)
