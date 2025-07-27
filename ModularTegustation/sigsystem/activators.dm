	/*--------\
	|Activator|
	\--------*/
	//Im sorry but this will be the most bloated code.
/obj/structure/sigsystem/activator
	name = "sigsystem activator"
	desc = "A device that effects structures placed ontop of it."
	icon_state = "activator"

/obj/structure/sigsystem/activator/ReceivePing()
	var/turf/our_turf = get_turf(src)
	//Remotely finds the turf where we spawn the thing.
	for(var/obj/structure/S in our_turf)
		if(istype(S, /obj/structure/closet))
			var/obj/structure/closet/C = S
			C.togglelock()
	for(var/obj/machinery/door/poddoor/M in our_turf)
		var/openclose
		if(openclose == null)
			openclose = M.density
		INVOKE_ASYNC(M, openclose ? TYPE_PROC_REF(/obj/machinery/door/poddoor, open) : TYPE_PROC_REF(/obj/machinery/door/poddoor, close))

	/*-------------\
	|Pressure Plate|
	\--------------/
	* A connector that can only be
	* activated by structures that aim for it.
	*/
/obj/structure/sigsystem/pressure_plate
	name = "pressure plate"
	desc = "A connector refashioned into a pressure plate."
	icon_state = "pressure_plate"
	happens_once = TRUE
	var/mobs_only = FALSE

/obj/structure/sigsystem/pressure_plate/ReceivePing()
	return

/obj/structure/sigsystem/pressure_plate/Crossed(H as mob|obj)
	..()
	if(happens_once && fired)
		return
	if(!H)
		return
	if(isobserver(H))
		return
	if(!ismob(H) && mobs_only)
		return
	PingDirection()


	/*----------\
	|Signal Node|
	\-----------/
	* A connector that can only be
	* activated by structures that aim for it.
	*/
/obj/structure/sigsystem/signal_node
	name = "signal node"
	desc = "A connector that cannot be activated by other connectors."
	icon_state = "node"

/obj/structure/sigsystem/signal_node/ReceivePing()
	return

/obj/structure/sigsystem/signal_node/proc/NodePing()
	PingDirection()

	/*-----------\
	|SIGNAL CHEST| Bit sloppy
	\------------/
	* Sigsystem crates can be locked and
	* unlocked with activators under them
	* and will send out a ping to any connector under them.
	*/
/obj/structure/closet/crate/sigsystem
	name = "system crate"
	desc = "A rectangular steel crate. Wired to be unlocked remotely."
	icon_state = "securecrate"
	anchored = TRUE
	anchorable = TRUE
	//If the crate fires a signal upon opening once
	var/once = TRUE
	var/fired = FALSE

/obj/structure/closet/crate/sigsystem/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/crate/sigsystem/update_overlays()
	. = ..()
	if(broken)
		. += "securecrateemag"
	else if(locked)
		. += "securecrater"
	else
		. += "securecrateg"

/obj/structure/closet/crate/sigsystem/after_open(mob/living/user, force)
	. = ..()
	if(once && fired)
		return
	PingLocation()

/obj/structure/closet/crate/sigsystem/togglelock(mob/living/user, silent)
	if(user)
		return

	if(locked)
		locked = FALSE
		playsound(src,'sound/machines/boltsup.ogg',30,FALSE,3)

	else
		locked = TRUE
	update_icon()

/obj/structure/closet/crate/sigsystem/proc/PingLocation()
	var/location = get_turf(src)
	for(var/obj/structure/sigsystem/signal_node/node in location)
		node.NodePing()
