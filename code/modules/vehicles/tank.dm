//BM SPEEDWAGON

/obj/vehicle/ridden/tank
	name = "R Corp Tank"
	desc = "Push it to the limit, walk along the razor's edge."
	icon = 'icons/obj/car.dmi'
	icon_state = "speedwagon"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay
	max_buckled_mobs = 4
	var/crash_all = FALSE //CHAOS
	pixel_y = -48
	pixel_x = -48
