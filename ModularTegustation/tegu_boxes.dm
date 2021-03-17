/obj/item/storage/box/stockparts/dna_manip
	name = "dna manipulator assembly box"
	desc = "Contains everything you need to build a DNA manipulator."

/obj/item/storage/box/stockparts/dna_manip/PopulateContents()
	var/static/items_inside = list(
		/obj/item/circuitboard/machine/plantgenes = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/scanning_module = 1)
	generate_items_inside(items_inside,src)
