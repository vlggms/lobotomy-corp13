#define MELTDOWN_NORMAL 1
#define MELTDOWN_GRAY 2
#define MELTDOWN_GOLD 3
#define MELTDOWN_PURPLE 4
#define MELTDOWN_CYAN 5

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
	// Currently running core suppression
	var/datum/suppression/core_suppression = null
	// List of available core suppressions for manager to choose
	var/list/available_core_suppressions = list()
	// State of the core suppression
	var/core_suppression_state = 0
	// Work logs from all abnormalities
	var/list/work_logs = list()

	var/current_box = 0
	var/box_goal = INFINITY // Initialized later
	var/goal_reached = FALSE
	//possession conditions
	var/enable_possession = FALSE

/datum/controller/subsystem/lobotomy_corp/Initialize(timeofday)
	. = ..()
	addtimer(CALLBACK(src, .proc/SetGoal), 5 MINUTES)
	addtimer(CALLBACK(src, .proc/InitializeOrdeals), 60 SECONDS)

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
/datum/controller/subsystem/lobotomy_corp/proc/PickPotentialSuppressions()
	if(istype(core_suppression))
		return
	var/list/cores = subtypesof(/datum/suppression)
	for(var/i = 1 to 2)
		var/core_type = pick(cores)
		available_core_suppressions += core_type
		cores -= core_type
	if(!LAZYLEN(available_core_suppressions))
		return
	for(var/obj/machinery/computer/abnormality_auxiliary/A in GLOB.abnormality_auxiliary_consoles)
		A.audible_message("<span class='notice'>Core Suppressions are now available!</span>")
		playsound(get_turf(A), 'sound/machines/dun_don_alert.ogg', 50, TRUE)
		A.updateUsrDialog()

/datum/controller/subsystem/lobotomy_corp/proc/NewAbnormality(datum/abnormality/new_abno)
	if(!istype(new_abno))
		return FALSE
	all_abnormality_datums += new_abno
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_SPAWN, new_abno)
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/WorkComplete(amount = 0, qliphoth_change = TRUE)
	if(qliphoth_change)
		QliphothUpdate()
	AdjustBoxes(amount)

/datum/controller/subsystem/lobotomy_corp/proc/AdjustBoxes(amount)
	current_box = clamp((current_box + amount), 0, box_goal)
	if((current_box >= box_goal) && !goal_reached) // Also TODO: Make it do something other than this
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
	qliphoth_max = 4 + round(player_count * 0.5)
	qliphoth_state += 1
	for(var/datum/abnormality/A in all_abnormality_datums)
		if(istype(A.current))
			A.current.OnQliphothEvent()
	var/ran_ordeal = FALSE
	if(qliphoth_state + 1 >= next_ordeal_time) // If ordeal is supposed to happen on the meltdown after that one
		if(istype(next_ordeal) && ordeal_timelock[next_ordeal.level] > world.time) // And it's on timelock
			next_ordeal_time += 1 // So it does not appear on the ordeal monitors until timelock is off
	if(qliphoth_state >= next_ordeal_time)
		if(OrdealEvent())
			ran_ordeal = TRUE
	for(var/obj/structure/sign/ordealmonitor/O in GLOB.ordeal_monitors)
		O.update_icon()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MELTDOWN_START, ran_ordeal)
	if(ran_ordeal)
		return
	InitiateMeltdown(qliphoth_meltdown_amount, FALSE)
	qliphoth_meltdown_amount = max(1, round(abno_amount * 0.35))

/datum/controller/subsystem/lobotomy_corp/proc/InitiateMeltdown(meltdown_amount = 1, forced = TRUE, type = MELTDOWN_NORMAL, min_time = 60, max_time = 90, alert_text = "Qliphoth meltdown occured in containment zones of the following abnormalities:", alert_sound = 'sound/effects/meltdownAlert.ogg')
	var/list/computer_list = list()
	var/list/meltdown_occured = list()
	for(var/obj/machinery/computer/abnormality/cmp in shuffle(GLOB.abnormality_consoles))
		if(!cmp.can_meltdown)
			continue
		if(cmp.meltdown || cmp.datum_reference.working)
			continue
		if(!cmp.datum_reference || !cmp.datum_reference.current)
			continue
		if(!(cmp.datum_reference.current.status_flags & GODMODE) || (!cmp.datum_reference.qliphoth_meter && cmp.datum_reference.qliphoth_meter_max))
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
		priority_announce("[alert_text] [text_info].", "Qliphoth Meltdown", sound=alert_sound)
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
	next_ordeal_time = qliphoth_state + (next_ordeal.delay * 2) + rand(1,2)
	next_ordeal_level += 1 // Increase difficulty!
	for(var/obj/structure/sign/ordealmonitor/O in GLOB.ordeal_monitors)
		O.update_icon()
	message_admins("Next ordeal to occur will be [next_ordeal.name].")
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/OrdealEvent()
	if(!next_ordeal)
		return FALSE
	if(ordeal_timelock[next_ordeal.level] > world.time)
		return FALSE // Time lock
	next_ordeal.Run()
	next_ordeal = null
	RollOrdeal()
	return TRUE // Very sloppy, but will do for now
