/obj/item/stack/fish_points
	name = "fish points"
	singular_name = "fish point"
	desc = "Brass pebbles that are used as a special currency by fishers."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "brassball"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 1
	max_amount = 1000
	grind_results = list(/datum/reagent/copper = 3, /datum/reagent/iron = 1)
	merge_type = /obj/item/stack/fish_points

/obj/item/stack/fish_points/fifty
	icon_state = "brassball_2"
	amount = 50

/obj/item/stack/fish_points/hundred
	icon_state = "brassball_2"
	amount = 100

/obj/item/stack/fish_points/thousand
	icon_state = "brassball_2"
	amount = 1000
