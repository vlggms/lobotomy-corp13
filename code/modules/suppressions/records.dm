/datum/suppression/records
	name = RECORDS_CORE_SUPPRESSION
	desc = "Each meltdown, a random ever-increasing amount of abnormalities within your containment will swap places. \
			At even intervals, a random amount of all living creatures in the facility will be teleported a short distance, \
			with abnormalities and ordeals seemingly teleporting in the direction of their opponent."
	reward_text = "The manager console will be equipped with function to swap the positions of abnormalities. \
			Attribute limits of all positions will be raised by 70."
	run_text = "The core suppression of Records department has begun. \n\
			The abnormalities will switch positions every meltdown. \n\
			All living creatures will teleport slightly at even intervals."
	/// How many of abnormality cells will swap places on meltdown, by percent of current count
	var/abno_swap_percentage = 1
	/// How often teleportations happen
	var/teleport_interval = 35 SECONDS
	/// Minimum teleport distance for mobs
	var/teleport_min_distance = 3
	/// How far can mobs teleport at maximum
	var/teleport_max_distance = 5
	/// Minimum percentage of all valid mobs that will be teleported
	var/teleport_min_mob_count = 0.1
	/// Maximum percent of valid mobs to be teleported
	var/teleport_max_mob_count = 0.2

/datum/suppression/records/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnQlipMeltdown))
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SWAP, PROC_REF(OnAbnoSwap))
	addtimer(CALLBACK(src, PROC_REF(TeleportLivingMobs)), teleport_interval)

/datum/suppression/records/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SWAP)
	// EVERYONE GETS INCREASED STAT LIMIT, LET'S FUCKING GOOOOOO
	for(var/datum/job/J in SSjob.occupations)
		J.job_attribute_limit += 70
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_attribute_limit(70)
		to_chat(H, span_notice("You feel new potential unlock within you!"))
	for(var/obj/machinery/computer/camera_advanced/manager/C in GLOB.lobotomy_devices)
		C.swap = new
		C.visible_message(span_notice("[C] has received a new ability!"))
		playsound(get_turf(C), 'sound/machines/ping.ogg', 25, TRUE)
	return ..()

/datum/suppression/records/proc/OnQlipMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	sound_to_playing_players('sound/effects/hokma_meltdown.ogg', 50)
	// Swap shit, wreck havoc
	var/list/abnos = SSlobotomy_corp.all_abnormality_datums.Copy()
	var/max_swap = round(length(abnos) * abno_swap_percentage)
	for(var/i = 1 to max_swap)
		if(!LAZYLEN(abnos))
			break
		var/datum/abnormality/A1 = pick(abnos)
		abnos -= A1
		if(istype(A1.current) && !A1.current.IsContained())
			i -= 1
			continue
		if(A1.working)
			i -= 1
			continue
		if(!LAZYLEN(abnos))
			break
		var/datum/abnormality/A2 = pick(abnos)
		abnos -= A2
		if(istype(A2.current) && !A2.current.IsContained())
			i -= 1
			continue
		if(A2.working)
			i -= 1
			continue
		// SWAP!
		A1.SwapPlaceWith(A2)

	// Upgrade the difficulty!
	if(ordeal)
		abno_swap_percentage = min(1, abno_swap_percentage + 0.2)
		teleport_interval = max(5 SECONDS, teleport_interval - 10 SECONDS)
		teleport_min_mob_count = max(0.8, teleport_min_mob_count + 0.15)
		teleport_max_mob_count = max(1, teleport_max_mob_count + 0.2)
		teleport_min_distance = min(10, teleport_min_distance + 1)
		teleport_max_distance = min(15, teleport_max_distance + 2)

// Show after-image of swapped abnos
/datum/suppression/records/proc/OnAbnoSwap(datum/source, datum/abnormality/A1, datum/abnormality/A2)
	SIGNAL_HANDLER

	if(istype(A1.current))
		var/obj/effect/temp_visual/decoy/D = new (get_turf(A2.landmark), A1.current)
		D.alpha = 150
		animate(D, alpha = 0, time = (10 SECONDS))
	if(istype(A2.current))
		var/obj/effect/temp_visual/decoy/D = new (get_turf(A1.landmark), A2.current)
		D.alpha = 150
		animate(D, alpha = 0, time = (10 SECONDS))

	playsound(A1.landmark, 'sound/effects/hokma_meltdown_short.ogg', 50, TRUE, 5)
	playsound(A2.landmark, 'sound/effects/hokma_meltdown_short.ogg', 50, TRUE, 5)

/// Teleports a random amount of all living mobs on the main z-level
/datum/suppression/records/proc/TeleportLivingMobs()
	var/list/valid_mobs = list()
	for(var/mob/living/L in GLOB.mob_living_list)
		if(istype(L, /mob/living/simple_animal/bot))
			continue
		if(L.z != SSmapping.station_start)
			continue
		if(L.stat == DEAD)
			continue
		var/mob/living/simple_animal/hostile/abnormality/A = L
		if(istype(A) && A.IsContained())
			continue
		var/mob/living/carbon/human/H = L
		if(istype(H) && H.is_working)
			continue
		valid_mobs += L

	var/teleport_count = max(2, round(length(valid_mobs) * (rand(teleport_min_mob_count * 10, teleport_max_mob_count * 10) * 0.1)))
	for(var/i = 1 to teleport_count)
		if(!LAZYLEN(valid_mobs))
			break
		var/mob/living/L = pick(valid_mobs)
		addtimer(CALLBACK(src, PROC_REF(TryToTeleportMob), L), rand(0, 6))
		valid_mobs -= L
	addtimer(CALLBACK(src, PROC_REF(TeleportLivingMobs)), teleport_interval)

/datum/suppression/records/proc/TryToTeleportMob(mob/living/L)
	if(QDELETED(L))
		return
	var/turf/open/T = null
	var/list/turf_list = list()
	var/mob/living/simple_animal/hostile/HA = L
	if(istype(HA) && isliving(HA.target))
		var/turf/TT = get_ranged_target_turf_direct(HA, HA.target, rand(teleport_min_distance, teleport_max_distance))
		turf_list = spiral_range_turfs(3, TT, 1)
	else
		turf_list = spiral_range_turfs(teleport_max_distance, get_turf(L), teleport_min_distance)

	for(var/turf/TT in turf_list)
		if(TT.density)
			turf_list -= TT

	for(var/i = 1 to 5)
		if(!LAZYLEN(turf_list))
			break
		T = pick(turf_list)
		turf_list -= T
		// Found good target turf
		if(LAZYLEN(get_path_to(L, T, TYPE_PROC_REF(/turf, Distance_cardinal), 0, teleport_max_distance * 2)))
			break
		T = null
	// Didn't find anything, very sad
	if(!istype(T))
		return FALSE
	var/list/line_list = getline(get_turf(L), T)
	for(var/i = 1 to length(line_list))
		var/turf/TT = line_list[i]
		var/obj/effect/temp_visual/decoy/D = new (TT, L)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
	L.forceMove(T)
	playsound(L, 'sound/effects/hokma_meltdown_short.ogg', 25, TRUE)
	playsound(T, 'sound/effects/hokma_meltdown_short.ogg', 25, TRUE)
