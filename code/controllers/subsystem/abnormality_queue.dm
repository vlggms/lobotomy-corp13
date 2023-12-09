#define ABNORMALITY_DELAY 180 SECONDS

/*
* The system was coded as a proof of concept long ago, and might need a good rework.
* Ideally, you should have a certain amount of abnormalities per their threat level.
* For example, an "ideal" composition would be close to this:
* ZAYIN: 2
* TETH: 4
* HE: 6
* WAW: 8
* ALEPH: 4
*/

SUBSYSTEM_DEF(abnormality_queue)
	name = "Abnormality Queue"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	wait = 10 SECONDS

	/// List of(preferably) 3 abnormalities available for manager to choose from.
	var/list/picking_abnormalities = list()
	/// The abnormality that will spawn on the next fire.
	var/mob/living/simple_animal/hostile/abnormality/queued_abnormality
	/// The subsystem will pick abnormalities of these threat levels.
	var/list/available_levels = list(ZAYIN_LEVEL)
	/// An associative list of potential abnormalities.
	var/list/possible_abnormalities = list(ZAYIN_LEVEL = list(), TETH_LEVEL = list(), HE_LEVEL = list(), WAW_LEVEL = list(), ALEPH_LEVEL = list())
	/// Amount of abnormality room spawners at the round-start.
	var/rooms_start = 0
	/// Amount of times postspawn() proc has been called. Kept separate from times_fired because admins love to call fire() manually
	var/spawned_abnos = 0
	// I am using this all because default subsystem waiting and next_fire is done in a very... interesting way.
	/// World time at which new abnormality will be spawned
	var/next_abno_spawn = INFINITY
	/// Wait time for next abno spawn; This time is further affected by amount of abnos in facility
	var/next_abno_spawn_time = 4 MINUTES
	/// Tracks if the current pick is forced
	var/fucked_it_lets_rolled = FALSE
	/// Due to Managers not passing the Litmus Test, divine approval is now necessary for red roll
	var/hardcore_roll_enabled = FALSE

/datum/controller/subsystem/abnormality_queue/Initialize(timeofday)
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, .proc/OnOrdealEnd)
	rooms_start = GLOB.abnormality_room_spawners.len
	next_abno_spawn_time -= min(2, rooms_start * 0.05) MINUTES // 20 rooms will decrease wait time by 1 minute
	..()

/datum/controller/subsystem/abnormality_queue/fire()
	if(world.time >= next_abno_spawn)
		SpawnAbno()

/datum/controller/subsystem/abnormality_queue/proc/SpawnAbno()
	// Earlier in the game, abnormalities will spawn faster and then slow down a bit
	next_abno_spawn = world.time + next_abno_spawn_time + ((min(16, spawned_abnos) - 6) * 6) SECONDS

	if(!LAZYLEN(GLOB.abnormality_room_spawners))
		return

	var/obj/effect/spawner/abnormality_room/choice = pick(GLOB.abnormality_room_spawners)
	if(istype(choice) && ispath(queued_abnormality))
		choice.SpawnRoom()

	if(fucked_it_lets_rolled)
		for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
			Q.ChangeLock(FALSE)
		fucked_it_lets_rolled = FALSE

	SelectAvailableLevels()

// Abno level selection
/datum/controller/subsystem/abnormality_queue/proc/SelectAvailableLevels()
	// ALEPH enabled, WAW disabled
	if(spawned_abnos >= rooms_start * 0.83)
		if(LAZYLEN(possible_abnormalities[ALEPH_LEVEL]))  // 8 WAWs (20 abnos) + 4 ALEPHs (24 abnos)
			available_levels = list(ALEPH_LEVEL)
		else // If we ran out of ALEPHs, somehow
			available_levels = list(WAW_LEVEL)

	// WAW enabled, HE disabled
	else if(spawned_abnos >= rooms_start * 0.5) // 6 HEs (12 abnos)
		available_levels = list(WAW_LEVEL)

	// HE enabled, TETH disabled
	else if(spawned_abnos >= rooms_start * 0.25) // 4 TETHs (6 abnos)
		available_levels = list(HE_LEVEL)

	// TETH enabled, ZAYIN disabled
	else if(spawned_abnos >= rooms_start * 0.08) // 2 ZAYINs
		available_levels = list(TETH_LEVEL)

	// Roll the abnos from available levels
	if(!ispath(queued_abnormality) && LAZYLEN(possible_abnormalities))
		pick_abno()

/datum/controller/subsystem/abnormality_queue/proc/postspawn()
	if(queued_abnormality)
		if(possible_abnormalities[initial(queued_abnormality.threat_level)][queued_abnormality] <= 0)
			stack_trace("Queued abnormality had no weight!?")
		possible_abnormalities[initial(queued_abnormality.threat_level)] -= queued_abnormality
		for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
			Q.audible_message("<span class='announce'>[initial(queued_abnormality.name)] has arrived at the facility!</span>")
			playsound(get_turf(Q), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
			Q.updateUsrDialog()
		queued_abnormality = null
		spawned_abnos++

/datum/controller/subsystem/abnormality_queue/proc/pick_abno()
	var/list/picking_abno = list()
	picking_abnormalities = list()
	for(var/lev in available_levels)
		if(!LAZYLEN(possible_abnormalities[lev]))
			continue
		picking_abno |= possible_abnormalities[lev]
	for(var/i = 1 to GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT))
		if(!LAZYLEN(picking_abno))
			break
		var/chosen_abno = pickweight(picking_abno)
		picking_abnormalities += chosen_abno
		picking_abno -= chosen_abno
	if(!LAZYLEN(picking_abnormalities))
		return
	queued_abnormality = pick(picking_abnormalities)

/datum/controller/subsystem/abnormality_queue/proc/HandleStartingAbnormalities()
	var/player_count = GLOB.clients.len
	var/i
	for(i=1 to round(clamp(player_count, 5, 30) / 5))
		sleep(15 SECONDS) // Allows manager to select abnormalities if he is fast enough.
		SpawnAbno()
	message_admins("[i] round-start abnormalities have been spawned.")
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		Q.audible_message("<span class='announce'>All the initial Abnormalities have arrived. Have a nice day Manager.</span>")
	return

/datum/controller/subsystem/abnormality_queue/proc/AnnounceLock()
	fucked_it_lets_rolled = TRUE
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		Q.ChangeLock(TRUE)
	return

/datum/controller/subsystem/abnormality_queue/proc/ClearChoices()
	picking_abnormalities = list() // LAZY BUT WHATEVER
	return

/datum/controller/subsystem/abnormality_queue/proc/GetRandomPossibleAbnormality()
	var/list/picking_abno = list()

	for(var/level in available_levels)
		if(!LAZYLEN(possible_abnormalities[level]))
			continue
		picking_abno |= possible_abnormalities[level]

	return pickweight(picking_abno)

// Spawns abnos faster if you lack abnos of that level
/datum/controller/subsystem/abnormality_queue/proc/OnOrdealEnd(datum/source, datum/ordeal/O = null)
	SIGNAL_HANDLER
	if(!istype(O))
		return
	if(O.level > 3 || O.level < 1)
		return
	var/level_threat = O.level + 2 // Dusk will equal to ALEPH here
	// Already in there, oops
	if(level_threat in available_levels)
		return
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		Q.audible_message("<span class='announce'>Due to [O.name] finishing early, additional abnormalities will be extracted soon.</span>")
	INVOKE_ASYNC(src, .proc/SpawnOrdealAbnos, level_threat)

/datum/controller/subsystem/abnormality_queue/proc/SpawnOrdealAbnos(level_threat = 1)
	// Spawn stuff until we reach the desired threat level, or spawn too many things
	for(var/i = 1 to 4)
		SpawnAbno()
		sleep(30 SECONDS)
		if(level_threat in available_levels)
			break
