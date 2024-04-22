GLOBAL_LIST_EMPTY(rcorp_structures)

/obj/effect/rcorp_blocker
	name = "R-Corp Timeblocker"
	var/timelock = 1 //how many 5 minutes it takes to open
	var/obj/machinery/door/poddoor/shutters/linked_door

/obj/effect/rcorp_blocker/Initialize()
	..()
	GLOB.rcorp_structures += src
	linked_door = new /obj/machinery/door/poddoor/shutters/indestructible(get_turf(src))

/obj/effect/rcorp_blocker/proc/Activate()
	linked_door.open()
