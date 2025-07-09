// Villains of the Night game controller

/datum/villains_controller
	var/name = "Villains of the Night"
	var/current_phase = VILLAIN_PHASE_SETUP
	var/phase_timer
	var/list/all_players = list()
	var/list/living_players = list()
	var/list/dead_players = list()
	var/list/spectators = list()
	var/list/player_role_lookup = list()
	
	// Victory tracking
	var/list/victory_points = list()
	var/mob/living/simple_animal/hostile/villains_character/current_villain
	var/last_eliminated
	
	// Voting system
	var/list/current_votes = list()
	var/voting_phase
	
	// Item tracking
	var/list/spawned_items = list()
	var/list/used_items = list()
	
	// Map references
	var/area/villains_area
	var/list/player_rooms = list() // room_id = landmark
	var/list/room_doors = list() // room_id = door
	var/list/player_room_assignments = list() // player = room_id
	var/list/room_landmarks = list() // List of room landmarks found in the map
	var/turf/main_room_center
	var/datum/map_template/villains/current_map
	var/datum/map_generator/massdelete/map_deleter
	
	// Character selection
	var/list/datum/villains_character/available_characters = list()
	var/list/selected_characters = list()
	var/character_selection_phase = FALSE
	
	// UI references
	// UI is handled directly on the controller

/datum/villains_controller/New()
	phase_timer = addtimer(CALLBACK(src, .proc/setup_game), 1 MINUTES, TIMER_STOPPABLE)
	map_deleter = new

/datum/villains_controller/Destroy()
	if(phase_timer)
		deltimer(phase_timer)
	reset_game()
	QDEL_NULL(map_deleter)
	return ..()

/datum/villains_controller/proc/reset_game()
	current_phase = VILLAIN_PHASE_SETUP
	all_players.Cut()
	living_players.Cut()
	dead_players.Cut()
	spectators.Cut()
	player_role_lookup.Cut()
	victory_points.Cut()
	current_votes.Cut()
	spawned_items.Cut()
	used_items.Cut()
	player_rooms.Cut()
	room_doors.Cut()
	player_room_assignments.Cut()
	room_landmarks.Cut()
	
	// Clean up the map
	if(map_deleter)
		map_deleter.generate()
	
	// Clear signup lists
	GLOB.villains_signup.Cut()
	GLOB.villains_bad_signup.Cut()
	
	// Clear global reference
	if(GLOB.villains_game == src)
		GLOB.villains_game = null

/datum/villains_controller/proc/load_map()
	// Find the spawn landmark
	var/turf/spawn_area = get_turf(locate(/obj/effect/landmark/villains_game_area) in GLOB.landmarks_list)
	if(!spawn_area)
		log_game("ERROR: No villains game area landmark found!")
		return FALSE
	
	// Get available map templates
	var/list/possible_maps = subtypesof(/datum/map_template/villains)
	if(!length(possible_maps))
		log_game("ERROR: No villains map templates found!")
		return FALSE
	
	// Pick and load a random map
	current_map = pick(possible_maps)
	current_map = new current_map
	
	var/list/bounds = current_map.load(spawn_area)
	if(!bounds)
		log_game("ERROR: Failed to load villains map [current_map.name]!")
		return FALSE
	
	// Setup the map deleter for cleanup
	// The mafia maps are 24x24, but villains maps might be different sizes
	// We'll calculate based on the template's actual size
	var/map_width = current_map.width - 1
	var/map_height = current_map.height - 1
	map_deleter.defineRegion(spawn_area, locate(spawn_area.x + map_width, spawn_area.y + map_height, spawn_area.z), replace = TRUE)
	
	// Find the villains area in the loaded map
	villains_area = locate(/area/villains) in world
	
	log_game("Villains map [current_map.name] loaded successfully at [spawn_area.x],[spawn_area.y],[spawn_area.z]")
	to_chat(world, span_notice("Loading map: [current_map.name]"))
	
	return TRUE

/datum/villains_controller/proc/setup_game()
	if(length(GLOB.villains_signup) < VILLAINS_MIN_PLAYERS)
		to_chat(world, span_notice("Not enough players signed up for Villains of the Night. Need at least [VILLAINS_MIN_PLAYERS] players."))
		qdel(src)
		return
	
	// Load the map
	if(!load_map())
		to_chat(world, span_boldwarning("Failed to load Villains map! Game cancelled."))
		qdel(src)
		return
	
	// Initialize available characters
	available_characters = get_villains_characters()
	
	// Start character selection phase
	character_selection_phase = TRUE
	announce_phase("Character Selection")
	
	// Give players time to select characters
	phase_timer = addtimer(CALLBACK(src, .proc/finalize_character_selection), 30 SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/announce_phase(phase_name)
	to_chat(world, span_greenannounce("Villains of the Night: [phase_name] phase has begun!"))

/datum/villains_controller/proc/change_phase(new_phase)
	current_phase = new_phase
	SEND_SIGNAL(src, COMSIG_VILLAIN_PHASE_CHANGE, new_phase)
	
	switch(new_phase)
		if(VILLAIN_PHASE_MORNING)
			start_morning_phase()
		if(VILLAIN_PHASE_EVENING)
			start_evening_phase()
		if(VILLAIN_PHASE_NIGHTTIME)
			start_nighttime_phase()
		if(VILLAIN_PHASE_INVESTIGATION)
			start_investigation_phase()
		if(VILLAIN_PHASE_ALIBI)
			start_alibi_phase()
		if(VILLAIN_PHASE_DISCUSSION)
			start_discussion_phase()
		if(VILLAIN_PHASE_VOTING)
			start_voting_phase()
		if(VILLAIN_PHASE_RESULTS)
			start_results_phase()

/datum/villains_controller/proc/start_morning_phase()
	announce_phase("Morning")
	// Unlock all rooms
	unlock_all_rooms()
	// Spawn items around the map
	spawn_morning_items()
	// Set timer for phase end
	var/morning_time = last_eliminated ? 60 : VILLAIN_TIMER_MORNING_MIN
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_EVENING), morning_time SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_evening_phase()
	announce_phase("Evening")
	// Teleport players to their rooms
	teleport_all_to_rooms()
	// Lock players in rooms
	lock_all_rooms()
	// Remove "fresh" status from items
	remove_item_freshness()
	// Open action selection UI
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_NIGHTTIME), VILLAIN_TIMER_EVENING SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_nighttime_phase()
	announce_phase("Nighttime")
	// Process all actions in order
	process_night_actions()

/datum/villains_controller/proc/start_investigation_phase()
	announce_phase("Investigation")
	// Announce who was eliminated
	if(last_eliminated)
		to_chat(world, span_userdanger("[last_eliminated] has been eliminated!"))
	// Scatter used items with yellow outline
	scatter_evidence_items()
	phase_timer = addtimer(CALLBACK(src, .proc/start_trial_briefing), VILLAIN_TIMER_INVESTIGATION SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_trial_briefing()
	// Teleport everyone to main room
	teleport_to_main_room()
	// Lock the room
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_ALIBI), 2 MINUTES, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_alibi_phase()
	announce_phase("Alibi")
	// Each player gets time to speak
	// TODO: Implement alibi system

/datum/villains_controller/proc/start_discussion_phase()
	announce_phase("Discussion")
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_VOTING), VILLAIN_TIMER_DISCUSSION_MIN SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_voting_phase()
	announce_phase("Final Voting")
	current_votes.Cut()
	voting_phase = TRUE
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_RESULTS), VILLAIN_TIMER_VOTING SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_results_phase()
	announce_phase("Results")
	voting_phase = FALSE
	tally_votes()

// Character selection procs
/datum/villains_controller/proc/select_character(mob/user, character_id)
	if(!character_selection_phase)
		to_chat(user, span_warning("Character selection phase is over!"))
		return FALSE
	
	if(!(user.ckey in GLOB.villains_signup))
		to_chat(user, span_warning("You are not signed up for this game!"))
		return FALSE
	
	if(character_id in selected_characters)
		to_chat(user, span_warning("That character has already been selected!"))
		return FALSE
	
	// Remove any previous selection
	for(var/id in selected_characters)
		if(selected_characters[id] == user.ckey)
			selected_characters -= id
			break
	
	selected_characters[character_id] = user.ckey
	to_chat(user, span_notice("You have selected [available_characters[character_id].name]."))
	return TRUE

/datum/villains_controller/proc/finalize_character_selection()
	character_selection_phase = FALSE
	
	// Assign remaining players random characters
	var/list/unassigned = list()
	for(var/ckey in GLOB.villains_signup)
		var/found = FALSE
		for(var/id in selected_characters)
			if(selected_characters[id] == ckey)
				found = TRUE
				break
		if(!found)
			unassigned += ckey
	
	var/list/unused_characters = list()
	for(var/id in available_characters)
		if(!(id in selected_characters))
			unused_characters += id
	
	for(var/ckey in unassigned)
		if(!length(unused_characters))
			break
		var/char_id = pick(unused_characters)
		selected_characters[char_id] = ckey
		unused_characters -= char_id
	
	// Setup room system
	setup_rooms()
	
	// Spawn character mobs
	spawn_character_mobs()
	
	// Select villain
	select_villain()
	
	// Start morning phase
	change_phase(VILLAIN_PHASE_MORNING)

/datum/villains_controller/proc/spawn_character_mobs()
	for(var/char_id in selected_characters)
		var/ckey = selected_characters[char_id]
		var/mob/dead/observer/ghost = locate_ghost(ckey)
		if(!ghost)
			continue
		
		var/datum/villains_character/character = available_characters[char_id]
		
		// Create the character mob first
		var/mob/living/simple_animal/hostile/villains_character/new_mob = new(get_turf(main_room_center), character, ghost)
		all_players += new_mob
		living_players += new_mob
		player_role_lookup[new_mob] = character
		
		// Assign a room to this player
		var/datum/villains_room/room = assign_room_to_player(new_mob)
		if(!room)
			to_chat(new_mob, span_warning("No room available! You'll spawn in the main hall."))
		else
			// Teleport to their room
			room.teleport_owner_to_room()
			to_chat(new_mob, span_notice("You have been assigned to [room.room_door?.name || "Room [room.room_id]"]."))
		
		to_chat(new_mob, span_notice("You are playing as [character.name]!"))
		to_chat(new_mob, span_notice("[character.desc]"))

/datum/villains_controller/proc/locate_ghost(ckey)
	for(var/mob/dead/observer/O in GLOB.player_list)
		if(O.ckey == ckey)
			return O
	return null

/datum/villains_controller/proc/select_villain()
	if(!length(living_players))
		return
	
	// Weight selection based on character villain_weight
	var/list/weighted_players = list()
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		var/weight = player.character_data?.villain_weight || 1
		weighted_players[player] = weight
	
	current_villain = pickweight(weighted_players)
	current_villain.is_villain = TRUE
	to_chat(current_villain, span_boldwarning("You are the villain! Eliminate another player to win!"))

// Death handling
/datum/villains_controller/proc/handle_death(mob/living/simple_animal/hostile/villains_character/victim)
	if(victim in living_players)
		living_players -= victim
		dead_players += victim
		last_eliminated = victim.name
		
		// Check if we need investigation phase
		if(current_phase == VILLAIN_PHASE_NIGHTTIME)
			change_phase(VILLAIN_PHASE_INVESTIGATION)

// Helper procs
/datum/villains_controller/proc/spawn_morning_items()
	if(!villains_area)
		return
	spawned_items = spawn_villains_items(villains_area, 10)


/datum/villains_controller/proc/remove_item_freshness()
	for(var/obj/item/villains/I in spawned_items)
		I.freshness = VILLAIN_ITEM_USED
		I.update_outline()

/datum/villains_controller/proc/process_night_actions()
	// TODO: Implement action processing

/datum/villains_controller/proc/scatter_evidence_items()
	// TODO: Scatter used items as evidence

/datum/villains_controller/proc/teleport_to_main_room()
	if(!main_room_center)
		// Try to find main room landmark
		var/obj/effect/landmark/villains/main_room/main_spawn = locate() in world
		if(main_spawn)
			main_room_center = get_turf(main_spawn)
	
	if(!main_room_center)
		return
	
	// Unlock all doors first
	unlock_all_rooms()
	
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		player.forceMove(main_room_center)

/datum/villains_controller/proc/tally_votes()
	// TODO: Count votes and determine results

// Room management procs
/datum/villains_controller/proc/setup_rooms()
	// Clear any existing room data first
	player_rooms.Cut()
	room_doors.Cut()
	
	// Find main room center within the loaded map
	var/obj/effect/landmark/villains/main_room/landmark = locate() in world
	if(landmark)
		main_room_center = get_turf(landmark)
	
	if(!main_room_center)
		to_chat(world, span_warning("No main room landmark found for Villains game!"))
		return
	
	// Call the new setup_player_rooms function
	setup_player_rooms()

/datum/villains_controller/proc/register_room_door(room_id, obj/machinery/door/airlock/door)
	room_doors[room_id] = door

/datum/villains_controller/proc/assign_player_room(ckey)
	// Find an unassigned room
	for(var/room_id in player_rooms)
		var/assigned = FALSE
		for(var/existing_ckey in player_room_assignments)
			if(player_room_assignments[existing_ckey] == room_id)
				assigned = TRUE
				break
		if(!assigned)
			player_room_assignments[ckey] = room_id
			return room_id
	
	// No rooms available
	to_chat(world, span_warning("Not enough rooms for all players!"))
	return null


// Room Management
/datum/villains_controller/proc/register_room_landmark(obj/effect/landmark/villains/player_room/landmark)
	if(!landmark)
		return
	room_landmarks += landmark

/datum/villains_controller/proc/setup_player_rooms()
	// Create room datums for each landmark
	for(var/obj/effect/landmark/villains/player_room/landmark in room_landmarks)
		var/datum/villains_room/room = new
		// Use the room_id from the landmark if it's set, otherwise generate one
		if(landmark.room_id)
			room.room_id = landmark.room_id
		else
			room.room_id = length(player_rooms) + 1
			landmark.room_id = room.room_id
		room.spawn_landmark = landmark
		landmark.assigned_room = room
		
		// Find associated door landmark
		for(var/obj/effect/landmark/villains/room_door/door_landmark in world)
			if(door_landmark.room_id == room.room_id)
				// Spawn an airlock at the door location
				var/obj/machinery/door/airlock/A = new /obj/machinery/door/airlock/silver(get_turf(door_landmark))
				A.name = "Room [room.room_id] Door"
				room.room_door = A
				door_landmark.spawned_door = A
				qdel(door_landmark) // Clean up the landmark
				break
		
		// Find the room area at the landmark's location
		var/area/villains/player_room/room_area = get_area(landmark)
		if(istype(room_area))
			room_area.room_id = room.room_id
		room.room_area = room_area
		
		player_rooms["[room.room_id]"] = room

/datum/villains_controller/proc/assign_room_to_player(mob/living/simple_animal/hostile/villains_character/player)
	if(!player)
		return null
	
	// Find an unassigned room
	for(var/room_key in player_rooms)
		var/datum/villains_room/room = player_rooms[room_key]
		if(!room.owner)
			room.owner = player
			player.assigned_room = room
			
			// Update room area name
			if(room.room_area)
				room.room_area.assign_to_player(player)
			
			// Update door name
			if(room.room_door)
				room.room_door.name = "[player.name]'s Room"
			
			return room
	
	return null

/datum/villains_controller/proc/lock_all_rooms()
	for(var/room_key in player_rooms)
		var/datum/villains_room/room = player_rooms[room_key]
		room.lock_door()
	
	to_chat(living_players, span_warning("All room doors have been locked for the evening."))

/datum/villains_controller/proc/unlock_all_rooms()
	for(var/room_key in player_rooms)
		var/datum/villains_room/room = player_rooms[room_key]
		room.unlock_door()
	
	to_chat(living_players, span_notice("All room doors have been unlocked."))

/datum/villains_controller/proc/teleport_all_to_rooms()
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player.assigned_room)
			player.assigned_room.teleport_owner_to_room()

/datum/villains_controller/proc/teleport_all_to_main_room()
	if(!main_room_center)
		var/obj/effect/landmark/villains/main_room/landmark = locate() in world
		if(landmark)
			main_room_center = get_turf(landmark)
	
	if(!main_room_center)
		return FALSE
	
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		player.forceMove(main_room_center)
	
	return TRUE

// UI interaction
/datum/villains_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VillainsPanel")
		ui.open()

// Global proc to create a new game
/proc/create_villains_game()
	if(GLOB.villains_game)
		return GLOB.villains_game
	
	var/datum/villains_controller/game = new
	GLOB.villains_game = game
	return game