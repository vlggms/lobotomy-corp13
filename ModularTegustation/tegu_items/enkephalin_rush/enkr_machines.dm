/obj/machinery/button/door/landmarkspawner
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/button/door/landmarkspawner/attack_hand(mob/user)
	..()
	for(var/obj/effect/landmark/delayed/department_center/D in GLOB.landmarks_list)
		D.CreateLandmark(D.spawner)

GLOBAL_VAR(lobotomy_damages)
GLOBAL_VAR(lobotomy_repairs)

/obj/machinery/containment_hotspot
	name = "broken containment panel"
	desc = "The controls to this containment cell have been broken. Should it be repaired, an abnormality core could be shipped inside it."
	icon = 'ModularTegustation/Teguicons/lc13doorpanels.dmi'
	icon_state = "broken"
	density = FALSE
	var/repair_state = 0
	var/fix_hint = "The panel is shut with philips screws."

/obj/machinery/containment_hotspot/Initialize()
	..()
	GLOB.lobotomy_damages += 1
	return INITIALIZE_HINT_NORMAL

/obj/machinery/containment_hotspot/examine(mob/user)
	. = ..()
	. += span_notice("[fix_hint]")

/obj/machinery/containment_hotspot/attackby(obj/item/P, mob/user, params)
	switch(repair_state)
		if(0)
			if(P.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("You start to disconnect the display..."))
				if(P.use_tool(src, user, 20, volume=50))
					to_chat(user, span_notice("The shattered display scatters around your feet..."))
					++repair_state
					icon_state = "broken2"
					fix_hint = "The circuitry has been destroyed and needs to be prepared for replacement."
				return
		if(1)
			if(P.tool_behaviour == TOOL_WIRECUTTER)
				P.play_tool_sound(src)
				to_chat(user, span_notice("You remove the crushed and twisted cables."))
				++repair_state
				fix_hint = "It is missing wires."
				return
		if(2)
			if(istype(P, /obj/item/stack/cable_coil))
				if(!P.tool_start_check(user, amount=5))
					return
				to_chat(user, span_notice("You begin to reconnect the wiring..."))
				if(P.use_tool(src, user, 20, volume=50, amount=5))
					if(repair_state != 2)
						return
					to_chat(user, span_notice("You've successfully repaired the internals of the containment panel."))
					++repair_state
					icon_state = "broken3"
					fix_hint = "The front panel is unscrewed."
		if(3)
			if(P.tool_behaviour == TOOL_SCREWDRIVER)
				to_chat(user, span_notice("You start to reconnect the display..."))
				if(P.use_tool(src, user, 20, volume=50))
					to_chat(user, span_notice("The panel vanishes. This containment cell will automatically complete when an abnormality is extracted into it."))
					var/turf/T = get_turf(src)
					T = get_ranged_target_turf(T, WEST, 4)
					new /obj/effect/spawner/abnormality_room(T)
					GLOB.lobotomy_repairs += 1
					qdel(src)

/obj/broken_regenerator
	name = "broken regenerator"
	desc = "A machine that could slowly restore the health and sanity of employees in the area. It needs some serious repairs."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "regen_broken"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	layer = ABOVE_OBJ_LAYER //So people dont stand ontop of it when above it

/obj/broken_regenerator/examine(mob/user)
	. = ..()
	. += span_notice("A Regenerator Augmentation Kit from Safety could be used to fix this.")

/obj/broken_regenerator/Initialize()
	..()
	GLOB.lobotomy_damages += 1
	return INITIALIZE_HINT_NORMAL

/obj/broken_regenerator/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/safety_kit))
		qdel(O)
		new /obj/machinery/regenerator(get_turf(src))
		GLOB.lobotomy_repairs += 1
		qdel(src)

