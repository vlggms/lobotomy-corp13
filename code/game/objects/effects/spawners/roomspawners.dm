//random room spawner. takes random rooms from their appropriate map file and places them. the room will spawn with the spawner in the bottom left corner
/obj/effect/spawner/room
	name = "random room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_room"
	dir = NORTH
	var/datum/map_template/random_room/template
	var/room_width = 0
	var/room_height = 0
	var/room_type = "maintenance" // Used so we can place landmarks in ruins and such.
	var/spawn_delay_min = 600
	var/spawn_delay_max = 600

/obj/effect/spawner/room/Initialize()
	..()/*
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/room/LateInitialize()*/
	var/list/possibletemplates = list()
	var/datum/map_template/random_room/cantidate = null
	shuffle_inplace(SSmapping.random_room_templates)
	for(var/ID in SSmapping.random_room_templates)
		cantidate = SSmapping.random_room_templates[ID]
		if(istype(cantidate, /datum/map_template/random_room) && (room_height == cantidate.template_height) && (room_width == cantidate.template_width) && (room_type == cantidate.room_type))
			if(!cantidate.spawned)
				possibletemplates[cantidate] = cantidate.weight
		cantidate = null
	if(possibletemplates.len)
		template = pickweight(possibletemplates)
		template.stock --
		template.weight = (template.weight / 2)
		if(template.stock <= 0)
			template.spawned = TRUE
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/spawner/room, LateSpawn)), rand(spawn_delay_min, spawn_delay_max))
	else
		template = null
	if(!template)
		qdel(src)

/obj/effect/spawner/room/proc/LateSpawn()
	template.load(get_turf(src), centered = template.centerspawner)
	qdel(src)

/* Spawner landmarks */

/obj/effect/spawner/room/fivexfour
	name = "5x4 room spawner"
	room_width = 5
	room_height = 4

/obj/effect/spawner/room/fivexthree
	name = "5x3 room spawner"
	room_width = 5
	room_height = 3

/obj/effect/spawner/room/threexfive
	name = "3x5 room spawner"
	room_width = 3
	room_height = 5

/obj/effect/spawner/room/tenxten
	name = "10x10 room spawner"
	room_width = 10
	room_height = 10

/obj/effect/spawner/room/tenxfive
	name = "10x5 room spawner"
	room_width = 10
	room_height = 5

/obj/effect/spawner/room/threexthree
	name = "3x3 room spawner"
	room_width = 3
	room_height = 3

/* Ruins landmarks */
/obj/effect/spawner/room/cybersun
	name = "random cybersun warehouse room"
	dir = NORTH
	room_width = 6
	room_height = 7
	room_type = "cybersun"

/obj/effect/spawner/room/cybersun_med
	name = "random cybersun medical room"
	dir = NORTH
	room_width = 3
	room_height = 5
	room_type = "cybersun_med"
