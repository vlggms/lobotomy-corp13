// Most of its effects are applied elsewhere
/datum/suppression/information
	name = INFORMATION_CORE_SUPPRESSION
	desc = "Assignments on the abnormality work consoles will be in random positions.\n\
			Announcement systems and suit sensors will be negatively impacted."
	reward_text = "Unique PE gained by working on abnormalities is increased by 25%."
	run_text = "The core suppression of Information department has begun. The information and sensors will be distorted for its duration."
	/// Used in Gibberish() proc as third argument in relevant places.
	var/gibberish_value = 10
	/// By how much the value is increased on each ordeal
	var/gibberish_value_increase = 30

/datum/suppression/information/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))

/datum/suppression/information/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	SSlobotomy_corp.box_work_multiplier *= 1.25
	return ..()

// Increase gibberish value every time an ordeal occurs
/datum/suppression/information/proc/OnMeltdown(datum/source, ordeal = FALSE)
	SIGNAL_HANDLER
	if(ordeal)
		gibberish_value = min(80, gibberish_value + gibberish_value_increase)
