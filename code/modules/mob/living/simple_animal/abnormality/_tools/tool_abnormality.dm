/obj/structure/toolabnormality
	name = "tool abnormality"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'ModularTegustation/Teguicons/toolabnormalities.dmi'
	icon_state = "mirror"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	/// List of ego equipment datums
	var/list/ego_list = list()

GLOBAL_LIST_INIT(unspawned_tools, list(
	/obj/structure/toolabnormality/attribute_giver/snake_oil,
	/obj/structure/toolabnormality/attribute_giver/skin,
	/obj/structure/toolabnormality/attribute_giver/vivavoce,
	/obj/structure/toolabnormality/attribute_giver/theonite_slab,
	/obj/structure/toolabnormality/dr_jekyll,
	/obj/structure/toolabnormality/fateloom,
	/obj/structure/toolabnormality/treesap,
	/obj/structure/toolabnormality/behavior,
	/obj/structure/toolabnormality/bracelet,
	/obj/structure/toolabnormality/aspiration,
	/obj/structure/toolabnormality/theresia,
	/obj/structure/toolabnormality/mirror,
	/obj/structure/toolabnormality/researcher,
	/obj/structure/toolabnormality/promise,
	/obj/structure/toolabnormality/you_happy,
//	/obj/structure/toolabnormality/touch,
//	/obj/structure/toolabnormality/wishwell,
//	/obj/structure/toolabnormality/realization,
))

/obj/effect/landmark/toolspawn
	name = "tool spawner"
	desc = "This is weird. Please inform a coder that you have this. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/toolspawn/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(!LAZYLEN(GLOB.unspawned_tools)) // You shouldn't ever need this but I mean go on I guess
		return INITIALIZE_HINT_QDEL
	var/spawning = pick_n_take(GLOB.unspawned_tools)
	new spawning(get_turf(src))
	return INITIALIZE_HINT_QDEL

