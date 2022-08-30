/datum/suppression
	/// This will be displayed as announcement title
	var/name = "Nothing Core Suppression"
	/// Announcement text. Self-explanatory
	var/run_text = "The core suppression of Nothing department has begun."
	/// Announcement text on the end.
	var/end_text = "The core suppression is over."
	/// Sound to play on announcement, if any
	var/annonce_sound = 'sound/effects/suppression.ogg'
	/// Sound to play on event end, if any
	var/end_sound = null

// Runs the event itself
/datum/suppression/proc/Run()
	RegisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START, .proc/OnMeltdown)
	priority_announce(run_text, name, sound=annonce_sound)
	SSlobotomy_corp.next_ordeal_level = 1
	SSlobotomy_corp.RollOrdeal()
	return

// Ends the event
/datum/suppression/proc/End()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MELTDOWN_START)
	priority_announce(end_text, name, sound=end_sound)
	qdel(src)
	return

// On lobotomy_corp meltdown event
/datum/suppression/proc/OnMeltdown(datum/source, ordeal = FALSE)
	return
