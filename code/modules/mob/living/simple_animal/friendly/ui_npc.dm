/mob/living/simple_animal/ui_npc
	name = "The Goat"
	icon = 'icons/mob/animal.dmi'
	icon_state = "goat"
	density = TRUE
	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	var/portrait_folder = "icons/UI_Icons/NPC_Portraits/"
	var/portrait = "the-goat.png"
	var/sound/talking = sound('sound/creatures/lc13/mailman.ogg', repeat = TRUE)
	var/datum/ui_npc/scene_manager/scene_manager = new()
	var/start_scene_id = "intro"
	var/typing_interval = 100
	var/typing_volume = 30
	var/payback_price = 400
	var/shut_up = FALSE
	var/list/emote_list = list()
	///Last world tick we sent a slogan message out
	var/last_emote = 0
	///How many ticks until we can send another
	var/emote_delay = 6000
	var/random_emotes = "baa!"


/mob/living/simple_animal/ui_npc/Life()
	. = ..()
	if(last_emote + emote_delay <= world.time && emote_list.len > 0 && !shut_up && DT_PROB(20, 1))
		var/emote = pick(emote_list)
		manual_emote(emote)
		last_emote = world.time

/mob/living/simple_animal/ui_npc/Initialize()
	. = ..()
	emote_list = splittext(random_emotes, ";")
	// So not all machines speak at the exact same time.
	// The first time this machine says something will be at slogantime + this random value,
	// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
	last_emote = world.time + rand(0, emote_delay)

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
		if (!action.visible_callback || action.visible_callback.Invoke(user))
			action_list += list(list(
				"key" = action_key,
				"text" = action.text,
				"enabled" = !action.enabled_callback || action.enabled_callback.Invoke(user) //action.min_rep <= state.reputation
			))

	return list(
		"title" = name,
		"text" = current_scene.text,
		"img_url" = portrait,
		"actions" = action_list,
		"typing_speed" = typing_interval
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
		user.playsound_local(user, null, typing_volume, 0, channel = CHANNEL_MUMBLE, use_reverb = FALSE, S = talking)
		return TRUE
	else if(action == "stopSound")
		user.stop_sound_channel(CHANNEL_MUMBLE)
		return TRUE


	var/datum/ui_npc/scene_action/chosen_action = current_scene.actions[action]
	if(!chosen_action)
		return

	var/result = TRUE
	if (chosen_action.proc_callback)
		result = chosen_action.proc_callback.Invoke()

	// Navigate to next scene if specified
	if(chosen_action.alternative_scene && !result)
		scene_manager.navigate_to_scene(user.client, chosen_action.alternative_scene)
		return TRUE

	if(chosen_action.next_scene)
		scene_manager.navigate_to_scene(user.client, chosen_action.next_scene)
		return TRUE

	return FALSE

// Defines how the UI should currently behave.
// Usually returns UI_INTERACTIVE when ready.
// /mob/living/simple_animal/ui_npc/ui_status(mob/user, datum/ui_state/state)
// 	return UI_INTERACTIVE


// Called when the UI closes.
/mob/living/simple_animal/ui_npc/ui_close(mob/user)
	// Perform any cleanup if necessary.
	user.stop_sound_channel(CHANNEL_MUMBLE)
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
	var/alternative_scene = ""
	var/min_rep = 0
	var/datum/callback/proc_callback
	var/datum/callback/enabled_callback
	var/datum/callback/visible_callback

/datum/ui_npc/scene_action/New(list/data)
	if(!data)
		return
	text = data["Text"]
	next_scene = data["next_scene"]
	alternative_scene = data["alternative_scene"]
	min_rep = data["min_rep"]
	enabled_callback = data["enabled_callback"]
	proc_callback = data["proc_callback"]
	visible_callback = data["visible_callback"]

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

/mob/living/simple_animal/ui_npc/eric_t
	var/parcel_deliveries = list()
	var/item_deliveries = list()
	var/ready_workers = list()
	var/blood_resistance = 250
	var/last_attacked_cooldown
	var/attacked_cooldown = 300
	var/attacked_line = "Yep, That will just be a waste of your time."
	name = "Eric T."
	desc = "A fancy looking fellow wearing a mask; they look relaxed right now."
	health = 1000
	maxHealth = 1000
	typing_interval = 30
	portrait = "erik_bloodfiend_zoom.png"
	start_scene_id = "intro"
	icon = 'ModularTegustation/Teguicons/blood_fiends_32x32.dmi'
	icon_state = "b_boss"
	icon_living = "b_boss"
	icon_dead = "b_boss_dead"
	emote_delay = 2000
	random_emotes = "shuffles through some papers;flips a page in their notebook;sighs..."

/mob/living/simple_animal/ui_npc/eric_t/Initialize()
		. = ..()
		scene_manager.load_scenes(list(
//Intro to the NPC
		"intro" = list(
			"text" = "... *The bloodfiend is simply sitting down and reading their notepad. It appears they have not noticed you.*",
			"actions" = list(
				"hi" = list(
					"Text" = "“Hello?”",
					"next_scene" = "greeting1",
					"min_rep" = 0),
				"stare" = list(
					"Text" = "*Stand here and stare at him*",
					"next_scene" = "greeting2",
					"proc_callback" = ""),
				"loud" = list(
					"Text" = "“HELLO!!!”",
					"next_scene" = "greeting3",
					"proc_callback" = ""),
				)
			),
		"greeting1" = list(
			"text" = "Hm... *The bloodfiend glances in your direction.* Greetings customer. Man, It's opening hours already?",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
		"greeting2" = list(
			"text" = "... *The bloodfiend slightly glances in your direction, before looking back down.*",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "greeting2_2",
					"proc_callback" = ""),
				)
			),
		"greeting2_2" = list(
			"text" = "... Oh, Are you here for our services? <i>You should of said something...</i>",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
		"greeting3" = list(
			"text" = "SHOOT, WHATS HAPPING-...    Dammit, Is this how you greet people?!?",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "greeting3_2",
					"proc_callback" = ""),
				)
			),
		"greeting3_2" = list(
			"text" = "Kids these days, lacking any kind of respect...",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
//Main Screen
		"main_screen" = list(
			"text" = "Anyways, What are you looking for today at the Clinic?",
			"actions" = list(
				"jobs" = list(
					"Text" = "“I am looking for a job!”",
					"next_scene" = "job_1",
					"visible_callback" = CALLBACK(src, PROC_REF(SwapCheckWorker))),
				"ready_jobs" = list(
					"Text" = "“About the job.”",
					"next_scene" = "job",
					"visible_callback" = CALLBACK(src, PROC_REF(CheckWorker))),
				"bloodfiend?" = list(
					"Text" = "“You are a bloodfiend?”",
					"next_scene" = "bloodfiend_1",
					"proc_callback" = ""),
				"arrival" = list(
					"Text" = "“Why are you here?”",
					"next_scene" = "arrival_1",
					"proc_callback" = ""),
				"who" = list(
					"Text" = "“Who are you?”",
					"next_scene" = "who_1",
					"proc_callback" = ""),

				)
			),
//Dialogue about getting a contract
		"job_1" = list(
			"text" = "Well, Lucky you. Your talking to the manager of this establishment.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_2",
					"proc_callback" = ""),
				)
			),
		"job_2" = list(
			"text" = "With us establishing a new clinic in this area, we are looking for some deliverymen.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_extra_1",
					"proc_callback" = ""),
				)
			),
		"job_extra_1" = list(
			"text" = "Some of our deliveries are within the nest, they are no problem. However...",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_3",
					"proc_callback" = ""),
				)
			),
		"job_3" = list(
			"text" = "Often we have syndicates and other factions ordering medical supplies and they want their stuff get delivered discreetly. We obviously accept them, you would surprised how much they are paying.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_4",
					"proc_callback" = ""),
				)
			),
		"job_4" = list(
			"text" = "So, we started using the backstreets as a way to deliver them, but it can be quite deadly in there.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_extra_2"),
				)
			),
		"job_extra_2" = list(
			"text" = "That's why we are looking for deliverymen who have some combat expertise, so they can insure that our products get delivered safely.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job",
					"proc_callback" = CALLBACK(src, PROC_REF(AddWorker))),
				)
			),
		"job" = list(
			"text" = "Are willing to take on some orders?",
			"actions" = list(
				"parcel" = list(
					"Text" = "“Accept the Job”",
					"next_scene" = "job_5",
					"enabled_callback" = CALLBACK(src, PROC_REF(CheckParcelDelivery)),
					"proc_callback" = CALLBACK(src, PROC_REF(OrderParcel))),
				"lost_parcel" = list(
					"Text" = "“About that...”",
					"next_scene" = "job_6",
					"visible_callback" = CALLBACK(src, PROC_REF(SwapCheckParcelDelivery))),
				"later" = list(
					"Text" = "“Maybe not right now.”",
					"next_scene" = "main_screen"),
				)
			),
		"job_5" = list(
			"text" = "Very well, here's the parcel with the ordered supplies. I also would recommend buying one of those coordinate pinpointers in the fixer vending machines, they should make the job easier.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
		"job_6" = list(
			"text" = "Lost it? *sighs*, I guess I should've expected this would happen eventually... Just pay 400 ahn to make up for the lost parcel.",
			"actions" = list(
				"payback" = list(
					"Text" = "Hand over 400 ahn",
					"next_scene" = "job_7",
					"alternative_scene" = "job_6_failed",
					"proc_callback" = CALLBACK(src, PROC_REF(Payback))),
				"backaway" = list(
					"Text" = "“I will get that money soon...”",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
		"job_6_failed" = list(
			"text" = "*takes a look at your ID card*, Oh, It appears that you don't have enough ahn to pay me back... Please return when you DO have enough so we don't waste each other's time.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job_6",
					"proc_callback" = ""),
				)
			),
		"job_7" = list(
			"text" = "*takes a look at your ID card*, Very well, Thanks for paying back your loss, please don't lose it again.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "job",
					"proc_callback" = ""),
				)
			),
//Dialogue about them being a bloodfiend
		"bloodfiend_1" = list(
			"text" = "Yep, I am one of those “big bad bloodfiends” you must have heard of.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "bloodfiend_2",
					"proc_callback" = ""),
				)
			),
		"bloodfiend_2" = list(
			"text" = "If you are worried about me, bringing harm to you in any way, you can drop that worry.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "bloodfiend_3",
					"proc_callback" = ""),
				)
			),
		"bloodfiend_3" = list(
			"text" = "I am paid well at this company, and if I ever happend to need a burst of blood there plenty of bodies in the back alley.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
//Dialogue about them arriving here.
		"arrival_1" = list(
			"text" = "I guess it must be a bit surprising to see me here, with me arriving without much of an announcement.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "arrival_2",
					"proc_callback" = ""),
				)
			),
		"arrival_2" = list(
			"text" = "Higher up wanted some more information on how well the clinic is doing in this nest. So the offered another job to me to watch over this clinic.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "arrival_3",
					"proc_callback" = ""),
				)
			),
		"arrival_3" = list(
			"text" = "It pays quite well, and I basically don't need to do anything other then watch over the docters and nurses.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
//Dialogue about who they are.
		"who_1" = list(
			"text" = "*sighs*, I still haven't made a public introduction of my sudden appearance. I really needed to work on getting that sorted out.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "who_2",
					"proc_callback" = ""),
				)
			),
		"who_2" = list(
			"text" = "Well, Let's get this introduction done and over with... *flips through their notepad...*",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "who_3",
					"proc_callback" = ""),
				)
			),
		"who_3" = list(
			"text" = "Ahm, “I am Eric T. The manager and newly employed health inspector of this clinic.”",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "who_4",
					"proc_callback" = ""),
				)
			),
		"who_4" = list(
			"text" = "“Some responsibilities of a clinic manager/health inspector include assignments like rating the clinic's efficiency, giving employees direct orders, ”- and yada yada...",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "who_5",
					"proc_callback" = ""),
				)
			),
		"who_5" = list(
			"text" = "Long story short, I am the guy who keeps the clinic on track.",
			"actions" = list(
				"..." = list(
					"Text" = "...",
					"next_scene" = "main_screen",
					"proc_callback" = ""),
				)
			),
	))

/mob/living/simple_animal/ui_npc/eric_t/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if (amount > 0)
		amount = amount - blood_resistance
		if (amount < 0)
			amount = 0
	. = ..()
	if (amount == 0)
		new /obj/effect/temp_visual/blood_shield(src.loc)
		if (last_attacked_cooldown < world.time - attacked_cooldown)
			say(attacked_line)
			last_attacked_cooldown = world.time

/mob/living/simple_animal/ui_npc/eric_t/proc/Payback()
	var/obj/item/card/id/C
	if(isliving(usr))
		var/mob/living/L = usr
		C = L.get_idcard(TRUE)
		if(!C)
		//		say("No card found.")
			return FALSE
		else if (!C.registered_account)
		//		say("No account found.")
			return FALSE
		var/datum/bank_account/account = C.registered_account
		if(payback_price && !account.adjust_money(-payback_price))
		//		say("You do not possess the funds!")
			return FALSE
		else
			RemoveUser(parcel_deliveries)
			RemoveUser(item_deliveries)
			L.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/ui_npc/proc/RemoveUser(list)
	for(var/D in list)
		list[D] -= usr


/mob/living/simple_animal/ui_npc/eric_t/proc/OrderParcel()
	var/door = pick(GLOB.delivery_doors)
	if (istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		D.OrderParcel(src.loc)
		var/mob/user = usr
		user.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)
		if (!parcel_deliveries[D])
			parcel_deliveries[D] = list()
		if (length(parcel_deliveries[D]) == 0)
			RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ParcelDelivered))
		parcel_deliveries[D] += usr

/mob/living/simple_animal/ui_npc/eric_t/proc/AddWorker()
	ready_workers += usr

/mob/living/simple_animal/ui_npc/eric_t/proc/ParcelDelivered(door, user)
	SIGNAL_HANDLER
	parcel_deliveries[door] -= user
	if (length(parcel_deliveries[door]) == 0)
		UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)

/mob/living/simple_animal/ui_npc/eric_t/proc/OrderItem(item, payment)
	var/door = pick(GLOB.delivery_doors)
	if (istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		D.OrderItems(src.loc, item, payment)
		if (!item_deliveries[D])
			item_deliveries[D] = list()
		if (length(item_deliveries[D]) == 0)
			RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ItemDelivered))
		item_deliveries[D] += usr

/mob/living/simple_animal/ui_npc/eric_t/proc/ItemDelivered(door, user)
	SIGNAL_HANDLER
	item_deliveries[door] -= user
	if (length(item_deliveries[door]) == 0)
		UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)

/mob/living/simple_animal/ui_npc/eric_t/proc/CheckItemDelivery(user)
	for(var/D in item_deliveries)
		for(var/U in item_deliveries[D])
			if (U == user)
				return FALSE
	return TRUE

/mob/living/simple_animal/ui_npc/eric_t/proc/CheckWorker(user)
	for(var/W in ready_workers)
		if (W == user)
			return TRUE
	return FALSE

/mob/living/simple_animal/ui_npc/eric_t/proc/SwapCheckWorker(user)
	for(var/W in ready_workers)
		if (W == user)
			return FALSE
	return TRUE

/mob/living/simple_animal/ui_npc/eric_t/proc/CheckParcelDelivery(user)
	for(var/D in parcel_deliveries)
		for(var/U in parcel_deliveries[D])
			if (U == user)
				return FALSE
	return TRUE

/mob/living/simple_animal/ui_npc/eric_t/proc/SwapCheckParcelDelivery(user)
	for(var/D in parcel_deliveries)
		for(var/U in parcel_deliveries[D])
			if (U == user)
				return TRUE
	return FALSE

/obj/effect/temp_visual/blood_shield
	name = "blood shield"
	desc = "A shimmering forcefield protecting the bloodfiend."
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "shield-cult"
	layer = FLY_LAYER
	light_system = MOVABLE_LIGHT
	light_range = 2
	duration = 6
