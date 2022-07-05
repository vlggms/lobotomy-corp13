GLOBAL_LIST_EMPTY(abnormality_room_spawners)

// Room spawner for abnormalities
/obj/effect/spawner/abnormality_room
	name = "random room spawner"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "abno_room"
	dir = NORTH
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/datum/map_template/abnormality_room/template

/obj/effect/spawner/abnormality_room/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/abnormality_room/LateInitialize()
	template = new(cache = TRUE)
	GLOB.abnormality_room_spawners += src

/obj/effect/spawner/abnormality_room/proc/SpawnRoom()
	template.load(get_turf(src))
	qdel(src)

/obj/effect/spawner/abnormality_room/Destroy()
	GLOB.abnormality_room_spawners -= src
	..()
