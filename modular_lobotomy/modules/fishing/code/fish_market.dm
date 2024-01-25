/obj/machinery/fish_market
	name = "fishing equipment vendor"
	desc = "A machine filled with brass pebbles. It appears that a fisher can exchange fish for brass pebbles here."
	icon = 'icons/obj/money_machine.dmi'
	icon_state = "bogdanoff"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/fish_points = 0

	var/list/order_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		//Gadgets - More Technical Equipment, Usually active
		new /datum/data/extraction_cargo("Discount Quality Suture ",	/obj/item/stack/medical/suture/emergency,			100) = 1,
		new /datum/data/extraction_cargo("Fishin Starting Pack ",		/obj/item/storage/box/fishing,						200) = 1,
		new /datum/data/extraction_cargo("Aquarium Rocks ",				/obj/item/aquarium_prop/rocks,						250) = 1,
		new /datum/data/extraction_cargo("Aquarium Seaweed ",			/obj/item/aquarium_prop/seaweed,					250) = 1,
		new /datum/data/extraction_cargo("Sinew Fishing Line ",			/obj/item/fishing_component/line/sinew,				250) = 1,
		new /datum/data/extraction_cargo("Bone Fishing Hook ",			/obj/item/fishing_component/hook/bone,				250) = 1,
		new /datum/data/extraction_cargo("Water Sprayer Backpack ",		/obj/item/watertank,								400) = 1,
		new /datum/data/extraction_cargo("Dock Worker Lantern ",		/obj/item/flashlight/lantern,						400) = 1,
		new /datum/data/extraction_cargo("Weighted Fishing Hook ", 		/obj/item/fishing_component/hook/weighted,			500) = 1,
		new /datum/data/extraction_cargo("Reinforced Fishing Line ", 	/obj/item/fishing_component/line/reinforced,		500) = 1,
		new /datum/data/extraction_cargo("Fishing Hat ",		 		/obj/item/clothing/head/beret/fishing_hat,			500) = 1,
		new /datum/data/extraction_cargo("Aquarium Branch Office ",		/obj/item/aquarium_prop/lcorp,						500) = 1,
		new /datum/data/extraction_cargo("Tier 1 Fishing Rod ",			/obj/item/fishing_rod/tier1,						500) = 1,
		//Yes we are scamming you.
		new /datum/data/extraction_cargo("Shiny Fishing Hook ", 		/obj/item/fishing_component/hook/shiny,				1000) = 1,
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
				to_chat(usr, span_warning("ERROR."))
				return FALSE
			if(fish_points < product_datum.cost)
				to_chat(usr, span_warning("Yer lackin some points there lad."))
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
		AdjustPoints(ValueFish(I))
		qdel(I)
		return
	if(istype(I, /obj/item/fishing_component/hook/bone))
		AdjustPoints(5)
		to_chat(user, span_notice("Thank you for notifying us of this object. 5 point reward."))
		playsound(get_turf(src), 'sound/machines/machine_vend.ogg', 10, TRUE)
		qdel(I)
		return
	if(istype(I, /obj/item/storage/bag/fish))
		var/obj/item/storage/bag/fish/bag = I
		var/fish_value = 0
		for(var/item in bag.contents)
			if(istype(item, /obj/item/fishing_component/hook/bone))
				fish_value += 5

			if(istype(item, /obj/item/food/fish))
				fish_value += ValueFish(item)

			else
				continue
			qdel(item)

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

/*Values Fish im too tired to add anything like
	size and weight considerations. Today was
	a long day, the rarity values are inverted because
	its 1000 for a basic fish and 1 for the most rare fish.-IP */
/obj/machinery/fish_market/proc/ValueFish(obj/item/food/fish/F)
	//Fish Value based on weight and size.
	var/fish_weight = (F.weight - F.average_weight) / F.average_weight
	var/fish_size = (F.size - F.average_size) / F.average_size
	var/fish_worth_mod = 1 + fish_weight + fish_size

	/*Fish Value based on rarity 2 is
		the worth of fish that are basic.*/
	var/fish_worth = 2
	switch(F.random_case_rarity)
		if(0 to FISH_RARITY_GOOD_LUCK_FINDING_THIS)
			fish_worth = 100
		if((FISH_RARITY_GOOD_LUCK_FINDING_THIS + 1) to FISH_RARITY_VERY_RARE)
			fish_worth = 50
		if((FISH_RARITY_VERY_RARE + 1) to FISH_RARITY_RARE)
			fish_worth = 10
	return round(fish_worth * fish_worth_mod)
