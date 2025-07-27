/datum/crew_manifest

/datum/crew_manifest/ui_state(mob/user)
	return GLOB.always_state

/datum/crew_manifest/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || isAI(user) || ispAI(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/crew_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewManifest")
		ui.open()

/datum/crew_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

/datum/crew_manifest/ui_data(mob/user)
	var/list/positions = list(
		// LOBOTOMYCORPORATION ADDITION START
		"W Corp" = list("exceptions" = list(), "open" = 0),
		"R Corp" = list("exceptions" = list(), "open" = 0),
		"Hana" = list("exceptions" = list(), "open" = 0),
		"Association" = list("exceptions" = list(), "open" = 0),
		"Syndicate" = list("exceptions" = list(), "open" = 0),
		"Fixers" = list("exceptions" = list(), "open" = 0),
		// LOBOTOMYCORPORATION ADDITION END
		"Command" = list("exceptions" = list(), "open" = 0),
		"Security" = list("exceptions" = list(), "open" = 0),
		"Engineering" = list("exceptions" = list(), "open" = 0),
		"Medical" = list("exceptions" = list(), "open" = 0),
		"Misc" = list("exceptions" = list(), "open" = 0),
		"Science" = list("exceptions" = list(), "open" = 0),
		"Supply" = list("exceptions" = list(), "open" = 0),
		"Service" = list("exceptions" = list(), "open" = 0),
		"Silicon" = list("exceptions" = list(), "open" = 0)
	)
	var/list/departments = list(
		// LOBOTOMYCORPORATION ADDITION START
		list("flag" = DEPARTMENT_W_CORP, "name" = "W Corp"),
		list("flag" = DEPARTMENT_R_CORP, "name" = "R Corp"),
		list("flag" = DEPARTMENT_HANA, "name" = "Hana"),
		list("flag" = DEPARTMENT_ASSOCIATION, "name" = "Association"),
		list("flag" = DEPARTMENT_CITY_ANTAGONIST, "name" = "Syndicate"),
		list("flag" = DEPARTMENT_FIXERS, "name" = "Fixers"),
		// LOBOTOMYCORPORATION ADDITION END
		list("flag" = DEPARTMENT_COMMAND, "name" = "Command"),
		list("flag" = DEPARTMENT_SECURITY, "name" = "Security"),
		list("flag" = DEPARTMENT_ENGINEERING, "name" = "Engineering"),
		list("flag" = DEPARTMENT_MEDICAL, "name" = "Medical"),
		list("flag" = DEPARTMENT_SCIENCE, "name" = "Science"),
		list("flag" = DEPARTMENT_CARGO, "name" = "Supply"),
		list("flag" = DEPARTMENT_SERVICE, "name" = "Service"),
		list("flag" = DEPARTMENT_SILICON, "name" = "Silicon"),
	)

// LOBOTOMYCORPORATION EDIT OLD START
/*
	for(var/job in SSjob.occupations)
		// Check if there are additional open positions or if there is no limit
		if ((job["total_positions"] > 0 && job["total_positions"] > job["current_positions"]) || (job["total_positions"] == -1))
			for(var/department in departments)
				// Check if the job is part of a department using its flag
				// Will return true for Research Director if the department is Science or Command, for example
				if(job["departments"] & department["flag"])
					if(job["total_positions"] == -1)
						// Add job to list of exceptions, meaning it does not have a position limit
						positions[department["name"]]["exceptions"] += list(job["title"])
					else
						// Add open positions to current department
						positions[department["name"]]["open"] += (job["total_positions"] - job["current_positions"])
*/
// LOBOTOMYCORPORATION EDIT OLD END
// LOBOTOMYCORPORATION EDIT NEW START
	for(var/datum/job/job in SSjob.occupations)
		if((job.total_positions > 0 && job.total_positions > job.current_positions) || (job.total_positions == -1))
			for(var/department in departments)
				// Check if the job is part of a department using its flag
				// Will return true for Research Director if the department is Science or Command, for example
				if(job.departments & department["flag"])
					if(job.total_positions == -1)
						// Add job to list of exceptions, meaning it does not have a position limit
						positions[department["name"]]["exceptions"] += list(job.title)
					else
						// Add open positions to current department
						positions[department["name"]]["open"] += (job.total_positions - job.current_positions)
// LOBOTOMYCORPORATION EDIT NEW END

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
