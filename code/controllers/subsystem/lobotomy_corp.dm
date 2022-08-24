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
							4 = list()
							)
	// At what qliphoth_state next ordeal will happen
	var/next_ordeal_time = 1
	// What ordeal level is being rolled for
	var/next_ordeal_level = 1
	// Minimum time for each ordeal level to occur. If requirement is not met - normal meltdown will occur
	var/list/ordeal_timelock = list(15 MINUTES, 30 MINUTES, 45 MINUTES, 60 MINUTES)
	// Datum of the chosen ordeal. It's stored so manager can know what's about to happen
	var/datum/ordeal/next_ordeal = null

	var/current_box = 0
	var/box_goal = INFINITY // Initialized later
	var/goal_reached = FALSE

/datum/controller/subsystem/lobotomy_corp/Initialize(timeofday)
	. = ..()
	addtimer(CALLBACK(src, .proc/SetGoal), 5 MINUTES)
	addtimer(CALLBACK(src, .proc/InitializeOrdeals), 60 SECONDS)

/datum/controller/subsystem/lobotomy_corp/proc/SetGoal()
	var/player_mod = GLOB.clients.len * 0.1
	box_goal = clamp(round(4000 * player_mod), 3000, 24000)
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/InitializeOrdeals()
	// Build ordeals global list
	for(var/type in subtypesof(/datum/ordeal))
		var/datum/ordeal/O = new type()
		all_ordeals[O.level] += O
	RollOrdeal()
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/NewAbnormality(datum/abnormality/new_abno)
	if(!istype(new_abno))
		return FALSE
	all_abnormality_datums += new_abno
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/WorkComplete(amount)
	QliphothUpdate()
	AdjustBoxes(amount)

/datum/controller/subsystem/lobotomy_corp/proc/AdjustBoxes(amount)
	current_box = clamp((current_box + amount), 0, box_goal)
	if((current_box >= box_goal) && !goal_reached) // Also TODO: Make it do something other than this
		goal_reached = TRUE
		priority_announce("The energy production goal has been reached.", "Energy Production", sound='sound/misc/notice2.ogg')
		return

/datum/controller/subsystem/lobotomy_corp/proc/QliphothUpdate(amount = 1)
	qliphoth_meter += amount
	if(qliphoth_meter >= qliphoth_max)
		QliphothEvent()

/datum/controller/subsystem/lobotomy_corp/proc/QliphothEvent()
	// Update list of abnormalities that can be affected by meltdown
	if((ZAYIN_LEVEL in qliphoth_meltdown_affected) && world.time >= 30 MINUTES)
		qliphoth_meltdown_affected -= ZAYIN_LEVEL
	if((TETH_LEVEL in qliphoth_meltdown_affected) && world.time >= 60 MINUTES)
		qliphoth_meltdown_affected -= TETH_LEVEL
	qliphoth_meter = 0
	var/abno_amount = all_abnormality_datums.len
	var/player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player))
			player_count += 1
	qliphoth_max = 4 + round(abno_amount * 0.25) + round(player_count * 0.3)
	qliphoth_state += 1
	for(var/datum/abnormality/A in all_abnormality_datums)
		if(istype(A.current))
			A.current.OnQliphothEvent()
	if(qliphoth_state >= next_ordeal_time)
		if(OrdealEvent())
			return
	InitiateMeltdown(qliphoth_meltdown_amount, FALSE)
	qliphoth_meltdown_amount = max(1, round(abno_amount * 0.35))

/datum/controller/subsystem/lobotomy_corp/proc/InitiateMeltdown(meltdown_amount = 1, forced = TRUE)
	var/list/computer_list = list()
	var/list/meltdown_occured = list()
	for(var/obj/machinery/computer/abnormality/cmp in shuffle(GLOB.abnormality_consoles))
		if(!cmp.can_meltdown)
			continue
		if(cmp.meltdown || cmp.working)
			continue
		if(!cmp.datum_reference || !cmp.datum_reference.current)
			continue
		if(!(cmp.datum_reference.current.status_flags & GODMODE))
			continue
		if(!(cmp.datum_reference.threat_level in qliphoth_meltdown_affected) && !forced)
			continue
		computer_list += cmp
	for(var/i = 1 to meltdown_amount)
		if(!LAZYLEN(computer_list))
			break
		var/obj/machinery/computer/abnormality/computer = pick(computer_list)
		computer_list -= computer
		computer.start_meltdown()
		meltdown_occured += computer
	if(LAZYLEN(meltdown_occured))
		var/text_info = ""
		for(var/y = 1 to meltdown_occured.len)
			var/obj/machinery/computer/abnormality/computer = meltdown_occured[y]
			text_info += computer.datum_reference.name
			if(y != meltdown_occured.len)
				text_info += ", "
		priority_announce("Qliphoth meltdown occured in containment zones of the following abnormalities: [text_info].", "Qliphoth Meltdown", sound='sound/effects/meltdownAlert.ogg')

/datum/controller/subsystem/lobotomy_corp/proc/RollOrdeal()
	if(!islist(all_ordeals[next_ordeal_level]) || !LAZYLEN(all_ordeals[next_ordeal_level]))
		return FALSE
	next_ordeal = pick(all_ordeals[next_ordeal_level])
	all_ordeals[next_ordeal_level] -= next_ordeal
	next_ordeal_time = qliphoth_state + (next_ordeal_level * 2) + rand(3,6)
	next_ordeal_level += 1 // Increase difficulty!
	message_admins("Next ordeal to occur will be [next_ordeal.name].")
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent()
	if(!next_ordeal)
		return FALSE
	if(ordeal_timelock[next_ordeal_level - 1] > world.time)
		return FALSE // Time lock
	next_ordeal.Run()
	next_ordeal = null
	RollOrdeal()
	return TRUE // Very sloppy, but will do for now
