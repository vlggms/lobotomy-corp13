//This event exists to mask sephirah rolls.
//It's very rare.
/datum/round_event_control/lc13/sephirah_helpful_roll
	name = "Helpful Abnormality Roll"
	typepath = /datum/round_event/sephirah_helpful_roll
	weight = 2
	max_occurrences = 2
	earliest_start = 20 MINUTES
	alert_observers = FALSE	//Sadly can't. Don't want the RO to know either.

/datum/round_event/sephirah_helpful_roll
	announceWhen = 1

/datum/round_event/sephirah_helpful_roll/start()
	SSabnormality_queue.next_abno_spawn = world.time + SSabnormality_queue.next_abno_spawn_time + ((min(16, SSabnormality_queue.spawned_abnos) - 6) * 6) SECONDS
	SSabnormality_queue.PickAbno()

	//Literally being griefed.
	SSlobotomy_corp.lob_points += 0.25
	minor_announce("Extraction has made an error in which abnormalities your manager was to select. Extraction apologizes profusely, \
			and the actual set of [GetFacilityUpgradeValue(UPGRADE_ABNO_QUEUE_COUNT)] abnormalities has been sent to your manager's console.", "Extraction Alert:", TRUE)
	return
