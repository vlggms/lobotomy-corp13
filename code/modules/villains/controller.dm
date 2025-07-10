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

	// Debug features
	var/list/fake_players = list()
	var/debug_mode = FALSE

	// UI references
	// UI is handled directly on the controller

/datum/villains_controller/New()
	// Don't start timer immediately - wait for first player
	log_game("DEBUG: Villains controller created")
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

/datum/villains_controller/proc/setup_game(force_start = FALSE)
	if(!force_start && length(GLOB.villains_signup) < VILLAINS_MIN_PLAYERS)
		to_chat(world, span_notice("Not enough players signed up for Villains of the Night. Need at least [VILLAINS_MIN_PLAYERS] players."))
		qdel(src)
		return

	if(force_start && length(GLOB.villains_signup) < VILLAINS_MIN_PLAYERS)
		to_chat(world, span_boldwarning("Admin force starting game with only [length(GLOB.villains_signup)] players (minimum: [VILLAINS_MIN_PLAYERS])."))

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
		var/turf/spawn_turf = main_room_center ? get_turf(main_room_center) : get_turf(ghost)
		if(!spawn_turf)
			to_chat(ghost, span_warning("Failed to find a valid spawn location!"))
			continue
		var/mob/living/simple_animal/hostile/villains_character/new_mob = new(spawn_turf, character, ghost)
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

/datum/villains_controller/proc/get_player_character(mob/user)
	if(!user?.ckey)
		return null

	for(var/mob/living/simple_animal/hostile/villains_character/character in all_players)
		if(character.ckey == user.ckey)
			return character

	return null

/datum/villains_controller/proc/get_phase_name(phase)
	switch(phase)
		if(VILLAIN_PHASE_SETUP)
			return "setup"
		if(VILLAIN_PHASE_MORNING)
			return "morning"
		if(VILLAIN_PHASE_EVENING)
			return "evening"
		if(VILLAIN_PHASE_NIGHTTIME)
			return "nighttime"
		if(VILLAIN_PHASE_INVESTIGATION)
			return "investigation"
		if(VILLAIN_PHASE_ALIBI)
			return "alibi"
		if(VILLAIN_PHASE_DISCUSSION)
			return "discussion"
		if(VILLAIN_PHASE_VOTING)
			return "voting"
		if(VILLAIN_PHASE_RESULTS)
			return "results"
	return "unknown"

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
		// Try to find any turf in the villains area as fallback
		if(villains_area)
			main_room_center = locate(/turf) in villains_area
		if(!main_room_center)
			to_chat(world, span_boldwarning("CRITICAL: Cannot find any valid spawn location for Villains game!"))
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
	log_game("DEBUG: ui_interact called for [user] (ckey: [user.ckey])")
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		log_game("DEBUG: Creating new UI for [user]")
		ui = new(user, src, "VillainsPanel")
		ui.open()
		log_game("DEBUG: UI opened for [user]")

/datum/villains_controller/ui_state(mob/user)
	log_game("DEBUG: ui_state called for [user]")
	return GLOB.always_state

/datum/villains_controller/ui_data(mob/user)
	log_game("DEBUG: ui_data called for [user]")
	var/list/data = list()
	data["phase"] = get_phase_name(current_phase)
	data["signup_count"] = length(GLOB.villains_signup)
	data["min_players"] = VILLAINS_MIN_PLAYERS
	data["max_players"] = VILLAINS_MAX_PLAYERS
	data["signed_up"] = (user.ckey in GLOB.villains_signup)
	data["character_selection_phase"] = character_selection_phase

	// Calculate time remaining if there's a timer
	if(phase_timer)
		var/time_left = timeleft(phase_timer)
		if(time_left > 0)
			data["time_remaining"] = round(time_left / 10) // Convert deciseconds to seconds

	// Character selection data
	if(character_selection_phase && available_characters)
		var/list/char_data = list()
		for(var/char_id in available_characters)
			var/datum/villains_character/character = available_characters[char_id]
			var/list/char_info = list(
				"id" = char_id,
				"name" = character.name,
				"desc" = character.desc,
				"taken" = (char_id in selected_characters && selected_characters[char_id] != user.ckey)
			)

			// Add ability information
			if(character.active_ability_name)
				char_info["active_ability"] = list(
					"name" = character.active_ability_name,
					"desc" = character.active_ability_desc,
					"type" = character.active_ability_type,
					"cost" = character.active_ability_cost
				)

			if(character.passive_ability_name)
				char_info["passive_ability"] = list(
					"name" = character.passive_ability_name,
					"desc" = character.passive_ability_desc
				)

			char_data += list(char_info)
		data["available_characters"] = char_data

		// Check if user has selected a character
		for(var/id in selected_characters)
			if(selected_characters[id] == user.ckey)
				data["selected_character"] = id
				break

	// Evening phase data
	if(current_phase == VILLAIN_PHASE_EVENING)
		// Always send living players list during evening phase
		var/list/players_data = list()
		for(var/mob/living/simple_animal/hostile/villains_character/P in living_players)
			players_data += list(list(
				"name" = P.name,
				"ref" = REF(P)
			))
		data["living_players"] = players_data

		// Player-specific data
		var/mob/living/simple_animal/hostile/villains_character/player = get_player_character(user)
		data["has_character"] = (player != null)

		if(player)
			data["is_villain"] = player.is_villain

			// Always initialize data structures
			var/list/ability_data = list()
			var/list/inventory_data = list()

			// Available actions
			if(player.character_data && player.character_data.active_ability_name)
				ability_data["active_ability"] = list(
					"name" = player.character_data.active_ability_name,
					"type" = player.character_data.active_ability_type,
					"cost" = player.character_data.active_ability_cost,
					"description" = player.character_data.active_ability_desc
				)

			// Inventory
			for(var/obj/item/villains/I in player.contents)
				inventory_data += list(list(
					"name" = I.name,
					"ref" = REF(I),
					"type" = I.action_type,
					"cost" = I.action_cost,
					"description" = I.desc
				))

			// Always set the data, even if empty
			data["available_actions"] = ability_data
			data["inventory"] = inventory_data
		else
			// Default values for spectators
			data["is_villain"] = FALSE
			data["available_actions"] = list()
			data["inventory"] = list()

	// Voting phase data
	if(current_phase == VILLAIN_PHASE_VOTING)
		var/mob/living/simple_animal/hostile/villains_character/voter = get_player_character(user)
		if(voter)
			// Check current vote
			for(var/mob/living/simple_animal/hostile/villains_character/candidate in current_votes)
				if(current_votes[candidate] == voter)
					data["current_vote"] = REF(candidate)
					break

			// Voting candidates
			var/list/candidates_data = list()
			for(var/mob/living/simple_animal/hostile/villains_character/C in living_players)
				var/vote_count = 0
				for(var/mob/living/simple_animal/hostile/villains_character/V in current_votes)
					if(current_votes[V] == C)
						vote_count++

				candidates_data += list(list(
					"name" = C.name,
					"ref" = REF(C),
					"character" = C.character_data?.name || "Unknown",
					"vote_count" = vote_count
				))
			data["voting_candidates"] = candidates_data

	// Debug data
	if(user.client?.holder)
		data["debug_mode"] = debug_mode

		// All players list for debug controls
		var/list/all_players_data = list()
		for(var/mob/living/simple_animal/hostile/villains_character/P in all_players)
			all_players_data += list(list(
				"name" = P.name,
				"ref" = REF(P),
				"character" = P.character_data?.character_id || "unknown",
				"alive" = (P in living_players),
				"is_villain" = P.is_villain,
				"is_fake" = (P.ckey in fake_players),
				"room" = P.assigned_room?.room_id || "none"
			))
		data["debug_all_players"] = all_players_data

		// Fake player count
		data["fake_player_count"] = length(fake_players)

		// List all possible phases for admin phase selection
		data["all_phases"] = list(
			"setup",
			"morning",
			"evening",
			"nighttime",
			"investigation",
			"alibi",
			"discussion",
			"voting",
			"results"
		)

	return data

/datum/villains_controller/ui_static_data(mob/user)
	var/list/data = list()

	// Check if user is an admin
	data["is_admin"] = FALSE
	if(user.client?.holder)
		data["is_admin"] = TRUE

	return data

/datum/villains_controller/ui_act(action, params)
	. = ..()
	if(. && !usr.client?.holder) // Allow admins to bypass proximity checks
		return

	var/mob/user = usr
	if(!user.ckey)
		return

	switch(action)
		if("signup")
			if(current_phase != VILLAIN_PHASE_SETUP)
				to_chat(user, span_warning("The game has already started!"))
				return TRUE

			if(length(GLOB.villains_signup) >= VILLAINS_MAX_PLAYERS)
				to_chat(user, span_warning("The game is full!"))
				return TRUE

			if(!(user.ckey in GLOB.villains_signup))
				log_game("DEBUG: Adding [user.ckey] to signup list")
				GLOB.villains_signup += user.ckey
				to_chat(user, span_notice("You have signed up for Villains of the Night!"))
				log_game("DEBUG: [user.ckey] signed up successfully. Total signups: [length(GLOB.villains_signup)]")

				// Start timer when first player signs up
				if(length(GLOB.villains_signup) == 1)
					start_signup_timer()

				// Announce to other players
				for(var/mob/dead/observer/O in GLOB.player_list)
					if(O != user && O.client)
						to_chat(O, span_notice("[user.ckey] has signed up for Villains of the Night! ([length(GLOB.villains_signup)]/[VILLAINS_MAX_PLAYERS])"))
			return TRUE

		if("leave")
			if(current_phase != VILLAIN_PHASE_SETUP)
				to_chat(user, span_warning("You cannot leave after the game has started!"))
				return TRUE

			if(user.ckey in GLOB.villains_signup)
				GLOB.villains_signup -= user.ckey
				to_chat(user, span_notice("You have left the Villains of the Night signup."))

				// Cancel timer if no players left
				if(!length(GLOB.villains_signup) && phase_timer)
					deltimer(phase_timer)
					phase_timer = null

				// Remove character selection if any
				for(var/id in selected_characters)
					if(selected_characters[id] == user.ckey)
						selected_characters -= id
						break

				// Announce to other players
				for(var/mob/dead/observer/O in GLOB.player_list)
					if(O != user && O.client)
						to_chat(O, span_notice("[user.ckey] has left the Villains of the Night signup. ([length(GLOB.villains_signup)]/[VILLAINS_MAX_PLAYERS])"))
			return TRUE

		if("select_character")
			var/character_id = params["character_id"]
			if(character_id)
				select_character(user, character_id)
			return TRUE

		// Admin-only actions
		if("admin_force_start")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to force start the Villains game"))
				return

			if(current_phase != VILLAIN_PHASE_SETUP)
				to_chat(user, span_warning("The game has already started!"))
				return TRUE

			// Cancel the existing timer if any
			if(phase_timer)
				deltimer(phase_timer)
				phase_timer = null

			// Start the game immediately with force start
			setup_game(TRUE)
			return TRUE

		if("admin_skip_phase")
			var/new_phase_name = params["phase"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to skip to phase: [new_phase_name]"))
				return

			// Convert phase name to constant
			var/new_phase
			switch(new_phase_name)
				if("setup")
					new_phase = VILLAIN_PHASE_SETUP
				if("morning")
					new_phase = VILLAIN_PHASE_MORNING
				if("evening")
					new_phase = VILLAIN_PHASE_EVENING
				if("nighttime")
					new_phase = VILLAIN_PHASE_NIGHTTIME
				if("investigation")
					new_phase = VILLAIN_PHASE_INVESTIGATION
				if("alibi")
					new_phase = VILLAIN_PHASE_ALIBI
				if("discussion")
					new_phase = VILLAIN_PHASE_DISCUSSION
				if("voting")
					new_phase = VILLAIN_PHASE_VOTING
				if("results")
					new_phase = VILLAIN_PHASE_RESULTS
				else
					return

			// Cancel current timer
			if(phase_timer)
				deltimer(phase_timer)
				phase_timer = null

			change_phase(new_phase)
			return TRUE

		if("admin_add_ghost")
			var/ghost_ckey = params["ckey"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to add [ghost_ckey] to Villains game"))
				return

			if(!ghost_ckey)
				return

			// Find the ghost by ckey
			var/mob/dead/observer/ghost = locate_ghost(ghost_ckey)
			if(!ghost)
				to_chat(user, span_warning("Ghost not found!"))
				return TRUE

			if(!(ghost.ckey in GLOB.villains_signup))
				GLOB.villains_signup += ghost.ckey
				to_chat(ghost, span_notice("You have been added to the Villains game by an admin!"))
				to_chat(user, span_notice("[ghost.ckey] has been added to the game."))
			return TRUE

		if("admin_force_end")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to force end the Villains game"))
				return

			to_chat(world, span_boldwarning("The Villains game has been forcefully ended by an administrator."))
			qdel(src)
			return TRUE

		if("admin_set_timer")
			var/minutes = params["minutes"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to set phase timer to [minutes] minutes"))
				return

			if(!isnum(minutes) || minutes < 0)
				return

			// Cancel current timer
			if(phase_timer)
				deltimer(phase_timer)

			// Set new timer
			if(minutes > 0)
				phase_timer = addtimer(CALLBACK(src, .proc/handle_phase_timer), minutes MINUTES, TIMER_STOPPABLE)
				to_chat(user, span_notice("Phase timer set to [minutes] minutes."))
			else
				phase_timer = null
				to_chat(user, span_notice("Phase timer cancelled."))
			return TRUE

		if("submit_evening_actions")
			if(current_phase != VILLAIN_PHASE_EVENING)
				return

			var/mob/living/simple_animal/hostile/villains_character/player = get_player_character(user)
			if(!player)
				return

			var/main_action = params["main_action"]
			var/main_target_ref = params["main_target"]
			// TODO: Implement secondary actions
			// var/secondary_action = params["secondary_action"]
			// var/secondary_target_ref = params["secondary_target"]

			if(!main_action || !main_target_ref)
				to_chat(user, span_warning("You must select a main action and target!"))
				return TRUE

			// Store the action selections (implement this based on your action system)
			// For now, just acknowledge the submission
			to_chat(user, span_notice("Your actions have been submitted for tonight."))
			return TRUE

		if("vote_player")
			if(current_phase != VILLAIN_PHASE_VOTING)
				return

			var/mob/living/simple_animal/hostile/villains_character/voter = get_player_character(user)
			if(!voter || !(voter in living_players))
				return

			var/player_ref = params["player_ref"]
			if(!player_ref)
				return

			var/mob/living/simple_animal/hostile/villains_character/target = locate(player_ref)
			if(!target || !(target in living_players))
				return

			// Remove any previous vote
			for(var/mob/living/simple_animal/hostile/villains_character/C in current_votes)
				if(current_votes[C] == voter)
					current_votes -= C
					break

			// Add new vote
			current_votes[target] = voter
			to_chat(user, span_notice("You have voted for [target.name]."))
			return TRUE

		// Debug actions
		if("debug_create_fake_player")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] created a fake player in Villains game"))
				return
			create_fake_player()
			return TRUE

		if("debug_create_multiple_fake")
			var/count = params["count"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] created [count] fake players in Villains game"))
				return
			create_multiple_fake_players(count)
			return TRUE

		if("debug_spawn_items")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] spawned all items in Villains game"))
				return
			spawn_all_items()
			return TRUE

		if("debug_kill_player")
			var/player_ref = params["player_ref"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] killed a player in Villains game"))
				return
			var/mob/living/simple_animal/hostile/villains_character/target = locate(player_ref)
			if(target)
				kill_player(target)
			return TRUE

		if("debug_set_villain")
			var/player_ref = params["player_ref"]
			if(!log_action(user, admin_action = TRUE, message_override = "[user] set villain in Villains game"))
				return
			var/mob/living/simple_animal/hostile/villains_character/target = locate(player_ref)
			if(target)
				set_villain(target)
			return TRUE

		if("debug_simulate_actions")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] simulated fake player actions in Villains game"))
				return
			simulate_fake_player_actions()
			return TRUE

		if("debug_instant_process")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] instantly processed actions in Villains game"))
				return
			instant_process_actions()
			return TRUE

		if("debug_show_state")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] requested game state in Villains game"))
				return
			var/summary = get_game_state_summary()
			to_chat(user, span_adminnotice("=== VILLAINS GAME STATE ===\n[summary]"))
			return TRUE

/datum/villains_controller/proc/start_signup_timer()
	log_game("DEBUG: start_signup_timer called. phase_timer: [phase_timer], current_phase: [current_phase]")
	if(!phase_timer && current_phase == VILLAIN_PHASE_SETUP)
		log_game("DEBUG: Starting signup timer")
		to_chat(world, span_greenannounce("Villains of the Night signup has begun! The game will start in 1 minute."))
		phase_timer = addtimer(CALLBACK(src, .proc/setup_game), 1 MINUTES, TIMER_STOPPABLE)
		log_game("DEBUG: Timer started: [phase_timer]")

// Helper proc for phase timer handling
/datum/villains_controller/proc/handle_phase_timer()
	// This proc will be called when admin sets a custom timer
	// Determine what to do based on current phase
	switch(current_phase)
		if(VILLAIN_PHASE_SETUP)
			setup_game()
		if(VILLAIN_PHASE_MORNING)
			change_phase(VILLAIN_PHASE_EVENING)
		if(VILLAIN_PHASE_EVENING)
			change_phase(VILLAIN_PHASE_NIGHTTIME)
		if(VILLAIN_PHASE_NIGHTTIME)
			if(last_eliminated)
				change_phase(VILLAIN_PHASE_INVESTIGATION)
			else
				change_phase(VILLAIN_PHASE_MORNING)
		if(VILLAIN_PHASE_INVESTIGATION)
			start_trial_briefing()
		if(VILLAIN_PHASE_ALIBI)
			change_phase(VILLAIN_PHASE_DISCUSSION)
		if(VILLAIN_PHASE_DISCUSSION)
			change_phase(VILLAIN_PHASE_VOTING)
		if(VILLAIN_PHASE_VOTING)
			change_phase(VILLAIN_PHASE_RESULTS)

/**
 * Logs interactions with the controller
 *
 * arguments:
 * (required) console_user = the user that is using the controller (usr)
 * (optional) admin_action = if the current action should be restricted for only admins
 * (optional/required) message_override = if set on any value other than FALSE, the logging message will be replaced by it
 */
/datum/villains_controller/proc/log_action(mob/console_user, admin_action = FALSE, message_override = FALSE)
	if(!console_user)
		CRASH("user not provided in (/datum/villains_controller/proc/log_action)")

	if(!admin_action)
		if(message_override)
			log_game(message_override)
			message_admins(message_override)
			return TRUE
		else
			CRASH("message_override not set up on a non-admin action within the Villains controller whilst its mandatory!")

	var/is_admin = console_user.client?.holder
	if(!is_admin)
		message_admins("[console_user] has used an admin-only option in the Villains UI whilst not an admin!")
		return FALSE

	if(message_override)
		log_game(message_override)
		message_admins(message_override)
		return TRUE

	log_game("[console_user] has used admin powers to trigger an admin-only action in the Villains controller")
	message_admins("[console_user] has used admin powers to trigger an admin-only action in the Villains controller")
	return TRUE

// Debug Methods
/datum/villains_controller/proc/create_fake_player(character_id = null)
	if(!debug_mode)
		debug_mode = TRUE
		to_chat(world, span_boldwarning("Debug mode activated for Villains game!"))

	// Pick a random character if none specified
	if(!character_id)
		var/list/unused_chars = list()
		for(var/id in available_characters)
			if(!(id in selected_characters))
				unused_chars += id
		if(!length(unused_chars))
			return null
		character_id = pick(unused_chars)

	// Generate fake ckey
	var/fake_ckey = "fakeplayer_[rand(1000,9999)]"
	while((fake_ckey in fake_players) || (fake_ckey in GLOB.villains_signup))
		fake_ckey = "fakeplayer_[rand(1000,9999)]"

	// Add to signup and select character
	GLOB.villains_signup += fake_ckey
	selected_characters[character_id] = fake_ckey
	fake_players += fake_ckey

	// If game is running, spawn the mob
	if(current_phase != VILLAIN_PHASE_SETUP)
		var/datum/villains_character/character = available_characters[character_id]
		var/turf/spawn_turf = main_room_center ? get_turf(main_room_center) : locate(/turf) in villains_area
		if(!spawn_turf)
			return null
		var/mob/living/simple_animal/hostile/villains_character/new_mob = new(spawn_turf, character)
		new_mob.ckey = fake_ckey
		new_mob.name = "[character.name] (AI)"
		all_players += new_mob
		living_players += new_mob
		player_role_lookup[new_mob] = character

		// Assign room
		var/datum/villains_room/room = assign_room_to_player(new_mob)
		if(room)
			room.teleport_owner_to_room()

		return new_mob

	return fake_ckey

/datum/villains_controller/proc/create_multiple_fake_players(count)
	var/created = 0
	for(var/i in 1 to count)
		if(create_fake_player())
			created++
	to_chat(world, span_notice("Created [created] fake players for testing."))

/datum/villains_controller/proc/force_player_action(mob/living/simple_animal/hostile/villains_character/player, action_type, mob/living/simple_animal/hostile/villains_character/target)
	if(!player || !target)
		return FALSE

	submit_action(player, action_type, target)
	to_chat(world, span_adminnotice("DEBUG: Forced [player] to perform [action_type] on [target]"))
	return TRUE

/datum/villains_controller/proc/spawn_all_items()
	if(!villains_area)
		return 0

	// Find all item spawn landmarks in the area
	var/list/spawn_points = list()
	for(var/obj/effect/landmark/villains/item_spawn/L in GLOB.landmarks_list)
		if(istype(get_area(L), villains_area))
			spawn_points += L

	if(!length(spawn_points))
		// Fallback to random turfs if no landmarks found
		var/list/turfs = get_area_turfs(villains_area)
		for(var/turf/T in turfs)
			spawn_points += T

	// Get all item types
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains
	var/spawned = 0

	for(var/item_type in item_types)
		if(!length(spawn_points))
			break
		var/spawn_loc = pick_n_take(spawn_points)
		var/obj/item/villains/I = new item_type(get_turf(spawn_loc))
		spawned_items += I
		spawned++

	to_chat(world, span_notice("DEBUG: Spawned [spawned] different item types at landmark locations."))
	return spawned

/datum/villains_controller/proc/give_item_to_player(mob/living/simple_animal/hostile/villains_character/player, item_type)
	if(!player)
		return FALSE

	var/obj/item/villains/I = new item_type(player)
	to_chat(world, span_adminnotice("DEBUG: Gave [I] to [player]"))
	return TRUE

/datum/villains_controller/proc/kill_player(mob/living/simple_animal/hostile/villains_character/victim)
	if(!victim || !(victim in living_players))
		return FALSE

	handle_death(victim)
	to_chat(world, span_adminnotice("DEBUG: Killed [victim]"))
	return TRUE

/datum/villains_controller/proc/set_villain(mob/living/simple_animal/hostile/villains_character/new_villain)
	if(!new_villain || !(new_villain in living_players))
		return FALSE

	// Remove old villain status
	if(current_villain)
		current_villain.is_villain = FALSE

	// Set new villain
	current_villain = new_villain
	new_villain.is_villain = TRUE
	to_chat(new_villain, span_boldwarning("You are now the villain!"))
	to_chat(world, span_adminnotice("DEBUG: [new_villain] is now the villain"))
	return TRUE

/datum/villains_controller/proc/simulate_fake_player_actions()
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(!(player.ckey in fake_players))
			continue

		// Pick random valid action
		var/list/possible_actions = list("talk_trade")
		if(player.character_data?.active_ability_name)
			possible_actions += "character_ability"
		if(player.is_villain)
			possible_actions += "eliminate"

		var/action = pick(possible_actions)
		var/mob/living/simple_animal/hostile/villains_character/target = pick(living_players - player)

		submit_action(player, action, target)

	to_chat(world, span_notice("DEBUG: All fake players have submitted random actions."))

/datum/villains_controller/proc/instant_process_actions()
	if(current_phase != VILLAIN_PHASE_NIGHTTIME)
		to_chat(world, span_warning("Can only process actions during nighttime phase!"))
		return

	// Process immediately instead of with delays
	process_night_actions()
	to_chat(world, span_adminnotice("DEBUG: Instantly processed all night actions"))

/datum/villains_controller/proc/get_game_state_summary()
	var/list/summary = list()
	summary += "Phase: [get_phase_name(current_phase)]"
	summary += "Living Players: [length(living_players)]"
	summary += "Dead Players: [length(dead_players)]"
	summary += "Current Villain: [current_villain?.name || "None"]"
	summary += "\nPlayers:"

	for(var/mob/living/simple_animal/hostile/villains_character/player in all_players)
		var/status = (player in living_players) ? "ALIVE" : "DEAD"
		var/villain_text = player.is_villain ? " (VILLAIN)" : ""
		var/ai_text = (player.ckey in fake_players) ? " \[AI\]" : ""
		summary += "- [player.name] ([player.character_data?.character_id]): [status][villain_text][ai_text]"

	return summary.Join("\n")

// Item spawning function that uses landmarks
/proc/spawn_villains_items(area/spawn_area, item_count = 10)
	if(!spawn_area)
		return list()

	// Find all item spawn landmarks in the area
	var/list/spawn_points = list()
	for(var/obj/effect/landmark/villains/item_spawn/L in GLOB.landmarks_list)
		spawn_points += L

	// if(!length(spawn_points))
	// 	// Fallback to random turfs if no landmarks found
	// 	var/list/turfs = get_area_turfs(spawn_area)
	// 	for(var/i in 1 to min(item_count, length(turfs)))
	// 		spawn_points += pick_n_take(turfs)

	// Get all item types
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains
	var/list/spawned = list()

	// Spawn items at random landmarks
	for(var/i in 1 to min(item_count, length(spawn_points)))
		var/spawn_loc = pick_n_take(spawn_points)
		var/item_type = pick(item_types)
		var/obj/item/villains/I = new item_type(get_turf(spawn_loc))
		spawned += I

	return spawned

// Global proc to create a new game
/proc/create_villains_game()
	if(GLOB.villains_game)
		return GLOB.villains_game

	var/datum/villains_controller/game = new
	GLOB.villains_game = game
	return game
