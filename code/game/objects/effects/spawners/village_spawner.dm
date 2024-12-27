/obj/effect/spawner/room/village_spawner
	name = "random room spawner"
	room_width = 100
	room_height = 100
	room_type = "village"
	var/spawn_delay_min = 1000
	var/spawn_delay_max = 1000

/obj/effect/spawner/room/village_spawner/LateSpawn()
	. = ..()
	// do stuff
