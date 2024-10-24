#define TRUSTEDPLAYERS "[global.config.directory]/trusted_players.txt"
#define MENTORPLAYERS "[global.config.directory]/mentors.txt"

GLOBAL_LIST(trusted_players)
GLOBAL_LIST(mentor_players)


/proc/load_trusted_players()
	GLOB.trusted_players = list()
	for(var/line in world.file2list(TRUSTEDPLAYERS))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.trusted_players[ckey(line)] = TRUE //Associative so we can check it much faster

/proc/is_trusted_player(client/user)
	if(GLOB.trusted_players[user.ckey])
		return TRUE
	if(check_rights(R_ADMIN, FALSE))
		return TRUE
	return FALSE


//Mentor version

/proc/load_mentor_players()
	GLOB.mentor_players = list()
	for(var/line in world.file2list(MENTORPLAYERS))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.mentor_players[ckey(line)] = TRUE //Associative so we can check it much faster

/proc/is_mentor_player(client/user)
	if(user.ckey in GLOB.mentor_players)
		return TRUE
	if(check_rights(R_ADMIN, FALSE))
		return TRUE
	return FALSE

#undef TRUSTEDPLAYERS
#undef MENTORPLAYERS
//Thank god for skyrat.
