/obj/structure/railing
	name = "railing"
	desc = "Basic railing meant to protect idiots like you from falling."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	density = TRUE
	anchored = TRUE

	var/climbable = TRUE
	///Initial direction of the railing.
	var/ini_dir

/obj/structure/railing/corner //aesthetic corner sharp edges hurt oof ouch
	icon_state = "railing_corner"
	density = FALSE
	climbable = FALSE

/obj/structure/railing/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS ,null,CALLBACK(src, PROC_REF(can_be_rotated)),CALLBACK(src, PROC_REF(after_rotation)))


/obj/structure/railing/Initialize()
	. = ..()
	ini_dir = dir
	if(climbable)
		AddElement(/datum/element/climbable)

/obj/structure/railing/attackby(obj/item/I, mob/living/user, params)
	..()
	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return

/obj/structure/railing/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(!anchored)
		to_chat(user, "<span class='warning'>You cut apart the railing.</span>")
		I.play_tool_sound(src, 100)
		deconstruct()
		return TRUE

/obj/structure/railing/deconstruct(disassembled)
	. = ..()
	if(!loc) //quick check if it's qdeleted already.
		return
	if(!(flags_1 & NODECONSTRUCT_1))
		var/obj/item/stack/rods/rod = new /obj/item/stack/rods(drop_location(), 3)
		transfer_fingerprints_to(rod)
		qdel(src)

/obj/structure/railing/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) & dir)
		var/checking = FLYING | FLOATING
		return . || mover.throwing || mover.movement_type & checking
	return TRUE

/obj/structure/railing/corner/CanPass()
	..()
	return TRUE

/obj/structure/railing/CheckExit(atom/movable/mover, turf/target)
	..()
	if(get_dir(loc, target) & dir)
		var/checking = PHASING | FLYING | FLOATING
		return !density || mover.throwing || mover.movement_type & checking || mover.move_force >= MOVE_FORCE_EXTREMELY_STRONG
	return TRUE

/obj/structure/railing/corner/CheckExit()
	return TRUE

/obj/structure/railing/proc/can_be_rotated(mob/user,rotation_type)
	if(anchored)
		to_chat(user, "<span class='warning'>[src] cannot be rotated while it is fastened to the floor!</span>")
		return FALSE

	var/target_dir = turn(dir, rotation_type == ROTATION_CLOCKWISE ? -90 : 90)

	if(!valid_window_location(loc, target_dir, is_fulltile = FALSE)) //Expanded to include rails, as well!
		to_chat(user, "<span class='warning'>[src] cannot be rotated in that direction!</span>")
		return FALSE
	return TRUE

/obj/structure/railing/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/railing/proc/after_rotation(mob/user,rotation_type)
	add_fingerprint(user)

// Variant of railing that takes the form of a floor riser. Functionally identical in many respects, except that they only face one way.
// Sucks that so much had to be duplicated, but these shouldn't be possible to construct, deconstruct, or rotate, so I had to go one layer up.
/obj/structure/riser
	name = "floor riser"
	icon = 'icons/obj/fluff.dmi'
	icon_state = "riser_standard"
	desc = "The edge of a risen portion of floor."
	density = TRUE
	anchored = TRUE

	var/climbable = TRUE
	dir = NORTH

/obj/structure/riser/Initialize()
	. = ..()
	if(climbable)
		AddElement(/datum/element/climbable)

/obj/structure/riser/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) & dir)
		var/checking = FLYING | FLOATING
		return . || mover.throwing || mover.movement_type & checking
	return TRUE

/obj/structure/riser/CheckExit(atom/movable/mover, turf/target)
	..()
	if(get_dir(loc, target) & dir)
		var/checking = PHASING | FLYING | FLOATING
		return !density || mover.throwing || mover.movement_type & checking || mover.move_force >= MOVE_FORCE_EXTREMELY_STRONG
	return TRUE

/obj/structure/riser/white
	icon_state = "riser_white"

/obj/structure/riser/dark
	icon_state = "riser_dark"

/obj/structure/riser/wood
	icon_state = "riser_wood"
