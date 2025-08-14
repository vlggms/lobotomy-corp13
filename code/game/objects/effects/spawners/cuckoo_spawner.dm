/obj/effect/spawner/room/cuckoo_spawner
	name = "cuckoo spawner"
	room_width = 17
	room_height = 12
	icon = 'ModularTegustation/Teguicons/room_spawners/17x12.dmi'
	icon_state = ""
	room_type = "cuckoo"
	spawn_delay_min = 18000
	spawn_delay_max = 18000

/datum/map_template/random_room/backstreets/cuckoo_nest
	name = "Cuckoo Nest"
	room_id = "cuckoo_nest"
	mappath = "_maps/RandomRooms/backstreets/cuckoo_nest.dmm"
	template_width = 17
	template_height = 12
	room_type = "cuckoo"

/obj/effect/spawner/room/cuckoo_spawner/LateSpawn()
	if(prob(20) && 	SSmaptype.maptype == "city")
		for(var/MN in GLOB.player_list)
			var/mob/M = MN
			M.playsound_local(M, "sound/hallucinations/veryfar_noise.ogg", 25)
			to_chat(M, span_warning("A malevolent force has been uncovered..."))
		. = ..()
	else
		qdel(src)
