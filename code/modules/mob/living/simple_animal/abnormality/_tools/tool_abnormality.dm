/obj/structure/toolabnormality
	name = "tool abnormality"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	icon_state = "mirror"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

GLOBAL_LIST_INIT(unspawned_tools, list(
	/obj/structure/toolabnormality/treesap,
	/obj/structure/toolabnormality/fateloom,
	/obj/structure/toolabnormality/behaviour,
	/obj/structure/toolabnormality/bracelet,
	/obj/structure/toolabnormality/aspiration,
	/obj/structure/toolabnormality/skin,
	/obj/structure/toolabnormality/theresia,
	/obj/structure/toolabnormality/mirror,
	/obj/structure/toolabnormality/wishwell,
))

/obj/effect/landmark/toolspawn
	name = "tool spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/toolspawn/Initialize()
	..()
	if(!LAZYLEN(GLOB.unspawned_tools)) // You shouldn't ever need this but I mean go on I guess
		return
	var/spawning
	spawning = pick(GLOB.unspawned_tools)
	GLOB.unspawned_tools -= spawning
	new spawning(get_turf(src))


