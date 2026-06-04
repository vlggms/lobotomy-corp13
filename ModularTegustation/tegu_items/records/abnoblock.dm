// RO meltdown watch
// Gives by default 5 additional minutes before the next abnormality spawns
/obj/item/records/abnodelay
	name = "records bronze watch"
	desc = "A bronze watch the records officer can use to increase the time it takes for the next abnormality to arrive."
	icon_state = "watch_bronze"
	watch_cooldown_time = 30 MINUTES
	var/next_abno_spawn_offset = 5 MINUTES
	var/upgraded = FALSE

/obj/item/records/abnodelay/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("This watch seems to be upgraded, its cooldown is reduced by 15 minutes.")

/obj/item/records/abnodelay/WatchAction(mob/user)
	to_chat(user, span_notice("You check your watch. You turn back the clock for the next abnormality's arrival."))
	// We grab the SubSystem for abnormality spawning and go to the spawn timer, and add the offset time to it directly.
	SSabnormality_queue.next_abno_spawn += next_abno_spawn_offset
	if(GetFacilityUpgradeValue(UPGRADE_RECORDS_1) && !upgraded)
		watch_cooldown_time /= 2
		upgraded = TRUE
	..()
