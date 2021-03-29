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

/obj/item/storage/box/stockparts/dna_manip_disks
	name = "plant data disk box"
	desc = "A box full of disks used to contain plant data, for use in DNA manipulator."

/obj/item/storage/box/stockparts/dna_manip_disks/PopulateContents()
	var/static/items_inside = list(
		/obj/item/disk/plantgene = 7)
	generate_items_inside(items_inside,src)
