// Enhanced scene_manager with player-specific variable resolution
/datum/ui_npc/scene_manager
	var/list/datum/ui_npc/scene/scenes = list()
	var/list/datum/ui_npc/conversation_state/user_states = list()

	// Global variables shared across all conversations
	var/datum/var_resolver/dictionary/global_vars

	// NPC variables - specific to this NPC but shared across all conversations
	var/datum/var_resolver/dictionary/npc_vars

	// Per-player resolvers - stored by user reference
	var/list/player_resolvers = list()
	var/list/dialog_resolvers = list()

	var/list/var_managers = list()
	
	// Reference to the parent NPC mob
	var/mob/living/simple_animal/hostile/ui_npc/parent_npc

/datum/ui_npc/scene_manager/New()
	// Initialize global variables
	global_vars = new()
	var/datum/var_resolver_manager/global_manager = new()
	global_manager.register_resolver("world", global_vars)

	// Initialize NPC variables
	npc_vars = new()

/datum/ui_npc/scene_manager/proc/load_scenes(list/scene_data)
	for(var/scene_key in scene_data)
		scenes[scene_key] = new /datum/ui_npc/scene(scene_data[scene_key])


// Get or create a variable manager for a specific player
/datum/ui_npc/scene_manager/proc/get_var_manager(mob/user)
	if(!user)
		return null

	var/user_ref = "\ref[user]"

	// Return existing manager if we have one
	if(user_ref in var_managers)
		return var_managers[user_ref]

	// Create or get dialog resolver for this player
	var/datum/var_resolver/dictionary/dialog_resolver
	if(!(user_ref in dialog_resolvers))
		dialog_resolver = new()
		dialog_resolvers[user_ref] = dialog_resolver

		// Initialize dialog state
		dialog_resolver.variables["is_first_visit"] = TRUE
		dialog_resolver.variables["visit_count"] = 1
		dialog_resolver.variables["discussed"] = list()
	else
		dialog_resolver = dialog_resolvers[user_ref]

	// Create or get player resolver for this player
	var/datum/var_resolver/player/player_resolver
	if(!(user_ref in player_resolvers))
		player_resolver = new(user)
		player_resolvers[user_ref] = player_resolver
	else
		player_resolver = player_resolvers[user_ref]

	// Create a manager with all resolvers
	var/datum/var_resolver_manager/manager = new()
	manager.register_resolver("player", player_resolver)  // Player-specific variables
	manager.register_resolver("npc", npc_vars)            // NPC-specific variables
	manager.register_resolver("dialog", dialog_resolver)  // Conversation state
	manager.register_resolver("world", global_vars)       // Global game state

	// Cache the manager for future use
	var_managers[user_ref] = manager

	return manager

// Get a parser for a specific player
/datum/ui_npc/scene_manager/proc/get_parser(mob/user)
	var/datum/var_resolver_manager/manager = get_var_manager(user)
	if(!manager)
		return null

	return new /datum/scoped_expression_parser(manager)

// Enhanced get_user_state that tracks player-specific dialog state
/datum/ui_npc/scene_manager/proc/get_user_state(mob/user)
	if(!user)
		return null

	var/user_ref = "\ref[user]"
	if(!user_states[user_ref])
		var/datum/ui_npc/conversation_state/new_state = new()
		user_states[user_ref] = new_state

		// Initialize dialog state for this player
		var/datum/var_resolver/dictionary/dialog_resolver
		if(!(user_ref in dialog_resolvers))
			dialog_resolver = new()
			dialog_resolvers[user_ref] = dialog_resolver
			dialog_resolver.variables["is_first_visit"] = TRUE
			dialog_resolver.variables["visit_count"] = 1
		else
			dialog_resolver = dialog_resolvers[user_ref]
			dialog_resolver.variables["is_first_visit"] = FALSE
			dialog_resolver.variables["visit_count"]++

	return user_states[user_ref]

// Variable getters and setters that use player-specific context
/datum/ui_npc/scene_manager/proc/set_var(mob/user, var_path, value)
	var/datum/var_resolver_manager/manager = get_var_manager(user)
	if(!manager)
		return FALSE

	return manager.set_var(var_path, value)

/datum/ui_npc/scene_manager/proc/get_var(mob/user, var_path)
	var/datum/var_resolver_manager/manager = get_var_manager(user)
	if(!manager)
		return null

	return manager.get_var(var_path)

// Process text with variable substitution for a specific player
/datum/ui_npc/scene_manager/proc/process_text(mob/user, text)
	if(!text || !user)
		return text

	var/datum/scoped_expression_parser/parser = get_parser(user)
	if(!parser)
		return text

	var/datum/var_resolver_manager/manager = get_var_manager(user)

	// Replace {variable} references
	var/regex/var_regex = new(@"\{([^{}]+)\}", "g")
	var/processed = text

	while(var_regex.Find(processed))
		var/var_path = var_regex.group[1]
		var/value = manager.get_var(var_path)
		if(isnull(value)) value = ""
		processed = replacetext(processed, "{[var_path]}", "[value]")

	// Process conditional text [condition?true_text:false_text]
	var/regex/cond_regex = new(@"\[([^:\]]+)\?([^:]+):([^\]]+)\]", "g")

	while(cond_regex.Find(processed))
		var/condition = cond_regex.group[1]
		var/true_text = cond_regex.group[2]
		var/false_text = cond_regex.group[3]

		var/result = parser.eval_scoped_expression(condition)
		var/replacement = result ? true_text : false_text

		processed = replacetext(processed, cond_regex.match, replacement)

	return processed

// Evaluate conditions for a specific player
/datum/ui_npc/scene_manager/proc/evaluate_condition(mob/user, condition)
	if(!condition || condition == "" || !user)
		return TRUE

	var/datum/scoped_expression_parser/parser = get_parser(user)
	if(!parser)
		return TRUE

	return parser.eval_scoped_expression(condition)

// Process variable updates for a specific player
/datum/ui_npc/scene_manager/proc/process_var_updates(mob/user, list/updates)
	if(!islist(updates) || !user)
		return

	var/datum/var_resolver_manager/manager = get_var_manager(user)
	var/datum/scoped_expression_parser/parser = get_parser(user)

	if(!manager || !parser)
		return

	for(var/var_path in updates)
		var/value = updates[var_path]

		// Handle expression evaluation if value is in {} format
		if(istext(value) && length(value) >= 3 && copytext(value, 1, 2) == "{" && copytext(value, -1) == "}")
			var/expression = copytext(value, 2, -1)
			value = parser.eval_scoped_expression(expression)

		manager.set_var(var_path, value)

// Check if an action should be visible for a specific player
/datum/ui_npc/scene_manager/proc/is_action_visible(mob/user, datum/ui_npc/scene_action/action)
	if(!user || !action)
		return FALSE

	// Check the visibility expression if it exists
	if(action.visibility_expression && action.visibility_expression != "")
		return evaluate_condition(user, action.visibility_expression)

	// Check the visibility proc if it exists
	if(action.visible_proc)
		return action.visible_proc.Invoke()

	// Default to visible if no conditions specified
	return TRUE

// Check if an action should be enabled for a specific player
/datum/ui_npc/scene_manager/proc/is_action_enabled(mob/user, datum/ui_npc/scene_action/action)
	if(!user || !action)
		return FALSE

	// Check the enabled expression if it exists
	if(action.enabled_expression && action.enabled_expression != "")
		return evaluate_condition(user, action.enabled_expression)

	// Check the enabled proc if it exists
	if(action.enabled_proc)
		return action.enabled_proc.Invoke()

	// Default to enabled if no conditions specified
	return TRUE

// Execute an action's callbacks and variable updates
/datum/ui_npc/scene_manager/proc/execute_action(mob/user, datum/ui_npc/scene_action/action)
	if(!user || !action)
		return

	// Execute all proc callbacks
	for(var/datum/callback/callback in action.proc_callbacks)
		if(callback)
			callback.Invoke()

	// Process variable updates
	if(islist(action.var_updates) && action.var_updates.len)
		process_var_updates(user, action.var_updates)

	// Determine the next scene
	var/next_scene = action.get_next_scene(src, user)
	if(next_scene && next_scene != "")
		return navigate_to_scene(user, next_scene)

	return null

// Enhanced navigate with player-specific variable state tracking
/datum/ui_npc/scene_manager/proc/navigate_to_scene(mob/user, scene_id)
	var/datum/ui_npc/conversation_state/state = get_user_state(user)
	if(!state)
		return

	// Get the current scene before changing
	var/datum/ui_npc/scene/current_scene = null
	if(state.current_scene_id)
		current_scene = scenes[state.current_scene_id]

	// Process on_exit for the current scene if it exists
	if(current_scene && current_scene.on_exit && islist(current_scene.on_exit))
		process_var_updates(user, current_scene.on_exit)

	// Store current scene in history before changing
	if(state.current_scene_id)
		state.scene_history += state.current_scene_id
		set_var(user, "dialog.previous_scene", state.current_scene_id)

	// Update current scene
	state.current_scene_id = scene_id
	set_var(user, "dialog.current_scene", scene_id)

	var/datum/ui_npc/scene/new_scene = scenes[scene_id]

	// Process on_enter variable updates if they exist
	if(new_scene && new_scene.on_enter && islist(new_scene.on_enter))
		process_var_updates(user, new_scene.on_enter)

	// Trigger scene speaking if enabled
	if(parent_npc && new_scene && new_scene.text)
		var/processed_text = process_text(user, new_scene.text)
		parent_npc.speak_scene_text(processed_text)

	return new_scene

// Get the current scene object for a given user
/datum/ui_npc/scene_manager/proc/get_current_scene(mob/user)
	var/datum/ui_npc/conversation_state/state = get_user_state(user)
	if(!state || !state.current_scene_id)
		return null

	return scenes[state.current_scene_id]

// Get all visible actions for the current scene
/datum/ui_npc/scene_manager/proc/get_visible_actions(mob/user)
	var/datum/ui_npc/conversation_state/state = get_user_state(user)
	if(!state || !state.current_scene_id)
		return list()

	var/datum/ui_npc/scene/current_scene = scenes[state.current_scene_id]
	if(!current_scene)
		return list()

	var/list/visible_actions = list()
	for(var/action_key in current_scene.actions)
		var/datum/ui_npc/scene_action/action = current_scene.actions[action_key]
		if(is_action_visible(user, action))
			visible_actions[action_key] = action

	return visible_actions

// Clear dialog state for a player when they exit conversation
/datum/ui_npc/scene_manager/proc/clear_conversation(mob/user)
	if(!user)
		return

	var/user_ref = "\ref[user]"

	// Keep the dialog resolver but reset the state
	if(user_ref in dialog_resolvers)
		var/datum/var_resolver/dictionary/dialog_resolver = dialog_resolvers[user_ref]
		dialog_resolver.variables["current_scene"] = null
		// Keep visit count and tracking which topics were discussed

	// Don't clear the player resolver as it may be used by other NPCs

/datum/ui_npc/conversation_state
	var/current_scene_id = null
	var/list/scene_history = list()
	var/reputation = 0

