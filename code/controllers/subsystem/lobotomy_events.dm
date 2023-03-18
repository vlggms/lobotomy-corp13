#define APOCALYPSE 1
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

/datum/controller/subsystem/lobotomy_events/Initialize(start_timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, .proc/OnAbnoBreach)

/datum/controller/subsystem/lobotomy_events/fire(resumed)
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
		INVOKE_ASYNC(src, .proc/SpawnEvent, APOCALYPSE)


/datum/controller/subsystem/lobotomy_events/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.type in AB_types)
		for(var/mob/living/simple_animal/hostile/abnormality/A in AB_breached)
			if(A.type == abno.type)
				return // Should stop dupes but allow for contract to start apoc.
		AB_breached += abno
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
				A.damage_coeff = list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0) // You can kill the portal but not them.
			AB_types = list() // So the event can't run again.
			return
	return

/**
 * Proc built primarily for testing but could be refined later?
 */
/datum/controller/subsystem/lobotomy_events/proc/SpawnEventAbnos(event_type = 0)
	if(event_type == 0)
		return
	switch(event_type)
		if(APOCALYPSE)
			for(var/type in AB_types)
				SSabnormality_queue.queued_abnormality = type
				SSabnormality_queue.SpawnAbno()
				sleep(1 SECONDS)
			return
	return


