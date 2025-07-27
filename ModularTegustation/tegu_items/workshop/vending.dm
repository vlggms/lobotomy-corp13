/obj/machinery/vending/forge
	name = "\improper Tres Delivery vending"
	desc = "A machine used to get metal and mods from Tres Association."
	product_slogans = "Come get your metal!!"
	product_ads = "The best in the business!"
	icon_state = "generic" //Placeholder
	icon_deny = null
	products = list(
		/obj/item/tresmetal = 300,
		/obj/item/workshop_mod/regular/red = 99,
		/obj/item/workshop_mod/fast/red = 99,
		/obj/item/workshop_mod/slow/red = 99,
		/obj/item/workshop_mod/throwforce/red = 99,
		/obj/item/workshop_mod/aoe/red = 99,
		//White
		/obj/item/workshop_mod/regular/white = 99,
		/obj/item/workshop_mod/fast/white = 99,
		/obj/item/workshop_mod/slow/white = 99,
		/obj/item/workshop_mod/throwforce/white = 99,
		/obj/item/workshop_mod/aoe/white = 99,
		//Black
		/obj/item/workshop_mod/regular/black = 99,
		/obj/item/workshop_mod/fast/black = 99,
		/obj/item/workshop_mod/slow/black = 99,
		/obj/item/workshop_mod/throwforce/black = 99,
		/obj/item/workshop_mod/aoe/black = 99,
		//GACHA BABY
		/obj/structure/lootcrate/tres = 99,
	)

	premium = list(
		//The pale stuff
		/obj/item/workshop_mod/regular/pale = 5,
		/obj/item/workshop_mod/fast/pale = 5,
		/obj/item/workshop_mod/slow/pale = 5,
		/obj/item/workshop_mod/throwforce/pale = 5,
		/obj/item/workshop_mod/aoe/pale = 5,

		//And the healing stuff
		/obj/item/workshop_mod/healing/red = 5,
		/obj/item/workshop_mod/healing/white = 5,
		/obj/item/workshop_mod/healing/black = 5,
		/obj/item/workshop_mod/sapping/red = 5,
		/obj/item/workshop_mod/sapping/white = 5,
		/obj/item/workshop_mod/sapping/black = 5,
		/obj/item/workshop_mod/curing/red = 5,
		/obj/item/workshop_mod/curing/white = 5,
		/obj/item/workshop_mod/curing/black = 5,

		//Combat
		/obj/item/workshop_mod/aoe/large/red = 5,
		/obj/item/workshop_mod/aoe/large/white = 5,
		/obj/item/workshop_mod/aoe/large/black = 5,
		/obj/item/workshop_mod/sharp/red = 5,
		/obj/item/workshop_mod/sharp/white = 5,
		/obj/item/workshop_mod/sharp/black = 5,
		/obj/item/workshop_mod/split/redpale = 1,
		/obj/item/workshop_mod/split/whiteblack = 1,

	)

	default_price = 150
	extra_price = 500
	input_display_header = "Tres Vending"
