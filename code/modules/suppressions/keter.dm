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

/datum/suppression/keter_day46/Run(run_white = TRUE)
	return ..()

/* Combined cores go here */
/datum/suppression/combination
	reward_text = "We will get one step closer to our goal..."
	goal_text = "Defeat the Midnight of White - The Claw."
	after_midnight = TRUE
	available = FALSE
	/// Starts out as list of core suppression types; On creation, replaced with new datums of said types
	var/list/running_cores = list()

// Day 47 - Control, Information, Safety and Training all combined, while also running white ordeals. HAVE FUN.
/datum/suppression/keter_day47
	name = DAY47_CORE_SUPPRESSION
	desc = "The facility will introduce White Ordeals with 1 meltdown in-between them. <br>\
			After clearing Dawn, Noon and Dusk the agents will have to face off against The Claw."
	run_text = "The Ordeals of White have been introduced into the facility's subroutines. There will be one meltdown in-between each ordeal."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
