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
	/// Amount of times PostSpawn() proc has been called. Kept separate from times_fired because admins love to call fire() manually
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
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OnOrdealEnd))
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
	// ALEPH and WAW
	if(spawned_abnos >= rooms_start * 0.75)
		if(spawned_abnos >= rooms_start - 2) // Last two picks will always be ALEPHs
			available_levels = list(ALEPH_LEVEL)
		else
			available_levels = list(WAW_LEVEL, ALEPH_LEVEL)

	// WAW only
	else if(spawned_abnos >= rooms_start * 0.63)
		available_levels = list(WAW_LEVEL)

	// WAW and HE
	else if(spawned_abnos >= rooms_start * 0.5)
		available_levels = list(WAW_LEVEL, HE_LEVEL)

	// HE only
	else if(spawned_abnos >= rooms_start * 0.37)
		available_levels = list(HE_LEVEL)

	// HE and TETH
	else if(spawned_abnos >= rooms_start * 0.25)
		available_levels = list(HE_LEVEL, TETH_LEVEL)

	// TETH only
	else if(spawned_abnos >= 2) // Always exactly two ZAYINs
		available_levels = list(TETH_LEVEL)

	// Roll the abnos from available levels
	if(!ispath(queued_abnormality) && LAZYLEN(possible_abnormalities))
		PickAbno()

/datum/controller/subsystem/abnormality_queue/proc/PostSpawn()
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

/datum/controller/subsystem/abnormality_queue/proc/PickAbno()
	if(!LAZYLEN(available_levels))
		return FALSE
	/// List of threat levels that we will pick
	var/list/picking_levels = list()
	for(var/threat in available_levels)
		if(!LAZYLEN(possible_abnormalities[threat]))
			continue
		picking_levels |= threat
	if(!LAZYLEN(picking_levels))
		return FALSE

	// There we select the abnormalities
	picking_abnormalities = list()
	var/pick_count = GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT)
	var/list/picked_levs = list()
	for(var/i = 1 to pick_count)
		if(!LAZYLEN(possible_abnormalities))
			break
		var/lev = pick(picking_levels)
		// If we have more options to fill and we have multiple available levels - force them in.
		// This prevents situations where you have WAW and HE available, but only get HE abnos.
		if((lev in picked_levs) && length(picking_levels) > 1 && prob(((i + 1) / pick_count) * 100))
			picking_levels -= lev
			// And pick again
			lev = pick(picking_levels)
		picked_levs |= lev
		if(!LAZYLEN(possible_abnormalities[lev] - picking_abnormalities))
			continue
		var/chosen_abno = PickWeightRealNumber(possible_abnormalities[lev] - picking_abnormalities)
		picking_abnormalities += chosen_abno
	if(!LAZYLEN(picking_abnormalities))
		return FALSE
	queued_abnormality = pick(picking_abnormalities)
	return TRUE

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
	INVOKE_ASYNC(src, PROC_REF(SpawnOrdealAbnos), level_threat)

/datum/controller/subsystem/abnormality_queue/proc/SpawnOrdealAbnos(level_threat = 1)
	// Spawn stuff until we reach the desired threat level, or spawn too many things
	for(var/i = 1 to 4)
		SpawnAbno()
		sleep(30 SECONDS)
		if(level_threat in available_levels)
			break
