// Villains of the Night character mob type

/mob/living/simple_animal/hostile/villains_character
	name = "Unknown"
	desc = "A participant in the Villains of the Night game."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "corpse"
	icon_living = "corpse"
	icon_dead = "corpse"
	health = 100
	maxHealth = 100
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	attack_verb_continuous = "touches"
	attack_verb_simple = "touch"
	speak_emote = list("says")
	emote_hear = list("sighs")
	emote_see = list("looks around")
	turns_per_move = 5
	see_in_dark = 8
	move_to_delay = 3
	response_help_continuous = "pats"
	response_help_simple = "pat"
	response_disarm_continuous = "pushes"
	response_disarm_simple = "push"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	mob_size = MOB_SIZE_HUMAN
	del_on_death = FALSE

	// No environmental damage
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = INFINITY

	// Villains gamemode specific variables
	var/datum/villains_character/character_data
	var/can_speak = TRUE
	var/forced_to_whisper = FALSE // For alibi phase - forces all speech to whisper
	var/list/fresh_items = list()
	var/datum/villains_action/main_action
	var/datum/villains_room/assigned_room
	var/datum/villains_action/secondary_action
	var/is_villain = FALSE
	var/list/active_buffs = list()
	var/mob/living/carbon/human/linked_ghost // The ghost player controlling this mob
	var/current_room = 0 // Room ID assigned to this player
	var/is_observing = FALSE // For Rudolta's observe ability
	var/mob/living/simple_animal/hostile/villains_character/observing_target

	// Protection flags
	var/elimination_immune = FALSE
	var/action_blocked = FALSE
	var/forsaken_counter_ready = FALSE // Forsaken Murder's counter ability
	var/main_action_blocked = FALSE // Set by handheld taser
	var/secondary_action_blocked = FALSE // Set by throwing bola

	// Trading status
	var/mob/living/simple_animal/hostile/villains_character/trading_with = null
	var/list/pending_contracts = list() // Contracts waiting for acceptance
	var/datum/villains_trade_session/active_trade_session = null // Current trade UI session
	var/mob/living/simple_animal/hostile/villains_character/cleaning_target = null // All-Around Cleaner's target

	// Investigation tracking
	var/mob/living/simple_animal/hostile/villains_character/drain_monitor_target = null
	var/mob/living/simple_animal/hostile/villains_character/rangefinder_target = null
	var/used_fairy_wine = FALSE // Makes actions appear as Talk/Trade

	// Victory tracking
	var/victory_points = 0
	var/win_condition = "default" // Can be "default", "survive", etc.

	// UI datums
	var/datum/villains_contract_ui/contract_ui
	var/datum/villains_character_sheet/character_sheet_ui

	// Character-specific tracking
	var/mob/living/simple_animal/hostile/villains_character/blessed_by = null // Who blessed this player (Puss in Boots)
	var/mob/living/simple_animal/hostile/villains_character/current_blessing = null // Who this player has blessed
	var/list/observed_players = list() // Players observed by Rudolta
	var/mob/living/simple_animal/hostile/villains_character/marked_for_hunting = null // Red Hood's Hunter's Mark target
	var/cursed_speech = FALSE // Kikimora's curse
	var/mob/living/simple_animal/hostile/villains_character/elimination_contract = null // Der Freischütz's contract holder (who accepted the contract)
	var/mob/living/simple_animal/hostile/villains_character/contract_target = null // Der Freischütz's target (chosen by contract holder)
	var/mob/living/simple_animal/hostile/villains_character/butterfly_guide_target = null // Sunset Traveller
	var/mob/living/simple_animal/hostile/villains_character/guidance_target = null // Funeral Butterflies
	var/used_hunters_mark = FALSE // Track if Red Hood used Hunter's Mark for passive
	var/soul_gather_target = null // Warden's target
	var/judge_target = null // Judgement Bird's target
	var/false_prophet_used = FALSE // Blue Shepherd ability tracking
	var/false_shelter_target = null // Fairy-Long-Legs' target to steal from when redirected

	// Item-specific tracking
	var/smoke_bombed = FALSE // Smoke Bomb effect
	var/audio_recorded = FALSE // Audio Recorder planted on them
	var/mob/living/simple_animal/hostile/villains_character/audio_recorder = null // Who is recording them
	var/has_lucky_coin = FALSE // Lucky Coin protection
	var/evidence_collection_cooldown = 0 // Prevents spam collecting evidence

/mob/living/simple_animal/hostile/villains_character/Initialize(mapload, datum/villains_character/character, mob/living/carbon/human/ghost_player)
	. = ..()
	if(character)
		setup_character(character)
	if(ghost_player)
		linked_ghost = ghost_player
		key = ghost_player.key
	var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
	AddSpell(bloodspell)

/mob/living/simple_animal/hostile/villains_character/Destroy()
	// Clean up UI datums
	if(contract_ui)
		qdel(contract_ui)
		contract_ui = null
	if(character_sheet_ui)
		qdel(character_sheet_ui)
		character_sheet_ui = null

	// Clear trade session
	if(active_trade_session)
		active_trade_session.end_session()
		active_trade_session = null

	// Clear trading partner
	if(trading_with)
		trading_with.trading_with = null
		trading_with = null

	return ..()

/mob/living/simple_animal/hostile/villains_character/proc/setup_character(datum/villains_character/character)
	character_data = character
	name = character.name
	desc = character.desc

	// Use icon data from character if available
	if(character.icon)
		icon = character.icon
	if(character.icon_state)
		icon_state = character.icon_state
	else
		icon_state = character.character_id

	if(character.icon_living)
		icon_living = character.icon_living
	else
		icon_living = icon_state

	if(character.icon_dead)
		icon_dead = character.icon_dead
	else
		icon_dead = "[icon_state]_dead"

	// Apply pixel offsets if specified
	if(character.base_pixel_x)
		base_pixel_x = character.base_pixel_x
		pixel_x = character.base_pixel_x
	if(character.base_pixel_y)
		base_pixel_y = character.base_pixel_y
		pixel_y = character.base_pixel_y

	// Apply character-specific settings
	switch(character.character_id)
		if(VILLAIN_CHAR_RUDOLTA)
			can_speak = FALSE
			speak_emote = list()
			emote_see = list("stares silently", "watches intently", "observes quietly")
		if(VILLAIN_CHAR_QUEENOFHATRED)
			speak_emote = list("declares", "proclaims")
			emote_see = list("strikes a heroic pose", "radiates determination")
		if(VILLAIN_CHAR_FORSAKENMURDER)
			speak_emote = list("mutters", "whispers")
			emote_see = list("twitches nervously", "glances around paranoidly")
		if(VILLAIN_CHAR_ALLROUNDCLEANER)
			speak_emote = list("chirps", "states")
			emote_see = list("tidies up", "looks helpful")
		if(VILLAIN_CHAR_FUNERALBUTTERFLIES)
			speak_emote = list("intones", "speaks softly")
			emote_see = list("mourns quietly", "butterflies flutter around them")
		if(VILLAIN_CHAR_FAIRYGENTLEMAN)
			speak_emote = list("charms", "eloquently states")
			emote_see = list("adjusts their tie", "offers a charming smile")
		if(VILLAIN_CHAR_PUSSINBOOTS)
			speak_emote = list("meows", "purrs")
			emote_see = list("swishes tail", "adjusts boots")
		if(VILLAIN_CHAR_DERFREISCHUTZ)
			speak_emote = list("aims", "declares")
			emote_see = list("checks their rifle", "takes aim at nothing")
		if(VILLAIN_CHAR_JUDGEMENTBIRD)
			speak_emote = list("judges", "pronounces")
			emote_see = list("spreads wings", "gazes with judgment")

	// Apply passive abilities
	character.apply_passive_ability(src, GLOB.villains_game)

// Item interaction
/mob/living/simple_animal/hostile/villains_character/attackby(obj/item/I, mob/user, params)
	// Only allow villains game items
	if(!istype(I, /obj/item/villains))
		to_chat(user, span_warning("You can't use that in the game!"))
		return

	// Check if during trade session
	if(user != src && is_trading_with(user))
		offer_trade(I, user)
		return

	return ..()

// Override for fresh item pickup
/mob/living/simple_animal/hostile/villains_character/Moved()
	. = ..()
	if(.)
		// Check for items at new location
		var/turf/T = get_turf(src)
		
		// Handle evidence collection during investigation phase with cooldown
		if(GLOB.villains_game?.current_phase == VILLAIN_PHASE_INVESTIGATION && world.time > evidence_collection_cooldown)
			// Count evidence items first
			var/evidence_count = 0
			var/obj/item/villains/first_evidence
			for(var/obj/item/villains/V in T)
				if(V.is_evidence)
					evidence_count++
					if(!first_evidence)
						first_evidence = V
			
			if(first_evidence)
				// Set cooldown based on number of evidence items
				evidence_collection_cooldown = world.time + (5 * max(1, evidence_count)) // Longer cooldown for multiple items
				
				// Process the first evidence item
				to_chat(src, span_notice("You find [first_evidence] and send it to the main room for analysis."))
				
				// Get a random open turf in main room (now cached and efficient)
				var/turf/target_turf = GLOB.villains_game.get_random_open_turf_in_main_room()
				if(target_turf)
					first_evidence.forceMove(target_turf)

				// Update the evidence list to show it was found
				for(var/i in 1 to length(GLOB.villains_game.evidence_list))
					if(findtext(GLOB.villains_game.evidence_list[i], first_evidence.name))
						// Check if already marked as found
						if(!findtext(GLOB.villains_game.evidence_list[i], "FOUND"))
							GLOB.villains_game.evidence_list[i] = "[GLOB.villains_game.evidence_list[i]] - FOUND by [name]"
						else if(!findtext(GLOB.villains_game.evidence_list[i], "[name]"))
							// Add this player's name if they haven't found it yet
							GLOB.villains_game.evidence_list[i] = "[GLOB.villains_game.evidence_list[i]], [name]"
						break
				
				// Notify about additional evidence
				if(evidence_count > 1)
					to_chat(src, span_notice("There are [evidence_count - 1] more evidence items here. Move again to collect them."))
				
				return // Don't try to pick up items if we found evidence
		
		// Normal item pickup logic
		for(var/obj/item/villains/V in T)
			// Skip evidence items in other phases
			if(V.is_evidence)
				continue

			// Check total item limit (3 items max, or 5 for Warden)
			var/total_items = 0
			for(var/obj/item/villains/I in contents)
				total_items++

			var/item_limit = (character_data?.character_id == VILLAIN_CHAR_WARDEN) ? 5 : 3

			if(total_items >= item_limit)
				break  // Stop trying to pick up items if we're at the limit

			// Check fresh item limit
			if(V.freshness == VILLAIN_ITEM_FRESH && !can_pickup_fresh())
				continue

			pickup_item(V)

/mob/living/simple_animal/hostile/villains_character/proc/can_pickup_fresh()
	// First clean up any items that might have been dropped
	update_fresh_items()
	return length(fresh_items) < VILLAIN_MAX_FRESH_ITEMS

/mob/living/simple_animal/hostile/villains_character/proc/pickup_item(obj/item/villains/V)
	// Check total item limit first
	var/total_items = 0
	for(var/obj/item/villains/I in contents)
		total_items++

	// Warden can hold 5 items
	var/item_limit = (character_data?.character_id == VILLAIN_CHAR_WARDEN) ? 5 : 3

	if(total_items >= item_limit)
		to_chat(src, span_warning("You can only carry [item_limit] items total!"))
		return FALSE

	// Then check fresh item limit
	if(V.freshness == VILLAIN_ITEM_FRESH)
		if(!can_pickup_fresh())
			to_chat(src, span_warning("You can only carry [VILLAIN_MAX_FRESH_ITEMS] fresh items!"))
			return FALSE

	V.forceMove(src)
	to_chat(src, span_notice("You pick up [V]."))
	// The item's pickup() proc will handle adding to fresh_items
	return TRUE

// Speech override for Rudolta, Kikimora, and alibi phase
/mob/living/simple_animal/hostile/villains_character/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak)
		to_chat(src, span_warning("You are unable to speak! Use emotes instead."))
		return

	// Handle forced whisper during alibi phase
	if(forced_to_whisper && !findtext(message, "#"))
		// Add whisper prefix if not already whispering
		message = "# " + message

	// Handle Kikimora's curse
	if(cursed_speech)
		// Replace all words with kiki or mora
		var/list/words = splittext(message, " ")
		var/list/cursed_words = list()
		for(var/word in words)
			cursed_words += pick("kiki", "mora")
		message = cursed_words.Join(" ")

		// Spread the curse to nearby players
		for(var/mob/living/simple_animal/hostile/villains_character/hearer in hearers(7, src))
			if(hearer != src && !hearer.cursed_speech)
				hearer.cursed_speech = TRUE
				to_chat(hearer, span_warning("Hearing the cursed words, you feel your own speech becoming corrupted!"))

	return ..(message, bubble_type, spans, sanitize, language, ignore_spam, forced)

// Trading system
/mob/living/simple_animal/hostile/villains_character/proc/is_trading_with(mob/living/simple_animal/hostile/villains_character/other)
	// TODO: Check if we have an active trade session
	return FALSE

/mob/living/simple_animal/hostile/villains_character/proc/offer_trade(obj/item/I, mob/living/simple_animal/hostile/villains_character/trader)
	// TODO: Implement trade UI
	to_chat(src, span_notice("[trader] offers you [I]."))
	to_chat(trader, span_notice("You offer [I] to [src]."))

// Phase-based behaviors
/mob/living/simple_animal/hostile/villains_character/proc/lock_in_room()
	if(!current_room || !GLOB.villains_game)
		return

	// Teleport to room first
	teleport_to_room()

	// Lock the door
	var/obj/machinery/door/airlock/door = GLOB.villains_game.room_doors[current_room]
	if(door && !door.locked)
		door.lock()

	to_chat(src, span_notice("You are locked in your room for the evening."))

/mob/living/simple_animal/hostile/villains_character/proc/unlock_room()
	if(!current_room || !GLOB.villains_game)
		return

	var/obj/machinery/door/airlock/door = GLOB.villains_game.room_doors[current_room]
	if(door && door.locked)
		door.unlock()

	to_chat(src, span_notice("Your room unlocks. You are free to explore."))

/mob/living/simple_animal/hostile/villains_character/proc/teleport_to_room()
	if(!assigned_room || !assigned_room.spawn_landmark)
		return

	forceMove(get_turf(assigned_room.spawn_landmark))

// Action effects
/mob/living/simple_animal/hostile/villains_character/proc/apply_protection()
	elimination_immune = TRUE
	to_chat(src, span_notice("You feel protected from harm."))
	RegisterSignal(src, COMSIG_VILLAIN_ELIMINATION, PROC_REF(block_elimination))

/mob/living/simple_animal/hostile/villains_character/proc/remove_protection()
	elimination_immune = FALSE
	to_chat(src, span_warning("Your protection wears off."))
	UnregisterSignal(src, COMSIG_VILLAIN_ELIMINATION)

/mob/living/simple_animal/hostile/villains_character/proc/block_elimination()
	SIGNAL_HANDLER
	if(elimination_immune)
		to_chat(src, span_userdanger("Someone tried to eliminate you, but you were protected!"))
		return VILLAIN_PREVENT_ELIMINATION

// These functions are kept for potential future use with items that block actions targeting the user
/mob/living/simple_animal/hostile/villains_character/proc/block_next_action()
	forsaken_counter_ready = TRUE
	to_chat(src, span_notice("You prepare to counter the next action against you."))
	RegisterSignal(src, COMSIG_VILLAIN_ACTION_PERFORMED, PROC_REF(counter_action))

/mob/living/simple_animal/hostile/villains_character/proc/counter_action(datum/source, datum/villains_action/action)
	SIGNAL_HANDLER
	// Debug logging
	if(GLOB.villains_game)
		log_game("VILLAINS DEBUG: counter_action called on [src], forsaken_counter_ready=[forsaken_counter_ready], action=[action], target=[action?.target]")

	// Check if we're blocking and if this action targets us
	if(forsaken_counter_ready && action && action.target == src)
		forsaken_counter_ready = FALSE
		UnregisterSignal(src, COMSIG_VILLAIN_ACTION_PERFORMED)
		to_chat(src, span_boldnotice("Restrained Violence activated! You successfully countered [action.performer]'s [action.name]!"))
		if(action.performer)
			to_chat(action.performer, span_boldwarning("Your action was violently countered by [src]!"))
		// Log this for debugging
		if(GLOB.villains_game)
			log_game("VILLAINS: [src] (Forsaken Murder) countered [action.performer]'s [action.name] action")
		return VILLAIN_PREVENT_ACTION

	// If we're blocking but this doesn't target us, stay ready
	if(forsaken_counter_ready)
		if(GLOB.villains_game)
			log_game("VILLAINS DEBUG: Action doesn't target [src], staying ready to counter")

// Rudolta's observe ability
/mob/living/simple_animal/hostile/villains_character/proc/start_observing(mob/living/simple_animal/hostile/villains_character/target)
	if(character_data?.character_id != VILLAIN_CHAR_RUDOLTA)
		return FALSE

	is_observing = TRUE
	observing_target = target
	forceMove(get_turf(target))
	to_chat(src, span_notice("You begin observing [target]."))
	return TRUE

/mob/living/simple_animal/hostile/villains_character/proc/stop_observing()
	if(!is_observing)
		return

	is_observing = FALSE
	observing_target = null
	teleport_to_room()
	to_chat(src, span_notice("You stop observing and return to your room."))

// Follow target movement (for Rudolta's observation)
/mob/living/simple_animal/hostile/villains_character/proc/follow_target(atom/movable/M, atom/oldloc, dir)
	SIGNAL_HANDLER
	if(is_observing && observing_target == M)
		forceMove(get_turf(M))
		to_chat(src, span_notice("You follow [M] to [get_area_name(M, TRUE)]."))

// Remove immunity from Judgement Bird's ability
/mob/living/simple_animal/hostile/villains_character/proc/remove_judge_immunity()
	action_blocked = FALSE

// Portrait access
/mob/living/simple_animal/hostile/villains_character/proc/GetPortrait()
	if(character_data?.portrait)
		return character_data.portrait
	return "UNKNOWN"

// UI delegation is no longer needed - the UI object handles it directly

// Death handling
/mob/living/simple_animal/hostile/villains_character/death(gibbed)
	// Clear any active trades
	if(trading_with)
		trading_with.trading_with = null
		to_chat(trading_with, span_warning("Your trading partner has died!"))
		trading_with = null

	// End active trade session
	if(active_trade_session)
		active_trade_session.end_session()

	// Close any open UIs
	if(contract_ui)
		SStgui.close_uis(contract_ui)
	if(character_sheet_ui)
		SStgui.close_uis(character_sheet_ui)

	if(GLOB.villains_game)
		GLOB.villains_game.handle_death(src)
	return ..()

// Examine for other players
/mob/living/simple_animal/hostile/villains_character/examine(mob/user)
	. = ..()
	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		. += span_notice("They are playing as [name].")
		if(is_villain && user == src)
			. += span_boldwarning("You are the villain!")

// Verb for opening action selection
/mob/living/simple_animal/hostile/villains_character/verb/select_actions()
	set name = "Select Night Actions"
	set category = "Villains"

	if(GLOB.villains_game?.current_phase != VILLAIN_PHASE_EVENING)
		to_chat(src, span_warning("You can only select actions during the evening phase!"))
		return

	var/datum/villains_action_selection/selection = new(src)
	selection.ui_interact(src)

// Contract system for Der Freischütz
/mob/living/simple_animal/hostile/villains_character/verb/offer_elimination_contract()
	set name = "Offer Elimination Contract"
	set category = "Villains"

	if(character_data?.character_id != VILLAIN_CHAR_DERFREISCHUTZ)
		return

	if(!trading_with)
		to_chat(src, span_warning("You must be trading with someone to offer a contract!"))
		return

	if(elimination_contract)
		to_chat(src, span_warning("You already have an active elimination contract with [elimination_contract]!"))
		return

	var/confirm = alert(src, "Offer an Elimination Contract to [trading_with]? If they accept, you will be able to eliminate them with Magic Bullet.", "Elimination Contract", "Yes", "No")
	if(confirm != "Yes" || !trading_with)
		return

	trading_with.pending_contracts[src] = "elimination"
	to_chat(src, span_notice("You offer an Elimination Contract to [trading_with]."))
	to_chat(trading_with, span_boldwarning("[src] offers you an Elimination Contract! You will choose who they must eliminate!"))
	to_chat(trading_with, span_notice("Use 'Review Contracts' to see details, then 'Accept Elimination Contract' or 'Decline Contract' to respond."))

// Verb for character sheet
/mob/living/simple_animal/hostile/villains_character/verb/view_character_sheet()
	set name = "View Character Sheet"
	set category = "Villains"

	if(!character_sheet_ui)
		character_sheet_ui = new(src)
	character_sheet_ui.ui_interact(src)

// Verb to review pending contracts
/mob/living/simple_animal/hostile/villains_character/verb/review_contracts()
	set name = "Review Contracts"
	set category = "Villains"

	if(!length(pending_contracts))
		to_chat(src, span_notice("You have no pending contracts."))
		return

	to_chat(src, span_notice("<b>===== PENDING CONTRACTS =====</b>"))
	var/index = 1
	for(var/mob/living/simple_animal/hostile/villains_character/offerer in pending_contracts)
		var/contract_type = pending_contracts[offerer]
		switch(contract_type)
			if("elimination")
				to_chat(src, span_warning("[index]. <b>Elimination Contract</b> from [offerer.name]"))
				to_chat(src, span_warning("   - You will choose who they must eliminate"))
				to_chat(src, span_warning("   - If successful, YOU become the villain!"))
		index++
	to_chat(src, span_notice("Use 'Accept Elimination Contract' or 'Decline Contract' to respond."))

// Verb to accept elimination contracts
/mob/living/simple_animal/hostile/villains_character/verb/accept_elimination_contract()
	set name = "Accept Elimination Contract"
	set category = "Villains"

	// Filter for elimination contracts only
	var/list/elimination_contracts = list()
	for(var/mob/living/simple_animal/hostile/villains_character/offerer in pending_contracts)
		if(pending_contracts[offerer] == "elimination")
			elimination_contracts[offerer.name] = offerer

	if(!length(elimination_contracts))
		to_chat(src, span_warning("You have no pending elimination contracts."))
		return

	// Choose which contract if multiple
	var/chosen_name
	if(length(elimination_contracts) == 1)
		// Get the first key from the associative list
		for(var/name in elimination_contracts)
			chosen_name = name
			break
	else
		chosen_name = input(src, "Which elimination contract do you want to accept?", "Accept Contract") as null|anything in elimination_contracts

	if(!chosen_name)
		return

	var/mob/living/simple_animal/hostile/villains_character/offerer = elimination_contracts[chosen_name]
	if(!offerer || !(offerer in pending_contracts))
		to_chat(src, span_warning("Contract no longer valid."))
		return

	// Get list of valid targets
	var/list/valid_targets = list()
	if(GLOB.villains_game?.living_players)
		for(var/mob/living/simple_animal/hostile/villains_character/player in GLOB.villains_game.living_players)
			if(player != src && player != offerer) // Can't target self or Der Freischütz
				valid_targets[player.name] = player

	if(!length(valid_targets))
		to_chat(src, span_warning("No valid targets available!"))
		return

	// Choose target
	var/target_name = input(src, "Who should [offerer.name] eliminate with Magic Bullet?", "Choose Target") as null|anything in valid_targets
	if(!target_name)
		return

	var/mob/living/simple_animal/hostile/villains_character/target = valid_targets[target_name]
	if(!target || !istype(target))
		to_chat(src, span_warning("Invalid target selected!"))
		return

	// Confirm
	var/confirm = alert(src, "Accept contract from [offerer.name] to eliminate [target.name]? If successful, you will become the villain!", "Confirm Contract", "Accept", "Cancel")
	if(confirm != "Accept")
		return

	// Set up the contract
	offerer.elimination_contract = src
	offerer.contract_target = target

	to_chat(offerer, span_boldnotice("[name] accepts your Elimination Contract! You must eliminate [target.name] with Magic Bullet!"))
	to_chat(src, span_boldwarning("You accept [offerer.name]'s Elimination Contract. They must eliminate [target.name]!"))

	// Record contract acceptance
	if(GLOB.villains_game)
		GLOB.villains_game.record_contract(offerer, src, "elimination", "accepted")

	// Remove from pending
	pending_contracts -= offerer

// Verb to decline contracts
/mob/living/simple_animal/hostile/villains_character/verb/decline_contract()
	set name = "Decline Contract"
	set category = "Villains"

	if(!length(pending_contracts))
		to_chat(src, span_notice("You have no pending contracts."))
		return

	// Build list of contracts
	var/list/contract_list = list()
	for(var/mob/living/simple_animal/hostile/villains_character/offerer in pending_contracts)
		var/contract_type = pending_contracts[offerer]
		contract_list["[contract_type] from [offerer.name]"] = offerer

	var/chosen = input(src, "Which contract do you want to decline?", "Decline Contract") as null|anything in contract_list
	if(!chosen)
		return

	var/mob/living/simple_animal/hostile/villains_character/offerer = contract_list[chosen]
	if(!offerer || !(offerer in pending_contracts))
		return

	var/contract_type = pending_contracts[offerer]
	pending_contracts -= offerer

	to_chat(src, span_notice("You decline the [contract_type] contract from [offerer.name]."))
	to_chat(offerer, span_warning("[name] has declined your [contract_type] contract."))

// Item management
/mob/living/simple_animal/hostile/villains_character/proc/update_fresh_items()
	// Clean up any items that are no longer in our inventory
	var/list/to_remove = list()
	for(var/obj/item/villains/V in fresh_items)
		if(V.loc != src)
			to_remove += V
	fresh_items -= to_remove

// Verb for giving items
/mob/living/simple_animal/hostile/villains_character/verb/give_item()
	set name = "Give Item"
	set category = "Villains"

	// Find nearby players
	var/list/nearby_players = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in oview(1, src))
		nearby_players += P

	if(!length(nearby_players))
		to_chat(src, span_warning("No one is close enough to trade with!"))
		return

	var/mob/living/simple_animal/hostile/villains_character/target = input(src, "Who do you want to give an item to?", "Give Item") as null|anything in nearby_players
	if(!target || !(target in oview(1, src)))
		return

	// Get list of items
	var/list/items = list()
	for(var/obj/item/villains/I in contents)
		items += I

	if(!length(items))
		to_chat(src, span_warning("You have no items to give!"))
		return

	var/obj/item/villains/chosen_item = input(src, "What item do you want to give?", "Give Item") as null|anything in items
	if(!chosen_item || !(chosen_item in contents))
		return

	// Remove from fresh items if applicable
	if(chosen_item.freshness == VILLAIN_ITEM_FRESH && (chosen_item in fresh_items))
		fresh_items -= chosen_item

	// Transfer the item
	chosen_item.forceMove(target)
	to_chat(src, span_notice("You give [chosen_item] to [target]."))
	to_chat(target, span_notice("[src] gives you [chosen_item]."))

// Help/Tutorial System
/mob/living/simple_animal/hostile/villains_character/verb/view_game_help()
	set name = "Game Help & Tutorial"
	set category = "Villains"
	set desc = "View comprehensive help and tutorial information for Villains of the Night"

	var/list/help_topics = list(
		"Quick Start Guide",
		"Victory Point System",
		"Game Phases",
		"Character Abilities",
		"Item Guide",
		"Action Priority",
		"Trading System",
		"Evidence & Investigation",
		"Tips for Innocents",
		"Tips for Villains",
		"FAQ"
	)

	var/chosen_topic = input(src, "What would you like to learn about?", "Villains Help System") as null|anything in help_topics
	if(!chosen_topic)
		return

	switch(chosen_topic)
		if("Quick Start Guide")
			show_quick_start_guide()
		if("Victory Point System")
			show_victory_point_guide()
		if("Game Phases")
			show_game_phases_guide()
		if("Character Abilities")
			show_character_guide()
		if("Item Guide")
			show_item_guide()
		if("Action Priority")
			show_action_priority_guide()
		if("Trading System")
			show_trading_guide()
		if("Evidence & Investigation")
			show_evidence_guide()
		if("Tips for Innocents")
			show_innocent_tips()
		if("Tips for Villains")
			show_villain_tips()
		if("FAQ")
			show_faq()

/mob/living/simple_animal/hostile/villains_character/proc/show_quick_start_guide()
	var/dat = {"<html><head><title>Quick Start Guide</title></head><body>
	<h2>Villains of the Night - Quick Start</h2>
	<hr>
	<h3>Welcome!</h3>
	<p>You're playing a social deduction game where one player is secretly the villain trying to eliminate others!</p>

	<h3>Your Goal:</h3>
	<ul>
	<li><b>As Innocent:</b> Find and vote out the villain to gain victory points</li>
	<li><b>As Villain:</b> Eliminate players without getting caught</li>
	</ul>

	<h3>Key Mechanics:</h3>
	<ul>
	<li><b>Nobody dies from voting!</b> Wrong votes cost you points, correct votes give you points</li>
	<li>The villain ALWAYS leaves after voting (whether caught or not)</li>
	<li>Game continues with new villains until <5 players remain</li>
	<li>Winners have ≥1 victory points at game end</li>
	</ul>

	<h3>First Steps:</h3>
	<ol>
	<li>Check your character sheet (View Character Sheet verb) to see your abilities</li>
	<li>During Morning phase, explore and collect items (max 2 fresh items)</li>
	<li>Talk with other players to build trust (or deceive!)</li>
	<li>During Evening phase, select your night actions carefully</li>
	<li>If someone dies, investigate for evidence and vote wisely!</li>
	</ol>

	<h3>Quick Commands:</h3>
	<ul>
	<li><b>View Character Sheet</b> - See your abilities and items</li>
	<li><b>Select Night Actions</b> - Choose what to do at night (Evening phase only)</li>
	<li><b>Give Item</b> - Trade items with nearby players</li>
	<li><b>Review Contracts</b> - Check any pending contracts (Der Freischütz)</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=600x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_victory_point_guide()
	var/dat = {"<html><head><title>Victory Point System</title></head><body>
	<h2>Victory Point System</h2>
	<hr>
	<p>Unlike traditional Mafia games, <b>nobody dies from voting</b> in Villains of the Night!</p>

	<h3>How Points Work:</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Situation</th><th>Points</th><th>Result</th></tr>
	<tr><td>Vote for the actual villain</td><td style='color:green'>+1</td><td>Villain leaves (caught)</td></tr>
	<tr><td>Vote for an innocent player</td><td style='color:red'>-1</td><td>Innocent stays, villain leaves</td></tr>
	<tr><td>Tie or no votes</td><td style='color:red'>-1</td><td>Villain wins by default</td></tr>
	</table>

	<h3>Game Flow:</h3>
	<ol>
	<li>Each round has one villain who tries to eliminate players</li>
	<li>After voting, the villain ALWAYS leaves (whether caught or not)</li>
	<li>Innocent players who were voted STAY in the game</li>
	<li>A new villain is selected from remaining players</li>
	<li>Game continues until fewer than 5 players remain</li>
	</ol>

	<h3>Winning:</h3>
	<ul>
	<li><b>Victory:</b> Have 1 or more victory points when game ends</li>
	<li><b>Defeat:</b> Have 0 or negative victory points</li>
	<li>Track your points on the main game panel</li>
	</ul>

	<h3>Strategy Tips:</h3>
	<ul>
	<li>Every vote matters - wrong votes hurt your final score!</li>
	<li>Pay attention to evidence and alibis</li>
	<li>Sometimes abstaining is better than guessing</li>
	<li>Build trust to coordinate votes with allies</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=600x600")

/mob/living/simple_animal/hostile/villains_character/proc/show_game_phases_guide()
	var/dat = {"<html><head><title>Game Phases Guide</title></head><body>
	<h2>Game Phases</h2>
	<hr>
	<p>The game cycles through several phases. Here's what happens in each:</p>

	<h3>1. Morning Phase (5-10 minutes)</h3>
	<ul>
	<li>🚪 All doors unlocked - explore freely!</li>
	<li>🎁 Items spawn around the facility (green outline)</li>
	<li>💬 Talk and trade with other players</li>
	<li>📦 Pick up to 2 "fresh" items (3 total item limit)</li>
	<li>🗳️ Vote to extend morning by 5 minutes if needed</li>
	</ul>

	<h3>2. Evening Phase (1 minute)</h3>
	<ul>
	<li>🔒 Everyone locked in their rooms</li>
	<li>📋 Select your night actions using "Select Night Actions" verb</li>
	<li><b>Main Action:</b> Talk/Trade, Use Ability, Use Item, or Eliminate (villain only)</li>
	<li><b>Secondary Action:</b> Use certain items or special abilities</li>
	</ul>

	<h3>3. Nighttime Phase (0-8 minutes)</h3>
	<ul>
	<li>🌙 Actions play out automatically</li>
	<li>⏱️ 5-second delay between actions</li>
	<li>📊 Actions resolve by priority (see Action Priority help)</li>
	<li>💀 Someone might die!</li>
	</ul>

	<h3>If Someone Dies:</h3>

	<h4>4. Investigation Phase (5 minutes)</h4>
	<ul>
	<li>🔍 Search hallways for evidence (yellow outline)</li>
	<li>🔎 Click evidence to send to main room</li>
	<li>💡 Dead player's items become evidence</li>
	</ul>

	<h4>5. Trial Briefing (2 minutes)</h4>
	<ul>
	<li>👥 Everyone teleported to main room</li>
	<li>📋 Review collected evidence together</li>
	<li>💬 Discuss findings before alibis</li>
	</ul>

	<h4>6. Alibi Phase (30 seconds per player)</h4>
	<ul>
	<li>🎤 Each player explains their night actions</li>
	<li>🤫 Only current speaker can talk (others whisper only)</li>
	<li>⏱️ 30 seconds per person</li>
	</ul>

	<h4>7. Discussion Phase (8-14 minutes)</h4>
	<ul>
	<li>💬 Free discussion - everyone can talk</li>
	<li>🤔 Analyze alibis and evidence</li>
	<li>🤝 Form voting alliances</li>
	</ul>

	<h4>8. Voting Phase (1 minute)</h4>
	<ul>
	<li>🗳️ Vote who you think is the villain</li>
	<li>⚠️ Wrong votes cost you points!</li>
	<li>🎯 Correct votes give you points!</li>
	</ul>

	<h4>9. Results Phase</h4>
	<ul>
	<li>📊 Villain revealed</li>
	<li>🏆 Victory points updated</li>
	<li>💬 3-4 minute post-game discussion</li>
	<li>🔄 New round starts if 5+ players remain</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x800")

/mob/living/simple_animal/hostile/villains_character/proc/show_character_guide()
	var/dat = {"<html><head><title>Character Abilities Guide</title></head><body>
	<h2>Character Abilities</h2>
	<hr>
	<p>Each character has unique active and passive abilities. Choose wisely!</p>

	<h3>🛡️ Protective Characters</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Character</th><th>Active Ability</th><th>Passive</th><th>Strategy</th></tr>
	<tr><td><b>Queen of Hatred</b></td><td>Protect target from elimination</td><td>50% less likely to be villain</td><td>Build trust, protect key players</td></tr>
	<tr><td><b>Puss in Boots</b></td><td>Give permanent protection (one at a time)</td><td>Free talk/trade with protected</td><td>Form strong partnerships</td></tr>
	<tr><td><b>Red Blooded American</b></td><td>Redirect all actions to self</td><td>Learn count of aggressive actions</td><td>High risk protection</td></tr>
	</table>

	<h3>🔍 Investigative Characters</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Character</th><th>Active Ability</th><th>Passive</th><th>Strategy</th></tr>
	<tr><td><b>Funeral Butterflies</b></td><td>See all visitors to target</td><td>See visitor count to dead</td><td>Track movements</td></tr>
	<tr><td><b>Judgement Bird</b></td><td>Check if action is Innocent/Guilty (Secondary!)</td><td>Immune while judging</td><td>Identify villains</td></tr>
	<tr><td><b>Shrimp Executive</b></td><td>See inventory + visits</td><td>Learn random item user if alone</td><td>Information broker</td></tr>
	<tr><td><b>Sunset Traveller</b></td><td>See who visits target</td><td>Trade partners immune to suppression</td><td>Safe info gathering</td></tr>
	<tr><td><b>Little Red</b></td><td>Alert if target uses aggressive action</td><td>Steal item from hunted targets</td><td>Hunt villains</td></tr>
	<tr><td><b>Blue Shepherd</b></td><td>80% see villain action, 20% random</td><td>Get false info each morning</td><td>Deduce from lies</td></tr>
	</table>

	<h3>🚫 Suppressive Characters</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Character</th><th>Active Ability</th><th>Passive</th><th>Strategy</th></tr>
	<tr><td><b>Forsaken Murder</b></td><td>Block first action against you</td><td>Learn targeter count</td><td>Bait attackers</td></tr>
	<tr><td><b>Fairy-Long-Legs</b></td><td>Force target to target you</td><td>Steal from redirected</td><td>Chaos and theft</td></tr>
	<tr><td><b>Kikimora</b></td><td>Target can only say "kiki/mora"</td><td>Curse spreads</td><td>Communication chaos</td></tr>
	<tr><td><b>The Warden</b></td><td>Cancel items, steal used ones</td><td>Hold 5 items (vs 3)</td><td>Item domination</td></tr>
	</table>

	<h3>🎭 Special Characters</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Character</th><th>Active Ability</th><th>Passive</th><th>Strategy</th></tr>
	<tr><td><b>All-Around Cleaner</b></td><td>Talk then steal random item</td><td>Get random used item nightly</td><td>Resource control</td></tr>
	<tr><td><b>Fairy Gentleman</b></td><td>Create Fairy Wine items</td><td>Know when wine used</td><td>Social network</td></tr>
	<tr><td><b>Der Freischütz</b></td><td>Contract elimination</td><td>Offer contracts in trades</td><td>High stakes deals</td></tr>
	<tr><td><b>Rudolta</b></td><td>Physically follow target</td><td>Cannot speak at all</td><td>Pure observation</td></tr>
	</table>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=800x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_item_guide()
	var/dat = {"<html><head><title>Item Guide</title></head><body>
	<h2>Item Guide</h2>
	<hr>
	<p>Items provide powerful one-time effects. Use them wisely!</p>

	<h3>Item Basics:</h3>
	<ul>
	<li>🟢 <b>Green outline</b> = Fresh item (just spawned)</li>
	<li>🟡 <b>Yellow outline</b> = Evidence (used last night)</li>
	<li>📦 Can only carry 2 fresh items at once</li>
	<li>🎒 Maximum 3 items total (5 for Warden)</li>
	<li>⚡ EMP'd items can't be used that night</li>
	</ul>

	<h3>🔍 Investigative Items (Information)</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Item</th><th>Rarity</th><th>Cost</th><th>Effect</th></tr>
	<tr><td>Binoculars</td><td>Common</td><td>Main</td><td>View target's inventory</td></tr>
	<tr><td>Audio Recorder</td><td>Common</td><td>Main</td><td>Hear target's conversations</td></tr>
	<tr><td>Command Projector</td><td>Common</td><td>Secondary</td><td>Send 100-char message</td></tr>
	<tr><td>Enkephalin Detector</td><td>Uncommon</td><td>Main</td><td>See who target targeted</td></tr>
	<tr><td>DEEPSCAN Kit</td><td>Uncommon</td><td>Main</td><td>See target's actions</td></tr>
	<tr><td>Drain Monitor</td><td>Uncommon</td><td>Main</td><td>See who targeted your target</td></tr>
	<tr><td>Keen-Sense Rangefinder</td><td>Uncommon</td><td>Main</td><td>See all actions on target</td></tr>
	</table>

	<h3>🛡️ Protective Items (Defense)</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Item</th><th>Rarity</th><th>Cost</th><th>Effect</th></tr>
	<tr><td>Smoke Bomb</td><td>Uncommon</td><td>Main</td><td>All actions on you fail</td></tr>
	<tr><td>Forcefield Projector</td><td>Rare</td><td>Main</td><td>Self elimination immunity</td></tr>
	<tr><td>Guardian Drone</td><td>Rare</td><td>Main</td><td>Target elimination immunity</td></tr>
	</table>

	<h3>⚡ Suppressive Items (Disruption)</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Item</th><th>Rarity</th><th>Cost</th><th>Effect</th></tr>
	<tr><td>Throwing Bola</td><td>Common</td><td>Secondary</td><td>Cancel target's secondary</td></tr>
	<tr><td>Handheld Taser</td><td>Uncommon</td><td>Main</td><td>Cancel target's main action</td></tr>
	<tr><td>W-Corp Teleporter</td><td>Uncommon</td><td>Main</td><td>Randomize target's target</td></tr>
	<tr><td>Nitrile Gloves</td><td>Rare</td><td>Main</td><td>Steal item, cancel if in use</td></tr>
	<tr><td>EMP Device</td><td>Rare</td><td>Main</td><td>Disable all target's items</td></tr>
	</table>

	<h3>✨ Special Items (Unique)</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Item</th><th>Rarity</th><th>Cost</th><th>Effect</th></tr>
	<tr><td>Lucky Coin</td><td>Uncommon</td><td>Secondary</td><td>Block one negative effect</td></tr>
	<tr><td>Fairy Wine</td><td>Rare</td><td>Secondary</td><td>Talk/trade with main target</td></tr>
	</table>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=700x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_action_priority_guide()
	var/dat = {"<html><head><title>Action Priority Guide</title></head><body>
	<h2>Action Priority System</h2>
	<hr>
	<p>Actions resolve in a specific order each night. Understanding this is crucial!</p>

	<h3>Priority Order (First to Last):</h3>
	<ol>
	<li><b style='color:orange'>🚫 Suppressive (Priority 1)</b>
		<ul>
		<li>Handheld Taser (blocks main actions)</li>
		<li>Throwing Bola (blocks secondary actions)</li>
		<li>W-Corp Teleporter (randomizes targets)</li>
		<li>EMP Device (disables items)</li>
		<li>Forsaken Murder's counter</li>
		</ul>
	</li>
	<li><b style='color:blue'>🛡️ Protective (Priority 2)</b>
		<ul>
		<li>Queen of Hatred's protection</li>
		<li>Forcefield Projector</li>
		<li>Guardian Drone</li>
		<li>Smoke Bomb</li>
		</ul>
	</li>
	<li><b style='color:green'>🔍 Investigative (Priority 3)</b>
		<ul>
		<li>All scanning abilities</li>
		<li>Binoculars, DEEPSCAN Kit</li>
		<li>Audio Recorder</li>
		<li>Judgement Bird's judge</li>
		</ul>
	</li>
	<li><b>🤝 Typeless (Priority 4)</b>
		<ul>
		<li>Talk/Trade sessions</li>
		<li>Most character abilities</li>
		<li>Fairy Wine usage</li>
		</ul>
	</li>
	<li><b style='color:red'>💀 Elimination (Priority 5)</b>
		<ul>
		<li>Villain's eliminate action</li>
		<li>Der Freischütz's Magic Bullet</li>
		<li>Always happens last!</li>
		</ul>
	</li>
	</ol>

	<h3>Why Priority Matters:</h3>
	<ul>
	<li><b>Taser beats everything:</b> If you're tasered, your main action fails</li>
	<li><b>Protection beats elimination:</b> Protected players survive kills</li>
	<li><b>Investigation sees final results:</b> Scans show what actually happened</li>
	<li><b>Elimination always last:</b> All other effects apply first</li>
	</ul>

	<h3>Strategic Examples:</h3>
	<ul>
	<li>✅ Taser the villain → Their kill fails</li>
	<li>✅ Protect someone → They survive elimination</li>
	<li>✅ Smoke Bomb yourself → All actions on you fail</li>
	<li>❌ Try to scan a smoke bombed player → Scan fails</li>
	<li>❌ Try to protect after being tasered → Protection fails</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_trading_guide()
	var/dat = {"<html><head><title>Trading System Guide</title></head><body>
	<h2>Trading System</h2>
	<hr>
	<p>Trading is a key social mechanic. Build alliances or make deals!</p>

	<h3>How to Trade:</h3>
	<ol>
	<li>During <b>Morning Phase</b>: Use "Give Item" verb when next to someone</li>
	<li>During <b>Night Phase</b>: Select "Talk/Trade" as your main action</li>
	</ol>

	<h3>Talk/Trade Sessions:</h3>
	<ul>
	<li>⏱️ Last 2 minutes</li>
	<li>💬 Private conversation between players</li>
	<li>📦 Can exchange items freely</li>
	<li>📜 Some abilities trigger during trades</li>
	</ul>

	<h3>Character Trade Bonuses:</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Character</th><th>Trade Effect</th></tr>
	<tr><td>Der Freischütz</td><td>Can offer elimination contracts</td></tr>
	<tr><td>All-Around Cleaner</td><td>Steals random item after trading</td></tr>
	<tr><td>Sunset Traveller</td><td>Trade partners immune to suppression</td></tr>
	<tr><td>Puss in Boots</td><td>Free trade with blessed player</td></tr>
	</table>

	<h3>Der Freischütz Contracts:</h3>
	<p>Special mechanic during trades:</p>
	<ol>
	<li>Der Freischütz offers contract during trade</li>
	<li>Partner chooses who Der must eliminate</li>
	<li>If successful, <b>partner becomes new villain!</b></li>
	<li>Changes win conditions for both players</li>
	</ol>

	<h3>Trading Strategy:</h3>
	<ul>
	<li>🤝 Trade protection items to trusted allies</li>
	<li>🔍 Trade info items for mutual benefit</li>
	<li>⚡ Keep suppression items secret</li>
	<li>🎭 Villains: Trade to seem helpful</li>
	<li>📜 Watch for contract offers!</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=600x650")

/mob/living/simple_animal/hostile/villains_character/proc/show_evidence_guide()
	var/dat = {"<html><head><title>Evidence & Investigation Guide</title></head><body>
	<h2>Evidence & Investigation</h2>
	<hr>
	<p>When someone dies, investigation phase begins. Find clues to catch the villain!</p>

	<h3>Investigation Phase (5 minutes):</h3>
	<ul>
	<li>🔍 Evidence spawns in <b>hallways only</b></li>
	<li>🟡 Look for <b>yellow outlined items</b></li>
	<li>👆 Click evidence to send to main room</li>
	<li>📋 All evidence appears on public list</li>
	<li>💀 Dead player's items become evidence</li>
	</ul>

	<h3>Types of Evidence:</h3>
	<table border='1' cellpadding='5'>
	<tr><th>Evidence</th><th>What it Reveals</th></tr>
	<tr><td>Used Items</td><td>What items were used last night</td></tr>
	<tr><td>Dead Player's Items</td><td>What the victim was carrying</td></tr>
	<tr><td>Blood Trail</td><td>Direction of attack</td></tr>
	<tr><td>Footprints</td><td>Someone was here</td></tr>
	</table>

	<h3>Evidence Analysis Tips:</h3>
	<ul>
	<li>🔍 <b>Used protective item?</b> Someone tried to kill there</li>
	<li>⚡ <b>Used suppressive item?</b> Check who was suppressed</li>
	<li>📦 <b>Victim had protection?</b> It was bypassed somehow</li>
	<li>🚪 <b>Location matters!</b> Evidence shows where actions happened</li>
	</ul>

	<h3>During Trial Briefing:</h3>
	<ul>
	<li>Review all collected evidence</li>
	<li>Note who found what (shown in list)</li>
	<li>Discuss patterns before alibis start</li>
	<li>Form theories to test during alibis</li>
	</ul>

	<h3>Common Evidence Patterns:</h3>
	<ul>
	<li><b>No protective items used</b> → Victim was caught off-guard</li>
	<li><b>Multiple scanners used</b> → Heavy investigation night</li>
	<li><b>Suppression items used</b> → Someone blocked actions</li>
	<li><b>Trade-related items</b> → Check who was trading</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x650")

/mob/living/simple_animal/hostile/villains_character/proc/show_innocent_tips()
	var/dat = {"<html><head><title>Tips for Innocent Players</title></head><body>
	<h2>Tips for Innocent Players</h2>
	<hr>
	<p>How to find villains and earn victory points!</p>

	<h3>🔍 Information Gathering:</h3>
	<ul>
	<li>Use investigative abilities on suspicious players</li>
	<li>Track who visits whom each night</li>
	<li>Share information with trusted allies</li>
	<li>Cross-reference multiple sources</li>
	<li>Note inconsistencies in alibis</li>
	</ul>

	<h3>🛡️ Survival Strategies:</h3>
	<ul>
	<li>Collect protective items when possible</li>
	<li>Trade protection to trusted allies</li>
	<li>Use suppression to stop suspected villains</li>
	<li>Avoid being alone with suspicious players</li>
	<li>Save protection for high-risk nights</li>
	</ul>

	<h3>🤝 Building Trust:</h3>
	<ul>
	<li>Be consistent in your actions</li>
	<li>Share useful items with allies</li>
	<li>Verify claims when possible</li>
	<li>Form voting blocks with confirmed innocents</li>
	<li>Remember: Queen of Hatred is rarely villain (50% less)</li>
	</ul>

	<h3>Character-Specific Tips:</h3>
	<ul>
	<li><b>Judgement Bird:</b> Your ability doesn't use main action!</li>
	<li><b>Funeral Butterflies:</b> Check popular players for visitor info</li>
	<li><b>Shrimp Executive:</b> Stay alone sometimes for passive</li>
	<li><b>Blue Shepherd:</b> Your info is partly false - verify!</li>
	</ul>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_villain_tips()
	var/dat = {"<html><head><title>Tips for Villain Players</title></head><body>
	<h2>Tips for Villain Players</h2>
	<hr>
	<p>How to eliminate players without getting caught!</p>

	<h3>😈 Deception Basics:</h3>
	<ul>
	<li>Act like an innocent - help others!</li>
	<li>Build trust before striking</li>
	<li>Create believable alibis</li>
	<li>Use your character ability normally</li>
	<li>Trade items to seem cooperative</li>
	</ul>

	<h3>🎯 Target Selection:</h3>
	<ul>
	<li>Avoid killing investigators early</li>
	<li>Target isolated players</li>
	<li>Kill those who suspect you</li>
	<li>Create confusion with target choice</li>
	<li>Sometimes skip killing to throw off suspicion</li>
	</ul>

	<h3>🎭 Creating Alibis:</h3>
	<ul>
	<li>Have a believable story ready</li>
	<li>Mention verifiable details</li>
	<li>Claim to use items you have</li>
	<li>Coordinate with trade partners</li>
	<li>Don't over-explain - keep it simple</li>
	</ul>

	<h3>🔍 Avoiding Detection:</h3>
	<ul>
	<li>Watch for investigation items</li>
	<li>Beware of Judgement Bird's ability</li>
	<li>Use suppression to block scanners</li>
	<li>Trade away suspicious items</li>
	<li>Frame others with strategic kills</li>
	</ul>

	<h3>💡 Advanced Strategies:</h3>
	<ul>
	<li>Kill during busy nights (many actions)</li>
	<li>Target players who were fighting</li>
	<li>Save protection items for yourself</li>
	<li>Blame missing players first</li>
	<li>Use character ability to gain trust</li>
	</ul>

	<h3>Character-Specific Villain Tips:</h3>
	<ul>
	<li><b>Queen of Hatred:</b> You're naturally trusted - use it!</li>
	<li><b>Forsaken Murder:</b> Bait investigations then counter</li>
	<li><b>Der Freischütz:</b> Kill contract holder to hide evidence</li>
	<li><b>Warden:</b> Steal protective items before killing</li>
	</ul>

	<h3>Remember:</h3>
	<p>You leave after voting regardless - make your round count!</p>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x700")

/mob/living/simple_animal/hostile/villains_character/proc/show_faq()
	var/dat = {"<html><head><title>Frequently Asked Questions</title></head><body>
	<h2>Frequently Asked Questions</h2>
	<hr>

	<h3>Q: Can I talk during other people's alibis?</h3>
	<p>A: No, only whispers. The current speaker has exclusive talking rights.</p>

	<h3>Q: What happens if nobody votes?</h3>
	<p>A: The villain wins by default in case of ties or no votes.</p>

	<h3>Q: Can I refuse to trade items?</h3>
	<p>A: Yes! Trading is voluntary. You can talk without trading.</p>

	<h3>Q: Do I keep items between rounds?</h3>
	<p>A: Yes, nothing forces you to drop all of your items.</p>

	<h3>Q: Can villains use protective abilities?</h3>
	<p>A: Yes! Villains can use any ability to maintain cover.</p>

	<h3>Q: What's the best character for beginners?</h3>
	<p>A: Queen of Hatred (simple protection) or Judgement Bird (clear info).</p>

	<h3>Q: How many rounds are there?</h3>
	<p>A: Varies! Game continues until fewer than 5 players remain.</p>

	<h3>Q: What happens to voted innocent players?</h3>
	<p>A: They stay in the game! Only villains leave when voted.</p>

	<h3>Q: What if everyone has negative points?</h3>
	<p>A: The villains win! At least one player needs 1+ points for innocents to win.</p>

	<h3>Q: What does Der Freischütz's contract do?</h3>
	<p>A: If accepted and successful, the contract acceptor becomes the new villain!</p>

	<h3>Q: Can Rudolta communicate at all?</h3>
	<p>A: No speech, but they can use emotes (*wave, *nod, etc).</p>

	<h3>Q: How do I know if I'm protected?</h3>
	<p>A: You'll get a message saying you feel protected.</p>

	<h3>Q: Can I drop items?</h3>
	<p>A: Yes! You can just click on the item in your character to drop it, but you can give them to others with "Give Item" verb.</p>
	</body></html>"}

	usr << browse(dat, "window=villains_help;size=650x700")
