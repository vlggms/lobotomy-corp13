/obj/structure/turnstile
	name = "turnstile"
	desc = "Just pretend that it's turning."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "turnstile"
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/turnstile/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /obj/vehicle))
		return FALSE
	return TRUE
