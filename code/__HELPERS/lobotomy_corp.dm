/// Returns list of all living agents that can work (Also Officers if officercount = TRUE)
/proc/AllLivingAgents(officercount = FALSE)
	. = list()
	var/officer_roles = list("Training Officer","Disciplinary Officer", "Records Officer", "Extraction Officer")
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions) && !(H.mind.assigned_role in officer_roles))
			continue
		if(HAS_TRAIT(H, TRAIT_WORK_FORBIDDEN))
			if(officercount == FALSE || !(H.mind.assigned_role in officer_roles))
				continue
		. += H

/// Returns amount of available agents that can work
/proc/AvailableAgentCount()
	. = 0
	for(var/mob/living/carbon/human/H in AllLivingAgents(FALSE))
		if(!H.client)
			continue
		if(!H.mind)
			continue
		if(!is_station_level(H.z))
			continue
		. += 1

/// Returns true if there's an available agent, officer or ert that can fight
/proc/CheckForFighters()
	. = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!H.mind)
			continue
		if(!(H.mind.assigned_role in GLOB.fighter_positions) && !(H.has_status_effect(/datum/status_effect/chosen)))//Puss buffed guys count
			continue
		if(!H.client)
			continue
		if(H.sanity_lost)
			continue
		if(!is_station_level(H.z))
			continue
		. = TRUE
		break

/* Core Suppression helpers */
/// Returns core suppression by path if its effects are active
/proc/GetCoreSuppression(datum/suppression/CS = null)
	return locate(CS) in SSlobotomy_corp.active_core_suppressions
