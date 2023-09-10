/obj/effect/landmark/cityspawner
	name = "cityspawner landmark"
	icon_state = "x3"

/obj/effect/landmark/cityloot
	name = "cityloot landmark"
	icon_state = "x2"


/obj/effect/bloodpool
	name = "bloodpool"
	desc = "A pool of blood"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "bloodin"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/bloodpool/Initialize()
	. = ..()
	QDEL_IN(src, 10)

/obj/effect/landmark/fixerbase
	name = "fixer base landmark"
	icon_state = "x"

/obj/effect/landmark/syndicatebase
	name = "syndicate base landmark"
	icon_state = "x"
