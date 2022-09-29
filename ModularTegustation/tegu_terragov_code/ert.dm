// TerraGov Marines
/datum/antagonist/ert/terragov
	name = "TerraGov Marine" // They are from another universe, ooOooOoo!
	outfit = /datum/outfit/terragov/marine
	role = "Marine"

/datum/antagonist/ert/terragov/greet()
	if(!ert_team)
		return

	to_chat(owner, "<B><font size=3 color=red>You are a [name].</font></B>")
	to_chat(owner, "<B><font size=3 color=red>You have come to this place from another universe!</font></B>")
	var/missiondesc = "Your squad is being sent on a mission to [station_name()] by TerraGov high command."
	if(leader) //If Squad Leader
		missiondesc += " Lead your squad to ensure the completion of the mission. Board the shuttle when your team is ready."
	else
		missiondesc += " Follow orders given to you by your squad leader."
	if(!rip_and_tear)
		missiondesc += "Avoid human casualties whenever possible; Non-human casualties are fine."

	missiondesc += "<BR><B>Your Mission</B> : [ert_team.mission.explanation_text]"
	to_chat(owner,missiondesc)

/datum/antagonist/ert/terragov/leader
	name = "CityGov Squad Leader"
	role = "Squad Leader"

/datum/antagonist/ert/terragov/heavy
	outfit = /datum/outfit/terragov/marine/armored
	rip_and_tear = TRUE

/datum/antagonist/ert/terragov/leader/heavy
	outfit = /datum/outfit/terragov/marine/armored
	rip_and_tear = TRUE

// TerraGov Official
/datum/antagonist/ert/terragov/official
	name = "TerraGov Official"
	show_name_in_check_antagonists = TRUE
	var/datum/objective/mission
	role = "Inspector"
	random_names = FALSE
	outfit = /datum/outfit/terragov

//message on spawn

/datum/antagonist/ert/terragov/official/greet()
	to_chat(owner, "<B><font size=3 color=red>You are a TerraGov Official.</font></B>")
	to_chat(owner, "<B><font size=3 color=red>You have come to this place from another universe!</font></B>")

	if (ert_team)
		to_chat(owner, "CityGov is sending you to [station_name()] with the task: [ert_team.mission.explanation_text]")
	else
		to_chat(owner, "TerraGov is sending you to [station_name()] with the task: [mission.explanation_text]")


/datum/antagonist/ert/terragov/official/forge_objectives()
	if (ert_team)
		return ..()
	if(mission)
		return
	var/datum/objective/missionobj = new ()
	missionobj.owner = owner
	missionobj.explanation_text = "Investigate the situation on the [station_name()]."
	missionobj.completed = TRUE
	mission = missionobj
	objectives |= mission

// ERT Datums
/datum/ert/terragov
	leader_role = /datum/antagonist/ert/terragov/leader
	roles = list(/datum/antagonist/ert/terragov)
	code = "TG - C"
	rename_team = "TerraGov Intervention Squad"
	polldesc = "a TerraGov Intervention Squad"

/datum/ert/terragov/heavy
	leader_role = /datum/antagonist/ert/terragov/leader/heavy
	roles = list(/datum/antagonist/ert/terragov/heavy)
	code = "TG - B"
	rename_team = "Heavy TerraGov Intervention Squad"
	polldesc = "a Heavy TerraGov Intervention Squad"

/datum/ert/terragov/official
	code = "TG - D"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/ert/terragov/official
	roles = list(/datum/antagonist/ert/terragov/official)
	rename_team = "TerraGov Official"
	polldesc = "a TerraGov Official"
	mission = "Investigate the situation on the station."
	opendoors = FALSE
	random_names = FALSE
	leader_experience = FALSE
