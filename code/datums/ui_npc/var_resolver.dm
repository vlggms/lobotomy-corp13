// Variable Resolver Interface
// This system allows accessing variables from different scopes with dot notation
// Examples: player.health, world.quest_complete, dialog.has_seen_intro

// Variable Scope Resolver
/datum/var_resolver
	var/name = "base"  // Scope name (e.g., "player", "world", "dialog")

// Get a variable value from this scope
// Returns: The value, or null if not found
/datum/var_resolver/proc/get_var(var_name)
	return null

// Set a variable value in this scope
// Returns: TRUE if successful, FALSE otherwise
/datum/var_resolver/proc/set_var(var_name, value)
		return FALSE

// Check if a variable exists in this scope
/datum/var_resolver/proc/has_var(var_name)
	return FALSE

// Manager for multiple variable resolvers
/datum/var_resolver_manager
	var/list/resolvers = list()

// Register a resolver for a specific scope
/datum/var_resolver_manager/proc/register_resolver(scope_name, datum/var_resolver/resolver)
	resolvers[scope_name] = resolver
	return TRUE

// Unregister a resolver
/datum/var_resolver_manager/proc/unregister_resolver(scope_name)
	if(scope_name in resolvers)
		resolvers -= scope_name
		return TRUE
	return FALSE

// Get a variable from any scope using dot notation
// Format: "scope.variable" (e.g., "player.health")
/datum/var_resolver_manager/proc/get_var(var_path)
	var/list/path_parts = splittext(var_path, ".")

	if(path_parts.len < 2)
		// No scope specified, return null
		return null

	var/scope = path_parts[1]
	var/var_name = path_parts[2]

	// For deeper paths (e.g., player.inventory.sword)
	if(path_parts.len > 2)
		var/remaining_path = ""
		for(var/i = 3; i <= path_parts.len; i++)
			remaining_path += path_parts[i]
			if(i < path_parts.len)
				remaining_path += "."
		var_name = var_name + "." + remaining_path

	// Look up the resolver for this scope
	var/datum/var_resolver/resolver = resolvers[scope]
	if(!resolver)
		return null

	return resolver.get_var(var_name)

// Set a variable in a specific scope using dot notation
/datum/var_resolver_manager/proc/set_var(var_path, value)
	var/list/path_parts = splittext(var_path, ".")

	if(path_parts.len < 2)
		// No scope specified, can't set
		return FALSE

	var/scope = path_parts[1]
	var/var_name = path_parts[2]

	// For deeper paths (e.g., player.inventory.sword)
	if(path_parts.len > 2)
		var/remaining_path = ""
		for(var/i = 3; i <= path_parts.len; i++)
			remaining_path += path_parts[i]
			if(i < path_parts.len)
				remaining_path += "."
		var_name = var_name + "." + remaining_path

	// Look up the resolver for this scope
	var/datum/var_resolver/resolver = resolvers[scope]
	if(!resolver)
		return FALSE

	return resolver.set_var(var_name, value)

// Check if a variable exists in any scope using dot notation
/datum/var_resolver_manager/proc/has_var(var_path)
	var/list/path_parts = splittext(var_path, ".")

	if(path_parts.len < 2)
		// No scope specified
		return FALSE

	var/scope = path_parts[1]
	var/var_name = path_parts[2]

	// For deeper paths (e.g., player.inventory.sword)
	if(path_parts.len > 2)
		var/remaining_path = ""
		for(var/i = 3; i <= path_parts.len; i++)
			remaining_path += path_parts[i]
			if(i < path_parts.len)
				remaining_path += "."
		var_name = var_name + "." + remaining_path

	// Look up the resolver for this scope
	var/datum/var_resolver/resolver = resolvers[scope]
	if(!resolver)
		return FALSE

	return resolver.has_var(var_name)

// Default fallback for variables not in any scope
/datum/var_resolver_manager/proc/get_default_value(var_path)
	return 0  // Default to 0 for undefined variables


// Implementation of common variable resolvers

// Corrected dictionary variable resolver
/datum/var_resolver/dictionary
	var/list/variables = list()

/datum/var_resolver/dictionary/New(list/initial_vars = null)
	if(islist(initial_vars))
		variables = initial_vars.Copy()

/datum/var_resolver/dictionary/get_var(var_name)
	// Check first if this is a nested path
	var/list/path_parts = splittext(var_name, ".")
	if(path_parts.len > 1)
		// Start with the first part of the path
		var/first_part = path_parts[1]
		if(!(first_part in variables))
			return null  // First segment doesn't exist

		var/current = variables[first_part]

		// Navigate through the rest of the path
		for(var/i = 2; i <= path_parts.len; i++)
			var/part = path_parts[i]

			// If current is not a list or doesn't contain this key, return null
			if(!islist(current) || !(part in current))
				return null

			// Get value at this level
			current = current[part]

			// If we're at the last part, return the value
			if(i == path_parts.len)
				return current

		// Should never reach here if path_parts.len > 1
		return null

	// Simple case: direct variable lookup
	if(var_name in variables)
		return variables[var_name]

	return null

/datum/var_resolver/dictionary/set_var(var_name, value)
	// Handle nested paths
	var/list/path_parts = splittext(var_name, ".")
	if(path_parts.len > 1)
		var/first_part = path_parts[1]

		// Make sure the first container exists
		if(!(first_part in variables))
			variables[first_part] = list()

		var/list/current = variables[first_part]

		// Navigate to the parent of the final property
		for(var/i = 2; i < path_parts.len; i++)
			var/part = path_parts[i]

			// Create intermediate containers if needed
			if(!islist(current) || !(part in current))
				current[part] = list()

			current = current[part]

		// Set the final value
		current[path_parts[path_parts.len]] = value
		return TRUE

	// Simple case: direct assignment
	variables[var_name] = value
	return TRUE

/datum/var_resolver/dictionary/has_var(var_name)
	// Check if this is a nested path
	var/list/path_parts = splittext(var_name, ".")
	if(path_parts.len > 1)
		// Start with the first part of the path
		var/first_part = path_parts[1]
		if(!(first_part in variables))
			return FALSE  // First segment doesn't exist

		var/current = variables[first_part]

		// Navigate through the rest of the path
		for(var/i = 2; i <= path_parts.len; i++)
			var/part = path_parts[i]

			// If current is not a list or doesn't contain this key, return false
			if(!islist(current) || !(part in current))
				return FALSE

			// If we're at the last part, we've confirmed it exists
			if(i == path_parts.len)
				return TRUE

			// Continue to next part
			current = current[part]

		// Should never reach here if path_parts.len > 1
		return FALSE

	// Simple case: direct variable check
	return (var_name in variables)

// Enhanced Universal Player Resolver
// Automatically resolves variables based on mob member variables
// Also supports storing custom variables in a dictionary
/datum/var_resolver/player
	var/mob/living/carbon/human/player_mob = null
	var/datum/var_resolver/dictionary/custom_vars = null  // Dictionary for custom variables
	var/list/cached_values = list()  // Optional cache for expensive operations

/datum/var_resolver/player/New(mob/living/carbon/human/M)
	player_mob = M
	custom_vars = new()  // Initialize the dictionary resolver for custom variables

// Get variable through direct member variable access or from custom vars
/datum/var_resolver/player/get_var(var_name)
	if(!player_mob)
		return null

	// Check for nested paths (e.g., "inventory.sword")
	var/list/path_parts = splittext(var_name, ".")

	// Handle special cases and categories first
	if(path_parts.len > 1)
		var/category = path_parts[1]
		var/property = path_parts[2]

		// Handle inventory-related variables
		if(category == "inventory")
			return get_inventory_var(property, path_parts)

		// Handle stats-related variables
		else if(category == "stats")
			return get_stats_var(property, path_parts)

		// Handle faction-related variables
		else if(category == "faction")
			return get_faction_var(property, path_parts)

		// Other categories can be added as needed

	if (var_name == "money")
		return get_money()

	if (var_name == "area")
		return get_player_area()

	// First check if it's a custom variable in our dictionary
	var/custom_value = custom_vars.get_var(var_name)
	if(!isnull(custom_value))
		return custom_value

	// If not found in custom vars, check if it exists directly on the player mob
	if(var_name in player_mob.vars)
		return player_mob.vars[var_name]

	return null

// Set a variable on the player mob or in custom vars
/datum/var_resolver/player/set_var(var_name, value)
	if(!player_mob)
		return FALSE

	// Check for nested paths
	var/list/path_parts = splittext(var_name, ".")

	if(path_parts.len > 1)
		var/category = path_parts[1]
		var/property = path_parts[2]

		// Handle inventory-related variables
		if(category == "inventory")
			return set_inventory_var(property, value, path_parts)

		// Handle other categories as needed

	// Direct variable setting
	// First, let's always try to store it in our custom vars dictionary
	return custom_vars.set_var(var_name, value)

	/*
	// If we wanted to set some variables directly on the mob, we could do:
	// Only set certain safe variables on the actual mob
	switch(var_name)
		if("gold", "money", "currency")
			// Example of safe variable to modify
			if(var_name in player_mob.vars)
				player_mob.vars[var_name] = value
				return TRUE
		// Add more safe variables as needed
	*/

// Check if a variable exists
/datum/var_resolver/player/has_var(var_name)
	if(!player_mob)
		return FALSE

	// Check for nested paths
	var/list/path_parts = splittext(var_name, ".")

	if(path_parts.len > 1)
		var/category = path_parts[1]
		//var/property = path_parts[2]

		// Handle known categories
		switch(category)
			if("inventory", "stats", "faction")
				return TRUE  // We know these categories exist

		// For unknown categories, check in custom vars
		return custom_vars.has_var(var_name)

	if(var_name == "money" || var_name == "area")
		return TRUE

	// Direct check for non-nested paths
	// First check custom vars
	if(custom_vars.has_var(var_name))
		return TRUE

	// Then check if the variable exists directly on the player mob
	return (var_name in player_mob.vars)

/datum/var_resolver/player/proc/get_money()
	var/obj/item/card/id/C = player_mob.get_idcard(TRUE)
	if(!C)
		return 0
	else if(!C.registered_account)
		return 0

	var/datum/bank_account/account = C.registered_account
	return account.account_balance

/datum/var_resolver/player/proc/get_player_area()
	var/area/A = get_area(player_mob)
	return A.name

// The rest of the code remains the same as the original
// (get_inventory_var, set_inventory_var, get_stats_var, etc.)
// Handle inventory-related variables
/datum/var_resolver/player/proc/get_inventory_var(item_name, list/path_parts)
	// This would need to be customized based on your inventory system

	// Example for checking if player has an item
	if(has_item(item_name))
		return TRUE

	// Example for checking item count
	if(path_parts.len > 2 && path_parts[3] == "count")
		return get_item_count(item_name)

	return 0

// Set inventory-related variables
/datum/var_resolver/player/proc/set_inventory_var(item_name, value, list/path_parts)
	// This would need to be customized based on your inventory system

	if(isnum(value) && value > 0)
		// Example of adding items
		give_item(item_name, value)
		return TRUE
	else if(value == FALSE || (isnum(value) && value <= 0))
		// Example of removing items
		remove_item(item_name, abs(value))
		return TRUE

	return FALSE

// Handle stats-related variables
/datum/var_resolver/player/proc/get_stats_var(stat_name, list/path_parts)
	// This would need to be customized based on your stats system

	//if(istype(player_mob, /mob/living/carbon/human))
		//var/mob/living/carbon/human/H = player_mob

		// Example mapping to standard stats
		// switch(stat_name)
		// 	if("strength")
		// 		return H.physique || H.strength || 10
		// 	if("intelligence")
		// 		return H.intelligence || H.int || 10
		// 	if("dexterity")
		// 		return H.dexterity || H.dex || 10
			// Add more stat mappings as needed

	return 0

// Handle faction-related variables
/datum/var_resolver/player/proc/get_faction_var(faction_name, list/path_parts)
	// This would need to be customized based on your faction system

	// Example of checking faction membership
	if(is_faction_member(faction_name))
		return TRUE

	// Example of getting faction reputation
	if(path_parts.len > 2 && path_parts[3] == "reputation")
		return get_faction_reputation(faction_name)

	return 0

// Helper to check if player has an item
// Customize based on your inventory system
/datum/var_resolver/player/proc/has_item(item_name)
	if(!player_mob)
		return FALSE

	// Example implementation - customize for your system
	for(var/obj/item/I in player_mob.contents)
		if(I.name == item_name || I.type == text2path("/obj/item/[item_name]"))
			return TRUE

	return FALSE

// Helper to get item count
/datum/var_resolver/player/proc/get_item_count(item_name)
	if(!player_mob)
		return 0

	var/count = 0

	// Example implementation - customize for your system
	for(var/obj/item/I in player_mob.contents)
		if(I.name == item_name || I.type == text2path("/obj/item/[item_name]"))
			count++

	return count

// Helper to give items
/datum/var_resolver/player/proc/give_item(item_name, amount = 1)
	if(!player_mob)
		return FALSE

	// Example implementation - customize for your system
	var/item_path = text2path("/obj/item/[item_name]")
	if(!item_path)
		return FALSE

	for(var/i = 1 to amount)
		var/obj/item/I = new item_path(player_mob)
		player_mob.put_in_hands(I)

	return TRUE

// Helper to remove items
/datum/var_resolver/player/proc/remove_item(item_name, amount = 1)
	if(!player_mob)
		return FALSE

	var/removed = 0

	// Example implementation - customize for your system
	for(var/obj/item/I in player_mob.contents)
		if((I.name == item_name || I.type == text2path("/obj/item/[item_name]")) && removed < amount)
			qdel(I)
			removed++

	return removed > 0

// Faction helpers - customize based on your faction system
/datum/var_resolver/player/proc/is_faction_member(faction_name)
	if(!player_mob)
		return FALSE

	// Example implementation - customize for your system
	if(player_mob.faction)
		return (faction_name in player_mob.faction)

	return FALSE

/datum/var_resolver/player/proc/get_faction_reputation(faction_name)
	if(!player_mob)
		return 0

	// Example implementation - customize for your system
	// if(player_mob.faction_reputation && (faction_name in player_mob.faction_reputation))
	// 	return player_mob.faction_reputation[faction_name]

	return 0

// World/Game state resolver
/datum/var_resolver/world_state
	var/list/quest_flags = list()
	var/list/world_flags = list()
	var/list/time_data = list()

/datum/var_resolver/world_state/New()
	// Initialize with some default values
	time_data["day"] = 1
	time_data["hour"] = 12
	time_data["is_daytime"] = TRUE

/datum/var_resolver/world_state/get_var(var_name)
	// Handle common categories with dot notation
	if(findtext(var_name, "quest."))
		var/quest_name = copytext(var_name, 7)  // After "quest."
		return quest_flags[quest_name]

	if(findtext(var_name, "time."))
		var/time_var = copytext(var_name, 6)  // After "time."
		return time_data[time_var]

	// Direct world flags
	return world_flags[var_name]

/datum/var_resolver/world_state/set_var(var_name, value)
	if(findtext(var_name, "quest."))
		var/quest_name = copytext(var_name, 7)  // After "quest."
		quest_flags[quest_name] = value
		return TRUE

	if(findtext(var_name, "time."))
		var/time_var = copytext(var_name, 6)  // After "time."
		time_data[time_var] = value
		return TRUE

	// Direct world flags
	world_flags[var_name] = value
	return TRUE

/datum/var_resolver/world_state/has_var(var_name)
	if(findtext(var_name, "quest."))
		var/quest_name = copytext(var_name, 7)  // After "quest."
		return (quest_name in quest_flags)

	if(findtext(var_name, "time."))
		var/time_var = copytext(var_name, 6)  // After "time."
		return (time_var in time_data)

	// Direct world flags
	return (var_name in world_flags)

// Dialog state resolver - tracks conversation history
/datum/var_resolver/dialog
	var/list/topics_discussed = list()
	var/list/choices_made = list()
	var/list/dialog_flags = list()
	var/visit_count = 0

/datum/var_resolver/dialog/get_var(var_name)
	switch(var_name)
		if("visit_count")
			return visit_count
		if("is_first_visit")
			return (visit_count == 1)

	if(findtext(var_name, "discussed."))
		var/topic = copytext(var_name, 11)  // After "discussed."
		return (topic in topics_discussed) ? 1 : 0

	if(findtext(var_name, "choice."))
		var/choice = copytext(var_name, 8)  // After "choice."
		return choices_made[choice]

	// General dialog flags
	return dialog_flags[var_name]

/datum/var_resolver/dialog/set_var(var_name, value)
	switch(var_name)
		if("visit_count")
			visit_count = value
			return TRUE

	if(findtext(var_name, "discussed."))
		var/topic = copytext(var_name, 11)  // After "discussed."
		if(value)
			topics_discussed[topic] = 1
		else
			topics_discussed -= topic
		return TRUE

	if(findtext(var_name, "choice."))
		var/choice = copytext(var_name, 8)  // After "choice."
		choices_made[choice] = value
		return TRUE

	// General dialog flags
	dialog_flags[var_name] = value
	return TRUE

/datum/var_resolver/dialog/has_var(var_name)
	switch(var_name)
		if("visit_count", "is_first_visit")
			return TRUE

	if(findtext(var_name, "discussed."))
		var/topic = copytext(var_name, 11)  // After "discussed."
		return (topic in topics_discussed)

	if(findtext(var_name, "choice."))
		var/choice = copytext(var_name, 8)  // After "choice."
		return (choice in choices_made)

	// General dialog flags
	return (var_name in dialog_flags)

// Record that a topic was discussed
/datum/var_resolver/dialog/proc/mark_topic_discussed(topic)
	topics_discussed[topic] = 1

// Record a choice that was made
/datum/var_resolver/dialog/proc/record_choice(choice_id, choice_value)
	choices_made[choice_id] = choice_value

// Increment visit counter
/datum/var_resolver/dialog/proc/increment_visit()
	visit_count++
	return visit_count
