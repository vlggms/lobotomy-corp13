#define CAT_GADGET 1
#define CAT_EQUIP 2
#define CAT_MEDICAL 3
#define CAT_RESOURCE 4
#define CAT_OTHER 5
//CONSOLE CODE uses a altered form of mining_vendor

/obj/machinery/computer/extraction_cargo
	name = "corporate trade console"
	desc = "Used to purchase supplies at the expense of energy."
	icon_screen = "extraction_cargo"
	resistance_flags = INDESTRUCTIBLE
	var/selected_level = CAT_GADGET
	// TODO - get rid of all this shit. I need to convert this console into an upgrade panel and make one for each department.
	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
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

			//So we have to adjust the available boxes down but adjust the goal boxes up. Why?
			//Adjusting the available boxes adjusts the goal. This is just the best way to do it
			SSlobotomy_corp.AdjustAvailableBoxes(-1 * product_datum.cost) // PE boxes should not be a currency. TODO: Rework this to use LOB points instead. And no consumable items. This should be for faciltiy upgrades. -Cox
			if(!SSlobotomy_corp.goal_reached)	//Okay, funny bug, if you have your goal eached and add goal boxes, then it adds to available boxes.
				SSlobotomy_corp.AdjustGoalBoxes(product_datum.cost)		//Normal
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
