/obj/machinery/vending/lobotomy_mining
	name = "\improper Site Recovery Equipment vendor"
	desc = "A machine used by wings to explore the ruins of L corp"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	product_slogans = "It's dangerous to go alone! Take this!"
	product_ads = "Buy my axe!"
	icon_state = "robotics"
	icon_deny = null
	products = list(
		/obj/item/safety_kit = 100,
		/obj/item/pickaxe/rusted = 10,
		/obj/item/pickaxe = 25,
		/obj/item/pickaxe/mini = 100,
		/obj/item/pickaxe/drill = 100,
		/obj/item/stat_equalizer/mining = 100,

		//Lobotomy Corporation gear
		/obj/item/abno_core_injector = 100,
		/obj/item/abno_core_injector/teth = 100,
		/obj/item/abno_core_injector/he = 15,
		/obj/item/abno_core_injector/waw = 5,

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
