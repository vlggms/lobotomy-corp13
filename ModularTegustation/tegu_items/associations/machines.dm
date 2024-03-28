/obj/structure/itemselling
	name = "item selling machine"
	desc = "A machine used to sell items to the greater city"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine2"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	var/list/level_0 = list(
		/obj/item/food/fish,
	)
	var/list/level_1 = list(
		/obj/item/food/meat/slab/sweeper,
		/obj/item/food/meat/slab/worm,
		/obj/item/food/meat/slab/robot,
		/obj/item/food/meat/slab/human/mutant/moth,
	)
	var/list/level_2 = list(
		/obj/item/clothing/suit/armor/ego_gear/city,
		/obj/item/ego_weapon/city,
		/obj/item/gun/ego_gun,
	)
	var/list/level_3 = list(
		/obj/item/raw_anomaly_core,
		/obj/item/documents,
		/obj/item/folder/syndicate,
		/obj/item/folder/documents,
	)

	/// Types that aren't listed with within examine.
	var/list/exclude_listing = list(
		/obj/item/clothing/suit/armor/ego_gear/city = "All Non-'Fixer Suit' Armor",
		/obj/item/ego_weapon/city = "All Non-'Workshop' Weapons",
		/obj/item/food/fish = "All Fish",
	)

/obj/structure/itemselling/Initialize()
	. = ..()
	SetSellables()

/obj/structure/itemselling/proc/SetSellables()
	var/list/temp = list()
	for(var/T in level_0)
		temp.Add(typecacheof(T))
	level_0 = temp.Copy()
	temp.Cut()
	for(var/T in level_1)
		temp.Add(typecacheof(T))
	level_1 = temp.Copy()
	temp.Cut()
	for(var/T in level_2)
		temp.Add(typecacheof(T))
	level_2 = temp.Copy()
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/misc))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/indigo_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/steel_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/amber_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/green_armor))
	temp.Cut()
	for(var/T in level_3)
		temp.Add(typecacheof(T))
	level_3 = temp.Copy()
	level_3[/obj/item/documents/photocopy] = FALSE
	temp.Cut()
	return

/obj/structure/itemselling/examine(mob/user)
	. = ..()
	. += span_notice("Hit with a storage item to dump all items in it into the machine.")
	. += "<a href='?src=[REF(src)];tier_3=1'>List Tier 3 Prices</a>"
	. += "<a href='?src=[REF(src)];tier_2=1'>List Tier 2 Prices</a>"
	. += "<a href='?src=[REF(src)];tier_1=1'>List Tier 1 Prices</a>"
	. += "<a href='?src=[REF(src)];tier_0=1'>List Tier 0 Prices</a>"
	/**
	. += "Secret Documents - 1000 Ahn"
	. += "Secret Documents Folders - 1000 Ahn"
	. += "Raw Anomaly Core - 1000 Ahn"
	. += "Melee weapons - 200 Ahn"
	. += "Ranged weapons - 200 Ahn"
	. += "Armor - 200 Ahn"
	. += "Sweeper/Robot/Worm Meat - 50 Ahn"
	. += "Fish - 10 Ahn"
	*/

/obj/structure/itemselling/Topic(href, href_list)
	. = ..()
	var/list/said_names = list()
	var/item_name = ""
	var/display_text = ""
	var/list/items = list()
	if(href_list["tier_3"])
		display_text = span_notice("<b>The following items are worth 1000 Ahn:</b>")
		items.Add(level_3)
	if(href_list["tier_2"])
		display_text = span_notice("<b>The following items are worth 200 Ahn:</b>")
		items.Add(level_2)
	if(href_list["tier_1"])
		display_text = span_notice("<b>The following items are worth 50 Ahn:</b>")
		items.Add(level_1)
	if(href_list["tier_0"])
		display_text = span_notice("<b>The following items are worth 10 Ahn:</b>")
		items.Add(level_0)
	for(var/I in items)
		item_name = ""
		for(var/E in exclude_listing)
			if(I in typecacheof(E))
				item_name = exclude_listing[E]
				break
		if(item_name == "")
			var/obj/item/IT = I
			item_name = initial(IT.name)
		var/list/parts = splittext(item_name, " ")
		item_name = ""
		for(var/S in parts)
			if(item_name == "")
				item_name = capitalize(S)
			else
				item_name = item_name + " [capitalize(S)]"
		if(item_name in said_names)
			continue
		said_names += item_name
		display_text += span_notice("\n[item_name]")
	to_chat(usr, display_text)

/obj/structure/itemselling/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/storage)) // Code for storage dumping
		var/obj/item/storage/S = I
		for(var/obj/item/IT in S)
			ManageSales(IT, user)
		to_chat(user, span_notice("\The [S] was dumped into [src]."))
		playsound(I, "rustle", 50, TRUE, -5)
		return TRUE
	return ManageSales(I, user)

/obj/structure/itemselling/proc/ManageSales(obj/item/I, mob/living/user)
	var/spawntype
	if(is_type_in_typecache(I, level_3))
		spawntype = /obj/item/stack/spacecash/c1000
	else if(is_type_in_typecache(I, level_2))
		spawntype = /obj/item/stack/spacecash/c200
	else if(is_type_in_typecache(I, level_1))
		spawntype = /obj/item/stack/spacecash/c50
	else if (is_type_in_typecache(I, level_0))
		spawntype = /obj/item/stack/spacecash/c10
	else
		to_chat(user, span_warning("You cannot sell [I]."))
		return FALSE

	if(spawntype)
		new spawntype (get_turf(src))
		qdel(I)
	return TRUE

/obj/structure/potential
	name = "Potential estimation machine"
	desc = "A machine used to estimate your poential"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine3"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

//Very dumb way to implement "empty hand AND full hand."
//These two code blocks are the same except for their triggers - if you've got a better idea, please use it.
/obj/structure/potential/proc/calculate_grade(mob/living/user)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/stattotal
		var/grade
		for(var/attribute in stats)
			stattotal += get_attribute_level(H, attribute)
		stattotal /= 4	// Potential is an average of stats
		grade = round((stattotal) / 20)	// Get the average level-20, divide by 20
		// Under grade 9 doesn't register
		if (10 - grade >= 10)
			to_chat(user, span_notice("Potential too low to give grade. Not recommended to issue fixer license."))
			return

		to_chat(user, span_notice("Recommended Grade - [10-grade]."))
		to_chat(user, span_notice("This grade may be adjusted by your local Hana representative."))
		return

	to_chat(user, span_notice("No human potential identified."))

/obj/structure/potential/attackby(obj/item/I, mob/living/user, params)
	calculate_grade(user)

/obj/structure/potential/attack_hand(mob/living/user)
	calculate_grade(user)

/obj/structure/timelock
	name = "T-Corp locking mechanism"
	desc = "A machine that is impossible to pass"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/timelock/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(die)), 15 MINUTES)

/obj/structure/timelock/proc/die()
	qdel(src)
