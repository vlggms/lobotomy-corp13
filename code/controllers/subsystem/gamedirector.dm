SUBSYSTEM_DEF(gamedirector)
	name = "RCE Director"
	flags = SS_BACKGROUND
	wait = 30 SECONDS
	init_order = INIT_ORDER_GAMEDIRECTOR

	var/list/obj/effect/landmark/rce_fob = list()
	var/list/obj/effect/landmark/rce_target/rce_targets = list()
	var/list/obj/effect/landmark/rce_target/fob_entrance = list()
	var/list/obj/effect/landmark/rce_target/low_level = list()
	var/list/obj/effect/landmark/rce_target/mid_level = list()
	var/list/obj/effect/landmark/rce_target/high_level = list()
	var/list/obj/effect/landmark/rce_target/xcorp_base = list()
	var/list/obj/effect/landmark/rce_arena_teleport = list()
	var/list/obj/effect/landmark/rce_postfight_teleport = list()
	var/list/obj/effect/landmark/heartfight_pylon = list()
	var/list/targets_by_id = list()
	var/datum/component/monwave_spawner/wave_announcer
	var/list/datum/component/monwave_spawner/spawners = list()
	var/first_announce = TRUE
	var/mob/living/simple_animal/hostile/megafauna/xcorp_heart/heart
	var/list/mob/living/combatants = list()
	var/obj/structure/rce_portal/portal
	var/fightstage = PHASE_NOT_STARTED
	var/rematch = FALSE
	var/timestamp_warning
	var/timestamp_finalwave
	var/timestamp_end

/datum/controller/subsystem/gamedirector/Initialize()
	. = ..()
	if(SSmaptype.maptype != "rcorp_factory")
		wait = 5 HOURS // Changing the flags to make the subsystem not run requires a MC restart, so we do this :3

/datum/controller/subsystem/gamedirector/fire(resumed = FALSE)
	if(fightstage != PHASE_FIGHT && SSticker.current_state != GAME_STATE_FINISHED)
		if(world.time > timestamp_end)
			to_chat(world, span_userdanger("R-Corp HQ has ordered immediate retreat!"))
		else if(world.time > timestamp_finalwave)
			to_chat(world, span_userdanger("A huge wave of zombies is approaching!"))
			StartLastWave()
		else if(world.time > timestamp_warning)
			to_chat(world, span_userdanger("There are 20 minutes left to kill the heart!"))
	return

/datum/controller/subsystem/gamedirector/proc/SetTimes(var/warningtime, var/endtime)
	timestamp_warning = world.time + warningtime
	timestamp_finalwave = world.time + warningtime - 10 MINUTES
	timestamp_end = world.time + endtime

/datum/controller/subsystem/gamedirector/proc/GetRandomTarget()
	return pick(rce_targets)

/datum/controller/subsystem/gamedirector/proc/GetRandomRaiderTarget()
	switch(rand(1, 10))
		if(1 to 5)
			return pick(mid_level)
		if(6 to 9)
			return pick(high_level)
		if(10)
			return pick(low_level)

/datum/controller/subsystem/gamedirector/proc/RegisterAsWaveAnnouncer(datum/component/monwave_spawner/applicant)
	if(!wave_announcer)
		wave_announcer = applicant
		return TRUE
	return FALSE

/datum/controller/subsystem/gamedirector/proc/StartLastWave()
	var/datum/component/monwave_spawner/spawner
	for(spawner in spawners)
		spawner.SwitchTarget(pick(rce_fob))
		spawner.StartAssault(pick(rce_fob))

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
	show_global_blurb(5 SECONDS, text, 1 SECONDS, 2 SECONDS, "red", "black")

	sleep(30)
	wave_announcer.SwitchTarget(pick(rce_targets))

/datum/controller/subsystem/gamedirector/proc/RegisterSpawner(datum/component/monwave_spawner/spawner)
	spawners += spawner

/datum/controller/subsystem/gamedirector/proc/RegisterHeart(mob/heart)
	heart = heart

/datum/controller/subsystem/gamedirector/proc/AnnounceVictory()
	var/text = "The X-Corp Heart has been destroyed! Victory achieved."
	show_global_blurb(60 SECONDS, text, 1 SECONDS, 2 SECONDS, "gold", "white")
	SSticker.force_ending = 1

/datum/controller/subsystem/gamedirector/proc/RegisterPortal(obj/structure/rce_portal/portal)
	portal = portal

/datum/controller/subsystem/gamedirector/proc/RegisterLobby(obj/effect/landmark/lobby)
	rce_arena_teleport += lobby

/datum/controller/subsystem/gamedirector/proc/RegisterFOB(obj/effect/landmark/fob)
	rce_fob += fob

/datum/controller/subsystem/gamedirector/proc/RegisterVictoryTeleport(obj/effect/landmark/postfight)
	rce_postfight_teleport += postfight

/datum/controller/subsystem/gamedirector/proc/RegisterHeartfightPylon(obj/effect/landmark/pylon)
	heartfight_pylon += pylon

/datum/controller/subsystem/gamedirector/proc/BeginPrefightPhase()
	fightstage = PHASE_PREFIGHT
	show_global_blurb(10 SECONDS, "The Heart of Greed has been challenged! Register quickly!", text_color = "#cc2200", outline_color = "#000000", text_align = "center", screen_location="LEFT+0,TOP-1")

/datum/controller/subsystem/gamedirector/proc/BeginRematchPhase()
	print_command_report("The Heart is tired from the fight and is going to sleep, no rematch today. Thank you for playing the RCE demo.", "Heart of Greed Tired", TRUE)
	SSticker.force_ending = 1

/datum/controller/subsystem/gamedirector/proc/RegisterCombatant(mob/living/combatant)
	if(fightstage == PHASE_NOT_STARTED || fightstage == PHASE_PREFIGHT || fightstage == PHASE_OVER_LOST)
		if(length(combatants) == 0)
			if(fightstage == PHASE_OVER_LOST)
				BeginRematchPhase()
			else
				BeginPrefightPhase()
		combatants += combatant
		RegisterSignal(combatant, COMSIG_LIVING_DEATH, PROC_REF(CombatantSlain))
		combatant.forceMove(get_turf(pick(rce_arena_teleport)))
		to_chat(combatant, span_alert("You find yourself in front of the arena! Prepare!"))
	else if(fightstage == PHASE_FIGHT)
		to_chat(combatant, span_danger("The intense aura of the fight prevents you from joining!"))
	else if(fightstage == PHASE_OVER_WON)
		combatant.forceMove(get_turf(pick(rce_postfight_teleport)))
		to_chat(combatant, span_alert("You find yourself at the end of the trial..."))

/datum/controller/subsystem/gamedirector/proc/CombatantSlain(mob/living/combatant)
	SIGNAL_HANDLER
