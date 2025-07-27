#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor


/obj/machinery/computer/extraction_cargo/chemistry
	name = "safety equipment console"
	icon_screen = "safety_cargo"
	order_list = list(
		//Gadgets - Technical Equipment, active, that helps the chemist do their job
		new /datum/data/extraction_cargo("Chemical Extraction Upgrade ",	/obj/item/work_console_upgrade/chemical_extraction_attachment,		120, CAT_GADGET) = 1,	//Cheaper here.

		//Equipment - Syringe Gun and such.
		new /datum/data/extraction_cargo("Spare Syringe",					/obj/item/reagent_containers/syringe,								3, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Syringe Gun",						/obj/item/gun/syringe,												100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Mini Syringe Gun",				/obj/item/gun/syringe/syndicate,									300, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Rapid Syringe Gun",				/obj/item/gun/syringe/rapidsyringe,									600, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Large Beaker ",					/obj/item/reagent_containers/glass/beaker/large,					10, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("XL Beaker ",						/obj/item/reagent_containers/glass/beaker/plastic,					100, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Metamaterial Beaker ",			/obj/item/reagent_containers/glass/beaker/meta,						300, CAT_EQUIP) = 1,

		//Medical - Raw beakers of medicine. Quite Expensive, as each bottle is 6 uses.
		new /datum/data/extraction_cargo("Mental-Stabilizer Bottle",	/obj/item/reagent_containers/glass/bottle/mental_stab,			200, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Salicylic Acid Bottle",		/obj/item/reagent_containers/glass/bottle/salacid,				200, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Protozine Bottle",			/obj/item/reagent_containers/glass/bottle/mental_stab,			200, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Omnizine Bottle",				/obj/item/reagent_containers/glass/bottle/salacid,				500, CAT_MEDICAL) = 1,

		//Resources - Raw bottles of sinchems; Somewhat expensive. cheaper to get yourself.
		new /datum/data/extraction_cargo("Liquid Wrath Bottle",		/obj/item/reagent_containers/glass/bottle/wrath,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Lust Bottle",		/obj/item/reagent_containers/glass/bottle/lust,							100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Sloth Bottle",		/obj/item/reagent_containers/glass/bottle/sloth,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Gluttony Bottle",	/obj/item/reagent_containers/glass/bottle/gluttony,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Gloom Bottle",		/obj/item/reagent_containers/glass/bottle/gloom,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Pride Bottle",		/obj/item/reagent_containers/glass/bottle/pride,						100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Liquid Envy Bottle",		/obj/item/reagent_containers/glass/bottle/envy,							100, CAT_RESOURCE) = 1,

		//Stuff for fishing up stuff, which does have chems in them.
		new /datum/data/extraction_cargo("Fishing Equipment ",			/obj/item/storage/box/fishing,										70, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Gold Fishing Hook ",			/obj/item/fishing_component/hook/shiny,								200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Reinforced Fishing Line ",	/obj/item/fishing_component/line/reinforced,						200, CAT_OTHER) = 1,


	)


#undef CAT_GADGET
#undef CAT_EQUIP
#undef CAT_MEDICAL
#undef CAT_RESOURCE
#undef CAT_OTHER
