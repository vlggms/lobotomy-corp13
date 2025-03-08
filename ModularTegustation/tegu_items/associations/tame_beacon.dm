/obj/item/choice_beacon/tame
	name = "T.A.M.E's beacon"
	desc = "A beacon workshops use to summon their T.A.M.E kit. (WARNING: This will spawn a structure at the place it is used)"
	var/useable_outside_office = FALSE
	custom_price = PAYCHECK_COMMAND * 2

/obj/item/choice_beacon/tame/attack_self(mob/user)
	if(!useable_outside_office)
		if(SSmaptype.maptype == "office")
			if(canUseBeacon(user))
				generate_options(user)
		else
			playsound(src, 'sound/machines/buzz-sigh.ogg', 40, TRUE)
			to_chat(user, span_hear("You can't use this beacon in this gamemode!"))
	else
		if(canUseBeacon(user))
			generate_options(user)

/obj/item/choice_beacon/tame/generate_display_names()
	var/static/list/beacon_item_list
	if(!beacon_item_list)
		beacon_item_list = list()
		var/list/templist = list(/obj/structure/ordeal_extractor)
		for(var/V in templist)
			var/atom/A = V
			beacon_item_list[initial(A.name)] = A
	return beacon_item_list

/obj/item/choice_beacon/tame/spawn_option(obj/choice,mob/living/M)
	new choice(get_turf(M))
	to_chat(M, span_hear("Take good care of your T.A.M.E kit!"))
