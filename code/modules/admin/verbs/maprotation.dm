/client/proc/forcerandomrotate()
	set category = "Server"
	set name = "Trigger Random Map Rotation"
	var/rotate = alert("Force a random map rotation to trigger?", "Rotate map?", "Yes", "Cancel")
	if (rotate != "Yes")
		return
	message_admins("[key_name_admin(usr)] is forcing a random map rotation.")
	log_admin("[key_name(usr)] is forcing a random map rotation.")
	SSmapping.maprotate()

/client/proc/adminchangesubmap(datum/map_config/map_config = null)
	set category = "Server"
	set name = "Change Submap"
	
	if(!map_config)
		map_config = SSmapping.next_map_config
		if(!map_config)
			to_chat(usr, span_warning("No map is currently selected!"))
			return
	
	if(!map_config.has_submaps || map_config.available_submaps.len <= 1)
		to_chat(usr, span_warning("[map_config.map_name] does not have multiple variants!"))
		return
	
	var/list/submap_choices = list()
	for(var/submap in map_config.available_submaps)
		var/display_name
		// Check if we have a custom display name
		if(submap in map_config.submap_display_names)
			display_name = map_config.submap_display_names[submap]
		else
			// Fall back to cleaned up filename
			display_name = replacetext(submap, ".dmm", "")
			display_name = replacetext(display_name, "_", " ")
			display_name = capitalize(display_name)
		submap_choices[display_name] = submap
	
	var/chosen_submap = input("Choose a variant for [map_config.map_name]", "Submap Selection") as null|anything in sortList(submap_choices)
	if(!chosen_submap)
		return
	
	var/actual_file = submap_choices[chosen_submap]
	if(map_config.SetSelectedSubmap(actual_file))
		map_config.MakeNextMap()
		message_admins("[key_name_admin(usr)] has selected the '[chosen_submap]' variant for [map_config.map_name]")
		log_admin("[key_name(usr)] selected the '[chosen_submap]' variant for [map_config.map_name]")
	else
		to_chat(usr, span_warning("Failed to set submap!"))

/client/proc/adminforcesubmapvote()
	set category = "Server"
	set name = "Force Submap Vote"
	
	if(!SSmapping.next_map_config)
		to_chat(usr, span_warning("No map is currently selected!"))
		return
	
	if(!SSmapping.next_map_config.has_submaps || SSmapping.next_map_config.available_submaps.len <= 1)
		to_chat(usr, span_warning("The selected map does not have multiple variants!"))
		return
	
	if(SSvote.mode)
		to_chat(usr, span_warning("There is already a vote in progress!"))
		return
	
	SSvote.initiate_vote("submap", key_name(usr))
	message_admins("[key_name_admin(usr)] forced a submap vote for [SSmapping.next_map_config.map_name]")
	log_admin("[key_name(usr)] forced a submap vote for [SSmapping.next_map_config.map_name]")

/client/proc/adminchangemap()
	set category = "Server"
	set name = "Change Map"
	var/list/maprotatechoices = list()
	for (var/map in config.maplist)
		var/datum/map_config/VM = config.maplist[map]
		var/mapname = VM.map_name
		if (VM == config.defaultmap)
			mapname += " (Default)"

		if (VM.config_min_users > 0 || VM.config_max_users > 0)
			mapname += " \["
			if (VM.config_min_users > 0)
				mapname += "[VM.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if (VM.config_max_users > 0)
				mapname += "[VM.config_max_users]"
			else
				mapname += "inf"
			mapname += "\]"

		maprotatechoices[mapname] = VM
	var/chosenmap = input("Choose a map to change to", "Change Map")  as null|anything in sortList(maprotatechoices)|"Custom"
	if (!chosenmap)
		return

	if(chosenmap == "Custom")
		message_admins("[key_name_admin(usr)] is changing the map to a custom map")
		log_admin("[key_name(usr)] is changing the map to a custom map")
		var/datum/map_config/VM = new

		VM.map_name = input("Choose the name for the map", "Map Name") as null|text
		if(isnull(VM.map_name))
			VM.map_name = "Custom"

		var/map_file = input("Pick file:", "Map File") as null|file
		if(isnull(map_file))
			return

		if(copytext("[map_file]", -4) != ".dmm")//4 == length(".dmm")
			to_chat(src, span_warning("Filename must end in '.dmm': [map_file]"))
			return

		if(!fcopy(map_file, "_maps/custom/[map_file]"))
			return

		// This is to make sure the map works so the server does not start without a map.
		var/datum/parsed_map/M = new (map_file)
		if(!M)
			to_chat(src, span_warning("Map '[map_file]' failed to parse properly."))
			return

		if(!M.bounds)
			to_chat(src, span_warning("Map '[map_file]' has non-existant bounds."))
			qdel(M)
			return

		qdel(M)

		var/shuttles = alert("Do you want to modify the shuttles?", "Map Shuttles", "Yes", "No")
		if(shuttles == "Yes")
			for(var/s in VM.shuttles)
				var/shuttle = input(s, "Map Shuttles") as null|text
				if(!shuttle)
					continue
				if(!SSmapping.shuttle_templates[shuttle])
					to_chat(usr, span_warning("No such shuttle as '[shuttle]' exists, using default."))
					continue
				VM.shuttles[s] = shuttle

		VM.map_path = "custom"
		VM.map_file = "[map_file]"
		VM.config_filename = "data/next_map.json"
		var/json_value = list(
			"version" = MAP_CURRENT_VERSION,
			"map_name" = VM.map_name,
			"map_path" = VM.map_path,
			"map_file" = VM.map_file,
			"shuttles" = VM.shuttles
		)

		// If the file isn't removed text2file will just append.
		if(fexists("data/next_map.json"))
			fdel("data/next_map.json")
		text2file(json_encode(json_value), "data/next_map.json")

		if(SSmapping.changemap(VM))
			message_admins("[key_name_admin(usr)] has changed the map to [VM.map_name]")
	else
		var/datum/map_config/source_config = maprotatechoices[chosenmap]
		message_admins("[key_name_admin(usr)] is changing the map to [source_config.map_name]")
		log_admin("[key_name(usr)] is changing the map to [source_config.map_name]")
		
		// We need to load a fresh copy of the config to modify
		var/datum/map_config/VM = load_map_config(source_config.config_filename, error_if_missing = FALSE)
		if(!VM)
			to_chat(usr, span_warning("Failed to load map config!"))
			return
		
		// Check if this map has submaps and ask admin if they want to select one BEFORE changemap
		if(VM.has_submaps && VM.available_submaps.len > 1)
			var/submap_choice = alert("This map has multiple variants. Do you want to select a specific one?", "Submap Selection", "Select Variant", "Start Vote", "Random")
			switch(submap_choice)
				if("Select Variant")
					adminchangesubmap(VM)
				if("Start Vote")
					// Let changemap handle the vote timing
					// Just mark that admin wants a vote
				if("Random")
					// Pick a random submap now
					var/selected = pick(VM.available_submaps)
					VM.SetSelectedSubmap(selected)
					message_admins("[key_name_admin(usr)] randomly selected '[selected]' variant for [VM.map_name]")
		
		if (SSmapping.changemap(VM))
			message_admins("[key_name_admin(usr)] has changed the map to [VM.map_name]")
