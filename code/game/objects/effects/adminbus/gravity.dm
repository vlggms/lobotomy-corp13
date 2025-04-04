/obj/effect/adminbus/gravitychaos
	name = "gravitational blast"
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	color = "#101010"
	var/turf/T
	var/range = 4
	var/power = 4
	var/visual_effect_chance = 60
	var/list/thrown_items = list()

/obj/effect/adminbus/gravitychaos/Initialize(mapload)
	. = ..()
	T = get_turf(src)
	for(var/atom/movable/A in range(T, range))
		if(A == src || A.anchored || thrown_items[A])
			continue
		if(ismob(A))
			var/mob/M = A
			if (M.mob_negates_gravity())
				continue
		A.safe_throw_at(get_edge_target_turf(A, pick(GLOB.cardinals)), power+1, 1, force = MOVE_FORCE_EXTREMELY_STRONG)
		thrown_items[A] = A
	for(var/turf/Z in range(T, range))
		if(prob(visual_effect_chance))
			new /obj/effect/temp_visual/gravpush(Z)

	return INITIALIZE_HINT_QDEL

/obj/effect/adminbus/gravitychaos/singletile
	range = 0
	visual_effect_chance = 100

/obj/effect/adminbus/targeted/gravitychaos
	name = "gravitational blast"
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	color = "#101010"
	var/turf/T
	var/power = 4
	var/visual_effect_chance = 60

/obj/effect/adminbus/targeted/gravitychaos/Initialize(mapload, mob/M)
	. = ..()
	T = get_turf(src)
	M.safe_throw_at(get_edge_target_turf(M, pick(GLOB.cardinals)), power+1, 1, force = MOVE_FORCE_EXTREMELY_STRONG)
	new /obj/effect/temp_visual/gravpush(T)

	return INITIALIZE_HINT_QDEL
