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
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_SPAWN, .proc/UpdateNetwork) //return a list of the abnormalities

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
	INVOKE_ASYNC(src, .proc/PingFacilityNetwork)

/obj/machinery/abnormality_monitor/proc/PingFacilityNetwork()
	sleep(20) //2 seconds i think. Delay so that the most recently linked containment panel reads its console.
	LAZYCLEARLIST(abnormalities)
	for(var/obj/machinery/containment_panel/C in GLOB.machines)
		if(C.linked_console)
			LAZYADD(abnormalities, "[C.AbnormalityInfo()]: [C.relative_location]")
	sortList(abnormalities)

/*------------------\
|Text Adventure Code|
\-------------------/
	Refer to lc13_adventuredatum.dm for the program code.*/
/obj/machinery/text_adventure_console
	name = "adventure console"
	desc = "This computer has a program on it that can decrypt abnormality data."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "nanite_program_hub"
	//Feels weird to make it indestructable but it is a unique machine.
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	density = TRUE
	//Keepin it simple and soft coded.
	var/datum/adventure_layout/adventure_data

//Console with debug text adventure program for testing.
/obj/machinery/text_adventure_console/debug/Initialize()
	. = ..()
	if(!adventure_data)
		adventure_data = new(TRUE)

//Stolen from nanite_program_hub.dm
/obj/machinery/text_adventure_console/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	SSvis_overlays.add_vis_overlay(src, icon, "nanite_program_hub_on", layer, plane)
	SSvis_overlays.add_vis_overlay(src, icon, "nanite_program_hub_on", EMISSIVE_LAYER, EMISSIVE_PLANE)

/obj/machinery/text_adventure_console/ui_interact(mob/user)
	. = ..()
	if(isliving(user))
		playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
	var/dat
	if(!adventure_data)
		adventure_data = new
	dat += adventure_data.Adventure(src, user)
	var/datum/browser/popup = new(user, "Adventure", "AdventureTest", 500, 600)
	popup.set_content(dat)
	popup.open()
	return

//This is where the magic happens with the adventure datum. Choices in the datum are returned and processed here.
/obj/machinery/text_adventure_console/Topic(href, href_list)
	. = ..()
	if(.)
		return .
	if(ishuman(usr))
		usr.set_machine(src)
		add_fingerprint(usr)
		//Setting display menu for the text adventure.
		if(href_list["set_display"])
			var/set_display = text2num(href_list["set_display"])
			if(!(set_display < 1 || set_display > 3) && set_display != adventure_data.display_mode)
				adventure_data.display_mode = set_display
				playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
				updateUsrDialog()
				return TRUE

		//Adventure Mode choice reaction.
		if(href_list["travel"])
			var/travel_num = text2num(href_list["travel"])
			adventure_data.AdventureModeReact(travel_num)
			playsound(get_turf(src), 'sound/machines/terminal_prompt_confirm.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		//Choosing an adventure from the event options.
		if(href_list["adventure"])
			/* There must be a better way of doing this because returning
				A itself just brings the name instead of the instance. -IP */
			var/created_event = text2path(href_list["adventure"])
			adventure_data.GenerateEvent(created_event)
			playsound(get_turf(src), 'sound/machines/uplinkpurchase.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		//Event choices.
		if(href_list["choice"])
			var/reaction = text2num(href_list["choice"])
			//Remotely call event reaction with our choice.
			adventure_data.event_data.EventReact(reaction)
			//Essential for refreshing the UI after completing a event.
			playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		if(href_list["extra_chance"])
			//Remotely call event reaction with our choice.
			adventure_data.event_data.AddChanceReact()
			//Essential for refreshing the UI after completing a event.
			playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE

		//For very niche effects and conditions.
		if(href_list["event_misc"])
			var/reaction = text2num(href_list["event_misc"])
			//Remotely call event reaction with our choice.
			adventure_data.event_data.ChanceCords(reaction)
			//Essential for refreshing the UI after completing a event.
			playsound(get_turf(src), 'sound/machines/pda_button2.ogg', 50, TRUE)
			updateUsrDialog()
			return TRUE
