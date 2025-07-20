#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor


/obj/machinery/computer/extraction_cargo/discipline
	name = "disciplinary equipment console"
	icon_screen = "disciplinary_cargo"
	order_list = list(
		//Gadgets - Technical Equipment, active, that the Disc team could use.
		new /datum/data/extraction_cargo("Barrier Grenade Kit ",		/obj/item/storage/box/barrier,										60, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Forcefield Projector ",		/obj/item/forcefield_projector,										150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Tracking Implant Kit ", 		/obj/item/storage/box/minertracker,									150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Command Projector ",			/obj/item/commandprojector,											150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("'DEEPSCAN' Kit ",				/obj/item/deepscanner,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Qliphoth Field Projector ",	/obj/item/powered_gadget/slowingtrapmk1,							150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Regenerator Augmentor ",		/obj/item/safety_kit,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Drain Monitor ",				/obj/item/powered_gadget/detector_gadget/abnormality,				200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Keen-Sense Rangefinder ",		/obj/item/powered_gadget/detector_gadget/ordeal,					200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Prototype Enkephalin Injector ",/obj/item/powered_gadget/enkephalin_injector,						200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Handheld Taser",				/obj/item/powered_gadget/handheld_taser,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Vitals Projector ",			/obj/item/powered_gadget/vitals_projector,							300, CAT_GADGET) = 1,

		//Equipment - L-Corp Gear
		new /datum/data/extraction_cargo("L-Corp Baton Template ",			/obj/item/ego_weapon/city/lcorp/baton,								100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Machete Template " ,		/obj/item/ego_weapon/city/lcorp/machete,							100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Club Template ",			/obj/item/ego_weapon/city/lcorp/club,								100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Shield Template ",			/obj/item/ego_weapon/shield/lcorp_shield,							100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Pistol Template ",			/obj/item/ego_weapon/ranged/city/lcorp/pistol,						100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Machinepistol Template ",	/obj/item/ego_weapon/ranged/city/lcorp/automatic_pistol,			100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("L-Corp Armored Vest Template ",	/obj/item/clothing/suit/armor/ego_gear/city/lcorp_vest,				100, CAT_EQUIP) = 1,

		//Medical
		new /datum/data/extraction_cargo("Epinepherine Medi-Pen ",		/obj/item/reagent_containers/hypospray/medipen,						40, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Sal-Acid Medi-Pen ",			/obj/item/reagent_containers/hypospray/medipen/salacid,				50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Mental-Stabilizer Medi-Pen ",	/obj/item/reagent_containers/hypospray/medipen/mental,				50, CAT_MEDICAL) = 1,

		//Resources - This is for EGOshards

		//Combat pages are too evil rn. I'm working on a new system. - Kirie/Kitsunemitsu
		//new /datum/data/extraction_cargo("L1 Combat Page ",				/obj/item/combat_page/level1,					200, CAT_RESOURCE) = 1,
		//new /datum/data/extraction_cargo("L2 Combat Page ",				/obj/item/combat_page/level2,					400, CAT_RESOURCE) = 1,
		//new /datum/data/extraction_cargo("L3 Combat Page ",				/obj/item/combat_page/level3,					800, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 1 EGOSHARD (Red) ",		/obj/item/egoshard,								50, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 1 EGOSHARD (White) ",	/obj/item/egoshard/white,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 1 EGOSHARD (Black) ",	/obj/item/egoshard/black,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 2 EGOSHARD (Red) ",		/obj/item/egoshard/bad,							300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 2 EGOSHARD (White) ",	/obj/item/egoshard/bad/white,					300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 2 EGOSHARD (Black) ",	/obj/item/egoshard/bad/black,					300, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 3 EGOSHARD (Red) ",		/obj/item/egoshard/good,						400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 3 EGOSHARD (White) ",	/obj/item/egoshard/good/white,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 3 EGOSHARD (Black) ",	/obj/item/egoshard/good/black,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 3 EGOSHARD (Pale) ",		/obj/item/egoshard/good/pale,					400, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 4 EGOSHARD (Red) ",		/obj/item/egoshard/great,						900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 4 EGOSHARD (White) ",	/obj/item/egoshard/great/white,					900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 4 EGOSHARD (Black) ",	/obj/item/egoshard/great/black,					900, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Tier 4 EGOSHARD (Pale) ",		/obj/item/egoshard/great/pale,					900, CAT_RESOURCE) = 1,

		//Random stuff
		new /datum/data/extraction_cargo("Bubblegum Gum Packet ",		/obj/item/storage/box/gum/bubblegum,								15, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Cigar ",						/obj/item/clothing/mask/cigarette/cigar/havana,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Beer ",						/obj/item/reagent_containers/food/drinks/beer,						25, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Spraycan ",					/obj/item/toy/crayon/spraycan,										40, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Magic 8-Ball ",				/obj/item/toy/eightball,											70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Six-Pack ",					/obj/item/storage/cans,												70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Fishing Equipment ",			/obj/item/storage/box/fishing,										70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Whiskey ",					/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Absinthe ",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Skateboard ",					/obj/item/melee/skateboard,											100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Gar Glasses ",				/obj/item/clothing/glasses/sunglasses/gar,							100, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Skub ",						/obj/item/skub,														200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Mannequin ",					/obj/structure/mannequin,											200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Gold Fishing Hook ",			/obj/item/fishing_component/hook/shiny,								200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Reinforced Fishing Line ",	/obj/item/fishing_component/line/reinforced,						200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("1000 Ahn ",					/obj/item/stack/spacecash/c1000,									200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Pet Whistle",					/obj/item/pet_whistle,												200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Margherita Pizza ",			/obj/item/food/pizza/margherita,									300, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Super Gar Glasses ",			/obj/item/clothing/glasses/sunglasses/gar/supergar,					500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Agent Captain's Cloak ",		/obj/item/clothing/neck/cloak/hos/agent,							500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Agent Captain's Cap ",		/obj/item/clothing/head/hos/agent,									500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Plushie Lootbox",				/obj/item/plushgacha,												1000, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Binah Doll ",					/obj/item/toy/plush/binah,											1000, CAT_OTHER) = 1,


	)


#undef CAT_GADGET
#undef CAT_EQUIP
#undef CAT_MEDICAL
#undef CAT_RESOURCE
#undef CAT_OTHER
