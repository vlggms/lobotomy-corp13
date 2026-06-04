// Meltdown Extender Watch
// For more documentation and information see code/game/machinery/computer/abnormality_work.dm
/obj/item/records/meltdown_extend
	name = "records wooden watch"
	desc = "A watch made with treated wood. The records officer can use this watch to give additional time to meltdowns of nearby abnormality consoles."
	icon_state = "watch_wood"
	watch_cooldown_time = 5 MINUTES
	var/meltdowntimer_increase = 30

/obj/item/records/meltdown_extend/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("This watch seems to be upgraded, its additional meltdown time is doubled.")

/obj/item/records/meltdown_extend/WatchAction(mob/user)
	var/checks = 0
	watch_cooldown_time = initial(watch_cooldown_time)
	for(var/obj/machinery/computer/abnormality/CA in oview(1))
		if(CA.datum_reference)
			/*
			Checking the following :
			1: If the console can meltdown
			2: If console *is* melting down currently
			3: If the meltdown time is greater then 0
			*/
			if(CA.can_meltdown && CA.meltdown && CA.meltdown_time > 0)
				// The watch itself has the time increase, we grab it and add that (in seconds)
				var/fake_meltdowntimer_increase = meltdowntimer_increase
				if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
					fake_meltdowntimer_increase *= 2
				CA.meltdown_time += fake_meltdowntimer_increase
				to_chat(user, span_warning("You increase the time left untill a meltdown to: [CA.meltdown_time] on [CA.datum_reference.name]'s console."))
				checks++
			else
				to_chat(user, span_warning("This abnormality is not in a meltdown."))

	if(checks > 0)
		watch_cooldown_time = watch_cooldown_time * checks // we'll reset the time at the beginning of thus proc
		..()
	else
		to_chat(user, span_warning("Their is no vaild close by console for the watch to use its affects."))
