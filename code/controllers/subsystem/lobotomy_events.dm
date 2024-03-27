#define APOCALYPSE 1
#define YINYANG 2
SUBSYSTEM_DEF(lobotomy_events)
	name = "Lobotomy Corp Events"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 10 SECONDS


	//Apocalypse Bird
	var/list/AB_types = list(
		/mob/living/simple_animal/hostile/abnormality/punishing_bird,
		/mob/living/simple_animal/hostile/abnormality/big_bird,
		/mob/living/simple_animal/hostile/abnormality/judgement_bird)
	var/list/AB_breached = list()

	// Yin and Yang
	var/list/YY_types = list(
		/mob/living/simple_animal/hostile/abnormality/yin,
		/mob/living/simple_animal/hostile/abnormality/yang
	)
	var/list/YY_breached = list()
	var/turf/YY_middle = null
	var/yin_downed = TRUE
	var/yang_downed = TRUE

	///God of the Seasons
	var/current_season
	var/list/seasons = list("spring", "summer", "fall", "winter")
	var/list/seasons_weather_list = list(/datum/weather/thunderstorm,
		/datum/weather/heatwave,
		/datum/weather/fog,
		/datum/weather/freezing_wind
		)
	var/season_change_time = 5 MINUTES
	var/season_last_change

/datum/controller/subsystem/lobotomy_events/Initialize(start_timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(OnNewCrew))

/datum/controller/subsystem/lobotomy_events/fire(resumed)
	if(season_last_change < world.time)
		ChangeSeasons()
	if(PruneList(APOCALYPSE) && (AB_breached.len == 2))
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			var/skip = FALSE
			for(var/mob/living/simple_animal/hostile/abnormality/AA in AB_breached)
				if(AA.type == A.abno_path)
					skip = TRUE
					break
			if(skip)
				continue
			if((A.current?.type in AB_types) && !(A.current in AB_breached))
				AB_breached += A.current
				break
	if(AB_breached.len >= 3)
		INVOKE_ASYNC(src, PROC_REF(SpawnEvent), APOCALYPSE)
	if(PruneList(YINYANG) && YY_breached.len >= 2 && isnull(YY_middle))
		INVOKE_ASYNC(src, PROC_REF(SpawnEvent), YINYANG)
	else if(YY_breached.len >= 2 && !isnull(YY_middle))
		for(var/mob/living/simple_animal/hostile/abnormality/A in YY_breached)
			if(yin_downed && yang_downed)
				A.death()
				continue
			if(A.health <= 0)
				continue
			A.patrol_to(YY_middle)
	return

/datum/controller/subsystem/lobotomy_events/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.type in AB_types)
		for(var/mob/living/simple_animal/hostile/abnormality/A in AB_breached)
			if(A.type == abno.type)
				return // Should stop dupes but allow for contract to start apoc.
		AB_breached += abno
	if(abno.type in YY_types)
		YY_breached += abno
		for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
			if(!(A.type in YY_types))
				continue
			if(A.type == abno.type)
				continue
			if(!A.IsContained())
				continue
			INVOKE_ASYNC(A.datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), -999)
			break
	return
	//Further checks for event abnos can go here.

/**
 * Cleans lists of dead/QDELETED abnormalities.
 */
/datum/controller/subsystem/lobotomy_events/proc/PruneList(event_type = 0)
	if(event_type == 0)
		return FALSE
	var/prune_list = list()
	switch(event_type)
		if(APOCALYPSE)
			for(var/mob/living/simple_animal/hostile/abnormality/a in AB_breached)
				if(QDELETED(a) || !istype(a))
					prune_list += a
			AB_breached -= prune_list
			return TRUE
		if(YINYANG)
			for(var/mob/living/simple_animal/hostile/abnormality/a in YY_breached)
				if(QDELETED(a) || !istype(a))
					prune_list += a
			YY_breached -= prune_list
			return TRUE
	return FALSE

/datum/controller/subsystem/lobotomy_events/proc/SpawnEvent(event_type = 0)
	if(event_type == 0)
		return
	switch(event_type)
		if(APOCALYPSE)
			var/mob/living/simple_animal/forest_portal/portal
			for(var/turf/T in GLOB.department_centers)
				if(istype(get_area(T),/area/department_main/command))
					for(var/mob/living/simple_animal/forest_portal/FP in T.contents) // If we SOMEHOW have duplicates...
						return
					portal = new(T)
					break
			for(var/mob/living/simple_animal/hostile/abnormality/A in AB_breached)
				if(A.IsContained())
					A.datum_reference.qliphoth_change(-999) // Breach it!
				if(istype(A, /mob/living/simple_animal/hostile/abnormality/punishing_bird))
					var/mob/living/simple_animal/hostile/abnormality/punishing_bird/PB = A
					deltimer(PB.death_timer)
				A.patrol_reset()
				A.patrol_to(get_turf(portal), TRUE)
				A.density = FALSE // They ignore you and walk past you.
				A.AIStatus = AI_OFF
				A.can_patrol = FALSE
				A.ChangeResistances(list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)) // You can kill the portal but not them.
			AB_types = list() // So the event can't run again.
			return
		if(YINYANG)
			if(YY_breached.len < 2)
				return FALSE
			var/list/meet_path = get_path_to(YY_breached[1], YY_breached[2], TYPE_PROC_REF(/turf, Distance), 0, 200)
			YY_middle = meet_path[round(meet_path.len/2)]
			for(var/mob/living/simple_animal/hostile/abnormality/A in YY_breached)
				A.patrol_to(YY_middle)
				A.density = FALSE
	return

/**
 * Proc built primarily for testing but could be refined later?
 */
/datum/controller/subsystem/lobotomy_events/proc/SpawnEventAbnos(event_type = 0)
	if(event_type == 0)
		return
	var/list/type_list = list()
	switch(event_type)
		if(APOCALYPSE)
			type_list = AB_types.Copy()
		if(YINYANG)
			type_list = YY_types.Copy()
	for(var/type in type_list)
		SSabnormality_queue.queued_abnormality = type
		SSabnormality_queue.SpawnAbno()
		sleep(1 SECONDS)
	return

//proc for handling season subsystem
/datum/controller/subsystem/lobotomy_events/proc/ChangeSeasons()
	if(!(current_season in seasons))
		current_season = pick(seasons)
		season_last_change = world.time + season_change_time
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SEASON_CHANGE, current_season)
		return
	for(var/W in SSweather.processing)
		var/datum/weather/V = W
		if(V.type in seasons_weather_list)
			return
	var/mob/living/simple_animal/hostile/abnormality/seasons/S = locate() in GLOB.abnormality_mob_list
	if(S)
		if(S.datum_reference.working)
			return
		if(!S.IsContained())
			return
	season_last_change = world.time + season_change_time
	var/index = seasons.Find(current_season)
	index = (index % seasons.len) + 1
	current_season = seasons[index]
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_SEASON_CHANGE, current_season)
	return

/datum/controller/subsystem/lobotomy_events/proc/OnNewCrew(datum_source, mob/living/carbon/human/newbie)
	SIGNAL_HANDLER
	if(!istype(newbie))
		return
	ApplySecurityLevelEffect(newbie)
