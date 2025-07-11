// Villains of the Night landmark definitions

// Game area spawn point - where the entire villains map will be loaded
/obj/effect/landmark/villains_game_area
	name = "Villains Area Spawn"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"

// Base landmark for villains game
/obj/effect/landmark/villains
	name = "villains landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"

// Player room spawn point - where a player's room will be created
/obj/effect/landmark/villains/player_room
	name = "villains player room"
	icon_state = "x"
	var/room_id = 0 // Will be assigned during setup
	var/datum/villains_room/assigned_room

/obj/effect/landmark/villains/player_room/Initialize()
	. = ..()
	// Register with the game controller if one exists
	// This will be called when the map loads, so the controller should exist
	if(GLOB.villains_game)
		var/datum/villains_controller/game = GLOB.villains_game
		game.register_room_landmark(src)

// Door landmark - marks where a room's door should be
/obj/effect/landmark/villains/room_door
	name = "villains room door"
	icon_state = "x"
	var/room_id = 0 // Must match the associated player_room landmark
	var/obj/machinery/door/airlock/spawned_door

// Main gathering room center
/obj/effect/landmark/villains/main_room
	name = "villains main room center"
	icon_state = "x2"

// Investigation scene marker
/obj/effect/landmark/villains/investigation_scene
	name = "villains investigation scene"
	icon_state = "x"

// Item spawn locations
/obj/effect/landmark/villains/item_spawn
	name = "villains item spawn"
	icon_state = "x"
	var/list/possible_items = list() // Will be populated during setup

// Room data structure
/datum/villains_room
	var/room_id = 0
	var/mob/living/simple_animal/hostile/villains_character/owner
	var/obj/effect/landmark/villains/player_room/spawn_landmark
	var/obj/machinery/door/airlock/room_door
	var/area/villains/player_room/room_area
	var/locked = FALSE

/datum/villains_room/proc/lock_door()
	if(!room_door)
		return FALSE
	// Close the door first if it's open
	if(room_door.density == FALSE)
		room_door.close()
	room_door.lock()
	locked = TRUE
	return TRUE

/datum/villains_room/proc/unlock_door()
	if(!room_door)
		return FALSE
	room_door.unlock()
	locked = FALSE
	return TRUE

/datum/villains_room/proc/teleport_owner_to_room()
	if(!owner || !spawn_landmark)
		return FALSE
	owner.forceMove(get_turf(spawn_landmark))
	return TRUE

/datum/villains_room/proc/is_owner_in_room()
	if(!owner || !room_area)
		return FALSE
	var/area/A = get_area(owner)
	return (A == room_area)