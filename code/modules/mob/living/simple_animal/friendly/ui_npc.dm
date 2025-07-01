/mob/living/simple_animal/hostile/ui_npc
	name = "The Goat"
	icon = 'icons/mob/animal.dmi'
	icon_state = "goat"
	density = TRUE
	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	faction = list("neutral")
	var/portrait_folder = "icons/UI_Icons/NPC_Portraits/"
	var/portrait = "the-goat.PNG"
	var/sound/talking = sound('sound/creatures/lc13/mailman.ogg', repeat = TRUE)
	var/datum/ui_npc/scene_manager/scene_manager
	var/start_scene_id = "intro"
	var/typing_interval = 100
	var/typing_volume = 30
	//var/payback_price = 400
	var/shut_up = FALSE
	var/list/emote_list = list()
	///Last world tick we sent a slogan message out
	var/last_emote = 0
	///How many ticks until we can send another
	var/emote_delay = 6000
	var/random_emotes = "baa!"
	var/bubble = "default2"
	var/mutable_appearance/speech_bubble
	var/can_interact = FALSE
	var/list/active_tgui_sessions = list()
	var/speak_scenes = FALSE // Toggle for speaking scene text
	var/last_scene_speak = 0 // Last time we spoke a scene
	var/scene_speak_cooldown = 40 // 4 second cooldown in deciseconds

/mob/living/simple_animal/hostile/ui_npc/proc/speaking_on()
	if(!can_interact)
		add_overlay(speech_bubble)
		can_interact = TRUE

/mob/living/simple_animal/hostile/ui_npc/proc/speaking_off()
	if(can_interact)
		close_all_tgui()
		cut_overlay(speech_bubble)
		can_interact = FALSE

/mob/living/simple_animal/hostile/ui_npc/Life()
	. = ..()
	if(last_emote + emote_delay <= world.time && emote_list.len > 0 && !shut_up && DT_PROB(20, 1))
		var/emote = pick(emote_list)
		manual_emote(emote)
		last_emote = world.time

/mob/living/simple_animal/hostile/ui_npc/Initialize()
	. = ..()
	speech_bubble = mutable_appearance('icons/mob/talk.dmi', bubble, ABOVE_MOB_LAYER)
	active_tgui_sessions = list()
	// Original code
	emote_list = splittext(random_emotes, ";")
	last_emote = world.time + rand(0, emote_delay)
	speaking_on()

	// add_overlay(mutable_appearance('icons/mob/talk.dmi', bubble, ABOVE_MOB_LAYER))

	// Initialize scene manager with parent reference
	scene_manager = new()
	scene_manager.parent_npc = src

	// Initialize NPC-specific variables (shared across all player interactions)
	scene_manager.npc_vars.variables["name"] = name
	scene_manager.npc_vars.variables["portrait"] = portrait
	scene_manager.npc_vars.variables["typing_interval"] = typing_interval

	// Initialize global variables if needed
	scene_manager.global_vars.variables["time_of_day"] = "day"  // Example global variable

// Called to supply static data that seldom changes.
/mob/living/simple_animal/hostile/ui_npc/ui_static_data(mob/user)
	return list()

/mob/living/simple_animal/hostile/ui_npc/ui_interact(mob/user, datum/tgui/ui)
	user << browse_rsc(file("[portrait_folder][portrait]"))
	. = ..() // Call parent's ui_interact as in original code

	// SStgui.try_update_ui will:
	// 1. Use 'ui' (if provided from args) and if it's valid for this user/src/"SpeakingNpc".
	// 2. Else, try to find an existing tgui datum for user/src/"SpeakingNpc".
	// 3. Else, return null.
	// It updates the UI's content if a tgui datum is found/used.
	var/datum/tgui/current_tgui_instance = SStgui.try_update_ui(user, src, ui)

	if(!current_tgui_instance) // If no existing UI, or 'ui' arg was not suitable
		current_tgui_instance = new(user, src, "SpeakingNpc") // owner is src (the NPC), key is "SpeakingNpc"
		current_tgui_instance.open()

	// Ensure this tgui instance is tracked
	if(current_tgui_instance)
		if(!active_tgui_sessions) // Should have been initialized, but for safety
			active_tgui_sessions = list()
		if(!(current_tgui_instance in active_tgui_sessions))
			active_tgui_sessions.Add(current_tgui_instance)

	return current_tgui_instance // SStgui expects the datum/tgui instance to be returned


/mob/living/simple_animal/hostile/ui_npc/attack_hand(mob/living/carbon/user)
	if(!stat && user.a_intent == INTENT_HELP && !client)
		if (stat == DEAD)
			return
		if(!user || !user.client)
			return
		if(target)
			return
		if(!can_interact)
			return
		ui_interact(user)
		return TRUE
	. = ..()

// Enhanced ui_data method with player-specific variable processing
/mob/living/simple_animal/hostile/ui_npc/ui_data(mob/user)
	if(!user?.client)
		return list()

	var/datum/ui_npc/conversation_state/state = scene_manager.get_user_state(user)
	if(!state.current_scene_id)
		scene_manager.navigate_to_scene(user, start_scene_id)

	var/datum/ui_npc/scene/current_scene = scene_manager.get_current_scene(user)
	if(!current_scene)
		return list()

	// Update player-specific variables
	update_player_variables(user)

	// Process text with variable substitution
	var/processed_text = scene_manager.process_text(user, current_scene.text)

	var/list/action_list = list()
	for(var/action_key in current_scene.actions)
		var/datum/ui_npc/scene_action/action = current_scene.actions[action_key]

		// Check if action should be visible using our player-specific condition system
		if(scene_manager.is_action_visible(user, action, user))
			// Process text for this action with variable substitution
			var/processed_action_text = scene_manager.process_text(user, action.text)

			action_list += list(list(
				"key" = action_key,
				"text" = processed_action_text,
				"enabled" = scene_manager.is_action_enabled(user, action, user)
			))

	return list(
		"title" = name,
		"text" = processed_text,
		"img_url" = portrait,
		"actions" = action_list,
		"typing_speed" = typing_interval
	)

// Helper method to update player variables before processing UI data
/mob/living/simple_animal/hostile/ui_npc/proc/update_player_variables(mob/user)
	if(!user)
		return

// Enhanced ui_act method to use the new scene_manager and action system
/mob/living/simple_animal/hostile/ui_npc/ui_act(action, data, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	if(!user)
		return

	var/datum/ui_npc/scene/current_scene = scene_manager.get_current_scene(user)
	if(!current_scene)
		return

	// Handle special actions
	if(action == "playSound")
		user.playsound_local(user, null, typing_volume, 0, channel = CHANNEL_MUMBLE, use_reverb = FALSE, S = talking)
		return TRUE
	else if(action == "stopSound")
		user.stop_sound_channel(CHANNEL_MUMBLE)
		return TRUE

	var/datum/ui_npc/scene_action/chosen_action = current_scene.actions[action]
	if(!chosen_action)
		return

	// Use the scene_manager's execute_action to handle all processing
	// This handles proc callbacks, variable updates, and scene transitions
	var/datum/ui_npc/scene/next_scene = scene_manager.execute_action(user, chosen_action)

	// If we successfully navigated to a new scene, return TRUE
	if(next_scene)
		return TRUE

	return FALSE

/mob/living/simple_animal/hostile/ui_npc/ui_close(mob/user)
	user.stop_sound_channel(CHANNEL_MUMBLE)

	if(user)
		scene_manager.clear_conversation(user)
		var/datum/tgui/session_to_remove = SStgui.get_open_ui(user, src, "SpeakingNpc")

		if(session_to_remove)
			if(active_tgui_sessions && (session_to_remove in active_tgui_sessions))
				active_tgui_sessions.Remove(session_to_remove)


/mob/living/simple_animal/hostile/ui_npc/proc/close_all_tgui()
	if(active_tgui_sessions && active_tgui_sessions.len > 0)
		// Iterate over a copy, as closing a session might trigger this NPC's ui_close(), modifying the original list
		var/list/sessions_to_close = active_tgui_sessions.Copy()
		for(var/datum/tgui/session in sessions_to_close)
			if(session && session.user && session.user.client) // Ensure session and its user/client are valid
				session.close() // This should initiate the TGUI close process for that user's window
		active_tgui_sessions.Cut() // Clear the NPC's list as all relevant sessions are being told to close

/mob/living/simple_animal/hostile/ui_npc/proc/speak_scene_text(scene_text)
	if(!speak_scenes)
		return

	// Check cooldown
	if(world.time < last_scene_speak + scene_speak_cooldown)
		return

	// Strip HTML tags and process text
	var/clean_text = strip_html_simple(scene_text)

	// Remove variable markers like {player.name}
	var/regex/var_pattern = regex(@"\{[^}]+\}", "g")
	clean_text = var_pattern.Replace(clean_text, "")

	// Limit text length to avoid spam
	if(length(clean_text) > 150)
		clean_text = copytext(clean_text, 1, 150) + "..."

	// Speak the text
	if(clean_text && length(clean_text) > 0)
		say(clean_text)
		last_scene_speak = world.time

/mob/living/simple_animal/hostile/ui_npc/death(gibbed, message)
	speaking_off()
	. = ..()
