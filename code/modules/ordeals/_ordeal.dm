/datum/ordeal
	/// This will be displayed as announcement title
	var/name = "Dawn of Death"
	/// Level from 1 to 4. It only answers for the order of the ordeals happening, so ordeal 1 will be first and so on.
	var/level = 0
	/// Added meltdown delay. The higher it is - the longer it'll take for the ordeal to occur. If null - uses level.
	var/delay = null
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

/datum/ordeal/New()
	..()
	if(delay == null)
		delay = level

// Runs the event itself
/datum/ordeal/proc/Run()
	priority_announce(annonce_text, name, sound='sound/effects/meltdownAlert.ogg')
	if(annonce_sound)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), annonce_sound, 35, 0)
	return

// Ends the event
/datum/ordeal/proc/End()
	var/total_reward = SSlobotomy_corp.box_goal * reward_percent
	SSlobotomy_corp.AdjustBoxes(total_reward)
	priority_announce("The ordeal has ended. Facility has been rewarded with [reward_percent*100]% PE.", name, sound=null)
	if(end_sound)
		for(var/mob/M in GLOB.player_list)
			if(M.client)
				M.playsound_local(get_turf(M), end_sound, 35, 0)
	qdel(src)
	return

/datum/ordeal/proc/OnMobDeath(mob/living/deadMob)
	ordeal_mobs -= deadMob
	if(!ordeal_mobs.len)
		End()
	return
