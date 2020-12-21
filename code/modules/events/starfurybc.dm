/datum/round_event_control/starfurybc
	name = "Starfury Battle Cruiser"
	typepath = /datum/round_event/starfurybc
	weight = 3
	max_occurrences = 1
	min_players = 50
	earliest_start = 60 MINUTES
	gamemode_blacklist = list("nuclear")

/datum/round_event_control/starfurybc/preRunEvent()
	if (!SSmapping.empty_space)
		return EVENT_CANT_RUN
	var/deadMobs = 0
	for(var/mob/M in GLOB.dead_mob_list)
		if(M.client)
			deadMobs++
	if(deadMobs < round(GLOB.player_list/9))
		message_admins("Syndicate Battle Cruiser attempted to spawn, but there was only [deadMobs]/[round(GLOB.player_list/9)] ghosts.")
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/starfurybc
	startWhen = 130 //30 = 1 minute, apparently. Default: 130
	var/minimum_required = 5 //Default 5
	var/shuttle_spawned = FALSE
	var/started = FALSE
	var/announcetime = 1 MINUTES //Default minimum.

/datum/round_event/starfurybc/announce(fake)
	priority_announce("Unidentified ship detected on long range scanners. ETA [round((rand(-30,70) + startWhen)/30)] minutes.")
	if(fake)
		return
	deadchat_broadcast("Starfury Battle Cruiser will arrive in [round(startWhen/30)] minutes!", message_type=DEADCHAT_ANNOUNCEMENT)
	started = TRUE

/datum/round_event_control/starfurybc/debug
	name = "(DEBUG) Starfury Battle Cruiser"
	typepath = /datum/round_event/starfurybc/debug
	weight = 0 // Admin-only

/datum/round_event/starfurybc/debug
	startWhen = 10
	minimum_required = 1 //Default 5

/datum/round_event/starfurybc/start()
	spawn_shuttle()

/datum/round_event/starfurybc/proc/spawn_shuttle()
	shuttle_spawned = TRUE

	var/list/candidates = pollGhostCandidates("Do you wish to be considered for syndicate battlecruiser crew?", ROLE_TRAITOR)
	shuffle_inplace(candidates)
	if(candidates.len < minimum_required)
		deadchat_broadcast("Starfury Battle Cruiser event did not get enough candidates ([minimum_required]) to spawn.", message_type=DEADCHAT_ANNOUNCEMENT)
		return

	var/datum/map_template/ruin/space/starfury/ship = new
	var/x = rand(TRANSITIONEDGE,world.maxx - TRANSITIONEDGE - ship.width)
	var/y = rand(TRANSITIONEDGE,world.maxy - TRANSITIONEDGE - ship.height)
	var/z = SSmapping.empty_space.z_value
	var/turf/T = locate(x,y,z)
	if(!T)
		CRASH("SBC Starfury event found no turf to load in")

	if(!ship.load(T))
		CRASH("Loading SBC Starfury cruiser failed!")

	for(var/turf/A in ship.get_affected_turfs(T))
		for(var/obj/effect/mob_spawn/human/syndicate/spawner in A)
			if(candidates.len > 0)
				var/mob/M = candidates[1]
				spawner.create(M.ckey)
				candidates -= M
				announce_to_ghosts(M)
			else
				announce_to_ghosts(spawner)
		for(var/obj/docking_port/stationary/dock in A)
			dock.load_roundstart()

	announcetime += rand(1 MINUTES, 2 MINUTES)
	sleep(announcetime)
	priority_announce("Heavily armed ship, identified as Syndicate Battle Cruiser Starfury, has been detected in nearby sector. Brace for impact.", sound = 'sound/machines/alarm.ogg')
