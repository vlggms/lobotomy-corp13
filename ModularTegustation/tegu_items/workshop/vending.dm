/obj/machinery/vending/forge
	name = "\improper Tres Delivery vending"
	desc = "A machine used to get metal and mods from Tres Association."
	product_slogans = "Come get your metal!!"
	product_ads = "The best in the business!"
	icon_state = "generic" //Placeholder
	icon_deny = null
	products = list(/obj/item/tresmetal = 300,
					/obj/item/workshop_mod/regular/red = 99,
		            /obj/item/workshop_mod/fast/red = 99,
					/obj/item/workshop_mod/slow/red = 99,
					/obj/item/workshop_mod/throwforce/red = 99,
					//White
					/obj/item/workshop_mod/regular/white = 99,
					/obj/item/workshop_mod/fast/white = 99,
					/obj/item/workshop_mod/slow/white = 99,
					/obj/item/workshop_mod/throwforce/white = 99,
					//Black
					/obj/item/workshop_mod/regular/black = 99,
					/obj/item/workshop_mod/fast/black = 99,
					/obj/item/workshop_mod/slow/black = 99,
					/obj/item/workshop_mod/throwforce/black = 99,
					)

	premium = list(
			//The pale stuff
			/obj/item/workshop_mod/regular/pale = 5,
			/obj/item/workshop_mod/fast/pale = 5,
			/obj/item/workshop_mod/slow/pale = 5,
			/obj/item/workshop_mod/throwforce/pale = 5,
			//And the special stuff
			/obj/item/workshop_mod/sapping/red = 5,
			/obj/item/workshop_mod/healing/red = 5,
			/obj/item/workshop_mod/sapping/white = 5,
			/obj/item/workshop_mod/healing/white = 5,
			/obj/item/workshop_mod/sapping/black = 5,
			/obj/item/workshop_mod/healing/black = 5,
			)

	default_price = 200
	extra_price = 700
	input_display_header = "Tres Vending"
