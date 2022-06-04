// TODO: Do something about it, idk
SUBSYSTEM_DEF(lobotomy_corp)
	name = "Lobotomy Corporation"
	flags = SS_KEEP_TIMING | SS_BACKGROUND | SS_NO_FIRE
	wait = 5 MINUTES

	var/list/all_abnormality_datums = list()
	var/current_box = 0
	var/box_goal = 1
	var/goal_reached = FALSE

/datum/controller/subsystem/lobotomy_corp/Initialize(timeofday)
	box_goal = 100 // TODO: Make it scale with pop
	return ..()

/datum/controller/subsystem/lobotomy_corp/proc/NewAbnormality(datum/abnormality/new_abno)
	if(!istype(new_abno))
		return FALSE
	all_abnormality_datums += new_abno
	return TRUE

/datum/controller/subsystem/lobotomy_corp/proc/AdjustBoxes(amount)
	current_box = clamp((current_box + amount), 0, box_goal)
	if((current_box >= box_goal) && !goal_reached) // Also TODO: Make it do something other than this
		goal_reached = TRUE
		priority_announce("The energy production goal has been reached.", "Energy Production", sound='sound/misc/notice2.ogg')
		return
