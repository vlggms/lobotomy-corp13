/obj/machinery/vending/lobotomy_mining
	name = "\improper Site Recovery Equipment"
	desc = "A machine used by wings to explore the ruins of L corp"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "Strike the earth!"
	product_ads = "And my axe!"
	icon_state = "robotics"
	icon_deny = null
	products = list(
		/obj/item/safety_kit = 100,
		/obj/item/pickaxe/rusted = 10,
		/obj/item/pickaxe = 25,
		/obj/item/pickaxe/mini = 100,
		/obj/item/pickaxe/drill = 100,

		//advanced stuff
		/obj/item/storage/firstaid/regular = 100,
		/obj/item/flashlight/lantern = 10,
		/obj/item/pickaxe/silver = 100,
		/obj/item/pickaxe/diamond = 100,
		/obj/item/pickaxe/drill/diamonddrill = 15,
		/obj/item/pickaxe/drill/jackhammer = 5,

	)

	default_price = 100
	input_display_header = "Mining Equipment"
	var/list/company_products = list(//Wing-specifc pickaxes, flares, mostly flavor stuff.
		/obj/item/stat_equalizer/mining = 100,
		/obj/item/pickaxe/lcorp = 100,
		)

/obj/machinery/vending/lobotomy_mining/Initialize(mapload)
	products = (company_products + products)//we want the unique items at the top of the list
	return ..()

/obj/machinery/vending/lobotomy_combat
	name = "\improper Combat Equipment Vendor"
	desc = "A vendor commissioned by X corp for the exploration of hellholes. The concept is widely adopted throughout the city."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "It's dangerous to go alone! Take this!"
	product_ads = "You have my sword!"
	icon_state = "robotics"
	icon_deny = null
	products = list(
	/obj/item/flashlight/seclite = 100,
	/obj/item/radio/headset = 200,
	/obj/item/crowbar = 100,
	/obj/item/kitchen/knife/combat/survival = 100,
	/obj/item/weldingtool/mini = 100,
	/obj/item/reagent_containers/hypospray/medipen/mental = 100,
	/obj/item/reagent_containers/hypospray/medipen/salacid = 100,
	/obj/item/gps/fixer = 100,
	/obj/item/pinpointer/coordinate = 20,
	/obj/item/storage/firstaid/regular = 100,
	)

	var/list/company_products = list(//The bread and butter of ER gear. These are specific to subtypes.
		//Lobotomy Corporation gear
		/obj/item/abno_core_injector = 100,
		/obj/item/abno_core_injector/teth = 100,
		/obj/item/abno_core_injector/he = 15,
		/obj/item/abno_core_injector/waw = 5,

		//Egoshard Bases - More expensive than the above
		/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest = 100,
		/obj/item/ego_weapon/city/lcorp/baton = 100,
		/obj/item/ego_weapon/city/lcorp/machete = 100,
		/obj/item/ego_weapon/city/lcorp/club = 100,
		/obj/item/ego_weapon/shield/lcorp_shield = 100,

		//Egoshards
		/obj/item/egoshard = 100,//60 stats
		/obj/item/egoshard/white = 100,
		/obj/item/egoshard/black = 100,
		/obj/item/egoshard/bad = 100,//80 stats
		/obj/item/egoshard/bad/white = 100,
		/obj/item/egoshard/bad/black = 100,
		/obj/item/egoshard/good = 20,//100 stats
		/obj/item/egoshard/good/white = 20,
		/obj/item/egoshard/good/black = 20,
		/obj/item/egoshard/good/pale = 20,
		/obj/item/egoshard/great = 10,//120 stats
		/obj/item/egoshard/great/white = 10,
		/obj/item/egoshard/great/black = 10,
		/obj/item/egoshard/great/pale = 10,
	)

/obj/machinery/vending/lobotomy_combat/Initialize(mapload)
	products += company_products
	return ..()
