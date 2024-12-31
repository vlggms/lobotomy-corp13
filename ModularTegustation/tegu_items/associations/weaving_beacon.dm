/obj/item/choice_beacon/weaving
	name = "weaver's beacon"
	desc = "A beacon weavers use to summon their gear."

/obj/item/choice_beacon/association/generate_display_names()
	if()
		var/static/list/beacon_item_list
		if(!beacon_item_list)
			beacon_item_list = list()
			var/list/templist = subtypesof(/obj/item/storage/box/association) //we have to convert type = name to name = type, how lovely!
			for(var/V in templist)
				var/atom/A = V
				beacon_item_list[initial(A.name)] = A
		return beacon_item_list

/obj/item/choice_beacon/association/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, span_hear("Make sure you put the equipment in the armory."))
