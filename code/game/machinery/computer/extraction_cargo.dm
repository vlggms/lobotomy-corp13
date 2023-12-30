#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor

/obj/machinery/computer/extraction_cargo
	name = "corporate trade console"
	desc = "Used to purchase supplies at the expense of energy."
	icon_screen = "supply"
	resistance_flags = INDESTRUCTIBLE
	var/selected_level = CAT_GADGET

	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		//Gadgets - More Technical Equipment, Usually active
		new /datum/data/extraction_cargo("Barrier Grenade Kit ",		/obj/item/storage/box/barrier,										60, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Forcefield Projector ",		/obj/item/forcefield_projector,										150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Tracking Implant Kit ", 		/obj/item/storage/box/minertracker,									150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Command Projector ",			/obj/item/commandprojector,											150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("'DEEPSCAN' Kit ",				/obj/item/deepscanner,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Qliphoth Field Projector ",	/obj/item/powered_gadget/slowingtrapmk1,							150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Regenerator Augmentor ",		/obj/item/safety_kit,												150, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Drain Monitor ",				/obj/item/powered_gadget/detector_gadget/abnormality,				200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Keen-Sense Rangefinder ",		/obj/item/powered_gadget/detector_gadget/ordeal,					200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("EMAIS	Capacity Upgrade ",		/obj/item/hypo_upgrade/cap_increase,								200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Prototype Enkephalin Injector ",/obj/item/powered_gadget/enkephalin_injector,						200, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Instant Clerkbot Constructor ",/obj/item/clerkbot_gadget,							250, CAT_GADGET) = 1,
		//new /datum/data/extraction_cargo("C-Fear Protection Injector ",	/obj/item/trait_injector/clerk_fear_immunity_injector,			300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Handheld Taser",				/obj/item/powered_gadget/handheld_taser,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Vitals Projector ",			/obj/item/powered_gadget/vitals_projector,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Shrimp Injector ",			/obj/item/trait_injector/shrimp_injector,							300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("EMAIS	Autoinjector ",			/obj/item/reagent_containers/hypospray/emais,						300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("W-Corp Teleporter ",			/obj/item/powered_gadget/teleporter,								300, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Officer Upgrade Injector ",	/obj/item/trait_injector/officer_upgrade_injector,					400, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Meson Scanner Goggles ",		/obj/item/clothing/glasses/meson,									500, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Gar Meson Scanner Goggles ",	/obj/item/clothing/glasses/meson/gar,								600, CAT_GADGET) = 1,
		new /datum/data/extraction_cargo("Agent Work Chance Injector ",	/obj/item/trait_injector/agent_workchance_trait_injector,			700, CAT_GADGET) = 1,

		//Equipment - Passive equipment, or less technical stuff.
		new /datum/data/extraction_cargo("'Seclite' Flashlight ",		/obj/item/flashlight/seclite,										30, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Hunting Knife ",				/obj/item/kitchen/knife/hunting,									30, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Throwing Bola ",				/obj/item/restraints/legcuffs/bola,									50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("EGO Small Arms Belt ",		/obj/item/storage/belt/ego,											50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Nitrile Gloves ",				/obj/item/clothing/gloves/color/latex/nitrile,						50, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Combat Webbing ",				/obj/item/storage/belt/military,									60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("EZ Light Replacer ",			/obj/item/lightreplacer,											60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Toolbox ",					/obj/item/storage/toolbox/mechanical,								60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Push Broom ",					/obj/item/pushbroom,												60, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Super Power Cell ",			/obj/item/stock_parts/cell/super,									150, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Megaphone ",					/obj/item/megaphone,												150, CAT_EQUIP) = 1,
		new /datum/data/extraction_cargo("Binoculars ",					/obj/item/binoculars,												200, CAT_EQUIP) = 1,

		//Medical
		new /datum/data/extraction_cargo("Epinepherine Medi-Pen ",		/obj/item/reagent_containers/hypospray/medipen,						40, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Sal-Acid Medi-Pen ",			/obj/item/reagent_containers/hypospray/medipen/salacid,				50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Mental-Stabilizer Medi-Pen ",	/obj/item/reagent_containers/hypospray/medipen/mental,				50, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Standard First-Aid Kit ",		/obj/item/storage/firstaid/regular,									250, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Naked Nest Cure Vial ",		/obj/item/serpentspoison,											400, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Orange Tree Flamer",			/obj/item/gun/ego_gun/flammenwerfer,								500, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Prosthetic Limb Crate ",		/obj/structure/closet/crate/freezer/surplus_limbs,					500, CAT_MEDICAL) = 1,
		new /datum/data/extraction_cargo("Assorted Medi-Pen Kit ",		/obj/item/storage/firstaid/revival,									500, CAT_MEDICAL) = 1,

		//Resources - Raw PE, ETC. Abnochem stuff goes here too. This is one use items to further LC13 systems
		new /datum/data/extraction_cargo("Blue Filter ",				/obj/item/refiner_filter/blue,										10, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Green Filter ",				/obj/item/refiner_filter/green,										10, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Red Filter ",					/obj/item/refiner_filter/red,										10, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Yellow Filter ",				/obj/item/refiner_filter/yellow,									10, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Raw PE Box ",					/obj/item/rawpe,													50, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Abnormality Chemistry Pack ",	/obj/structure/closet/crate/science/abnochem_startercrate,			100, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Chemical Extraction Upgrade ",/obj/item/chemical_extraction_attachment,							150, CAT_RESOURCE) = 1,
		new /datum/data/extraction_cargo("Mysterious Invitation ",		/obj/item/invitation,												1500, CAT_RESOURCE) = 1,

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
		new /datum/data/extraction_cargo("Gold Fishing Hook ",			/obj/item/fishing_component/hook/shiny,										200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Reinforced Fishing Line ",	/obj/item/fishing_component/line/reinforced,									200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("1000 Ahn ",					/obj/item/stack/spacecash/c1000,									200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Pet Whistle",					/obj/item/pet_whistle,												200, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Margherita Pizza ",			/obj/item/food/pizza/margherita,									300, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Super Gar Glasses ",			/obj/item/clothing/glasses/sunglasses/gar/supergar,					500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Agent Captain's Cloak ",		/obj/item/clothing/neck/cloak/hos/agent,							500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Agent Captain's Cap ",		/obj/item/clothing/head/hos/agent,									500, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Plushie Lootbox",				/obj/item/plushgacha,												1000, CAT_OTHER) = 1,
		new /datum/data/extraction_cargo("Binah Doll ",					/obj/item/toy/plush/binah,											1000, CAT_OTHER) = 1,


	)

//Everything below this you should test before finalizing -IP
/datum/data/extraction_cargo
	var/equipment_name = "ERROR"
	var/equipment_path = null
	var/cost = 0
	var/catagory = CAT_OTHER

/datum/data/extraction_cargo/New(name, path, cost, catagory) //This is the weirdest code. Instantly create a datum by defining it in the above list.
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost
	src.catagory = catagory

/obj/machinery/computer/extraction_cargo/ui_interact(mob/user) //Unsure if this can stand on its own as a structure, later on we may fiddle with that to break out of computer variables. -IP
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "Available PE: [SSlobotomy_corp.available_box] <br>"
	if(SSlobotomy_corp.box_goal != 0)
		if(SSlobotomy_corp.goal_reached)
			dat += "PE Quota has been reached, well done!<br>"
		else
			dat += "Goal Progress: [max(SSlobotomy_corp.available_box+SSlobotomy_corp.goal_boxes, 0)]/[SSlobotomy_corp.box_goal] <br>"
	else
		dat += "Today's PE Quota is still being calculated, please hold. <br>"
	for(var/level = CAT_GADGET to CAT_OTHER) //IF YOU ADD A NEW CATAGORY GO FROM FIRST DEFINED CATAGORY TO LAST TO AVOID BREAKAGE  -IP
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[name_catagory(level)]</u></b>" : "[name_catagory(level)]"]</A>"
	dat += "<br>"
	for(var/datum/data/extraction_cargo/A in order_list)
		if(A.catagory != selected_level)
			continue
		dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] PE)</A><br>"
	var/datum/browser/popup = new(user, "extraction_cargo", "L Corp Energy Trade", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/extraction_cargo/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["set_level"])
			var/level = text2num(href_list["set_level"])
			if(!(level < CAT_GADGET || level > CAT_OTHER) && level != selected_level)
				selected_level = level
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE
		if(href_list["purchase"])
			var/datum/data/extraction_cargo/product_datum = locate(href_list["purchase"]) in order_list //The href_list returns the individual number code and only works if we have it in the first column. -IP
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(SSlobotomy_corp.available_box < product_datum.cost)
				to_chat(usr, "<span class='warning'>Not enough PE boxes stored for this operation.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			new product_datum.equipment_path(get_turf(src))
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * product_datum.cost)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

/obj/machinery/computer/extraction_cargo/proc/name_catagory(cat) //for each catagory please place the number its defined as -IP
	switch(cat)
		if(1)
			return "Gadget"
		if(2)
			return "Equipment"
		if(3)
			return "Medical"
		if(4)
			return "Resources"
		if(5)
			return "Misc"


#undef CAT_GADGET
#undef CAT_EQUIP
#undef CAT_MEDICAL
#undef CAT_RESOURCE
#undef CAT_OTHER
