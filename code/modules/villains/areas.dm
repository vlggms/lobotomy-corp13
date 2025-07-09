// Villains of the Night area definitions

// Base area for all villains game areas
/area/villains
	name = "Villains Game Area"
	icon_state = "green"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')

// Individual player rooms
/area/villains/player_room
	name = "Player Room"
	icon_state = "dorms"
	var/room_id = 0
	var/mob/living/simple_animal/hostile/villains_character/room_owner

/area/villains/player_room/Initialize()
	. = ..()
	// Rooms will be dynamically named when assigned to players
	name = "Unassigned Room [room_id]"

/area/villains/player_room/proc/assign_to_player(mob/living/simple_animal/hostile/villains_character/player)
	if(!player || !player.name)
		return FALSE
	room_owner = player
	name = "[player.name]'s Room"
	return TRUE

// Main gathering room where players meet
/area/villains/main_room
	name = "Main Hall"
	icon_state = "bar"

// Investigation area for examining crime scenes
/area/villains/investigation
	name = "Investigation Scene"
	icon_state = "detective"

// Hallways connecting rooms
/area/villains/hallway
	name = "Hallway"
	icon_state = "hallC"

// Special areas for different phases
/area/villains/trial_room
	name = "Trial Room"
	icon_state = "courtroom"

/area/villains/voting_booth
	name = "Voting Booth"
	icon_state = "purple"

// Storage areas where items can spawn
/area/villains/storage
	name = "Storage Room"
	icon_state = "storage"

// Outside area (if players can go outside)
/area/villains/outside
	name = "Outside"
	icon_state = "space"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	always_unpowered = TRUE