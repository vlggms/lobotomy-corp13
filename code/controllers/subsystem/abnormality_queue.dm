#define ABNORMALITY_DELAY 180 SECONDS

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
	var/list/all_abnos = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn))
			possible_abnormalities[initial(abno.threat_level)] += abno
	if(LAZYLEN(possible_abnormalities))
		pick_abno()
	rooms_start = GLOB.abnormality_room_spawners.len
	next_abno_spawn_time -= min(2, rooms_start * 0.05) MINUTES // 20 rooms will decrease wait time by 1 minute
	..()

/datum/controller/subsystem/abnormality_queue/fire()
	if(world.time >= next_abno_spawn)
		SpawnAbno()

/datum/controller/subsystem/abnormality_queue/proc/SpawnAbno()
	// Earlier in the game, abnormalities will spawn faster and then slow down a bit
	next_abno_spawn = world.time + next_abno_spawn_time + ((min(16, spawned_abnos) - 4) * 6) SECONDS
	// HE enabled, ZAYIN disabled
	if(spawned_abnos > rooms_start * 0.2 && spawned_abnos <= rooms_start * 0.6)
		if(ZAYIN_LEVEL in available_levels)
			available_levels -= ZAYIN_LEVEL
		available_levels |= HE_LEVEL
	// WAW enabled, TETH disabled
	if(spawned_abnos > rooms_start * 0.4 && spawned_abnos <= rooms_start * 0.9)
		if(TETH_LEVEL in available_levels)
			available_levels -= TETH_LEVEL
		available_levels |= WAW_LEVEL
	// ALEPH enabled, HE disabled
	if(spawned_abnos > rooms_start * 0.6)
		if(HE_LEVEL in available_levels)
			available_levels -= HE_LEVEL
		available_levels |= ALEPH_LEVEL
	// WAW disabled; Pick an ALEPH, weakling
	if(spawned_abnos > rooms_start * 0.9)
		if(LAZYLEN(possible_abnormalities[ALEPH_LEVEL]) && (WAW_LEVEL in available_levels))
			available_levels -= WAW_LEVEL
		else // If we ran out of ALEPHs, somehow
			available_levels |= WAW_LEVEL

	if(!ispath(queued_abnormality) && LAZYLEN(possible_abnormalities))
		pick_abno()

	if(!LAZYLEN(GLOB.abnormality_room_spawners))
		return

	var/obj/effect/spawner/abnormality_room/choice = pick(GLOB.abnormality_room_spawners)

	if(istype(choice) && ispath(queued_abnormality))
		addtimer(CALLBACK(choice, .obj/effect/spawner/abnormality_room/proc/SpawnRoom))

	if(fucked_it_lets_rolled)
		for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.abnormality_queue_consoles)
			Q.ChangeLock(FALSE)
		fucked_it_lets_rolled = FALSE

/datum/controller/subsystem/abnormality_queue/proc/postspawn()
	if(queued_abnormality)
		possible_abnormalities[initial(queued_abnormality.threat_level)] -= queued_abnormality
		for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.abnormality_queue_consoles)
			Q.audible_message("<span class='notice'>[initial(queued_abnormality.name)] has arrived at the facility!</span>")
			playsound(get_turf(Q), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
			Q.updateUsrDialog()
		queued_abnormality = null
		if(spawned_abnos == 0)
			available_levels = list(ZAYIN_LEVEL, TETH_LEVEL)
		spawned_abnos++
		pick_abno()

/datum/controller/subsystem/abnormality_queue/proc/pick_abno()
	var/list/picking_abno = list()
	picking_abnormalities = list()
	for(var/lev in available_levels)
		if(!LAZYLEN(possible_abnormalities[lev]))
			continue
		picking_abno |= possible_abnormalities[lev]
	for(var/i = 1 to 3)
		if(!LAZYLEN(picking_abno))
			break
		var/chosen_abno = pick(picking_abno)
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
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.abnormality_queue_consoles)
		Q.visible_message("<span class='notice'>All the initial abnormalities have arrived. Have a nice day.</span>")
	return

/datum/controller/subsystem/abnormality_queue/proc/AnnounceLock()
	fucked_it_lets_rolled = TRUE
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.abnormality_queue_consoles)
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

	return pick(picking_abno)
