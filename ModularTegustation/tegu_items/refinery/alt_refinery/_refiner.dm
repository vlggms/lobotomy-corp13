/obj/structure/refiner
	name = "Unknwon refinery"
	desc = "Contact a coder immediately!"
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-blue"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/refiner/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/refiner/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

GLOBAL_LIST_INIT(unspawned_refiners, list(
	/obj/structure/refiner/blood,
	/obj/structure/refiner/quick,
	/obj/structure/refiner/timed,
	/obj/structure/refiner/weapon,
))

/obj/effect/landmark/refinerspawn
	name = "alt-refinery spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/refinerspawn/Initialize()
	..()
	if(!LAZYLEN(GLOB.unspawned_refiners))
		return INITIALIZE_HINT_QDEL
	var/obj/structure/refiner/spawning = pick_n_take(GLOB.unspawned_refiners)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL


