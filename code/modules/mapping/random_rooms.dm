/datum/map_template/random_room
	var/room_id //The SSmapping random_room_template list is ordered by this var
	var/spawned //Whether this template (on the random_room template list) has been spawned
	var/centerspawner = TRUE
	var/template_width = 0
	var/template_height = 0
	var/weight = 10 //weight a room has to appear
	var/stock = 1 //how many times this room can appear in a round
	var/room_type = "maintenance"

/* Cybersun Ship Rooms */
/datum/map_template/random_room/cybersun_default
	name = "Cybersun Warehouse - Default"
	room_id = "cybersun_default"
	mappath = "_maps/RandomRooms/ruins/cybersun_default.dmm"
	centerspawner = FALSE
	template_width = 6
	template_height = 7
	room_type = "cybersun"

/datum/map_template/random_room/cybersun_rich
	name = "Cybersun Warehouse - Rich"
	room_id = "cybersun_rich"
	mappath = "_maps/RandomRooms/ruins/cybersun_rich.dmm"
	centerspawner = FALSE
	template_width = 6
	template_height = 7
	weight = 5
	room_type = "cybersun"

/datum/map_template/random_room/cybersun_med_default
	name = "Cybersun Medical - Default"
	room_id = "cybersun_med_default"
	mappath = "_maps/RandomRooms/ruins/cybersun_med_default.dmm"
	centerspawner = FALSE
	template_width = 3
	template_height = 5
	room_type = "cybersun_med"

/datum/map_template/random_room/cybersun_med_rich
	name = "Cybersun Medical - Rich"
	room_id = "cybersun_med_rich"
	mappath = "_maps/RandomRooms/ruins/cybersun_med_rich.dmm"
	centerspawner = FALSE
	template_width = 3
	template_height = 5
	weight = 5
	room_type = "cybersun_med"
