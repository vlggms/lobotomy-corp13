GLOBAL_LIST_EMPTY(wcorp_structures)

/obj/effect/blocker
	name = "W-Corp Timeblocker"
	var/timelock = 1 //the round which it opens
	var/obj/machinery/door/poddoor/shutters/linked_door

/obj/effect/blocker/Initialize()
	..()
	GLOB.wcorp_structures += src
	linked_door = new /obj/machinery/door/poddoor/shutters/indestructible(get_turf(src))

/obj/effect/blocker/proc/Activate()
	linked_door.open()
