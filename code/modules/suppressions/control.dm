/datum/suppression/control
	name = "Control Core Suppression"
	run_text = "The core suppression of Control department has begun. The work assignments will be scrambled each meltdown."

/datum/suppression/control/Run(run_white = TRUE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnMeltdown)
	OnMeltdown()

/datum/suppression/control/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.scramble_list = list()
	return ..()

// On lobotomy_corp meltdown event
/datum/suppression/control/proc/OnMeltdown(datum/source, ordeal = FALSE)
	var/list/normal_works = shuffle(list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION))
	var/list/application_scramble_list = list()
	var/list/choose_from = normal_works.Copy()
	for(var/work in normal_works)
		application_scramble_list[work] = pick(choose_from - work)
		choose_from -= application_scramble_list[work]
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.scramble_list = application_scramble_list
