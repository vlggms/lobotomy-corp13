// A day 46 wannabe - Only triggers white ordeals
/datum/suppression/keter_day46
	name = DAY46_CORE_SUPPRESSION
	desc = "The facility will introduce White Ordeals with 1 meltdown in-between them. <br>\
			After clearing Dawn, Noon and Dusk the agents will have to face off against The Claw."
	goal_text = "Defeat the Midnight of White - The Claw."
	run_text = "The Ordeals of White have been introduced into the facility's subroutines. There will be one meltdown in-between each ordeal."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE

/datum/suppression/keter_day46/Run(run_white = TRUE, silent = FALSE)
	return ..()

/* Combined cores go here */
/datum/suppression/combination
	reward_text = "We will get one step closer to our goal..."
	goal_text = "Defeat the Midnight of White - The Claw."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE
	available = FALSE
	/// List of all cores "inside" of it; On End - ends them, too
	var/list/running_cores = list()
	/// List of core names required for this suppression to be available for selection
	var/list/required_cores = list()

/datum/suppression/combination/New()
	. = ..()
	if(!LAZYLEN(required_cores))
		return
	if(available)
		return

	/// Amount of people online that have met the requirements
	var/clear_count = 0
	/// How many people must meet requirements to enable it
	var/clear_requirement = length(GLOB.player_list) * 0.5
	for(var/mob/M in GLOB.player_list)
		if(!(M.ckey in SSpersistence.cleared_core_suppressions))
			continue
		var/list/diffs = difflist(required_cores, SSpersistence.cleared_core_suppressions[M.ckey])
		if(LAZYLEN(diffs))
			continue
		clear_count += 1

	if(clear_count >= clear_requirement)
		available = TRUE

/datum/suppression/combination/End(silent = FALSE)
	for(var/datum/suppression/S in running_cores)
		S.End(TRUE)
	return ..()

// Day 47 - Control, Information, Safety and Training all combined, while also running white ordeals. HAVE FUN.
/datum/suppression/combination/keter_day47
	name = DAY47_CORE_SUPPRESSION
	desc = "Effects of core suppressions of Control, Information, Safety and Training departments \
			will activate for the duration of this test. <br>\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "Effects of Control, Information, Safety and Training core suppressions are now in effect. Ordeals of White have been introduced in the subroutines."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day47/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Create our cores
	running_cores += new /datum/suppression/control
	// Less scuffed words in announcements
	var/datum/suppression/information/I = new
	I.gibberish_value_increase = 10
	running_cores += I
	running_cores += new /datum/suppression/safety
	// More stat reductions
	var/datum/suppression/training/T = new
	T.attribute_debuff_count_starting = -20
	running_cores += T
	// And then start them all
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)
