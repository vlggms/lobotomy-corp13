SUBSYSTEM_DEF(gamedirector)
	name = "RCE Director"
	flags = SS_BACKGROUND || SS_NO_FIRE
	wait = 30 SECONDS
	init_order = INIT_ORDER_GAMEDIRECTOR

	var/list/obj/effect/landmark/available_landmarks = list()
	var/list/obj/effect/landmark/rce_target/rce_targets = list()
	var/list/obj/effect/landmark/rce_target/fob_entrance = list()
	var/list/obj/effect/landmark/rce_target/low_level = list()
	var/list/obj/effect/landmark/rce_target/mid_level = list()
	var/list/obj/effect/landmark/rce_target/high_level = list()
	var/list/obj/effect/landmark/rce_target/xcorp_base = list()
	var/list/targets_by_id = list()
	var/datum/component/monwave_spawner/wave_announcer
	var/first_announce = TRUE

/datum/controller/subsystem/gamedirector/Initialize()
	. = ..()
	available_landmarks = GLOB.department_centers.Copy()

/datum/controller/subsystem/gamedirector/fire(resumed = FALSE)
	return

/datum/controller/subsystem/gamedirector/proc/PopRandomLandmark()
	if(available_landmarks.len > 0)
		var/x = pick(available_landmarks)
		available_landmarks.Remove(x)
		return x
	else
		return pick(GLOB.department_centers)

/datum/controller/subsystem/gamedirector/proc/GetRandomTarget()
	return pick(rce_targets)

/datum/controller/subsystem/gamedirector/proc/RegisterAsWaveAnnouncer(datum/component/monwave_spawner/applicant)
	if(!wave_announcer)
		wave_announcer = applicant
		return TRUE
	return FALSE

/datum/controller/subsystem/gamedirector/proc/RegisterTarget(obj/effect/landmark/rce_target/target, type, id = NONE)
	rce_targets.Add(target)
	switch(type)
		if(RCE_TARGET_TYPE_FOB_ENTRANCE)
			fob_entrance.Add(target)
		if(RCE_TARGET_TYPE_LOW_LEVEL)
			low_level.Add(target)
		if(RCE_TARGET_TYPE_MID_LEVEL)
			mid_level.Add(target)
		if(RCE_TARGET_TYPE_HIGH_LEVEL)
			high_level.Add(target)
		if(RCE_TARGET_TYPE_XCORP_BASE)
			xcorp_base.Add(target)

	if(id)
		targets_by_id[id] = target

/datum/controller/subsystem/gamedirector/proc/GetTargetById(id)
	return targets_by_id[id]


/datum/controller/subsystem/gamedirector/proc/AnnounceWave()
	if(first_announce)
		first_announce = FALSE
		return
	var/text = "A strong X-Corp attack wave is inbound."
	show_global_blurb(5 SECONDS, text, 2 SECONDS, "red", "black")

	sleep(30)
	wave_announcer.SwitchTarget(pick(rce_targets))

/datum/controller/subsystem/gamedirector/proc/AnnounceVictory()
	var/text = "The X-Corp Heart has been destroyed! Victory achieved."
	show_global_blurb(60 SECONDS, text, 2 SECONDS, "gold", "white")
	SSticker.force_ending = 1
