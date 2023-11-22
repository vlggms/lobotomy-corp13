/// Returns amount of available agents that can work
/proc/AvailableAgentCount()
	. = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client)
			continue
		if(!H.mind)
			continue
		if(H.stat == DEAD)
			continue
		if(!(H.mind.assigned_role in GLOB.security_positions))
			continue
		if(HAS_TRAIT(H, TRAIT_WORK_FORBIDDEN))
			continue
		. += 1
