/proc/load_trusted_players()
	if(fexists("[global.config.directory]/trusted_players.txt"))
		GLOB.trusted_players = world.file2list("[global.config.directory]/trusted_players.txt")
