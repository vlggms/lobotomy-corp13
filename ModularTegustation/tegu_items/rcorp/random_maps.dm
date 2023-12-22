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

//Maps with 2 types are 10 points split between the two types, maps with 1 type are 10.
//Facility Types
/datum/map_template/random_room/rcorp/standard
	name = "Rcorp - Facility"
	room_id = "rcorp_inside_standard"
	mappath = "_maps/RandomRooms/rcorp/facility/standard.dmm"
	weight = 5

/datum/map_template/random_room/rcorp/standard2
	name = "Rcorp - Facility alt"
	room_id = "rcorp_inside_standardalt"
	mappath = "_maps/RandomRooms/rcorp/facility/standard2.dmm"
	weight = 5

//Sewer Types
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

//Beach Types
/datum/map_template/random_room/rcorp/beach
	name = "Rcorp - Beaches"
	room_id = "rcorp_inside_beaches"
	mappath = "_maps/RandomRooms/rcorp/facility/beaches.dmm"
	weight = 5

/datum/map_template/random_room/rcorp/beachalt
	name = "Rcorp - Beaches Alt"
	room_id = "rcorp_inside_beaches2"
	mappath = "_maps/RandomRooms/rcorp/facility/beaches2.dmm"
	weight = 5

//Office Types
/datum/map_template/random_room/rcorp/office
	name = "Rcorp - Offices"
	room_id = "rcorp_inside_office"
	mappath = "_maps/RandomRooms/rcorp/facility/offices.dmm"
	weight = 10

//City, similar to the zombies map
/datum/map_template/random_room/rcorp/city
	name = "Rcorp - City alt"
	room_id = "rcorp_inside_cityalt"
	mappath = "_maps/RandomRooms/rcorp/facility/city2.dmm"
	weight = 5

//Skeld type maps
/datum/map_template/random_room/rcorp/skeld
	name = "Rcorp - Skeld"
	room_id = "rcorp_inside_skeld"
	mappath = "_maps/RandomRooms/rcorp/facility/skeld.dmm"
	weight = 5

//Nest type maps
/datum/map_template/random_room/rcorp/nest
	name = "Rcorp - Nest"
	room_id = "rcorp_inside_nest"
	mappath = "_maps/RandomRooms/rcorp/facility/nest.dmm"
	weight = 5

//Special Types.
/datum/map_template/random_room/rcorp/raidboss
	name = "Rcorp - Raid Boss"
	room_id = "rcorp_inside_raidboss"
	mappath = "_maps/RandomRooms/rcorp/facility/raidboss.dmm"
	weight = 10

/datum/map_template/random_room/rcorp/zombies
	name = "Rcorp - City"
	room_id = "rcorp_inside_city"
	mappath = "_maps/RandomRooms/rcorp/facility/city.dmm"
	weight = 10

/datum/map_template/random_room/rcorp/xenos
	name = "Rcorp - Xenos"
	room_id = "rcorp_inside_xenos"
	mappath = "_maps/RandomRooms/rcorp/facility/xenos.dmm"
//	weight = 10 			Currently instantly ends the round for reasons known only to god.

