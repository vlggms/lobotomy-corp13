SUBSYSTEM_DEF(abnormality_queue)
	name = "Abnormality Queue"
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	wait = 8 MINUTES

	var/mob/living/simple_animal/hostile/abnormality/queued_abnormality
	var/list/available_levels = list(ZAYIN_LEVEL, TETH_LEVEL)
	var/list/possible_abnormalities = list(ZAYIN_LEVEL = list(), TETH_LEVEL = list(), HE_LEVEL = list(), WAW_LEVEL = list(), ALEPH_LEVEL = list())

/datum/controller/subsystem/abnormality_queue/Initialize(timeofday)
	var/list/all_abnos = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in all_abnos)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(initial(abno.can_spawn))
			possible_abnormalities[initial(abno.threat_level)] += abno
	if(LAZYLEN(possible_abnormalities))
		pick_abno()

	. = ..()

/datum/controller/subsystem/abnormality_queue/fire()
	if(!(HE_LEVEL in available_levels) && (world.time >= 15 MINUTES))
		available_levels += HE_LEVEL
	if(!(WAW_LEVEL in available_levels) && (world.time >= 25 MINUTES))
		available_levels += WAW_LEVEL
	if(!(ALEPH_LEVEL in available_levels) && (world.time >= 45 MINUTES))
		available_levels += ALEPH_LEVEL

	if(!ispath(queued_abnormality) && LAZYLEN(possible_abnormalities))
		pick_abno()
		return

	if(!LAZYLEN(GLOB.abnormality_room_spawners))
		return

	var/obj/effect/spawner/abnormality_room/choice = pick(GLOB.abnormality_room_spawners)
	if(istype(choice))
		addtimer(CALLBACK(choice, .obj/effect/spawner/abnormality_room/proc/SpawnRoom))

/datum/controller/subsystem/abnormality_queue/proc/postspawn()
	if(queued_abnormality)
		queued_abnormality = null
		pick_abno()

/datum/controller/subsystem/abnormality_queue/proc/pick_abno()
	var/list/picking_abno = list()
	for(var/lev in available_levels)
		if(!LAZYLEN(possible_abnormalities[lev]))
			continue
		picking_abno += pick(possible_abnormalities[lev])
	if(LAZYLEN(picking_abno))
		queued_abnormality = pick(picking_abno)
	possible_abnormalities[initial(queued_abnormality.threat_level)] -= queued_abnormality
