/obj/item/fishing_net
	name = "fishing net"
	desc = "This tool functions as a aquatic wall you can put down and just harvest the fish that get tangled in it."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "trawling_net"
	w_class = WEIGHT_CLASS_HUGE
	//Item deployment code is inside /turf/open/water/deep

/obj/structure/destructible/fishing_net
	name = "fishing net"
	desc = "A wall of twine and wires that traps fish. Alt click to harvest."
	icon = 'ModularTegustation/fishing/icons/fishing.dmi'
	icon_state = "trawling_net_empty"
	anchored = TRUE
	max_integrity = 5
	break_message = span_notice("The net falls apart!")
	break_sound = 'sound/items/wirecutter.ogg'
	debris = list(/obj/item/fishing_net = 1)
	var/fishin_cooldown = 25 SECONDS
	var/fishin_cooldown_delay = 1 SECONDS
	var/turf/open/water/deep/open_waters

/obj/structure/destructible/fishing_net/Initialize()
	. = ..()
	open_waters = get_turf(src)
	if(!istype(open_waters, /turf/open/water/deep))
		qdel(src)
		return
	//will proc at least 5 times before the loop stops.
	addtimer(CALLBACK(src, PROC_REF(CatchFish)), fishin_cooldown + fishin_cooldown_delay)

/obj/structure/destructible/fishing_net/examine(mob/user)
	. = ..()
	if(contents.len > 0)
		. += span_notice("[contents.len]/5 things are caught in the [src].")

/obj/structure/destructible/fishing_net/AltClick(mob/user)
	. = ..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	EmptyNet(get_turf(user))

/obj/structure/destructible/fishing_net/proc/EmptyNet(turf/dropoff)
	for(var/atom/movable/harvest in contents)
		harvest.forceMove(dropoff)
	new /obj/item/fishing_net(dropoff)
	qdel(src)

/obj/structure/destructible/fishing_net/proc/CatchFish()
	if(contents.len >= 5 || !open_waters)
		return
	var/atom/thing_caught = pickweight(open_waters.ReturnChanceList(0.8))
	new thing_caught(src)
	icon_state = "trawling_net_full"
	update_icon()
	fishin_cooldown_delay = rand(0, 5) SECONDS
	addtimer(CALLBACK(src, PROC_REF(CatchFish)), fishin_cooldown + fishin_cooldown_delay)
