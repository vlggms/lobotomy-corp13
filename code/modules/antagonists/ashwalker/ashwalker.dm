/datum/team/ashwalkers
	name = "Ashwalkers"
	show_roundend_report = FALSE
	var/list/players_spawned = new

/datum/antagonist/ashwalker
	name = "Ash Walker"
	job_rank = ROLE_LAVALAND
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	prevent_roundtype_conversion = FALSE
	antagpanel_category = "Ash Walkers"
	var/datum/team/ashwalkers/ashie_team

/datum/antagonist/ashwalker/create_team(datum/team/team)
	if(team)
		ashie_team = team
		objectives |= ashie_team.objectives
	else
		ashie_team = new

/datum/antagonist/ashwalker/get_team()
	return ashie_team

