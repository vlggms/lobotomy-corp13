/obj/item/storage/box/fishing
	name = "simple fishin tacklebox"
	desc = "Contains everything you need for your fishing trip."
	icon_state = "plasticbox"
	material_flags = NONE

/obj/item/storage/box/fishing/PopulateContents()
	. = ..()
	new /obj/item/fishing_rod(src)
	new /obj/item/fishing_component/line(src)
	new /obj/item/fishing_component/hook(src)
	new /obj/item/storage/bag/fish(src)
	new /obj/item/fishing_net(src)
	new /obj/item/book/granter/fish_skill(src)
