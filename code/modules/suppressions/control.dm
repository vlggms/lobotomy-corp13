/datum/suppression/control
	name = CONTROL_CORE_SUPPRESSION
	desc = "Assignments on the abnormality work consoles will be scrambled each meltdown/ordeal."
	reward_text = "The facility is rewarded with extra 10 LOB points."
	run_text = "The core suppression of Control department has begun. The work assignments will be scrambled each meltdown."

/datum/suppression/control/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))
	OnMeltdown()

/datum/suppression/control/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/computer/abnormality/C in GLOB.lobotomy_devices)
		C.scramble_list = list()
	// Reward!
	SSlobotomy_corp.AddLobPoints(10, "[CONTROL_CORE_SUPPRESSION] completion reward")
	return ..()

// On lobotomy_corp meltdown event
/datum/suppression/control/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	var/list/normal_works = shuffle(list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION))
	var/list/application_scramble_list = list()
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		application_scramble_list[work] = pick(choose_from - work)
		choose_from -= application_scramble_list[work]
	for(var/obj/machinery/computer/abnormality/C in GLOB.lobotomy_devices)
		C.scramble_list = application_scramble_list
