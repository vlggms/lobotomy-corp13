/mob/living/simple_animal/ui_npc
	name = "The Goat"
	icon = 'icons/mob/animal.dmi'
	icon_state = "goat"
	density = TRUE
	var/portrait_folder = "icons/UI_Icons/NPC_Portraits/"
	var/portrait = "the-goat.png"
	var/soundfile =  'sound/creatures/lc13/goat_bleating.ogg'
	var/datum/ui_npc/scene_manager/scene_manager = new()
	var/start_scene_id = "intro"
	var/list/scenes = list(
			"intro" = list(
				"text" = "Intro scene 1. “Baa” (Who are you, mortal who crosses thy path?!!)",
				"actions" = list(
					"hi" = list(
						"Text" = "“Hi! How are you?”",
						"next_scene" = "hru",
						"min_rep" = 20,
						"proc" = ""),
					"bye" = list(
						"Text" = "“Bye!”",
						"next_scene" = "bye",
						"min_rep" = 20,
						"proc" = ""),
					)
				),
			"hru" = list(
				"text" = "Intro scene 2. “Baa... BAA!! Baa?” (Well, I guess today is okay... BUT IT COULD BE BETTER! Anyways, How is your day?)",
				"actions" = list(
					"good" = list(
						"Text" = "“Good!”",
						"next_scene" = "intro",
						"min_rep" = 20,
						"proc" = ""),
					"bad" = list(
						"Text" = "“Bad!”",
						"next_scene" = "intro",
						"min_rep" = 20,
						"proc" = ""),
					)
				),
			"bye" = list(
				"text" = "Intro scene 3. “Baa” (Understood, Have a good day.)",
				"actions" = list(),
			)
		)

/mob/living/simple_animal/ui_npc/Initialize()
	. = ..()
	scene_manager.load_scenes(scenes)

// Called to supply dynamic data to the UI.
/mob/living/simple_animal/ui_npc/ui_data(mob/user)
	var/datum/ui_npc/conversation_state/state = scene_manager.get_user_state(user.client)
	if(!state.current_scene_id)
		scene_manager.navigate_to_scene(user.client, start_scene_id)
	var/datum/ui_npc/scene/current_scene = scene_manager.get_current_scene(user.client)
	if(!current_scene)
		return list()

	var/list/action_list = list()
	for(var/action_key in current_scene.actions)
		var/datum/ui_npc/scene_action/action = current_scene.actions[action_key]
		action_list += list(list(
			"key" = action_key,
			"text" = action.text,
			//"enabled" = action.min_rep <= state.reputation
		))

	return list(
		"title" = name,
		"text" = current_scene.text,
		"img_url" = portrait,
		"actions" = action_list
	)

// Called to supply static data that seldom changes.
/mob/living/simple_animal/ui_npc/ui_static_data(mob/user)
	return list()

// Called when a user performs an action in the UI.
/mob/living/simple_animal/ui_npc/ui_act(action, data, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	if(!user?.client)
		return

	var/datum/ui_npc/scene/current_scene = scene_manager.get_current_scene(user.client)
	if(!current_scene)
		return

	var/datum/ui_npc/scene_action/chosen_action = current_scene.actions[action]
	if(!chosen_action)
		return

	// Handle special actions
	if(action == "playSound")
		playsound(usr, sound(soundfile, repeat=1), 50, channel = 3)
		return TRUE
	else if(action == "stopSound")
		stop_sound_channel(3)
		return TRUE

	// Navigate to next scene if specified
	if(chosen_action.next_scene)
		scene_manager.navigate_to_scene(user.client, chosen_action.next_scene)
		return TRUE

	return FALSE

// Defines how the UI should currently behave.
// Usually returns UI_INTERACTIVE when ready.
/mob/living/simple_animal/ui_npc/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE


// Called when the UI closes.
/mob/living/simple_animal/ui_npc/ui_close(mob/user)
	// Perform any cleanup if necessary.
	return

// Called periodically if autoupdate=TRUE. If you need periodic refreshes, do them here.
/mob/living/simple_animal/ui_npc/ui_interact(mob/user, datum/tgui/ui)
	user << browse_rsc(file("[portrait_folder][portrait]"))
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpeakingNpc")
		ui.open()

/mob/living/simple_animal/ui_npc/attack_hand(mob/living/carbon/user)
	. = ..()
	if(!user || !user.client)
		return
	ui_interact(user)

/mob/living/simple_animal/ui_npc/attackby(obj/item/O, mob/user, params)
	. = ..()
	if(!user || !user.client)
		return
	ui_interact(user)

/datum/ui_npc/scene_action
	var/text = ""
	var/next_scene = ""
	var/min_rep = 0
	var/proc_name = ""

/datum/ui_npc/scene_action/New(list/data)
	if(!data)
		return
	text = data["Text"]
	next_scene = data["next_scene"]
	min_rep = data["min_rep"]
	proc_name = data["proc"]

/datum/ui_npc/scene
	var/text = ""
	var/list/datum/ui_npc/scene_action/actions = list()

/datum/ui_npc/scene/New(list/data)
	if(!data)
		return
	text = data["text"]
	if(data["actions"])
		for(var/action_key in data["actions"])
			var/list/action_data = data["actions"][action_key]
			actions[action_key] = new /datum/ui_npc/scene_action(action_data)

/datum/ui_npc/conversation_state
	var/current_scene_id = null
	var/list/scene_history = list()
	var/reputation = 0


/datum/ui_npc/scene_manager
	var/list/datum/ui_npc/scene/scenes = list()
	var/list/datum/ui_npc/conversation_state/user_states = list()

/datum/ui_npc/scene_manager/proc/load_scenes(list/scene_data)
	for(var/scene_key in scene_data)
		scenes[scene_key] = new /datum/ui_npc/scene(scene_data[scene_key])

/datum/ui_npc/scene_manager/proc/get_user_state(client/client)
	if(!client)
		return null
	var/client_ref = "\ref[client]"
	if(!user_states[client_ref])
		var/datum/ui_npc/conversation_state/new_state = new()
		user_states[client_ref] = new_state
	return user_states[client_ref]

/datum/ui_npc/scene_manager/proc/get_current_scene(client/client)
	var/datum/ui_npc/conversation_state/state = get_user_state(client)
	if(!state || !state.current_scene_id)
		return null
	return scenes[state.current_scene_id]

/datum/ui_npc/scene_manager/proc/navigate_to_scene(client/client, scene_id)
	var/datum/ui_npc/conversation_state/state = get_user_state(client)
	if(!state)
		return

	// Store current scene in history before changing
	if(state.current_scene_id)
		state.scene_history += state.current_scene_id

	state.current_scene_id = scene_id
	return scenes[scene_id]

