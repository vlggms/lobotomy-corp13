// Right now the only core suppression with a proper reward, which is higher spawning stats.
/datum/suppression/training
	name = "Training Core Suppression"
	desc = "All employees will be weakened by an amount equal to a -30 debuff on each attribute for the duration of suppression."
	reward_text = "Employees that survived through the suppression will be awarded with 20 increase and +5 buff to all attributes.\n\
			All Agents that will join post-suppression will start with higher attributes."
	run_text = "The core suppression of Training department has begun. All personnel will be suffering from symptoms of work fatigue."
	/// Mob ref = Current ttribute debuff
	var/list/affected_mobs = list()
	// How much your attributes are debuffed after each ordeal
	var/attribute_debuff_count = -10
	// Used for new arrivals
	var/current_debuff_amount

/datum/suppression/training/Run(run_white = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, .proc/OnJoin)
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnMeltdown)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_all_attribute_bonuses(attribute_debuff_count)
		to_chat(H, "<span class='danger'>You feel weaker...</span>")
		affected_mobs[H] = attribute_debuff_count
		RegisterSignal(H, COMSIG_PARENT_QDELETING, .proc/RemoveFromAffectedMobs)
	current_debuff_amount = attribute_debuff_count

/datum/suppression/training/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)
	for(var/mob/living/carbon/human/H in affected_mobs)
		H.adjust_all_attribute_bonuses(-affected_mobs[H] + 5)
		H.adjust_all_attribute_levels(20) // A tiny reward
		to_chat(H, "<span class='notice'>You feel much better than ever before!</span>")
		UnregisterSignal(H, COMSIG_PARENT_QDELETING)
	affected_mobs = null
	for(var/datum/job/agent/J in SSjob.occupations)
		J.normal_attribute_level += 5 // This allows agents to spawn with 100 in all stats
	return ..()

// When a new employee spawns in
/datum/suppression/training/proc/OnJoin(datum/source, mob/living/L, rank)
	if(!ishuman(L))
		return FALSE
	var/mob/living/carbon/human/H = L
	H.adjust_all_attribute_bonuses(current_debuff_amount) // Suffer
	to_chat(H, "<span class='danger'>You feel weaker...</span>")
	affected_mobs[H] = current_debuff_amount
	RegisterSignal(H, COMSIG_PARENT_QDELETING, .proc/RemoveFromAffectedMobs)
	return TRUE

// Whenever an affected mob gets deleted
/datum/suppression/training/proc/RemoveFromAffectedMobs(mob/M)
	SIGNAL_HANDLER
	affected_mobs -= M

// Update debuff amount with each ordeal
/datum/suppression/training/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(!ordeal)
		return
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjust_all_attribute_bonuses(attribute_debuff_count)
		affected_mobs[H] += attribute_debuff_count
		to_chat(H, "<span class='danger'>You feel weaker...</span>")
	current_debuff_amount += attribute_debuff_count
