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
	var/blurb_text = pick(
		"Will we finally meet after such a long time..?",
		"You have reached this place after such a long time...",
		"Let your body and mind rest. You must be exhausted...",
		)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2")
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
		DAY46_CORE_SUPPRESSION,
		)

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
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Create our cores
	running_cores += new /datum/suppression/control
	// Less scuffed words in announcements
	var/datum/suppression/information/I = new
	I.gibberish_value_increase = 10
	running_cores += I
	running_cores += new /datum/suppression/safety
	// More stat reductions at the start, but gets reverted over time
	var/datum/suppression/training/T = new
	T.attribute_debuff_count_starting = -60
	T.attribute_debuff_count = 10
	running_cores += T
	// And then start them all
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day47/End(silent = FALSE)
	var/blurb_text = "You will overcome this despair if you just wake up and smell the roses. You still have a chance."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2")
	return ..()

// Day 48 - Central Command, Welfare, Disciplinary
/datum/suppression/combination/keter_day48
	name = DAY48_CORE_SUPPRESSION
	desc = "Effects of core suppressions of Central Command, Welfare and Disciplinary departments \
			will activate for the duration of this test. <br>\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "Effects of Control, Information, Safety and Training core suppressions are now in effect. Ordeals of White have been introduced in the subroutines."
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
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// Create our cores
	// Less scuffed words in announcements
	var/datum/suppression/command/C = new
	C.meltdown_count_increase = 4
	C.meltdown_time_multiplier = 0.5
	C.meltdown_time_reduction = 0.1
	running_cores += C
	// More stat reductions
	var/datum/suppression/welfare/W = new
	running_cores += W
	// TODO: Red mist spawn
	// --------------------
	// And then start them all
	for(var/datum/suppression/S in running_cores)
		S.Run(FALSE, TRUE)

	// As running all previous ones would set them as main core, we need to reset it
	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day48/End(silent = FALSE)
	var/blurb_text = "You will reach tomorrow. You can overcome this regret and atonement."
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2")
	return ..()

// Day 49 - Records and Extraction
/datum/suppression/combination/keter_day49
	name = DAY49_CORE_SUPPRESSION
	desc = "Effects of Records core suppression will be present throughout the entire challenge. <br>\
			The Arbiter will make their appearence after completing the Noon of White.<br>\
			To complete the challenge - you must defeat the Midnight of White - The Claw."
	run_text = "The effects of Records core suppression are now in effect. The Arbiter will return after completing the Noon of White. Ordeals of White have been introduced in the subroutines."
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
	RegisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END, PROC_REF(OnOrdealEnd))
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
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
	// More fucked up chaos
	var/datum/suppression/records/R = new
	R.teleport_interval = 30 SECONDS
	R.teleport_min_distance = 1
	R.teleport_max_distance = 3
	R.teleport_min_mob_count = 0.5
	R.teleport_max_mob_count = 0.8
	running_cores += R
	R.Run(FALSE, TRUE)

	SSlobotomy_corp.core_suppression = src

/datum/suppression/combination/keter_day49/End(silent = FALSE)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ORDEAL_END)
	var/blurb_text = "So you refuse to join me, and instead choose to move toward the unpredictable future?"
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2")
	return ..()

/datum/suppression/combination/keter_day49/proc/OnOrdealEnd(datum/source, datum/ordeal/O)
	SIGNAL_HANDLER
	if(!istype(O, /datum/ordeal/fixers/white_noon))
		return
	// Spawn the arbiter
	addtimer(CALLBACK(src, PROC_REF(SpawnArbiter)), 10 SECONDS)

/datum/suppression/combination/keter_day49/proc/SpawnArbiter()
	// Make records less AIDS
	var/datum/suppression/records/R = GetCoreSuppression(/datum/suppression/records)
	R.teleport_interval = 20 SECONDS
	var/turf/T = pick(GLOB.department_centers)
	sound_to_playing_players_on_level('sound/magic/arbiter/repulse.ogg', 100, zlevel = T.z)
	var/blurb_text = pick(
		"You cannot escape the Head.",
		"If you cannot defeat me, you shall be crushed by the Head and its ruthless Claws yet again.",
		"What do you think you will accomplish on your own, even after breaking out of this prison?",
		)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, blurb_text, 1 SECONDS, "black", "yellow", "left", "CENTER-6,BOTTOM+2")
	var/mob/living/simple_animal/hostile/megafauna/arbiter/A = new(T)
	// A bit nerfed, so you don't suffer like you are in hell, okay?
	A.maxHealth = round(A.maxHealth * 0.6)
	A.health = A.maxHealth
	// While nerfed in health, its attacks are more rapid
	A.spikes_cooldown_time = round(A.spikes_cooldown_time * 0.5)
	A.fairy_cooldown_time = round(A.fairy_cooldown_time * 0.5)
	A.key_cooldown_time = round(A.key_cooldown_time * 0.5)

// Day 50 - Tree of Light
/datum/suppression/combination/keter_day50
	name = DAY50_CORE_SUPPRESSION
	desc = "The facility will experience unusual effects on it, with unknown subset of ordeals present.<br>\
			To complete the challenge - you must defeat the Eclipse of White."
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
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 10 SECONDS, blurb_text, 1 SECONDS, "white", "black", "left", "CENTER-6,BOTTOM+2"), i * 11 SECONDS)
