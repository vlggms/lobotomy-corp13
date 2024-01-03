#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8


/*
Reminder If this ss breaks again or things are weird,
	the final step would be to just cram in a identifier of each thing calling map_loader_begin/map_loader_stop procs in the params
	Then we will just log everything into lists to find the culprits next to the initialized value, and have to do something other than port a tg pr
	Afterall it doesn't matter so much as long as initialized is not fuckin stuck on anything other than 1 aka INITIALIZATION_INNEW_REGULAR
	But for now heres 	https://github.com/tgstation/tgstation/pull/64705
	Along with 		  	https://github.com/tgstation/tgstation/pull/69742
*/
SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	/// A count of how many initalize changes we've made. We want to prevent old_initialize being overriden by some other value, breaking init code
	var/initialized_changed = 0

	var/old_initialized

	var/list/late_loaders = list()

	var/list/BadInitializeCalls = list()

	///initAtom() adds the atom its creating to this list iff InitializeAtoms() has been given a list to populate as an argument
	var/list/created_atoms
	// ^ if this is not null after InitializeAtoms() is done, this list will fill up with every atom in the world initialized afterwards!

	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/Initialize(timeofday)
	GLOB.fire_overlay.appearance_flags = RESET_COLOR
	setupGenetics() //to set the mutations' sequence

	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	initialized = INITIALIZATION_INNEW_REGULAR
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms, list/atoms_to_return = null)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	set_tracked_initalized(INITIALIZATION_INNEW_MAPLOAD)

	// This may look a bit odd, but if the actual atom creation runtimes for some reason, we absolutely need to set initialized BACK
	CreateAtoms(atoms, atoms_to_return)
	clear_tracked_initalize()

	if(late_loaders.len)
		for(var/I in 1 to late_loaders.len)
			var/atom/A = late_loaders[I]
			//I hate that we need this
			if(QDELETED(A))
				continue
			A.LateInitialize()
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()


	if (created_atoms)
		atoms_to_return += created_atoms
		created_atoms = null

/// Actually creates the list of atoms. Exists soley so a runtime in the creation logic doesn't cause initalized to totally break
/datum/controller/subsystem/atoms/proc/CreateAtoms(list/atoms, list/atoms_to_return)
	if (atoms_to_return)
		LAZYINITLIST(created_atoms)

	#ifdef TESTING
	var/count
	#endif

	var/list/mapload_arg = list(TRUE)

	if(atoms)

		#ifdef TESTING
		count = atoms.len
		#endif

		for(var/I in 1 to atoms.len)
			var/atom/A = atoms[I]
			if(!(A.flags_1 & INITIALIZED_1))
				CHECK_TICK
				InitAtom(A, mapload_arg)
	else

		#ifdef TESTING
		count = 0
		#endif

		for(var/atom/A as anything in world)
			if(!(A.flags_1 & INITIALIZED_1))
				InitAtom(A, mapload_arg)
				#ifdef TESTING
				++count
				#endif
				CHECK_TICK

	testing("Initialized [count] atoms")


/// Init this specific atom
/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	switch(result)
		if(INITIALIZE_HINT_NORMAL)
			// pass
		if(INITIALIZE_HINT_LATELOAD)
			if(arguments[1])	//mapload
				late_loaders += A
			else
				A.LateInitialize()
		if(INITIALIZE_HINT_QDEL)
			qdel(A)
			qdeleted = TRUE
		else
			BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.flags_1 & INITIALIZED_1))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT
	else
		SEND_SIGNAL(A,COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE)

	if (created_atoms)
		created_atoms += A

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	set_tracked_initalized(INITIALIZATION_INSSATOMS)

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	clear_tracked_initalize()

/// Use this to set initialized to prevent error states where old_initialized is overriden. It keeps happening and it's cheesing me off
/datum/controller/subsystem/atoms/proc/set_tracked_initalized(value)
	if(!initialized_changed)
		old_initialized = initialized
		initialized = value
	else
		stack_trace("We started maploading while we were already maploading. You doing something odd?")
	initialized_changed += 1

/datum/controller/subsystem/atoms/proc/clear_tracked_initalize()
	initialized_changed -= 1
	if(!initialized_changed)
		initialized = old_initialized


/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_initialized = SSatoms.old_initialized

	BadInitializeCalls = SSatoms.BadInitializeCalls


/datum/controller/subsystem/atoms/proc/setupGenetics()
	var/list/mutations = subtypesof(/datum/mutation/human)
	shuffle_inplace(mutations)
	for(var/A in subtypesof(/datum/generecipe))
		var/datum/generecipe/GR = A
		GLOB.mutation_recipes[initial(GR.required)] = initial(GR.result)
	for(var/i in 1 to LAZYLEN(mutations))
		var/path = mutations[i] //byond gets pissy when we do it in one line
		var/datum/mutation/human/B = new path ()
		B.alias = "Mutation [i]"
		GLOB.all_mutations[B.type] = B
		GLOB.full_sequences[B.type] = generate_gene_sequence(B.blocks)
		GLOB.alias_mutations[B.alias] = B.type
		if(B.locked)
			continue
		if(B.quality == POSITIVE)
			GLOB.good_mutations |= B
		else if(B.quality == NEGATIVE)
			GLOB.bad_mutations |= B
		else if(B.quality == MINOR_NEGATIVE)
			GLOB.not_good_mutations |= B
		CHECK_TICK

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[GLOB.log_directory]/initialize.log")
