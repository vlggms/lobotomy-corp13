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

	// Item-specific tracking
	var/smoke_bombed = FALSE // Smoke Bomb effect
	var/audio_recorded = FALSE // Audio Recorder planted on them
	var/mob/living/simple_animal/hostile/villains_character/audio_recorder = null // Who is recording them
	var/has_lucky_coin = FALSE // Lucky Coin protection

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
		for(var/obj/item/villains/V in T)
			// Handle evidence collection during investigation phase
			if(V.is_evidence && GLOB.villains_game?.current_phase == VILLAIN_PHASE_INVESTIGATION)
				// Mark as found
				to_chat(src, span_notice("You find [V] and send it to the main room for analysis."))
				
				// Get a random open turf in main room
				var/turf/target_turf = GLOB.villains_game.get_random_open_turf_in_main_room()
				if(target_turf)
					V.forceMove(target_turf)
				
				// Update the evidence list to show it was found
				for(var/i in 1 to length(GLOB.villains_game.evidence_list))
					if(findtext(GLOB.villains_game.evidence_list[i], V.name))
						GLOB.villains_game.evidence_list[i] = "[GLOB.villains_game.evidence_list[i]] - <b>FOUND by [name]</b>"
						break
				
				continue // Don't pick it up, just mark as found
			
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
