//Links to abnormality consoles when the console spawns
/obj/machinery/containment_panel
	name = "containment panel"
	desc = "A device that logs the location of a abnormality cell when it spawns."
	icon = 'ModularTegustation/Teguicons/lc13doorpanels.dmi'
	icon_state = "control"
	density = FALSE
	use_power = 0
	var/obj/machinery/computer/abnormality/linked_console
	var/work
	var/relative_location

/obj/machinery/containment_panel/Initialize()
	. = ..()
	var/turf/closest_department
	for(var/turf/T in GLOB.department_centers)
		if(T.z != z)
			continue
		if(!istype(T.loc, /area/department_main))
			continue
		if(!closest_department)
			closest_department = T
			continue
		if(get_dist(T, src) > get_dist(closest_department, src))
			continue
		closest_department = T
	var/direction = "in an unknown direction"
	var/xdif = closest_department.x - src.x
	var/ydif = closest_department.y - src.y
	if(abs(xdif) > abs(ydif))
		if(xdif < 0)
			direction = "East"
		else
			direction = "West"
	else
		if(ydif < 0)
			direction = "North"
		else
			direction = "South"
	relative_location = "[get_dist(closest_department, src)] meters [direction] from [closest_department.loc.name]."
	icon_state = replacetext("[closest_department.loc.type]", "/area/department_main/", "")

/obj/machinery/containment_panel/proc/console_status(obj/machinery/computer/abnormality/linked_console)
	cut_overlays()
	if(linked_console)
		add_overlay("glow_[icon_state]")
		desc = null

/obj/machinery/containment_panel/proc/console_working()
	cut_overlays()
	desc = "It says that work is in progress."
	if(icon_state == "command")
		add_overlay("glow_[icon_state]_work_in_progress")
		return
	add_overlay("glow_work_in_progress")
	return

/obj/machinery/containment_panel/proc/AbnormalityInfo()
	if(!linked_console)
		return "ERROR"
	return linked_console.datum_reference.name

/obj/machinery/containment_panel/discipline
	icon_state = "discipline"

/obj/machinery/containment_panel/extraction
	icon_state = "extraction"

/obj/machinery/containment_panel/records
	icon_state = "records"

/obj/machinery/containment_panel/welfare
	icon_state = "welfare"

/obj/machinery/containment_panel/training
	icon_state = "training"

/obj/machinery/containment_panel/information
	icon_state = "information"

/obj/machinery/containment_panel/safety
	icon_state = "safety"

/obj/machinery/containment_panel/command
	icon_state = "command"

/obj/machinery/abnormality_monitor
	name = "facility abnormality list"
	desc = "A screen that shows a list of all currently housed abnormalities and their departments."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "monitor1"
	density = FALSE
	use_power = 0
	var/list/abnormalities = list()

/obj/machinery/abnormality_monitor/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, PROC_REF(UpdateNetwork)) //return a list of the abnormalities

/obj/machinery/abnormality_monitor/examine(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/abnormality_monitor/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	dat += "<b>FACILITY INFO:</b><br>"
	for(var/i = 1 to abnormalities.len)
		if(!LAZYLEN(abnormalities))
			dat += "[abnormalities[i]]"
		else
			dat += "[abnormalities[i]]"
		dat += "<br>"
	var/datum/browser/popup = new(user, "containment_diagnostics", "Current Containment", 500, 550)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/abnormality_monitor/proc/UpdateNetwork()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(PingFacilityNetwork))

/obj/machinery/abnormality_monitor/proc/PingFacilityNetwork()
	sleep(20) //2 seconds i think. Delay so that the most recently linked containment panel reads its console.
	LAZYCLEARLIST(abnormalities)
	for(var/obj/machinery/containment_panel/C in GLOB.machines)
		if(C.linked_console)
			LAZYADD(abnormalities, "[C.AbnormalityInfo()]: [C.relative_location]")
	sortList(abnormalities)
