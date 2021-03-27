/proc/load_trusted_players()
	if(fexists("[global.config.directory]/trusted_players.txt"))
		var/list/lines = world.file2list("[global.config.directory]/trusted_players.txt")
		for(var/line in lines)
			if(!length(line))
				continue
			if(findtextEx(line, "#", 1, 2))
				continue
			GLOB.trusted_players += line
