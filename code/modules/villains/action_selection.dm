// Action selection datum for Villains of the Night
/datum/villains_action_selection
	var/mob/living/simple_animal/hostile/villains_character/owner
	var/selected_main_action
	var/selected_main_target
	var/selected_secondary_action
	var/selected_secondary_target

/datum/villains_action_selection/New(mob/living/simple_animal/hostile/villains_character/character)
	owner = character

/datum/villains_action_selection/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VillainsSimpleActionSelection")
		ui.open()

/datum/villains_action_selection/ui_state(mob/user)
	return GLOB.always_state

/datum/villains_action_selection/ui_data(mob/user)
	var/list/data = list()

	if(!owner || !GLOB.villains_game)
		return data

	// Character info
	data["character_name"] = owner.name
	data["is_villain"] = owner.is_villain

	// Combine all available actions into one list
	var/list/available_actions = list()

	// Talk/Trade is always available
	available_actions += list(list(
		"id" = "talk_trade",
		"name" = "Talk/Trade",
		"type" = "typeless",
		"cost" = VILLAIN_ACTION_MAIN,
		"desc" = "Visit another player to talk and trade for 2 minutes"
	))

	// Character ability
	if(owner.character_data?.active_ability_name)
		var/ability_type = "typeless"
		switch(owner.character_data.active_ability_type)
			if(VILLAIN_ACTION_SUPPRESSIVE)
				ability_type = "suppressive"
			if(VILLAIN_ACTION_PROTECTIVE)
				ability_type = "protective"
			if(VILLAIN_ACTION_INVESTIGATIVE)
				ability_type = "investigative"
			if(VILLAIN_ACTION_ELIMINATION)
				ability_type = "elimination"
		
		available_actions += list(list(
			"id" = "character_ability",
			"name" = owner.character_data.active_ability_name,
			"type" = ability_type,
			"cost" = owner.character_data.active_ability_cost,
			"desc" = owner.character_data.active_ability_desc
		))

	// Items
	for(var/obj/item/villains/I in owner.contents)
		var/item_type = "typeless"
		switch(I.action_type)
			if(VILLAIN_ACTION_SUPPRESSIVE)
				item_type = "suppressive"
			if(VILLAIN_ACTION_PROTECTIVE)
				item_type = "protective"
			if(VILLAIN_ACTION_INVESTIGATIVE)
				item_type = "investigative"
			if(VILLAIN_ACTION_ELIMINATION)
				item_type = "elimination"
		
		available_actions += list(list(
			"id" = "item_[REF(I)]",
			"name" = "Use [I.name]",
			"type" = item_type,
			"cost" = I.action_cost,
			"desc" = I.desc
		))

	// Eliminate (villain only)
	if(owner.is_villain)
		available_actions += list(list(
			"id" = "eliminate",
			"name" = "Eliminate",
			"type" = "elimination",
			"cost" = VILLAIN_ACTION_MAIN,
			"desc" = "Attempt to eliminate another player"
		))

	data["available_actions"] = available_actions

	// Targets with better info
	var/list/targets = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in GLOB.villains_game.living_players)
		var/can_target = TRUE
		var/reason = ""
		var/is_self = (P == owner)
		
		// Check targeting restrictions based on selected action
		if(selected_main_action)
			switch(owner.character_data?.character_id)
				if(VILLAIN_CHAR_FORSAKENMURDER, VILLAIN_CHAR_FAIRYGENTLEMAN, VILLAIN_CHAR_BLUESHEPHERD)
					if(!is_self)
						can_target = FALSE
						reason = "This action can only target yourself"
				if(VILLAIN_CHAR_ALLROUNDCLEANER)
					if(is_self)
						can_target = FALSE
						reason = "You cannot target yourself with this action"
		
		targets += list(list(
			"ref" = REF(P),
			"name" = P.name,
			"is_self" = is_self,
			"can_target" = can_target,
			"reason" = reason
		))
	
	data["available_targets"] = targets

	// Current selections
	data["selected_action"] = selected_main_action
	data["selected_target"] = selected_main_target
	data["can_submit"] = (selected_main_action && selected_main_target)

	return data

/datum/villains_action_selection/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_action")
			selected_main_action = params["action_id"]
			// Clear target if changing action
			selected_main_target = null
			return TRUE

		if("select_target")
			selected_main_target = params["target_ref"]
			return TRUE

		if("submit")
			if(!selected_main_action || !selected_main_target)
				to_chat(owner, span_warning("You must select an action and target!"))
				return TRUE

			// Validate target
			var/mob/living/simple_animal/hostile/villains_character/target = locate(selected_main_target)
			if(!target || !(target in GLOB.villains_game.living_players))
				to_chat(owner, span_warning("Invalid target!"))
				return TRUE

			// Submit to the game controller
			if(GLOB.villains_game)
				// Parse the action type
				var/action_type
				var/action_data

				if(selected_main_action == "talk_trade")
					action_type = VILLAIN_ACTION_TALK_TRADE
				else if(selected_main_action == "character_ability")
					action_type = VILLAIN_ACTION_CHARACTER_ABILITY
				else if(selected_main_action == "eliminate")
					action_type = VILLAIN_ACTION_ELIMINATE
				else if(findtext(selected_main_action, "item_"))
					action_type = VILLAIN_ACTION_USE_ITEM
					action_data = copytext(selected_main_action, 6) // Remove "item_" prefix

				// Store on the mob
				owner.main_action = list(
					"type" = action_type,
					"target" = selected_main_target,
					"data" = action_data
				)

				to_chat(owner, span_notice("Your action has been submitted for tonight."))
				to_chat(owner, span_notice("You will [selected_main_action] targeting [target.name]."))

				// Close the UI
				SStgui.close_uis(src)

			return TRUE

		if("clear")
			selected_main_action = null
			selected_main_target = null
			return TRUE
