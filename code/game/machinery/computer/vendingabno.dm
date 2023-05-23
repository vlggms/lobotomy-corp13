#define CAT_LCORP 1
#define CAT_BODHICHICKEN 2
#define CAT_UCORP 3
#define CAT_HAMHAMPANGPANG 4
#define CAT_NCORP 5
#define CAT_EXTRA 6
//VENDING CODE uses a altered form of CONSOLE CODE which is an altered form of mining_vendor
//TODO: Replace all mentions of Catagory with Category.

/obj/machinery/computer/vending_abno
	name = "I Want To Be Helpful"
	desc = "A strange refrigerator with a rabbit head on top of it. It can be used to purchase food at the expense of ahn."
	icon = 'icons/obj/machines/vendingabno.dmi'
	resistance_flags = INDESTRUCTIBLE
	var/selected_level = CAT_LCORP
	var/ahnstored = 0
	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		//LCorp - Lots of normal vending machine stuff, and some L-Corp specific foods as well

		new /datum/data/vending_abno("City Cola ",							/obj/item/reagent_containers/food/drinks/soda_cans/cola,						30, CAT_LCORP) = 1,
		new /datum/data/vending_abno("Outskirts Wind ",						/obj/item/reagent_containers/food/drinks/soda_cans/outskirts_wind,				50, CAT_LCORP) = 1,
		new /datum/data/vending_abno("Starkist ",							/obj/item/reagent_containers/food/drinks/soda_cans/starkist,					50, CAT_LCORP) = 1,
		new /datum/data/vending_abno("BongBong Bread ",						/obj/item/food/bread/bongbread,													10000, CAT_LCORP) = 1,

		//Bodhisattva Chicken - Expensive delicacies and ornate goods.

		new /datum/data/vending_abno("Bodhisattva Signature Chicken ",		/obj/item/food/meat/slab/chicken,												80, CAT_BODHICHICKEN) = 1,
		new /datum/data/vending_abno("Gourmet Chicken Nugget ",				/obj/item/food/nugget,															30, CAT_BODHICHICKEN) = 1,
		new /datum/data/vending_abno("Delicious Milo Soup ",				/obj/item/food/soup/milo,														220, CAT_BODHICHICKEN) = 1,

		//U Corp - Lots of materials and tools for cooking

		new /datum/data/vending_abno("Genuine Meat ",						/obj/item/food/meat/human,														40, CAT_UCORP) = 1,
		new /datum/data/vending_abno("Imitation Carp ",						/obj/item/food/carpmeat/imitation,												80, CAT_UCORP) = 1,
		new /datum/data/vending_abno("Bag of Flour ",						/obj/item/reagent_containers/food/condiment/flour,								90, CAT_UCORP) = 1,
		new /datum/data/vending_abno("Bag of Sugar ",						/obj/item/reagent_containers/food/condiment/sugar,								125, CAT_UCORP) = 1,
		new /datum/data/vending_abno("Carton of Milk ",						/obj/item/reagent_containers/food/condiment/milk,								110, CAT_UCORP) = 1,
		new /datum/data/vending_abno("Carton of Soy Milk ",					/obj/item/reagent_containers/food/condiment/soymilk,							130, CAT_UCORP) = 1,

		//HamHamPangPang - Cheap food and good sandwiches

		new /datum/data/vending_abno("HHPP Standard ",						/obj/item/food/sandwich,														150, CAT_HAMHAMPANGPANG) = 1,
		new /datum/data/vending_abno("Toasted Sandwich ",					/obj/item/food/toastedsandwich,													150, CAT_HAMHAMPANGPANG) = 1,
		new /datum/data/vending_abno("Grilled Cheese ",						/obj/item/food/grilledcheese,													150, CAT_HAMHAMPANGPANG) = 1,
		new /datum/data/vending_abno("Jelly Sandwich ",						/obj/item/food/jellysandwich,													150, CAT_HAMHAMPANGPANG) = 1,
		new /datum/data/vending_abno("Jellied Toast ",						/obj/item/food/jelliedtoast,													150, CAT_HAMHAMPANGPANG) = 1,
		new /datum/data/vending_abno("Buttered Toast ",						/obj/item/food/butteredtoast,													150, CAT_HAMHAMPANGPANG) = 1,


		//NCorp - Inexpensive soups. Incredibly cheap and easy to get.

		new /datum/data/vending_abno("Standard Ration Soup ",				/obj/item/food/soup/tomato,														35, CAT_NCORP) = 1,
		new /datum/data/vending_abno("Sub-Standard Ration Soup ",			/obj/item/food/soup/wish,														5, CAT_NCORP) = 1,
		new /datum/data/vending_abno("Standardized Stew ",					/obj/item/food/soup/stew,														60, CAT_NCORP) = 1,
		new /datum/data/vending_abno("Mystery Soup ",						/obj/item/food/soup/mystery,													100, CAT_NCORP) = 1,

		//Extra - Bonus equipment and neat stuff that's more cosmetic than any of the other sections

		new /datum/data/vending_abno("Plushie Lootbox ",					/obj/item/plushgacha,															5000, CAT_EXTRA) = 1,
		new /datum/data/vending_abno("Hod Plushie ",						/obj/item/toy/plush/hod,														3000, CAT_EXTRA) = 1,
		new /datum/data/vending_abno("Pierre Plushie ",						/obj/item/toy/plush/pierre,														3000, CAT_EXTRA) = 1,

	)

//Everything below this you should test before finalizing -IP
/datum/data/vending_abno
	var/equipment_name = "ERROR"
	var/equipment_path = null
	var/cost = 0
	var/catagory = CAT_EXTRA

/datum/data/vending_abno/New(name, path, cost, catagory) //This is the weirdest code. Instantly create a datum by defining it in the above list.
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost
	src.catagory = catagory

/obj/machinery/computer/vending_abno/ui_interact(mob/user) //Unsure if this can stand on its own as a structure, later on we may fiddle with that to break out of computer variables. -IP
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "[ahnstored] Ahn <br>"
	for(var/level = CAT_LCORP to CAT_EXTRA) //IF YOU ADD A NEW CATAGORY GO FROM FIRST DEFINED CATAGORY TO LAST TO AVOID BREAKAGE  -IP
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[name_catagory(level)]</u></b>" : "[name_catagory(level)]"]</A>"
	dat += "<br>"
	for(var/datum/data/vending_abno/A in order_list)
		if(A.catagory != selected_level)
			continue
		dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] Ahn)</A><br>"
	var/datum/browser/popup = new(user, "extraction_cargo", "Cheemsburmger", 660, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/vending_abno/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["set_level"])
			var/level = text2num(href_list["set_level"])
			if(!(level < CAT_LCORP || level > CAT_EXTRA) && level != selected_level)
				selected_level = level
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE
		if(href_list["purchase"])
			var/datum/data/vending_abno/product_datum = locate(href_list["purchase"]) in order_list //The href_list returns the individual number code and only works if we have it in the first column. -IP
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(ahnstored < product_datum.cost)
				to_chat(usr, "<span class='warning'>Not enough Ahn stored for this operation.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			new product_datum.equipment_path(get_turf(src))
			ahnstored = ahnstored - 1 * product_datum.cost
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

obj/machinery/computer/vending_abno/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		ahnstored += H.credits
		to_chat(user, "<span class='notice'>You insert the ahn into [src].</span>")
		update_icon()
		qdel(H)



/obj/machinery/computer/vending_abno/proc/name_catagory(cat) //for each catagory please place the number its defined as -IP
	switch(cat)
		if(1)
			return "LCorp"
		if(2)
			return "Bodhisavatta Chicken"
		if(3)
			return "U Corp"
		if(4)
			return "HamHamPangPang"
		if(5)
			return "N Corp"
		if(6)
			return "Extra"


#undef CAT_LCORP
#undef CAT_BODHICHICKEN
#undef CAT_UCORP
#undef CAT_HAMHAMPANGPANG
#undef CAT_NCORP
#undef CAT_EXTRA
