/// Returns list of all living agents that can work
/proc/AllLivingAgents()
	. = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions))
			continue
		if(HAS_TRAIT(H, TRAIT_WORK_FORBIDDEN))
			continue
		. += H

/// Returns amount of available agents that can work
/proc/AvailableAgentCount()
	. = 0
	for(var/mob/living/carbon/human/H in AllLivingAgents())
		if(!H.client)
			continue
		if(!H.mind)
			continue
		. += 1

/* Core Suppression helpers */
/// Returns core suppression by path if its effects are active
/proc/GetCoreSuppression(datum/suppression/CS = null)
	return locate(CS) in SSlobotomy_corp.active_core_suppressions

/*
 *	Updates the static data of all given Abnormality Consoles.
 *  Returns the update console or consoles, accepts a console or a list of consoles as an input.
 */
/proc/UpdateAbnoConsole(console)
	if(islist(console))
		. = list()
		for(var/obj/machinery/computer/abnormality/abno_console in console)
			for(var/mob/console_reader in range(1, abno_console))
				abno_console.update_static_data(console_reader, SStgui.get_open_ui(console_reader, abno_console))
			. |= abno_console
		return
	
	if(!istype(console, /obj/machinery/computer/abnormality))
		return FALSE
	
	var/obj/machinery/computer/abnormality/abno_console = console
	for(var/mob/console_reader in range(1, abno_console))
		abno_console.update_static_data(console_reader, SStgui.get_open_ui(console_reader, abno_console))
	return abno_console
