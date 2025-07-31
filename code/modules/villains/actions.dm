// Villains of the Night action system

/datum/villains_action
	var/name = "Unknown Action"
	var/mob/living/performer
	var/mob/living/target
	var/action_type = VILLAIN_ACTION_TYPELESS
	var/action_cost = VILLAIN_ACTION_MAIN
	var/completed = FALSE
	var/prevented = FALSE
	var/datum/villains_controller/game
	var/priority // Custom priority override

/datum/villains_action/New(mob/living/user, mob/living/target_mob, datum/villains_controller/controller)
	performer = user
	target = target_mob
	game = controller

/datum/villains_action/proc/can_perform()
	if(!performer)
		return FALSE
	// Allow fake players (no client) to perform actions
	if(prevented)
		return FALSE
	// Check if the performer is blocked by taser
	if(istype(performer, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/P = performer
		if(P.main_action_blocked && action_cost == VILLAIN_ACTION_MAIN)
			prevented = TRUE
			to_chat(P, span_warning("Your action failed to execute."))
			return FALSE
	if(SEND_SIGNAL(performer, COMSIG_VILLAIN_ACTION_PERFORMED, src) & VILLAIN_PREVENT_ACTION)
		prevented = TRUE
		return FALSE
	// Also send signal to target for defensive abilities like Forsaken Murder
	if(target && target != performer)
		if(SEND_SIGNAL(target, COMSIG_VILLAIN_ACTION_PERFORMED, src) & VILLAIN_PREVENT_ACTION)
			prevented = TRUE
			return FALSE
	return TRUE

/datum/villains_action/proc/perform()
	if(!can_perform())
		completed = TRUE  // Mark as complete even if failed
		return FALSE
	// Most actions complete instantly, but some (like talk_trade) take time
	// Those should set completed = TRUE when they're actually done
	completed = TRUE
	return TRUE

/datum/villains_action/proc/get_priority()
	if(priority)
		return priority
	return action_type

// Base action types

/datum/villains_action/talk_trade
	name = "Talk and Trade"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_MAIN

/datum/villains_action/talk_trade/perform()
	// Don't call parent's perform() as it sets completed = TRUE immediately
	if(!can_perform())
		completed = TRUE
		return FALSE
	if(!target)
		to_chat(performer, span_warning("Invalid target for Talk and Trade!"))
		return FALSE

	// Check if they're both villains characters
	if(!istype(performer, /mob/living/simple_animal/hostile/villains_character) || !istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/P = performer
	var/mob/living/simple_animal/hostile/villains_character/T = target

	// Check if target is already trading
	if(T.trading_with)
		to_chat(P, span_notice("[T] is already trading with someone. Waiting for them to finish..."))
		// Wait for their trade to finish
		while(T.trading_with && completed == FALSE)
			sleep(1 SECONDS)
			if(!T || !P) // Safety check
				return FALSE

	// Check again if target is available
	if(T.trading_with)
		to_chat(P, span_warning("[T] is still busy!"))
		return FALSE

	// Mark both as trading
	P.trading_with = T
	T.trading_with = P

	// Teleport performer to target's room
	if(T.assigned_room?.spawn_landmark)
		P.forceMove(get_turf(T.assigned_room.spawn_landmark))
	else
		P.forceMove(get_turf(T))

	to_chat(performer, span_notice("You visit [target] to talk and trade..."))
	to_chat(target, span_notice("[performer] visits you to talk and trade..."))

	// Create trading session
	var/datum/villains_trade_session/session = new(P, T)
	
	// Apply Sunset Traveller's passive - grant suppression immunity
	if(P.character_data?.character_id == VILLAIN_CHAR_SUNSETTRAVELLER)
		T.action_blocked = TRUE
		to_chat(T, span_notice("[P]'s restful presence protects you from suppressive actions for the rest of the night!"))
	else if(T.character_data?.character_id == VILLAIN_CHAR_SUNSETTRAVELLER)
		P.action_blocked = TRUE
		to_chat(P, span_notice("[T]'s restful presence protects you from suppressive actions for the rest of the night!"))

	// Wait for 2 minutes
	sleep(0.5 MINUTES)

	// End the trade
	end_talk_trade(session)

	// Mark action as truly complete
	completed = TRUE
	return TRUE

/datum/villains_action/talk_trade/proc/end_talk_trade(datum/villains_trade_session/session)
	if(session)
		session.end_session()

	// Clear trading status
	if(istype(performer, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/P = performer
		P.trading_with = null
		if(P.assigned_room)
			P.assigned_room.teleport_owner_to_room()

	if(istype(target, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/T = target
		T.trading_with = null

	to_chat(performer, span_notice("Your talk and trade session with [target] has ended."))
	to_chat(target, span_notice("Your talk and trade session with [performer] has ended."))

/datum/villains_action/eliminate
	name = "Eliminate"
	action_type = VILLAIN_ACTION_ELIMINATION
	action_cost = VILLAIN_ACTION_MAIN

/datum/villains_action/eliminate/can_perform()
	if(!..())
		return FALSE
	// Only villain can eliminate
	if(game.current_villain != performer)
		to_chat(performer, span_warning("Only the villain can eliminate!"))
		return FALSE
	return TRUE

/datum/villains_action/eliminate/perform()
	if(!..())
		return FALSE
	if(!target)
		to_chat(performer, span_warning("Invalid target for elimination!"))
		return FALSE

	// Check if target is a villains character
	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target

	// Check for protection
	if(SEND_SIGNAL(T, COMSIG_VILLAIN_ELIMINATION) & VILLAIN_PREVENT_ELIMINATION)
		to_chat(performer, span_warning("Your action failed to execute."))
		return FALSE

	// Perform elimination
	to_chat(performer, span_userdanger("You have eliminated [target]!"))
	to_chat(target, span_userdanger("You have been eliminated!"))

	// Actually kill the target
	T.death()

	return TRUE

/datum/villains_action/use_item
	name = "Use Item"
	var/obj/item/villains/used_item

/datum/villains_action/use_item/New(mob/living/user, mob/living/target_mob, datum/villains_controller/controller, obj/item/villains/item)
	..()
	used_item = item
	if(item)
		name = "Use [item.name]"
		action_type = item.action_type
		action_cost = item.action_cost

/datum/villains_action/use_item/perform()
	if(!..())
		return FALSE
	if(!used_item)
		log_game("VILLAINS DEBUG: use_item action has no item!")
		return FALSE

	log_game("VILLAINS DEBUG: Performing use_item action with [used_item.name] (priority [priority])")
	return used_item.use_item(performer, target, game)

/datum/villains_action/character_ability
	name = "Character Ability"
	var/datum/villains_character/character

/datum/villains_action/character_ability/New(mob/living/user, mob/living/target_mob, datum/villains_controller/controller, datum/villains_character/char)
	..()
	character = char
	if(char)
		name = char.active_ability_name
		action_type = char.active_ability_type
		action_cost = char.active_ability_cost

/datum/villains_action/character_ability/perform()
	if(!..())
		return FALSE
	if(!character)
		return FALSE

	return character.perform_active_ability(performer, target, game)

// Action queue manager
/datum/villains_action_queue
	var/list/actions = list()
	var/datum/villains_controller/game

/datum/villains_action_queue/New(datum/villains_controller/controller)
	game = controller

/datum/villains_action_queue/proc/add_action(datum/villains_action/action)
	actions += action

/datum/villains_action_queue/proc/process_actions()
	// Sort actions by priority
	var/list/sorted_actions = list()
	for(var/priority in 1 to 6) // Include VILLAIN_ACTION_PRIORITY_LOW (6)
		for(var/datum/villains_action/A in actions)
			if(A.get_priority() == priority)
				sorted_actions += A

	// Check for elimination conflicts (villain vs Der Freischütz)
	var/list/elimination_actions = list()
	for(var/datum/villains_action/A in sorted_actions)
		if(A.action_type == VILLAIN_ACTION_ELIMINATION)
			elimination_actions += A
	
	// If both villain and Der Freischütz are trying to eliminate someone
	if(length(elimination_actions) >= 2)
		var/has_villain_elimination = FALSE
		var/has_magic_bullet = FALSE
		
		for(var/datum/villains_action/A in elimination_actions)
			if(istype(A, /datum/villains_action/eliminate))
				has_villain_elimination = TRUE
			else if(istype(A, /datum/villains_action/character_ability))
				var/datum/villains_action/character_ability/CA = A
				if(CA.character?.character_id == VILLAIN_CHAR_DERFREISCHUTZ)
					has_magic_bullet = TRUE
		
		// If both exist, cancel the Magic Bullet
		if(has_villain_elimination && has_magic_bullet)
			for(var/datum/villains_action/A in elimination_actions)
				if(istype(A, /datum/villains_action/character_ability))
					var/datum/villains_action/character_ability/CA = A
					if(CA.character?.character_id == VILLAIN_CHAR_DERFREISCHUTZ)
						CA.prevented = TRUE
						to_chat(CA.performer, span_warning("Your Magic Bullet fails - the villain's elimination takes priority!"))

	// Process actions in order with delays
	for(var/datum/villains_action/A in sorted_actions)
		log_game("VILLAINS DEBUG: Processing action [A.type] with priority [A.get_priority()] by [A.performer ? A.performer.name : "Unknown"]")
		// Start the action
		spawn(0)
			A.perform()

		// Wait for action to complete
		while(!A.completed)
			sleep(1 SECONDS)

		// Add delay between actions
		sleep(5 SECONDS)

	// Clear the queue
	actions.Cut()


// UI object for trade session
/obj/villains_trade_ui_object
	name = "Trade Session"
	var/datum/villains_trade_session/parent_session

/obj/villains_trade_ui_object/ui_interact(mob/user)
	. = ..()

/obj/villains_trade_ui_object/ui_data(mob/user)
	if(parent_session)
		return parent_session.get_ui_data(user)
	return list()

/obj/villains_trade_ui_object/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(parent_session)
		return parent_session.handle_ui_act(action, params, usr)

// Trading session system
/datum/villains_trade_session
	var/mob/living/simple_animal/hostile/villains_character/trader1
	var/mob/living/simple_animal/hostile/villains_character/trader2
	var/active = TRUE
	var/list/trader1_offer = list() // List of item refs being offered by trader1
	var/list/trader2_offer = list() // List of item refs being offered by trader2
	var/trader1_ready = FALSE
	var/trader2_ready = FALSE
	var/trade_complete = FALSE
	var/start_time
	var/list/obj/ui_objects = list()

/datum/villains_trade_session/New(mob/living/simple_animal/hostile/villains_character/T1, mob/living/simple_animal/hostile/villains_character/T2)
	trader1 = T1
	trader2 = T2
	start_time = world.time
	
	// Set the session reference on both traders
	trader1.active_trade_session = src
	trader2.active_trade_session = src
	
	// Open UI for both traders
	open_ui_for_trader(trader1)
	open_ui_for_trader(trader2)

/datum/villains_trade_session/proc/end_session()
	active = FALSE
	
	// Clear session references
	if(trader1)
		trader1.active_trade_session = null
	if(trader2)
		trader2.active_trade_session = null
		
	// Close UIs
	for(var/obj/O in ui_objects)
		SStgui.close_uis(O)
		qdel(O)
	ui_objects.Cut()
	
	to_chat(trader1, span_notice("Trading session ended."))
	to_chat(trader2, span_notice("Trading session ended."))

/datum/villains_trade_session/proc/open_ui_for_trader(mob/user)
	var/obj/villains_trade_ui_object/ui_object = new()
	ui_object.parent_session = src
	ui_objects += ui_object
	
	var/datum/tgui/ui = SStgui.try_update_ui(user, ui_object, "VillainsTradeUI")
	if(!ui)
		ui = new(user, ui_object, "VillainsTradeUI", "Trade Session")
		ui.open()

/datum/villains_trade_session/proc/get_ui_data(mob/user)
	var/list/data = list()
	
	var/is_trader1 = (user == trader1)
	var/mob/living/simple_animal/hostile/villains_character/me = is_trader1 ? trader1 : trader2
	var/mob/living/simple_animal/hostile/villains_character/partner = is_trader1 ? trader2 : trader1
	
	data["my_name"] = me.name
	data["partner_name"] = partner.name
	data["time_remaining"] = max(0, 120 - ((world.time - start_time) / 10))
	data["trade_complete"] = trade_complete
	
	// My inventory
	var/list/my_inv = list()
	for(var/obj/item/villains/I in me.contents)
		var/rarity_color = "white"
		switch(I.rarity)
			if(VILLAIN_ITEM_COMMON)
				rarity_color = "gray"
			if(VILLAIN_ITEM_UNCOMMON)
				rarity_color = "yellow"
			if(VILLAIN_ITEM_RARE)
				rarity_color = "orange"
		
		my_inv += list(list(
			"name" = I.name,
			"desc" = I.desc,
			"ref" = REF(I),
			"rarity_color" = rarity_color
		))
	data["my_inventory"] = my_inv
	
	// Partner inventory
	var/list/partner_inv = list()
	for(var/obj/item/villains/I in partner.contents)
		var/rarity_color = "white"
		switch(I.rarity)
			if(VILLAIN_ITEM_COMMON)
				rarity_color = "gray"
			if(VILLAIN_ITEM_UNCOMMON)
				rarity_color = "yellow"
			if(VILLAIN_ITEM_RARE)
				rarity_color = "orange"
				
		partner_inv += list(list(
			"name" = I.name,
			"desc" = I.desc,
			"ref" = REF(I),
			"rarity_color" = rarity_color
		))
	data["partner_inventory"] = partner_inv
	
	// Offers
	data["my_offer"] = is_trader1 ? trader1_offer : trader2_offer
	data["partner_offer"] = is_trader1 ? trader2_offer : trader1_offer
	data["my_ready"] = is_trader1 ? trader1_ready : trader2_ready
	data["partner_ready"] = is_trader1 ? trader2_ready : trader1_ready
	
	return data

/datum/villains_trade_session/proc/handle_ui_act(action, params, mob/user)
	if(!active)
		return FALSE
		
	var/is_trader1 = (user == trader1)
	
	switch(action)
		if("offer_item")
			var/item_ref = params["item_ref"]
			var/obj/item/villains/I = locate(item_ref)
			if(!I || I.loc != user)
				return FALSE
				
			if(is_trader1)
				if(!(item_ref in trader1_offer))
					trader1_offer += item_ref
					trader1_ready = FALSE
					trader2_ready = FALSE
			else
				if(!(item_ref in trader2_offer))
					trader2_offer += item_ref
					trader1_ready = FALSE
					trader2_ready = FALSE
			return TRUE
			
		if("remove_offer")
			var/item_ref = params["item_ref"]
			if(is_trader1)
				trader1_offer -= item_ref
				trader1_ready = FALSE
				trader2_ready = FALSE
			else
				trader2_offer -= item_ref
				trader1_ready = FALSE
				trader2_ready = FALSE
			return TRUE
			
		if("toggle_ready")
			if(is_trader1)
				trader1_ready = !trader1_ready
			else
				trader2_ready = !trader2_ready
			return TRUE
			
		if("confirm_trade")
			if(trader1_ready && trader2_ready)
				execute_trade()
			return TRUE
			
		if("cancel_trade")
			end_session()
			return TRUE
			
	return FALSE

/datum/villains_trade_session/proc/execute_trade()
	if(!trader1_ready || !trader2_ready || trade_complete)
		return
		
	trade_complete = TRUE
	
	// Record the trade before executing
	if(GLOB.villains_game)
		GLOB.villains_game.record_trade(trader1, trader2, trader1_offer, trader2_offer)
	
	// Transfer items from trader1 to trader2
	for(var/item_ref in trader1_offer)
		var/obj/item/villains/I = locate(item_ref)
		if(I && I.loc == trader1)
			// Handle fresh items
			if(I.freshness == VILLAIN_ITEM_FRESH && (I in trader1.fresh_items))
				trader1.fresh_items -= I
			I.forceMove(trader2)
			to_chat(trader2, span_notice("You receive [I] from [trader1]."))
	
	// Transfer items from trader2 to trader1
	for(var/item_ref in trader2_offer)
		var/obj/item/villains/I = locate(item_ref)
		if(I && I.loc == trader2)
			// Handle fresh items
			if(I.freshness == VILLAIN_ITEM_FRESH && (I in trader2.fresh_items))
				trader2.fresh_items -= I
			I.forceMove(trader1)
			to_chat(trader1, span_notice("You receive [I] from [trader2]."))
	
	to_chat(trader1, span_boldnotice("Trade complete!"))
	to_chat(trader2, span_boldnotice("Trade complete!"))
	
	// End the session after a short delay
	addtimer(CALLBACK(src, PROC_REF(end_session)), 3 SECONDS)

// Contract UI system
/datum/villains_contract_ui
	var/mob/living/simple_animal/hostile/villains_character/owner

/datum/villains_contract_ui/New(mob/living/simple_animal/hostile/villains_character/character)
	owner = character

/datum/villains_contract_ui/ui_interact(mob/user)
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, "VillainsContractUI")
	if(!ui)
		ui = new(user, src, "VillainsContractUI", "Contract Management")
		ui.open()

/datum/villains_contract_ui/ui_state(mob/user)
	return GLOB.always_state

/datum/villains_contract_ui/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/villains_contract_ui/ui_data(mob/user)
	var/list/data = list()
	
	data["character_name"] = owner.name
	data["can_offer_contract"] = (owner.character_data?.character_id == VILLAIN_CHAR_DERFREISCHUTZ)
	data["is_trading"] = (owner.trading_with != null)
	data["trading_partner"] = owner.trading_with?.name
	
	// Pending contracts
	var/list/pending = list()
	for(var/mob/living/simple_animal/hostile/villains_character/offerer in owner.pending_contracts)
		var/contract_type = owner.pending_contracts[offerer]
		var/type_display = "Unknown Contract"
		var/terms = "No terms specified"
		
		if(contract_type == "elimination")
			type_display = "Elimination Contract"
			terms = "You choose who [offerer] must eliminate with Magic Bullet"
		
		pending += list(list(
			"id" = REF(offerer),
			"offerer" = offerer.name,
			"type" = contract_type,
			"type_display" = type_display,
			"terms" = terms
		))
	data["pending_contracts"] = pending
	
	// Active contracts
	var/list/active = list()
	
	// Check if we have an elimination contract
	if(owner.character_data?.character_id == VILLAIN_CHAR_DERFREISCHUTZ && owner.elimination_contract)
		var/target_name = owner.contract_target ? owner.contract_target.name : "Unknown"
		active += list(list(
			"type" = "elimination",
			"type_display" = "Elimination Contract",
			"party1" = owner.name,
			"party2" = owner.elimination_contract.name,
			"terms" = "Must eliminate [target_name] with Magic Bullet",
			"active" = TRUE
		))
	
	// Check if someone has a contract on us
	for(var/mob/living/simple_animal/hostile/villains_character/player in GLOB.villains_game?.living_players)
		if(player.elimination_contract == owner)
			var/target_name = player.contract_target ? player.contract_target.name : "Unknown"
			active += list(list(
				"type" = "elimination",
				"type_display" = "Elimination Contract (Contract Holder)",
				"party1" = player.name,
				"party2" = owner.name,
				"terms" = "[player.name] must eliminate [target_name] with Magic Bullet",
				"active" = TRUE
			))
		// Check if we're the target of someone's contract
		if(player.contract_target == owner)
			active += list(list(
				"type" = "elimination",
				"type_display" = "Elimination Contract (Target)",
				"party1" = player.name,
				"party2" = player.elimination_contract ? player.elimination_contract.name : "Unknown",
				"terms" = "[player.name] will eliminate you with Magic Bullet!",
				"active" = TRUE
			))
	
	data["active_contracts"] = active
	
	// Get living players for target selection (elimination contracts)
	var/list/living = list()
	if(GLOB.villains_game?.living_players)
		for(var/mob/living/simple_animal/hostile/villains_character/player in GLOB.villains_game.living_players)
			if(player != owner && player != owner.trading_with) // Can't target self or Der Freischütz
				living += list(list(
					"ref" = REF(player),
					"name" = player.name
				))
	data["living_players"] = living
	
	return data

/datum/villains_contract_ui/ui_act(action, params)
	. = ..()
	if(.)
		return
	
	switch(action)
		if("accept_contract")
			var/offerer_ref = params["contract_id"]
			var/mob/living/simple_animal/hostile/villains_character/offerer = locate(offerer_ref)
			if(!offerer || !(offerer in owner.pending_contracts))
				return FALSE
			
			var/contract_type = owner.pending_contracts[offerer]
			if(contract_type == "elimination")
				// Get the selected target
				var/target_ref = params["target"]
				if(!target_ref)
					to_chat(owner, span_warning("You must select a target for the elimination!"))
					return FALSE
				
				var/mob/living/simple_animal/hostile/villains_character/target = locate(target_ref)
				if(!target || !istype(target) || target == owner || target == offerer)
					to_chat(owner, span_warning("Invalid target selected!"))
					return FALSE
				
				// Set up the contract
				offerer.elimination_contract = owner
				offerer.contract_target = target
				
				to_chat(offerer, span_boldnotice("[owner] accepts your Elimination Contract! You must eliminate [target.name] with Magic Bullet!"))
				to_chat(owner, span_boldwarning("You accept [offerer]'s Elimination Contract. They must eliminate [target.name]!"))
				
				// Record contract acceptance
				if(GLOB.villains_game)
					GLOB.villains_game.record_contract(offerer, owner, "elimination", "accepted")
			
			owner.pending_contracts -= offerer
			return TRUE
			
		if("decline_contract")
			var/offerer_ref = params["contract_id"]
			var/mob/living/simple_animal/hostile/villains_character/offerer = locate(offerer_ref)
			if(!offerer || !(offerer in owner.pending_contracts))
				return FALSE
			
			var/contract_type = owner.pending_contracts[offerer]
			to_chat(offerer, span_warning("[owner] declines your [contract_type] contract."))
			to_chat(owner, span_notice("You decline [offerer]'s [contract_type] contract."))
			
			// Record contract rejection
			if(GLOB.villains_game)
				GLOB.villains_game.record_contract(offerer, owner, contract_type, "declined")
			
			owner.pending_contracts -= offerer
			return TRUE
			
		if("offer_elimination_contract")
			if(owner.character_data?.character_id != VILLAIN_CHAR_DERFREISCHUTZ)
				return FALSE
			
			if(!owner.trading_with)
				to_chat(owner, span_warning("You must be trading with someone to offer a contract!"))
				return FALSE
			
			if(owner.elimination_contract)
				to_chat(owner, span_warning("You already have an active elimination contract with [owner.elimination_contract]!"))
				return FALSE
			
			owner.trading_with.pending_contracts[owner] = "elimination"
			to_chat(owner, span_notice("You offer an Elimination Contract to [owner.trading_with]."))
			to_chat(owner.trading_with, span_boldwarning("[owner] offers you an Elimination Contract! Use the Contract Management to review."))
			
			// Update the UI for the trading partner if they have it open
			SStgui.update_uis(src)
			
			return TRUE
