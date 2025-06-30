/datum/round_event_control/lc13/break_time
	name = "2 Minute Break"
	typepath = /datum/round_event/break_time
	max_occurrences = 1
	weight = 30	//Very common but you get 1 break.
	earliest_start = 30 MINUTES

/datum/round_event/break_time
	announceWhen = 1
	endWhen = 200

/datum/round_event/break_time/announce()
	priority_announce("Welfare HQ is notifying this facility's Manager that you are on your (optional) 2 minute break. \
	We have notified Extraction HQ to delay the abnormality arrival by the said amount of time. \
	However, Records and Information would like to remind you that certain abnormalities will not respect your break time.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Welfare")

	SSabnormality_queue.next_abno_spawn += 2 MINUTES
	for(var/V in GLOB.player_list)
		var/mob/M = V
		if((M.client.prefs.toggles & SOUND_MIDI) && is_station_level(M.z))
			M.playsound_local(M, 'sound/ambience/aurora_caelus.ogg', 20, FALSE, pressure_affected = FALSE)


/datum/round_event/break_time/end()
	priority_announce("Welfare HQ is notifying this facility's Manager that the allotted 2 minute break has ended.",
	sound = 'sound/misc/notice2.ogg',
	sender_override = "HQ Welfare")
