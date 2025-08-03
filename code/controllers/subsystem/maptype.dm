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
	var/list/clearmaps = list("rcorp", "city", "wcorp", "limbus_labs", "fixers", "office")

	//LC13 Maps, this enables Traits and cores
	var/list/lc_maps = list("standard", "fishing")

	//LC13 Gamemode Traits
	var/list/lc_trait = list(
						//Actual traits
						FACILITY_TRAIT_MOBA_AGENTS = 10, 		//Agents pick a MOBA class
						FACILITY_TRAIT_CRITICAL_HITS = 10,		//EGO can Critical hit.
						FACILITY_TRAIT_DEPARTMENTAL_BUFFS = 10,	//Departmental Agent Buffs
						FACILITY_TRAIT_XP_MOD = 7,				//XP works differently on HP/SP
						FACILITY_TRAIT_ABNO_BLITZ = 3,			//The game is significantly Faster, starts after noon.
						FACILITY_TRAIT_DAMAGE_TYPE_SHUFFLE = 2, //Shuffles all lob corp color damage types randomly. Attack and armor damage types shuffled separately.

						//Joke stuff is below, should all be low
						FACILITY_TRAIT_WORKING_CLERKS = 2,		//For the joke
						FACILITY_TRAIT_CALLBACK = 2,			//Brings back 2 Classic bugs in Backpack EGO and wounds
						FACILITY_TRAIT_JOKE_ABNOS = 1,			// Okay it's funny
						FACILITY_TRAIT_VISIBLE_GHOSTS = 1,		// Very Metagamey but funny
						FACILITY_TRAIT_PLAYABLES = 1,			//I'm going to kill myself

						//Disabled traits becuase these suck lmao
						//FACILITY_TRAIT_LEGACY_PALE = 0,			//You take 90% damage if pale damage hits you
						//FACILITY_TRAIT_FUCKED_SELECTION = 0,	//The abno selection is randomized
						)

	var/chosen_trait = "No Trait"

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
	if(SSmaptype.maptype in SSmaptype.lc_maps)
		if(prob(40))	//40% chance to not run a station trait
			return
		chosen_trait = pickweight(lc_trait)
		switch(chosen_trait)
			if(FACILITY_TRAIT_VISIBLE_GHOSTS)
				var/msg = span_warning("You suddenly feel extremely obvious...")
				set_observer_default_invisibility(0, msg)
			if(FACILITY_TRAIT_DAMAGE_TYPE_SHUFFLE)
				GLOB.damage_type_shuffler.is_enabled = TRUE

			if(FACILITY_TRAIT_PLAYABLES)
				if(!SSlobotomy_corp.enable_possession)
					SSlobotomy_corp.enable_possession = TRUE

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
