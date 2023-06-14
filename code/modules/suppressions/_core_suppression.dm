/datum/suppression
	/// This will be displayed as announcement title
	var/name = "Nothing Core Suppression"
	/// This is displayed in auxiliary manager's console when selected
	var/desc = "Normal effects of core suppression will apply. Yell at coders to fix description."
	/// Same as above, but what facility has to do to win
	var/goal_text = "Complete the Midnight of White."
	/// Ditto, but for reward
	var/reward_text = "N/A"
	/// Announcement text. Self-explanatory
	var/run_text = "The core suppression of Nothing department has begun."
	/// Announcement text on the end.
	var/end_text = "The core suppression is over."
	/// Sound to play on announcement, if any
	var/annonce_sound = 'sound/effects/suppression.ogg'
	/// Sound to play on event end, if any
	var/end_sound = null

// Runs the event itself
/datum/suppression/proc/Run(run_white = TRUE)
	priority_announce(run_text, name, sound=annonce_sound)
	SSlobotomy_corp.core_suppression_state = max(SSlobotomy_corp.core_suppression_state, 1) // Started suppression
	if(run_white)
		SSlobotomy_corp.next_ordeal_level = 6 // White dawn
		SSlobotomy_corp.RollOrdeal()
	return

// Ends the event
/datum/suppression/proc/End()
	priority_announce(end_text, name, sound=end_sound)
	SSlobotomy_corp.core_suppression = null
	SSlobotomy_corp.core_suppression_state = max(SSlobotomy_corp.core_suppression_state, 2) // Finished core suppression
	if(GLOB.master_mode == "suppression")
		SSticker.force_ending = 1 // Congratulations! You beat the core suppression!
	qdel(src)
	return
