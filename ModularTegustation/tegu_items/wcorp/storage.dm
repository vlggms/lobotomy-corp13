/obj/item/storage/packet
	name = "w-corp emergency stims"
	desc = "You wear this on your back and put items into it."
	icon_state = "medpack"
	inhand_icon_state = "medpack"
	slot_flags = ITEM_SLOT_POCKETS
	resistance_flags = NONE
	max_integrity = 300

/obj/item/storage/packet/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 21
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 3

/obj/item/storage/packet/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/hypospray/medipen/mental(src)

