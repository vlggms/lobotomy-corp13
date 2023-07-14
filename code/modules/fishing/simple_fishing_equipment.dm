//There is a Fish bag in bags.dm for anyone porting this anywhere.

// Reels
/obj/item/fishing_line
	name = "fishing line reel"
	desc = "Simple fishing line."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_blue"
	var/fishin_value = 100
	var/line_color = "#808080"

/obj/item/fishing_line/reinforced
	name = "reinforced fishing line reel"
	desc = "Essential for fishing in extreme environments."
	icon_state = "reel_green"
	fishin_value = 400
	line_color = "#2b9c2b"

/obj/item/fishing_line/sinew
	name = "fishing sinew"
	desc = "An all-natural fishing line made of stretched out sinew."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_sinew"
	fishin_value = 200
	line_color = "#d1cca3"

/datum/crafting_recipe/sinew_line
	name = "Sinew Fishing Line Reel"
	result = /obj/item/fishing_line/sinew
	reqs = list(/obj/item/stack/sheet/sinew = 2)
	time = 2 SECONDS
	category = CAT_MISC

// Hooks

/obj/item/fishing_hook
	name = "simple fishing hook"
	desc = "A simple fishing hook."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "hook"
	w_class = WEIGHT_CLASS_TINY
	var/fishin_value = 100
	/// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"

/obj/item/fishing_hook/shiny
	name = "shiny lure hook"
	icon_state = "gold_shiny"
	rod_overlay_icon_state = "hook_shiny_overlay"
	fishin_value = 500

/obj/item/fishing_hook/weighted
	name = "weighted hook"
	icon_state = "weighted"
	fishin_value = 300
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing_hook/bone
	name = "bone hook"
	desc = "a simple hook carved from sharpened bone"
	icon_state = "hook_bone"
	fishin_value = 200

/datum/crafting_recipe/bone_hook
	name = "Bone Hook"
	result = /obj/item/fishing_hook/bone
	reqs = list(/obj/item/stack/sheet/bone = 1)
	time = 2 SECONDS
	category = CAT_MISC

/obj/item/storage/box/fishing
	name = "simple fishin tacklebox"
	desc = "Contains everything you need for your fishing trip."
	icon_state = "plasticbox"
	material_flags = NONE

/obj/item/storage/box/fishing/PopulateContents()
	. = ..()
	new /obj/item/simple_fishing_rod(src)
	new /obj/item/fishing_hook(src)
	new /obj/item/fishing_line(src)
	new /obj/item/storage/bag/fish(src)
	new /obj/item/simple_fishing_net(src)

//FISHING POINTS
/obj/item/stack/fish_points
	name = "fish points"
	singular_name = "fish point"
	desc = "Brass pebbles that are used as a special currency by fishers."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "brassball"
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	amount = 1
	max_amount = 1000
	grind_results = list(/datum/reagent/copper = 3, /datum/reagent/iron = 1)
	merge_type = /obj/item/stack/fish_points

/obj/item/stack/fish_points/fifty
	icon_state = "brassball_2"
	amount = 50

/obj/item/stack/fish_points/hundred
	icon_state = "brassball_2"
	amount = 100

/obj/item/stack/fish_points/thousand
	icon_state = "brassball_2"
	amount = 1000

/**********************Fishing Equipment Vendor**************************/

/obj/machinery/fish_market
	name = "fishing equipment vendor"
	desc = "A machine filled with brass pebbles. It appears that a fisher can exchange fish for brass pebbles here."
	icon = 'icons/obj/money_machine.dmi'
	icon_state = "bogdanoff"
	density = TRUE
	var/fish_points = 0

	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		//Gadgets - More Technical Equipment, Usually active
		new /datum/data/extraction_cargo("1 Ahn ",						/obj/item/stack/spacecash/c1,										100) = 1,
		new /datum/data/extraction_cargo("Discount Quality Suture ",	/obj/item/stack/medical/suture/emergency,							100) = 1,
		new /datum/data/extraction_cargo("Aquarium Rocks ",				/obj/item/aquarium_prop/rocks,										250) = 1,
		new /datum/data/extraction_cargo("Aquarium Seaweed ",			/obj/item/aquarium_prop/seaweed,									250) = 1,
		new /datum/data/extraction_cargo("Fishin Starting Pack ",		/obj/item/storage/box/fishing,										450) = 1,
		new /datum/data/extraction_cargo("Weighted Fishing Hook ", 		/obj/item/fishing_hook/weighted,									500) = 1,
		new /datum/data/extraction_cargo("Reinforced Fishing Line ", 	/obj/item/fishing_line/reinforced,									500) = 1,
		new /datum/data/extraction_cargo("Fishing Hat ",		 		/obj/item/clothing/head/beret/tegu/fishing_hat,						500) = 1,
		new /datum/data/extraction_cargo("Aquarium Branch Office ",		/obj/item/aquarium_prop/lcorp,										500) = 1,
		//Yes we are scamming you.
		new /datum/data/extraction_cargo("Shiny Fishing Hook ", 		/obj/item/fishing_hook/shiny,										1500) = 1,
	)

/obj/machinery/fish_market/ui_interact(mob/user) //Unsure if this can stand on its own as a structure, later on we may fiddle with that to break out of computer variables. -IP
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "[fish_points] FISH POINTS!!! <br>"
	dat += " <A href='byond://?src=[REF(src)];RedeemPoints=[REF(src)]'>Redeem Points</A><br>"
	for(var/datum/data/extraction_cargo/A in order_list)
		dat += " <A href='byond://?src=[REF(src)];purchase=[REF(A)]'>[A.equipment_name]([A.cost] Points)</A><br>"
	var/datum/browser/popup = new(user, "FishingVendor", "FishingVendor", 440, 640)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/fish_market/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		if(href_list["purchase"])
			var/datum/data/extraction_cargo/product_datum = locate(href_list["purchase"]) in order_list //The href_list returns the individual number code and only works if we have it in the first column. -IP
			if(!product_datum)
				to_chat(usr, "<span class='warning'>ERROR.</span>")
				return FALSE
			if(fish_points < product_datum.cost)
				to_chat(usr, "<span class='warning'>Yer lackin some points there lad.</span>")
				playsound(get_turf(src), 'sound/machines/terminal_prompt_deny.ogg', 50, TRUE)
				return FALSE
			new product_datum.equipment_path(get_turf(src))
			AdjustPoints(-1 * product_datum.cost)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
		if(href_list["RedeemPoints"])
			RedeemPoints()
			playsound(get_turf(src), 'sound/machines/machine_vend.ogg', 10, TRUE)
			updateUsrDialog()
			return TRUE

/obj/machinery/fish_market/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/fish_points))
		var/obj/item/stack/fish_points/more_points = I
		AdjustPoints(more_points.amount)
		qdel(I)
		return
	if(istype(I, /obj/item/food/fish))
		AdjustPoints(1)
		qdel(I)
		return
	if(istype(I, /obj/item/fishing_hook/bone))
		AdjustPoints(5)
		to_chat(user, "<span class='notice'>Thank you for notifying us of this object. 5 point reward.</span>")
		playsound(get_turf(src), 'sound/machines/machine_vend.ogg', 10, TRUE)
		qdel(I)
		return
	if(istype(I, /obj/item/storage/bag/fish))
		var/obj/item/storage/bag/fish/bag = I
		var/fish_value = 0
		for(var/obj/item/food/fish/F in bag.contents)
			fish_value ++
			qdel(F)
		AdjustPoints(fish_value)
	return ..()

/obj/machinery/fish_market/proc/RedeemPoints()
	if(fish_points < 1)
		return
	for(var/your_points = 1 to 5)
		if(fish_points >= 1000)
			fish_points -= 1000
			new /obj/item/stack/fish_points/thousand(get_turf(src))
		if(fish_points <= 1000)
			var/obj/item/stack/fish_points/modify_points = new /obj/item/stack/fish_points(get_turf(src))
			modify_points.amount = fish_points
			fish_points -= fish_points
		if(fish_points <= 0)
			break
	return

/obj/machinery/fish_market/proc/AdjustPoints(new_points)
	fish_points += new_points
