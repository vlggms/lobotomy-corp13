//This literally just exists because I couldn't figure out another way to have a global var. My apologies to whoever is dealing with this spaghetti bullshit in the future.
//-Bootlegbow

//This has been deshittified. Thank you for your service.
//-Kitsunemitsu

SUBSYSTEM_DEF(maptype)
	name = "Map Type"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MAPTYPE
	var/maptype = "lc13"//for the love of god, do not change the default we will all die -Bootlegbow

	//All the map tags that delete all jobs and replace them with others.
	var/list/clearmaps = list("rcorp")

	//All the map tags that are combat maps and need abnos to breach immediately
	var/list/combatmaps = list("rcorp")

	//Ghosts should be possessbale at all times
	var/list/autopossess = list("rcorp")

	//These end after 40 minutes.
	var/list/autoend = list("rcorp")

	//What departments are we looking at
	var/list/departments = list("Command","Security","Service")

/datum/controller/subsystem/maptype/Initialize()
	..()

	//Badda Bing Badda Da. This makes the latejoin menu cleaner
	switch(SSmaptype.maptype)
		if("wonderlabs")
			departments = list("Command", "Security", "Service", "Science")
		if("rcorp")
			departments = list("Command", "Security")

	var/list/all_jobs = subtypesof(/datum/job)
	if(!all_jobs.len)
		to_chat(world, "<span class='boldannounce'>Error setting up jobs, no job datums found</span>")
		return FALSE

	//Make ghosts able to possess things
	if(maptype in autopossess)
		SSlobotomy_corp.enable_possession = TRUE
