//This literally just exists because I couldn't figure out another way to have a global var. My apologies to whoever is dealing with this spaghetti bullshit in the future.
//-Bootlegbow

//This has been deshittified. Thank you for your service.
//-Kitsunemitsu

SUBSYSTEM_DEF(maptype)
	name = "Map Type"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MAPTYPE
	var/maptype = "lc13"			//for the love of god, do not change the default we will all die -Bootlegbow
	var/jobtype		//If a map RNGs which jobs are available, use this

	//All the map tags that delete all jobs and replace them with others.
	var/list/clearmaps = list("rcorp", "city", "wcorp", "limbus_labs")

	//All the map tags that are combat maps and need abnos to breach immediately
	var/list/combatmaps = list("rcorp", "wcorp", "limbus_labs")

	//Ghosts should be possessbale at all times
	var/list/autopossess = list("rcorp", "limbus_labs")

	//These end after a certain number of minutes.
	var/list/autoend = list("rcorp", "wcorp", "limbus_labs")

	//This map is city stuff
	var/list/citymaps = list("wonderlabs", "city")

	//This is for maps that incorporate space
	var/list/spacemaps = list("skeld")

	//This is for maps where crafting is enabled.
	var/list/craftingmaps = list("skeld", "limbus_labs")

	//Maps that give no fear. Everyone cannot work as is fear immune.
	var/list/nofear = list("limbus_labs")

	//What departments are we looking at
	var/list/departments = list("Command","Security","Service")


/datum/controller/subsystem/maptype/Initialize()
	..()

	//Badda Bing Badda Da. This makes the latejoin menu cleaner
	switch(SSmaptype.maptype)
		if("wonderlabs", "city")
			departments = list("Command", "Security", "Service", "Science")
		if("limbus_labs")
			departments = list("Command", "Security","Medical", "Science", "Service" )
		if("rcorp", "wcorp")
			departments = list("Command", "Security")

	var/list/all_jobs = subtypesof(/datum/job)
	if(!all_jobs.len)
		to_chat(world, "<span class='boldannounce'>Error setting up jobs, no job datums found</span>")
		return FALSE

	//Make ghosts able to possess things
	if(maptype in autopossess)
		SSlobotomy_corp.enable_possession = TRUE

	//All the maptype specific stuff
	switch(maptype)
		if("rcorp")	//For the gamemode stuff
			if(prob(30))
				jobtype = "rcorp_fifth"

			switch(rand(1,3))
				if(1)	 //Find this var in the objectives folder
					GLOB.rcorp_objective = "button"
				if(2)
					GLOB.rcorp_objective = "vip"
				if(3)
					GLOB.rcorp_objective = "arbiter"


