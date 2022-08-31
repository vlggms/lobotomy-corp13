// Right now the only core suppression with a proper reward, which is higher spawning stats.
/datum/suppression/training
	name = "Training Core Suppression"
	run_text = "The core suppression of Training department has begun. All personnel will be suffering from symptoms of work fatigue."
	var/list/affected_mobs = list()

/datum/suppression/training/Run(run_white = TRUE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, .proc/OnJoin)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_all_attribute_buffs(-40)
		affected_mobs += H

/datum/suppression/training/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	for(var/mob/living/carbon/human/H in affected_mobs)
		H.adjust_all_attribute_buffs(40)
		H.adjust_all_attribute_levels(20) // A tiny reward
	for(var/datum/job/agent/J in SSjob.occupations)
		J.normal_attribute_level += 5 // This allows agents to spawn with 100 in all stats
	return ..()

// When a new employee spawns in
/datum/suppression/training/proc/OnJoin(datum/source, mob/living/L, rank)
	if(!ishuman(L))
		return FALSE
	var/mob/living/carbon/human/H = L
	H.adjust_all_attribute_buffs(-40) // Suffer
	affected_mobs += H
	return TRUE
