/datum/suppression/command
	name = "Central Command Core Suppression"
	desc = "Meltdowns immunities of certain abnormality levels will be forfeit for the duration of the suppression \
			and more meltdowns will occur with lower timer on each. Missed or failed meltdowns will trigger a \
			meltdown on another abnormality within the facility."
	reward_text = "Managerial bullets will activate in a small area around original target. \
			Works performed on a melting cell will net more attributes."
	run_text = "The core suppression of Central Command department has begun. \n\
			Meltdown immunities are forfeit and qliphoth meltdowns will have lesser timer. \n\
			Failed meltdowns will trigger a meltdown in another cell."

	/// Amount of additional abnormalities melting each qliphoth event
	var/meltdown_count_increase = 2
	/// Multiplier to the duration of abnormality meltdowns
	var/meltdown_time_multiplier = 0.9

/datum/suppression/command/Run(run_white = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnQlipMeltdown)
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED, .proc/OnAbnoMeltdown)

/datum/suppression/command/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_FINISHED)
	SSlobotomy_corp.melt_work_multiplier += 1
	SSlobotomy_corp.manager_bullet_area = 1 // Bullets will activate in a 3x3 AOE
	return ..()

/datum/suppression/command/proc/OnQlipMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(ordeal)
		meltdown_count_increase += 1
		meltdown_time_multiplier = max(0.1, meltdown_time_multiplier - 0.2)

/datum/suppression/command/proc/OnAbnoMeltdown(obj/machinery/computer/abnormality/source, melt_removed = TRUE)
	SIGNAL_HANDLER
	if(!istype(source))
		return
	if(melt_removed)
		return
	var/list/potential_consoles = list()
	for(var/obj/machinery/computer/abnormality/A in GLOB.abnormality_consoles)
		if(!A.can_meltdown)
			continue
		if(!A.datum_reference || !A.datum_reference.current)
			continue
		if(A.meltdown || A.datum_reference.working)
			continue
		if(!A.datum_reference.current.IsContained()) // Does what the old check did, but allows it to be redefined by abnormalities that do so.
			continue
		potential_consoles |= A

	if(!LAZYLEN(potential_consoles))
		return
	var/obj/machinery/computer/abnormality/A = pick(potential_consoles)
	source.Beam(A, icon_state = "volt_ray", time = 5 SECONDS)
	playsound(source, 'sound/weapons/zapbang.ogg', 50, TRUE)
	playsound(A, 'sound/weapons/zapbang.ogg', 50, TRUE)
	A.start_meltdown(MELTDOWN_NORMAL, round(40 * meltdown_time_multiplier), round(60 * meltdown_time_multiplier))
