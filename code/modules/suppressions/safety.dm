/datum/suppression/safety
	name = "Safety Core Suppression"
	run_text = "The core suppression of Safety department has begun. The regenerators and sleepers will stop operating normally. Regenerators will resume their work for a short while on each meltdown instead."

/datum/suppression/safety/Run(run_white = TRUE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnMeltdown)
	KillRegenerators()
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat | BROKEN)

/datum/suppression/safety/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/obj/machinery/regenerator/R in GLOB.regenerators) // All regenerators gain permanent buff
		R.icon_state = "smoke1"
		R.reset_timer = 0
		R.regeneration_amount += 3
	for(var/obj/machinery/sleeper/S in GLOB.sleepers)
		S.set_machine_stat(S.machine_stat & (~BROKEN))
	return ..()

/datum/suppression/safety/proc/KillRegenerators()
	for(var/obj/machinery/regenerator/R in GLOB.regenerators)
		R.icon_state = "smoke0"
		R.reset_timer = INFINITY
		R.burst_cooldown = TRUE
		R.modified = TRUE

// On lobotomy_corp meltdown event
/datum/suppression/safety/proc/OnMeltdown(datum/source, ordeal = FALSE)
	for(var/obj/machinery/regenerator/R in GLOB.regenerators)
		R.icon_state = "smoke1"
		R.reset_timer = 0
		R.hp_bonus = 15
		R.sp_bonus = 15
	addtimer(CALLBACK(src, .proc/KillRegenerators), 10 SECONDS)
	return
