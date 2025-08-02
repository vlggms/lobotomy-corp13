// Villains of the Night game items

/obj/item/villains
	name = "game item"
	desc = "An item used in the Villains of the Night game."
	icon = 'icons/obj/device.dmi'
	icon_state = "tablet"

	var/action_type = VILLAIN_ACTION_TYPELESS
	var/action_cost = VILLAIN_ACTION_MAIN
	var/freshness = VILLAIN_ITEM_FRESH
	var/evidence_color = "#FFFF00" // Yellow for investigation phase
	var/rarity = VILLAIN_ITEM_COMMON // Item rarity for spawn weighting
	var/emp_disabled = FALSE // If the item has been disabled by EMP
	var/is_evidence = FALSE // If TRUE, item can't be picked up during investigation

/obj/item/villains/Initialize()
	. = ..()
	update_outline()

/obj/item/villains/Destroy()
	remove_filter("villains_glow")
	. = ..()
	return

/obj/item/villains/examine(mob/user)
	. = ..()
	// Show rarity
	switch(rarity)
		if(VILLAIN_ITEM_COMMON)
			. += span_notice("This is a <b>common</b> item.")
		if(VILLAIN_ITEM_UNCOMMON)
			. += span_notice("This is an <b style='color:#4169E1'>uncommon</b> item.")
		if(VILLAIN_ITEM_RARE)
			. += span_notice("This is a <b style='color:#FFD700'>rare</b> item.")

	// Show action type and cost
	var/type_name = "Unknown"
	switch(action_type)
		if(VILLAIN_ACTION_TYPELESS)
			type_name = "Typeless"
		if(VILLAIN_ACTION_PROTECTIVE)
			type_name = "Protective"
		if(VILLAIN_ACTION_INVESTIGATIVE)
			type_name = "Investigative"
		if(VILLAIN_ACTION_SUPPRESSIVE)
			type_name = "Suppressive"
		if(VILLAIN_ACTION_ELIMINATION)
			type_name = "Elimination"

	. += span_notice("Action Type: <b>[type_name]</b> | Cost: <b>[action_cost]</b>")

	// Show evidence information during investigation
	if(freshness == VILLAIN_ITEM_USED)
		. += span_warning("This item shows signs of recent use!")
		if(is_evidence)
			if(GLOB.villains_game?.current_phase == VILLAIN_PHASE_INVESTIGATION)
				. += span_boldnotice("Click on this evidence to mark it as found and send it to the main room.")
			else
				. += span_notice("This evidence cannot be picked up. All players may examine it.")
	else if(freshness == VILLAIN_ITEM_FRESH)
		. += span_notice("This item appears untouched.")

	// Show if disabled by EMP
	if(emp_disabled)
		. += span_danger("This item has been disabled by an EMP!")

/obj/item/villains/proc/update_outline()
	// Remove any existing filters
	remove_filter("villains_glow")

	if(freshness == VILLAIN_ITEM_FRESH)
		// Green outline for fresh items
		add_filter("villains_glow", 2, list("type" = "outline", "color" = "#00FF0080", "size" = 2))
		// Start glow animation
		addtimer(CALLBACK(src, PROC_REF(glow_loop)), rand(1,19))
	else if(freshness == VILLAIN_ITEM_USED)
		// Yellow outline for used items (evidence)
		add_filter("villains_glow", 2, list("type" = "outline", "color" = evidence_color + "80", "size" = 2))
		// Start glow animation
		addtimer(CALLBACK(src, PROC_REF(glow_loop)), rand(1,19))

/obj/item/villains/proc/glow_loop()
	var/filter = get_filter("villains_glow")
	if(filter)
		animate(filter, alpha = 110, time = 15, loop = -1)
		animate(alpha = 40, time = 25)

/obj/item/villains/proc/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	log_game("VILLAINS DEBUG: use_item() called for [src.name] by [user] on [target]")
	
	// Check if item is disabled by EMP
	if(emp_disabled)
		to_chat(user, span_warning("[src] sparks and fails - it has been disabled by an EMP!"))
		return FALSE
	
	freshness = VILLAIN_ITEM_USED
	update_outline()
	if(game)
		if(!(src in game.used_items)) // Prevent duplicates
			game.used_items += src
			log_game("VILLAINS DEBUG: Added [src.name] to used_items list (now [length(game.used_items)] items)")
		else
			log_game("VILLAINS DEBUG: [src.name] already in used_items list, skipping")
	else
		log_game("VILLAINS DEBUG: No game controller found, item not added to used_items!")
	return TRUE

/obj/item/villains/attack_hand(mob/user)
	// If this is evidence, handle it specially
	if(is_evidence)
		if(!istype(user, /mob/living/simple_animal/hostile/villains_character))
			return TRUE

		var/mob/living/simple_animal/hostile/villains_character/V = user

		// Evidence can only be examined, not picked up manually
		to_chat(V, span_notice("This is evidence from the investigation. You can examine it but cannot pick it up manually."))
		if(GLOB.villains_game?.current_phase == VILLAIN_PHASE_INVESTIGATION)
			to_chat(V, span_notice("Walk over evidence to collect it."))

		return TRUE // Block pickup

	// Normal pickup behavior
	return ..()

/obj/item/villains/pickup(mob/user)
	// Prevent picking up evidence items
	if(is_evidence)
		if(user)
			user.dropItemToGround(src, TRUE)
		return FALSE

	. = ..()
	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/V = user
		// Check fresh item limit
		if(freshness == VILLAIN_ITEM_FRESH)
			if(!V.can_pickup_fresh())
				to_chat(V, span_warning("You can only carry [VILLAIN_MAX_FRESH_ITEMS] fresh items at a time!"))
				V.dropItemToGround(src)
				return
			V.fresh_items += src

/obj/item/villains/dropped(mob/user)
	. = ..()
	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/V = user
		if(freshness == VILLAIN_ITEM_FRESH && (src in V.fresh_items))
			V.fresh_items -= src

// Investigative Items

/obj/item/villains/enkephalin_detector
	name = "Enkephalin Detector"
	desc = "Learn your target's targets for their main and secondary actions."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/enkephalin_detector/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	
	// Check if they're currently engaged in trading
	if(T.trading_with)
		to_chat(user, span_notice("[target]'s main action targets: [T.trading_with.name]"))
		// They might still have a secondary action queued
	else if(T.main_action)
		var/target_ref = T.main_action["target"]
		var/mob/living/simple_animal/hostile/villains_character/action_target = locate(target_ref)
		if(action_target)
			to_chat(user, span_notice("[target]'s main action targets: [action_target.name]"))
		else
			to_chat(user, span_notice("[target]'s main action targets: themselves"))
	else
		to_chat(user, span_notice("[target] has not selected a main action."))
	
	// Show secondary action target
	if(T.secondary_action)
		var/target_ref = T.secondary_action["target"]
		var/mob/living/simple_animal/hostile/villains_character/action_target = locate(target_ref)
		if(action_target)
			to_chat(user, span_notice("[target]'s secondary action targets: [action_target.name]"))
		else
			to_chat(user, span_notice("[target]'s secondary action targets: themselves"))
	else
		to_chat(user, span_notice("[target] has not selected a secondary action."))
		
	return TRUE

/obj/item/villains/deepscan_kit
	name = "'DEEPSCAN' Kit"
	desc = "Learn your target's main and secondary actions."
	icon = 'icons/obj/storage.dmi'
	icon_state = "maint_kit"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/deepscan_kit/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	
	// Check if they're currently engaged in trading
	if(T.trading_with)
		to_chat(user, span_notice("[target]'s main action: Talk/Trade"))
		return TRUE
	
	if(T.main_action)
		var/action_type = T.main_action["type"]
		var/action_name = "Unknown"

		// Check if they used fairy wine - if so, show Talk/Trade
		if(T.used_fairy_wine)
			action_name = "Talk/Trade"
		else
			switch(action_type)
				if(VILLAIN_ACTION_TALK_TRADE)
					action_name = "Talk/Trade"
				if(VILLAIN_ACTION_ELIMINATE)
					action_name = "Eliminate"
				if(VILLAIN_ACTION_USE_ITEM)
					action_name = "Use Item"
				if(VILLAIN_ACTION_CHARACTER_ABILITY)
					action_name = "Character Ability"
		
		// Check if the action was blocked
		if(T.main_action_blocked)
			to_chat(user, span_notice("[target]'s main action: [action_name] (BLOCKED)"))
		else
			to_chat(user, span_notice("[target]'s main action: [action_name]"))
	else
		to_chat(user, span_notice("[target] has not selected a main action."))
	
	// Check secondary action
	if(T.secondary_action)
		var/sec_action_type = T.secondary_action["type"]
		var/sec_action_name = "Unknown"
		switch(sec_action_type)
			if("talk_trade")
				sec_action_name = "Talk/Trade"
			if("use_item")
				sec_action_name = "Use Item"
			if("character_ability")
				sec_action_name = "Character Ability"
			if("inheritance_trade")
				sec_action_name = "Talk/Trade (Inheritance)"
		// Check if the secondary action was blocked
		if(T.secondary_action_blocked)
			to_chat(user, span_notice("[target]'s secondary action: [sec_action_name] (BLOCKED)"))
		else
			to_chat(user, span_notice("[target]'s secondary action: [sec_action_name]"))
	else
		to_chat(user, span_notice("[target] has not selected a secondary action."))
	
	return TRUE

/obj/item/villains/drain_monitor
	name = "Drain Monitor"
	desc = "Learn everyone who targeted your target."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/drain_monitor/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	// This will be filled in during action processing
	// For now, mark that we're monitoring this target
	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/U = user
		U.drain_monitor_target = target
		to_chat(user, span_notice("You set up the drain monitor on [target]. You'll learn who targeted them after all actions are processed."))

	return TRUE

/obj/item/villains/rangefinder
	name = "Keen-Sense Rangefinder"
	desc = "Learn all of the actions that targeted your target."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget2r"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/rangefinder/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	// This will be filled in during action processing
	// For now, mark that we're monitoring this target
	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/U = user
		U.rangefinder_target = target
		to_chat(user, span_notice("You focus the rangefinder on [target]. You'll learn what actions targeted them after all actions are processed."))

	return TRUE

/obj/item/villains/binoculars
	name = "Binoculars"
	desc = "Learn the target's inventory."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "binoculars"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_COMMON

/obj/item/villains/binoculars/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	var/list/inventory_items = list()

	for(var/obj/item/villains/I in T.contents)
		inventory_items += I.name

	if(length(inventory_items))
		to_chat(user, span_notice("[target] is carrying: [inventory_items.Join(", ")]."))
	else
		to_chat(user, span_notice("[target] is not carrying any items."))

	return TRUE

/obj/item/villains/command_projector
	name = "Command Projector"
	desc = "Send a short message to a player (max 100 characters)."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget3"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_SECONDARY
	rarity = VILLAIN_ITEM_COMMON

/obj/item/villains/command_projector/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	// Get message from user via input
	var/message = input(user, "Enter message to send to [target] (max 100 characters):", "Command Projector") as text|null
	if(!message)
		to_chat(user, span_warning("No message entered."))
		return FALSE

	// Limit to 100 characters
	message = copytext(message, 1, 101)

	to_chat(target, span_boldnotice("You receive a mysterious message: '[message]'"))
	to_chat(user, span_notice("You send your message to [target]: '[message]'"))

	return TRUE

// Protective Items

/obj/item/villains/forcefield_projector
	name = "Forcefield Projector"
	desc = "Target becomes immune to direct eliminations. Can only target yourself."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker_forcefield"
	action_type = VILLAIN_ACTION_PROTECTIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_RARE

/obj/item/villains/forcefield_projector/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(target != user)
		to_chat(user, span_warning("You can only use this on yourself!"))
		return FALSE
	if(!..())
		return FALSE

	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/U = user
		U.apply_protection()
		to_chat(user, span_notice("You activate the forcefield projector, protecting yourself from elimination."))
	return TRUE

// Suppressive Items

/obj/item/villains/handheld_taser
	name = "Handheld Taser"
	desc = "Your targeted player's main action will fail tonight."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "taser"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/handheld_taser/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	T.main_action_blocked = TRUE
	to_chat(user, span_notice("You tase [target], disrupting their main action!"))
	to_chat(target, span_warning("You feel a strange sensation..."))
	return TRUE

/obj/item/villains/w_corp_teleporter
	name = "W-Corp Teleporter"
	desc = "Your target's main action's target will be randomized."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "teleporter"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/w_corp_teleporter/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target

	// Check if they have a main action
	if(!T.main_action)
		to_chat(user, span_notice("The teleporter activates but finds no action to redirect."))
		return TRUE

	// Get list of possible targets
	var/list/possible_targets = list()
	for(var/mob/living/simple_animal/hostile/villains_character/P in game.living_players)
		possible_targets += REF(P)

	if(!length(possible_targets))
		return FALSE

	// Randomize the target
	var/new_target = pick(possible_targets)
	T.main_action["target"] = new_target

	to_chat(user, span_notice("You activate the teleporter on [target], scrambling their targeting systems!"))
	to_chat(target, span_warning("You feel disoriented..."))

	return TRUE

/obj/item/villains/throwing_bola
	name = "Throwing Bola"
	desc = "Your targeted player's secondary action will fail tonight."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "bola"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_SECONDARY
	rarity = VILLAIN_ITEM_COMMON

/obj/item/villains/throwing_bola/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	T.secondary_action_blocked = TRUE
	to_chat(user, span_notice("You throw the bola at [target], tangling their legs!"))
	to_chat(target, span_warning("You feel a strange sensation..."))
	return TRUE

/obj/item/villains/nitrile_gloves
	name = "Nitrile Gloves"
	desc = "Steal a random item from the target's inventory. If they were using it, their action is canceled."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "nitrile"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_RARE

/obj/item/villains/nitrile_gloves/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	if(!istype(user, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	var/mob/living/simple_animal/hostile/villains_character/U = user

	// Get list of stealable items
	var/list/stealable_items = list()
	for(var/obj/item/villains/I in T.contents)
		stealable_items += I

	if(!length(stealable_items))
		to_chat(user, span_notice("You search [target] but find nothing to steal."))
		return TRUE

	// Steal a random item
	var/obj/item/villains/stolen_item = pick(stealable_items)

	// Check if the stolen item was being used in an action
	var/action_canceled = FALSE
	if(T.main_action && T.main_action["type"] == "use_item")
		var/action_item_ref = T.main_action["data"]
		if(action_item_ref == REF(stolen_item))
			T.main_action = null
			action_canceled = TRUE
			to_chat(T, span_warning("Your action was disrupted!"))

	if(T.secondary_action && T.secondary_action["type"] == "use_item")
		var/action_item_ref = T.secondary_action["data"]
		if(action_item_ref == REF(stolen_item))
			T.secondary_action = null
			action_canceled = TRUE
			to_chat(T, span_warning("Your secondary action was disrupted!"))

	// Transfer the item
	stolen_item.forceMove(U)

	// Update fresh item tracking
	if(stolen_item.freshness == VILLAIN_ITEM_FRESH && (stolen_item in T.fresh_items))
		T.fresh_items -= stolen_item
		// Don't add to user's fresh items since it's stolen

	to_chat(user, span_notice("You steal [stolen_item] from [target]![action_canceled ? " Their action using it was canceled!" : ""]"))
	to_chat(target, span_warning("Your [stolen_item] has been stolen!"))

	return TRUE

// Special Items

/obj/item/villains/fairy_wine
	name = "Fairy Wine"
	desc = "Talk and Trade with the target of your Main Action. Makes your action appear as Talk and Trade to investigators."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "fairy_wine"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_SECONDARY
	rarity = VILLAIN_ITEM_RARE

/obj/item/villains/fairy_wine/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(user, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/U = user

	// Mark the user as having used fairy wine (for investigative purposes)
	U.used_fairy_wine = TRUE

	// Alert all Fairy Gentleman players and give them the effect
	for(var/mob/living/simple_animal/hostile/villains_character/player in game.living_players)
		if(player.character_data?.character_id == VILLAIN_CHAR_FAIRYGENTLEMAN)
			to_chat(player, span_boldnotice("Someone has consumed Fairy Wine! You feel a mystical connection..."))
			// Give them the fairy wine effect too
			player.used_fairy_wine = TRUE

	to_chat(user, span_notice("You drink the Fairy Wine, feeling more charismatic... Your main action will appear as Talk/Trade to investigators."))

	// Note: The actual Talk/Trade session will be created when processing the main action
	// if the main action's target matches this secondary action's target

	return TRUE

// New Protective Items

/obj/item/villains/guardian_drone
	name = "Guardian Drone"
	desc = "Protects target player from elimination for the night."
	icon = 'icons/obj/device.dmi'
	icon_state = "flightpack_boost"
	action_type = VILLAIN_ACTION_PROTECTIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_RARE

/obj/item/villains/guardian_drone/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(istype(target, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/T = target
		T.apply_protection()
		to_chat(user, span_notice("You deploy the guardian drone to protect [target]."))
		to_chat(target, span_notice("A guardian drone hovers protectively around you."))
	return TRUE

/obj/item/villains/smoke_bomb
	name = "Smoke Bomb"
	desc = "Creates confusion, making all actions targeting you fail."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "smoke"
	action_type = VILLAIN_ACTION_PROTECTIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/smoke_bomb/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(target != user)
		to_chat(user, span_warning("You can only use this on yourself!"))
		return FALSE
	if(!..())
		return FALSE

	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/U = user
		U.smoke_bombed = TRUE
		to_chat(user, span_notice("You throw down the smoke bomb, obscuring yourself in a thick cloud!"))

		// Notify anyone who was targeting this player
		for(var/mob/living/simple_animal/hostile/villains_character/player in game.living_players)
			if(player.main_action && player.main_action["target"] == REF(user))
				to_chat(player, span_warning("Your target disappears in a cloud of smoke!"))
			if(player.secondary_action && player.secondary_action["target"] == REF(user))
				to_chat(player, span_warning("Your secondary target disappears in a cloud of smoke!"))
	return TRUE

// New Investigative Items

/obj/item/villains/audio_recorder
	name = "Audio Recorder"
	desc = "Hear snippets of conversations your target has."
	icon = 'icons/obj/device.dmi'
	icon_state = "recorder"
	action_type = VILLAIN_ACTION_INVESTIGATIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_COMMON

/obj/item/villains/audio_recorder/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target
	T.audio_recorded = TRUE
	T.audio_recorder = user

	to_chat(user, span_notice("You plant the audio recorder on [target]. You'll hear any conversations they have tonight."))
	return TRUE

// New Suppressive Items

/obj/item/villains/emp_device
	name = "EMP Device"
	desc = "Disables all items in target's inventory for the night."
	icon = 'icons/obj/device.dmi'
	icon_state = "emp"
	action_type = VILLAIN_ACTION_SUPPRESSIVE
	action_cost = VILLAIN_ACTION_MAIN
	rarity = VILLAIN_ITEM_RARE

/obj/item/villains/emp_device/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(!..())
		return FALSE

	if(!istype(target, /mob/living/simple_animal/hostile/villains_character))
		return FALSE

	var/mob/living/simple_animal/hostile/villains_character/T = target

	// Disable all items in their inventory
	var/disabled_count = 0
	for(var/obj/item/villains/I in T.contents)
		I.emp_disabled = TRUE
		disabled_count++

	// Cancel any item-based actions they had queued
	if(T.main_action && T.main_action["type"] == "use_item")
		T.main_action = null
		to_chat(T, span_warning("Your main action was disrupted by an EMP!"))

	if(T.secondary_action && T.secondary_action["type"] == "use_item")
		T.secondary_action = null
		to_chat(T, span_warning("Your secondary action was disrupted by an EMP!"))

	to_chat(user, span_notice("You activate the EMP device on [target], disabling [disabled_count] items!"))
	to_chat(target, span_warning("Your electronic devices spark and fail! All your items have been disabled!"))

	return TRUE

// New Special/Utility Items

/obj/item/villains/lucky_coin
	name = "Lucky Coin"
	desc = "Flip to avoid one negative effect targeting you."
	icon = 'icons/obj/economy.dmi'
	icon_state = "coin_heads"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_SECONDARY
	rarity = VILLAIN_ITEM_UNCOMMON

/obj/item/villains/lucky_coin/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	if(target != user)
		to_chat(user, span_warning("You can only use this on yourself!"))
		return FALSE
	if(!..())
		return FALSE

	if(istype(user, /mob/living/simple_animal/hostile/villains_character))
		var/mob/living/simple_animal/hostile/villains_character/U = user
		U.has_lucky_coin = TRUE
		to_chat(user, span_notice("You flip the lucky coin and keep it ready. It will protect you from one negative effect tonight."))

		// Visual effect
		user.visible_message(span_notice("[user] flips a golden coin..."), span_notice("You flip your lucky coin..."))

		// Coin flip result (just for flavor)
		if(prob(50))
			to_chat(user, span_notice("It lands on heads! You feel fortunate."))
		else
			to_chat(user, span_notice("It lands on tails! Luck is on your side."))

	return TRUE

// Resource Items

/obj/item/villains/candle
	name = "Candle"
	desc = "A special candle that provides light and warmth. Can be consumed to gain candle resources."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1_lit"
	action_type = VILLAIN_ACTION_TYPELESS
	action_cost = VILLAIN_ACTION_FREE
	rarity = VILLAIN_ITEM_RARE
	
/obj/item/villains/candle/use_item(mob/living/user, mob/living/target, datum/villains_controller/game)
	// Candles can't be used directly as an action
	to_chat(user, span_notice("This candle will be consumed during the evening phase to provide candle resources."))
	return FALSE
	
/obj/item/villains/candle/examine(mob/user)
	. = ..()
	. += span_notice("This candle will be automatically consumed during the evening phase to grant 1 candle resource.")

