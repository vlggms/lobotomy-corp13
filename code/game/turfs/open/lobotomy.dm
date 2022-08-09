/turf/open/floor/facility
	icon = 'icons/turf/floors/facility.dmi'
	icon_state = "fulltile"

/turf/open/floor/facility/dark
	icon_state = "darktile"

/turf/open/floor/facility/white
	icon_state = "whitetile"

/turf/open/floor/facility/halls
	name = "facility floor plating"
	desc = "Facility floor plating."
	icon_state = "facility1"

/turf/open/floor/facility/halls/Initialize()
	. = ..()
	icon_state = "facility[pick(1,2,3)]"
	if (IS_DYNAMIC_LIGHTING(src))
		lighting_build_overlay()
	else
		lighting_clear_overlay()

