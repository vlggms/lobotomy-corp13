//Cosmetic Effects
/obj/effect/wall_vent
	name = "wall vent"
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "wall_vent"

/obj/effect/temp_visual/roomdamage  // room damage effect
	name = "generic damage effect"
	duration = 15
	icon = 'icons/effects/160x96.dmi'
	icon_state = "red"
	layer = ABOVE_OPEN_TURF_LAYER

/obj/effect/temp_visual/roomdamage/Initialize(mapload, set_dir)
	. = ..()
	animate(src, pixel_x = base_pixel_x + rand(-3, 3), pixel_y = base_pixel_y + rand(-3, 3), time = 1)
	addtimer(CALLBACK(src, PROC_REF(ResetAnim)),2)

/obj/effect/temp_visual/roomdamage/proc/ResetAnim()
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	animate(src, alpha = 0, time = 13)

/obj/effect/temp_visual/workcomplete  // Work complete effect
	name = "work complete"
	duration = 15
	icon = 'icons/effects/160x96.dmi'
	icon_state = "normal"
	layer = ABOVE_ALL_MOB_LAYER
	alpha = 200

/obj/effect/temp_visual/workcomplete/Initialize(mapload, set_dir)
	. = ..()
	animate(src, alpha = 100, time = 5)
	addtimer(CALLBACK(src, PROC_REF(ResetAnim)),5)

/obj/effect/temp_visual/workcomplete/proc/ResetAnim()
	animate(src, alpha = 200, time = 5)
	sleep(5)
	animate(src, alpha = 0, time = 5)
