//Used to call the quirk subsystem and handle backstories for roundstart
// - Mostly copied off the quirk subsystem
// - Backstories are stored in a datum
PROCESSING_SUBSYSTEM_DEF(backstories)
	name = "Backstories"
	init_order = INIT_ORDER_BACKSTORIES
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	var/list/backstories = list()		//Assoc. list of all roundstart backstory datum types; "name" = /path/

/datum/controller/subsystem/processing/backstories/Initialize(timeofday)
	if(!backstories.len)
		SetupBackstories()
	return ..()

/datum/controller/subsystem/processing/backstories/proc/SetupBackstories()
	// Sort by type then by name
	var/list/backstory_list = sortList(subtypesof(/datum/backstory), GLOBAL_PROC_REF(cmp_backstory_asc))

	for(var/V in backstory_list)
		var/datum/backstory/T = V
		backstories[initial(T.name)] = T

/proc/cmp_backstory_asc(datum/backstory/A, datum/backstory/B)
	var/a_name = initial(A.name)
	var/b_name = initial(B.name)
	return sorttext(b_name, a_name)
