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

/datum/villains_action/New(mob/living/user, mob/living/target_mob, datum/villains_controller/controller)
	performer = user
	target = target_mob
	game = controller

/datum/villains_action/proc/can_perform()
	if(!performer || !performer.client)
		return FALSE
	if(prevented)
		return FALSE
	if(SEND_SIGNAL(performer, COMSIG_VILLAIN_ACTION_PERFORMED, src) & VILLAIN_PREVENT_ACTION)
		prevented = TRUE
		return FALSE
	return TRUE

/datum/villains_action/proc/perform()
	if(!can_perform())
		return FALSE
	completed = TRUE
	return TRUE

/datum/villains_action/proc/get_priority()
	return action_type

// Base action types

/datum/villains_action/talk_trade
	name = "Talk and Trade"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_MAIN

/datum/villains_action/talk_trade/perform()
	if(!..())
		return FALSE
	if(!target)
		to_chat(performer, span_warning("Invalid target for Talk and Trade!"))
		return FALSE
	
	// TODO: Implement talk/trade UI
	to_chat(performer, span_notice("You visit [target] to talk and trade..."))
	to_chat(target, span_notice("[performer] visits you to talk and trade..."))
	
	// Give them 2 minutes to interact
	addtimer(CALLBACK(src, .proc/end_talk_trade), 2 MINUTES)
	return TRUE

/datum/villains_action/talk_trade/proc/end_talk_trade()
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
	
	// Check for protection
	if(SEND_SIGNAL(target, COMSIG_VILLAIN_ELIMINATION) & VILLAIN_PREVENT_ELIMINATION)
		to_chat(performer, span_warning("Your elimination attempt was prevented!"))
		return FALSE
	
	// Perform elimination
	game.last_eliminated = target
	game.living_players -= target
	game.dead_players += target
	
	to_chat(performer, span_userdanger("You have eliminated [target]!"))
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
		A.perform()
		sleep(5 SECONDS)
	
	// Clear the queue
	actions.Cut()

// Helper procs for the controller
/datum/villains_controller/proc/submit_action(mob/living/user, action_type, mob/living/target, obj/item/villains/item = null)
	if(current_phase != VILLAIN_PHASE_EVENING)
		to_chat(user, span_warning("You can only submit actions during the evening phase!"))
		return FALSE
	
	var/datum/villains_action/new_action
	
	switch(action_type)
		if("talk_trade")
			new_action = new /datum/villains_action/talk_trade(user, target, src)
		if("eliminate")
			new_action = new /datum/villains_action/eliminate(user, target, src)
		if("use_item")
			if(!item)
				return FALSE
			new_action = new /datum/villains_action/use_item(user, target, src, item)
		if("character_ability")
			var/datum/villains_character/char = player_role_lookup[user]
			if(!char)
				return FALSE
			new_action = new /datum/villains_action/character_ability(user, target, src, char)
	
	if(!new_action)
		return FALSE
	
	// TODO: Add to action queue
	to_chat(user, span_notice("Action submitted: [new_action.name] targeting [target ? target : "yourself"]"))
	return TRUE