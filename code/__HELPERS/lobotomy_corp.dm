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
