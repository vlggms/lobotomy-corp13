/obj/effect/spawner/room/village_spawner
	name = "village spawner"
	room_width = 29
	room_height = 22
	icon = 'ModularTegustation/Teguicons/room_spawners/29x22.dmi'
	icon_state = ""
	room_type = "village"
	spawn_delay_min = 8200
	spawn_delay_max = 11200

/datum/map_template/random_room/backstreets/resurgence_village
	name = "Resurgence Village"
	room_id = "resurgence_village"
	mappath = "_maps/RandomRooms/backstreets/resurgence_village.dmm"
	template_width = 29
	template_height = 22
	room_type = "village"

/obj/effect/spawner/room/village_spawner/LateSpawn()
	// do stuff
	for(var/MN in GLOB.player_list)
		var/mob/M = MN
		// Double check for client
		M.playsound_local(M, "sound/effects/explosioncreak1.ogg", 100)
		shake_camera(M, 25, 4)
	sleep(75)
	minor_announce("Warning, a large area has appeared in the backstreets. Entities within this area appear to non-hostile. Please approach them with caution.", "Local Activity Alert:", TRUE)
	. = ..()
