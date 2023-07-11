/obj/effect/spawner/room/rcorp_caves
	name = "rcorp facility spawner"
	icon_state = "random_room"
	room_width = 49
	room_height = 122
	room_type = "rcorp_caves" // Used so we can place landmarks in ruins and such.


/datum/map_template/random_room/rcorp_caves
	centerspawner = FALSE
	template_width = 49
	template_height = 122
	room_type = "rcorp_caves"
	weight = 0

//Facility Types
/datum/map_template/random_room/rcorp_caves/standard
	name = "R-Corp Caves - Standard"
	room_id = "rcorp_caves_standard"
	mappath = "_maps/RandomRooms/rcorp/caves/caves.dmm"
	weight = 5

/datum/map_template/random_room/rcorp_caves/winding
	name = "R-Corp Caves - Winding Path"
	room_id = "rcorp_caves_winding"
	mappath = "_maps/RandomRooms/rcorp/caves/winding.dmm"
	weight = 5

/datum/map_template/random_room/rcorp_caves/open
	name = "R-Corp Caves - Open"
	room_id = "rcorp_caves_open"
	mappath = "_maps/RandomRooms/rcorp/caves/open.dmm"
	weight = 2

/datum/map_template/random_room/rcorp_caves/choke
	name = "R-Corp Caves - Choke"
	room_id = "rcorp_caves_choke"
	mappath = "_maps/RandomRooms/rcorp/caves/choke.dmm"
	weight = 2
