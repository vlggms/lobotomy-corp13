/obj/structure/altrefiner
	name = "Unknown refinery"
	desc = "Contact a coder immediately!"
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator-blue"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/altrefiner/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src

/obj/structure/altrefiner/Destroy()
	GLOB.lobotomy_devices -= src
	return ..()

GLOBAL_LIST_INIT(unspawned_refiners, list(
	/obj/structure/altrefiner/blood,
	/obj/structure/altrefiner/quick,
	/obj/structure/altrefiner/timed,
	/obj/structure/altrefiner/weapon,
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
	var/obj/structure/altrefiner/spawning = pick_n_take(GLOB.unspawned_refiners)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL


