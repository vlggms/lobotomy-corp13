// Meltdown types
#define MELTDOWN_NORMAL 1
#define MELTDOWN_GRAY 2
#define MELTDOWN_GOLD 3
#define MELTDOWN_PURPLE 4
#define MELTDOWN_CYAN 5
#define MELTDOWN_BLACK 6

// TODO: Do something about it, idk
SUBSYSTEM_DEF(lobotomy_corp)
	name = "Lobotomy Corporation"
	flags = SS_KEEP_TIMING | SS_BACKGROUND | SS_NO_FIRE
	wait = 5 MINUTES

	var/list/all_abnormality_datums = list()

	// How many qliphoth_events were called so far
	var/qliphoth_state = 0
	// Current level of the qliphoth meter
	var/qliphoth_meter = 0
	// State at which it will cause qliphoth meltdowns/ordeal
	var/qliphoth_max = 4
	// How many abnormalities will be affected. Cannot be more than current amount of abnos
	var/qliphoth_meltdown_amount = 1
	// What abnormality threat levels are affected by meltdowns
	var/list/qliphoth_meltdown_affected = list(
		ZAYIN_LEVEL,
		TETH_LEVEL,
		HE_LEVEL,
		WAW_LEVEL,
		ALEPH_LEVEL
		)

	// Assoc list of ordeals by level
	var/list/all_ordeals = list(
							1 = list(),
							2 = list(),
							3 = list(),
							4 = list(),
							5 = list(),
							6 = list(),
							7 = list(),
							8 = list(),
							9 = list()
							)
	// At what qliphoth_state next ordeal will happen
	var/next_ordeal_time = 1
	// What ordeal level is being rolled for
	var/next_ordeal_level = 1
	// Minimum time for each ordeal level to occur. If requirement is not met - normal meltdown will occur
	var/list/ordeal_timelock = list(10 MINUTES, 25 MINUTES, 45 MINUTES, 60 MINUTES, 0, 0, 0, 0, 0)
	// Datum of the chosen ordeal. It's stored so manager can know what's about to happen
	var/datum/ordeal/next_ordeal = null
	/// List of currently running ordeals
	var/list/current_ordeals = list()
	// Currently running core suppression
	var/datum/suppression/core_suppression = null
	// List of active core suppressions; Different from above, as there can only be one "main" core
	var/list/active_core_suppressions = list()
	// List of available core suppressions for manager to choose
	var/list/available_core_suppressions = list()
	// State of the core suppression
	var/core_suppression_state = 0
	// Work logs from all abnormalities
	var/list/work_logs = list()
	// Work logs, but from agent perspective. Used mainly for round-end report
	var/list/work_stats = list()
	// List of facility upgrade datums
	var/list/upgrades = list()

	// PE available to be spent
	var/available_box = 0
	// PE specifically for PE Quota
	var/goal_boxes = 0
	// Total PE generated
	var/total_generated = 0
	// Total PE spent
	var/total_spent = 0
	// The number we must reach
	var/box_goal = 0 // Initialized later
	// Where we reached our goal
	var/goal_reached = FALSE
	/// Multiplier to PE earned from working on abnormalities
	var/box_work_multiplier = 1
	/// Multiplier towards attribute points earned for working on melting abnormalities
	var/melt_work_multiplier = 1
	/// The area of effect of manager's bullets; -1 is for direct target only
	var/manager_bullet_area = -1
	/// When TRUE - abnormalities can be possessed by ghosts
	var/enable_possession = FALSE
	/// Amount of abnormalities that agents achieved full understanding on
	var/understood_abnos = 0
	/// The amount of core suppression options that will be available
	var/max_core_options = 3
	/// Points used for facility upgrades
	var/lob_points = 2

	/// If TRUE - will not count deaths for auto restart
	var/auto_restart_in_progress = FALSE

/datum/controller/subsystem/lobotomy_corp/Initialize(timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath))
	addtimer(CALLBACK(src, PROC_REF(SetGoal)), 5 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(InitializeOrdeals)), 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(PickPotentialSuppressions)), 60 SECONDS)
	for(var/F in subtypesof(/datum/facility_upgrade))
		upgrades += new F

/datum/controller/subsystem/lobotomy_corp/proc/SetGoal()
	var/player_mod = GLOB.clients.len * 0.15
	box_goal = clamp(round(5000 * player_mod), 3000, 36000)
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/InitializeOrdeals()
	// Build ordeals global list
	for(var/type in subtypesof(/datum/ordeal))
		var/datum/ordeal/O = new type()
		if(O.level < 1)
			qdel(O)
			continue
		all_ordeals[O.level] += O
	RollOrdeal()
	return TRUE

// Called when any normal midnight ends
/datum/controller/subsystem/lobotomy_corp/proc/PickPotentialSuppressions(announce = FALSE, extra_core = FALSE)
	if(istype(core_suppression))
		return
	var/obj/machinery/computer/abnormality_auxiliary/aux_cons = locate() in GLOB.lobotomy_devices
	if(!aux_cons) // There's no consoles, for some reason
		message_admins("Tried to pick potential core suppressions, but there was no auxiliary consoles! Fix it!")
		return
	var/list/cores = subtypesof(/datum/suppression)
	// Remove cores that don't fit requirements
	for(var/core_type in cores)
		var/datum/suppression/C = core_type
		if(!extra_core && initial(C.after_midnight))
			cores -= core_type
			continue
		if(extra_core && !initial(C.after_midnight))
			cores -= core_type
			continue
		// Create to see if it meets requirements and becomes available
		C = new core_type()
		if(!C.available)
			cores -= core_type
		qdel(C)
	for(var/i = 1 to max_core_options)
		if(!LAZYLEN(cores))
			break
		var/core_type = pick(cores)
		available_core_suppressions += core_type
		cores -= core_type
	if(!LAZYLEN(available_core_suppressions))
		return
	// This solution is hacky and extra dirty I hate it
	if(extra_core)
		addtimer(CALLBACK(src, PROC_REF(WarnBeforeReset)), (4 MINUTES))
	if(announce)
		var/announce_text = "[extra_core ? "Extra" : "Sephirah"] Core Suppressions have been made available via auxiliary managerial consoles."
		var/announce_title = "[extra_core ? "Extra" : "Sephirah"] Core Suppression"
		priority_announce(announce_text, \
						announce_title, sound = 'sound/machines/dun_don_alert.ogg')
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		A.audible_message("<span class='notice'>[extra_core ? "Extra " : ""]Core Suppressions are now available!</span>")
		playsound(get_turf(A), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
		A.updateUsrDialog()

/datum/controller/subsystem/lobotomy_corp/proc/WarnBeforeReset()
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		A.audible_message("<span class='userdanger'>Core Suppression options will be disabled if you don't pick one in a minute!</span>")
		playsound(get_turf(A), 'sound/machines/dun_don_alert.ogg', 100, TRUE, 14)
	addtimer(CALLBACK(src, PROC_REF(ResetPotentialSuppressions), TRUE), (1 MINUTES))

/datum/controller/subsystem/lobotomy_corp/proc/ResetPotentialSuppressions(announce = FALSE)
	if(istype(core_suppression) || !LAZYLEN(available_core_suppressions))
		return
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		A.audible_message("<span class='userdanger'>Core Suppression options have been disabled for this shift!</span>")
		playsound(get_turf(A), 'sound/machines/dun_don_alert.ogg', 100, TRUE, 14)
		A.selected_core_type = null
		A.updateUsrDialog()
	available_core_suppressions = list()
	if(announce)
		priority_announce("Core Suppression hasn't been chosen in 5 minutes window and have been disabled for this shift.", \
						"Core Suppression", sound = 'sound/machines/dun_don_alert.ogg')

/datum/controller/subsystem/lobotomy_corp/proc/NewAbnormality(datum/abnormality/new_abno)
	if(!istype(new_abno))
		return FALSE
	all_abnormality_datums += new_abno
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_SPAWN, new_abno)
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/WorkComplete(amount = 0, qliphoth_change = TRUE)
	if(qliphoth_change)
		QliphothUpdate()
	AdjustAvailableBoxes(amount)

/datum/controller/subsystem/lobotomy_corp/proc/AdjustAvailableBoxes(amount)
	available_box = max((available_box + amount), 0)
	if(amount > 0)
		total_generated += amount
	else
		total_spent -= amount
	CheckGoal()

/datum/controller/subsystem/lobotomy_corp/proc/AdjustGoalBoxes(amount)
	if(goal_reached)
		AdjustAvailableBoxes(amount)
		return
	goal_boxes = max(goal_boxes + amount, 0)
	if(amount > 0)
		total_generated += amount
	else
		total_spent -= amount
	CheckGoal()

/datum/controller/subsystem/lobotomy_corp/proc/CheckGoal()
	if(goal_reached || box_goal == 0)
		return
	if(available_box + goal_boxes >= box_goal)
		AddLobPoints(4, "Quota Reward")
		available_box -= box_goal - goal_boxes // Leftover is drained
		goal_reached = TRUE
		priority_announce("The energy production goal has been reached.", "Energy Production", sound='sound/misc/notice2.ogg')
		var/pizzatype_list = subtypesof(/obj/item/food/pizza)
		pizzatype_list -= /obj/item/food/pizza/arnold // No murder pizza
		pizzatype_list -= /obj/item/food/pizza/margherita/robo // No robo pizza
		for(var/mob/living/carbon/human/person in GLOB.mob_living_list)
			// Yes, this delivers to dead bodies. It's REALLY FUNNY.
			var/obj/structure/closet/supplypod/centcompod/pod = new()
			var/pizzatype = pick(pizzatype_list)
			new pizzatype(pod)
			pod.explosionSize = list(0,0,0,0)
			to_chat(person, "<span class='nicegreen'>It's pizza time!</span>")
			new /obj/effect/pod_landingzone(get_turf(person), pod)
		for(var/mob/M in GLOB.player_list)
			if(!M.ckey || !M.client)
				continue
			SSpersistence.agent_rep_change[M.ckey] += 3
	return

/datum/controller/subsystem/lobotomy_corp/proc/QliphothUpdate(amount = 1)
	qliphoth_meter += amount
	if(qliphoth_meter >= qliphoth_max)
		QliphothEvent()

/datum/controller/subsystem/lobotomy_corp/proc/QliphothEvent()
	// Update list of abnormalities that can be affected by meltdown
	if((ZAYIN_LEVEL in qliphoth_meltdown_affected) && ROUNDTIME >= 30 MINUTES)
		qliphoth_meltdown_affected -= ZAYIN_LEVEL
	if((TETH_LEVEL in qliphoth_meltdown_affected) && ROUNDTIME >= 60 MINUTES)
		qliphoth_meltdown_affected -= TETH_LEVEL
	qliphoth_meter = 0
	var/abno_amount = all_abnormality_datums.len
	var/player_count = AvailableAgentCount()
	qliphoth_max = (player_count > 1 ? 4 : 3) + player_count // Some extra help on non solo rounds
	qliphoth_state += 1
	for(var/datum/abnormality/A in all_abnormality_datums)
		if(istype(A.current))
			A.current.OnQliphothEvent()
	var/ran_ordeal = FALSE
	if(qliphoth_state + 1 >= next_ordeal_time) // If ordeal is supposed to happen on the meltdown after that one
		if(istype(next_ordeal) && ordeal_timelock[next_ordeal.level] > ROUNDTIME) // And it's on timelock
			next_ordeal_time += 1 // So it does not appear on the ordeal monitors until timelock is off
	if(qliphoth_state >= next_ordeal_time)
		if(OrdealEvent())
			ran_ordeal = TRUE
	for(var/obj/structure/sign/ordealmonitor/O in GLOB.lobotomy_devices)
		O.update_icon()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_START, ran_ordeal)
	if(ran_ordeal)
		return
	InitiateMeltdown(qliphoth_meltdown_amount, FALSE)
	// Less agents will decrease meltdown count, but more - increase it
	var/agent_mod = 0.4 + (player_count * 0.1)
	qliphoth_meltdown_amount = clamp(round(abno_amount * CONFIG_GET(number/qliphoth_meltdown_percent) * agent_mod), 1, abno_amount * 0.5)

/datum/controller/subsystem/lobotomy_corp/proc/InitiateMeltdown(meltdown_amount = 1, forced = TRUE, type = MELTDOWN_NORMAL, min_time = 60, max_time = 90, alert_text = "Qliphoth meltdown occured in containment zones of the following abnormalities:", alert_sound = 'sound/effects/meltdownAlert.ogg')
	// Honestly, I wish I could do it another way, but oh well
	var/datum/suppression/command/C = GetCoreSuppression(/datum/suppression/command)
	if(istype(C))
		// All abno levels melt
		forced = TRUE
		meltdown_amount += C.meltdown_count_increase
		min_time = round(min_time * C.meltdown_time_multiplier)
		max_time = round(max_time * C.meltdown_time_multiplier)
	var/list/computer_list = list()
	var/list/meltdown_occured = list()
	for(var/obj/machinery/computer/abnormality/cmp in shuffle(GLOB.lobotomy_devices))
		if(!cmp.can_meltdown)
			continue
		if(cmp.meltdown || cmp.datum_reference.working)
			continue
		if(!cmp.datum_reference || !cmp.datum_reference.current)
			continue
		if(!cmp.datum_reference.current.IsContained()) // Does what the old check did, but allows it to be redefined by abnormalities that do so.
			continue
		if(!(cmp.datum_reference.threat_level in qliphoth_meltdown_affected) && !forced)
			continue
		computer_list += cmp
	for(var/i = 1 to meltdown_amount)
		if(!LAZYLEN(computer_list))
			break
		var/obj/machinery/computer/abnormality/computer = pick(computer_list)
		computer_list -= computer
		computer.start_meltdown(type, min_time, max_time)
		meltdown_occured += computer
	if(LAZYLEN(meltdown_occured))
		var/text_info = ""
		for(var/y = 1 to meltdown_occured.len)
			var/obj/machinery/computer/abnormality/computer = meltdown_occured[y]
			text_info += computer.datum_reference.name
			if(y != meltdown_occured.len)
				text_info += ", "
		text_info += "."
		// Announce next ordeal
		if(next_ordeal && (qliphoth_state + 1 >= next_ordeal_time))
			text_info += "\n\n[next_ordeal.name] will trigger on the next meltdown."
		priority_announce("[alert_text] [text_info]", "Qliphoth Meltdown", sound=alert_sound)
		return meltdown_occured

/datum/controller/subsystem/lobotomy_corp/proc/RollOrdeal()
	if(!islist(all_ordeals[next_ordeal_level]) || !LAZYLEN(all_ordeals[next_ordeal_level]))
		return FALSE
	var/list/available_ordeals = list()
	for(var/datum/ordeal/O in all_ordeals[next_ordeal_level])
		if(O.can_run)
			available_ordeals += O
	if(!LAZYLEN(available_ordeals))
		return FALSE
	next_ordeal = pick(available_ordeals)
	all_ordeals[next_ordeal_level] -= next_ordeal
	next_ordeal_time = max(3, qliphoth_state + next_ordeal.delay + (next_ordeal.random_delay ? rand(-1, 1) : 0))
	next_ordeal_level += 1 // Increase difficulty!
	for(var/obj/structure/sign/ordealmonitor/O in GLOB.lobotomy_devices)
		O.update_icon()
	message_admins("Next ordeal to occur will be [next_ordeal.name].")
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent()
	if(!next_ordeal)
		return FALSE
	if(ordeal_timelock[next_ordeal.level] > ROUNDTIME)
		return FALSE // Time lock
	next_ordeal.Run()
	next_ordeal = null
	RollOrdeal()
	return TRUE // Very sloppy, but will do for now

/// Adds LOB points and notifies players via aux consoles
/datum/controller/subsystem/lobotomy_corp/proc/AddLobPoints(amount = 1, message = "UNKNOWN")
	lob_points += amount
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.lobotomy_devices)
		A.audible_message("<span class='notice'>[round(amount, 0.1)] LOB point[amount > 1 ? "s" : ""] deposited! Reason: [message].</span>")
		playsound(get_turf(A), 'sound/machines/twobeep_high.ogg', 20, TRUE)
		A.updateUsrDialog()

/// Checks if all agents are dead with ordeals running. Used for procs below.
/datum/controller/subsystem/lobotomy_corp/proc/OrdealDeathCheck()
	// Might be temporary: Only works on high pop
	if(length(GLOB.clients) <= 30)
		return FALSE
	if(!LAZYLEN(current_ordeals))
		return FALSE
	var/agent_count = AvailableAgentCount()
	if(agent_count > 0)
		return FALSE
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(SSmaptype.maptype in list("standard", "skeld", "fishing", "wonderlabs")))
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(OrdealDeathCheck() && !auto_restart_in_progress)
		OrdealDeathAutoRestart()
	return TRUE

/// Restarts the round when time reaches 0
/datum/controller/subsystem/lobotomy_corp/proc/OrdealDeathAutoRestart(time = 120 SECONDS)
	auto_restart_in_progress = TRUE
	if(!OrdealDeathCheck())
		// Yay
		auto_restart_in_progress = FALSE
		return FALSE
	if(time <= 0)
		message_admins("The round is over because all agents are dead while ordeals are unresolved!")
		to_chat(world, span_danger("<b>The round is over because all agents are dead while ordeals are unresolved!</b>"))
		SSticker.force_ending = TRUE
		return TRUE
	to_chat(world, span_danger("<b>All agents are dead! If ordeals are left unresolved or new agents don't join, the round will automatically end in <u>[round(time/10)] seconds!</u></b>"))
	addtimer(CALLBACK(src, PROC_REF(OrdealDeathAutoRestart), max(0, time - 30 SECONDS)), 30 SECONDS)
	return TRUE
