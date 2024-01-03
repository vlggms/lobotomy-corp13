
/**
 *
 * Modular file containing: debug tools, for admins and coders alike
 *
 */

/**
 * Gives all fish
 */

/obj/item/storage/box/fish_debug
	name = "box full of fish"

/obj/item/storage/box/fish_debug/PopulateContents()
	for(var/fish in subtypesof(/obj/item/food/fish))
		new fish(src)

/**
 * Gives all lines and hooks
 */

/obj/item/storage/box/fish_things_debug
	name = "box full of hooks and lines"

/obj/item/storage/box/fish_things_debug/PopulateContents()
	for(var/items in subtypesof(/obj/item/fishing_component))
		new items(src)

/**
 * Gives all debug items
 */

/obj/item/storage/box/fish_debug_items
	name = "box of debug items"

/obj/item/storage/box/fish_debug_items/PopulateContents()
	new /obj/item/fishing_rod/debug(src)
	new /obj/item/storage/bag/fish/debug(src)
	new /obj/item/water_turf_spawner(src)

/**
 * Gives everything
 */

/obj/structure/closet/crate/debug_fishing
	name = "Debug fishing chest"

/obj/structure/closet/crate/debug_fishing/PopulateContents()
	new /obj/item/storage/box/fish_debug_items(src)
	new /obj/item/storage/box/fish_debug(src)
	new /obj/item/storage/box/fish_things_debug(src)
	new /obj/item/fishing_rod(src)
	new /obj/item/fishing_net(src)
	new /obj/item/storage/bag/fish(src)
