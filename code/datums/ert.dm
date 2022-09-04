/datum/ert
	var/mobtype = /mob/living/carbon/human
	var/team = /datum/team/ert
	var/opendoors = TRUE
	var/leader_role = /datum/antagonist/ert/commander
	var/enforce_human = TRUE
	var/roles = list(/datum/antagonist/ert/security, /datum/antagonist/ert/medic, /datum/antagonist/ert/engineer) //List of possible roles to be assigned to ERT members.
	var/rename_team
	var/code
	var/mission = "Assist the facility."
	var/teamsize = 5
	var/polldesc
	/// If TRUE, gives the team members "[role] [random last name]" style names
	var/random_names = TRUE
	/// If TRUE, the admin who created the response team will be spawned in the briefing room in their preferred briefing outfit (assuming they're a ghost)
	var/spawn_admin = FALSE
	/// If TRUE, we try and pick one of the most experienced players who volunteered to fill the leader slot
	var/leader_experience = TRUE

/datum/ert/New()
	if (!polldesc)
		polldesc = "a Code [code] N-Corporation Emergency Response Team"

/datum/ert/blue
	opendoors = FALSE
	code = "Blue"

/datum/ert/amber
	code = "Amber"

/datum/ert/red
	leader_role = /datum/antagonist/ert/commander/red
	roles = list(/datum/antagonist/ert/security/red, /datum/antagonist/ert/medic/red, /datum/antagonist/ert/engineer/red)
	code = "Red"

/datum/ert/deathsquad
	roles = list(/datum/antagonist/ert/deathsquad)
	leader_role = /datum/antagonist/ert/deathsquad/leader
	rename_team = "Deathsquad"
	code = "Delta"
	mission = "Leave no witnesses."
	polldesc = "an elite N-Corporation Strike Team"

/datum/ert/centcom_official
	code = "Green"
	teamsize = 1
	opendoors = FALSE
	leader_role = /datum/antagonist/ert/official
	roles = list(/datum/antagonist/ert/official)
	rename_team = "CentCom Officials"
	polldesc = "a CentCom Official"
	random_names = FALSE
	leader_experience = FALSE

/datum/ert/centcom_official/New()
	mission = "Conduct a routine performance review of [station_name()] and its Captain."

/datum/ert/inquisition
	roles = list(/datum/antagonist/ert/chaplain/inquisitor, /datum/antagonist/ert/security/inquisitor, /datum/antagonist/ert/medic/inquisitor)
	leader_role = /datum/antagonist/ert/commander/inquisitor
	rename_team = "Inquisition"
	mission = "Destroy any traces of paranormal activity aboard the station."
	polldesc = "a Nanotrasen paranormal response team"

/datum/ert/janitor
	roles = list(/datum/antagonist/ert/janitor, /datum/antagonist/ert/janitor/heavy)
	leader_role = /datum/antagonist/ert/janitor/heavy
	teamsize = 4
	opendoors = FALSE
	rename_team = "Janitor"
	mission = "Clean up EVERYTHING."
	polldesc = "a Nanotrasen Janitorial Response Team"

/datum/ert/intern
	roles = list(/datum/antagonist/ert/intern)
	leader_role = /datum/antagonist/ert/intern/leader
	teamsize = 7
	opendoors = FALSE
	rename_team = "Horde of Interns"
	mission = "Assist in conflict resolution."
	polldesc = "an unpaid internship opportunity with K-Corporation"
	random_names = FALSE

/datum/ert/intern/unarmed
	roles = list(/datum/antagonist/ert/intern/unarmed)
	leader_role = /datum/antagonist/ert/intern/leader/unarmed
	rename_team = "Unarmed Horde of Interns"

/datum/ert/erp
	roles = list(/datum/antagonist/ert/security/party, /datum/antagonist/ert/clown/party, /datum/antagonist/ert/engineer/party, /datum/antagonist/ert/janitor/party)
	leader_role = /datum/antagonist/ert/commander/party
	opendoors = FALSE
	rename_team = "Emergency Response Party"
	mission = "Create entertainment for the crew."
	polldesc = "a Code Rainbow Nanotrasen Emergency Response Party"
	code = "Rainbow"

/datum/ert/rabbit
	roles = list(/datum/antagonist/ert/security/rabbit)
	leader_role = /datum/antagonist/ert/commander/rabbit
	teamsize = 6
	opendoors = FALSE
	rename_team = "Rabbit Team"
	mission = "Dispose of any breaching abnormalities and avoid casualties if possible. Destroy any traitors immediately."
	polldesc = "Rabbit Squad, R-Corporation's combat team that specializes in fighting abnormals as a unit."
	code = "Orange"

/datum/ert/rhino
	roles = list(/datum/antagonist/ert/security/rhino)
	leader_role = /datum/antagonist/ert/commander/rhino
	teamsize = 1
	opendoors = TRUE
	rename_team = "Rhino Team"
	mission = "Dispose of any breaching abnormalities and try not to damage the facility, but the last one's a soft rule."
	polldesc = "Rhino Squad, R-Corporation's full force combat team, each in a powerful combat mech suit."
	code = "Orange"

/datum/ert/zwei
	roles = list(/datum/antagonist/ert/zwei_shield, /datum/antagonist/ert/zwei_shield/veteran)
	leader_role = /datum/antagonist/ert/zwei_shield/captain
	opendoors = TRUE
	rename_team = "Zwei Shield Unit"
	mission = "Preserve the lives of the client employees, remove all clear and evident threats to their safety."
	polldesc = "Zwei Shieldbearers, swordsmen with squad tactics and professional attitude."

/datum/ert/hardhead
	roles = list(/datum/antagonist/ert/hardhead, /datum/antagonist/ert/hardhead/fireaxe, /datum/antagonist/ert/hardhead/shotgun)
	leader_role = /datum/antagonist/ert/hardhead/foreman
	opendoors = TRUE
	rename_team = "Hardhead Wrecking Crew"
	mission = "You've been hired to wreck whatever's causing a mess with your buddies by your side. Get 'er done!"
	polldesc = "Hardhead Office, former wageslaves who formed an office that clears piles of rubble, yet usually make more of it."
