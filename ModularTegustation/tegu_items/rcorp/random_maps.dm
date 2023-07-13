/obj/effect/spawner/room/rcorp
	name = "rcorp facility spawner"
	icon_state = "random_room"
	room_width = 100
	room_height = 161
	room_type = "rcorp_inside" // Used so we can place landmarks in ruins and such.


/datum/map_template/random_room/rcorp
	centerspawner = FALSE
	template_width = 100
	template_height = 161
	room_type = "rcorp_inside"
	weight = 0


/datum/map_template/random_room/rcorp/standard
	name = "Rcorp - Facility"
	room_id = "rcorp_inside_standard"
	mappath = "_maps/RandomRooms/rcorp/facility/standard.dmm"
	weight = 10


/datum/map_template/random_room/rcorp/maze
	name = "Rcorp - Sewers"
	room_id = "rcorp_inside_maze"
	mappath = "_maps/RandomRooms/rcorp/facility/maze.dmm"
	weight = 5


/datum/map_template/random_room/rcorp/maze2
	name = "Rcorp - Sewers alt"
	room_id = "rcorp_inside_mazealt"
	mappath = "_maps/RandomRooms/rcorp/facility/maze2.dmm"
	weight = 5

/datum/map_template/random_room/rcorp/beach
	name = "Rcorp - Beaches"
	room_id = "rcorp_inside_beaches"
	mappath = "_maps/RandomRooms/rcorp/facility/beaches.dmm"
	weight = 10

