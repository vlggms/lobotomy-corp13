/datum/ordeal
	/// This will be displayed as announcement title
	var/name = "Dawn of Death"
	/// Level from 1 to 4. It only answers for the order of the ordeals happening, so ordeal 1 will be first and so on.
	var/level = 0
	/// Added meltdown delay. The higher it is - the longer it'll take for the ordeal to occur. If null - uses level.
	var/delay = null
	/// If TRUE - delay will always be adjusted by random number(1-2).
	var/random_delay = TRUE
	/// Announcement text. Self-explanatory
	var/annonce_text = "Oh my god we're going to die!"
	/// Sound to play on announcement, if any
	var/annonce_sound = null
	/// Mobs spawned by event. On their death - event ends
	var/list/ordeal_mobs = list()
	/// Sound to play on event end, if any
	var/end_sound = null
	/// Reward in percents to PE upon winning ordeal. From 0 to 1
	var/reward_percent = 0
	/// HTML Color of the ordeal. Used by the monitors
	var/color = COLOR_VERY_LIGHT_GRAY
	/// If ordeal can be normally chosen
	var/can_run = TRUE
	/// World.time when ordeal started
	var/start_time

/datum/ordeal/New()
	..()
	if(delay == null)
		delay = level * 2

// Runs the event itself
/datum/ordeal/proc/Run()
	start_time = ROUNDTIME
	SSlobotomy_corp.current_ordeals += src
	priority_announce(annonce_text, name, sound='sound/effects/meltdownAlert.ogg')
	/// If dawn started - clear suppression options
	if(level == 1 && !istype(SSlobotomy_corp.core_suppression))
		SSlobotomy_corp.ResetPotentialSuppressions()
	if(annonce_sound)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), annonce_sound, 35, 0)
	return

// Ends the event
/datum/ordeal/proc/End()
	var/total_reward = max(SSlobotomy_corp.box_goal, 3000) * reward_percent
	priority_announce("The ordeal has ended. Facility has been rewarded with [reward_percent*100]% PE.", name, sound=null)
	SSlobotomy_corp.AdjustAvailableBoxes(total_reward)
	SSlobotomy_corp.current_ordeals -= src
	if(end_sound)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), end_sound, 35, 0)
	/// If it was a midnight and we got to it before time limit after previously completing a core suppression
	if(level == 4 && SSlobotomy_corp.core_suppression_state == 2 && \
	start_time <= CONFIG_GET(number/suppression_time_limit))
		// Extra cores, and announced!
		addtimer(CALLBACK(SSlobotomy_corp, /datum/controller/subsystem/lobotomy_corp/proc/PickPotentialSuppressions, TRUE, TRUE), 15 SECONDS)
	/// If it was a dusk - we end running core suppression
	else if(level == 3 && istype(SSlobotomy_corp.core_suppression))
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, /datum/suppression/proc/End), 5 SECONDS)
	qdel(src)
	return

/datum/ordeal/proc/OnMobDeath(mob/living/deadMob)
	ordeal_mobs -= deadMob
	if(!ordeal_mobs.len)
		End()
	return

/// Returns the type of ordeal without spoilering the color; Basically level2name kind of proc.
/datum/ordeal/proc/ReturnSecretName()
	switch(level)
		if(1, 6)
			return "Dawn"
		if(2, 7)
			return "Noon"
		if(3, 8)
			return "Dusk"
		if(4, 9)
			return "Midnight"
	return "Unknown"
