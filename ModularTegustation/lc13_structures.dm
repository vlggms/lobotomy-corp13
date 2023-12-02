/* Spreading Structures Code
	Stolen and edited from alien weed code. I wanted a spreading
	structure that doesnt have the atmospheric element attached to its root. */
/obj/structure/spreading
	name = "spreading structure"
	desc = "This thing seems to spread when supplied with a outside signal."
	max_integrity = 15
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	var/conflict_damage = 10
	var/last_expand = 0 //last world.time this weed expanded
	var/expand_cooldown = 1.5 SECONDS
	var/can_expand = TRUE
	var/static/list/blacklisted_turfs

/obj/structure/spreading/Initialize()
	. = ..()

	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava,
			/turf/open/openspace))

/obj/structure/spreading/proc/expand(bypasscooldown = FALSE)
	if(!can_expand)
		return

	if(!bypasscooldown)
		last_expand = world.time + expand_cooldown

	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE

	var/list/spread_turfs = U.GetAtmosAdjacentTurfs()
	shuffle_inplace(spread_turfs)
	for(var/turf/T in spread_turfs)
		if(locate(/obj/structure/spreading) in T)
			var/obj/structure/spreading/S = locate(/obj/structure/spreading) in T
			if(S.type != type) //if it is not another of the same spreading structure.
				S.take_damage(conflict_damage, BRUTE, "melee", 1)
				break
			last_expand += (0.6 SECONDS) //if you encounter another of the same then the delay increases
			continue

		if(is_type_in_typecache(T, blacklisted_turfs))
			continue

		new type(T)
		break
	return TRUE

//Cosmetic Structures
/obj/structure/cavein_floor
	name = "blocked off floor entrance"
	desc = "An entrance to some underground facility that has been caved in."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "cavein_floor"
	anchored = TRUE

/obj/structure/cavein_door
	name = "blocked off facility entrance"
	desc = "A entrance to somewhere that has been blocked off with rubble."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "cavein_door"
	pixel_y = -8
	base_pixel_y = -8
	anchored = TRUE
