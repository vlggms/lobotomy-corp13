#define CAT_BOAT 1
#define CAT_SAILOR 2

//Works off of Extraction cargo code
/obj/machinery/computer/boat_shop
	name = "boat shop"
	desc = "A place to buy boats"
	icon_screen = "comm_logs"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/selected_level = CAT_BOAT
	var/list/dock = list()
	var/list/current_boats = list()
	var/list/order_list = list(
		new /datum/data/boat_shop("Skiff ", 		/obj/vehicle/sealed/adventure_boat/skiff,				150, CAT_BOAT) = 1,//150
		new /datum/data/boat_shop("Sloop ", 		/obj/vehicle/sealed/adventure_boat/sloop,				500, CAT_BOAT) = 1,//500

		new /datum/data/boat_shop("Fishhook Office Fixer ", 		/datum/sailor/noob,				0, CAT_SAILOR) = 1,//150
		new /datum/data/boat_shop("Crawdad Office Sailor ", 		/datum/sailor/basic,				500, CAT_SAILOR) = 1,//150
		new /datum/data/boat_shop("Eight Association Sailor ", 		/datum/sailor/pro,				2000, CAT_SAILOR) = 1,//2000
	)

/obj/machinery/computer/boat_shop/handle_atom_del(atom/A) // Update the UIs in case something inside gets deleted
	SStgui.update_uis(src)

/datum/data/boat_shop
	var/equipment_name = "ERROR"
	var/equipment_path = null
	var/cost = 0
	var/category = CAT_SAILOR

/datum/data/boat_shop/New(name, path, cost, category)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost
	src.category = category

/obj/machinery/computer/boat_shop/ui_interact(mob/user)
	if(!LAZYLEN(dock))
		for(var/obj/effect/boatspawn/B in range(8, src))
			dock += B
		say("Calibration complete.")
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	for(var/level = CAT_BOAT to CAT_SAILOR) //May add a third category - remember to append it to the end of this loop
		dat += "<A href='byond://?src=[REF(src)];set_level=[level]'>[level == selected_level ? "<b><u>[name_category(level)]</u></b>" : "[name_category(level)]"]</A>"
	dat += "<br>"
	for(var/datum/data/boat_shop/A in order_list)
		if(A.category != selected_level)
			continue
		dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] Ahn)</A><br>"
	var/datum/browser/popup = new(user, "boat shop", "Eight Association Shipyard", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/computer/boat_shop/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		if(href_list["set_level"])
			var/level = text2num(href_list["set_level"])
			if(!(level < CAT_BOAT || level > CAT_SAILOR) && level != selected_level)
				selected_level = level
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE
			return FALSE
		if(href_list["purchase"])
			var/obj/item/card/id/C
			var/mob/living/L = usr
			C = L.get_idcard(TRUE)
			var/datum/data/boat_shop/product_datum = locate(href_list["purchase"]) in order_list //The href_list returns the individual number code and only works if we have it in the first column. -IP
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			var/datum/bank_account/account = C.registered_account
			if(product_datum.cost && !account.adjust_money(-product_datum.cost))
				say("You do not possess the funds to purchase [product_datum].")
				return
			switch(product_datum.category)
				if(CAT_BOAT)
					spawn_ship(product_datum.equipment_path)
				if(CAT_SAILOR)
					if(!spawn_sailor(usr, product_datum.equipment_path))
						account.adjust_money(product_datum.cost)//refund if it fails to generate a sailor
						playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
						updateUsrDialog()
						return FALSE

			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

obj/machinery/computer/boat_shop/proc/spawn_ship(obj/vehicle/sealed/adventure_boat/picked_type)
	if(!LAZYLEN(GLOB.lobotomy_boats))
		say("There are too many boats at sea! Try later.")
	else
		say("The ship has been processed successfully. It can be found at the dock.")
		var/obj/effect/T = pick(dock)
		var/obj/vehicle/sealed/adventure_boat/myboat = new picked_type(get_turf(T))
		current_boats += myboat
		myboat.CheckCaptain(usr)

obj/machinery/computer/boat_shop/proc/spawn_sailor(mob/user, mob/living/simple_animal/hostile/sailor/picked_type)
	if(!LAZYLEN(current_boats))
		say("There are no boats currently available.")
		return FALSE
	else
		var/obj/vehicle/sealed/adventure_boat/chosen_boat = input(user,"Please select your ship") as null|anything in current_boats
		if(!chosen_boat)
			say("Please select the boat to which the sailor will guide.")
			return FALSE
		if(!chosen_boat.CheckCaptain(user))
			say("You are not the captain of the [chosen_boat]")
			return FALSE
		var/datum/sailor/new_sailor = new picked_type(chosen_boat.interior)
		chosen_boat.AddSailor(new_sailor)
		to_chat(user, "The [chosen_boat] will now be guided by a new sailor.")
	return TRUE

/obj/machinery/computer/boat_shop/proc/name_category(cat)
	switch(cat)
		if(1)
			return "Ship"
		if(2)
			return "Sailor"

#undef CAT_BOAT
#undef CAT_SAILOR
