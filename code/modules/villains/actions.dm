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
	if(!performer || !performer.client)
		return FALSE
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
		return FALSE

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
	for(var/priority in 1 to 5)
		for(var/datum/villains_action/A in actions)
			if(A.get_priority() == priority)
				sorted_actions += A

	// Process actions in order with delays
	for(var/datum/villains_action/A in sorted_actions)
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


// Trading session system
/datum/villains_trade_session
	var/mob/living/simple_animal/hostile/villains_character/trader1
	var/mob/living/simple_animal/hostile/villains_character/trader2
	var/active = TRUE

/datum/villains_trade_session/New(mob/living/simple_animal/hostile/villains_character/T1, mob/living/simple_animal/hostile/villains_character/T2)
	trader1 = T1
	trader2 = T2
	to_chat(trader1, span_notice("You can now trade items with [trader2]. Use 'Give Item' verb to offer items."))
	to_chat(trader2, span_notice("You can now trade items with [trader1]. Use 'Give Item' verb to offer items."))

/datum/villains_trade_session/proc/end_session()
	active = FALSE
	to_chat(trader1, span_notice("Trading session ended."))
	to_chat(trader2, span_notice("Trading session ended."))
