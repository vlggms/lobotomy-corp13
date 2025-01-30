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

/mob/living/simple_animal/ui_npc/Initialize()
	. = ..()

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
			"enabled" = !action.enabled_callback || action.enabled_callback.Invoke(user) //action.min_rep <= state.reputation
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

	// Handle special actions
	if(action == "playSound")
		playsound(usr, sound(soundfile, repeat=1), 50, channel = 3)
		return TRUE
	else if(action == "stopSound")
		stop_sound_channel(3)
		return TRUE


	var/datum/ui_npc/scene_action/chosen_action = current_scene.actions[action]
	if(!chosen_action)
		return

	if (chosen_action.proc_callback)
		chosen_action.proc_callback.Invoke()

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
	var/datum/callback/proc_callback = ""
	var/datum/callback/enabled_callback = ""

/datum/ui_npc/scene_action/New(list/data)
	if(!data)
		return
	text = data["Text"]
	next_scene = data["next_scene"]
	min_rep = data["min_rep"]
	enabled_callback = data["enabled_callback"]
	proc_callback = data["proc_callback"]

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

/mob/living/simple_animal/ui_npc/mailman
	var/parcel_deliveries = list()
	var/item_deliveries = list()

/mob/living/simple_animal/ui_npc/mailman/Initialize()
		. = ..()
		scene_manager.load_scenes(list(
		"intro" = list(
			"text" = "Intro scene 1. “Baa” (Who are you, mortal who crosses thy path?!!)",
			"actions" = list(
				"hi" = list(
					"Text" = "“Hi! How are you?”",
					"next_scene" = "hru",
					"min_rep" = 20),
				"bye" = list(
					"Text" = "“Bye!”",
					"next_scene" = "bye",
					"min_rep" = 20,
					"proc_callback" = ""),
				)
			),
		"hru" = list(
			"text" = "Intro scene 2. “Baa... BAA!! Baa?” (Well, I guess today is okay... BUT IT COULD BE BETTER! Anyways, How is your day?)",
			"actions" = list(
				"good" = list(
					"Text" = "“Good!”",
					"next_scene" = "intro",
					"min_rep" = 20,
					"enabled_callback" = CALLBACK(src, PROC_REF(CheckItemDelivery)),
					"proc_callback" = CALLBACK(src, PROC_REF(OrderItem), /obj/item/food/pizza/margherita, 30)),
				"bad" = list(
					"Text" = "“Bad!”",
					"next_scene" = "intro",
					"min_rep" = 20,
					"enabled_callback" = CALLBACK(src, PROC_REF(CheckParcelDelivery)),
					"proc_callback" = CALLBACK(src, PROC_REF(OrderParcel))
					),
				)
			),
		"bye" = list(
			"text" = "Intro scene 3. “Baa” (Understood, Have a good day.)",
			"actions" = list(),
		)
	))

/mob/living/simple_animal/ui_npc/mailman/proc/OrderParcel()
	var/door = pick(GLOB.delivery_doors)
	if (istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		D.OrderParcel(src.loc)
		new /obj/item/pinpointer/coordinate(src.loc)
		if (!parcel_deliveries[D])
			parcel_deliveries[D] = list()
		if (length(parcel_deliveries[D]) == 0)
			RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ParcelDelivered))
		parcel_deliveries[D] += usr


/mob/living/simple_animal/ui_npc/mailman/proc/ParcelDelivered(door, user)
	SIGNAL_HANDLER
	parcel_deliveries[door] -= user
	if (length(parcel_deliveries[door]) == 0)
		UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)

/mob/living/simple_animal/ui_npc/mailman/proc/OrderItem(item, payment)
	var/door = pick(GLOB.delivery_doors)
	if (istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		D.OrderItems(src.loc, item, payment)
		if (!item_deliveries[D])
			item_deliveries[D] = list()
		if (length(item_deliveries[D]) == 0)
			RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ItemDelivered))
		parcel_deliveries[D] += usr

/mob/living/simple_animal/ui_npc/mailman/proc/ItemDelivered(door, user)
	SIGNAL_HANDLER
	item_deliveries[door] -= user
	if (length(item_deliveries[door]) == 0)
		UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)

/mob/living/simple_animal/ui_npc/mailman/proc/CheckItemDelivery(user)
	for(var/D in item_deliveries)
		for(var/U in item_deliveries[D])
			if (U == user)
				return FALSE
	return TRUE

/mob/living/simple_animal/ui_npc/mailman/proc/CheckParcelDelivery(user)
	for(var/D in parcel_deliveries)
		for(var/U in parcel_deliveries[D])
			if (U == user)
				return FALSE
	return TRUE
