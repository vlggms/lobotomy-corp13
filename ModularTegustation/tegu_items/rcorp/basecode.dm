/*
/obj/effect/spawner/room/rcorp_base
	name = "rcorp base spawner"
	icon_state = "random_room"
	room_width = 49
	room_height = 35
	room_type = "rcorp_fourth"

/*
/obj/effect/spawner/room/rcorp_base/Initialize()
	if(SSmaptype.jobtype == "rcorp_fifth")
		room_type = "rcorp_fifth"
	..()*/

/datum/map_template/random_room/rcorp
	centerspawner = FALSE
	template_width = 49
	template_height = 35

/datum/map_template/random_room/rcorp/fourth
	name = "R-Corp 4th pack Base"
	room_id = "rcorp_base_fourth"
	mappath = "_maps/templates/rcorp_base/fourthpack.dmm"
	room_type = "rcorp_fourth"
	weight = 5*/

/*
/datum/map_template/random_room/rcorp/fifth
	name = "R-Corp 5th pack Base"
	room_id = "rcorp_base_fifth"
	mappath = "_maps/templates/rcorp_base/fifthpack.dmm"
	room_type = "rcorp_fifth"
	weight = 5*/


/obj/effect/spawner/room/rcorp_base
	name = "rcorp facility spawner"
	icon_state = "random_room"
	room_width = 49
	room_height = 35
	room_type = "rcorp_fourth" // Used so we can place landmarks in ruins and such.


/datum/map_template/random_room/rcorp/fourth
	centerspawner = FALSE
	template_width = 49
	template_height = 35
	room_type = "rcorp_fourth"
	weight = 1
	mappath = "_maps/templates/rcorp_base/fourthpack.dmm"
