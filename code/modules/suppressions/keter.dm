// A day 46 wannabe - Only triggers white ordeals
/datum/suppression/keter_day46
	name = "<b>Proving Oneself</b>"
	desc = "The facility will introduce White Ordeals with 1 meltdown in-between them. <br>\
			After clearing Dawn, Noon and Dusk the agents will have to face off against The Claw."
	goal_text = "Defeat the Midnight of White - The Claw."
	run_text = "The Ordeals of White have been introduced into the facility's subroutines. There will be one meltdown in-between each ordeal."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE

/datum/suppression/white_ordeals/Run(run_white = TRUE)
	return ..()
