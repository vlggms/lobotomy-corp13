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
	var/game_active = FALSE

	// Action queue
	var/datum/villains_action_queue/action_queue
	var/list/last_night_actions = list() // Track actions from the last nighttime phase
	var/list/action_targets = list() // Track who was targeted by whom (target = list(performers))
	
	// Trade and contract history
	var/list/trade_history = list()
	var/list/contract_history = list()

	// Voting system
	var/list/current_votes = list()
	var/voting_phase
	
	// Alibi phase management
	var/mob/living/simple_animal/hostile/villains_character/current_speaker
	var/list/alibi_queue = list()
	var/alibi_timer
	var/alibi_index = 0

	// Item tracking
	var/list/spawned_items = list()
	var/list/used_items = list()
	var/list/evidence_list = list() // List of evidence descriptions for investigation phase

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
	action_queue = new(src)

/datum/villains_controller/Destroy()
	if(phase_timer)
		deltimer(phase_timer)
	reset_game()
	QDEL_NULL(map_deleter)
	QDEL_NULL(action_queue)
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
	alibi_queue.Cut()
	current_speaker = null
	if(alibi_timer)
		deltimer(alibi_timer)
		alibi_timer = null
	alibi_index = 0
	spawned_items.Cut()
	used_items.Cut()
	evidence_list.Cut()
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
	// Clear evidence status from previous investigation
	for(var/obj/item/villains/I in world)
		if(I.is_evidence)
			I.is_evidence = FALSE
	// Unlock all rooms
	unlock_all_rooms()
	// Spawn items around the map
	spawn_morning_items()

	// Trigger character phase change callbacks
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player.character_data)
			player.character_data.on_phase_change(VILLAIN_PHASE_MORNING, player, src)

	// Set timer for phase end
	var/morning_time = last_eliminated ? 60 : VILLAIN_TIMER_MORNING_MIN
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_EVENING), morning_time SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_evening_phase()
	announce_phase("Evening")
	// Teleport players to their rooms
	teleport_all_to_rooms()
	// Lock players in rooms
	lock_all_rooms()
	// Remove unpicked items
	remove_unpicked_items()
	// Remove "fresh" status from items
	remove_item_freshness()
	// Reset action blocks from previous night
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		player.main_action_blocked = FALSE  // Reset taser effect
		player.secondary_action_blocked = FALSE  // Reset bola effect
		player.action_blocked = FALSE  // Reset general action block (Sunset Traveller's passive)
		player.forsaken_counter_ready = FALSE  // Reset Forsaken Murder's counter
		player.main_action = null  // Clear previous action
		player.secondary_action = null  // Clear previous secondary action

		// Stop Rudolta's observation if active
		if(player.is_observing)
			player.stop_observing()
			UnregisterSignal(player.observing_target, COMSIG_MOVABLE_MOVED)
	// Open action selection UI
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_NIGHTTIME), VILLAIN_TIMER_EVENING SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_nighttime_phase()
	announce_phase("Nighttime")
	// Clear used items from previous nights
	used_items.Cut()
	// Process all actions in order
	process_night_actions()

/datum/villains_controller/proc/start_investigation_phase()
	announce_phase("Investigation")
	// Announce who was eliminated
	if(last_eliminated)
		to_chat(world, span_userdanger("[last_eliminated] has been eliminated!"))
		to_chat(living_players, span_boldwarning("A crime has been committed! Search for evidence to find the villain!"))
	
	// Unlock all rooms for investigation
	unlock_all_rooms()
	
	// Scatter evidence items and create residue markers
	scatter_evidence_items()
	
	// Give instructions
	to_chat(living_players, span_notice("You have [VILLAIN_TIMER_INVESTIGATION / 60] minutes to search for evidence:"))
	to_chat(living_players, span_notice("• Look for items with yellow outlines in the hallways"))
	to_chat(living_players, span_notice("• Click on evidence items to mark them as found and send them to the main room"))
	to_chat(living_players, span_notice("• Gather in the main room when the timer expires to review all found evidence"))
	
	phase_timer = addtimer(CALLBACK(src, .proc/start_trial_briefing), VILLAIN_TIMER_INVESTIGATION SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_trial_briefing()
	// Teleport everyone to main room
	teleport_to_main_room()
	
	// Announce the briefing phase
	to_chat(living_players, span_boldannounce("=== TRIAL BRIEFING ==="))
	to_chat(living_players, span_notice("All evidence has been gathered in the main room. You have 2 minutes to review the evidence and discuss before alibis begin."))
	to_chat(living_players, span_notice("Check your game panel to see the list of evidence found!"))
	
	// Lock the main room doors to prevent people from leaving
	for(var/obj/machinery/door/airlock/door in get_area(main_room_center))
		door.lock()
	
	// Start the 2 minute timer
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_ALIBI), 2 MINUTES, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_alibi_phase()
	announce_phase("Alibi")
	
	// Set up alibi queue with randomized order
	alibi_queue = shuffle(living_players.Copy())
	alibi_index = 0
	
	// Announce the alibi phase rules
	to_chat(living_players, span_boldannounce("=== ALIBI PHASE ==="))
	to_chat(living_players, span_notice("Each player will have 30 seconds to present their alibi."))
	to_chat(living_players, span_notice("Only the current speaker may talk normally. Others must whisper."))
	to_chat(living_players, span_notice("Speaking order has been randomized."))
	
	// Start the first player's turn
	if(length(alibi_queue))
		process_alibi_queue()
	else
		// No players to give alibis, skip to discussion
		change_phase(VILLAIN_PHASE_DISCUSSION)

/datum/villains_controller/proc/process_alibi_queue()
	// Check if we've gone through all players
	if(alibi_index >= length(alibi_queue))
		// All alibis complete, move to discussion
		end_current_alibi()
		change_phase(VILLAIN_PHASE_DISCUSSION)
		return
	
	// Get the next speaker
	alibi_index++
	var/mob/living/simple_animal/hostile/villains_character/speaker = alibi_queue[alibi_index]
	
	// Make sure the speaker is still alive
	if(!(speaker in living_players))
		// Skip dead players
		process_alibi_queue()
		return
	
	// Start this player's alibi turn
	start_player_alibi(speaker)

/datum/villains_controller/proc/start_player_alibi(mob/living/simple_animal/hostile/villains_character/speaker)
	// End previous speaker's turn if any
	if(current_speaker)
		end_current_alibi()
	
	// Set new speaker
	current_speaker = speaker
	
	// Force all other players to whisper
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player != speaker)
			player.forced_to_whisper = TRUE
		else
			player.forced_to_whisper = FALSE
	
	// Announce the new speaker
	to_chat(living_players, span_boldannounce("[speaker.name] is now presenting their alibi!"))
	to_chat(speaker, span_boldnotice("You have 30 seconds to present your alibi. You may speak normally."))
	to_chat(living_players - speaker, span_notice("You must whisper while [speaker.name] presents their alibi."))
	
	// Set the timer for this player's turn
	alibi_timer = addtimer(CALLBACK(src, .proc/end_alibi_turn), VILLAIN_TIMER_ALIBI_PER_PLAYER SECONDS, TIMER_STOPPABLE)
	
	// Add a 10-second warning
	addtimer(CALLBACK(src, .proc/alibi_time_warning, speaker), (VILLAIN_TIMER_ALIBI_PER_PLAYER - 10) SECONDS)

/datum/villains_controller/proc/alibi_time_warning(mob/living/simple_animal/hostile/villains_character/speaker)
	if(current_speaker == speaker)
		to_chat(speaker, span_warning("You have 10 seconds remaining for your alibi!"))

/datum/villains_controller/proc/end_alibi_turn()
	if(current_speaker)
		to_chat(current_speaker, span_notice("Your alibi time has ended."))
	
	// Process the next player in queue
	process_alibi_queue()

/datum/villains_controller/proc/end_current_alibi()
	// Clear the current speaker
	current_speaker = null
	
	// Cancel the timer if it exists
	if(alibi_timer)
		deltimer(alibi_timer)
		alibi_timer = null
	
	// Remove whisper restriction from all players
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		player.forced_to_whisper = FALSE

/datum/villains_controller/proc/start_discussion_phase()
	announce_phase("Discussion")
	
	// Make sure alibi phase is fully cleaned up
	end_current_alibi()
	
	to_chat(living_players, span_boldannounce("=== DISCUSSION PHASE ==="))
	to_chat(living_players, span_notice("All players may now speak freely. Discuss the evidence and alibis!"))
	
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_VOTING), VILLAIN_TIMER_DISCUSSION_MIN SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_voting_phase()
	announce_phase("Final Voting")
	current_votes.Cut()
	voting_phase = TRUE
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_RESULTS), VILLAIN_TIMER_VOTING SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/start_results_phase()
	announce_phase("Results")
	voting_phase = FALSE
	
	// Tally the votes and determine who to eliminate
	var/mob/living/simple_animal/hostile/villains_character/to_eliminate = tally_votes()
	
	if(to_eliminate)
		// Build suspense before elimination
		to_chat(world, span_userdanger("\n>>> [to_eliminate.name] has been eliminated by vote! <<<"))
		
		// Add dramatic pause
		sleep(2 SECONDS)
		
		// Kill the player with visual effect
		if(to_eliminate.stat != DEAD)
			// Add a red overlay before death
			to_eliminate.add_overlay(image('icons/effects/blood.dmi', "splatter"))
			playsound(to_eliminate, 'sound/effects/splat.ogg', 50, TRUE)
			to_eliminate.death()
		
		// Update game state
		handle_death(to_eliminate)
		
		// Another dramatic pause before reveal
		sleep(3 SECONDS)
		
		// Check win conditions and reveal
		if(to_eliminate.is_villain)
			// Villain was caught!
			to_chat(world, span_boldannounce("\n=== VILLAIN REVEALED ==="))
			to_chat(world, span_redtext("[to_eliminate.name] ([to_eliminate.character_data?.name]) was THE VILLAIN!"))
			to_chat(world, span_greentext("\nThe abnormalities have successfully identified and eliminated the villain!"))
			to_chat(world, span_greentext("ABNORMALITIES WIN!"))
			
			// Play victory sound
			for(var/mob/living/simple_animal/hostile/villains_character/winner in living_players)
				playsound(winner, 'sound/arcade/win.ogg', 50, FALSE)
			
			end_game("abnormalities")
			return
		else
			// Innocent was eliminated
			to_chat(world, span_warning("\n[to_eliminate.name] was INNOCENT!"))
			
			// Check if game should end
			if(living_players.len <= 2)
				// Check if only villain remains
				var/villain_alive = FALSE
				var/mob/living/simple_animal/hostile/villains_character/the_villain
				for(var/mob/living/simple_animal/hostile/villains_character/survivor in living_players)
					if(survivor.is_villain)
						villain_alive = TRUE
						the_villain = survivor
						break
				
				if(villain_alive)
					// Villain wins!
					sleep(2 SECONDS)
					to_chat(world, span_boldannounce("\n=== VILLAIN REVEALED ==="))
					to_chat(world, span_redtext("[the_villain.name] ([the_villain.character_data?.name]) was THE VILLAIN!"))
					to_chat(world, span_redtext("\nThe villain has successfully eliminated enough abnormalities!"))
					to_chat(world, span_redtext("VILLAIN WINS!"))
					
					// Evil laugh sound
					playsound(the_villain, 'sound/voice/human/manlaugh1.ogg', 50, FALSE)
					
					end_game("villain")
					return
	else
		to_chat(world, span_notice("\nNo one was eliminated this round."))
	
	// Clear votes for next round
	current_votes.Cut()
	
	// Start post-elimination discussion
	to_chat(world, span_boldnotice("\n=== POST-ROUND DISCUSSION ==="))
	to_chat(world, span_notice("You have 3.5 minutes to discuss before the next morning phase begins."))
	
	// Continue to next morning phase after discussion period
	phase_timer = addtimer(CALLBACK(src, .proc/change_phase, VILLAIN_PHASE_MORNING), VILLAIN_TIMER_RESULTS SECONDS, TIMER_STOPPABLE)

/datum/villains_controller/proc/end_game(winner)
	// Cancel any active timers
	if(phase_timer)
		deltimer(phase_timer)
		phase_timer = null
	
	// Announce the winner
	to_chat(world, span_boldannounce("\n=== GAME OVER ==="))
	
	// Find the villain for detailed stats
	var/mob/living/simple_animal/hostile/villains_character/the_villain
	for(var/mob/living/simple_animal/hostile/villains_character/player in all_players)
		if(player.is_villain)
			the_villain = player
			break
	
	switch(winner)
		if("villain")
			to_chat(world, span_redtext("The villain has won the game!"))
			if(the_villain)
				to_chat(world, span_boldwarning("The villain was: [the_villain.name] playing as [the_villain.character_data?.name]"))
		
		if("abnormalities")
			to_chat(world, span_greentext("The abnormalities have won the game!"))
			if(the_villain)
				to_chat(world, span_notice("The villain was: [the_villain.name] playing as [the_villain.character_data?.name]"))
	
	// Show game statistics
	to_chat(world, span_boldnotice("\n=== GAME STATISTICS ==="))
	
	// Show final vote tallies
	to_chat(world, span_notice("\nFinal Vote:"))
	if(length(current_votes))
		var/list/vote_summary = list()
		for(var/mob/living/simple_animal/hostile/villains_character/voter in current_votes)
			var/mob/living/simple_animal/hostile/villains_character/voted_for = current_votes[voter]
			if(voter && voted_for)
				vote_summary += "[voter.name] voted for [voted_for.name]"
		for(var/vote in vote_summary)
			to_chat(world, span_notice("• [vote]"))
	else
		to_chat(world, span_notice("No votes were cast in the final round."))
	
	// Show eliminations in order
	to_chat(world, span_notice("\nElimination Order:"))
	var/elim_count = 1
	for(var/mob/living/simple_animal/hostile/villains_character/dead in dead_players)
		var/death_type = dead.is_villain ? span_redtext(" (VILLAIN)") : ""
		to_chat(world, span_notice("[elim_count]. [dead.name] ([dead.character_data?.name])[death_type]"))
		elim_count++
	
	// Show final survivors
	to_chat(world, span_notice("\nFinal Survivors:"))
	for(var/mob/living/simple_animal/hostile/villains_character/survivor in living_players)
		var/role = survivor.is_villain ? span_redtext(" (VILLAIN)") : span_greentext(" (INNOCENT)")
		to_chat(world, span_notice("• [survivor.name] ([survivor.character_data?.name])[role]"))
	
	// Show villain's actions
	if(the_villain && length(last_night_actions))
		to_chat(world, span_notice("\nVillain's Night Actions:"))
		var/night_num = 1
		for(var/datum/villains_action/action in last_night_actions)
			if(action.performer == the_villain)
				to_chat(world, span_notice("• Night [night_num]: [action.name] on [action.target]"))
				night_num++
	
	// Post-game discussion period
	to_chat(world, span_boldnotice("\n=== POST-GAME DISCUSSION ==="))
	to_chat(world, span_notice("The game has ended. Feel free to discuss!"))
	to_chat(world, span_notice("The game area will be cleaned up in 3.5 minutes."))
	
	// Clean up after discussion period
	addtimer(CALLBACK(src, .proc/cleanup_game), VILLAIN_TIMER_RESULTS SECONDS)
	
	// Reset game state immediately
	current_phase = VILLAIN_PHASE_SETUP
	game_active = FALSE
	
	// Reset all game state
	GLOB.villains_signup.Cut()
	selected_characters.Cut()
	all_players.Cut()
	living_players.Cut()
	dead_players.Cut()
	current_votes.Cut()
	
	// Announce that a new game can be started
	to_chat(world, span_notice("\nA new game of Villains of the Night can now be started."))

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

	// Mark game as active
	game_active = TRUE

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
		
		// Don't change phase immediately - let process_night_actions handle it
		// This ensures all actions are processed before moving to investigation

// Helper procs
/datum/villains_controller/proc/spawn_morning_items()
	if(!villains_area)
		return

	// Categorize spawn locations for better distribution
	var/list/main_room_spawns = list()
	var/list/hallway_spawns = list()
	var/list/room_spawns = list()
	var/list/special_spawns = list()
	
	// Find all item spawn landmarks in the area
	for(var/obj/effect/landmark/villains/item_spawn/L in GLOB.landmarks_list)
		if(istype(get_area(L), villains_area))
			special_spawns += L

	// Get all valid turfs and categorize them
	var/list/all_turfs = get_area_turfs(villains_area)
	for(var/turf/T in all_turfs)
		if(T.density || locate(/obj/structure) in T)
			continue // Skip walls and structures
			
		var/area/A = get_area(T)
		if(istype(A, /area/villains/main_room))
			main_room_spawns += T
		else if(istype(A, /area/villains/hallway))
			hallway_spawns += T
		else if(istype(A, /area/villains/player_room))
			// Don't spawn items in player rooms during morning
			continue
		else
			room_spawns += T

	// Create distribution lists
	var/list/common_spawns = list()
	var/list/uncommon_spawns = list()
	var/list/rare_spawns = list()
	
	// Distribute spawn points by rarity
	// Commons go everywhere
	common_spawns += main_room_spawns
	common_spawns += hallway_spawns
	common_spawns += room_spawns
	
	// Uncommons in hallways and special rooms
	uncommon_spawns += hallway_spawns
	uncommon_spawns += room_spawns
	uncommon_spawns += special_spawns
	
	// Rares in special locations and far rooms
	rare_spawns += special_spawns
	rare_spawns += room_spawns
	
	// Spawn items based on rarity
	spawned_items = list()
	var/items_to_spawn = max(15, length(living_players) * 2) // Scale with player count
	
	// If it's a later morning phase (after first day), add more dangerous spawns
	var/day_number = round(length(dead_players) / 2) + 1
	if(day_number > 1)
		// On later days, put some items in more dangerous locations
		// This encourages risk-taking as the game progresses
		var/list/dangerous_spawns = list()
		
		// Find spawns far from main room
		if(main_room_center)
			for(var/turf/T in all_turfs)
				if(get_dist(T, main_room_center) > 15)
					dangerous_spawns += T
		
		// Add dangerous spawns for uncommon and rare items
		uncommon_spawns += dangerous_spawns
		rare_spawns += dangerous_spawns
		
		// Increase item count on later days
		items_to_spawn += (day_number - 1) * 3
	
	// Ensure minimum distance between spawns
	var/list/used_spawns = list()
	var/min_distance = 3 // Minimum 3 tiles between items
	
	// Determine item distribution
	var/common_count = round(items_to_spawn * 0.5) // 50% common
	var/uncommon_count = round(items_to_spawn * 0.35) // 35% uncommon
	var/rare_count = items_to_spawn - common_count - uncommon_count // 15% rare
	
	// Spawn items by rarity
	spawn_items_by_rarity(VILLAIN_ITEM_COMMON, common_count, common_spawns, used_spawns, min_distance)
	spawn_items_by_rarity(VILLAIN_ITEM_UNCOMMON, uncommon_count, uncommon_spawns, used_spawns, min_distance)
	spawn_items_by_rarity(VILLAIN_ITEM_RARE, rare_count, rare_spawns, used_spawns, min_distance)

	// Announce spawn details
	var/common_spawned = 0
	var/uncommon_spawned = 0
	var/rare_spawned = 0
	
	for(var/obj/item/villains/I in spawned_items)
		switch(I.rarity)
			if(VILLAIN_ITEM_COMMON)
				common_spawned++
			if(VILLAIN_ITEM_UNCOMMON)
				uncommon_spawned++
			if(VILLAIN_ITEM_RARE)
				rare_spawned++
	
	to_chat(living_players, span_notice("<b>[length(spawned_items)] mysterious items have appeared!</b>"))
	to_chat(living_players, span_notice("Common items: [common_spawned] | Uncommon items: [uncommon_spawned] | <b style='color:gold'>Rare items: [rare_spawned]</b>"))

/datum/villains_controller/proc/spawn_items_by_rarity(rarity, count, list/possible_spawns, list/used_spawns, min_distance)
	// Get all items of this rarity
	var/list/items_of_rarity = list()
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains
	
	for(var/item_type in item_types)
		var/obj/item/villains/I = item_type
		if(initial(I.rarity) == rarity)
			items_of_rarity += item_type
	
	if(!length(items_of_rarity) || !length(possible_spawns))
		return
	
	// Track spawned item types to limit duplicates
	var/list/spawned_types = list()
	var/max_duplicates = 2 // Maximum 2 of the same item type
	
	// Spawn the items
	for(var/i in 1 to count)
		// Find a valid spawn location
		var/turf/spawn_loc = find_valid_spawn(possible_spawns, used_spawns, min_distance)
		if(!spawn_loc)
			continue
			
		// Pick an item that hasn't reached duplicate limit
		var/list/available_items = list()
		for(var/item_type in items_of_rarity)
			if(spawned_types[item_type] < max_duplicates)
				available_items += item_type
		
		// If all items hit duplicate limit, reset
		if(!length(available_items))
			available_items = items_of_rarity
			
		var/item_type = pick(available_items)
		var/obj/item/villains/new_item = new item_type(spawn_loc)
		spawned_items += new_item
		used_spawns += spawn_loc
		spawned_types[item_type] = spawned_types[item_type] ? spawned_types[item_type] + 1 : 1
		
		// Add some visual feedback for rare items
		if(rarity == VILLAIN_ITEM_RARE)
			new_item.add_atom_colour("#FFD700", FIXED_COLOUR_PRIORITY) // Gold glow for rares
			new_item.light_range = 2
			new_item.light_power = 0.5
			new_item.light_color = "#FFD700"

/datum/villains_controller/proc/find_valid_spawn(list/possible_spawns, list/used_spawns, min_distance)
	var/list/valid_spawns = list()
	
	for(var/turf/T in possible_spawns)
		var/too_close = FALSE
		for(var/turf/used in used_spawns)
			if(get_dist(T, used) < min_distance)
				too_close = TRUE
				break
		
		if(!too_close)
			valid_spawns += T
	
	if(!length(valid_spawns))
		// If no valid spawns with distance, just use any available
		valid_spawns = possible_spawns - used_spawns
	
	if(!length(valid_spawns))
		return null
		
	return pick(valid_spawns)

/datum/villains_controller/proc/pick_weighted_item()
	// Build weighted list of all item types
	var/list/weighted_items = list()
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains

	for(var/item_type in item_types)
		var/obj/item/villains/I = item_type
		var/weight = initial(I.rarity)

		switch(weight)
			if(VILLAIN_ITEM_COMMON)
				weight = 3
			if(VILLAIN_ITEM_UNCOMMON)
				weight = 2
			if(VILLAIN_ITEM_RARE)
				weight = 1
			else
				weight = 2 // Default to uncommon if not set

		weighted_items[item_type] = weight

	// Pick a random item based on weights
	return pickweight(weighted_items)

// Debug proc to visualize item spawn distribution
/datum/villains_controller/proc/debug_show_spawn_distribution()
	if(!check_rights(R_ADMIN))
		return
		
	// Clear any existing markers
	for(var/obj/effect/decal/cleanable/blood/gibs/G in villains_area)
		if(G.name == "spawn marker")
			qdel(G)
	
	// Show common spawn points in green
	var/list/main_room_spawns = list()
	var/list/hallway_spawns = list()
	var/list/room_spawns = list()
	var/list/special_spawns = list()
	
	// Find all item spawn landmarks
	for(var/obj/effect/landmark/villains/item_spawn/L in GLOB.landmarks_list)
		if(istype(get_area(L), villains_area))
			special_spawns += get_turf(L)
	
	// Categorize turfs
	var/list/all_turfs = get_area_turfs(villains_area)
	for(var/turf/T in all_turfs)
		if(T.density || locate(/obj/structure) in T)
			continue
			
		var/area/A = get_area(T)
		if(istype(A, /area/villains/main_room))
			main_room_spawns += T
		else if(istype(A, /area/villains/hallway))
			hallway_spawns += T
		else if(!istype(A, /area/villains/player_room))
			room_spawns += T
	
	// Place colored markers
	for(var/turf/T in main_room_spawns)
		if(prob(10)) // Show 10% to avoid clutter
			var/obj/effect/decal/cleanable/blood/gibs/marker = new(T)
			marker.name = "spawn marker"
			marker.desc = "Common spawn area (main room)"
			marker.color = "#00FF00" // Green
	
	for(var/turf/T in hallway_spawns)
		if(prob(20))
			var/obj/effect/decal/cleanable/blood/gibs/marker = new(T)
			marker.name = "spawn marker"
			marker.desc = "Uncommon spawn area (hallway)"
			marker.color = "#FFFF00" // Yellow
	
	for(var/turf/T in special_spawns)
		var/obj/effect/decal/cleanable/blood/gibs/marker = new(T)
		marker.name = "spawn marker"
		marker.desc = "Rare spawn area (special)"
		marker.color = "#FFD700" // Gold
		marker.alpha = 200
	
	to_chat(usr, span_notice("Spawn distribution markers placed. Green=Common, Yellow=Uncommon, Gold=Rare"))


/datum/villains_controller/proc/remove_unpicked_items()
	var/removed_count = 0
	for(var/obj/item/villains/I in spawned_items)
		// Check if the item is still on the ground (not picked up by a player)
		if(!ismob(I.loc))
			qdel(I)
			removed_count++

	// Clean up the spawned items list
	spawned_items.Cut()

	if(removed_count > 0)
		to_chat(living_players, span_notice("[removed_count] unpicked items have been removed."))

/datum/villains_controller/proc/remove_item_freshness()
	// Only process items that are in player inventories
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		for(var/obj/item/villains/I in player.contents)
			I.freshness = VILLAIN_ITEM_USED
			I.update_outline()

/datum/villains_controller/proc/process_night_actions()
	if(!action_queue)
		return

	to_chat(living_players, span_notice("Processing night actions..."))

	// Clear last night's actions
	last_night_actions.Cut()
	action_targets.Cut()

	// Pre-process Warden's Soul Gather to cancel item actions
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player.soul_gather_target)
			var/mob/living/simple_animal/hostile/villains_character/soul_target = player.soul_gather_target

			// Cancel and block item-based actions
			if(soul_target.main_action && soul_target.main_action["type"] == "use_item")
				to_chat(soul_target, span_warning("Your soul is being gathered... your item action fails!"))
				soul_target.main_action = null

			if(soul_target.secondary_action && soul_target.secondary_action["type"] == "use_item")
				to_chat(soul_target, span_warning("Your soul is being gathered... your secondary item action fails!"))
				soul_target.secondary_action = null

	// Collect all submitted actions
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player.main_action)
			var/action_type = player.main_action["type"]
			var/target_ref = player.main_action["target"]
			var/action_data = player.main_action["data"]

			var/mob/living/simple_animal/hostile/villains_character/target = locate(target_ref)
			if(!target)
				continue

			var/datum/villains_action/new_action

			switch(action_type)
				if("talk_trade")
					new_action = new /datum/villains_action/talk_trade(player, target, src)
				if("eliminate")
					new_action = new /datum/villains_action/eliminate(player, target, src)
				if("use_item")
					var/obj/item/villains/item = locate(action_data)
					if(item)
						new_action = new /datum/villains_action/use_item(player, target, src, item)
				if("character_ability")
					var/datum/villains_character/char = player.character_data
					if(char)
						new_action = new /datum/villains_action/character_ability(player, target, src, char)

			if(new_action)
				// Check if player used fairy wine with matching targets
				if(player.used_fairy_wine && player.secondary_action)
					var/sec_target_ref = player.secondary_action["target"]
					if(sec_target_ref == target_ref && action_type != "talk_trade")
						// Create a Talk/Trade session after the main action
						var/datum/villains_action/fairy_trade = new /datum/villains_action/talk_trade(player, target, src)
						fairy_trade.priority = VILLAIN_ACTION_PRIORITY_LOW // Process after main action
						action_queue.add_action(fairy_trade)
						to_chat(player, span_notice("The Fairy Wine's magic activates, creating a Talk/Trade session with your target!"))

				action_queue.add_action(new_action)
				// Track this action
				last_night_actions += new_action
				// Track who targeted whom
				if(target)
					if(!action_targets[REF(target)])
						action_targets[REF(target)] = list()
					action_targets[REF(target)] += list(list(
						"performer" = player,
						"action" = new_action
					))

		// Also process secondary action if present
		if(player.secondary_action && !player.secondary_action_blocked)
			var/sec_action_type = player.secondary_action["type"]
			var/sec_target_ref = player.secondary_action["target"]
			var/sec_action_data = player.secondary_action["data"]

			var/mob/living/simple_animal/hostile/villains_character/sec_target = locate(sec_target_ref)
			if(sec_target)
				var/datum/villains_action/secondary_action

				switch(sec_action_type)
					if("use_item")
						var/obj/item/villains/item = locate(sec_action_data)
						if(item && item.action_cost == VILLAIN_ACTION_SECONDARY)
							secondary_action = new /datum/villains_action/use_item(player, sec_target, src, item)
					if("character_ability")
						var/datum/villains_character/char = player.character_data
						if(char && char.active_ability_cost == VILLAIN_ACTION_SECONDARY)
							secondary_action = new /datum/villains_action/character_ability(player, sec_target, src, char)
					if("inheritance_trade")
						// Puss in Boots special Talk/Trade
						if(player.character_data?.character_id == VILLAIN_CHAR_PUSSINBOOTS && sec_target == player.current_blessing)
							secondary_action = new /datum/villains_action/talk_trade(player, sec_target, src)

				if(secondary_action)
					// Secondary actions have lower priority than main actions
					secondary_action.priority = VILLAIN_ACTION_PRIORITY_LOW
					action_queue.add_action(secondary_action)
					// Track this action
					last_night_actions += secondary_action
					// Track who targeted whom
					if(sec_target)
						if(!action_targets[REF(sec_target)])
							action_targets[REF(sec_target)] = list()
						action_targets[REF(sec_target)] += list(list(
							"performer" = player,
							"action" = secondary_action
						))
		else if(player.secondary_action && player.secondary_action_blocked)
			to_chat(player, span_warning("Your secondary action failed to execute."))

		// Clear action storage
		player.main_action = null
		player.secondary_action = null
		player.used_fairy_wine = FALSE

	// Process all actions in priority order
	spawn(0)
		action_queue.process_actions()

		// After all actions are processed
		sleep(5 SECONDS)

		// Process investigative results
		process_investigative_results()

		// Check if someone was eliminated
		if(last_eliminated)
			change_phase(VILLAIN_PHASE_INVESTIGATION)
		else
			change_phase(VILLAIN_PHASE_MORNING)

/datum/villains_controller/proc/process_investigative_results()
	// Process drain monitor and rangefinder results
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		// Drain Monitor - show who targeted someone
		if(player.drain_monitor_target)
			var/mob/living/simple_animal/hostile/villains_character/monitored = player.drain_monitor_target
			var/list/targeters = list()

			if(action_targets[REF(monitored)])
				for(var/list/action_data in action_targets[REF(monitored)])
					var/mob/living/simple_animal/hostile/villains_character/performer = action_data["performer"]
					if(performer && !(performer.name in targeters))
						targeters += performer.name

			if(length(targeters))
				to_chat(player, span_notice("Drain Monitor Results: The following players targeted [monitored]: [targeters.Join(", ")]."))
			else
				to_chat(player, span_notice("Drain Monitor Results: Nobody targeted [monitored]."))

			player.drain_monitor_target = null

		// Rangefinder - show what actions targeted someone
		if(player.rangefinder_target)
			var/mob/living/simple_animal/hostile/villains_character/targeted = player.rangefinder_target
			var/list/action_list = list()

			if(action_targets[REF(targeted)])
				for(var/list/action_data in action_targets[REF(targeted)])
					var/mob/living/simple_animal/hostile/villains_character/performer = action_data["performer"]
					var/datum/villains_action/action = action_data["action"]
					if(performer && action)
						// Check if performer used fairy wine
						if(performer.used_fairy_wine)
							action_list += "[performer.name] used Talk/Trade"
						else
							action_list += "[performer.name] used [action.name]"

			if(length(action_list))
				to_chat(player, span_notice("Rangefinder Results: The following actions targeted [targeted]: [action_list.Join(", ")]."))
			else
				to_chat(player, span_notice("Rangefinder Results: No actions targeted [targeted]."))

			player.rangefinder_target = null

		// Funeral Butterflies Guidance - show who visited someone (same as Drain Monitor)
		if(player.guidance_target)
			var/mob/living/simple_animal/hostile/villains_character/guided = player.guidance_target
			var/list/visitors = list()

			if(action_targets[REF(guided)])
				for(var/list/action_data in action_targets[REF(guided)])
					var/mob/living/simple_animal/hostile/villains_character/performer = action_data["performer"]
					if(performer && !(performer.name in visitors))
						visitors += performer.name

			if(length(visitors))
				to_chat(player, span_notice("Guidance Results: The following players visited [guided]: [visitors.Join(", ")]."))
			else
				to_chat(player, span_notice("Guidance Results: Nobody visited [guided]."))

			player.guidance_target = null

		// Hunter's Mark - notify if target used Suppressive/Elimination
		if(player.marked_for_hunting)
			var/mob/living/simple_animal/hostile/villains_character/hunted = player.marked_for_hunting
			var/used_aggressive = FALSE

			for(var/datum/villains_action/action in last_night_actions)
				if(action.performer == hunted)
					var/action_category = VILLAIN_ACTION_TYPELESS

					if(action.action_type == "character_ability" && hunted.character_data)
						action_category = hunted.character_data.active_ability_type
					else if(action.action_type == "use_item")
						var/datum/villains_action/use_item/UI = action
						if(UI.used_item)
							action_category = UI.used_item.action_type
					else if(action.action_type == "eliminate")
						action_category = VILLAIN_ACTION_ELIMINATION

					if(action_category == VILLAIN_ACTION_SUPPRESSIVE || action_category == VILLAIN_ACTION_ELIMINATION)
						used_aggressive = TRUE
						break

			if(used_aggressive)
				to_chat(player, span_boldwarning("Hunter's Mark Alert: [hunted] used an aggressive action (Suppressive or Elimination)!"))
			else
				to_chat(player, span_notice("Hunter's Mark: [hunted] did not use any aggressive actions."))

			player.marked_for_hunting = null

		// Warden's Soul Gather - cancel item actions and steal items
		if(player.soul_gather_target)
			var/mob/living/simple_animal/hostile/villains_character/soul_target = player.soul_gather_target
			var/list/stolen_items = list()

			// Check if target used any items
			if(soul_target.main_action && soul_target.main_action["type"] == "use_item")
				soul_target.main_action = null
				to_chat(soul_target, span_warning("Your action was disrupted by dark forces!"))

			if(soul_target.secondary_action && soul_target.secondary_action["type"] == "use_item")
				soul_target.secondary_action = null
				to_chat(soul_target, span_warning("Your secondary action was disrupted by dark forces!"))

			// Steal all items they used
			for(var/datum/villains_action/action in last_night_actions)
				if(action.performer == soul_target && action.action_type == "use_item")
					var/datum/villains_action/use_item/UI = action
					if(UI.used_item && UI.used_item.loc == soul_target)
						UI.used_item.forceMove(player)
						stolen_items += UI.used_item.name
						if(UI.used_item.freshness == VILLAIN_ITEM_FRESH && (UI.used_item in soul_target.fresh_items))
							soul_target.fresh_items -= UI.used_item

			if(length(stolen_items))
				to_chat(player, span_boldnotice("Soul Gather successful! You stole: [stolen_items.Join(", ")]"))
				to_chat(soul_target, span_userdanger("Your items have been stolen by [player]!"))
			else
				to_chat(player, span_notice("Soul Gather: [soul_target] did not use any items."))

			player.soul_gather_target = null

		// Blue Shepherd's False Prophet
		if(player.false_prophet_used)
			var/revealed_action = null

			// 20% chance to show random player's action instead of villain's
			if(prob(20))
				// Show a random player's action
				var/list/other_players = living_players - player - current_villain
				if(length(other_players))
					var/mob/living/simple_animal/hostile/villains_character/random_player = pick(other_players)
					if(random_player.main_action)
						revealed_action = "[random_player]'s action: [get_action_description(random_player.main_action, random_player)]"
			else
				// Show villain's action
				if(current_villain && current_villain.main_action)
					revealed_action = "[current_villain]'s action: [get_action_description(current_villain.main_action, current_villain)]"

			if(revealed_action)
				to_chat(player, span_boldnotice("False Prophet Vision: [revealed_action]"))
			else
				to_chat(player, span_notice("False Prophet Vision: The villain took no action."))

			player.false_prophet_used = FALSE

		// Butterfly Guide - show who visited target (Sunset Traveller)
		if(player.butterfly_guide_target)
			var/mob/living/simple_animal/hostile/villains_character/butterfly_target = player.butterfly_guide_target
			var/list/visitors = list()

			if(action_targets[REF(butterfly_target)])
				for(var/list/action_data in action_targets[REF(butterfly_target)])
					var/mob/living/simple_animal/hostile/villains_character/performer = action_data["performer"]
					if(performer && !(performer.name in visitors))
						visitors += performer.name

			if(length(visitors))
				to_chat(player, span_notice("Butterfly Guide Results: The following players visited [butterfly_target]: [visitors.Join(", ")]."))
			else
				to_chat(player, span_notice("Butterfly Guide Results: Nobody visited [butterfly_target]."))

			player.butterfly_guide_target = null

		// Forsaken Murderer's Paranoid - count who targeted them
		if(player.character_data?.character_id == VILLAIN_CHAR_FORSAKENMURDER)
			var/targeters_count = 0

			if(action_targets[REF(player)])
				for(var/list/action_data in action_targets[REF(player)])
					targeters_count++

			if(targeters_count > 0)
				to_chat(player, span_boldnotice("Paranoid: [targeters_count] player\s targeted you last night!"))
			else
				to_chat(player, span_notice("Paranoid: Nobody targeted you last night."))

/datum/villains_controller/proc/get_action_description(list/action_data, mob/living/simple_animal/hostile/villains_character/performer)
	if(!action_data)
		return "no action"

	var/action_type = action_data["type"]
	var/target_ref = action_data["target"]
	var/mob/living/simple_animal/hostile/villains_character/target = locate(target_ref)

	switch(action_type)
		if("talk_trade")
			return "Talk/Trade with [target ? target.name : "unknown"]"
		if("eliminate")
			return "Eliminate [target ? target.name : "unknown"]"
		if("character_ability")
			if(performer?.character_data)
				return "[performer.character_data.active_ability_name] on [target ? target.name : "unknown"]"
			return "Character ability on [target ? target.name : "unknown"]"
		if("use_item")
			var/item_ref = action_data["data"]
			var/obj/item/villains/I = locate(item_ref)
			if(I)
				return "Use [I.name] on [target ? target.name : "unknown"]"
			return "Use item on [target ? target.name : "unknown"]"
		if("inheritance_trade")
			return "Inheritance (Talk/Trade) with [target ? target.name : "unknown"]"
		else
			return "[action_type] on [target ? target.name : "unknown"]"

/datum/villains_controller/proc/scatter_evidence_items()
	if(!villains_area)
		return

	// Get only hallway turfs that are open and accessible
	var/list/hallway_turfs = list()
	var/list/used_turfs = list() // Track used turfs to prevent overlap
	
	for(var/turf/T in get_area_turfs(villains_area))
		// Skip dense turfs (walls)
		if(T.density)
			continue
		
		// Skip turfs with blocking structures
		var/has_blocking = FALSE
		for(var/obj/O in T.contents)
			if(O.density && !(istype(O, /obj/machinery/door))) // Allow doors
				has_blocking = TRUE
				break
		if(has_blocking)
			continue
			
		var/area/A = get_area(T)
		if(istype(A, /area/villains/hallway))
			hallway_turfs += T

	var/list/all_evidence_items = list()
	var/list/evidence_info = list()
	
	// Collect all used items
	for(var/obj/item/villains/I in used_items)
		all_evidence_items += I
		evidence_info += "[I.name] (used during night)"
		
	// Collect items from eliminated player
	if(last_eliminated)
		for(var/mob/living/simple_animal/hostile/villains_character/victim in dead_players)
			if(victim.name == last_eliminated)
				// Get all items from the victim
				for(var/obj/item/villains/I in victim.contents)
					I.forceMove(victim.loc) // Drop at death location first
					all_evidence_items += I
					evidence_info += "[I.name] (held by [victim.name])"
				break
				
	// Track all items that were dropped or moved during the night
	for(var/obj/item/villains/I in world)
		if(!istype(get_area(I), villains_area))
			continue
		if(I in all_evidence_items)
			continue
		if(I.freshness == VILLAIN_ITEM_USED || !ismob(I.loc))
			all_evidence_items += I
			evidence_info += "[I.name] (found at scene)"

	// Scatter evidence items only in hallways, ensuring no overlap
	for(var/obj/item/villains/I in all_evidence_items)
		if(!length(hallway_turfs))
			// If we run out of hallway space, send directly to main room
			if(main_room_center)
				I.forceMove(main_room_center)
			else
				break
		else
			// Find a turf that hasn't been used yet
			var/turf/spawn_turf = pick(hallway_turfs)
			hallway_turfs -= spawn_turf
			used_turfs += spawn_turf
			
			I.forceMove(spawn_turf)
		
		// Mark as evidence
		I.freshness = VILLAIN_ITEM_USED
		I.update_outline()
		// Make items non-pickupable evidence
		I.is_evidence = TRUE
		
	// Store evidence list for display
	evidence_list = evidence_info
	
	to_chat(living_players, span_notice("Evidence has been scattered throughout the hallways. [length(all_evidence_items)] items found."))

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

/datum/villains_controller/proc/get_random_open_turf_in_main_room()
	var/list/open_turfs = list()
	
	// Get all turfs in the main room area
	for(var/turf/T in world)
		var/area/A = get_area(T)
		if(!istype(A, /area/villains/main_room))
			continue
			
		// Skip dense turfs (walls)
		if(T.density)
			continue
			
		// Skip turfs with blocking structures
		var/has_blocking = FALSE
		for(var/obj/O in T.contents)
			if(O.density && !istype(O, /obj/machinery/door))
				has_blocking = TRUE
				break
		
		if(!has_blocking)
			open_turfs += T
	
	if(length(open_turfs))
		return pick(open_turfs)
	
	// Fallback to main room center if no open turfs found
	return main_room_center

/datum/villains_controller/proc/tally_votes()
	// Count votes for each player
	var/list/vote_counts = list()
	var/highest_votes = 0
	var/list/tied_players = list()
	
	// Tally up the votes
	for(var/mob/living/simple_animal/hostile/villains_character/voted_for in current_votes)
		if(!(voted_for in vote_counts))
			vote_counts[voted_for] = 0
		vote_counts[voted_for]++
		
		if(vote_counts[voted_for] > highest_votes)
			highest_votes = vote_counts[voted_for]
			tied_players = list(voted_for)
		else if(vote_counts[voted_for] == highest_votes)
			tied_players += voted_for
	
	// Announce vote results
	to_chat(world, span_boldnotice("\n=== VOTING RESULTS ==="))
	
	// Show each player's vote count
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		var/votes = vote_counts[player] || 0
		if(votes > 0)
			to_chat(world, span_notice("[player.name]: [votes] vote[votes == 1 ? "" : "s"]"))
	
	// Handle the results
	if(highest_votes == 0)
		to_chat(world, span_notice("No votes were cast. No one will be eliminated."))
		return null
	
	if(tied_players.len > 1)
		// Handle ties - for now, no elimination on ties
		to_chat(world, span_warning("There is a tie! No one will be eliminated."))
		var/tie_text = "Tied players: "
		for(var/mob/living/simple_animal/hostile/villains_character/tied in tied_players)
			tie_text += "[tied.name] "
		to_chat(world, span_notice(tie_text))
		return null
	
	// Single player with most votes
	var/mob/living/simple_animal/hostile/villains_character/eliminated = tied_players[1]
	to_chat(world, span_userdanger("\n[eliminated.name] has received the most votes and will be eliminated!"))
	return eliminated

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
	
	// Investigation phase data
	if(current_phase == VILLAIN_PHASE_INVESTIGATION || current_phase == VILLAIN_PHASE_ALIBI)
		data["evidence_list"] = evidence_list
	
	// Alibi phase data
	if(current_phase == VILLAIN_PHASE_ALIBI)
		if(current_speaker)
			data["current_speaker"] = list(
				"name" = current_speaker.name,
				"ref" = REF(current_speaker)
			)
		
		// Build the speaking queue
		var/list/speaking_queue = list()
		for(var/i in alibi_index + 1 to length(alibi_queue))
			var/mob/living/simple_animal/hostile/villains_character/queued = alibi_queue[i]
			if(queued in living_players)
				speaking_queue += list(list(
					"name" = queued.name,
					"position" = i - alibi_index
				))
		data["alibi_queue"] = speaking_queue
		
		// Time remaining for current speaker
		if(alibi_timer)
			var/time_left = timeleft(alibi_timer)
			if(time_left > 0)
				data["alibi_time_remaining"] = round(time_left / 10) // Convert to seconds

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

		if("admin_end_phase")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] has used admin powers to end the current phase"))
				return

			// Cancel current timer
			if(phase_timer)
				deltimer(phase_timer)
				phase_timer = null

			// Progress to the next phase naturally
			handle_phase_timer()
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

		if("admin_reveal_actions")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] revealed last night's actions in Villains game"))
				return

			reveal_last_night_actions(user)
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

		if("debug_give_items_to_fakes")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] gave items to all fake players in Villains game"))
				return
			give_items_to_fake_players()
			return TRUE

		if("debug_control_fake_action")
			if(!log_action(user, admin_action = TRUE, message_override = "[user] is controlling a fake player's action in Villains game"))
				return
			control_fake_player_action(user)
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

	// Generate fake ckey (no underscores as BYOND removes them)
	var/fake_ckey = "fakeplayer[rand(1000,9999)]"
	while((fake_ckey in fake_players) || (fake_ckey in GLOB.villains_signup))
		fake_ckey = "fakeplayer[rand(1000,9999)]"

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

		// Update fake_players list with actual ckey (in case BYOND modified it)
		if(new_mob.ckey != fake_ckey)
			fake_players -= fake_ckey
			fake_players += new_mob.ckey
			// Also update in signups
			GLOB.villains_signup -= fake_ckey
			GLOB.villains_signup += new_mob.ckey
			selected_characters[character_id] = new_mob.ckey

		to_chat(world, span_adminnotice("DEBUG: Created fake player [new_mob.name] with ckey [new_mob.ckey]"))

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

	// Get all item types except fairy wine
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains - /obj/item/villains/fairy_wine
	var/spawned = 0

	// Spawn one of each item for testing
	for(var/item_type in item_types)
		if(!length(spawn_points))
			break
		var/spawn_loc = pick_n_take(spawn_points)
		var/obj/item/villains/I = new item_type(get_turf(spawn_loc))
		spawned_items += I
		spawned++

		// Show rarity in debug message
		var/rarity_text = "UNKNOWN"
		switch(I.rarity)
			if(VILLAIN_ITEM_COMMON)
				rarity_text = "COMMON"
			if(VILLAIN_ITEM_UNCOMMON)
				rarity_text = "UNCOMMON"
			if(VILLAIN_ITEM_RARE)
				rarity_text = "RARE"

		to_chat(world, span_notice("DEBUG: Spawned [I.name] ([rarity_text])"))

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
	var/actions_submitted = 0

	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(!(player.ckey in fake_players))
			continue

		// Pick random valid action
		var/list/possible_actions = list("talk_trade")
		var/action_type
		var/action_data

		if(player.character_data?.active_ability_name)
			possible_actions += "character_ability"
		if(player.is_villain)
			possible_actions += "eliminate"

		// Add item actions
		for(var/obj/item/villains/I in player.contents)
			if(I.action_cost == VILLAIN_ACTION_MAIN)
				possible_actions += "use_[I.name]"

		var/action_choice = pick(possible_actions)
		var/mob/living/simple_animal/hostile/villains_character/target = pick(living_players - player)

		// Convert action choice to action type
		if(action_choice == "talk_trade")
			action_type = "talk_trade"
		else if(action_choice == "character_ability")
			action_type = "character_ability"
		else if(action_choice == "eliminate")
			action_type = "eliminate"
		else if(findtext(action_choice, "use_"))
			action_type = "use_item"
			// Find the item
			var/item_name = copytext(action_choice, 5) // Remove "use_"
			for(var/obj/item/villains/I in player.contents)
				if(I.name == item_name)
					action_data = REF(I)
					break

		// Set the action on the player mob (same format as UI)
		player.main_action = list(
			"type" = action_type,
			"target" = REF(target),
			"data" = action_data
		)

		// Check for secondary action items
		var/list/secondary_items = list()
		for(var/obj/item/villains/I in player.contents)
			if(I.action_cost == VILLAIN_ACTION_SECONDARY)
				secondary_items += I

		// 50% chance to use a secondary action if available
		if(length(secondary_items) && prob(50))
			var/obj/item/villains/sec_item = pick(secondary_items)
			var/mob/living/simple_animal/hostile/villains_character/sec_target = pick(living_players - player)

			player.secondary_action = list(
				"type" = "use_item",
				"target" = REF(sec_target),
				"data" = REF(sec_item)
			)

			to_chat(world, span_adminnotice("DEBUG: [player.name] will also use [sec_item.name] on [sec_target.name] (secondary)"))

		actions_submitted++
		to_chat(world, span_adminnotice("DEBUG: [player.name] will [action_choice] targeting [target.name]"))

	to_chat(world, span_notice("DEBUG: [actions_submitted] fake players have submitted random actions."))

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

/datum/villains_controller/proc/give_items_to_fake_players()
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains - /obj/item/villains/fairy_wine
	var/items_given = 0

	to_chat(world, span_adminnotice("DEBUG: Starting give_items_to_fake_players"))
	to_chat(world, span_adminnotice("DEBUG: fake_players list: [fake_players.Join(", ")]"))
	to_chat(world, span_adminnotice("DEBUG: living_players count: [length(living_players)]"))

	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		to_chat(world, span_adminnotice("DEBUG: Checking player [player.name] (ckey: [player.ckey])"))

		if(!(player.ckey in fake_players))
			to_chat(world, span_adminnotice("DEBUG: [player.name] is not a fake player, skipping"))
			continue

		to_chat(world, span_adminnotice("DEBUG: [player.name] is a fake player, giving items"))

		// Give 2-3 random items to each fake player
		var/items_to_give = rand(2, 3)
		for(var/i in 1 to items_to_give)
			// Check if they're at the item limit
			var/total_items = 0
			for(var/obj/item/villains/I in player.contents)
				total_items++

			if(total_items >= 3)
				to_chat(world, span_adminnotice("DEBUG: [player.name] already has [total_items] items, at limit"))
				break

			// Give a random item
			var/item_type = pick(item_types)
			var/obj/item/villains/new_item = new item_type(player)
			new_item.freshness = VILLAIN_ITEM_USED // Give them as used items
			items_given++
			to_chat(world, span_adminnotice("DEBUG: Gave [new_item] to [player]"))

	to_chat(world, span_adminnotice("DEBUG: Distributed [items_given] items to fake players."))

/datum/villains_controller/proc/control_fake_player_action(mob/admin)
	if(current_phase != VILLAIN_PHASE_EVENING)
		to_chat(admin, span_warning("Can only control fake player actions during evening phase!"))
		return

	// Get list of fake players
	var/list/fake_player_list = list()
	for(var/mob/living/simple_animal/hostile/villains_character/player in living_players)
		if(player.ckey in fake_players)
			fake_player_list += player

	if(!length(fake_player_list))
		to_chat(admin, span_warning("No fake players available!"))
		return

	// Pick a random fake player
	var/mob/living/simple_animal/hostile/villains_character/fake_player = pick(fake_player_list)

	// Get available actions
	var/list/action_choices = list("Talk/Trade", "Character Ability")
	if(fake_player.is_villain)
		action_choices += "Eliminate"

	// Add items
	for(var/obj/item/villains/I in fake_player.contents)
		action_choices += "Use [I.name]"

	var/chosen_action = input(admin, "Select action for [fake_player.name]", "Control Fake Player") as null|anything in action_choices
	if(!chosen_action)
		return

	// Get possible targets
	var/list/target_choices = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in living_players)
		target_choices += P

	var/mob/living/simple_animal/hostile/villains_character/chosen_target = input(admin, "Select target for action", "Control Fake Player") as null|anything in target_choices
	if(!chosen_target)
		return

	// Submit the action
	var/action_type
	var/action_data

	if(chosen_action == "Talk/Trade")
		action_type = "talk_trade"
	else if(chosen_action == "Character Ability")
		action_type = "character_ability"
	else if(chosen_action == "Eliminate")
		action_type = "eliminate"
	else if(findtext(chosen_action, "Use "))
		action_type = "use_item"
		// Find the item
		var/item_name = copytext(chosen_action, 5) // Remove "Use "
		for(var/obj/item/villains/I in fake_player.contents)
			if(I.name == item_name)
				action_data = REF(I)
				break

	// Store the action
	fake_player.main_action = list(
		"type" = action_type,
		"target" = REF(chosen_target),
		"data" = action_data
	)

	to_chat(admin, span_adminnotice("Set [fake_player.name] to perform [chosen_action] on [chosen_target.name]"))

	// Ask about secondary action
	var/list/secondary_choices = list("No Secondary Action")

	// Check for secondary action items
	for(var/obj/item/villains/I in fake_player.contents)
		if(I.action_cost == VILLAIN_ACTION_SECONDARY)
			secondary_choices += "Use [I.name]"

	// Check for secondary ability
	if(fake_player.character_data?.active_ability_cost == VILLAIN_ACTION_SECONDARY)
		secondary_choices += "Character Ability"

	if(length(secondary_choices) > 1)
		var/chosen_secondary = input(admin, "Select secondary action for [fake_player.name] (optional)", "Control Secondary Action") as null|anything in secondary_choices

		if(chosen_secondary && chosen_secondary != "No Secondary Action")
			var/sec_action_type
			var/sec_action_data

			if(chosen_secondary == "Character Ability")
				sec_action_type = "character_ability"
			else if(findtext(chosen_secondary, "Use "))
				sec_action_type = "use_item"
				// Find the item
				var/item_name = copytext(chosen_secondary, 5) // Remove "Use "
				for(var/obj/item/villains/I in fake_player.contents)
					if(I.name == item_name && I.action_cost == VILLAIN_ACTION_SECONDARY)
						sec_action_data = REF(I)
						break

			if(sec_action_type)
				// Get target for secondary action
				var/mob/living/simple_animal/hostile/villains_character/sec_target = input(admin, "Select target for secondary action", "Control Secondary Target") as null|anything in target_choices

				if(sec_target)
					fake_player.secondary_action = list(
						"type" = sec_action_type,
						"target" = REF(sec_target),
						"data" = sec_action_data
					)

					to_chat(admin, span_adminnotice("Also set [fake_player.name] to perform [chosen_secondary] on [sec_target.name] (secondary)"))

	to_chat(world, span_adminnotice("DEBUG: Admin [admin] controlled [fake_player.name] to [chosen_action] targeting [chosen_target.name]"))

/datum/villains_controller/proc/reveal_last_night_actions(mob/admin)
	if(!length(last_night_actions))
		to_chat(admin, span_notice("No actions were performed during the last nighttime phase."))
		return

	var/list/action_summary = list()
	action_summary += span_adminnotice("=== LAST NIGHT'S ACTIONS ===")
	action_summary += span_notice("Actions are listed in the order they were processed:")
	action_summary += ""

	// Sort actions by priority for display
	var/list/sorted_actions = list()
	for(var/priority in 1 to 5)
		for(var/datum/villains_action/A in last_night_actions)
			if(A.get_priority() == priority)
				sorted_actions += A

	var/action_num = 1
	for(var/datum/villains_action/A in sorted_actions)
		var/priority_name = ""
		switch(A.get_priority())
			if(VILLAIN_ACTION_SUPPRESSIVE)
				priority_name = "SUPPRESSIVE"
			if(VILLAIN_ACTION_PROTECTIVE)
				priority_name = "PROTECTIVE"
			if(VILLAIN_ACTION_INVESTIGATIVE)
				priority_name = "INVESTIGATIVE"
			if(VILLAIN_ACTION_TYPELESS)
				priority_name = "TYPELESS"
			if(VILLAIN_ACTION_ELIMINATION)
				priority_name = "ELIMINATION"

		var/success_text = A.completed ? "SUCCESS" : "FAILED"
		var/prevented_text = A.prevented ? " (PREVENTED)" : ""

		action_summary += "[action_num]. [span_bold(A.name)] ([priority_name])"
		action_summary += "   Performer: [A.performer ? A.performer.name : "Unknown"]"
		action_summary += "   Target: [A.target ? A.target.name : "Self"]"
		action_summary += "   Result: [success_text][prevented_text]"

		// Add special details for specific action types
		if(istype(A, /datum/villains_action/use_item))
			var/datum/villains_action/use_item/UI = A
			if(UI.used_item)
				action_summary += "   Item Used: [UI.used_item.name]"

		if(istype(A, /datum/villains_action/eliminate))
			if(A.completed && !A.prevented)
				action_summary += span_userdanger("   >>> ELIMINATION SUCCESSFUL <<<")

		action_summary += ""
		action_num++

	// Show any eliminations
	if(last_eliminated)
		action_summary += span_userdanger("ELIMINATED: [last_eliminated]")
	else
		action_summary += span_boldnicegreen("No one was eliminated.")

	// Output the summary
	var/summary_text = action_summary.Join("\n")
	to_chat(admin, summary_text)

	// Also create a popup window for easier reading
	var/datum/browser/popup = new(admin, "villains_actions", "Last Night's Actions", 600, 500)
	popup.set_content("<pre>[summary_text]</pre>")
	popup.open()

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

	// Get all item types except fairy wine
	var/list/item_types = typesof(/obj/item/villains) - /obj/item/villains - /obj/item/villains/fairy_wine
	var/list/spawned = list()

	// Spawn items at random landmarks
	for(var/i in 1 to min(item_count, length(spawn_points)))
		var/spawn_loc = pick_n_take(spawn_points)
		var/item_type = pick(item_types)
		var/obj/item/villains/I = new item_type(get_turf(spawn_loc))
		spawned += I

	return spawned

/datum/villains_controller/proc/cleanup_game()
	/**
	 * Cleans up all game-related objects and resets the game area
	 * Called after the post-game discussion period
	 */
	to_chat(world, span_boldnotice("Cleaning up the Villains game area..."))
	
	// Clean up all player mobs
	for(var/mob/living/simple_animal/hostile/villains_character/M in all_players)
		if(M.client)
			// Return player to ghost form
			var/mob/dead/observer/ghost = M.ghostize(TRUE)
			if(ghost)
				ghost.forceMove(pick(GLOB.observer_start_landmarks))
		qdel(M)
	
	// Clean up spawned items
	for(var/obj/item/villains/I in spawned_items)
		qdel(I)
	
	// Clean up any items that might have been moved around
	if(villains_area)
		for(var/obj/item/villains/I in villains_area)
			qdel(I)
	
	// Clean up room doors
	for(var/room_id in room_doors)
		var/obj/machinery/door/D = room_doors[room_id]
		if(D && !QDELETED(D))
			qdel(D)
	
	// Clean up any remaining evidence markers or other game objects
	if(villains_area)
		for(var/obj/O in villains_area)
			if(istype(O, /obj/effect/decal/cleanable) || istype(O, /obj/effect/overlay))
				qdel(O)
	
	// Clear all lists
	all_players.Cut()
	living_players.Cut()
	dead_players.Cut()
	spectators.Cut()
	spawned_items.Cut()
	used_items.Cut()
	evidence_list.Cut()
	player_rooms.Cut()
	room_doors.Cut()
	player_room_assignments.Cut()
	room_landmarks.Cut()
	trade_history.Cut()
	contract_history.Cut()
	
	// Clear game area reference
	villains_area = null
	main_room_center = null
	
	// Final cleanup announcement
	to_chat(world, span_notice("Villains game area has been cleaned up."))
	log_game("VILLAINS: Game cleanup completed")
	
	// Delete the controller itself
	GLOB.villains_game = null
	qdel(src)

// Trade and contract tracking
/datum/villains_controller/proc/record_trade(mob/living/simple_animal/hostile/villains_character/trader1, mob/living/simple_animal/hostile/villains_character/trader2, list/items1, list/items2)
	var/datum/villains_trade_record/record = new()
	record.phase = current_phase
	record.trader1 = trader1.name
	record.trader2 = trader2.name
	record.timestamp = world.time
	
	// Record items traded
	for(var/item_ref in items1)
		var/obj/item/villains/I = locate(item_ref)
		if(I)
			record.items_from_trader1 += I.name
	
	for(var/item_ref in items2)
		var/obj/item/villains/I = locate(item_ref)
		if(I)
			record.items_from_trader2 += I.name
	
	trade_history += record
	
	// Log for admins
	log_game("VILLAINS: Trade between [trader1] and [trader2]. [trader1] gave: [record.items_from_trader1.Join(", ")]. [trader2] gave: [record.items_from_trader2.Join(", ")]")

/datum/villains_controller/proc/record_contract(mob/living/simple_animal/hostile/villains_character/offerer, mob/living/simple_animal/hostile/villains_character/target, contract_type, status)
	var/datum/villains_contract_record/record = new()
	record.phase = current_phase
	record.offerer = offerer.name
	record.target = target.name
	record.contract_type = contract_type
	record.status = status // "accepted", "declined", "completed"
	record.timestamp = world.time
	
	contract_history += record
	
	// Log for admins
	log_game("VILLAINS: Contract [contract_type] from [offerer] to [target] was [status]")

// Trade record datum
/datum/villains_trade_record
	var/phase
	var/trader1
	var/trader2
	var/list/items_from_trader1 = list()
	var/list/items_from_trader2 = list()
	var/timestamp

/datum/villains_trade_record/proc/get_summary()
	var/t1_items = length(items_from_trader1) ? items_from_trader1.Join(", ") : "nothing"
	var/t2_items = length(items_from_trader2) ? items_from_trader2.Join(", ") : "nothing"
	return "[trader1] traded [t1_items] with [trader2] for [t2_items]"

// Contract record datum
/datum/villains_contract_record
	var/phase
	var/offerer
	var/target
	var/contract_type
	var/status
	var/timestamp

/datum/villains_contract_record/proc/get_summary()
	return "[offerer] offered [contract_type] contract to [target] - [status]"

// Global proc to create a new game
/proc/create_villains_game()
	if(GLOB.villains_game)
		return GLOB.villains_game

	var/datum/villains_controller/game = new
	GLOB.villains_game = game
	return game
