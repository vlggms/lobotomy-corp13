//This literally just exists because I couldn't figure out another way to have a global var. My apologies to whoever is dealing with this spaghetti bullshit in the future.
//-Bootlegbow

//This has been deshittified. Thank you for your service.
//-Kitsunemitsu

//This sucks ass
//-Crabby

//We can make this better.
//-Mr. H

SUBSYSTEM_DEF(maptype)
	name = "Map Type"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MAPTYPE
	var/maptype = "lc13"			//for the love of god, do not change the default we will all die -Bootlegbow
	var/jobtype		//If a map RNGs which jobs are available, use this
	var/list/map_tags = list()//For specific mechanics that maptypes don't cover. This needs to be an array with brackets [] in the json.

	//All the map tags that delete all jobs and replace them with others.
	var/list/clearmaps = list("rcorp", "city", "wcorp", "limbus_labs", "fixers", "office")

	//LC13 Maps, this enables Traits and cores
	var/list/lc_maps = list("standard", "fishing")

	//All the map tags that are combat maps and need abnos to breach immediately
	var/list/combatmaps = list("rcorp", "wcorp", "limbus_labs", "fixers", "office")

	//Ghosts should be possessbale at all times
	var/list/autopossess = list("rcorp", "limbus_labs")

	//These end after a certain number of minutes.
	var/list/autoend = list("rcorp", "wcorp", "limbus_labs", "fixers", "office")

	//This map is city stuff
	var/list/citymaps = list("wonderlabs", "city", "fixers", "office", "lcorp_city")

	//This is for maps that incorporate space
	var/list/spacemaps = list("skeld")

	//This is for maps where crafting is enabled.
	var/list/craftingmaps = list("skeld", "limbus_labs", "enkephalin_rush")

	//Maps that give no fear. Everyone cannot work as is fear immune.
	var/list/nofear = list("limbus_labs")

	//What departments are we looking at
	var/list/departments = list("Command", "Security", "Service")



/datum/controller/subsystem/maptype/Initialize()
	..()

	//Badda Bing Badda Da. This makes the latejoin menu cleaner
	switch(SSmaptype.maptype)
		if("wonderlabs")
			departments = list("Command", "Fixers", "Security", "Service")
		if("city")
			departments = list("Command", "Hana", "Association", "Syndicate", "Fixers", "Medical", "Security", "Service")
		if("fixers")
			departments = list("Command", "Hana", "Association", "Fixers", "Medical", "Service")
		if("office")
			departments = list("Command", "Fixers")
		if("limbus_labs")
			departments = list("Command", "Security", "Medical", "Science", "Engineering", "Service" )
		if("rcorp")
			departments = list("Command", "R Corp", "Medical")
		if("wcorp")
			departments = list("Command", "W Corp")
		if("lcorp_city")
			departments = list("Command", "Security", "Service", "Association", "Fixers", "Medical")

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

			switch(rand(1,5))
				if(1)	 //Find this var in the objectives folder
					GLOB.rcorp_objective = "button"
				if(2)
					GLOB.rcorp_objective = "vip"
				if(3)
					GLOB.rcorp_objective = "arbiter"
				if(4)
					GLOB.rcorp_objective = "payload_rcorp"
				if(5)
					GLOB.rcorp_objective = "payload_abno"
