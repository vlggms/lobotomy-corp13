// Character sheet datum for Villains of the Night
/datum/villains_character_sheet
	var/mob/living/simple_animal/hostile/villains_character/owner

/datum/villains_character_sheet/New(mob/living/simple_animal/hostile/villains_character/character)
	owner = character

/datum/villains_character_sheet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VillainsCharacterSheet")
		ui.open()

/datum/villains_character_sheet/ui_state(mob/user)
	return GLOB.always_state

/datum/villains_character_sheet/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/villains_character_sheet/ui_data(mob/user)
	var/list/data = list()

	if(!owner || !owner.character_data)
		return data

	data["character_name"] = owner.name
	data["character_icon"] = owner.character_data.name
	data["character_portrait"] = owner.character_data.portrait

	// Convert character icon to base64 for display
	var/icon/character_icon = icon(owner.icon, owner.icon_state)
	data["portrait_base64"] = icon2base64(character_icon)

	data["is_villain"] = owner.is_villain
	// Warden can hold 5 items, everyone else 3
	data["max_items"] = (owner.character_data?.character_id == VILLAIN_CHAR_WARDEN) ? 5 : 3

	// Active ability
	if(owner.character_data.active_ability_name)
		data["active_ability"] = list(
			"name" = owner.character_data.active_ability_name,
			"type" = owner.character_data.active_ability_type,
			"cost" = owner.character_data.active_ability_cost,
			"description" = owner.character_data.active_ability_desc
		)

	// Passive ability
	if(owner.character_data.passive_ability_name)
		data["passive_ability"] = list(
			"name" = owner.character_data.passive_ability_name,
			"description" = owner.character_data.passive_ability_desc
		)

	// Inventory
	var/list/inventory_data = list()
	for(var/obj/item/villains/I in owner.contents)
		inventory_data += list(list(
			"name" = I.name,
			"ref" = REF(I),
			"type" = I.action_type,
			"cost" = I.action_cost,
			"description" = I.desc,
			"fresh" = (I.freshness == VILLAIN_ITEM_FRESH)
		))
	data["inventory"] = inventory_data

	// Game phase information
	if(GLOB.villains_game)
		data["current_phase"] = GLOB.villains_game.get_phase_name(GLOB.villains_game.current_phase)

		// Calculate time remaining if there's a timer
		if(GLOB.villains_game.phase_timer)
			var/time_left = timeleft(GLOB.villains_game.phase_timer)
			if(time_left > 0)
				data["time_remaining"] = round(time_left / 10) // Convert deciseconds to seconds

		// Victory points
		data["victory_points"] = owner.victory_points

	return data

/datum/villains_character_sheet/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("drop_item")
			var/item_ref = params["item_ref"]
			if(!item_ref)
				return

			var/obj/item/villains/I = locate(item_ref)
			if(!I || I.loc != owner)
				return

			I.forceMove(get_turf(owner))
			to_chat(owner, span_notice("You drop [I]."))
			return TRUE
