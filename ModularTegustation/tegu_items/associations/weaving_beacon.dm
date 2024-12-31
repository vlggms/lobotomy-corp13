/obj/item/choice_beacon/weaving
	name = "weaver's beacon"
	desc = "A beacon weavers use to summon their gear."
	var/useable_outside_office = FALSE
	custom_price = PAYCHECK_RESOURCE

/obj/item/choice_beacon/weaving/attack_self(mob/user)
	if(useable_outside_office)
		if(SSmaptype.maptype == "office")
			if(canUseBeacon(user))
				generate_options(user)
		else
			playsound(src, 'sound/machines/buzz-sigh.ogg', 40, TRUE)
			to_chat(user, span_hear("You can't use this beacon in this gamemode!"))
	else
		if(canUseBeacon(user))
			generate_options(user)

/obj/item/choice_beacon/weaving/generate_display_names()
	var/static/list/beacon_item_list
	if(!beacon_item_list)
		beacon_item_list = list()
		var/list/templist = list(/obj/effect/weaving_spawner)
		for(var/V in templist)
			var/atom/A = V
			beacon_item_list[initial(A.name)] = A
	return beacon_item_list

/obj/item/choice_beacon/weaving/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, span_hear("Take good care of your gear!"))

/obj/effect/weaving_spawner
	name = "Weaver Gear, (WARNING: Comes with a vending machine)"
	desc = "Spawns in all of the gear that a weaver needs."

/obj/effect/weaving_spawner/Initialize(mapload)
	. = ..()
	new /obj/machinery/vending/weaving/cheap (get_turf(src))
	new /obj/item/book/granter/crafting_recipe/carnival/weaving_armor (get_turf(src))
	new /obj/item/silkknife (get_turf(src))
	new /obj/item/storage/bag/silk/filled (get_turf(src))
	new /obj/item/book/granter/crafting_recipe/carnival/human_replacements (get_turf(src))
	new /obj/item/book/granter/crafting_recipe/carnival/weaving_basic_converstion (get_turf(src))
	new /obj/item/paper/fluff/silk_guide (get_turf(src))
	new /obj/item/paper/fluff/silk_guide (get_turf(src))
	qdel(src)

/obj/item/storage/bag/silk/filled

/obj/item/storage/bag/silk/filled/PopulateContents()
	for(var/i in 1 to 8)
		new /obj/item/stack/sheet/silk/indigo_simple(src)
		new /obj/item/stack/sheet/silk/green_simple(src)
		new /obj/item/stack/sheet/silk/steel_simple(src)
		new /obj/item/stack/sheet/silk/amber_simple(src)
	for(var/i in 1 to 4)
		new /obj/item/stack/sheet/silk/human_simple(src)
