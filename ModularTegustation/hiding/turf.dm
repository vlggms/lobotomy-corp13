/turf/open/floor
	/// What players are currently hiding near us
	var/list/possible_hiding_players = list()
	/// How likelly they are to be detected per tile moved (in %)
	var/noise = 10

/turf/open/floor/Destroy()
	possible_hiding_players = null
	return ..()
