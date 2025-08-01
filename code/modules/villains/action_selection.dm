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

/datum/villains_action_selection/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/villains_action_selection/ui_data(mob/user)
	var/list/data = list()

	if(!owner || !GLOB.villains_game)
		return data

	// Character info
	data["character_name"] = owner.name
	data["is_villain"] = owner.is_villain

	// Separate main and secondary actions
	var/list/main_actions = list()
	var/list/secondary_actions = list()

	// Talk/Trade is always available as main action
	var/candle_text = owner.candles > 0 ? "[owner.candles] candles available" : "No candles!"
	main_actions += list(list(
		"id" = "talk_trade",
		"name" = "Talk/Trade (Requires 1 Candle)",
		"type" = "typeless",
		"cost" = VILLAIN_ACTION_MAIN,
		"desc" = "Visit another player to talk and trade for 2 minutes. Consumes 1 candle. ([candle_text])",
		"disabled" = owner.candles <= 0,
		"disabled_reason" = "No candles available"
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
		
		// Add to appropriate list based on cost
		if(owner.character_data.active_ability_cost == VILLAIN_ACTION_MAIN)
			var/ability_name = owner.character_data.active_ability_name
			var/ability_desc = owner.character_data.active_ability_desc
			
			// Check if this is All-Around Cleaner's Room Cleaning
			if(owner.character_data.character_id == VILLAIN_CHAR_ALLROUNDCLEANER)
				var/cleaner_candle_text = owner.candles > 0 ? "[owner.candles] candles available" : "No candles!"
				ability_name = "Room Cleaning (Requires 1 Candle)"
				ability_desc = "Talk and trade with your target for 2 minutes before stealing one random item from their inventory. Consumes 1 candle. ([cleaner_candle_text])"
			
			var/list/ability_data = list(
				"id" = "character_ability",
				"name" = ability_name,
				"type" = ability_type,
				"cost" = owner.character_data.active_ability_cost,
				"desc" = ability_desc
			)
			
			// Add disabled state for All-Around Cleaner when no candles
			if(owner.character_data.character_id == VILLAIN_CHAR_ALLROUNDCLEANER)
				ability_data["disabled"] = owner.candles <= 0
				ability_data["disabled_reason"] = "No candles available"
			
			main_actions += list(ability_data)
		else if(owner.character_data.active_ability_cost == VILLAIN_ACTION_SECONDARY)
			secondary_actions += list(list(
				"id" = "character_ability",
				"name" = owner.character_data.active_ability_name,
				"type" = ability_type,
				"cost" = owner.character_data.active_ability_cost,
				"desc" = owner.character_data.active_ability_desc
			))
		else if(owner.character_data.active_ability_cost == VILLAIN_ACTION_FREE)
			// Free actions can be used as either main or secondary
			main_actions += list(list(
				"id" = "character_ability",
				"name" = owner.character_data.active_ability_name,
				"type" = ability_type,
				"cost" = owner.character_data.active_ability_cost,
				"desc" = owner.character_data.active_ability_desc + " (Free Action - doesn't consume your action)"
			))
	
	// Puss in Boots special - can Talk/Trade with blessed players as secondary
	if(owner.character_data?.character_id == VILLAIN_CHAR_PUSSINBOOTS && owner.current_blessing)
		var/inheritance_candle_text = owner.candles > 0 ? "[owner.candles] candles available" : "No candles!"
		secondary_actions += list(list(
			"id" = "inheritance_trade",
			"name" = "Inheritance (Talk/Trade with Blessed - Requires 1 Candle)",
			"type" = "typeless",
			"cost" = VILLAIN_ACTION_SECONDARY,
			"desc" = "Talk and trade with your blessed player. Consumes 1 candle. ([inheritance_candle_text])",
			"disabled" = owner.candles <= 0,
			"disabled_reason" = "No candles available"
		))

	// Items - separate by cost
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
		
		var/action_data = list(
			"id" = "item_[REF(I)]",
			"name" = "Use [I.name]",
			"type" = item_type,
			"cost" = I.action_cost,
			"desc" = I.desc
		)
		
		if(I.action_cost == VILLAIN_ACTION_MAIN)
			main_actions += list(action_data)
		else if(I.action_cost == VILLAIN_ACTION_SECONDARY)
			secondary_actions += list(action_data)

	// Eliminate (villain only) - main action
	if(owner.is_villain)
		var/list/eliminate_data = list(
			"id" = "eliminate",
			"name" = "Eliminate",
			"type" = "elimination",
			"cost" = VILLAIN_ACTION_MAIN,
			"desc" = "Attempt to eliminate another player"
		)
		
		// Disable on first night
		if(GLOB.villains_game?.is_first_night)
			eliminate_data["disabled"] = TRUE
			eliminate_data["disabled_reason"] = "Cannot eliminate on the first night"
		
		main_actions += list(eliminate_data)

	data["available_actions"] = main_actions
	data["secondary_actions"] = secondary_actions

	// Targets with better info
	var/list/targets = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in GLOB.villains_game.living_players)
		var/can_target = TRUE
		var/reason = ""
		var/is_self = (P == owner)
		
		// Check targeting restrictions based on selected action
		if(selected_main_action == "character_ability")
			switch(owner.character_data?.character_id)
				if(VILLAIN_CHAR_FORSAKENMURDER, VILLAIN_CHAR_FAIRYGENTLEMAN, VILLAIN_CHAR_BLUESHEPHERD)
					if(!is_self)
						can_target = FALSE
						reason = "This action can only target yourself"
				if(VILLAIN_CHAR_ALLROUNDCLEANER)
					if(is_self)
						can_target = FALSE
						reason = "You cannot target yourself with this action"
		
		// Check item-based restrictions
		else if(findtext(selected_main_action, "item_"))
			var/item_ref = copytext(selected_main_action, 6)
			var/obj/item/villains/I = locate(item_ref)
			if(I)
				// Items that can only target self
				if(istype(I, /obj/item/villains/forcefield_projector) || \
				   istype(I, /obj/item/villains/smoke_bomb) || \
				   istype(I, /obj/item/villains/lucky_coin))
					if(!is_self)
						can_target = FALSE
						reason = "This item can only be used on yourself"
		
		targets += list(list(
			"ref" = REF(P),
			"name" = P.name,
			"is_self" = is_self,
			"can_target" = can_target,
			"reason" = reason
		))
	
	data["available_targets"] = targets
	
	// Build secondary targets with their own restrictions
	var/list/secondary_targets = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in GLOB.villains_game.living_players)
		var/can_target = TRUE
		var/reason = ""
		var/is_self = (P == owner)
		
		// Check secondary action restrictions
		if(selected_secondary_action == "inheritance_trade")
			// Puss in Boots can only target their blessed player
			if(owner.character_data?.character_id == VILLAIN_CHAR_PUSSINBOOTS)
				if(P != owner.current_blessing)
					can_target = FALSE
					reason = "You can only use Inheritance on your blessed player"
		else if(findtext(selected_secondary_action, "item_"))
			var/item_ref = copytext(selected_secondary_action, 6)
			var/obj/item/villains/I = locate(item_ref)
			if(I)
				// Items that can only target self
				if(istype(I, /obj/item/villains/forcefield_projector) || \
				   istype(I, /obj/item/villains/smoke_bomb) || \
				   istype(I, /obj/item/villains/lucky_coin))
					if(!is_self)
						can_target = FALSE
						reason = "This item can only be used on yourself"
		
		secondary_targets += list(list(
			"ref" = REF(P),
			"name" = P.name,
			"is_self" = is_self,
			"can_target" = can_target,
			"reason" = reason
		))
	
	data["secondary_targets"] = secondary_targets

	// Current selections
	data["selected_action"] = selected_main_action
	data["selected_target"] = selected_main_target
	data["selected_secondary_action"] = selected_secondary_action
	data["selected_secondary_target"] = selected_secondary_target
	data["can_submit"] = (selected_main_action && selected_main_target)

	return data

/datum/villains_action_selection/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_action")
			var/action_id = params["action_id"]
			selected_main_action = action_id
			// Clear target if changing action
			selected_main_target = null
			return TRUE

		if("select_target")
			selected_main_target = params["target_ref"]
			return TRUE
			
		if("select_secondary_action")
			var/action_id = params["action_id"]
			selected_secondary_action = action_id
			// Clear target if changing action
			selected_secondary_target = null
			return TRUE

		if("select_secondary_target")
			selected_secondary_target = params["target_ref"]
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
			
			// Validate self-targeting restrictions for items
			if(findtext(selected_main_action, "item_"))
				var/item_ref = copytext(selected_main_action, 6)
				var/obj/item/villains/I = locate(item_ref)
				if(I)
					if(istype(I, /obj/item/villains/forcefield_projector) || \
					   istype(I, /obj/item/villains/smoke_bomb) || \
					   istype(I, /obj/item/villains/lucky_coin))
						if(target != owner)
							to_chat(owner, span_warning("This item can only be used on yourself!"))
							return TRUE

			// Submit to the game controller
			if(GLOB.villains_game)
				// Parse the action type
				var/action_type
				var/action_data

				if(selected_main_action == "talk_trade")
					// Check if player has candles
					if(owner.candles <= 0)
						to_chat(owner, span_warning("You need at least 1 candle to Talk/Trade!"))
						return TRUE
					action_type = "talk_trade"
				else if(selected_main_action == "character_ability")
					// Check if this is All-Around Cleaner's Room Cleaning
					if(owner.character_data?.character_id == VILLAIN_CHAR_ALLROUNDCLEANER)
						if(owner.candles <= 0)
							to_chat(owner, span_warning("You need at least 1 candle to use Room Cleaning!"))
							return TRUE
					action_type = "character_ability"
				else if(selected_main_action == "eliminate")
					// Check if it's first night
					if(GLOB.villains_game?.is_first_night)
						to_chat(owner, span_warning("You cannot eliminate anyone on the first night!"))
						return TRUE
					action_type = "eliminate"
				else if(findtext(selected_main_action, "item_"))
					action_type = "use_item"
					action_data = copytext(selected_main_action, 6) // Remove "item_" prefix

				// Store main action on the mob
				owner.main_action = list(
					"type" = action_type,
					"target" = selected_main_target,
					"data" = action_data
				)
				
				// Handle secondary action if selected
				if(selected_secondary_action && selected_secondary_target)
					var/mob/living/simple_animal/hostile/villains_character/secondary_target = locate(selected_secondary_target)
					if(secondary_target && (secondary_target in GLOB.villains_game.living_players))
						// Validate self-targeting restrictions for secondary items
						if(findtext(selected_secondary_action, "item_"))
							var/item_ref = copytext(selected_secondary_action, 6)
							var/obj/item/villains/I = locate(item_ref)
							if(I)
								if(istype(I, /obj/item/villains/forcefield_projector) || \
								   istype(I, /obj/item/villains/smoke_bomb) || \
								   istype(I, /obj/item/villains/lucky_coin))
									if(secondary_target != owner)
										to_chat(owner, span_warning("This secondary item can only be used on yourself!"))
										return TRUE
						
						// Validate inheritance trade targeting
						if(selected_secondary_action == "inheritance_trade")
							if(owner.character_data?.character_id == VILLAIN_CHAR_PUSSINBOOTS)
								if(secondary_target != owner.current_blessing)
									to_chat(owner, span_warning("You can only use Inheritance on your blessed player!"))
									return TRUE
								// Check if player has candles for inheritance trade
								if(owner.candles <= 0)
									to_chat(owner, span_warning("You need at least 1 candle to use Inheritance!"))
									return TRUE
						
						var/secondary_type
						var/secondary_data
						
						if(selected_secondary_action == "character_ability")
							secondary_type = "character_ability"
						else if(selected_secondary_action == "inheritance_trade")
							secondary_type = "inheritance_trade"
						else if(findtext(selected_secondary_action, "item_"))
							secondary_type = "use_item"
							secondary_data = copytext(selected_secondary_action, 6) // Remove "item_" prefix
						
						owner.secondary_action = list(
							"type" = secondary_type,
							"target" = selected_secondary_target,
							"data" = secondary_data
						)

				to_chat(owner, span_notice("Your action has been submitted for tonight."))
				
				// Get display name for the action
				var/action_display = get_action_display_name(selected_main_action)
				to_chat(owner, span_notice("Main: You will [action_display] [target.name]."))
				
				if(selected_secondary_action && selected_secondary_target)
					var/secondary_display = get_action_display_name(selected_secondary_action)
					var/secondary_target = locate(selected_secondary_target)
					if(secondary_target)
						to_chat(owner, span_notice("Secondary: You will [secondary_display] [secondary_target]."))

				// Close the UI
				SStgui.close_uis(src)

			return TRUE

		if("clear")
			selected_main_action = null
			selected_main_target = null
			selected_secondary_action = null
			selected_secondary_target = null
			return TRUE

/datum/villains_action_selection/proc/get_action_display_name(action_id)
	if(!action_id)
		return "perform an unknown action on"
	
	switch(action_id)
		if("talk_trade")
			return "talk and trade with"
		if("character_ability")
			return "use your ability on"
		if("eliminate")
			return "eliminate"
		else
			// Check if it's an item action
			if(findtext(action_id, "item_"))
				var/item_ref = copytext(action_id, 6) // Remove "item_" prefix
				var/obj/item/villains/I = locate(item_ref)
				if(I)
					return "use [I.name] on"
				else
					return "use an item on"
			else
				return "perform [action_id] on"
