SUBSYSTEM_DEF(abnormality_queue)
	name = "Abnormality Queue"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 10 MINUTES

	var/mob/living/simple_animal/hostile/abnormality/queued_abnormality
	var/list/available_levels = list(ZAYIN_LEVEL, TETH_LEVEL)
	var/list/possible_abnormalities = list(ZAYIN_LEVEL = list(), TETH_LEVEL = list(), HE_LEVEL = list(), WAW_LEVEL = list(), ALEPH_LEVEL = list(), )

/datum/controller/subsystem/abnormality_queue/Initialize(timeofday)
	var/list/all_abnos = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn))
			possible_abnormalities[initial(abno.threat_level)] += abno
	if(possible_abnormalities.len)
		var/list/picking_abno = list()
		for(var/lev in available_levels)
			if(!LAZYLEN(possible_abnormalities[lev]))
				continue
			picking_abno += pick(possible_abnormalities[lev])
		if(LAZYLEN(picking_abno))
			queued_abnormality = pick(picking_abno)

	. = ..()

/datum/controller/subsystem/abnormality_queue/fire()
	if(!(HE_LEVEL in available_levels) && (world.time >= 15 MINUTES))
		available_levels += HE_LEVEL
	if(!(WAW_LEVEL in available_levels) && (world.time >= 35 MINUTES))
		available_levels += WAW_LEVEL
	if(!(ALEPH_LEVEL in available_levels) && (world.time >= 55 MINUTES))
		available_levels += ALEPH_LEVEL

	if(!ispath(queued_abnormality))
		var/list/picking_abno = list()
		for(var/lev in available_levels)
			if(!LAZYLEN(possible_abnormalities[lev]))
				continue
			picking_abno += pick(possible_abnormalities[lev])
		if(LAZYLEN(picking_abno))
			queued_abnormality = pick(picking_abno)
		return

	var/obj/effect/spawner/abnormality_room/choice = pick(GLOB.abnormality_room_spawners)
	if(istype(choice))
		addtimer(CALLBACK (choice, .obj/effect/spawner/abnormality_room/proc/SpawnRoom))

/datum/controller/subsystem/abnormality_queue/proc/postspawn()
	if(possible_abnormalities.len && queued_abnormality)
		possible_abnormalities[initial(queued_abnormality.threat_level)] -= queued_abnormality
		queued_abnormality = null
		var/list/picking_abno = list()
		for(var/lev in available_levels)
			if(!LAZYLEN(possible_abnormalities[lev]))
				continue
			picking_abno += pick(possible_abnormalities[lev])
		if(LAZYLEN(picking_abno))
			queued_abnormality = pick(picking_abno)
