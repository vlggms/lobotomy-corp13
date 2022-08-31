/datum/suppression/control
	name = "Control Core Suppression"
	run_text = "The core suppression of Control department has begun. The work assignments will be scrambled each meltdown."

/datum/suppression/control/Run()
	. = ..()
	OnMeltdown()

/datum/suppression/control/OnMeltdown(datum/source, ordeal = FALSE)
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.Scramble()

/datum/suppression/control/End()
	. = ..()
	for(var/obj/machinery/computer/abnormality/C in GLOB.abnormality_consoles)
		C.scramble_list = list()
