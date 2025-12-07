/datum/suppression/safety
	name = SAFETY_CORE_SUPPRESSION
	desc = "Regenerators will stop operating normally, all personnel will be healed after each meltdown instead.\n\
			Sleepers and EMAIS will be non-functional.\n\
			Medi-pens will have a chance to malfunction and require a delay on each activation."
	reward_text = "All regenerators will receive a permanent +3 boost to healing power."
	run_text = "The core suppression of Safety department has begun. The regenerators and sleepers will stop operating normally. All personnel will be automatically healed after each meltdown instead."

/datum/suppression/safety/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))
	for(var/obj/machinery/regenerator/R in GLOB.lobotomy_devices)
		R.reset_timer = INFINITY
		R.burst_cooldown = TRUE
		R.modified = TRUE
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat | BROKEN)

/datum/suppression/safety/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/regenerator/R in GLOB.lobotomy_devices) // All regenerators gain permanent buff
		R.reset_timer = 0
		R.regeneration_amount += 3
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat & (~BROKEN))
	return ..()

// On lobotomy_corp meltdown event
/datum/suppression/safety/proc/OnMeltdown(datum/source, ordeal = FALSE)
	// Everyone gets healed
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.ckey)
			continue
		H.adjustBruteLoss(-250)
		H.adjustSanityLoss(-250)
		to_chat(H, "<span class='notice'>You suddenly feel better!</span>")
	return
