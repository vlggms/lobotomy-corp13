//This event exists to mask sephirah rolls.
//It's very rare.
/datum/round_event_control/lc13/sephirah_yellow_roll
	name = "Abnormality Roll"
	typepath = /datum/round_event/sephirah_yellow_roll
	weight = 1
	max_occurrences = 2
	earliest_start = 20 MINUTES
	alert_observers = FALSE	//Sadly can't. Don't want the RO to know either.

/datum/round_event/sephirah_yellow_roll
	announceWhen = 1

/datum/round_event/sephirah_yellow_roll/start()
	for(var/obj/machinery/computer/abnormality_queue/Q in GLOB.lobotomy_devices)
		var/mob/living/simple_animal/hostile/abnormality/target_type = SSabnormality_queue.GetRandomPossibleAbnormality()
		if(Q.locked)
			return

		Q.UpdateAnomaly(target_type, "fucked it lets rolled", TRUE)
		SSabnormality_queue.AnnounceLock()
		SSabnormality_queue.ClearChoices()

		//Literally being griefed.
		SSlobotomy_corp.lob_points += 1
		minor_announce("Due to a lack of resources; a random abnormality has been chosen and LOB point has been deposited in your account. \
				Extraction Headquarters apologizes for the inconvenience", "Extraction Alert:", TRUE)
		return
