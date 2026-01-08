/// Returns list of all living agents that can work (Also Suppression Agents if suppressioncount = TRUE)
/proc/AllLivingAgents(suppressioncount = FALSE)
	. = list()
	var/suppression_roles = list("Combat Research Agent", "Disciplinary Officer")
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions))
			continue
		if(HAS_TRAIT(H, TRAIT_WORK_FORBIDDEN))
			if(suppressioncount == FALSE || !(H.mind.assigned_role in suppression_roles))
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

/// Returns amount of available agents and erts that can fight
/proc/AvailableAgentAndERTCount()
	. = 0
	for(var/mob/living/carbon/human/H in AllLivingAgents(TRUE))
		if(!H.client)
			continue
		if(!H.mind)
			continue
		if(H.sanity_lost)
			continue
		if(!is_station_level(H.z))
			continue
		. += 1
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.ert_positions))
			continue
		if(!H.client)
			continue
		if(!H.mind)
			continue
		if(H.sanity_lost)
			continue
		if(!is_station_level(H.z))
			continue
		. += 1

/* Core Suppression helpers */
/// Returns core suppression by path if its effects are active
/proc/GetCoreSuppression(datum/suppression/CS = null)
	return locate(CS) in SSlobotomy_corp.active_core_suppressions
