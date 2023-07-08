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


/datum/map_template/random_room/rcorp/standard
	name = "Rcorp - old"
	room_id = "rcorp_inside_standard"
	mappath = "_maps/RandomRooms/rcorp/facility/standard.dmm"
	weight = 20


/datum/map_template/random_room/rcorp/maze
	name = "Rcorp - sewers"
	room_id = "rcorp_inside_maze"
	mappath = "_maps/RandomRooms/rcorp/facility/maze.dmm"
	weight = 5


/datum/map_template/random_room/rcorp/maze2
	name = "Rcorp - sewers alt"
	room_id = "rcorp_inside_mazealt"
	mappath = "_maps/RandomRooms/rcorp/facility/maze2.dmm"
	weight = 5

/datum/map_template/random_room/rcorp/beach
	name = "Rcorp - sewers alt"
	room_id = "rcorp_inside_beaches"
	mappath = "_maps/RandomRooms/rcorp/facility/beaches.dmm"
	weight = 5

