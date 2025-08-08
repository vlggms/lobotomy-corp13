//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	var/config_filename = "_maps/alphacorp.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/votable = FALSE

	// Config actually from the JSON - should default to Meta
	var/map_name = "Facility A-098 ALPHA"
	var/map_path = "map_files/Alpha"
	var/map_file = "alphacorp.dmm"

	var/traits = null
	var/space_ruin_levels = 0
	var/space_empty_levels = 0

	var/minetype = "none"
	var/faction = "Station"

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")

	/// Dictionary of job sub-typepath to template changes dictionary
	var/job_changes = list()
	
	/// If this map has multiple submaps to choose from
	var/has_submaps = FALSE
	/// List of available submaps if pick_one was set
	var/list/available_submaps = list()
	/// Custom display names for submaps (optional)
	var/list/submap_display_names = list()

/proc/load_map_config(filename = "data/next_map.json", default_to_box, delete_after, error_if_missing = TRUE)
	var/datum/map_config/config = new
	if (default_to_box)
		return config
	if (!config.LoadConfig(filename, error_if_missing))
		qdel(config)
		config = new /datum/map_config  // Fall back to Box
	if (delete_after)
		fdel(filename)
	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/datum/map_config/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	if(!json["version"])
		log_world("map_config missing version!")
		return

	if(json["version"] != MAP_CURRENT_VERSION)
		log_world("map_config has invalid version [json["version"]]!")
		return

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]

	map_file = json["map_file"]
	// "map_file": "MetaStation.dmm"
	if (istext(map_file))
		if (!fexists("_maps/[map_path]/[map_file]"))
			log_world("Map file ([map_path]/[map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("_maps/[map_path]/[file]"))
				log_world("Map file ([map_path]/[file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	if (json["pick_one"] && islist(map_file))
		has_submaps = TRUE
		var/list/L = map_file
		available_submaps = L.Copy()
		// Don't pick yet - will be decided by vote
		
		// Load custom display names if provided
		if(json["submap_names"] && islist(json["submap_names"]))
			var/list/names = json["submap_names"]
			submap_display_names = names.Copy()

	if (islist(json["shuttles"]))
		var/list/L = json["shuttles"]
		for(var/key in L)
			var/value = L[key]
			shuttles[key] = value
	else if ("shuttles" in json)
		log_world("map_config shuttles is not a list!")
		return

	traits = json["traits"]
	// "traits": [{"Linkage": "Cross"}, {"Space Ruins": true}]
	if (islist(traits))
		// "Station" is set by default, but it's assumed if you're setting
		// traits you want to customize which level is cross-linked
		for (var/level in traits)
			if (!(ZTRAIT_STATION in level))
				level[ZTRAIT_STATION] = TRUE
	// "traits": null or absent -> default
	else if (!isnull(traits))
		log_world("map_config traits is not a list!")
		return

	var/temp = json["space_ruin_levels"]
	if (isnum(temp))
		space_ruin_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_ruin_levels is not a number!")
		return

	temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	if ("minetype" in json)
		minetype = json["minetype"]

	if("faction" in json)
		SSmapping.faction = json["faction"]

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE

	if ("job_changes" in json)
		if(!islist(json["job_changes"]))
			log_world("map_config \"job_changes\" field is missing or invalid!")
			return
		job_changes = json["job_changes"]

	if("maptype" in json)
		SSmaptype.maptype = json["maptype"]

	defaulted = FALSE
	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	// If we have a selected submap, we need to write a new JSON with just that file
	if(has_submaps && istext(map_file))
		var/json_value = list(
			"version" = MAP_CURRENT_VERSION,
			"map_name" = map_name,
			"map_path" = map_path,
			"map_file" = map_file, // This is now a single file, not a list
			"shuttles" = shuttles,
			"traits" = traits,
			"space_ruin_levels" = space_ruin_levels,
			"space_empty_levels" = space_empty_levels,
			"minetype" = minetype
		)
		
		if(faction)
			json_value["faction"] = faction
		if(job_changes && length(job_changes))
			json_value["job_changes"] = job_changes
		if(SSmaptype?.maptype)
			json_value["maptype"] = SSmaptype.maptype
			
		// Remove old file and write new one
		if(fexists("data/next_map.json"))
			fdel("data/next_map.json")
		text2file(json_encode(json_value), "data/next_map.json")
		return TRUE
		
	// Default behavior - just copy the file
	return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")

/datum/map_config/proc/SetSelectedSubmap(selected_file)
	if(!has_submaps || !(selected_file in available_submaps))
		return FALSE
	map_file = selected_file
	// Keep has_submaps and available_submaps intact so admins can change selection later
	return TRUE
