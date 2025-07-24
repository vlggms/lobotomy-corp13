//Golden Watch
//Casts Timestop for 11 seconds (jojoke)
//Making everything that passes into the area freeze in place untill the 10 seconds are up.
/obj/item/records/timestop
	name = "records golden watch"
	desc = "A golden watch the records officer can use to stop time temporarily."
	icon_state = "watch_gold"

/obj/item/records/timestop/examine(mob/user)
	. = ..()
	if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
		. += span_notice("This watch seems to be upgraded, its cooldown is reduced by 5 minutes.")

/obj/item/records/timestop/watch_action(mob/user)
	//First we spawn a timestop affect, freezing the area around are user, for 10 seconds
	new /obj/effect/timestop(get_turf(user), 3, 110, list(user))
	if(records_cooldown_timer)
		var cooldown = records_cooldown_timer
		if (GetFacilityUpgradeValue(UPGRADE_RECORDS_1))
			cooldown /= 2
		addtimer(CALLBACK(src, PROC_REF(reset)), cooldown)
		usable = FALSE

