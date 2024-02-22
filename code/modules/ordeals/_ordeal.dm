/datum/ordeal
	/// This will be displayed as announcement title
	var/name = "The Dawn of Death"
	/// Level from 1 to 4. It only answers for the order of the ordeals happening, so ordeal 1 will be first and so on.
	var/level = 0
	/// Added meltdown delay. The higher it is - the longer it'll take for the ordeal to occur. If null - uses level.
	var/delay = null
	/// If TRUE - delay will always be adjusted by random number(between -1 and 1).
	var/random_delay = TRUE
	/// Flavor text
	var/flavor_name = "ERRORNAME"
	/// Announcement text. Self-explanatory
	var/announce_text = "Oh my god we're going to die!"
	/// Sound to play on announcement, if any
	var/announce_sound = null
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
		delay = min(6, level * 2) + 1

// Runs the event itself
/datum/ordeal/proc/Run()
	start_time = ROUNDTIME
	SSlobotomy_corp.current_ordeals += src
	priority_announce(announce_text, name, sound='sound/effects/meltdownAlert.ogg')
	/// If dawn started - clear suppression options
	if(level == 1 && !istype(SSlobotomy_corp.core_suppression))
		SSlobotomy_corp.ResetPotentialSuppressions()
	for(var/mob/player in GLOB.player_list)
		if(player.client)
			var/client/watcher = player.client
			ShowOrdealBlurb(watcher, 25, 40, color)
			if(announce_sound)
				player.playsound_local(get_turf(player), announce_sound, 35, 0)
	return

// Ends the event
/datum/ordeal/proc/End()
	var/total_reward = max(SSlobotomy_corp.box_goal, 3000) * reward_percent
	priority_announce("The ordeal has ended. Facility has been rewarded with [reward_percent*100]% PE.", name, sound=null)
	SSlobotomy_corp.AdjustAvailableBoxes(total_reward)
	SSlobotomy_corp.current_ordeals -= src
	SSlobotomy_corp.AddLobPoints(level * 0.5, "Ordeal Reward")
	if(end_sound)
		for(var/mob/player in GLOB.player_list)
			if(player.client)
				player.playsound_local(get_turf(player), end_sound, 35, 0)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!H.client || !H.ckey)
			continue
		SSpersistence.agent_rep_change[H.ckey] += level
	/// If it was a midnight and we got to it before time limit
	if(level == 4 && start_time <= CONFIG_GET(number/suppression_time_limit))
		// Extra cores, and announced!
		addtimer(CALLBACK(SSlobotomy_corp, TYPE_PROC_REF(/datum/controller/subsystem/lobotomy_corp, PickPotentialSuppressions), TRUE, TRUE), 15 SECONDS)
	/// If it was a dusk - we end running core suppression
	else if(level == 3 && istype(SSlobotomy_corp.core_suppression))
		addtimer(CALLBACK(SSlobotomy_corp.core_suppression, TYPE_PROC_REF(/datum/suppression, End)), 5 SECONDS)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ORDEAL_END, src)
	qdel(src)
	return

/datum/ordeal/proc/OnMobDeath(mob/living/deadMob)
	ordeal_mobs.Remove(deadMob)
	ordeal_mobs = removeNullsFromList(ordeal_mobs)
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

//Global special blurb
/datum/ordeal/proc/ShowOrdealBlurb(client/C, duration, fade_time = 5, text_color = color, text_align = "center", screen_location = "Center-6,Center+3")
	if(!C)
		return
	var/style1 = "font-family: 'Baskerville'; text-align: [text_align]; color: [text_color]; font-size:12pt;"
	var/style2 = "font-family: 'Baskerville'; text-align: [text_align]; color: [text_color]; font-size:14pt;"
	var/style3 = "font-family: 'Baskerville'; text-align: [text_align]; color: [text_color]; font-size:10pt;"
	var/obj/effect/overlay/T = new()
	var/obj/effect/overlay/ordeal/BG = new()
	T.alpha = 0
	T.maptext_height = 120
	T.maptext_width = 424
	T.layer = FLOAT_LAYER
	T.plane = HUD_PLANE
	T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	T.screen_loc = screen_location
	C.screen += T
	C.screen += BG
	animate(T, alpha = 255, time = 10)
	T.maptext = "<span style=\"[style1]\">[name]</span><br><span style=\"[style2]\">[flavor_name]</span><br><span style=\"[style3]\">[announce_text]</span>"
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), C, T, fade_time), duration)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), C, BG, fade_time), duration)

//Black background for blurb
/obj/effect/overlay/ordeal
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "black"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "1,10 to 17,14"
	alpha = 0
	layer = UNDER_HUD_LAYER
	plane = HUD_PLANE - 1
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

/obj/effect/overlay/ordeal/Initialize()
	. = ..()
	animate(src, alpha = 175, time = 10)
