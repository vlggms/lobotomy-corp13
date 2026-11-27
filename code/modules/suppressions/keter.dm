// A day 46 wannabe - Only triggers white ordeals
/datum/suppression/keter_day46
	name = DAY46_CORE_SUPPRESSION
	desc = "The facility will introduce White Ordeals with 1 meltdown in-between them.\n\
			After clearing Dawn, Noon and Dusk the agents will have to face off against The Claw."
	goal_text = "Defeat the Midnight of White - The Claw."
	run_text = "The Ordeals of White have been introduced into the facility's subroutines. There will be one meltdown in-between each ordeal."
	reward_text = "We will get one step closer to our goal..."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE
	special_core = TRUE

/datum/suppression/keter_day46/Run(run_white = TRUE, silent = FALSE)
	var/blurb_text = pick(
		"Will we finally meet after such a long time..?",
		"You have reached this place after such a long time...",
		"Let your body and mind rest. You must be exhausted...",
		)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

/* Combined cores go here */
/datum/suppression/combination
	reward_text = "We will get one step closer to our goal..."
	goal_text = "Defeat the Midnight of White - The Claw."
	annonce_sound = 'sound/effects/combat_suppression_start.ogg'
	end_sound = 'sound/effects/combat_suppression_end.ogg'
	after_midnight = TRUE
	available = FALSE
	special_core = TRUE
	/// List of all cores "inside" of it; On End - ends them, too
	var/list/running_cores = list()
	/// List of core names required for this suppression to be available for selection
	var/list/required_cores = list()
	var/current_melt = 0

/datum/suppression/combination/New()
	. = ..()
	if(!LAZYLEN(required_cores))
		return
	if(available)
		return

	var/list/all_agents = AllLivingAgents()
	/// Amount of people online that have met the requirements
	var/clear_count = 0
	/// How many people must meet requirements to enable it
	var/clear_requirement = length(all_agents) * 0.5
	for(var/mob/M in all_agents)
		if(!(M.ckey in SSpersistence.cleared_core_suppressions))
			continue
		var/list/diffs = difflist(required_cores, SSpersistence.cleared_core_suppressions[M.ckey])
		if(LAZYLEN(diffs))
			continue
		clear_count += 1

	if(clear_count >= clear_requirement)
		available = TRUE

/datum/suppression/combination/Run(run_white = FALSE, silent = FALSE)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, PROC_REF(OnMeltdown))

/datum/suppression/combination/proc/OnMeltdown(datum/source, ordeal = FALSE)
	if(ordeal)
		current_melt ++

/datum/suppression/combination/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	for(var/datum/suppression/S in running_cores)
		S.End(TRUE)
	return ..()

// Day 47 - Control, Information, Safety and Training all combined, while also running white ordeals. HAVE FUN.
/datum/suppression/combination/keter_day47
	name = DAY47_CORE_SUPPRESSION
	desc = "Effects of core suppressions of Control, Information, Safety and Training departments \
			will activate one by one throughout the duration of this test.\n\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "The effects of the Control core suppression are now in effect. Ordeals of White have been introduced in the subroutines."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		)
	var/off_beat_melt = FALSE

/datum/suppression/combination/keter_day47/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"It seems you have decided to move forward...",
		"Your body and mind are weathered. Where does your confidence come from?",
		"How do we expect to move forward when we cannot even stand up straight?",
		"It is best for everyone if we just turn back to the first act now.",
		"Who knows, our unforgivable sin may lighten just a tiny bit if you do.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Starts Control
	var/datum/suppression/control/C = new
	running_cores += C
	C.Run(FALSE, TRUE)
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day47/OnMeltdown(datum/source, ordeal = FALSE)
	. = ..()
	switch(current_melt)
		if(1) //Dawn
			priority_announce("The effects of the Info core suppression are now in effect.", name, sound='sound/machines/dun_don_alert.ogg')
			// Less scuffed words in announcements
			var/datum/suppression/information/I = new
			I.gibberish_value = 40
			I.gibberish_value_increase = 0
			running_cores += I
			I.Run(FALSE, TRUE)
		if(2) //Noon
			priority_announce("The effects of the Training core suppression are now in effect.", name, sound='sound/machines/dun_don_alert.ogg')
			// Training Activates
			var/datum/suppression/training/T = new
			T.attribute_debuff_count_starting = -25
			T.attribute_debuff_count = 0
			running_cores += T
			T.Run(FALSE, TRUE)
		if(3) //Dusk with ho healing is a tad much
			if(off_beat_melt)
				off_beat_melt = FALSE
				priority_announce("The effects of the Safety core suppression are now in effect.", name, sound='sound/machines/dun_don_alert.ogg')
				var/datum/suppression/safety/S = new
				running_cores += S
				S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day47/End(silent = FALSE)
	var/blurb_text = "You will overcome this despair if you just wake up and smell the roses. You still have a chance."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

// Day 48 - Central Command, Welfare, Disciplinary
/datum/suppression/combination/keter_day48
	name = DAY48_CORE_SUPPRESSION
	desc = "Effects of core suppressions of Central Command and Welfare departments \
			will activate for the duration of this test.\n\
			The Red Mist will make her appearence on the meltdown after the Noon of White.\n\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "Effects of Center Commandand and Welfare core suppressions are now in effect. The Red Mist will return the meltdown after the Noon of White. Ordeals of White have been introduced in the subroutines.."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day48/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"Do you remember when we still knew the warmth of the sun?",
		"We have become too cold for such a thing.",
		"Were we really only pretending when we were reluctant about countless deaths?",
		"We were wrong from the start. What is left for us is atonement",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Create our cores
	var/datum/suppression/command/C = new
	C.meltdown_count_increase = 2
	C.meltdown_time_multiplier = 0.8
	C.meltdown_time_reduction = 0.1 // Maybe having meldowns happening 5x faster while having Welfare jacking up damage taken wouldn't be a good idea
	running_cores += C
	// Some damage types hurt more
	var/datum/suppression/welfare/W = new
	//Scales much less or else it and Central combined would be unbeatable after dusk
	W.damage_mod = 1.5
	W.mod_increase = 0.25 //Scales up to 2x
	W.mod_count = 2
	//Scales up to 4 types later on
	W.selection_increase = 0
	running_cores += W
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day48/OnMeltdown(datum/source, ordeal = FALSE)
	. = ..()
	if(current_melt == 2) //Noon
		SSlobotomy_corp.is_boss_ready = TRUE
	if(SSlobotomy_corp.is_boss_ready)
		SSlobotomy_corp.is_boss_ready = FALSE
		var/datum/suppression/welfare/W = GetCoreSuppression(/datum/suppression/welfare)
		W.mod_count = 0//Just like in base LC, Welfare gets disabled during the red mist refight
		W.selection_limit = 4//You can't pray for it not hitting red for claw!
		W.selection_increase = 2//Needed to bounce back the scaling after setting it to 0
		W.OnMeltdown()
		priority_announce("[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown.", "Qliphoth Meltdown", sound='sound/effects/meltdownAlert.ogg')
		/*var/turf/T = pick(GLOB.department_centers)
		var/mob/living/simple_animal/hostile/megafauna/red_mist/RM = new(T)
		// A bit nerfed, like in lob corp
		RM.maxHealth = round(RM.maxHealth * 0.6)
		RM.health = RM.maxHealth*/

/datum/suppression/combination/keter_day48/End(silent = FALSE)
	var/blurb_text = "You will reach tomorrow. You can overcome this regret and atonement."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

// Day 49 - Records and Extraction
/datum/suppression/combination/keter_day49
	name = DAY49_CORE_SUPPRESSION
	desc = "Effects of Records core suppression will be present throughout the entire challenge.\n\
			The Arbiter will make their appearence on the meltdown after the Noon Noon of White.\n\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "The effects of Records core suppression are now in effect. The Arbiter will return the meltdown after the Noon of White. Ordeals of White have been introduced in the subroutines."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		RECORDS_CORE_SUPPRESSION,
		EXTRACTION_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		DAY48_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day49/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"You won't believe how long I have been painstakingly waiting for you.",
		"The wait was getting so, so boring.",
		"Nothing is as boring as watching a predetermined fall.",
		"Yes, we could see the truth.",
		"The Abnormalities are no longer abnormal; They are no mere fantasies anymore.",
		"They are our truer forms.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// More fucked up chaos
	var/datum/suppression/records/R = new
	// Make records less AIDS
	R.abno_swap_percentage = 5
	R.teleport_min_distance = 1
	R.teleport_max_distance = 2

	R.abno_swap_scale = 10
	R.teleport_interval_scale = 5 SECONDS
	R.teleport_min_distance_scale = 1
	R.teleport_max_distance_scale = 1
	R.teleport_min_mob_scale = 0.1
	R.teleport_max_mob_scale = 0.1
	running_cores += R
	R.Run(FALSE, TRUE)

	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day49/OnMeltdown(datum/source, ordeal = FALSE)
	. = ..()
	if(current_melt == 2) //Noon
		SSlobotomy_corp.is_boss_ready = TRUE
	if(SSlobotomy_corp.is_boss_ready)
		SSlobotomy_corp.is_boss_ready = FALSE
		var/turf/T = pick(GLOB.department_centers)
		sound_to_playing_players_on_level('sound/magic/arbiter/repulse.ogg', 100, zlevel = T.z)
		var/blurb_text = pick(
			"You cannot escape the Head.",
			"If you cannot defeat me, you shall be crushed by the Head and its ruthless Claws yet again.",
			"What do you think you will accomplish on your own, even after breaking out of this prison?",
			)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, blurb_text, 1 SECONDS, "black", "yellow", "center", "CENTER-6,BOTTOM+2")
		var/mob/living/simple_animal/hostile/megafauna/arbiter/A = new(T)
		// A bit nerfed, so you don't suffer like you are in hell, okay?
		A.maxHealth = round(A.maxHealth * 0.6)
		A.health = A.maxHealth
		priority_announce("[SSlobotomy_corp.next_ordeal.name] will trigger on the next meltdown.", "Qliphoth Meltdown", sound='sound/effects/meltdownAlert.ogg')

/datum/suppression/combination/keter_day49/End(silent = FALSE)
	var/blurb_text = "So you refuse to join me, and instead choose to move toward the unpredictable future?"
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2")
	return ..()

//I have no idea what to do with this core?
// Day 50 - Tree of Light
/*/datum/suppression/combination/keter_day50
	name = DAY50_CORE_SUPPRESSION
	desc = "The facility will experience unusual effects on it, with unknown subset of ordeals present.\n\
			To complete the challenge - you must defeat..."
	run_text = "The final day on your job has come."
	required_cores = list(
		CONTROL_CORE_SUPPRESSION,
		INFORMATION_CORE_SUPPRESSION,
		SAFETY_CORE_SUPPRESSION,
		TRAINING_CORE_SUPPRESSION,
		COMMAND_CORE_SUPPRESSION,
		WELFARE_CORE_SUPPRESSION,
		DISCIPLINARY_CORE_SUPPRESSION,
		RECORDS_CORE_SUPPRESSION,
		EXTRACTION_CORE_SUPPRESSION,
		DAY46_CORE_SUPPRESSION,
		DAY47_CORE_SUPPRESSION,
		DAY48_CORE_SUPPRESSION,
		DAY49_CORE_SUPPRESSION,
		)

/datum/suppression/combination/keter_day50/Run(run_white = TRUE, silent = FALSE)
	. = ..()
	// Ominous blurbs
	var/list/blurb_list = list(
		"We finally meet here today.",
		"You must have realized that as well, seeing as you have made it to this point without hesitation.",
		"I had known... For a very long time...",
		"That we all lost our hearts.",
		"As you can see, we’ve become just like the other Wings, committing atrocities just like them.",
		"The employees here have repeated hundreds upon thousands of deaths...",
		"This sin shall never be forgiven.",
		"Nonetheless... We must finish this.",
		"This will be our final day at work.",
		)
	for(var/i = 1 to length(blurb_list))
		var/blurb_text = blurb_list[i]
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "center", "CENTER-6,BOTTOM+2"), i * 11 SECONDS) */
