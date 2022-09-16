/world/proc/update_status_tegu()

	var/list/features = list()

	if (!GLOB.enter_allowed)
		features += "closed"

	var/s = ""
	var/hostedby
	if(config)
		var/server_name = CONFIG_GET(string/servername)
		if (server_name)
			s += "<b>[server_name]</b>\] &#8212; "
		features += "[CONFIG_GET(flag/norespawn) ? "no " : ""]respawn"
		if(CONFIG_GET(flag/allow_vote_mode))
			features += "vote"
		if(CONFIG_GET(flag/allow_ai))
			features += "AI allowed"
		hostedby = CONFIG_GET(string/hostedby)

	var/server_caption = CONFIG_GET(string/servercaption)
	s+= "<b>[server_caption]</b>"
	s += " ("
	s += "<a href=\"[CONFIG_GET(string/discordurl)]\">"
	s += "Discord"
	s += "</a>"
	s += ")<br>"

	// Tegu Description
	s += "<br>Map: <b>\[[SSmapping.config?.map_name || "Loading..."]</b>\]"
	s += "<br>Roleplay: \[<b>Medium</b>\]"//\]"
		// NOTE: If this is the LAST THING to be added to the description, then it'll end with a ] anyway. So don't include it here

	var/players = GLOB.clients.len

	var/popcaptext = ""
	var/popcap = max(CONFIG_GET(number/extreme_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/soft_popcap))
	if (popcap)
		popcaptext = "/[popcap]"

	if (players > 1)
		features += "[players][popcaptext] players"
	else if (players > 0)
		features += "[players][popcaptext] player"

	game_state = (CONFIG_GET(number/extreme_popcap) && players >= CONFIG_GET(number/extreme_popcap)) //tells the hub if we are full

	if (!host && hostedby)
		features += "hosted by <b>[hostedby]</b>"

	status = s
	return s
